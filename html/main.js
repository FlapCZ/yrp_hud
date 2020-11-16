let isShowed = false

$(function () {
	window.addEventListener('message', function (event) {
		switch (event.data.action) {
			case 'YRPjob':
				$('.job-text').text(event.data.data)
				break
			case 'YRPjobGrade':
				$('.grade-text').text(event.data.data)
				break
			case 'YRPcharacterName':
				$('.char-name-text').text(event.data.charactername)
				break
			case 'YRPstatus':
				$(".test").css("display", event.data.status? "none":"block");
				$("#health").text(event.data.health + "%");
				$("#armor").text(event.data.armor + "%");
				$("#hunger").text(Math.floor((1 + event.data.hunger)) + "%");
				$("#thirst").text(Math.floor((1 + event.data.thirst)) + "%");
				break
			case 'YRPmoney':
				$('#cash').text('$ ' + event.data.cash)
				$('#frakcnikasa').text(event.data.frakcnikasa)
				$('#bank').text('$ ' + event.data.bank)
				if (typeof event.data.black_money !== 'undefined') {
					$('#black_money_item').show()
					$('#black_money').text('$ ' + event.data.black_money)
				} else {
					$('#black_money_item').fadeOut()
				}
				if (typeof event.data.society !== 'undefined') {
					$('#society_item').fadeIn()
					$('#society').text('$ ' + event.data.society)
				} else {
					$('#society_item').hide()
				}
				break
			case 'YRPslide':
				if (!isShowed) {
					isShowed = true
					$('.container').animate({
						left: "-=21%"
					}, 600, () => {
						setTimeout(() => {
							$('.container').animate({
								left: "+=21%"
							}, 600)
							isShowed = false
						}, 6000);
					})
				}
				break
			case 'YRPpausemenu':
				event.data.data ? $('body').fadeOut(300) : $('body').fadeIn(1000)
				break
		}
	})
})