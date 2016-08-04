From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 3/8] KVM: irqchip: Convey devid to kvm_set_msi
Date: Thu,  4 Aug 2016 13:40:31 +0200
Message-ID: <1470310836-10371-4-git-send-email-christoffer.dall@linaro.org>
References: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBC1B49B60
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:33:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZZnVa-Zgey0w for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2016 07:33:56 -0400 (EDT)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F279A49B62
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:33:55 -0400 (EDT)
Received: by mail-lf0-f43.google.com with SMTP id f93so180537748lfi.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2016 04:40:48 -0700 (PDT)
In-Reply-To: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgoKb24gQVJNLCBhIGRldmlk
IGZpZWxkIGlzIHBvcHVsYXRlZCBpbiBrdm1fbXNpIHN0cnVjdCBpbiBjYXNlIHRoZQpmbGFnIGlz
IHNldCB0byBLVk1fTVNJX1ZBTElEX0RFVklELiBMZXQncyBwcm9wYWdhdGUgYm90aCBmbGFncyBh
bmQKZGV2aWQgZmllbGQgaW4ga3ZtX2tlcm5lbF9pcnFfcm91dGluZ19lbnRyeS4KClNpZ25lZC1v
ZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6IEFu
ZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPgpBY2tlZC1ieTogQ2hyaXN0b2Zm
ZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5hcm8ub3JnPgpBY2tlZC1ieTogUmFkaW0gS3LE
jW3DocWZIDxya3JjbWFyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8
bWFyYy56eW5naWVyQGFybS5jb20+Ci0tLQogdmlydC9rdm0vaXJxY2hpcC5jIHwgNCArKystCiAx
IGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0
IGEvdmlydC9rdm0vaXJxY2hpcC5jIGIvdmlydC9rdm0vaXJxY2hpcC5jCmluZGV4IDhkYjE5N2Iu
LjBjMDAwNTQgMTAwNjQ0Ci0tLSBhL3ZpcnQva3ZtL2lycWNoaXAuYworKysgYi92aXJ0L2t2bS9p
cnFjaGlwLmMKQEAgLTYyLDEyICs2MiwxNCBAQCBpbnQga3ZtX3NlbmRfdXNlcnNwYWNlX21zaShz
dHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fbXNpICptc2kpCiB7CiAJc3RydWN0IGt2bV9rZXJu
ZWxfaXJxX3JvdXRpbmdfZW50cnkgcm91dGU7CiAKLQlpZiAoIWlycWNoaXBfaW5fa2VybmVsKGt2
bSkgfHwgbXNpLT5mbGFncyAhPSAwKQorCWlmICghaXJxY2hpcF9pbl9rZXJuZWwoa3ZtKSB8fCAo
bXNpLT5mbGFncyAmIH5LVk1fTVNJX1ZBTElEX0RFVklEKSkKIAkJcmV0dXJuIC1FSU5WQUw7CiAK
IAlyb3V0ZS5tc2kuYWRkcmVzc19sbyA9IG1zaS0+YWRkcmVzc19sbzsKIAlyb3V0ZS5tc2kuYWRk
cmVzc19oaSA9IG1zaS0+YWRkcmVzc19oaTsKIAlyb3V0ZS5tc2kuZGF0YSA9IG1zaS0+ZGF0YTsK
Kwlyb3V0ZS5tc2kuZmxhZ3MgPSBtc2ktPmZsYWdzOworCXJvdXRlLm1zaS5kZXZpZCA9IG1zaS0+
ZGV2aWQ7CiAKIAlyZXR1cm4ga3ZtX3NldF9tc2koJnJvdXRlLCBrdm0sIEtWTV9VU0VSU1BBQ0Vf
SVJRX1NPVVJDRV9JRCwgMSwgZmFsc2UpOwogfQotLSAKMS45LjEKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
