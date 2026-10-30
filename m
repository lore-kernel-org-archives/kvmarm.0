Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343384;
	b=0IhTdOZnjQdIjjXJcKw5NCU3fzWfBfb7biPQF9G2rNkAJtPJTrYCv37qVY8HCK9f2tnb
	 nmHF3RffjIvgcXk0tU/FEOdEta2JW00wOy7bqkHinarr7WTjB49UhZPEcIL8cA3bEkIo0
	 HTgqBwkf+1XlWfmjeVZg5BJrZnCMLs5nQeMxvPtuaNZhBld5061WoF33O0azBrT8lOoK7
	 zsyvj4PZUUHRpt1Ol8y/G9LWWLXwwKhQp+4mkNKbidtdyrpXx40VfiIUtUHJ8v1Oh9r8W
	 IfU7KwEY4OLcMoeJwi2eZ28rOzAt9YoyS2jeENs34ljMvPnwKLlrJzGXaZ9OWQaoCCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343384;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=EL8a4MeYH+m0ZVW8u6F5ZtSMCbhlmxJcf6tss3m07Sc=;
	b=owpYfD1MNP+OzXdj9kQR7ZfXbEgPEvBgRCCqLmw8wY74tu7qlFCwtSp2ujbUwyM0RK0a
	 Zd1dXIhdUGWrhkKSIY3WnmlURmlnmRmW9hHNtRfHdvAi4TgNhNFI9SZ4wkNHyaSVApT69
	 D9Fn4CG2p1/o4QCoypnKKNLkj/kqvVn8vNNe+aAPn0vkT4DKJ9wfYMdp1+Qliq/PzjdYY
	 u87trg1B60lI7B0S7VUdE4Ylr90y91xexITw9m8rdQUQRz5p+Kf2/MIRpl0A9MaWU5QDE
	 o00ZeVJ0lUrBJfqrqYodKjM56o8MB7V0EDPPMSTAAFpnBX9hsGQEc7Y439L9W9DC9Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=rAXUhPLB;
	arc=none smtp.remote-ip=113.46.200.219
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845DE606A31F
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 06:56:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 845DE606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=rAXUhPLB
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EL8a4MeYH+m0ZVW8u6F5ZtSMCbhlmxJcf6tss3m07Sc=;
	b=rAXUhPLBPQ0CXi2c8w4ZCr4EFSuGAuHVS+iAn4Srfb9KWFhzhaI4M0VAXhBc0wCwyO5j/g+MP
	OtQUWSzL4okdIAvHDlehEB2uoYLv0qghB3FCywmNpMHDlgaRXE4N+n0Z8NEt/c3BL4HxAKQclDx
	FjzprqQjpriRKH0RYjZBm8E=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jGBhd4wQpz1prnJ;
	Fri, 30 Oct 2026 14:56:17 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A70C202E6;
	Fri, 30 Oct 2026 14:56:19 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemk300013.china.huawei.com
 (7.202.194.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 30 Oct
 2026 14:56:18 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-doc@vger.kernel.org>
CC: <maz@kernel.org>, <oupton@kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <zhengtian10@huawei.com>, <linuxarm@huawei.com>,
	<kristina.martsenko@arm.com>, <pbonzini@redhat.com>, <fuad.tabba@linux.dev>,
	<joey.gouly@arm.com>, <seiden@linux.ibm.com>, <prime.zeng@hisilicon.com>
Subject: [RFC 2/6] KVM: arm64: Add VTLBID sysregs and update VTLBID(n) on vCPU load
Date: Fri, 30 Oct 2026 14:56:13 +0800
Message-ID: <20261030065617.4090073-3-yangjinqian1@huawei.com>
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

kvm_tlbidomain_vcpu_load()/kvm_tlbidomain_vcpu_put() maintain the
per-vCPU domain map and reprogram the VTLBIDn registers on vCPU
schedule-in. On first load or migration, each vDomain's CPU set is
recomputed and mapped to the smallest physical domain containing it,
and KVM_REQ_RELOAD_VTLBID makes the other vCPUs reprogram their
registers after a map change.

HCRX_EL2.VTLBIDEn is only set for VMs with vTLBID enabled, so the
host never runs with vTLBID translation active.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  10 +-
 arch/arm64/include/asm/mmu.h         |   2 +
 arch/arm64/kvm/arm.c                 | 239 +++++++++++++++++++++++++++
 arch/arm64/mm/tlbid.c                |  32 ++++
 4 files changed, 280 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 306e51fce221..75fe3f9169f8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -735,9 +735,13 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 			}
 		}
 
-		if (cpus_have_final_cap(ARM64_HAS_TLBID))
-			vcpu->arch.hcrx_el2 |= (HCRX_EL2_VTLBIDEn |
-						HCRX_EL2_VTLBIDOSEn);
+		if (cpus_have_final_cap(ARM64_HAS_TLBID)) {
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_VTLBIDOSEn;
+#ifdef CONFIG_KVM_ARM_VTLBID
+			if (vcpu->kvm->arch.tlbidomain.kvm_tlbid_enabled)
+				vcpu->arch.hcrx_el2 |= HCRX_EL2_VTLBIDEn;
+#endif
+		}
 
 	}
 }
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index ae43a91ddabc..c68c35bfe09b 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -112,11 +112,13 @@ int init_tlbid_context(struct mm_struct *mm);
 void destroy_tlbid_context(struct mm_struct *mm);
 void update_tlbid_domains(struct mm_struct *mm, unsigned int cpu);
 u16 get_tlbid_domain(struct mm_struct *mm);
+int tlbid_pick_domain(const struct cpumask *active_cpus);
 #else
 static inline int init_tlbid_context(struct mm_struct *mm) { return 0; }
 static inline void destroy_tlbid_context(struct mm_struct *mm) {}
 static inline void update_tlbid_domains(struct mm_struct *mm, unsigned int cpu) {}
 static inline u16 get_tlbid_domain(struct mm_struct *mm) { return 0; }
+static inline int tlbid_pick_domain(const struct cpumask *active_cpus) { return 0; }
 #endif
 
 #endif	/* !__ASSEMBLER__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7292e3e0ec1c..809d33b8e5be 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -779,6 +779,240 @@ static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
 	return single_task_running();
 }
 
+#ifdef CONFIG_KVM_ARM_VTLBID
+static bool is_vcpu_in_vdomain(u32 vdomain_bitmap, int vdomain_idx)
+{
+	return vdomain_bitmap & BIT(vdomain_idx);
+}
+
+static int update_domain_map(struct kvm_vcpu *vcpu, int vdomain_idx,
+			     int last_pcpu, bool clear_flag)
+{
+	struct tlbidomain *vdomain = &vcpu->kvm->arch.tlbidomain;
+	int pdomain = vdomain->domain_map[vdomain_idx];
+	cpumask_t new_cpus;
+
+	cpumask_copy(&new_cpus, vdomain->vdomain_cpumasks[vdomain_idx]);
+
+	if (unlikely(pdomain == -1)) {
+		cpumask_set_cpu(vcpu->cpu, &new_cpus);
+		goto update_mask;
+	}
+
+	if (last_pcpu != -1 && clear_flag) {
+		/* remove old_cpu, not need to do so when first load */
+		if (cpumask_test_cpu(last_pcpu, &new_cpus))
+			cpumask_clear_cpu(last_pcpu, &new_cpus);
+	}
+
+	cpumask_set_cpu(vcpu->cpu, &new_cpus);
+
+update_mask:
+	cpumask_copy(vdomain->vdomain_cpumasks[vdomain_idx], &new_cpus);
+	return tlbid_pick_domain(vdomain->vdomain_cpumasks[vdomain_idx]);
+}
+
+static void vtlbidn_clear_set_s(int idx, u64 clear, u64 set)
+{
+	switch (idx) {
+	case 0:
+		sysreg_clear_set_s(SYS_VTLBID0_EL2, clear, set);
+		break;
+	case 1:
+		sysreg_clear_set_s(SYS_VTLBID1_EL2, clear, set);
+		break;
+	case 2:
+		sysreg_clear_set_s(SYS_VTLBID2_EL2, clear, set);
+		break;
+	case 3:
+		sysreg_clear_set_s(SYS_VTLBID3_EL2, clear, set);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
+static void kvm_arm_update_tlbid_map(struct tlbidomain *vdomain)
+{
+	int i, pdomain, vtlbid_idx, offset;
+	int pdomain_bits, nis = vdomain->nis;
+	int max_vdomains = vdomain->max_vdomains;
+	u64 clear, set;
+
+	if (nis >= NIS_RANGE_MIN_1_8 && nis <= NIS_RANGE_MAX_1_8)
+		pdomain_bits = VTLBID_TD_WIDTH_NIS_1_8;
+	else if (nis >= NIS_RANGE_MIN_9_16 && nis <= NIS_RANGE_MAX_9_16)
+		pdomain_bits = VTLBID_TD_WIDTH_NIS_9_16;
+	else
+		return;
+
+	for (i = 0; i < max_vdomains; i++) {
+		pdomain = vdomain->domain_map[i];
+		if (pdomain == -1) {
+			if (vdomain->domain_map[0] != -1)
+				pdomain = vdomain->domain_map[0];
+			else
+				pdomain = 0;
+		}
+
+		vtlbid_idx = i * pdomain_bits / VTLBID_EL2_WIDTH;
+		offset = i * pdomain_bits % VTLBID_EL2_WIDTH;
+
+		clear = GENMASK(offset + pdomain_bits - 1, offset);
+		set = (u64)pdomain << offset;
+
+		vtlbidn_clear_set_s(vtlbid_idx, clear, set);
+	}
+}
+
+static void kvm_vcpu_reload_tlbid(struct kvm *kvm)
+{
+	struct tlbidomain *vdomain = &kvm->arch.tlbidomain;
+
+	if (WARN_ON_ONCE(!vdomain->kvm_tlbid_enabled))
+		return;
+
+	preempt_disable();
+	spin_lock(&vdomain->tlbid_lock);
+	kvm_arm_update_tlbid_map(vdomain);
+	spin_unlock(&vdomain->tlbid_lock);
+	preempt_enable();
+}
+
+static void kvm_tlbidomain_vcpu_load(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct tlbidomain *vdomain = &kvm->arch.tlbidomain;
+	int max_vdomains = vdomain->max_vdomains;
+	DECLARE_BITMAP(clear_bits, KVM_VTLBID_MAX_VDOMAINS);
+	struct vcpu_tlbid_data *current_data, *other_data;
+	bool domain_map_changed = false;
+	int i, old_map;
+
+	/*
+	 * If we support tlbid, but user does not enable it, we can do
+	 * vdomain0 -> pdomainN as well by default.
+	 */
+	if (!vdomain->kvm_tlbid_enabled)
+		return;
+
+	current_data = xa_load(&vdomain->vcpu_data_array, vcpu->vcpu_idx);
+	if (WARN_ON_ONCE(!current_data))
+		return;
+
+	/*
+	 * Check if vCPU thread will move to another pCPU. Even when
+	 * staying on the same pCPU, another vCPU may have reprogrammed
+	 * the per-pCPU VTLBIDn registers in between, so reprogram them
+	 * before re-entering the guest.
+	 */
+	if (likely(vcpu->cpu == current_data->last_pcpu)) {
+		spin_lock(&vdomain->tlbid_lock);
+		kvm_arm_update_tlbid_map(vdomain);
+		spin_unlock(&vdomain->tlbid_lock);
+		return;
+	}
+
+	spin_lock(&vdomain->tlbid_lock);
+
+	bitmap_zero(clear_bits, max_vdomains);
+
+	/*
+	 * Remove current vCPU from its last_pcpu list and compute clear_bits
+	 * only when there was a previous pCPU. On first load (last_pcpu == -1),
+	 * no previous pCPU needs to be cleared from vdomain_cpumask.
+	 */
+	if (current_data->last_pcpu != -1) {
+		list_del_init(&current_data->pcpu_node);
+
+		/*
+		 * Iterate only vCPUs that share the same last_pcpu to compute
+		 * clear_bits. This is O(1) in the typical case since most pCPUs
+		 * host only one vCPU at a time.
+		 */
+		bitmap_fill(clear_bits, max_vdomains);
+		list_for_each_entry(other_data,
+				    &vdomain->pcpu_vcpu_list[current_data->last_pcpu],
+				    pcpu_node) {
+			unsigned long other_bits = other_data->vdomain_bitmap;
+
+			bitmap_andnot(clear_bits, clear_bits, &other_bits,
+				      max_vdomains);
+		}
+	}
+
+	if (!vdomain->guest_tlbid_enabled) {
+		old_map = vdomain->domain_map[0];
+
+		/*
+		 * If QEMU is not configured with vdomains, only vDomain0 needs
+		 * to be mapped.
+		 */
+		vdomain->domain_map[0] = update_domain_map(vcpu,
+							   0,
+							   current_data->last_pcpu,
+							   test_bit(0, clear_bits));
+		if (vdomain->domain_map[0] == old_map)
+			goto unlock;
+	} else {
+		/*
+		 * If QEMU is configured with vdomains, all vdomains need to be
+		 * mapped. For all vdomains which includes this vCPU, check if
+		 * vdomain map should be changed as well.
+		 */
+		for (i = 0; i < vdomain->num_domains; i++) {
+			if (!is_vcpu_in_vdomain(current_data->vdomain_bitmap, i))
+				continue;
+
+			old_map = vdomain->domain_map[i];
+			vdomain->domain_map[i] = update_domain_map(vcpu,
+								   i,
+								   current_data->last_pcpu,
+								   test_bit(i, clear_bits));
+
+			if (vdomain->domain_map[i] != old_map)
+				domain_map_changed = true;
+		}
+
+		if (!domain_map_changed)
+			goto unlock;
+	}
+
+	kvm_flush_remote_tlbs(kvm);
+
+	/*
+	 * Before this vcpu load, kick other vCPUs out, so maps for other vCPUs
+	 * will be updated during vCPU load.
+	 *
+	 * Add KVM_REQUEST_WAIT to make sure vCPU is out.
+	 */
+	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_VTLBID | KVM_REQUEST_WAIT);
+
+unlock:
+	/* update tlbid hardware map register */
+	kvm_arm_update_tlbid_map(vdomain);
+
+	current_data->last_pcpu = vcpu->cpu;
+	list_add_tail(&current_data->pcpu_node,
+		      &vdomain->pcpu_vcpu_list[vcpu->cpu]);
+
+	spin_unlock(&vdomain->tlbid_lock);
+}
+
+static void kvm_tlbidomain_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct tlbidomain *vdomain = &kvm->arch.tlbidomain;
+
+	if (!vdomain->kvm_tlbid_enabled)
+		return;
+}
+#else
+static inline void kvm_vcpu_reload_tlbid(struct kvm *kvm) { }
+static inline void kvm_tlbidomain_vcpu_load(struct kvm_vcpu *vcpu) { }
+static inline void kvm_tlbidomain_vcpu_put(struct kvm_vcpu *vcpu) { }
+#endif
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_s2_mmu *mmu;
@@ -828,6 +1062,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_vgic_load(vcpu);
 	kvm_vcpu_load_debug(vcpu);
 	kvm_vcpu_load_fgt(vcpu);
+	kvm_tlbidomain_vcpu_load(vcpu);
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
@@ -879,6 +1114,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
+	kvm_tlbidomain_vcpu_put(vcpu);
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_put_hw_mmu(vcpu);
 	kvm_arm_vmid_clear_active();
@@ -1265,6 +1501,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_VGIC_PROCESS_UPDATE, vcpu))
 			kvm_vgic_process_async_update(vcpu);
 
+		if (kvm_check_request(KVM_REQ_RELOAD_VTLBID, vcpu))
+			kvm_vcpu_reload_tlbid(vcpu->kvm);
+
 		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
 			kvm_update_stolen_time(vcpu);
 
diff --git a/arch/arm64/mm/tlbid.c b/arch/arm64/mm/tlbid.c
index 2b3e41e6ac22..1bf5929a42f9 100644
--- a/arch/arm64/mm/tlbid.c
+++ b/arch/arm64/mm/tlbid.c
@@ -208,3 +208,35 @@ int __init arm64_tlbid_init(struct tlbi_domain *domains_in, int count)
 	kfree(domains);
 	return 0;
 }
+
+/*
+ * tlbid_pick_domain - Select the smallest physical domain containing
+ * all CPUs in @active_cpus. Domains are sorted by size, with the
+ * smallest having the highest index. Domain 0 (broadcast) is returned
+ * if no better match exists.
+ */
+int tlbid_pick_domain(const struct cpumask *active_cpus)
+{
+	int i, cpu;
+
+	if (!system_supports_tlbid())
+		return 0;
+
+	if (cpumask_empty(active_cpus))
+		return 0;
+
+	for (i = domain_count - 1; i >= 0; i--) {
+		bool contains = true;
+
+		for_each_cpu(cpu, active_cpus) {
+			if (!test_bit(i, cpu_domains[cpu])) {
+				contains = false;
+				break;
+			}
+		}
+		if (contains)
+			return domain_ids[i];
+	}
+
+	return 0;
+}
-- 
2.33.0

