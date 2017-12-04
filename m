From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 13/19] kvm: arm64: handle single-step during SError exceptions
Date: Mon,  4 Dec 2017 15:03:42 +0100
Message-ID: <20171204140348.21965-11-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67D3C49DA6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:01:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VcJBQGYqRtIL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:01:00 -0500 (EST)
Received: from mail-wr0-f196.google.com (mail-wr0-f196.google.com
 [209.85.128.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D5BF49D7F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:00:59 -0500 (EST)
Received: by mail-wr0-f196.google.com with SMTP id x49so17407084wrb.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 06:04:06 -0800 (PST)
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgoKV2hlbiBhbiBTRXJy
b3IgYXJyaXZlcyBkdXJpbmcgc2luZ2xlLXN0ZXAgYm90aCB0aGUgU0Vycm9yIGFuZCBkZWJ1Zwpl
eGNlcHRpb25zIG1heSBiZSBwZW5kaW5nIHdoZW4gdGhlIHN0ZXAgaXMgY29tcGxldGVkLCBhbmQg
dGhlCmFyY2hpdGVjdHVyZSBkb2Vzbid0IGRlZmluZSB0aGUgb3JkZXJpbmcgb2YgdGhlIHR3by4g
IFRoaXMgbWVhbnMgdGhhdCB3ZQpjYW4gb2JzZXJ2ZSBlbiBTRXJyb3IgZXZlbiB0aG91Z2ggd2Un
dmUganVzdCBjb21wbGV0ZWQgYSBzdGVwLCB3aXRob3V0CnJlY2VpdmluZyBhIGRlYnVnIGV4Y2Vw
dGlvbi4gIEluIHRoYXQgY2FzZSB0aGUgREJHX1NQU1JfU1MgYml0IHdpbGwgaGF2ZQpmbGlwcGVk
IGFzIHRoZSBpbnN0cnVjdGlvbiBleGVjdXRlZC4gQWZ0ZXIgaGFuZGxpbmcgdGhlIGFib3J0IGlu
CmhhbmRsZV9leGl0KCkgd2UgdGVzdCB0byBzZWUgaWYgdGhlIGJpdCBpcyBjbGVhciBhbmQgd2Ug
d2VyZQpzaW5nbGUtc3RlcHBpbmcgYmVmb3JlIGRlY2lkaW5nIGlmIHdlIG5lZWQgdG8gZXhpdCB0
byB1c2VyIHNwYWNlLgoKQWNrZWQtYnk6IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5j
b20+ClJldmlld2VkLWJ5OiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGxpbmFy
by5vcmc+ClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9y
Zz4KU2lnbmVkLW9mZi1ieTogQ2hyaXN0b2ZmZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5h
cm8ub3JnPgotLS0KIGFyY2gvYXJtNjQva3ZtL2hhbmRsZV9leGl0LmMgfCA4ICsrKysrKystCiAx
IGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQuYyBiL2FyY2gvYXJtNjQva3ZtL2hhbmRsZV9l
eGl0LmMKaW5kZXggMDI5YzI4ZGQyNWU5Li4zMDQyMDNmYTllMzMgMTAwNjQ0Ci0tLSBhL2FyY2gv
YXJtNjQva3ZtL2hhbmRsZV9leGl0LmMKKysrIGIvYXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQu
YwpAQCAtMjgsNiArMjgsNyBAQAogI2luY2x1ZGUgPGFzbS9rdm1fZW11bGF0ZS5oPgogI2luY2x1
ZGUgPGFzbS9rdm1fbW11Lmg+CiAjaW5jbHVkZSA8YXNtL2t2bV9wc2NpLmg+CisjaW5jbHVkZSA8
YXNtL2RlYnVnLW1vbml0b3JzLmg+CiAKICNkZWZpbmUgQ1JFQVRFX1RSQUNFX1BPSU5UUwogI2lu
Y2x1ZGUgInRyYWNlLmgiCkBAIC0yNTIsNyArMjUzLDEyIEBAIGludCBoYW5kbGVfZXhpdChzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcnVuICpydW4sCiAJCXJldHVybiAxOwogCWNh
c2UgQVJNX0VYQ0VQVElPTl9FTDFfU0VSUk9SOgogCQlrdm1faW5qZWN0X3ZhYnQodmNwdSk7Ci0J
CXJldHVybiAxOworCQkvKiBXZSBtYXkgc3RpbGwgbmVlZCB0byByZXR1cm4gZm9yIHNpbmdsZS1z
dGVwICovCisJCWlmICghKCp2Y3B1X2Nwc3IodmNwdSkgJiBEQkdfU1BTUl9TUykKKwkJCSYmIGt2
bV9hcm1faGFuZGxlX3N0ZXBfZGVidWcodmNwdSwgcnVuKSkKKwkJCXJldHVybiAwOworCQllbHNl
CisJCQlyZXR1cm4gMTsKIAljYXNlIEFSTV9FWENFUFRJT05fVFJBUDoKIAkJcmV0dXJuIGhhbmRs
ZV90cmFwX2V4Y2VwdGlvbnModmNwdSwgcnVuKTsKIAljYXNlIEFSTV9FWENFUFRJT05fSFlQX0dP
TkU6Ci0tIAoyLjE0LjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
