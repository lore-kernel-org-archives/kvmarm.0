Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0788820C01C;
	Fri, 10 Jan 2025 11:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736506854; cv=none; b=IT//TUW5bfGlX0ZAGbvwCx4DXpLxeJqLo0/N7TaIDConnA23bkT8QArv7z1pL9s3KY5Izw2QN/y3xDsyByl5Do3hZ0nyFxyVwJoUEhjgtG/0xBWG1bB21Ryoft3gNXdgr47u3c9CoFe60E7cnS3ipnXaaYY1SNqoHNNw2Tzv6Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736506854; c=relaxed/simple;
	bh=ufnAMvfyTipAJNioLcVhIPqLQx4TKJI7tO8dVXXCXzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3gkJPXPNzPAa0+N+0UKwax/IN9PAEoANku1eeTLDFzg30ZRxD7dpN3gGl7NjqMdj0/iTE8HhUCvs0BhQpaAePiZt1iRvcNshr7zDXezK8Int1C/b5fdCBeGxmgW/cNksfFtyBGVB2WitnNpSMbwcUs3RyfDHYdkmvo8WkqBff0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjWA+zqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjWA+zqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23702C4CED6;
	Fri, 10 Jan 2025 11:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736506853;
	bh=ufnAMvfyTipAJNioLcVhIPqLQx4TKJI7tO8dVXXCXzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjWA+zqI2E+3xoYUuq+poOeYPAP+e/6aWJ6JhIU8HsPvVkyfoECyjutRQ5k8ggpxw
	 izpfkE+rO6j2wnYKocCf+66qq4gyiqWh/hfIZyNjIXjIoryu7XYizeelotaWM1XdoE
	 3bWIvn4fBTrI8hW6+RJQlTL+D6rsdD27iUTov6zeKaiXjvYO88pzLBxTKVgTscVo6A
	 JSGxMj/Afa9KYlEzm1+EF3fnzM/ItnTTYVOLxnPtGQaLnxmMBmOQKhQAddbxXLHK8M
	 V6YSS9F6ktBi/BtAVekfwXk0ZasMDZXr/sf4zBd4yz0PEW8F0VsgzcknKcXwvFwCN5
	 TijgN4V7f3jcw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH v2 4/7] KVM: arm64: MTE: Add KVM_CAP_ARM_MTE_PERM
Date: Fri, 10 Jan 2025 16:30:20 +0530
Message-ID: <20250110110023.2963795-5-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by VMM to enable the usage of NoTagAccess memory
attribute while mapping pages not supporting allocating tags to guest
IPA.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst    | 14 ++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  7 +++++++
 arch/arm64/kvm/arm.c              | 11 +++++++++++
 include/uapi/linux/kvm.h          |  1 +
 4 files changed, 33 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 454c2aaa155e..e954fca76c27 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -9017,6 +9017,20 @@ Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
 production.  The behavior and effective ABI for software-protected VMs is
 unstable.
 
+8.42 KVM_CAP_ARM_MTE_PERM
+------------------------
+
+:Capability: KVM_CAP_ARM_MTE_PERM
+:Architectures: arm64
+:Type: vm
+
+This capability, if KVM_CHECK_EXTENSION indicates that it is available, means
+that the kernel has support for mapping memory regions not supporting
+allocations tags into a guest which enables KVM_CAP_ARM_MTE capability.
+
+In order to use this, it has to be activated by setting this capability via
+KVM_ENABLE_CAP ioctl on the VM fd.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e18e9244d17a..ad2b488b99d5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -331,6 +331,9 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		7
 	/* Fine-Grained UNDEF initialised */
 #define KVM_ARCH_FLAG_FGU_INITIALIZED			8
+	/* Memory Tagging Extension NoTagAccess check enabled for the guest */
+#define KVM_ARCH_FLAG_MTE_PERM_ENABLED			9
+
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
@@ -1417,6 +1420,10 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_vm_has_ran_once(kvm)					\
 	(test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &(kvm)->arch.flags))
 
+#define kvm_has_mte_perm(kvm)					\
+	(system_supports_notagaccess() &&				\
+	 test_bit(KVM_ARCH_FLAG_MTE_PERM_ENABLED, &(kvm)->arch.flags))
+
 static inline bool __vcpu_has_feature(const struct kvm_arch *ka, int feature)
 {
 	return test_bit(feature, ka->vcpu_features);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..fdcd2c1605d5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -150,6 +150,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
+	case KVM_CAP_ARM_MTE_PERM:
+		mutex_lock(&kvm->lock);
+		if (system_supports_notagaccess() && !kvm->created_vcpus) {
+			r = 0;
+			set_bit(KVM_ARCH_FLAG_MTE_PERM_ENABLED, &kvm->arch.flags);
+		}
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		break;
 	}
@@ -418,6 +426,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
 		r = BIT(0);
 		break;
+	case KVM_CAP_ARM_MTE_PERM:
+		r = system_supports_notagaccess();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 502ea63b5d2e..4900ff577819 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -933,6 +933,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_ARM_MTE_PERM 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.43.0

