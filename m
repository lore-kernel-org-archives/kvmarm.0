Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05C141D239;
	Fri, 24 Jul 2026 09:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784886175; cv=none; b=puHHNk6HJEOq0RuNlstP70XTxjk1EAIIm5u2LvgyhvwwPcXsp92XJN1moVRNN78Rs2dryATxpD44SIggUVMfapXg87+3h3l5aHAfER0HgXcLG51EtUjDJIorerFoarg71qiKythViYFr+yHVn0eCy8ZbbBHPFGoeudydXEaf/7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784886175; c=relaxed/simple;
	bh=p1rp+6y9WsV1qwRzPxc+AFIXKMN/BKdCcEqoP5V1DWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhEPgwDY9kkWNvyOKQ4S01IWzsNSR0IN8ETNUj8rw2BtKWgwqUs0Zt4A2NNwEJ5UD/Nyk06JW5XroNa94RdY+cvsZtYscGZxHWMY3bKOwR3lrbLjt63D0QDmokC3QCUQoRbTN6erkIZ1JUU5HO3jlAIzeV2xeVeNmTRQ5vukHfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=aYftdanJ; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="aYftdanJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1784886174; x=1816422174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p1rp+6y9WsV1qwRzPxc+AFIXKMN/BKdCcEqoP5V1DWo=;
  b=aYftdanJtdFPaOQtU8U5ltwK5mvSzltCAQ4Jcjoa2smm2Q5sDuXdCd9C
   V/6kqEbmXE0Bz6tw9ME4gZEMjYNLNsXMpWGSZ7A8EXricqg6C/jnKBDxA
   rnTHtJUlaIsNMNFMzG5zv1w32dxDAKQ5WftQXV9XxhU6hXGIv1UYa6VuG
   sk8EwItU1HdXF9yvn1hIH3WRkGErdUm/Z0C89tqIVKvluYZuzh5wE71vd
   qsgONIClGZO2n4h5Uc/4F0AQ9L6kGSju0d2mXOzlJXyGLgHapCo+OweEG
   aKsDMxaSnQp7nXCY8uotmjd/cfp8G3j8Fa+rbSYUxcuFDHOB3L8uaCoel
   Q==;
X-CSE-ConnectionGUID: klB0TaGkSYCnG6QVQeavFA==
X-CSE-MsgGUID: 4Ca5Klj4SeWP9dHy3vxeIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="252021175"
X-IronPort-AV: E=Sophos;i="6.25,182,1779116400"; 
   d="scan'208";a="252021175"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 18:41:45 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 0E5AD3D1B;
	Fri, 24 Jul 2026 09:41:45 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id B46EC10214F0;
	Fri, 24 Jul 2026 09:41:44 +0000 (UTC)
Received: from sm-arm-grace07.ssoft.mng.com (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id ECB8A405AB7;
	Fri, 24 Jul 2026 09:41:38 +0000 (UTC)
From: Kohei Enju <enju.kohei@fujitsu.com>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-coco@lists.linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Steven Price <steven.price@arm.com>,
	Kohei Enju <enju.kohei@fujitsu.com>
Subject: [RFC PATCH v1 1/2] KVM: arm64: CCA: Add support for configuring the Realm MEC policy
Date: Fri, 24 Jul 2026 18:40:55 +0900
Message-ID: <20260724094120.166536-2-enju.kohei@fujitsu.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724094120.166536-1-enju.kohei@fujitsu.com>
References: <20260724094120.166536-1-enju.kohei@fujitsu.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the KVM_ARM_RMI_CONFIG ioctl to allow userspace to configure
Realm VM parameters before the Realm is created.

Currently, ARM_RMI_CFG_MEC_POLICY is the only supported configuration
item. Its value can be ARM_RMI_MEC_POLICY_SHARED or
ARM_RMI_MEC_POLICY_PRIVATE. Reject the private policy if the platform
does not support private MECs.

If userspace does not explicitly configure the MEC policy,
ARM_RMI_MEC_POLICY_SHARED is used by default.

Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
---
 Documentation/virt/kvm/api.rst   | 29 +++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_rmi.h |  4 ++++
 arch/arm64/kvm/arm.c             |  9 +++++++++
 arch/arm64/kvm/rmi.c             | 29 +++++++++++++++++++++++++++++
 drivers/firmware/arm_rmm/rmi.c   |  8 ++++++--
 include/linux/arm-rmi-cmds.h     |  1 +
 include/uapi/linux/kvm.h         | 17 +++++++++++++++++
 7 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85bec9b4f021..e1c660e5eb34 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6690,6 +6690,35 @@ populated data is hashed and added to the guest's Realm Initial Measurement
 (RIM) stored by the RMM. This can then be retrieved by the guest (using the RSI
 interface) to present to an attestation server.
 
+4.147 KVM_ARM_RMI_CONFIG
+------------------------
+
+:Capability: KVM_CAP_ARM_RMI
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct kvm_arm_rmi_config (in)
+:Returns: 0 on success, < 0 on error
+
+::
+
+  struct kvm_arm_rmi_config {
+       __u32 cfg;
+       union {
+               /* cfg == ARM_RMI_CFG_MEC_POLICY */
+               __u8 mec_policy;
+
+               /* Fix the size of the union */
+               __u8 reserved[256];
+       };
+  };
+
+Configures parameters of a Realm VM before the Realm is created.
+
+Currently, `ARM_RMI_CFG_MEC_POLICY` is the only supported configuration item.
+`mec_policy` must be either `ARM_RMI_MEC_POLICY_SHARED` or
+`ARM_RMI_MEC_POLICY_PRIVATE`. `ARM_RMI_MEC_POLICY_PRIVATE` is not supported if
+no private MEC is available on the platform.
+
 .. _kvm_run:
 
 5. The kvm_run structure
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 420e99fca07e..721033b132e1 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -60,6 +60,7 @@ enum realm_state {
  * @ia_bits: Number of valid Input Address bits in the IPA
  * @stage2_unmapped: The Realm stage-2 mappings have been removed
  * @rtts_destroyed: The non-root RTTs have been torn down
+ * @mec_policy: MEC policy for the Realm VM
  */
 struct realm {
 	void *rd;
@@ -76,6 +77,7 @@ struct realm {
 	unsigned int ia_bits;
 	bool stage2_unmapped;
 	bool rtts_destroyed;
+	unsigned int mec_policy;
 };
 
 /**
@@ -115,6 +117,8 @@ struct kvm_arm_rmi_populate;
 
 int kvm_arm_rmi_populate(struct kvm *kvm,
 			 struct kvm_arm_rmi_populate *arg);
+struct kvm_arm_rmi_config;
+int kvm_arm_rmi_config(struct kvm *kvm, struct kvm_arm_rmi_config *arg);
 void kvm_realm_unmap_range(struct kvm *kvm,
 			   unsigned long ipa,
 			   unsigned long size,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3862db30779f..17302ba2844c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2169,6 +2169,15 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			return -EFAULT;
 		return ret;
 	}
+	case KVM_ARM_RMI_CONFIG: {
+		struct kvm_arm_rmi_config cfg;
+
+		if (!kvm_is_realm(kvm))
+			return -ENXIO;
+		if (copy_from_user(&cfg, argp, sizeof(cfg)))
+			return -EFAULT;
+		return kvm_arm_rmi_config(kvm, &cfg);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 06cc85fb5092..629dea5e8c47 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -572,6 +572,9 @@ static int realm_create_rd(struct kvm *kvm)
 	if (kvm_lpa2_is_enabled())
 		params->flags0 |= RMI_REALM_PARAM_FLAG_LPA2;
 
+	params->flags0 |= FIELD_PREP(RMI_REALM_PARAM_FLAG_MEC_POLICY,
+				     realm->mec_policy);
+
 	r = realm_init_sve_param(kvm, params);
 	if (r)
 		goto out_undelegate_tables;
@@ -1155,6 +1158,30 @@ int kvm_arm_rmi_populate(struct kvm *kvm,
 	return ret;
 }
 
+int kvm_arm_rmi_config(struct kvm *kvm, struct kvm_arm_rmi_config *cfg)
+{
+	guard(mutex)(&kvm->arch.config_lock);
+
+	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
+		return -EBUSY;
+
+	switch (cfg->cfg) {
+	case ARM_RMI_CFG_MEC_POLICY:
+		if (cfg->mec_policy != ARM_RMI_MEC_POLICY_SHARED &&
+		    cfg->mec_policy != ARM_RMI_MEC_POLICY_PRIVATE)
+			return -EINVAL;
+
+		if (cfg->mec_policy == ARM_RMI_MEC_POLICY_PRIVATE &&
+		    rmi_mec_count() == 0)
+			return -EOPNOTSUPP;
+
+		kvm->arch.realm.mec_policy = cfg->mec_policy;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1474,6 +1501,8 @@ int kvm_init_realm(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
 
+	realm->mec_policy = ARM_RMI_MEC_POLICY_SHARED;
+
 	realm->params = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	realm->sro = kmalloc_obj(*realm->sro);
 	if (!realm->params || !realm->sro) {
diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index d0c083bdf251..e9632c35e7db 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -14,8 +14,7 @@
 
 static bool arm64_rmi_is_available;
 
-/* Currently only the first 2 registers are used by Linux */
-#define RMI_FEAT_REG_COUNT	2
+#define RMI_FEAT_REG_COUNT	5
 static __ro_after_init unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT];
 
 unsigned long rmi_feat_reg(unsigned long id)
@@ -27,6 +26,11 @@ unsigned long rmi_feat_reg(unsigned long id)
 }
 EXPORT_SYMBOL_GPL(rmi_feat_reg);
 
+u64 rmi_mec_count(void)
+{
+	return u64_get_bits(rmi_feat_reg(4), RMI_FEATURE_REGISTER_4_MEC_COUNT);
+}
+
 int rmi_delegate_range(phys_addr_t phys,
 		       unsigned long size,
 		       phys_addr_t *out_phys)
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 138983ab4e3c..5236600421c6 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -28,6 +28,7 @@ struct rmi_sro_state {
 };
 
 unsigned long rmi_feat_reg(unsigned long id);
+u64 rmi_mec_count(void);
 
 int rmi_delegate_range(phys_addr_t phys, unsigned long size,
 		       phys_addr_t *out_phys);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index adee3936d6ae..46e62327957c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1704,4 +1704,21 @@ struct kvm_arm_rmi_populate {
 	__u32 reserved;
 };
 
+#define KVM_ARM_RMI_CONFIG     _IOW(KVMIO, 0xd8, struct kvm_arm_rmi_config)
+
+#define ARM_RMI_CFG_MEC_POLICY		0
+#define ARM_RMI_MEC_POLICY_SHARED	0
+#define ARM_RMI_MEC_POLICY_PRIVATE	1
+
+struct kvm_arm_rmi_config {
+	__u32 cfg;
+	union {
+		/* cfg == ARM_RMI_CFG_MEC_POLICY */
+		__u8 mec_policy;
+
+		/* Reserve space for future configuration payloads. */
+		__u8 reserved[256];
+	};
+};
+
 #endif /* __LINUX_KVM_H */
-- 
2.43.0

