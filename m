From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v5 4/6] target-arm: kvm - support for single step
Date: Fri, 29 May 2015 16:19:22 +0100
Message-ID: <1432912764-7073-5-git-send-email-alex.bennee@linaro.org>
References: <1432912764-7073-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D25352579
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 11:09:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vKruSAlA22wr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2015 11:09:33 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91F0552576
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 11:09:33 -0400 (EDT)
In-Reply-To: <1432912764-7073-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org, peter.maydell@linaro.org, christoffer.dall@linaro.org, zhichao.huang@linaro.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

VGhpcyBhZGRzIHN1cHBvcnQgZm9yIHNpbmdsZS1zdGVwLiBUaGVyZSBpc24ndCBtdWNoIHRvIGRv
IG9uIHRoZSBRRU1VCnNpZGUgYXMgYWZ0ZXIgd2Ugc2V0LXVwIHRoZSByZXF1ZXN0IGZvciBzaW5n
bGUgc3RlcCB2aWEgdGhlIGRlYnVnIGlvY3RsCml0IGlzIGFsbCBoYW5kbGVkIHdpdGhpbiB0aGUg
a2VybmVsLgoKU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8u
b3JnPgoKLS0tCnYyCiAgLSBjb252ZXJ0IHRvIHVzaW5nIEhTUl9FQwp2MwogIC0gdXNlIGludGVy
bmFscy5oIGRlZmluaXRpb25zCi0tLQogdGFyZ2V0LWFybS9rdm0uYyB8IDEwICsrKysrKysrKysK
IDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvdGFyZ2V0LWFy
bS9rdm0uYyBiL3RhcmdldC1hcm0va3ZtLmMKaW5kZXggYzNiYWQ2Zi4uZGUyODY1YSAxMDA2NDQK
LS0tIGEvdGFyZ2V0LWFybS9rdm0uYworKysgYi90YXJnZXQtYXJtL2t2bS5jCkBAIC01MjgsNiAr
NTI4LDEzIEBAIHN0YXRpYyBpbnQga3ZtX2hhbmRsZV9kZWJ1ZyhDUFVTdGF0ZSAqY3MsIHN0cnVj
dCBrdm1fcnVuICpydW4pCiAgICAga3ZtX2NwdV9zeW5jaHJvbml6ZV9zdGF0ZShjcyk7CiAKICAg
ICBzd2l0Y2ggKGhzcl9lYykgeworICAgIGNhc2UgRUNfU09GVFdBUkVTVEVQOgorICAgICAgICBp
ZiAoY3MtPnNpbmdsZXN0ZXBfZW5hYmxlZCkgeworICAgICAgICAgICAgcmV0dXJuIHRydWU7Cisg
ICAgICAgIH0gZWxzZSB7CisgICAgICAgICAgICBlcnJvcl9yZXBvcnQoIkNhbWUgb3V0IG9mIFNJ
TkdMRSBTVEVQIHdoZW4gbm90IGVuYWJsZWQiKTsKKyAgICAgICAgfQorICAgICAgICBicmVhazsK
ICAgICBjYXNlIEVDX0FBNjRfQktQVDoKICAgICAgICAgaWYgKGt2bV9maW5kX3N3X2JyZWFrcG9p
bnQoY3MsIGVudi0+cGMpKSB7CiAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsKQEAgLTU4OCw2ICs1
OTUsOSBAQCBpbnQga3ZtX2FyY2hfb25fc2lnYnVzKGludCBjb2RlLCB2b2lkICphZGRyKQogCiB2
b2lkIGt2bV9hcmNoX3VwZGF0ZV9ndWVzdF9kZWJ1ZyhDUFVTdGF0ZSAqY3MsIHN0cnVjdCBrdm1f
Z3Vlc3RfZGVidWcgKmRiZykKIHsKKyAgICBpZiAoY3MtPnNpbmdsZXN0ZXBfZW5hYmxlZCkgewor
ICAgICAgICBkYmctPmNvbnRyb2wgfD0gS1ZNX0dVRVNUREJHX0VOQUJMRSB8IEtWTV9HVUVTVERC
R19TSU5HTEVTVEVQOworICAgIH0KICAgICBpZiAoa3ZtX3N3X2JyZWFrcG9pbnRzX2FjdGl2ZShj
cykpIHsKICAgICAgICAgZGJnLT5jb250cm9sIHw9IEtWTV9HVUVTVERCR19FTkFCTEUgfCBLVk1f
R1VFU1REQkdfVVNFX1NXX0JQOwogICAgIH0KLS0gCjIuNC4xCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K
