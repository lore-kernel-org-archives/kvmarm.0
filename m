Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB74A413249;
	Wed, 18 Mar 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849443; cv=none; b=CL+5vuq3w4xHoFmaHs0myj1brQqHWlTDXNnfQYZdAgy6niMH7cfXleCl4MAXdO+ghWWl0ie+8yOACUf2epvIaD689SUkaHZT7RGkhAVA23Jk8NQh7s8PWmX8XcMTY0bdEjWjRl0/I+qRGioF6sHPZX+N5jNSsw058CquBc6Oj6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849443; c=relaxed/simple;
	bh=fZtPYshS4jt9m5V6dNmRy6ebCHivCSGGwPHPUhVpHh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWbf0km03EBrl6eGZ3FIGI221+/C5BnimrTDU1QP5q9DjJutpJ5JSwPVOumZDKDKEHM5jKVwG74fIPMDYOE02qtgQK9ewKnoC9A+bt/O7AS8tSwPTZPM1N/+HmIWZHDqGNlOWNodOZKzejst7yJm/fK3+oXYd+D+3/yJczgsWQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A38922BE;
	Wed, 18 Mar 2026 08:57:12 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E6043F73B;
	Wed, 18 Mar 2026 08:57:15 -0700 (PDT)
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
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v13 48/48] [WIP] arm64: RMI: Add support for SRO
Date: Wed, 18 Mar 2026 15:54:12 +0000
Message-ID: <20260318155413.793430-49-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
References: <20260318155413.793430-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO).
This means that an SMC can return with an operation still in progress.
The host is expected to continue the operation until it reaches a
conclusion (either success or failure). During this process the RMM can
request addition memory ('donate') or hand memory back to the host
('reclaim'). The host can request an operation is cancelled, but must
still continue the operation until it has completed (otherwise the
incomplete operation may cause future RMM operations to fail).

SROs may request memory and these operations sometimes have to be
performed in places where memory allocation may not be possible. To deal
with this a SRO may be started, but then cancelled when the memory
allocation cannot be completed. The reclaimed memory will then be stored
in a struct rmi_sro_state object with the intention that once Linux has
returned to a state where memory allocation is possible, the failed
allocation can be reattempted (with GFP flags enabling sleeping and/or
direct reclaim) and the SRO operation reattempted (after acquiring the
necessary locks). In the worst case this may require several attempts
(if the RMM makes several memory requests) but should always make
forward progress.

This patch is currently a work-in-progress showing the general structure
of how this should work and implementing SROs for two operations
(RMI_REC_CREATE and RMI_REC_DESTROY). I'm aware there is missing
error-checking and there are some details in the specification that need
clarifying. These operations are also 'easy' in that we don't have
restrictions on memory allocation in these contexts.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rmi.h  |   8 -
 arch/arm64/include/asm/rmi_cmds.h |  71 +++---
 arch/arm64/include/asm/rmi_smc.h  |  27 +--
 arch/arm64/kvm/rmi.c              | 385 +++++++++++++++++++++++-------
 4 files changed, 347 insertions(+), 144 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index b914b9a84bd8..e1f5523c2dfa 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -51,7 +51,6 @@ enum realm_state {
  * @state: The lifetime state machine for the realm
  * @rd: Kernel mapping of the Realm Descriptor (RD)
  * @params: Parameters for the RMI_REALM_CREATE command
- * @num_aux: The number of auxiliary pages required by the RMM
  * @ia_bits: Number of valid Input Address bits in the IPA
  */
 struct realm {
@@ -60,7 +59,6 @@ struct realm {
 	void *rd;
 	struct realm_params *params;
 
-	unsigned long num_aux;
 	unsigned int ia_bits;
 };
 
@@ -75,12 +73,6 @@ struct realm {
 struct realm_rec {
 	unsigned long mpidr;
 	void *rec_page;
-	/*
-	 * REC_PARAMS_AUX_GRANULES is the maximum number of 4K granules that
-	 * the RMM can require. The array is sized to be large enough for the
-	 * maximum number of host sized pages that could be required.
-	 */
-	struct page *aux_pages[(REC_PARAMS_AUX_GRANULES * SZ_4K) >> PAGE_SHIFT];
 	struct rec_run *run;
 };
 
diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 9c4f83644a61..b761d74e1273 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -17,6 +17,27 @@ struct rtt_entry {
 	int ripas;
 };
 
+#define RMI_MAX_ADDR_LIST 256
+
+struct rmi_sro_state {
+	struct arm_smccc_1_2_regs regs;
+
+	unsigned long addr_count;
+	unsigned long addr_list[RMI_MAX_ADDR_LIST];
+};
+
+#define rmi_init_sro(...) ({						\
+	struct rmi_sro_state *sro = kmalloc_obj(*sro);			\
+	if (sro)							\
+		*sro = (struct rmi_sro_state){.regs = {__VA_ARGS__}};	\
+	sro;								\
+})
+
+#define rmi_smccc(...) do { \
+	arm_smccc_1_1_invoke(__VA_ARGS__); \
+} while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY || \
+	 RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
+
 /**
  * rmi_rmm_config_get() - Get the system configuration
  * @cfg_ptr: PA of a struct rmm_config
@@ -410,29 +431,7 @@ static inline int rmi_realm_destroy(unsigned long rd)
 }
 
 /**
- * rmi_rec_aux_count() - Get number of auxiliary granules required
- * @rd: PA of the RD
- * @aux_count: Number of granules written to this pointer
- *
- * A REC may require extra auxiliary granules to be delegated for the RMM to
- * store metadata (not visible to the normal world) in. This function provides
- * the number of granules that are required.
- *
- * Return: RMI return code
- */
-static inline int rmi_rec_aux_count(unsigned long rd, unsigned long *aux_count)
-{
-	struct arm_smccc_res res;
-
-	arm_smccc_1_1_invoke(SMC_RMI_REC_AUX_COUNT, rd, &res);
-
-	if (aux_count)
-		*aux_count = res.a1;
-	return res.a0;
-}
-
-/**
- * rmi_rec_create() - Create a REC
+ * rmi_rec_create_sro_init() - Init an SRO to create a REC
  * @rd: PA of the RD
  * @rec: PA of the target REC
  * @params: PA of REC parameters
@@ -440,33 +439,27 @@ static inline int rmi_rec_aux_count(unsigned long rd, unsigned long *aux_count)
  * Create a REC using the parameters specified in the struct rec_params pointed
  * to by @params.
  *
- * Return: RMI return code
+ * Returns: Allocated SRO object
  */
-static inline int rmi_rec_create(unsigned long rd, unsigned long rec,
-				 unsigned long params)
+static inline struct rmi_sro_state *
+rmi_rec_create_sro_init(unsigned long rd,
+			unsigned long rec,
+			unsigned long params)
 {
-	struct arm_smccc_res res;
-
-	arm_smccc_1_1_invoke(SMC_RMI_REC_CREATE, rd, rec, params, &res);
-
-	return res.a0;
+	return rmi_init_sro(SMC_RMI_REC_CREATE, rd, rec, params);
 }
 
 /**
- * rmi_rec_destroy() - Destroy a REC
+ * rmi_rec_destroy_sro_init() - Init an SRO to destroy a REC
  * @rec: PA of the target REC
  *
  * Destroys a REC. The REC must not be running.
  *
- * Return: RMI return code
+ * Return: Allocated SRO object
  */
-static inline int rmi_rec_destroy(unsigned long rec)
+static inline struct rmi_sro_state *rmi_rec_destroy_sro_init(unsigned long rec)
 {
-	struct arm_smccc_res res;
-
-	arm_smccc_1_1_invoke(SMC_RMI_REC_DESTROY, rec, &res);
-
-	return res.a0;
+	return rmi_init_sro(SMC_RMI_REC_DESTROY, rec);
 }
 
 /**
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 049d71470486..fa23818e1b4c 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -38,7 +38,6 @@
 #define SMC_RMI_PSCI_COMPLETE			SMC_RMI_CALL(0x0164)
 #define SMC_RMI_FEATURES			SMC_RMI_CALL(0x0165)
 #define SMC_RMI_RTT_FOLD			SMC_RMI_CALL(0x0166)
-#define SMC_RMI_REC_AUX_COUNT			SMC_RMI_CALL(0x0167) //
 #define SMC_RMI_RTT_INIT_RIPAS			SMC_RMI_CALL(0x0168)
 #define SMC_RMI_RTT_SET_RIPAS			SMC_RMI_CALL(0x0169)
 #define SMC_RMI_VSMMU_CREATE			SMC_RMI_CALL(0x016a)
@@ -180,11 +179,18 @@
 #define RMI_ADDR_TYPE_SINGLE		1
 #define RMI_ADDR_TYPE_LIST		2
 
-#define RMI_ADDR_RANGE_SIZE(ar)		(FIELD_GET(GENMASK(1, 0), (ar)))
-#define RMI_ADDR_RANGE_COUNT(ar)	(FIELD_GET(GENMASK(PAGE_SHIFT - 1, 2), \
+#define RMI_ADDR_RANGE_SIZE_MASK	GENMASK(1, 0)
+#define RMI_ADDR_RANGE_COUNT_MASK	GENMASK(PAGE_SHIFT - 1, 2)
+#define RMI_ADDR_RANGE_ADDR_MASK	(PAGE_MASK & GENMASK(51, 0))
+#define RMI_ADDR_RANGE_STATE_MASK	BIT(63)
+
+#define RMI_ADDR_RANGE_SIZE(ar)		(FIELD_GET(RMI_ADDR_RANGE_SIZE_MASK, \
+						   (ar)))
+#define RMI_ADDR_RANGE_COUNT(ar)	(FIELD_GET(RMI_ADDR_RANGE_COUNT_MASK, \
+						   (ar)))
+#define RMI_ADDR_RANGE_ADDR(ar)		((ar) & RMI_ADDR_RANGE_ADDR_MASK)
+#define RMI_ADDR_RANGE_STATE(ar)	(FIELD_GET(RMI_ADDR_RANGE_STATE_MASK, \
 						   (ar)))
-#define RMI_ADDR_RANGE_ADDR(ar)		((ar) & PAGE_MASK & GENMASK(51, 0))
-#define RMI_ADDR_RANGE_STATE(ar)	(FIELD_GET(BIT(63), (ar)))
 
 enum rmi_ripas {
 	RMI_EMPTY = 0,
@@ -295,8 +301,6 @@ struct realm_params {
 
 #define REC_PARAMS_FLAG_RUNNABLE	BIT_ULL(0)
 
-#define REC_PARAMS_AUX_GRANULES		16
-
 struct rec_params {
 	union { /* 0x0 */
 		u64 flags;
@@ -312,14 +316,7 @@ struct rec_params {
 	};
 	union { /* 0x300 */
 		u64 gprs[REC_CREATE_NR_GPRS];
-		u8 padding3[0x500];
-	};
-	union { /* 0x800 */
-		struct {
-			u64 num_rec_aux;
-			u64 aux[REC_PARAMS_AUX_GRANULES];
-		};
-		u8 padding4[0x800];
+		u8 padding3[0xd00];
 	};
 };
 
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index e76e58762f55..10ff1c3bddaf 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -20,6 +20,295 @@ static unsigned long rmm_feat_reg1;
 
 #define RMM_L2_BLOCK_SIZE	PMD_SIZE
 
+static int delegate_range(phys_addr_t phys, unsigned long size);
+static int undelegate_range(phys_addr_t phys, unsigned long size);
+
+static unsigned long donate_req_to_size(unsigned long donatereq)
+{
+	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
+
+	switch (unit_size) {
+	case 0:
+		return PAGE_SIZE;
+	case 1:
+		return PMD_SIZE;
+	case 2:
+		return PUD_SIZE;
+	case 3:
+		return P4D_SIZE;
+	}
+	unreachable();
+}
+
+static void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs_in,
+			     struct arm_smccc_1_2_regs *regs_out)
+{
+	struct arm_smccc_1_2_regs regs = *regs_in;
+	unsigned long status;
+
+	do {
+		arm_smccc_1_2_invoke(&regs, regs_out);
+		status = RMI_RETURN_STATUS(regs_out->a0);
+	} while (status == RMI_BUSY || status == RMI_BLOCKED);
+}
+
+static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
+				 unsigned long sro_handle,
+				 unsigned long donatereq,
+				 struct arm_smccc_1_2_regs *out_regs,
+				 gfp_t gfp)
+{
+	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
+	unsigned long count = RMI_DONATE_COUNT(donatereq);
+	unsigned long state = RMI_DONATE_STATE(donatereq);
+	unsigned long size;
+	unsigned long addr_range;
+	struct page *pages;
+	phys_addr_t phys;
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_MEM_DONATE,
+		sro_handle
+	};
+
+	for (int i = 0; i < sro->addr_count; i++) {
+		unsigned long entry = sro->addr_list[i];
+
+		if (RMI_ADDR_RANGE_SIZE(entry) == unit_size &&
+		    RMI_ADDR_RANGE_COUNT(entry) == count &&
+		    RMI_ADDR_RANGE_STATE(entry) == state) {
+			sro->addr_count--;
+			swap(sro->addr_list[sro->addr_count],
+			     sro->addr_list[i]);
+
+			goto out;
+		}
+	}
+
+	size = donate_req_to_size(donatereq) * count;
+
+	pages = alloc_pages(gfp, get_order(size));
+	if (!pages)
+		return -ENOMEM;
+	phys = page_to_phys(pages);
+
+	if (state == RMI_OP_MEM_DELEGATED) {
+		if (delegate_range(phys, size)) {
+			__free_pages(pages, get_order(size));
+			return -ENXIO;
+		}
+	}
+
+	addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
+	FIELD_MODIFY(RMI_ADDR_RANGE_SIZE_MASK, &addr_range, unit_size);
+	FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);
+	FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
+
+	sro->addr_list[sro->addr_count] = addr_range;
+
+out:
+	regs.a2 = virt_to_phys(&sro->addr_list[sro->addr_count]);
+	regs.a3 = 1;
+	rmi_smccc_invoke(&regs, out_regs);
+
+	unsigned long donated_granules = out_regs->a1;
+
+	WARN_ON(donated_granules > 1);
+	if (WARN_ON(donated_granules == 0)) {
+		sro->addr_count++;
+		return 0;
+	}
+
+	return 0;
+}
+
+static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
+				    unsigned long sro_handle,
+				    unsigned long donatereq,
+				    struct arm_smccc_1_2_regs *out_regs,
+				    gfp_t gfp)
+{
+	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
+	unsigned long count = RMI_DONATE_COUNT(donatereq);
+	unsigned long state = RMI_DONATE_STATE(donatereq);
+	unsigned long found = 0;
+	unsigned long addr_list_start = sro->addr_count;
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_MEM_DONATE,
+		sro_handle
+	};
+
+	for (int i = 0; i < addr_list_start && found < count; i++) {
+		unsigned long entry = sro->addr_list[i];
+
+		if (RMI_ADDR_RANGE_SIZE(entry) == unit_size &&
+		    RMI_ADDR_RANGE_COUNT(entry) == 1 &&
+		    RMI_ADDR_RANGE_STATE(entry) == state) {
+			addr_list_start--;
+			swap(sro->addr_list[addr_list_start],
+			     sro->addr_list[i]);
+			found++;
+			i--;
+		}
+	}
+
+	while (found < count) {
+		unsigned long addr_range;
+		unsigned long size = donate_req_to_size(donatereq);
+
+		struct page *pages = alloc_pages(gfp, get_order(size));
+		phys_addr_t phys;
+
+		if (!pages)
+			return -ENOMEM;
+
+		phys = page_to_phys(pages);
+
+		if (state == RMI_OP_MEM_DELEGATED) {
+			if (delegate_range(phys, size)) {
+				__free_pages(pages, get_order(size));
+				return -ENXIO;
+			}
+		}
+
+		addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
+		FIELD_MODIFY(RMI_ADDR_RANGE_SIZE_MASK, &addr_range, unit_size);
+		FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, 1);
+		FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
+
+		sro->addr_list[sro->addr_count++] = addr_range;
+		found++;
+	}
+
+	regs.a2 = virt_to_phys(&sro->addr_list[addr_list_start]);
+	regs.a3 = found;
+	rmi_smccc_invoke(&regs, out_regs);
+
+	unsigned long donated_granules = out_regs->a1;
+
+	while (donated_granules < found) {
+		swap(sro->addr_list[addr_list_start++],
+		     sro->addr_list[--sro->addr_count]);
+		found--;
+	}
+	sro->addr_count -= donated_granules;
+
+	return 0;
+}
+
+static int rmi_sro_donate(struct rmi_sro_state *sro,
+			  unsigned long sro_handle,
+			  unsigned long donatereq,
+			  struct arm_smccc_1_2_regs *regs,
+			  gfp_t gfp)
+{
+	unsigned long count = RMI_DONATE_COUNT(donatereq);
+
+	if (WARN_ON(!count))
+		return 0;
+
+	if (RMI_DONATE_CONTIG(donatereq)) {
+		return rmi_sro_donate_contig(sro, sro_handle, donatereq,
+					     regs, gfp);
+	} else {
+		return rmi_sro_donate_noncontig(sro, sro_handle, donatereq,
+						regs, gfp);
+	}
+}
+
+static int rmi_sro_reclaim(struct rmi_sro_state *sro,
+			   unsigned long sro_handle,
+			   struct arm_smccc_1_2_regs *out_regs)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_MEM_RECLAIM,
+		sro_handle,
+		virt_to_phys(&sro->addr_list[sro->addr_count]),
+		RMI_MAX_ADDR_LIST - sro->addr_count
+	};
+	rmi_smccc_invoke(&regs, out_regs);
+	sro->addr_count += out_regs->a1;
+
+	return 0;
+}
+
+static void rmi_sro_free(struct rmi_sro_state *sro)
+{
+	for (int i = 0; i < sro->addr_count; i++) {
+		unsigned long entry = sro->addr_list[i];
+		unsigned long addr = RMI_ADDR_RANGE_ADDR(entry);
+		unsigned long unit_size = RMI_ADDR_RANGE_SIZE(entry);
+		unsigned long count = RMI_ADDR_RANGE_COUNT(entry);
+		unsigned long state = RMI_ADDR_RANGE_STATE(entry);
+		unsigned long size = donate_req_to_size(unit_size) * count;
+
+		if (state == RMI_OP_MEM_DELEGATED) {
+			if (WARN_ON(undelegate_range(addr, size))) {
+				/* Leak the pages */
+				continue;
+			}
+		}
+		__free_pages(phys_to_page(addr), get_order(size));
+	}
+
+	sro->addr_count = 0;
+}
+
+DEFINE_FREE(sro, struct rmi_sro_state *, if (_T) rmi_sro_free(_T))
+
+static unsigned long rmi_sro_execute(struct rmi_sro_state *sro)
+{
+	unsigned long sro_handle;
+	struct arm_smccc_1_2_regs regs;
+	struct arm_smccc_1_2_regs *regs_in = &sro->regs;
+
+	rmi_smccc_invoke(regs_in, &regs);
+
+	sro_handle = regs.a1;
+
+	while (RMI_RETURN_STATUS(regs.a0) == RMI_INCOMPLETE) {
+		bool can_cancel = RMI_RETURN_CANCANCEL(regs.a0);
+		int ret;
+
+		switch (RMI_RETURN_MEMREQ(regs.a0)) {
+		case RMI_OP_MEM_REQ_NONE:
+			regs = (struct arm_smccc_1_2_regs){
+				SMC_RMI_OP_CONTINUE, sro_handle, 0
+			};
+			rmi_smccc_invoke(&regs, &regs);
+			break;
+		case RMI_OP_MEM_REQ_DONATE:
+			ret = rmi_sro_donate(sro, sro_handle, regs.a2, &regs,
+					     GFP_KERNEL);
+			break;
+		case RMI_OP_MEM_REQ_RECLAIM:
+			ret = rmi_sro_reclaim(sro, sro_handle, &regs);
+			break;
+		default:
+			ret = WARN_ON(1);
+			break;
+		}
+
+		if (ret) {
+			if (can_cancel) {
+				/*
+				 * FIXME: Handle cancelling properly!
+				 *
+				 * If the operation has failed due to memory
+				 * allocation failure then the information on
+				 * the memory allocation should be saved, so
+				 * that the allocation can be repeated outside
+				 * of any context which prevented the
+				 * allocation.
+				 */
+			}
+			if (WARN_ON(ret))
+				return ret;
+		}
+	}
+
+	return regs.a0;
+}
+
 static inline unsigned long rmi_rtt_level_mapsize(int level)
 {
 	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
@@ -795,12 +1084,6 @@ static int realm_create_rd(struct kvm *kvm)
 		goto out_undelegate_tables;
 	}
 
-	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
-		WARN_ON(rmi_realm_destroy(rd_phys));
-		r = -ENXIO;
-		goto out_undelegate_tables;
-	}
-
 	realm->rd = rd;
 	WRITE_ONCE(realm->state, REALM_STATE_NEW);
 	/* The realm is up, free the parameters.  */
@@ -1432,65 +1715,9 @@ int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void free_rec_aux(struct page **aux_pages,
-			 unsigned int num_aux)
-{
-	unsigned int i;
-	unsigned int page_count = 0;
-
-	for (i = 0; i < num_aux; i++) {
-		struct page *aux_page = aux_pages[page_count++];
-		phys_addr_t aux_page_phys = page_to_phys(aux_page);
-
-		if (!WARN_ON(undelegate_page(aux_page_phys)))
-			__free_page(aux_page);
-		aux_page_phys += PAGE_SIZE;
-	}
-}
-
-static int alloc_rec_aux(struct page **aux_pages,
-			 u64 *aux_phys_pages,
-			 unsigned int num_aux)
-{
-	struct page *aux_page;
-	unsigned int i;
-	int ret;
-
-	for (i = 0; i < num_aux; i++) {
-		phys_addr_t aux_page_phys;
-
-		aux_page = alloc_page(GFP_KERNEL);
-		if (!aux_page) {
-			ret = -ENOMEM;
-			goto out_err;
-		}
-
-		aux_page_phys = page_to_phys(aux_page);
-		if (delegate_page(aux_page_phys)) {
-			ret = -ENXIO;
-			goto err_undelegate;
-		}
-		aux_phys_pages[i] = aux_page_phys;
-		aux_pages[i] = aux_page;
-	}
-
-	return 0;
-err_undelegate:
-	while (i > 0) {
-		i--;
-		if (WARN_ON(undelegate_page(aux_phys_pages[i]))) {
-			/* Leak the page if the undelegate fails */
-			goto out_err;
-		}
-	}
-	__free_page(aux_page);
-out_err:
-	free_rec_aux(aux_pages, i);
-	return ret;
-}
-
 static int kvm_create_rec(struct kvm_vcpu *vcpu)
 {
+	struct rmi_sro_state *sro __free(sro) = NULL;
 	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
 	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
 	struct realm *realm = &vcpu->kvm->arch.realm;
@@ -1538,18 +1765,17 @@ static int kvm_create_rec(struct kvm_vcpu *vcpu)
 		goto out_free_pages;
 	}
 
-	r = alloc_rec_aux(rec->aux_pages, params->aux, realm->num_aux);
-	if (r)
-		goto out_undelegate_rmm_rec;
-
-	params->num_rec_aux = realm->num_aux;
 	params->mpidr = mpidr;
 
-	if (rmi_rec_create(virt_to_phys(realm->rd),
-			   rec_page_phys,
-			   virt_to_phys(params))) {
+	sro = rmi_rec_create_sro_init(virt_to_phys(realm->rd),
+				      rec_page_phys, virt_to_phys(params));
+	if (!sro) {
+		r = -ENOMEM;
+		goto out_undelegate_rmm_rec;
+	}
+	if (rmi_sro_execute(sro)) {
 		r = -ENXIO;
-		goto out_free_rec_aux;
+		goto out_undelegate_rmm_rec;
 	}
 
 	rec->mpidr = mpidr;
@@ -1557,8 +1783,6 @@ static int kvm_create_rec(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)params);
 	return 0;
 
-out_free_rec_aux:
-	free_rec_aux(rec->aux_pages, realm->num_aux);
 out_undelegate_rmm_rec:
 	if (WARN_ON(undelegate_page(rec_page_phys)))
 		rec->rec_page = NULL;
@@ -1572,7 +1796,7 @@ static int kvm_create_rec(struct kvm_vcpu *vcpu)
 
 void kvm_destroy_rec(struct kvm_vcpu *vcpu)
 {
-	struct realm *realm = &vcpu->kvm->arch.realm;
+	struct rmi_sro_state *sro __free(sro) = NULL;
 	struct realm_rec *rec = &vcpu->arch.rec;
 	unsigned long rec_page_phys;
 
@@ -1588,15 +1812,12 @@ void kvm_destroy_rec(struct kvm_vcpu *vcpu)
 
 	rec_page_phys = virt_to_phys(rec->rec_page);
 
-	/*
-	 * The REC and any AUX pages cannot be reclaimed until the REC is
-	 * destroyed. So if the REC destroy fails then the REC page and any AUX
-	 * pages will be leaked.
-	 */
-	if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
+	sro = rmi_rec_destroy_sro_init(rec_page_phys);
+	if (WARN_ON(!sro))
 		return;
 
-	free_rec_aux(rec->aux_pages, realm->num_aux);
+	if (WARN_ON(rmi_sro_execute(sro)))
+		return;
 
 	free_delegated_page(rec_page_phys);
 }
-- 
2.43.0

