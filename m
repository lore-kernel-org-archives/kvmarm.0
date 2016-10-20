From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm/arm64: KVM: Map the BSS at HYP
Date: Thu, 20 Oct 2016 14:00:41 +0100
Message-ID: <1476968441-29003-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, eric.auger@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

When used with a compiler that doesn't implement "asm goto"
(such as the AArch64 port of GCC 4.8), jump labels generate a
memory access to find out about the value of the key (instead
of just patching the code). The key itself is likely to be
stored in the BSS.

This is perfectly fine, except that we don't map the BSS at HYP,
leading to an exploding kernel at the first access. The obvious
fix is simply to map the BSS there (which should have been done
a long while ago, but hey...).

Reported-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 09942f0..14adf40 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1345,6 +1345,13 @@ static int init_hyp_mode(void)
 		goto out_err;
 	}
 
+	err = create_hyp_mappings(kvm_ksym_ref(__bss_start),
+				  kvm_ksym_ref(__bss_stop), PAGE_HYP_RO);
+	if (err) {
+		kvm_err("Cannot map bss section\n");
+		goto out_err;
+	}
+
 	/*
 	 * Map the Hyp stack pages
 	 */
-- 
2.1.4

