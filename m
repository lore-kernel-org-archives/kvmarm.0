From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 02/31] KVM: arm64: Expose limited memory management
 support to the virtual EL2
Date: Mon,  2 Oct 2017 22:09:58 -0500
Message-ID: <1507000198-3635-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29C3C40638
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:09:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NxQ6+zSUGSAk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:09:43 -0400 (EDT)
Received: from mail-io0-f177.google.com (mail-io0-f177.google.com
 [209.85.223.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B28C4060C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:09:43 -0400 (EDT)
Received: by mail-io0-f177.google.com with SMTP id v36so6453089ioi.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:10:03 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, pbonzini@redhat.com, Dave.Martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Exposing memory management support to the virtual EL2 as is exposed to
the host hypervisor would make the implementation too complex and
inefficient. Therefore expose limited memory management support for the
following two cases.

We expose same or larger page granules than the one host uses.  We can
theoretically support a guest hypervisor having smaller-than-host
granularities but it is not worth it since it makes the implementation
complicated and it would waste memory.

We expose 40 bits of physical address range to the virtual EL2, because
we only support a 40bit IPA for the guest.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 65f4c20..395b964 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1233,6 +1233,50 @@ static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	.set_user = set_raz_id_reg,			\
 }
 
+static bool access_id_aa64mmfr0_el1(struct kvm_vcpu *v,
+				    struct sys_reg_params *p,
+				    const struct sys_reg_desc *r)
+{
+	u64 val;
+	u64 vtcr_tg0 = VTCR_EL2_TGRAN_FLAGS & VTCR_EL2_TG0_MASK;
+
+	if (!nested_virt_in_use(v))
+		return access_id_reg(v, p, r);
+
+	if (p->is_write)
+		return write_to_read_only(v, p, r);
+
+	val = p->regval;
+	/*
+	 * Don't expose granules smaller than the host's granule to the guest.
+	 * We can theoretically support a guest hypervisor having
+	 * smaller-than-host granularities but it is not worth it since it
+	 * makes the implementation complicated and it would waste memory.
+	 */
+	switch (vtcr_tg0) {
+	case VTCR_EL2_TG0_64K:
+		/* 16KB granule not supported */
+		val &= ~(0xf << ID_AA64MMFR0_TGRAN16_SHIFT);
+		val |= (ID_AA64MMFR0_TGRAN16_NI << ID_AA64MMFR0_TGRAN16_SHIFT);
+		/* fall through */
+	case VTCR_EL2_TG0_16K:
+		/* 4KB granule not supported */
+		val &= ~(0xf << ID_AA64MMFR0_TGRAN4_SHIFT);
+		val |= (ID_AA64MMFR0_TGRAN4_NI << ID_AA64MMFR0_TGRAN4_SHIFT);
+		break;
+	default:
+		break;
+	}
+
+	/* Expose only 40 bits physical address range to the guest hypervisor */
+	val &= ~(0xf << ID_AA64MMFR0_PARANGE_SHIFT);
+	val |= (0x2 << ID_AA64MMFR0_PARANGE_SHIFT); /* 40 bits */
+
+	p->regval = val;
+
+	return true;
+}
+
 /*
  * sys_reg_desc initialiser for known ID registers that we hide from guests.
  * For now, these are exposed just like unallocated ID regs: they appear
@@ -1309,7 +1353,8 @@ static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	ID_SANITISED(ID_PFR1_EL1),
 	ID_SANITISED(ID_DFR0_EL1),
 	ID_HIDDEN(ID_AFR0_EL1),
-	ID_SANITISED(ID_MMFR0_EL1),
+	{ SYS_DESC(SYS_ID_MMFR0_EL1), access_id_aa64mmfr0_el1, NULL, 0, 0,
+	  get_id_reg, set_id_reg },
 	ID_SANITISED(ID_MMFR1_EL1),
 	ID_SANITISED(ID_MMFR2_EL1),
 	ID_SANITISED(ID_MMFR3_EL1),
-- 
1.9.1
