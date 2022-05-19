Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CCDC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:47:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA5554B475;
	Thu, 19 May 2022 09:47:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8i1+1nVgezHn; Thu, 19 May 2022 09:47:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A58CD4B479;
	Thu, 19 May 2022 09:47:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FFDC4B475
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zmwfltQZzVKS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:47:07 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC42D4B479
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:07 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 725DB617D7;
 Thu, 19 May 2022 13:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6397DC34116;
 Thu, 19 May 2022 13:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968026;
 bh=c/cAcfak9Xq41vGzDwWXcOzbHn4dVNJfvW6JUCOKNTI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=MnPjV3KuVwQUlMfc1bxb7Eh0vxVdKcadWa6N25Tysz4Od0+B2FJt1LWs8WjIylfl2
 Cr7z63W96JEuaQRNGEl84zm2GC3vU9pwfmjV4x7GThKwuEKXS9ycGnTlTnrcHZD0s9
 xBz+tzYcC5a1FccAF49rSQR+OdlxpFXHQo+CLJAZaBXWPtDv/+MtfwBTvoTe4U6i2D
 0IwivhMTCBHyjYAqAnqchlXudb+DJRsnLE5QHlI/LvKZKaat5NMAy13xAdavTcYHar
 rdgZwtbrDknGepmUFtuyn0yr4A+dYOmx08mBYfc2pxGgzFBjiFgFNwhn4q/LWXpCYd
 kvP4cYDsuQnfQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 71/89] KVM: arm64: Initialize shadow vm state at hyp
Date: Thu, 19 May 2022 14:41:46 +0100
Message-Id: <20220519134204.5379-72-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Fuad Tabba <tabba@google.com>

Do not rely on the state of the vm as provided by the host, but
initialize it instead at EL2 to a known good and safe state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 71 ++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 839506a546c7..51da5c1d7e0d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -6,6 +6,9 @@
 
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
+
+#include <asm/kvm_emulate.h>
+
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
 #include <nvhe/pkvm.h>
@@ -315,6 +318,53 @@ struct kvm_shadow_vcpu_state *pkvm_loaded_shadow_vcpu_state(void)
 	return __this_cpu_read(loaded_shadow_state);
 }
 
+/* Check and copy the supported features for the vcpu from the host. */
+static void copy_features(struct kvm_vcpu *shadow_vcpu, struct kvm_vcpu *host_vcpu)
+{
+	DECLARE_BITMAP(allowed_features, KVM_VCPU_MAX_FEATURES);
+
+	/* No restrictions for non-protected VMs. */
+	if (!kvm_vm_is_protected(shadow_vcpu->kvm)) {
+		bitmap_copy(shadow_vcpu->arch.features,
+			    host_vcpu->arch.features,
+			    KVM_VCPU_MAX_FEATURES);
+		return;
+	}
+
+	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
+
+	/*
+	 * For protected vms, always allow:
+	 * - CPU starting in poweroff state
+	 * - PSCI v0.2
+	 */
+	set_bit(KVM_ARM_VCPU_POWER_OFF, allowed_features);
+	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
+
+	/*
+	 * Check if remaining features are allowed:
+	 * - Performance Monitoring
+	 * - Scalable Vectors
+	 * - Pointer Authentication
+	 */
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), PVM_ID_AA64DFR0_ALLOW))
+		set_bit(KVM_ARM_VCPU_PMU_V3, allowed_features);
+
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_SVE), PVM_ID_AA64PFR0_ALLOW))
+		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
+
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_API), PVM_ID_AA64ISAR1_ALLOW) &&
+	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA), PVM_ID_AA64ISAR1_ALLOW))
+		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
+
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI), PVM_ID_AA64ISAR1_ALLOW) &&
+	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA), PVM_ID_AA64ISAR1_ALLOW))
+		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
+
+	bitmap_and(shadow_vcpu->arch.features, host_vcpu->arch.features,
+		   allowed_features, KVM_VCPU_MAX_FEATURES);
+}
+
 static void unpin_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
 			     unsigned int nr_vcpus)
 {
@@ -350,6 +400,17 @@ static int set_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
 	return 0;
 }
 
+static int init_ptrauth(struct kvm_vcpu *shadow_vcpu)
+{
+	int ret = 0;
+
+	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, shadow_vcpu->arch.features) ||
+	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, shadow_vcpu->arch.features))
+		ret = kvm_vcpu_enable_ptrauth(shadow_vcpu);
+
+	return ret;
+}
+
 static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
 			       struct kvm_vcpu **vcpu_array,
 			       int *last_ran,
@@ -357,10 +418,12 @@ static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
 			       unsigned int nr_vcpus)
 {
 	int i;
+	int ret;
 
 	vm->host_kvm = kvm;
 	vm->kvm.created_vcpus = nr_vcpus;
 	vm->kvm.arch.vtcr = host_kvm.arch.vtcr;
+	vm->kvm.arch.pkvm.enabled = READ_ONCE(kvm->arch.pkvm.enabled);
 	vm->kvm.arch.mmu.last_vcpu_ran = last_ran;
 	vm->last_ran_size = last_ran_size;
 	memset(vm->kvm.arch.mmu.last_vcpu_ran, -1, sizeof(int) * hyp_nr_cpus);
@@ -377,8 +440,16 @@ static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
 		shadow_vcpu->vcpu_idx = i;
 
 		shadow_vcpu->arch.hw_mmu = &vm->kvm.arch.mmu;
+		shadow_vcpu->arch.power_off = true;
+
+		copy_features(shadow_vcpu, host_vcpu);
+
+		ret = init_ptrauth(shadow_vcpu);
+		if (ret)
+			return ret;
 
 		pkvm_vcpu_init_traps(shadow_vcpu, host_vcpu);
+		kvm_reset_pvm_sys_regs(shadow_vcpu);
 	}
 
 	return 0;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
