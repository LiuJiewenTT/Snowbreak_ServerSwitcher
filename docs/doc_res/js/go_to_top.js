// Go to Top功能实现
$(document).ready(function() {
    // 显示/隐藏按钮
    $(window).scroll(function() {
        if ($(this).scrollTop() > 200) {
            $('.go-to-top').fadeIn();
        } else {
            $('.go-to-top').fadeOut();
        }
    });
    
    // 平滑滚动到顶部
    $('.go-to-top').click(function() {
        $('html, body').animate({scrollTop: 0}, 300);
        return false;
    });
});
