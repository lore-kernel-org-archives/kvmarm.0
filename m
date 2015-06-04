From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 2/6] target-arm: kvm64: introduce kvm_arm_init_debug()
Date: Thu, 4 Jun 2015 11:56:54 +0100
Message-ID: <CAFEAcA8GBDF1=ju9N6uuOK+pFxZ5sJxm0mwBV+OrY3R8YUhJkg@mail.gmail.com>
References: <1432912764-7073-1-git-send-email-alex.bennee@linaro.org>
 <1432912764-7073-3-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0997052EFC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2015 06:47:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EkzgEGsk5FM9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2015 06:47:12 -0400 (EDT)
Received: from mail-ig0-f170.google.com (mail-ig0-f170.google.com
 [209.85.213.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05B7652F15
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2015 06:47:11 -0400 (EDT)
Received: by igbsb11 with SMTP id sb11so36490857igb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Jun 2015 03:57:14 -0700 (PDT)
In-Reply-To: <1432912764-7073-3-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, Zhichao Huang <zhichao.huang@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjkgTWF5IDIwMTUgYXQgMTY6MTksIEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4gd3JvdGU6Cj4gQXMgd2UgaGF2ZW4ndCBhbHdheXMgaGFkIGd1ZXN0IGRlYnVnIHN1cHBv
cnQgd2UgbmVlZCB0byBwcm9iZSBmb3IgaXQuCj4gQWRkaXRpb25hbGx5IHdlIGRvbid0IGRvIHRo
aXMgaW4gdGhlIHN0YXJ0LXVwIGNhcGFiaWxpdHkgY29kZSBzbyB3ZQo+IGRvbid0IGZhbGwgb3Zl
ciBvbiBvbGQga2VybmVscy4KPgo+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5i
ZW5uZWVAbGluYXJvLm9yZz4KPiAtLS0KClJldmlld2VkLWJ5OiBQZXRlciBNYXlkZWxsIDxwZXRl
ci5tYXlkZWxsQGxpbmFyby5vcmc+Cgp0aGFua3MKLS0gUE1NCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
