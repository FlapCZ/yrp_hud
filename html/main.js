let yrp_hud_showed = false

$(function () {
	window.addEventListener('message', function (event) {
		switch (event.data.action) {
			case 'YRPhudSlide':
				if (!yrp_hud_showed) {
					yrp_hud_showed = true
					$('.container').animate({
						top: "+=40%"
					}, 600, () => {
						setTimeout(() => {
							$('.container').animate({
								top: "-=40%"
							}, 600)
							yrp_hud_showed = false
						}, 6000);
					})
				}
				break
			case 'YRPhudJob':
				$('.yrp_hud-job-label').text(event.data.data)
				break
			case 'YRPhudGrade':
				$('.yrp_hud-grade-label').text(event.data.data)
				break
			case 'YRPhudChar':
				$('.yrp_hud-character-name').text(event.data.charactername)
				break
			case 'YRPhudMoney':
				$('#yrp_hud-cash').text('$ ' + event.data.cash)
				$('#yrp_hud-job-cash').text(event.data.frakcnikasa)
				$('#yrp_hud-bank').text('$ ' + event.data.bank)
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
			case 'yrp_hud-disable-hud':
				event.data.data ? $('body').fadeOut(300) : $('body').fadeIn(1000)
				break
		}
	})
})