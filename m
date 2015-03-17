From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 5/5] target-arm: cpu.h document why env->spsr exists
Date: Tue, 17 Mar 2015 15:50:37 +0000
Message-ID: <CAFEAcA97OF2rMPNew8kiJrWBC+f=70c=G-pAC5tiYnEx6r6AYA@mail.gmail.com>
References: <1426503716-13931-1-git-send-email-alex.bennee@linaro.org>
 <1426503716-13931-6-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABAD048F49
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 11:44:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FpLiwVD9SCq5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Mar 2015 11:44:21 -0400 (EDT)
Received: from mail-ie0-f170.google.com (mail-ie0-f170.google.com
 [209.85.223.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E0BF48F40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 11:44:20 -0400 (EDT)
Received: by iecsl2 with SMTP id sl2so13727130iec.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 08:50:57 -0700 (PDT)
In-Reply-To: <1426503716-13931-6-git-send-email-alex.bennee@linaro.org>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMTYgTWFyY2ggMjAxNSBhdCAxMTowMSwgQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5h
cm8ub3JnPiB3cm90ZToKPiBJIHdhcyBnZXR0aW5nIHZlcnkgY29uZnVzZWQgYWJvdXQgdGhlIGR1
cGxpY2F0aW9uIG9mIHN0YXRlIHNvIHdhbnRlZCB0bwo+IG1ha2UgaXQgZXhwbGljaXQuCj4KPiBT
aWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+Cj4KPiBk
aWZmIC0tZ2l0IGEvdGFyZ2V0LWFybS9jcHUuaCBiL3RhcmdldC1hcm0vY3B1LmgKPiBpbmRleCAw
ODMyMTFjLi42ZGMxNzk5IDEwMDY0NAo+IC0tLSBhL3RhcmdldC1hcm0vY3B1LmgKPiArKysgYi90
YXJnZXQtYXJtL2NwdS5oCj4gQEAgLTE1NSw2ICsxNTUsMTEgQEAgdHlwZWRlZiBzdHJ1Y3QgQ1BV
QVJNU3RhdGUgewo+ICAgICAgICAgVGhpcyBjb250YWlucyBhbGwgdGhlIG90aGVyIGJpdHMuICBV
c2UgY3Bzcl97cmVhZCx3cml0ZX0gdG8gYWNjZXNzCj4gICAgICAgICB0aGUgd2hvbGUgQ1BTUi4g
ICovCj4gICAgICB1aW50MzJfdCB1bmNhY2hlZF9jcHNyOwo+ICsgICAgLyogVGhlIHNwc3IgaXMg
YSBhbGlhcyBmb3Igc3Bzcl9lbE4gd2hlcmUgTiBpcyB0aGUgY3VycmVudAo+ICsgICAgICogZXhj
ZXB0aW9uIGxldmVsLgoKSSBjb3VsZCBoYXZlIHN3b3JuIEknZCBjb21tZW50ZWQgYWJvdXQgdGhp
cyBpbiBhbiBlYXJsaWVyCnZlcnNpb24uIEl0J3Mgbm90IGFuIGFsaWFzIGZvciBzcHNyX2VsTiwg
YmVjYXVzZSBvbiBBQXJjaDMyIHRoZXJlIGFyZQptdWx0aXBsZSBTUFNScyBhdCBFTDE7IGl0IGlz
IHRoZSBjdXJyZW50IFNQU1IsIGFuZAp0aGUgU1BTUnMgZm9yIG90aGVyIG1vZGVzIGFyZSBzdG9y
ZWQgaW4gYmFua2VkX3Nwc3JbXS4KCiAgICAvKiBTUFNSIGZvciBjdXJyZW50IG1vZGUuICovCgp3
b3VsZCBkbyBJTUhPIChtYXRjaGluZyB0aGUgY29tbWVudCBmb3IgZW52LT5yZWdzW10uKQoKLS0g
UE1NCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
