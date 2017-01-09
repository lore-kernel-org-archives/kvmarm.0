From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 47/55] KVM: arm/arm64: Forward the guest hypervisor's stage 2
 permission faults
Date: Mon,  9 Jan 2017 01:24:43 -0500
Message-ID: <1483943091-1364-48-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF548404E7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t7AymAWMY63F for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:54 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE653406F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:50 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096O7S7005079
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:32 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 9840CA3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:32 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 7D3CD84
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:32 -0500 (EST)
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com
 [209.85.216.198])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QWUV057852
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:32 -0500
Received: by mail-qt0-f198.google.com with SMTP id k15so94310914qtg.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:32 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When faulting on a shadow stage 2 page table we have to check if the
fault was a permission fault and if so, if that fault needs to be
handled by the guest hypervisor before us, in case the guest hypervisor
has created a less permissive S2 entry than the operation required.

Check if this is the case, and inject a fault if it is.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_mmu.h   |  7 +++++++
 arch/arm/kvm/mmu.c               |  5 +++++
 arch/arm64/include/asm/kvm_mmu.h |  9 +++++++++
 arch/arm64/kvm/mmu-nested.c      | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index ab41a10..0d106ae 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -241,6 +241,13 @@ static inline int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
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
 static inline int kvm_nested_s2_init(struct kvm_vcpu *vcpu) { return 0; }
 static inline void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu) { }
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index abdf345..68fc8e8 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1542,6 +1542,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
 		if (ret)
 			goto out_unlock;
+
+		ret = kvm_s2_handle_perm_fault(vcpu, fault_ipa, &nested_trans);
+		if (ret)
+			goto out_unlock;
+
 		ipa = nested_trans.output;
 	}
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 2ac603d..2086296 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -338,6 +338,8 @@ struct kvm_s2_trans {
 bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr);
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 		       struct kvm_s2_trans *result);
+int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			     struct kvm_s2_trans *trans);
 void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu);
 int kvm_nested_s2_init(struct kvm_vcpu *vcpu);
 void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu);
@@ -366,6 +368,13 @@ static inline int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
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
 static inline int kvm_nested_s2_init(struct kvm_vcpu *vcpu) { return 0; }
 static inline void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu) { }
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index b579d23..65ad0da 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -52,6 +52,19 @@ static unsigned int pa_max(void)
 	return ps_to_output_size(parange);
 }
 
+static int vcpu_inject_s2_perm_fault(struct kvm_vcpu *vcpu, gpa_t ipa,
+				     int level)
+{
+	u32 esr;
+
+	vcpu->arch.ctxt.el2_regs[FAR_EL2] = vcpu->arch.fault.far_el2;
+	vcpu->arch.ctxt.el2_regs[HPFAR_EL2] = vcpu->arch.fault.hpfar_el2;
+	esr = kvm_vcpu_get_hsr(vcpu) & ~ESR_ELx_FSC;
+	esr |= ESR_ELx_FSC_PERM;
+	esr |= level & 0x3;
+	return kvm_inject_nested_sync(vcpu, esr);
+}
+
 static int vcpu_inject_s2_trans_fault(struct kvm_vcpu *vcpu, gpa_t ipa,
 				      int level)
 {
@@ -268,6 +281,26 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
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
+	    (!write_fault && !trans->readable))
+		return vcpu_inject_s2_perm_fault(vcpu, fault_ipa, trans->level);
+
+	return 0;
+}
+
 /* expects kvm->mmu_lock to be held */
 void kvm_nested_s2_all_vcpus_wp(struct kvm *kvm)
 {
-- 
1.9.1
