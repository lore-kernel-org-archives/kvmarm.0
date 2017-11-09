From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 0/3] KVM: arm64: single step emulation instructions
Date: Thu,  9 Nov 2017 17:00:18 +0000
Message-ID: <20171109170021.2984-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8B5A49D54
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Nov 2017 11:58:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I+YEgITpFYtr for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Nov 2017 11:58:23 -0500 (EST)
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C040B49D27
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Nov 2017 11:58:23 -0500 (EST)
Received: by mail-wr0-f194.google.com with SMTP id o88so6215915wrb.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Nov 2017 09:00:24 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

SGksCgpUaGlzIGlzIHJldiAyIG9mIHRoZSBzZXJpZXMuIFRoZSBtYWluIGNoYW5nZSBpcyBJJ3Zl
IG1vdmVkIHRoZSBoZWxwZXIKaW50byBpdCdzIG93biBwYXRjaCBhbmQgY2hhbmdlZCBpdCdzIHJl
dHVybiB0byBhIGJvb2wgcmF0aGVyIHRoYW4gdHJ5CmFuZCBzdHJhZGRsZSB0aGUgZGlmZmVyZW50
IHJldHVybiBzZW1hbnRpY3Mgb2Yga3ZtX2hhbmRsZV9tbWlvX3JldHVybgphbmQgaGFuZGxlX2V4
aXQuCgpUaGUgcmVzdWx0IGlzIHdlIG5vIGxvbmdlciBoYXZlIGNvZGUgbW90aW9uIGluIHBhdGNo
IDIgKG5vdyAzKSB0bwppbnRyb2R1Y2UgdGhlIGhlbHBlciBtYWtpbmcgaXQgZW1iYXJyYXNzaW5n
bHkgc2hvcnQgLSBidXQgaG9wZWZ1bGx5IGEKbG90IGNsZWFyZXIuCgpBcyB1c3VhbCByZXZpc2lv
biBkZXRhaWxzIGJlbGxvdyB0aGUgLS0tIGluIGVhY2ggcGF0Y2guCgpBbGV4IEJlbm7DqWUgKDMp
OgogIGt2bTogYXJtIGRlYnVnOiBpbnRyb2R1Y2UgaGVscGVyIGZvciBzaW5nbGUtc3RlcAogIGt2
bTogYXJtNjQ6IGhhbmRsZSBzaW5nbGUtc3RlcHBpbmcgdHJhcHBlZCBpbnN0cnVjdGlvbnMKICBr
dm06IGFybTY0OiBoYW5kbGUgc2luZ2xlLXN0ZXAgb2YgdXNlcnNwYWNlIG1taW8gaW5zdHJ1Y3Rp
b25zCgogYXJjaC9hcm0vaW5jbHVkZS9hc20va3ZtX2hvc3QuaCAgIHwgIDIgKysKIGFyY2gvYXJt
NjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8ICAxICsKIGFyY2gvYXJtNjQva3ZtL2RlYnVnLmMg
ICAgICAgICAgICB8IDIyICsrKysrKysrKysrKysrKysrKwogYXJjaC9hcm02NC9rdm0vaGFuZGxl
X2V4aXQuYyAgICAgIHwgNDcgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0t
CiB2aXJ0L2t2bS9hcm0vYXJtLmMgICAgICAgICAgICAgICAgfCAgMyArKysKIDUgZmlsZXMgY2hh
bmdlZCwgNjEgaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pCgotLSAKMi4xNC4yCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
