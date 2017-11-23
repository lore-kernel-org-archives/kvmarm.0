From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v1 0/2] Additional single-step-cases
Date: Thu, 23 Nov 2017 12:11:32 +0000
Message-ID: <20171123121134.11050-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD18349D75
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 07:09:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jlb2LjT2wI1w for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Nov 2017 07:08:59 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9023749D6B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 07:08:59 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id y80so16095958wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Nov 2017 04:11:37 -0800 (PST)
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

SGksCgpUaGlzIGlzIG5vdyBzcGxpdCBpbnRvIHR3byBwYXRjaGVzIGFzIHRoZSBmaXJzdCBjYXNl
IG9mIFNFcnJvciBpcwpzZXBhcmF0ZSBmcm9tIGJlaGF2aW91ciBvZiBzdGVwcGluZyBpbnN0cnVj
dGlvbnMuCgpBbGV4IEJlbm7DqWUgKDIpOgogIGt2bTogYXJtNjQ6IGhhbmRsZSBzaW5nbGUtc3Rl
cCBkdXJpbmcgU0Vycm9yIGV4Y2VwdGlvbnMKICBrdm06IGFybTY0OiBoYW5kbGUgc2luZ2xlLXN0
ZXAgb2YgaHlwIGVtdWxhdGVkIG1taW8gaW5zdHJ1Y3Rpb25zCgogYXJjaC9hcm02NC9rdm0vaGFu
ZGxlX2V4aXQuYyB8ICA4ICsrKysrKystCiBhcmNoL2FybTY0L2t2bS9oeXAvc3dpdGNoLmMgIHwg
MzcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2Vk
LCAzNyBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKLS0gCjIuMTUuMAoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
