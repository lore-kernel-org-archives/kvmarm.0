Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91286427FB0;
	Mon,  3 Aug 2026 13:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764743; cv=none; b=VGwj+RWMmwkM+GQE58w+ZhZfZ8ExBtXjVKG/4X4rEKqJLHP74f4ucaO1rPjtwWdg6W9K7giTldLI52LFukx9RlSV1GGVwVWoaHuBzGKMesh5t5FuiGFNnIjVyTXbeicbU+KSFUUCDM4jnBNdGauBsk1oSrU45XF2z1sY02qGUcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764743; c=relaxed/simple;
	bh=sAsN6eSDXeVqmO6cS4TqVq5CroV3r+4L1qYoCWFOJFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XD0bmYrx2nIyGDnkn2asrFtJOKbD0L5aGqUzU6wKWmJboIvOPpBIGRECl6UfFKlsYICor7cacNQ4P8YtPh0UIgU2Ogc7Fe1P7gchbo24mlyx9LhiQ3yOQmb0tG6R9tTe/XFxlJ6eFH71Xs2l0f0BegIZcRTLYiLNBP6+rTQS7QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fUfh5Igr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fUfh5Igr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13A441476;
	Mon,  3 Aug 2026 06:45:37 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7528A3F66F;
	Mon,  3 Aug 2026 06:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764741; bh=sAsN6eSDXeVqmO6cS4TqVq5CroV3r+4L1qYoCWFOJFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUfh5IgrUx/qRDkG1GOjP1F0gzbo6mbOkFiti7p0nym7XtX9iDuqXWk2w6EKd9ByC
	 sxvOYNXZQmT6hOMB5iqZ6dW+aBOeAvcd5thiOqctp26Go+j6qDsHE/B8WyIB87Luaj
	 YVjOp/2+n31qThLwxwtnEp4habpou/GlS01eKnzE=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 18/45] KVM: arm64: CCA: Allocate and free RECs to match vCPUs
Date: Mon,  3 Aug 2026 14:43:34 +0100
Message-ID: <20260803134403.80630-19-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM maintains a data structure known as the Realm Execution Context
(or REC). It is similar to struct kvm_vcpu and tracks the state of the
virtual CPUs. KVM must delegate memory and request the structures are
created when vCPUs are created, and suitably tear down on destruction.

RECs may require additional pages (e.g. for storing larger register
state for SVE). The RMM can request extra pages for this purpose using
the Stateful RMI Operations (SRO) functionality to request pages during
REC creation. These pages are then passed back to the host from the RMM
('reclaimed') when the REC is destroyed. The kernel tracking object
(struct rmi_sro_state) is stored in the realm_rec structure to avoid
memory allocation during the destruction path.

Note that only some of register state for the REC can be set by KVM, the
rest is defined by the RMM (zeroed). The register state then cannot be
changed by KVM after the REC is created (except when the guest
explicitly requests this e.g. by performing a PSCI call).

Note that the function kvm_create_rec() is unused at this point, a
future patch will add the call and remove the __maybe_unused attribute.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Propagate negative error code in kvm_create_rec().
Changes since v14:
 * Handle partial REC creation better by NULLing rec->run, rec->rec_page
   and rec->sro when freeing.
Changes since v13:
 * Support SRO for REC creation/destruction instead of auxiliary
   granules.
Changes since v12:
 * Use the new range-based delegation RMI.
Changes since v11:
 * Remove the KVM_ARM_VCPU_REC feature. User space no longer needs to
   configure each VCPU separately, RECs are created on the first VCPU
   run of the guest.
Changes since v9:
 * Size the aux_pages array according to the PAGE_SIZE of the host.
Changes since v7:
 * Add comment explaining the aux_pages array.
 * Rename "undeleted_failed" variable to "should_free" to avoid a
   confusing double negative.
Changes since v6:
 * Avoid reporting the KVM_ARM_VCPU_REC feature if the guest isn't a
   realm guest.
 * Support host page size being larger than RMM's granule size when
   allocating/freeing aux granules.
Changes since v5:
 * Separate the concept of vcpu_is_rec() and
   kvm_arm_vcpu_rec_finalized() by using the KVM_ARM_VCPU_REC feature as
   the indication that the VCPU is a REC.
Changes since v2:
 * Free rec->run earlier in kvm_destroy_realm() and adapt to previous patches.
---
 arch/arm64/include/asm/kvm_emulate.h |   5 ++
 arch/arm64/include/asm/kvm_host.h    |   3 +
 arch/arm64/include/asm/kvm_rmi.h     |  20 ++++++
 arch/arm64/kvm/arm.c                 |   6 ++
 arch/arm64/kvm/reset.c               |   1 +
 arch/arm64/kvm/rmi.c                 | 103 +++++++++++++++++++++++++++
 6 files changed, 138 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index e26d6755279f..2e69fe494716 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -712,4 +712,9 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
 	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
 }
 
+static inline bool vcpu_is_rec(const struct kvm_vcpu *vcpu)
+{
+	return kvm_is_realm(vcpu->kvm);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1a5e15040111..9b46b39ed11e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -949,6 +949,9 @@ struct kvm_vcpu_arch {
 
 	/* Hyp-readable copy of kvm_vcpu::pid */
 	pid_t pid;
+
+	/* Realm meta data */
+	struct realm_rec rec;
 };
 
 /*
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 339a9f8c4408..3bffd021ca26 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -75,12 +75,32 @@ struct realm {
 	bool rtts_destroyed;
 };
 
+/**
+ * struct realm_rec - Additional per VCPU data for a Realm
+ *
+ * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify this VCPU
+ * @rec_page: Kernel VA of the RMM's private page for this REC
+ * @rec_phys: Physical address of @rec_page
+ * @run: Kernel VA of the RmiRecRun structure shared with the RMM
+ * @run_phys: Physical address of @run
+ * @sro: A preallocated SRO state context
+ */
+struct realm_rec {
+	unsigned long mpidr;
+	void *rec_page;
+	phys_addr_t rec_phys;
+	struct rec_run *run;
+	phys_addr_t run_phys;
+	struct rmi_sro_state *sro;
+};
+
 void kvm_init_rmi(void);
 u32 kvm_rmm_ipa_limit(void);
 
 int kvm_init_realm(struct kvm *kvm);
 void kvm_destroy_realm(struct kvm *kvm);
 int kvm_realm_teardown_stage2(struct kvm *kvm);
+void kvm_destroy_rec(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9881fd6c511c..38fac98cd6a4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -589,6 +589,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
 
+	vcpu->arch.rec.mpidr = INVALID_HWID;
+
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
 	/* Set up the timer */
@@ -1668,6 +1670,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
 		return -EINVAL;
 
+	/* Realms are incompatible with AArch32 */
+	if (vcpu_is_rec(vcpu))
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b963fd975aac..c18cdca7d125 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -161,6 +161,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 	kfree(vcpu->arch.vncr_tlb);
 	kfree(vcpu->arch.ccsidr);
+	kvm_destroy_rec(vcpu);
 }
 
 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 4154c6cc1112..f6686287119d 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -205,6 +205,109 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
 	return realm_destroy_rtts(kvm);
 }
 
+static int __maybe_unused kvm_create_rec(struct kvm_vcpu *vcpu)
+{
+	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
+	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+	struct realm *realm = &vcpu->kvm->arch.realm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	struct rec_params *params;
+	long rmi_ret;
+	int r, i;
+
+	if (rec->run)
+		return -EBUSY;
+
+	/*
+	 * The RMM will report PSCI v1.0 to Realms and the KVM_ARM_VCPU_PSCI_0_2
+	 * flag covers v0.2 and onwards.
+	 */
+	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
+		return -EINVAL;
+
+	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
+	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
+
+	params = (struct rec_params *)get_zeroed_page(GFP_KERNEL);
+	rec->rec_page = (void *)__get_free_page(GFP_KERNEL);
+	rec->run = (struct rec_run *)get_zeroed_page(GFP_KERNEL);
+	rec->sro = kmalloc_obj(*rec->sro);
+	if (!params || !rec->rec_page || !rec->run || !rec->sro) {
+		r = -ENOMEM;
+		goto out_free_pages;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(params->gprs); i++)
+		params->gprs[i] = vcpu_regs->regs[i];
+
+	params->pc = vcpu_regs->pc;
+
+	if (vcpu->vcpu_id == 0)
+		params->flags |= REC_PARAMS_FLAG_RUNNABLE;
+
+	rec->rec_phys = virt_to_phys(rec->rec_page);
+	rec->run_phys = virt_to_phys(rec->run);
+
+	if (rmi_delegate_page(rec->rec_phys)) {
+		r = -ENXIO;
+		goto out_free_pages;
+	}
+
+	params->mpidr = mpidr;
+
+	rmi_ret = rmi_rec_create(virt_to_phys(realm->rd), rec->rec_phys,
+				 virt_to_phys(params), rec->sro);
+	if (rmi_ret) {
+		r = rmi_ret < 0 ? rmi_ret : -ENXIO;
+		goto out_undelegate_rmm_rec;
+	}
+
+	rec->mpidr = mpidr;
+
+	free_page((unsigned long)params);
+	return 0;
+
+out_undelegate_rmm_rec:
+	if (WARN_ON(rmi_undelegate_page(rec->rec_phys)))
+		rec->rec_page = NULL;
+out_free_pages:
+	free_page((unsigned long)rec->run);
+	free_page((unsigned long)rec->rec_page);
+	free_page((unsigned long)params);
+	kfree(rec->sro);
+	rec->run = NULL;
+	rec->rec_page = NULL;
+	rec->rec_phys = 0;
+	rec->run_phys = 0;
+	rec->sro = NULL;
+	return r;
+}
+
+void kvm_destroy_rec(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	if (!vcpu_is_rec(vcpu))
+		return;
+
+	if (!rec->run) {
+		/* Nothing to do if the VCPU hasn't been finalized */
+		return;
+	}
+
+	if (WARN_ON(rmi_rec_destroy(rec->rec_phys, rec->sro)))
+		return;
+
+	free_page((unsigned long)rec->run);
+	kfree(rec->sro);
+	free_delegated_page(rec->rec_phys);
+	rec->run = NULL;
+	rec->sro = NULL;
+	rec->rec_page = NULL;
+	rec->rec_phys = 0;
+	rec->run_phys = 0;
+}
+
 void kvm_destroy_realm(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
-- 
2.43.0

