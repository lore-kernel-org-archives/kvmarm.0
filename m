From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 0/3] KVM: arm64: single step emulation instructions
Date: Thu, 16 Nov 2017 15:39:18 +0000
Message-ID: <20171116153921.21991-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC28D49D4F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 10:37:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HSksZP+J2HKc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Nov 2017 10:37:05 -0500 (EST)
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECA2A406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 10:37:04 -0500 (EST)
Received: by mail-wr0-f194.google.com with SMTP id p96so23130106wrb.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 07:39:24 -0800 (PST)
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

SGksCgpUaGlzIGlzIHJldiAzIG9mIHRoZSBzZXJpZXMsIHByYWN0aWNhbGx5IHRoZSBzYW1lIHRo
YW4gcmV2IDIgYnV0IGZpeGVkCmEgcmV0dXJuIDEtPjAgaW4gdGhlIGt2bV9ydW4gbG9vcCB0aGF0
IEp1bGllbiBjYXVnaHQuIEkndmUgYWRkZWQgaGlzCnItYiB0YWdzIHRvIHRoZSBvdGhlciBwYXRj
aGVzLgoKQXMgdXN1YWwgcmV2aXNpb24gZGV0YWlscyBiZWxsb3cgdGhlIC0tLSBpbiBlYWNoIHBh
dGNoLgoKQWxleCBCZW5uw6llICgzKToKICBrdm06IGFybSBkZWJ1ZzogaW50cm9kdWNlIGhlbHBl
ciBmb3Igc2luZ2xlLXN0ZXAKICBrdm06IGFybTY0OiBoYW5kbGUgc2luZ2xlLXN0ZXBwaW5nIHRy
YXBwZWQgaW5zdHJ1Y3Rpb25zCiAga3ZtOiBhcm02NDogaGFuZGxlIHNpbmdsZS1zdGVwIG9mIHVz
ZXJzcGFjZSBtbWlvIGluc3RydWN0aW9ucwoKIGFyY2gvYXJtL2luY2x1ZGUvYXNtL2t2bV9ob3N0
LmggICB8ICA1ICsrKysrCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggfCAgMSAr
CiBhcmNoL2FybTY0L2t2bS9kZWJ1Zy5jICAgICAgICAgICAgfCAyMiArKysrKysrKysrKysrKysr
KysKIGFyY2gvYXJtNjQva3ZtL2hhbmRsZV9leGl0LmMgICAgICB8IDQ3ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKy0tLS0tLS0tLS0tLQogdmlydC9rdm0vYXJtL2FybS5jICAgICAgICAgICAg
ICAgIHwgIDMgKysrCiA1IGZpbGVzIGNoYW5nZWQsIDY0IGluc2VydGlvbnMoKyksIDE0IGRlbGV0
aW9ucygtKQoKLS0gCjIuMTUuMAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
