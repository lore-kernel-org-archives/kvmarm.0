From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 17/28] arm64/sve: Preserve SVE registers around
 kernel-mode NEON use
Date: Thu, 14 Sep 2017 11:52:22 +0100
Message-ID: <87efr9a6xl.fsf@linaro.org>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-18-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BBA749C34
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 06:49:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2evlzjex1kfk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Sep 2017 06:49:43 -0400 (EDT)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CC8640FB0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 06:49:43 -0400 (EDT)
Received: by mail-wr0-f171.google.com with SMTP id v109so5527444wrc.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 03:52:24 -0700 (PDT)
In-reply-to: <1504198860-12951-18-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IEtlcm5lbC1tb2Rl
IE5FT04gd2lsbCBjb3JydXB0IHRoZSBTVkUgdmVjdG9yIHJlZ2lzdGVycywgZHVlIHRvIHRoZQo+
IHdheSB0aGV5IGFsaWFzIHRoZSBGUFNJTUQgdmVjdG9yIHJlZ2lzdGVycyBpbiB0aGUgaGFyZHdh
cmUuCj4KPiBUaGlzIHBhdGNoIGVuc3VyZXMgdGhhdCBhbnkgbGl2ZSBTVkUgcmVnaXN0ZXIgY29u
dGVudCBmb3IgdGhlIHRhc2sKPiBpcyBzYXZlZCBieSBrZXJuZWxfbmVvbl9iZWdpbigpLiAgVGhl
IGRhdGEgd2lsbCBiZSByZXN0b3JlZCBpbiB0aGUKPiB1c3VhbCB3YXkgb24gcmV0dXJuIHRvIHVz
ZXJzcGFjZS4KPgo+IFNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0u
Y29tPgo+IFJldmlld2VkLWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJv
Lm9yZz4KClJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+
Cgo+IC0tLQo+ICBhcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYyB8IDYgKysrKy0tCj4gIDEgZmls
ZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9rZXJuZWwvZnBzaW1kLmMgYi9hcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQu
Ywo+IGluZGV4IGNlYTA1YTcuLmRkODlhY2YgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9rZXJu
ZWwvZnBzaW1kLmMKPiArKysgYi9hcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYwo+IEBAIC03NDQs
OCArNzQ0LDEwIEBAIHZvaWQga2VybmVsX25lb25fYmVnaW4odm9pZCkKPiAgCV9fdGhpc19jcHVf
d3JpdGUoa2VybmVsX25lb25fYnVzeSwgdHJ1ZSk7Cj4KPiAgCS8qIFNhdmUgdW5zYXZlZCB0YXNr
IGZwc2ltZCBzdGF0ZSwgaWYgYW55OiAqLwo+IC0JaWYgKGN1cnJlbnQtPm1tICYmICF0ZXN0X2Fu
ZF9zZXRfdGhyZWFkX2ZsYWcoVElGX0ZPUkVJR05fRlBTVEFURSkpCj4gLQkJZnBzaW1kX3NhdmVf
c3RhdGUoJmN1cnJlbnQtPnRocmVhZC5mcHNpbWRfc3RhdGUpOwo+ICsJaWYgKGN1cnJlbnQtPm1t
KSB7Cj4gKwkJdGFza19mcHNpbWRfc2F2ZSgpOwo+ICsJCXNldF90aHJlYWRfZmxhZyhUSUZfRk9S
RUlHTl9GUFNUQVRFKTsKPiArCX0KPgo+ICAJLyogSW52YWxpZGF0ZSBhbnkgdGFzayBzdGF0ZSBy
ZW1haW5pbmcgaW4gdGhlIGZwc2ltZCByZWdzOiAqLwo+ICAJX190aGlzX2NwdV93cml0ZShmcHNp
bWRfbGFzdF9zdGF0ZSwgTlVMTCk7CgoKLS0KQWxleCBCZW5uw6llCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
