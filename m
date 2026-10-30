Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343384;
	b=uhqxxjL3+RX2VrknR/pMuV9+VPV8uX7e/kIwWDb9Pdz3ZOQDgSpp0QoQVp72lPjUmhFt
	 RcVvnBw/flegD0FPHz5KFuDo/StfHCgB2x33c9mV3kMzV9gBWANowyBSFssH4KWXpGIyF
	 6ilOpWx19KpXfaUqgbT9gTEF1K8JF8N0lqR/tt7j8R9GifPXt9GIzrZYtmAO1un8XvYJ9
	 S3LAmf1G0j18km9myYGk/dfT0kqkiJH6lDWV9q+PllkFEYAHJmvdTj9RFImyFxzH8xtCZ
	 ni4wDdyVRMoKNg5KVTSflDL/4Q3pyWUKLB7espRZcFy10HGfoqzpj3nsLU+imRtwsrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343384;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=j3o4Hr1tImNLf1ZatEPhpw+q0Mj2sL9CPD7ffrsuWjI=;
	b=KUlDq2f3Ttlo5QaTmlCFCJ8Qi6QsPml57rymTIFWdVlhpl1z5yf3cIiSJvk5vbpJympT
	 6aZeD1mtjffoynfamhSIlitFKKrXu0A372N2ZKqMojCaCB989qPTO7gnvixS1ZbBAw1VD
	 Kgu9Fnsnu2WUBdJt536ter/VAzKSfUNEmpcvFdW7D4zCpRkYNXzdPN6VoH/HqdmJnxr1C
	 WuYkrsMf+e/TVJXamgdfofbu81Bcr8HwvAc63ybfFBI4LNrRQmCyzgCHZ3VE0igq8vixI
	 fBqeFaBXvmCiakMgZ+6mNlbHq5eebjLKqhOw2EJ3ZeBB43FFfuI5iNRwEfvT2XCNq3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=JEGBT4X8;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2628606A325
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 06:56:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2628606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=JEGBT4X8
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=j3o4Hr1tImNLf1ZatEPhpw+q0Mj2sL9CPD7ffrsuWjI=;
	b=JEGBT4X8yV888GI99lgi2m3H0Y541wkKwjqRq3YKadT94vflq6LzOdYnbgjuHferKblDfx3wj
	YEQ73qEWgmtkNFqti798dOdhy9TlRNBhEdetNvLAsfSbaFNK1t4jhdW92EjVTfSDR31tgpAPP4O
	1iq34tsO10T6uUWxxcb5Ao4=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jGBhY00Ytz1cynJ;
	Fri, 30 Oct 2026 14:56:12 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id E76374055B;
	Fri, 30 Oct 2026 14:56:20 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemk300013.china.huawei.com
 (7.202.194.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 30 Oct
 2026 14:56:20 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-doc@vger.kernel.org>
CC: <maz@kernel.org>, <oupton@kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <zhengtian10@huawei.com>, <linuxarm@huawei.com>,
	<kristina.martsenko@arm.com>, <pbonzini@redhat.com>, <fuad.tabba@linux.dev>,
	<joey.gouly@arm.com>, <seiden@linux.ibm.com>, <prime.zeng@hisilicon.com>
Subject: [RFC 5/6] KVM: arm64: Conditionally expose ID_AA64MMFR4_EL1.TLBID to guest
Date: Fri, 30 Oct 2026 14:56:16 +0800
Message-ID: <20261030065617.4090073-6-yangjinqian1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20261030065617.4090073-1-yangjinqian1@huawei.com>
References: <20261030065617.4090073-1-yangjinqian1@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300013.china.huawei.com (7.202.194.231)

The TLBID feature bit in ID_AA64MMFR4_EL1 is only advertised to the
guest after userspace configures vDomains via KVM_ARM_VCPU_SET_VDOMAIN,
which sets the guest_tlbid_enabled flag. Until then the bit is masked
to prevent the guest from enabling TLBID without a valid vDomain
affinity.

Exposing the feature would otherwise let the guest read the physical
TLBIDIDR_EL1 directly, so keep that register trapped in the guest
FGT context and served by the emulation added earlier. The host's
own register is never affected.

Expose KVM_REG_ARM_ID_AA64MMFR4_EL1 in the arm64 UAPI header so
userspace can read the sanitised value via KVM_GET_ONE_REG.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/uapi/asm/kvm.h |  2 ++
 arch/arm64/kvm/arm.c              |  2 ++
 arch/arm64/kvm/config.c           | 11 +++++++
 arch/arm64/kvm/sys_regs.c         | 49 +++++++++++++++++++++++++++++--
 arch/arm64/kvm/sys_regs.h         |  6 ++++
 5 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 019e5e3d892e..e54129ed431d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -255,6 +255,8 @@ struct kvm_arm_counter_offset {
 
 #define ARM64_SYS_REG(...) (__ARM64_SYS_REG(__VA_ARGS__) | KVM_REG_SIZE_U64)
 
+#define KVM_REG_ARM_ID_AA64MMFR4_EL1 ARM64_SYS_REG(3, 0, 0, 7, 4)
+
 /* Physical Timer EL0 Registers */
 #define KVM_REG_ARM_PTIMER_CTL		ARM64_SYS_REG(3, 3, 14, 2, 1)
 #define KVM_REG_ARM_PTIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 2, 2)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ddf7c25f9ed9..b5ab89db1c07 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2313,6 +2313,8 @@ static int kvm_arm_vcpu_set_vdomain(struct kvm_vcpu *vcpu,
 
 	kvm_info("vCPU%d: vDomain bitmap: 0x%x\n", vcpu->vcpu_idx, vdomain_bitmap);
 
+	kvm_update_aa64mmfr4_tlbid(vcpu->kvm);
+
 	return 0;
 }
 #else
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 6c116aa1864a..d0402151a752 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1536,6 +1536,17 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 	case HFGRTR2_GROUP:
 		val |= compute_fgu_bits(kvm, &hfgrtr2_desc);
 		val |= compute_fgu_bits(kvm, &hfgwtr2_desc);
+#ifdef CONFIG_KVM_ARM_VTLBID
+		/*
+		 * TLBIDIDR_EL1 must stay trapped even when TLBID is
+		 * exposed to the guest, so it can be emulated with the
+		 * synthesized virtual domain counts. This only affects
+		 * the guest FGT context; the host's own HFGRTR2_EL2 is
+		 * never modified.
+		 */
+		if (kvm->arch.tlbidomain.kvm_tlbid_enabled)
+			val |= HFGRTR2_EL2_nTLBIDIDR_EL1;
+#endif
 		break;
 	case HFGITR2_GROUP:
 		val |= compute_fgu_bits(kvm, &hfgitr2_desc);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cf9804e54ff1..a1ca7309406e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2012,9 +2012,17 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		if (!system_supports_poe())
 			val &= ~ID_AA64MMFR3_EL1_S1POE;
 		break;
-	case SYS_ID_AA64MMFR4_EL1:
+	case SYS_ID_AA64MMFR4_EL1: {
+#ifdef CONFIG_KVM_ARM_VTLBID
+		struct tlbidomain *vdomain = &vcpu->kvm->arch.tlbidomain;
+
+		if (!vdomain->guest_tlbid_enabled)
+			val &= ~ID_AA64MMFR4_EL1_TLBID;
+#else
 		val &= ~ID_AA64MMFR4_EL1_TLBID;
+#endif
 		break;
+	}
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ID_MMFR4_EL1_CCIDX;
 		break;
@@ -3494,7 +3502,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				       ID_AA64MMFR3_EL1_SCTLRX	|
 				       ID_AA64MMFR3_EL1_S1PIE   |
 				       ID_AA64MMFR3_EL1_S1POE)),
-	ID_WRITABLE(ID_AA64MMFR4_EL1, ID_AA64MMFR4_EL1_NV_frac),
+	ID_WRITABLE(ID_AA64MMFR4_EL1, ID_AA64MMFR4_EL1_NV_frac |
+				    ID_AA64MMFR4_EL1_TLBID_MASK),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
 	ID_UNALLOCATED(7,7),
@@ -5495,6 +5504,42 @@ static bool index_to_params(u64 id, struct sys_reg_params *params)
 	}
 }
 
+/*
+ * Update the VM's stored value for an ID register.
+ */
+#ifdef CONFIG_KVM_ARM_VTLBID
+void kvm_update_aa64mmfr4_tlbid(struct kvm *kvm)
+{
+	struct tlbidomain *vdomain = &kvm->arch.tlbidomain;
+	u64 val, tlbid_val;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (kvm_vm_has_ran_once(kvm)) {
+		/*
+		 * ID_AA64MMFR4 is a VM-level register already set during
+		 * the first vCPU init. Skip the write to avoid triggering
+		 * KVM_BUG_ON in kvm_set_vm_id_reg(). The per-vCPU
+		 * vdomain_bitmap is still updated by the caller.
+		 */
+		mutex_unlock(&kvm->arch.config_lock);
+		return;
+	}
+
+	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR4_EL1);
+	tlbid_val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR4_EL1);
+	tlbid_val &= ID_AA64MMFR4_EL1_TLBID_MASK;
+
+	val &= ~ID_AA64MMFR4_EL1_TLBID_MASK;
+	if (vdomain->guest_tlbid_enabled)
+		val |= tlbid_val;
+
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR4_EL1, val);
+
+	mutex_unlock(&kvm->arch.config_lock);
+}
+#endif
+
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num)
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index bd56a45abbf9..0b5487947790 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -252,6 +252,12 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 			 const struct sys_reg_desc table[], unsigned int num);
 
+#ifdef CONFIG_KVM_ARM_VTLBID
+void kvm_update_aa64mmfr4_tlbid(struct kvm *kvm);
+#else
+static inline void kvm_update_aa64mmfr4_tlbid(struct kvm *kvm) { }
+#endif
+
 bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index);
 
 int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu);
-- 
2.33.0

