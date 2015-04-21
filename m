From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 3/4] target-arm: kvm - support for single step
Date: Tue, 21 Apr 2015 14:01:50 +0100
Message-ID: <CAFEAcA_odo0qmtowmAvEvjBA2RgNbZZKk=WpyfN2UdEccgT1Eg@mail.gmail.com>
References: <1427816446-31586-1-git-send-email-alex.bennee@linaro.org>
 <1427816446-31586-4-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA_dqx-78AoGiHViv_tMCDkSd7Uf2GpUz+uBm5QbgX0nvg@mail.gmail.com>
 <87tww9vdv6.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B746C4D36D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2015 08:54:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pSO2+FAJ6t2H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Apr 2015 08:54:02 -0400 (EDT)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com
 [209.85.223.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCCEA4D2D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2015 08:54:02 -0400 (EDT)
Received: by iedfl3 with SMTP id fl3so14397127ied.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2015 06:02:10 -0700 (PDT)
In-Reply-To: <87tww9vdv6.fsf@linaro.org>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, Zhichao Huang <zhichao.huang@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjEgQXByaWwgMjAxNSBhdCAxMzo1NiwgQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5h
cm8ub3JnPiB3cm90ZToKPgo+IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9y
Zz4gd3JpdGVzOgo+Pj4gICAgICBzd2l0Y2ggKGhzcl9lYykgewo+Pj4gKyAgICBjYXNlIEhTUl9F
Q19TT0ZUX1NURVA6Cj4+PiArICAgICAgICBpZiAoY3MtPnNpbmdsZXN0ZXBfZW5hYmxlZCkgewo+
Pj4gKyAgICAgICAgICAgIHJldHVybiB0cnVlOwo+Pj4gKyAgICAgICAgfSBlbHNlIHsKPj4+ICsg
ICAgICAgICAgICBlcnJvcl9yZXBvcnQoIkNhbWUgb3V0IG9mIFNJTkdMRSBTVEVQIHdoZW4gbm90
IGVuYWJsZWQiKTsKPj4KPj4gVGhpcyBjYW4gb25seSBoYXBwZW4gaWYgdGhlcmUncyBhIGtlcm5l
bCBidWcsIHJpZ2h0Pwo+Cj4gU3VyZS4gU2hvdWxkIHdlIHJlcG9ydCBpdCBkaWZmZXJlbnRseT8g
YWJvcnQoKSBvdXQ/CgpTYXlpbmcgJ1RoaXMgd291bGQgYmUgYSBrZXJuZWwgYnVnJyBpbiBhIGNv
bW1lbnQgd291bGQgZG8uLi4KCi0tIFBNTQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
