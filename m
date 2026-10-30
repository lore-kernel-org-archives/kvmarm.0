Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343382;
	b=N5XXCn8WNN+erlCLpCP4S2/HVBY83T+S9vPi+hNNJoBtKx4RpT0AL8bbQq+DfE1daKop
	 O4axNcLWkic8xWJKoOGhG+Y4MaNI5JAFIxeXEdPrYCfnGueuHjLMZhD6cgLkuEURMYzGd
	 mwcZU70Dk4IiilX3GG5w5eV6x5+RXr1bHpnX20z7JJ62BeICA51BoK8UFEj5V/i7JP/Yl
	 pUGITTL7yrMPr31nUpue2nb2PEX5sRzHDyGFwWI9a/alCWFhp1+No07HIbXwLwiarq16B
	 t6hHWHyWLtmET2QvOUXx4S8a0LK0li0TIoE3C3Gas3mYsBbURhujo9FSRnM0u2cy2Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343382;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=xp7cbfuJRPCrhAUq7HMqvlSWwn8abvANab2dTt+OUNU=;
	b=D2AU8VESbCJPMTUu0ycKafDG+kz6x3fbSj9oJ1MuJHMtXFISoYDjBwrQA5XbJ+wFs6l0
	 7VQZwe1OkYlCcgRL1x1vKO/T1basI97BAZZ/ceTycjOBVkLUezeUEaFbZxvXkkx0oga4c
	 kDZb1KD19C14VOAb9M3ik1NWWL0i3JikVRfsLzqaoS7fqI+sNUzGj1TwwZykcqii6YkLT
	 yrR8GAsWOfLbFBSaV4DmzxAUOkEYHryZHid1tkBB1k+tbHjEKj09ugNFez5QclgEoeo1D
	 7tLp6ZkUh2uUNZe6A0A4GhUh+BxgDF4cXWdMPKjavh+vRW9vwZ8FCfX2XwJ6Re7iS6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=M47wRBge;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC0606A31E
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 06:56:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8AC0606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=M47wRBge
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xp7cbfuJRPCrhAUq7HMqvlSWwn8abvANab2dTt+OUNU=;
	b=M47wRBge92zdTDsngHc8gXmA4K1vtE7/LIfPnECXHj8BmyvCQkOOrN5yvhFraV6rLk4dfIg+E
	oqqtnLAkpEA0p57D2X7p5mcGYyNIEvx9Q8ALVNoMMAm6niuOt3/h1iFSr2o0ewcVp/5R2Jt55NE
	XZyRsE7fS0orMrPvVB/IKJU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jGBhV5nb2z1cyTP;
	Fri, 30 Oct 2026 14:56:10 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id B2B7A4057A;
	Fri, 30 Oct 2026 14:56:18 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemk300013.china.huawei.com
 (7.202.194.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 30 Oct
 2026 14:56:17 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-doc@vger.kernel.org>
CC: <maz@kernel.org>, <oupton@kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <zhengtian10@huawei.com>, <linuxarm@huawei.com>,
	<kristina.martsenko@arm.com>, <pbonzini@redhat.com>, <fuad.tabba@linux.dev>,
	<joey.gouly@arm.com>, <seiden@linux.ibm.com>, <prime.zeng@hisilicon.com>
Subject: [RFC 1/6] KVM: arm64: Introduce TLBID virtualization infrastructure
Date: Fri, 30 Oct 2026 14:56:12 +0800
Message-ID: <20261030065617.4090073-2-yangjinqian1@huawei.com>
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

struct tlbidomain, embedded in kvm_arch, holds the per-VM vTLBID
state; kvm_arm_init_tlbidomain()/free_tlbid_vdomain() manage it over
the VM lifetime, and kvm_arm_tlbidomain_vcpu_init() defaults each
vCPU to vDomain0.

The UAPI adds three interfaces: KVM_CAP_ARM_TLBIDOMAIN lets userspace
probe the feature, KVM_ARM_GET_VDOMAIN_NUM returns the number of
vDomains available to the VM, and KVM_ARM_VCPU_SET_VDOMAIN sets each
vCPU's vDomain membership bitmap. All three are documented in
Documentation/virt/kvm/api.rst.

The feature is VHE-only: VTLBIDn_EL2 cannot be written from EL1.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 Documentation/virt/kvm/api.rst    |  59 ++++++++
 arch/arm64/include/asm/kvm_host.h |  55 +++++++
 arch/arm64/kvm/Kconfig            |  12 ++
 arch/arm64/kvm/arm.c              | 241 +++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h          |  14 ++
 5 files changed, 380 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e0430cc750c9..d8a2854e32b1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6665,6 +6665,49 @@ significant bit):
 
 .. _kvm_run:
 
+4.146 KVM_ARM_GET_VDOMAIN_NUM
+------------------------------
+
+:Capability: KVM_CAP_ARM_TLBIDOMAIN
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct kvm_arm_get_vdomain (out)
+:Returns: 0 on success, < 0 on error
+
+Parameters are specified via the following structure::
+
+	struct kvm_arm_get_vdomain {
+		__u8 max_vdomains;
+	};
+
+The ``max_vdomains`` field is the maximum number of vDomains supported
+by the virtual TLBID implementation. This value is derived from
+TLBIDIDR_EL1.NVIS and is capped at 32.
+
+4.147 KVM_ARM_VCPU_SET_VDOMAIN
+------------------------------
+
+:Capability: KVM_CAP_ARM_TLBIDOMAIN
+:Architectures: arm64
+:Type: vcpu ioctl
+:Parameters: struct kvm_arm_set_vdomain (in)
+:Returns: 0 on success, < 0 on error
+
+This ioctl allows KVM to obtain TLBI Domain of Guest.
+
+Parameters are specified via the following structure::
+
+	struct kvm_arm_set_vdomain {
+		__u32 vdomain_bitmap;
+		__u8 num_vdomains;
+	};
+
+The ``vdomain_bitmap`` field is a bitmap, where '1' indicates that vDomain
+includes this vCPU. For example, ``vCPU0:  vdomain_bitmap=0b1011`` indicates
+that vCPU0 included in vDomain(0, 1, 3).
+
+The ``num_vdomains`` field is the number of vDomains.
+
 5. The kvm_run structure
 ========================
 
@@ -9056,6 +9099,22 @@ enabled, cmma can't be enabled anymore and pfmfi and the storage key
 interpretation are disabled. If cmma has already been enabled or the
 hpage_2g module parameter is not set to 1, -EINVAL is returned.
 
+7.48 KVM_CAP_ARM_TLBIDOMAIN
+-------------------------------------
+
+:Architectures: arm64
+:Target: VM
+:Parameters: None
+:Returns: 0 on success, negative value on error
+
+This capability enables TLBID virtualization, which optimizes tlbi broadcast
+range to avoid unnecessary broadcasts.
+
+When this capability is enabled, KVM can obtain the vDomain bitmaps of VM. When
+a vCPU is loaded, KVM writes the mapping between the vDomain and the pDomain
+into the VTLBID(n). If guest enabled TLBID, hardware will convert vDomain id to
+pDomain id for TLBI broadcast.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7..1e19e197d736 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -55,6 +55,7 @@
 #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
 #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
+#define KVM_REQ_RELOAD_VTLBID	KVM_ARCH_REQ(12)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
@@ -306,6 +307,56 @@ enum fgt_group_id {
 	__NR_FGT_GROUP_IDS__
 };
 
+#define NIS_RANGE_MIN_1_8 1
+#define NIS_RANGE_MAX_1_8 8
+#define NIS_RANGE_MIN_9_16 9
+#define NIS_RANGE_MAX_9_16 16
+#define VTLBID_TD_WIDTH_NIS_1_8 8
+#define VTLBID_TD_WIDTH_NIS_9_16 16
+#define VTLBID_EL2_WIDTH 64
+/*
+ * Cap the supported NVIS so per-vDomain bitmaps have a compile-time
+ * upper bound; the hardware field itself is 5 bits wide.
+ */
+#define KVM_VTLBID_MAX_NVIS		5
+#define KVM_VTLBID_MAX_VDOMAINS		BIT(KVM_VTLBID_MAX_NVIS)
+
+struct vcpu_tlbid_data {
+	/* Node in per-pCPU vCPU list of tlbidomain */
+	struct list_head pcpu_node;
+	/* Store vDomain bitmap, indexed by vCPU ID */
+	u32 vdomain_bitmap;
+	/* Record the last pCPU where vCPU was running, indexed by vCPU ID */
+	int last_pcpu;
+};
+
+struct tlbidomain {
+	/* Using xarray to dynamically allocate vCPU-related TLBID info */
+	struct xarray vcpu_data_array;
+	/* The number of vDomains */
+	int num_domains;
+	/* Number of vDomains representable in the VTLBIDn registers */
+	int max_vdomains;
+	/* Mapping of pDomain to vDomain, indexed by vDomain ID */
+	int *domain_map;
+	/* Record the bitmap of pCPUs mapped to vDomain, indexed by vDomain ID */
+	cpumask_var_t *vdomain_cpumasks;
+	/* Whether virt-TLBID is enabled by KVM */
+	bool kvm_tlbid_enabled;
+	/* Whether virt-TLBID is enabled by Guest */
+	bool guest_tlbid_enabled;
+	/* TLBIDIDR.NVIS */
+	u8 nvis;
+	/* TLBIDIDR.NIS */
+	u8 nis;
+	/* Guest-visible TLBIDIDR value (NIS/NOS carry virtual domain counts) */
+	u64 tlbididr_val;
+	/* Used to prevent concurrent modifications to the domain mapping. */
+	spinlock_t tlbid_lock;
+	/* Per-pCPU list of vCPUs whose last_pcpu equals this pCPU */
+	struct list_head *pcpu_vcpu_list;
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -427,6 +478,10 @@ struct kvm_arch {
 	/* Nested virtualization info */
 	struct dentry *debugfs_nv_dentry;
 #endif
+
+#ifdef CONFIG_KVM_ARM_VTLBID
+	struct tlbidomain tlbidomain;
+#endif
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..c54ce82d31fc 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -104,4 +104,16 @@ config PKVM_STACKTRACE
 
 endif # NVHE_EL2_DEBUG
 endif # KVM
+config KVM_ARM_VTLBID
+	bool "Virtual TLBID support for KVM guests"
+	depends on KVM && ARM64_TLBID
+	default n
+	help
+	  Enable virtualization of FEAT_TLBID so that each KVM guest can
+	  use TLBI Domains independently of the host. The host TLBID
+	  hardware is partitioned per-VM through VTLBID_EL2 registers
+	  managed on the vCPU load/put path.
+
+	  If unsure, say N.
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90..7292e3e0ec1c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -214,6 +214,119 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }
 
+#ifdef CONFIG_KVM_ARM_VTLBID
+static int kvm_arm_init_tlbidomain(struct kvm *kvm)
+{
+	struct tlbidomain *vdomain = &kvm->arch.tlbidomain;
+	int i, max_vdomains, pdomain_bits;
+	u64 tlbididr;
+
+	if (!system_supports_tlbid() || !has_vhe())
+		return 0;
+
+	tlbididr = read_sanitised_ftr_reg(SYS_TLBIDIDR_EL1);
+
+	vdomain->nis = FIELD_GET(TLBIDIDR_EL1_NIS_MASK, tlbididr);
+	vdomain->nvis = min_t(u8, FIELD_GET(TLBIDIDR_EL1_NVIS_MASK, tlbididr),
+			      KVM_VTLBID_MAX_NVIS);
+	vdomain->num_domains = -1;
+	/*
+	 * The four VTLBIDn registers hold at most 4 * 64 / pdomain_bits
+	 * vDomain fields. Disable vTLBID altogether when NIS is outside
+	 * the supported ranges (no useful ISH domains).
+	 */
+	if (vdomain->nis >= NIS_RANGE_MIN_1_8 && vdomain->nis <= NIS_RANGE_MAX_1_8)
+		pdomain_bits = VTLBID_TD_WIDTH_NIS_1_8;
+	else if (vdomain->nis >= NIS_RANGE_MIN_9_16 && vdomain->nis <= NIS_RANGE_MAX_9_16)
+		pdomain_bits = VTLBID_TD_WIDTH_NIS_9_16;
+	else
+		return 0;
+	max_vdomains = min_t(int, 1 << vdomain->nvis,
+			     4 * VTLBID_EL2_WIDTH / pdomain_bits);
+	vdomain->max_vdomains = max_vdomains;
+
+	kvm_info("TLBIDIDR: 0x%llx, NIS: %d, NVIS: %d\n", tlbididr, vdomain->nis, vdomain->nvis);
+
+	xa_init(&vdomain->vcpu_data_array);
+
+	vdomain->domain_map = kcalloc(max_vdomains, sizeof(*vdomain->domain_map),
+				      GFP_KERNEL);
+	if (!vdomain->domain_map)
+		goto destroy_vcpu_data_array;
+
+	vdomain->vdomain_cpumasks = kcalloc(max_vdomains,
+					    sizeof(cpumask_var_t),
+					    GFP_KERNEL);
+	if (!vdomain->vdomain_cpumasks)
+		goto free_domain_map;
+
+	for (i = 0; i < max_vdomains; i++) {
+		if (!alloc_cpumask_var(&vdomain->vdomain_cpumasks[i], GFP_KERNEL))
+			goto free_vdomain_cpumasks;
+		cpumask_clear(vdomain->vdomain_cpumasks[i]);
+	}
+
+	for (i = 0; i < max_vdomains; i++)
+		vdomain->domain_map[i] = -1;
+
+	spin_lock_init(&vdomain->tlbid_lock);
+
+	vdomain->pcpu_vcpu_list = kcalloc(nr_cpu_ids,
+					  sizeof(*vdomain->pcpu_vcpu_list),
+					  GFP_KERNEL);
+	if (!vdomain->pcpu_vcpu_list)
+		goto free_vdomain_cpumasks;
+
+	for (i = 0; i < nr_cpu_ids; i++)
+		INIT_LIST_HEAD(&vdomain->pcpu_vcpu_list[i]);
+
+	/* Enable vTLBID only after all resources are allocated. */
+	vdomain->kvm_tlbid_enabled = true;
+
+	return 0;
+
+free_vdomain_cpumasks:
+	while (--i >= 0)
+		free_cpumask_var(vdomain->vdomain_cpumasks[i]);
+	kfree(vdomain->vdomain_cpumasks);
+free_domain_map:
+	kfree(vdomain->domain_map);
+destroy_vcpu_data_array:
+	xa_destroy(&vdomain->vcpu_data_array);
+
+	kvm_err("vTLBID init failed with -ENOMEM, feature disabled\n");
+	return -ENOMEM;
+}
+
+static void free_tlbid_vdomain(struct kvm *kvm)
+{
+	struct tlbidomain *vdomain = &kvm->arch.tlbidomain;
+	struct vcpu_tlbid_data *data;
+	int i, max_vdomains;
+	unsigned long index;
+
+	if (!vdomain->kvm_tlbid_enabled)
+		return;
+
+	max_vdomains = vdomain->max_vdomains;
+
+	kfree(vdomain->domain_map);
+
+	for (i = 0; i < max_vdomains; i++)
+		free_cpumask_var(vdomain->vdomain_cpumasks[i]);
+	kfree(vdomain->vdomain_cpumasks);
+
+	kfree(vdomain->pcpu_vcpu_list);
+
+	xa_for_each(&vdomain->vcpu_data_array, index, data)
+		kfree(data);
+	xa_destroy(&vdomain->vcpu_data_array);
+}
+#else
+static inline int kvm_arm_init_tlbidomain(struct kvm *kvm) { return 0; }
+static inline void free_tlbid_vdomain(struct kvm *kvm) { }
+#endif
+
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -276,6 +389,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
 
+	kvm_arm_init_tlbidomain(kvm);
+
 	return 0;
 
 err_uninit_mmu:
@@ -332,6 +447,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_uninit_stage2_mmu(kvm);
 	kvm_destroy_mpidr_data(kvm);
 
+	free_tlbid_vdomain(kvm);
+
 	kfree(kvm->arch.sysreg_masks);
 	kvm_destroy_vcpus(kvm);
 
@@ -1731,6 +1848,52 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+#ifdef CONFIG_KVM_ARM_VTLBID
+static int kvm_arm_tlbidomain_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	struct tlbidomain *vdomain;
+	struct vcpu_tlbid_data *data;
+	int ret;
+
+	if (!system_supports_tlbid())
+		return 0;
+
+	data = kzalloc_obj(*data, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/*
+	 * When the host has enabled TLBID but the guest has not,
+	 * KVM can map vDomain0 to pDomainN to optimize the TLBI
+	 * instructions for the guest. Therefore, the value is set
+	 * to 0x1, indicating that the vCPU is in vDomain0. If QEMU
+	 * calls KVM_ARM_VCPU_SET_VDOMAIN to configure vdomains, this
+	 * value will be overwritten to support the guest enabling
+	 * TLBID.
+	 */
+	data->vdomain_bitmap = 0x1;
+	data->last_pcpu = -1;
+	INIT_LIST_HEAD(&data->pcpu_node);
+
+	vdomain = &vcpu->kvm->arch.tlbidomain;
+	if (!vdomain->kvm_tlbid_enabled) {
+		kfree(data);
+		return 0;
+	}
+
+	ret = xa_insert(&vdomain->vcpu_data_array,
+			vcpu->vcpu_idx, data, GFP_KERNEL);
+	if (ret) {
+		kfree(data);
+		return ret == -EBUSY ? 0 : ret;
+	}
+
+	return 0;
+}
+#else
+static inline int kvm_arm_tlbidomain_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
+#endif
+
 static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 					 struct kvm_vcpu_init *init)
 {
@@ -1781,7 +1944,9 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 
 	spin_unlock(&vcpu->arch.mp_state_lock);
 
-	return 0;
+	ret = kvm_arm_tlbidomain_vcpu_init(vcpu);
+
+	return ret;
 }
 
 static int kvm_arm_vcpu_set_attr(struct kvm_vcpu *vcpu,
@@ -1852,6 +2017,59 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	return __kvm_arm_vcpu_set_events(vcpu, events);
 }
 
+#ifdef CONFIG_KVM_ARM_VTLBID
+static int kvm_arm_vcpu_set_vdomain(struct kvm_vcpu *vcpu,
+				    struct kvm_arm_set_vdomain *vdomain)
+{
+	struct tlbidomain *td = &vcpu->kvm->arch.tlbidomain;
+	u32 vdomain_bitmap = vdomain->vdomain_bitmap;
+	u8 num_vdomains = vdomain->num_vdomains;
+	struct vcpu_tlbid_data *data;
+
+	if (!td->kvm_tlbid_enabled)
+		return -EINVAL;
+
+	/*
+	 * The guest-visible ID registers and the FGU masks are frozen on
+	 * the first vCPU run; configuring vDomains afterwards would be
+	 * silently ineffective.
+	 */
+	if (kvm_vm_has_ran_once(vcpu->kvm))
+		return -EBUSY;
+
+	if (num_vdomains > td->max_vdomains)
+		return -EINVAL;
+
+	if (td->num_domains != -1 && td->num_domains != num_vdomains)
+		return -EINVAL;
+
+	if (num_vdomains < 32 && (vdomain_bitmap >> num_vdomains))
+		return -EINVAL;
+
+	data = xa_load(&td->vcpu_data_array, vcpu->vcpu_idx);
+	if (!data) {
+		kvm_err("vCPU%d: Failed to load vcpu_tlbid_data\n", vcpu->vcpu_idx);
+		return -EINVAL;
+	}
+
+	spin_lock(&td->tlbid_lock);
+	data->vdomain_bitmap = vdomain_bitmap;
+	td->num_domains = num_vdomains;
+	td->guest_tlbid_enabled = true;
+	spin_unlock(&td->tlbid_lock);
+
+	kvm_info("vCPU%d: vDomain bitmap: 0x%x\n", vcpu->vcpu_idx, vdomain_bitmap);
+
+	return 0;
+}
+#else
+static inline int kvm_arm_vcpu_set_vdomain(struct kvm_vcpu *vcpu,
+					   struct kvm_arm_set_vdomain *vdomain)
+{
+	return -EINVAL;
+}
+#endif
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -2031,6 +2249,27 @@ static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	}
 }
 
+#ifdef CONFIG_KVM_ARM_VTLBID
+static int kvm_arm_get_vdomain_num(struct kvm *kvm,
+				   struct kvm_arm_get_vdomain *vdomain)
+{
+	struct tlbidomain *td = &kvm->arch.tlbidomain;
+
+	if (!td->kvm_tlbid_enabled)
+		return -EINVAL;
+
+	vdomain->max_vdomains = td->max_vdomains;
+
+	return 0;
+}
+#else
+static inline int kvm_arm_get_vdomain_num(struct kvm *kvm,
+					  struct kvm_arm_get_vdomain *vdomain)
+{
+	return -EINVAL;
+}
+#endif
+
 int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac2d77d14963..030c76f1689e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -999,6 +999,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_HPAGE_2G 249
 #define KVM_CAP_PPC_COMPAT_CAPS 250
 #define KVM_CAP_ARM_PMU_V3_STRICT 251
+#define KVM_CAP_ARM_TLBIDOMAIN 252
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1674,4 +1675,17 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+struct kvm_arm_get_vdomain {
+	__u8 max_vdomains;
+};
+
+#define KVM_ARM_GET_VDOMAIN_NUM	_IOR(KVMIO, 0xd7, struct kvm_arm_get_vdomain)
+
+struct kvm_arm_set_vdomain {
+	__u32 vdomain_bitmap;
+	__u8 num_vdomains;
+};
+
+#define KVM_ARM_VCPU_SET_VDOMAIN	_IOW(KVMIO, 0xd8, struct kvm_arm_set_vdomain)
+
 #endif /* __LINUX_KVM_H */
-- 
2.33.0

