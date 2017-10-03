From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 14/31] KVM: arm/arm64: Forward the guest hypervisor's
 stage 2 permission faults
Date: Mon,  2 Oct 2017 22:10:56 -0500
Message-ID: <1507000273-3735-12-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 493CA406BB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GC2PCyvdZtR8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:38 -0400 (EDT)
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com
 [209.85.214.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC7CD49D49
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:34 -0400 (EDT)
Received: by mail-it0-f52.google.com with SMTP id 85so9735580ith.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:54 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
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
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

We can have discrepancies between the nested stage 2 page table and the
shadow one in a couple of cases.  For example, the guest hypervisor can
mark a page writable but the host hypervisor maps the page read-only in
the shadow page table, if using something like KSM on the host level.
In this case, a write fault is handled directly by the host hypervisor.
But we could also simply have a read-only page mapped read-only in both
tables, in which case the host hypervisor cannot do anything else than
telling the guest hypervisor about the fault.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h   |  7 +++++++
 arch/arm64/include/asm/kvm_mmu.h |  2 ++
 arch/arm64/kvm/mmu-nested.c      | 22 ++++++++++++++++++++++
 virt/kvm/arm/mmu.c               |  7 +++++++
 4 files changed, 38 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 6a22846..1c5b652 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -237,6 +237,13 @@ static inline int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	return 0;
 }
 
+static inline int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
+					   phys_addr_t fault_ipa,
+					   struct kvm_s2_trans *trans)
+{
+	return 0;
+}
+
 static inline void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu) { }
 static inline void kvm_nested_s2_free(struct kvm *kvm) { }
 static inline void kvm_nested_s2_wp(struct kvm *kvm) { }
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 425e4a2..239bb89 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -337,6 +337,8 @@ struct kvm_s2_trans {
 void update_nested_s2_mmu(struct kvm_vcpu *vcpu);
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 		       struct kvm_s2_trans *result);
+int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			     struct kvm_s2_trans *trans);
 void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu);
 void kvm_nested_s2_free(struct kvm *kvm);
 void kvm_nested_s2_wp(struct kvm *kvm);
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index 75570cc..a440d7b 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -271,6 +271,28 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	return walk_nested_s2_pgd(vcpu, gipa, &wi, result);
 }
 
+/*
+ * Returns non-zero if permission fault is handled by injecting it to the next
+ * level hypervisor.
+ */
+int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			     struct kvm_s2_trans *trans)
+{
+	unsigned long fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
+	bool write_fault = kvm_is_write_fault(vcpu);
+
+	if (fault_status != FSC_PERM)
+		return 0;
+
+	if ((write_fault && !trans->writable) ||
+	    (!write_fault && !trans->readable)) {
+		trans->esr = esr_s2_fault(vcpu, trans->level, ESR_ELx_FSC_PERM);
+		return 1;
+	}
+
+	return 0;
+}
+
 /* expects kvm->mmu_lock to be held */
 void kvm_nested_s2_wp(struct kvm *kvm)
 {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 74941ad..4fb7b3b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1591,6 +1591,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (ret)
 			goto out_unlock;
 
+		nested_trans.esr = 0;
+		ret = kvm_s2_handle_perm_fault(vcpu, fault_ipa, &nested_trans);
+		if (nested_trans.esr)
+			kvm_inject_s2_fault(vcpu, nested_trans.esr);
+		if (ret)
+			goto out_unlock;
+
 		ipa = nested_trans.output;
 	}
 
-- 
1.9.1
