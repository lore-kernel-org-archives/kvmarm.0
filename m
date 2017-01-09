From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 52/55] KVM: arm/arm64: Create a vcpu mapping for the nested VM
Date: Mon,  9 Jan 2017 01:24:48 -0500
Message-ID: <1483943091-1364-53-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C979D40102
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2tJg7dUWh8ag for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:58 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19A8C40423
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:56 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PXwO017320
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:37 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id B5F4983
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:37 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 80A258B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:37 -0500 (EST)
Received: from mail-qt0-f200.google.com (mail-qt0-f200.google.com
 [209.85.216.200])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QbJo057990
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:37 -0500
Received: by mail-qt0-f200.google.com with SMTP id t56so77870059qte.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:37 -0800 (PST)
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

Create a mapping from the nested VM's cpu interface to the hardware
virtual cpu interface. This is to allow the nested VM to access virtual
cpu interface directly.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_mmu.h   |  3 +++
 arch/arm/kvm/mmu.c               |  5 +++++
 arch/arm64/include/asm/kvm_mmu.h |  5 +++++
 arch/arm64/kvm/mmu-nested.c      | 26 ++++++++++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 0d106ae..048a021 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -254,6 +254,9 @@ static inline void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu) { }
 static inline void kvm_nested_s2_all_vcpus_wp(struct kvm *kvm) { }
 static inline void kvm_nested_s2_all_vcpus_unmap(struct kvm *kvm) { }
 static inline void kvm_nested_s2_all_vcpus_flush(struct kvm *kvm) { }
+static inline int kvm_nested_mmio_ondemand(struct kvm_vcpu *vcpu,
+					   phys_addr_t fault_ipa,
+					   phys_addr_t ipa) { return 0; }
 
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 				struct kvm_s2_mmu *mmu)
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 2cd6a19..f7c2911 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1615,6 +1615,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			goto out_unlock;
 		}
 
+		if (kvm_nested_mmio_ondemand(vcpu, fault_ipa, ipa)) {
+			ret = 1;
+			goto out_unlock;
+		}
+
 		/*
 		 * The IPA is reported as [MAX:12], so we need to
 		 * complement it with the bottom 12 bits from the
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ec9e5e9..ee80a58 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -354,6 +354,8 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 void kvm_nested_s2_all_vcpus_wp(struct kvm *kvm);
 void kvm_nested_s2_all_vcpus_unmap(struct kvm *kvm);
 void kvm_nested_s2_all_vcpus_flush(struct kvm *kvm);
+int kvm_nested_mmio_ondemand(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			     phys_addr_t ipa);
 #else
 static inline struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu,
 						       u64 vttbr)
@@ -389,6 +391,9 @@ static inline void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu) { }
 static inline void kvm_nested_s2_all_vcpus_wp(struct kvm *kvm) { }
 static inline void kvm_nested_s2_all_vcpus_unmap(struct kvm *kvm) { }
 static inline void kvm_nested_s2_all_vcpus_flush(struct kvm *kvm) { }
+static inline int kvm_nested_mmio_ondemand(struct kvm_vcpu *vcpu,
+					   phys_addr_t fault_ipa,
+					   phys_addr_t ipa) { return 0; }
 #endif
 
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index 65ad0da..bce0042 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -473,3 +473,29 @@ bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr)
 
 	return true;
 }
+
+/*
+ * vcpu interface address. This address is supposed to come from the guest's
+ * device tree via QEMU. Here we just hardcoded it, but should be fixed.
+ */
+#define NESTED_VCPU_IF_ADDR	0x08010000
+int kvm_nested_mmio_ondemand(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			     phys_addr_t ipa)
+{
+	int ret = 0;
+	phys_addr_t vcpu_base = vgic_vcpu_base();
+
+	/* Return if this fault is not from a nested VM */
+	if (vcpu->arch.hw_mmu == &vcpu->kvm->arch.mmu)
+		return ret;
+
+	if (ipa == NESTED_VCPU_IF_ADDR)  {
+		ret = __kvm_phys_addr_ioremap(vcpu->kvm, vcpu->arch.hw_mmu,
+					      fault_ipa, vcpu_base,
+					      KVM_VGIC_V2_CPU_SIZE, true);
+		if (!ret)
+			ret = 1;
+	}
+
+	return ret;
+}
-- 
1.9.1
