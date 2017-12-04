From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 16/19] kvm: arm: don't treat unavailable HYP mode as an error
Date: Mon,  4 Dec 2017 15:03:45 +0100
Message-ID: <20171204140348.21965-14-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CF3649D86
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:01:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h7Vv3su5xd-z for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:01:07 -0500 (EST)
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C4F149D79
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:01:02 -0500 (EST)
Received: by mail-wr0-f194.google.com with SMTP id s66so17395955wrc.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 06:04:10 -0800 (PST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Since it is perfectly legal to run the kernel at EL1, it is not
actually an error if HYP mode is not available when attempting to
initialize KVM, given that KVM support cannot be built as a module.
So demote the kvm_err() to kvm_info(), which prevents the error from
appearing on an otherwise 'quiet' console.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 322c570d211e..ca65d06b38a8 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1507,7 +1507,7 @@ int kvm_arch_init(void *opaque)
 	bool in_hyp_mode;
 
 	if (!is_hyp_mode_available()) {
-		kvm_err("HYP mode not available\n");
+		kvm_info("HYP mode not available\n");
 		return -ENODEV;
 	}
 
-- 
2.14.2
