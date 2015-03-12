From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 3/6] hw/char: pl011 don't keep setting the IRQ if
 nothing changed
Date: Thu, 12 Mar 2015 20:27:20 +0000
Message-ID: <CAFEAcA-UOfgxBA969U6ADdra75fxYQPi6JFe017J6-oMG1rGhg@mail.gmail.com>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
 <1425479753-18349-4-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA-RhZVe1qwKQ3LzfWbzYVcBQ-jrwTnhH0OX69GNtnoysw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5475A48B9F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 16:21:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PvU+yzSWEviX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2015 16:21:18 -0400 (EDT)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
 [209.85.217.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 131B348B9E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 16:21:17 -0400 (EDT)
Received: by lbdu14 with SMTP id u14so18660027lbd.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2015 13:27:40 -0700 (PDT)
In-Reply-To: <CAFEAcA-RhZVe1qwKQ3LzfWbzYVcBQ-jrwTnhH0OX69GNtnoysw@mail.gmail.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMTIgTWFyY2ggMjAxNSBhdCAxNTo1MSwgUGV0ZXIgTWF5ZGVsbCA8cGV0ZXIubWF5ZGVsbEBs
aW5hcm8ub3JnPiB3cm90ZToKPiBPbiA0IE1hcmNoIDIwMTUgYXQgMTQ6MzUsIEFsZXggQmVubsOp
ZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4gd3JvdGU6Cj4+IFdoaWxlIG9ic2VydmluZyBLVk0g
dHJhY2VzIEkgY2FuIHNlZSBhZGRpdGlvbmFsIElSUSBjYWxscyBvbiBwcmV0dHkgbXVjaAo+PiBl
dmVyeSBNTUlPIGFjY2VzcyB3aGljaCBpcyBqdXN0IHBsYWluIGluZWZmaWNpZW50LiBPbmx5IHVw
ZGF0ZSB0aGUgUUVNVQo+PiBJUlEgbGV2ZWwgaWYgc29tZXRoaW5nIGhhcyBhY3R1YWxseSBjaGFu
Z2VkIGZyb20gbGFzdCB0aW1lLiBPdGhlcndpc2Ugd2UKPj4gbWF5IGJlIHBhcGVyaW5nIG92ZXIg
b3RoZXIgZmFpbHVyZSBtb2Rlcy4KCj4gQ29uc2lkZXIgdGhpcyBzZXF1ZW5jZSBvZiBldmVudHM6
CgpJbmNpZGVudGFsbHksIHRoZSBjb2RlIHJldmlldyBydWxlIG9mIHRodW1iIHRoYXQgbGVkIG1l
IHRvCmNvbnN0cnVjdCB0aGF0IHNjZW5hcmlvIGlzOgogKiBzdGF0ZSBpbnNpZGUgdGhlIGRldmlj
ZSBzdHJ1Y3Qgd2hpY2ggZG9lc24ndCBjb3JyZXNwb25kCiAgIHRvIHJlYWwgaGFyZHdhcmUgc3Rh
dGUgaXMgc3VzcGljaW91cwogKiBzdGF0ZSB3aGljaCBkb2Vzbid0IGhhdmUgYW55IGhhbmRsaW5n
IG9uIG1pZ3JhdGlvbgogICBzYXZlL3Jlc3RvcmUgaXMgZG91Ymx5IHN1c3BpY2lvdXMKLi4uYW5k
IHRoZW4gaXQgd2FzIGp1c3QgYSBtYXR0ZXIgb2YgImZpbmQgdGhlIHNpdHVhdGlvbgp3aGVyZSB0
aGlzIGlzIGJyb2tlbiIgOi0pCgpJZiB3ZSB3YW50IHRvIGF2b2lkIG1ha2luZyBzeXNjYWxscyBi
YWNrIGludG8gS1ZNIGl0IG1pZ2h0CmJlIGJldHRlciB0byBhdHRhY2sgdGhlIHByb2JsZW0gaW4g
dGhlIEdJQyBvYmplY3QgcmF0aGVyCnRoYW4gaW4gYWxsIHRoZSBkZXZpY2VzIHRoYXQgbWlnaHQg
YmUgY29ubmVjdGVkIHRvIGl0LgpJbiBnZW5lcmFsIFFFTVUgZGV2aWNlcyB0ZW5kIHRvIGFzc3Vt
ZSB0aGV5IGNhbiBqdXN0CmFsd2F5cyBjYWxsIHFlbXVfc2V0X2lycSgpIGFuZCBpdCdzIHRoZSBv
dGhlciBlbmQncwpqb2IgdG8gYXZvaWQgZG9pbmcgYW55dGhpbmcgdG9vIGV4cGVuc2l2ZSBpbiB0
aGF0IHNpdHVhdGlvbi4KCi0tIFBNTQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
