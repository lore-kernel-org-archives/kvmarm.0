From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 15/27] KVM: arm/arm64: Move kvm_is_write_fault to header file
Date: Fri, 22 Feb 2019 16:25:53 +0000
Message-ID: <20190222162605.5054-16-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 705614A320
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L2bxGkZ7mEJK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:28:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F2F4A380
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:16 -0500 (EST)
In-Reply-To: <20190222162605.5054-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

Move this little function to the header files for arm/arm64 so other
code can make use of it directly.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h   | 8 ++++++++
 arch/arm64/include/asm/kvm_emulate.h | 8 ++++++++
 virt/kvm/arm/mmu.c                   | 8 --------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 77121b713bef..8927cae7c966 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -265,6 +265,14 @@ static inline bool kvm_vcpu_dabt_isextabt(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_trap_is_iabt(vcpu))
+		return false;
+
+	return kvm_vcpu_dabt_iswrite(vcpu);
+}
+
 static inline u32 kvm_vcpu_hvc_get_imm(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & HSR_HVC_IMM_MASK;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 506386a3edde..a0d1ce9ae12b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -331,6 +331,14 @@ static inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 	return ESR_ELx_SYS64_ISS_RT(esr);
 }
 
+static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_trap_is_iabt(vcpu))
+		return false;
+
+	return kvm_vcpu_dabt_iswrite(vcpu);
+}
+
 static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 {
 	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index f8dda452ea24..e3e5a26b4845 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1403,14 +1403,6 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 	return false;
 }
 
-static bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
-{
-	if (kvm_vcpu_trap_is_iabt(vcpu))
-		return false;
-
-	return kvm_vcpu_dabt_iswrite(vcpu);
-}
-
 /**
  * stage2_wp_ptes - write protect PMD range
  * @pmd:	pointer to pmd entry
-- 
2.20.1
