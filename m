Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE26385D88;
	Wed, 15 Jul 2026 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125703; cv=none; b=iSLlRcXdFZMwSaf3s4fFYE9+3yX/rCla5AXhCaBc0GeF/GIKYDp+tvoZ4Rjh+Zoe9zvdhyRMchK9I88d/RONnYhIg+WlYAMvcRpS2lsp2FWNFoe0dheomlo7rJh4hK7qzQ8pjnQ4k5z9vZdH7znL8f+HV9bgeoU85EzhAHen8Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125703; c=relaxed/simple;
	bh=Qan3vfOrYepGtYfFmm/BRV40tqHew+9msYxZMgCj4Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaUdybchywMotAsDYNuP5jVZR4zgEshbKOY5S6XHeSP3N17pBDh7i1Qu/ldzOwFJhV6PcP2sw3nnkEdWONIAZs/TImitomyn62RVQOyM0ePvKoLFMhCkm9f2R6fX7GMTS4HEYwhfCMLYaDcM//lay+jJirJCji/IaX7KOLVuxOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=piz6bfjh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="piz6bfjh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A62F41477;
	Wed, 15 Jul 2026 07:28:15 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56CB43F7B4;
	Wed, 15 Jul 2026 07:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125699; bh=Qan3vfOrYepGtYfFmm/BRV40tqHew+9msYxZMgCj4Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piz6bfjhKIv2/nFs9K9yQcjZSQs8nnG2FLCfx1DVyGnXk6sZMuC0x59X++X92UnnK
	 qRfaSLPk5CRwq9Pqc+veRFlz1ts3l3bcnQIgVhTeMr5B2ybAwW/941RQfPLWG9cg4f
	 CbLqDD5bpSpiPo8zaUP37fAuNVTwsZNQO2s7VnJU=
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
Subject: [PATCH 5/6] firmware: arm_rmm: Add support for SRO
Date: Wed, 15 Jul 2026 15:27:36 +0100
Message-ID: <20260715142739.80398-6-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142739.80398-1-steven.price@arm.com>
References: <20260715142739.80398-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
means that an SMC can return with an operation still in progress. The
host is expected to continue the operation until it reaches a conclusion
(either success or failure). During this process the RMM can request
additional memory ('donate') or hand memory back to the host
('reclaim'). The host can request an in progress operation is cancelled,
but still continue the operation until it has completed (otherwise the
incomplete operation may cause future RMM operations to fail).

The SRO is tracked using a struct rmi_sro_state object which keeps track
of any memory which has been allocated but not yet consumed by the RMM
or reclaimed from the RMM. This allows the memory to be reused in a
future request within the same operation. It will also permit an
operation to be done in a context where memory allocation may be
difficult (e.g. atomic context) with the option to abort the operation
and retry the memory allocation outside of the atomic context. The
memory stored in the struct rmi_sro_state object can then be reused on
the subsequent attempt.

Wrappers for SRO RMI commands are also provided here because they depend
on the rmi_sro_execute() implementation added by this patch.
Delegate/undelegate handles are also added here because they now use the
SRO/stateful command infrastructure.

Signed-off-by: Steven Price <steven.price@arm.com>
---
v15:
 * Wrappers for SRO RMI functions are provided in this patch due to
   their dependency on the SRO infrastructure.
 * Fold the range delegate/undelegate wrappers into this patch because
   they depend on the stateful command infrastructure.
 * Add cpu_relax() calls when RMI_BUSY/RMI_BLOCKED is returned.
 * Various fixes.
v14:
 * SRO support has improved although is still not fully complete. The
   infrastructure has been moved out of KVM.
---
 arch/arm64/include/asm/rmi_cmds.h | 392 ++++++++++++++++++++++++
 drivers/firmware/arm_rmm/rmi.c    | 491 +++++++++++++++++++++++++++++-
 include/linux/arm-rmi-cmds.h      | 114 +++++++
 3 files changed, 996 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 7eb2c8d7f7fa..f13ecdb40ded 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -9,6 +9,102 @@
 #include <linux/arm-rmi-cmds.h>
 #include <linux/arm-smccc-rmi.h>
 
+/**
+ * rmi_rtt_data_map_init() - Create a protected mapping with data contents
+ * @rd: PA of the RD
+ * @data: PA of the target granule
+ * @ipa: IPA at which the granule will be mapped in the guest
+ * @src: PA of the source granule
+ * @flags: RMI_MEASURE_CONTENT if the contents should be measured
+ *
+ * Create a mapping from Protected IPA space to conventional memory, copying
+ * contents from a Non-secure Granule provided by the caller.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_data_map_init(unsigned long rd, unsigned long data,
+					unsigned long ipa, unsigned long src,
+					unsigned long flags)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_DATA_MAP_INIT, rd, data, ipa, src, flags
+	};
+
+	return rmi_sro_execute(&regs);
+}
+
+/**
+ * rmi_rtt_data_map() - Create mappings in protected IPA with unknown contents
+ * @rd: PA of the RD
+ * @base: Base of the target IPA range
+ * @top: Top of the target IPA range
+ * @flags: Flags
+ * @oaddr: Output address set descriptor
+ * @out_top: Top address of range which was processed.
+ *
+ * Return RMI return code
+ */
+static inline int rmi_rtt_data_map(unsigned long rd,
+				   unsigned long base,
+				   unsigned long top,
+				   unsigned long flags,
+				   unsigned long oaddr,
+				   unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_DATA_MAP, rd, base, top, flags, oaddr
+	};
+	int ret;
+
+	ret = rmi_sro_execute(&regs);
+
+	if (out_top)
+		*out_top = regs.a1;
+
+	return ret;
+}
+
+/**
+ * rmi_rtt_data_unmap() - Remove mappings to conventional memory
+ * @rd: PA of the RD for the target Realm
+ * @base: Base of the target IPA range
+ * @top: Top of the target IPA range
+ * @flags: Flags
+ * @oaddr: Output address set descriptor
+ * @out_top: Returns top IPA of range which has been unmapped
+ * @out_range: Output address range
+ * @out_count: Number of entries in output address list
+ *
+ * Removes mappings to convention memory with a target Protected IPA range.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_data_unmap(unsigned long rd,
+				     unsigned long base,
+				     unsigned long top,
+				     unsigned long flags,
+				     unsigned long oaddr,
+				     unsigned long *out_top,
+				     unsigned long *out_range,
+				     unsigned long *out_count)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_DATA_UNMAP, rd, base, top, flags, oaddr
+	};
+	int ret;
+
+	ret = rmi_sro_execute(&regs);
+
+	if (out_top)
+		*out_top = regs.a1;
+	if (out_range)
+		*out_range = regs.a2;
+	if (out_count)
+		*out_count = regs.a3;
+
+	return ret;
+}
+
 /**
  * rmi_psci_complete() - Complete pending PSCI command
  * @calling_rec: PA of the calling REC
@@ -46,6 +142,98 @@ static inline int rmi_realm_activate(unsigned long rd)
 	return res.a0;
 }
 
+/**
+ * rmi_realm_create() - Create a realm
+ * @rd: PA of the RD
+ * @params: PA of realm parameters
+ * @sro: Preallocated SRO context to be used
+ *
+ * Create a new realm using the given parameters.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_create(unsigned long rd, unsigned long params,
+				   struct rmi_sro_state *sro)
+{
+	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL,
+				   SMC_RMI_REALM_CREATE, rd, params);
+}
+
+/**
+ * rmi_realm_terminate() - Terminate a realm
+ * @rd: PA of the RD
+ * @sro: Preallocated SRO context to be used
+ *
+ * Terminates a realm, moving it into a ZOMBIE state
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_terminate(unsigned long rd,
+				      struct rmi_sro_state *sro)
+{
+	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL,
+				   SMC_RMI_REALM_TERMINATE, rd);
+}
+
+/**
+ * rmi_realm_destroy() - Destroy a realm
+ * @rd: PA of the RD
+ * @sro: Preallocated SRO context to be used
+ *
+ * Destroys a realm, all objects belonging to the realm must be destroyed first.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_destroy(unsigned long rd,
+				    struct rmi_sro_state *sro)
+{
+	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL,
+				   SMC_RMI_REALM_DESTROY, rd);
+}
+
+/**
+ * rmi_rec_create() - Create a REC
+ * @rd: PA of the RD
+ * @rec: PA of the target REC
+ * @params: PA of REC parameters
+ * @sro: Allocated SRO context to be used
+ *
+ * Create a REC using the parameters specified in the struct rec_params pointed
+ * to by @params.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rec_create(unsigned long rd,
+				 unsigned long rec,
+				 unsigned long params,
+				 struct rmi_sro_state *sro)
+{
+	int ret;
+
+	*sro = (struct rmi_sro_state){.regs = {
+		SMC_RMI_REC_CREATE, rd, rec, params
+	}};
+	ret = rmi_sro_memxfer_execute(sro, GFP_KERNEL);
+	rmi_sro_free(sro);
+
+	return ret;
+}
+
+/**
+ * rmi_rec_destroy() - Destroy a REC
+ * @rec: PA of the target REC
+ * @sro: Allocated SRO context to be used
+ *
+ * Destroys a REC. The REC must not be running.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rec_destroy(unsigned long rec,
+				  struct rmi_sro_state *sro)
+{
+	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_REC_DESTROY, rec);
+}
+
 /**
  * rmi_rec_enter() - Enter a REC
  * @rec: PA of the target REC
@@ -64,4 +252,208 @@ static inline int rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
 	return res.a0;
 }
 
+/**
+ * rmi_rtt_create() - Creates an RTT
+ * @rd: PA of the RD
+ * @rtt: PA of the target RTT
+ * @ipa: Base of the IPA range described by the RTT
+ * @level: Depth of the RTT within the tree
+ *
+ * Creates an RTT (Realm Translation Table) at the specified level for the
+ * translation of the specified address within the realm.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_create(unsigned long rd, unsigned long rtt,
+				 unsigned long ipa, long level)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_CREATE, rd, rtt, ipa, level
+	};
+
+	return rmi_sro_execute(&regs);
+}
+
+/**
+ * rmi_rtt_destroy() - Destroy an RTT
+ * @rd: PA of the RD for the target realm
+ * @ipa: Base of the IPA range described by the RTT
+ * @level: RTT level
+ * @out_rtt: Pointer to write the PA of the RTT which was destroyed
+ * @out_top: Pointer to write the top IPA of non-live RTT entries, from entry
+ * at which the RTT walk terminated.
+ *
+ * Destroys an RTT. The RTT must be non-live, i.e. none of the entries in the
+ * table are in ASSIGNED or TABLE state.
+ *
+ * Return: RMI return code.
+ */
+static inline int rmi_rtt_destroy(unsigned long rd,
+				  unsigned long ipa,
+				  long level,
+				  unsigned long *out_rtt,
+				  unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_DESTROY, rd, ipa, level
+	};
+	int ret = rmi_sro_execute(&regs);
+
+	if (out_rtt)
+		*out_rtt = regs.a1;
+	if (out_top)
+		*out_top = regs.a2;
+
+	return ret;
+}
+
+/**
+ * rmi_rtt_fold() - Fold an RTT
+ * @rd: PA of the RD
+ * @ipa: Base of the IPA range described by the RTT
+ * @level: Depth of the RTT within the tree
+ * @out_rtt: Pointer to write the PA of the RTT which was destroyed
+ *
+ * Folds an RTT. If all entries with the RTT are 'homogeneous' the RTT can be
+ * folded into the parent and the RTT destroyed.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_fold(unsigned long rd, unsigned long ipa,
+			       long level, unsigned long *out_rtt)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_FOLD, rd, ipa, level
+	};
+	int ret = rmi_sro_execute(&regs);
+
+	if (out_rtt)
+		*out_rtt = regs.a1;
+
+	return ret;
+}
+
+/**
+ * rmi_rtt_init_ripas() - Set RIPAS for new realm
+ * @rd: PA of the RD
+ * @base: Base of target IPA region
+ * @top: Top of target IPA region
+ * @out_top: Top IPA of range whose RIPAS was modified
+ *
+ * Sets the RIPAS of a target IPA range to RAM, for a realm in the NEW state.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_init_ripas(unsigned long rd, unsigned long base,
+				     unsigned long top, unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_INIT_RIPAS, rd, base, top
+	};
+	int ret = rmi_sro_execute(&regs);
+
+	if (out_top)
+		*out_top = regs.a1;
+
+	return ret;
+}
+
+/**
+ * rmi_rtt_unprot_map() - Map unprotected granules into a realm
+ * @rd: PA of the RD
+ * @base: Base IPA of the mapping
+ * @top: Top of the target IPA range
+ * @flags: Flags
+ * @oaddr: Output address set descriptor
+ * @out_top: Top IPA of range which has been mapped
+ *
+ * Create mappings to memory within a target unprotected IPA range.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_unprot_map(unsigned long rd,
+				     unsigned long base,
+				     unsigned long top,
+				     unsigned long flags,
+				     unsigned long oaddr,
+				     unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_UNPROT_MAP, rd, base, top, flags, oaddr
+	};
+	int ret = rmi_sro_execute(&regs);
+
+	if (out_top)
+		*out_top = regs.a1;
+
+	return ret;
+}
+
+/**
+ * rmi_rtt_set_ripas() - Set RIPAS for an running realm
+ * @rd: PA of the RD
+ * @rec: PA of the REC making the request
+ * @base: Base of target IPA region
+ * @top: Top of target IPA region
+ * @out_top: Pointer to write top IPA of range whose RIPAS was modified
+ *
+ * Completes a request made by the realm to change the RIPAS of a target IPA
+ * range.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_set_ripas(unsigned long rd, unsigned long rec,
+				    unsigned long base, unsigned long top,
+				    unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_SET_RIPAS, rd, rec, base, top
+	};
+	int ret = rmi_sro_execute(&regs);
+
+	if (out_top)
+		*out_top = regs.a1;
+
+	return ret;
+}
+
+/**
+ * rmi_rtt_unprot_unmap() - Remove mappings within an unprotected IPA range
+ * @rd: PA of the RD
+ * @base: Base IPA of the mapping
+ * @top: Top of the target IPA range
+ * @flags: Flags
+ * @oaddr: Output address set descriptor
+ * @out_top: Top IPA which has been unmapped
+ * @out_range: Output address range
+ * @out_count: Number of entries in output address list
+ *
+ * Removes mappings to memory within a target unprotected IPA range.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_unprot_unmap(unsigned long rd,
+				       unsigned long base,
+				       unsigned long top,
+				       unsigned long flags,
+				       unsigned long oaddr,
+				       unsigned long *out_top,
+				       unsigned long *out_range,
+				       unsigned long *out_count)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_UNPROT_UNMAP, rd, base, top, flags, oaddr
+	};
+	int ret = rmi_sro_execute(&regs);
+
+	if (out_top)
+		*out_top = regs.a1;
+	if (out_range)
+		*out_range = regs.a2;
+	if (out_count)
+		*out_count = regs.a3;
+
+	return ret;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index e7ab4a7df3ca..6a9f61760fd7 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -6,6 +6,7 @@
 #include <linux/cpufeature.h>
 #include <linux/memblock.h>
 #include <linux/arm-rmi-cmds.h>
+#include <linux/processor.h>
 #include <linux/slab.h>
 
 #include <asm/memory.h>
@@ -22,6 +23,487 @@ unsigned long rmi_feat_reg(unsigned long id)
 
 	return rmi_feat_reg_cache[id];
 }
+EXPORT_SYMBOL_GPL(rmi_feat_reg);
+
+int rmi_delegate_range(phys_addr_t phys,
+		       unsigned long size,
+		       phys_addr_t *out_phys)
+{
+	unsigned long ret = 0;
+	unsigned long top = phys + size;
+	unsigned long out_top;
+
+	while (phys < top) {
+		ret = rmi_granule_range_delegate(phys, top, &out_top);
+		if (ret == RMI_SUCCESS)
+			phys = out_top;
+		else if (ret == RMI_BUSY || ret == RMI_BLOCKED)
+			cpu_relax();
+		else
+			break;
+	}
+
+	if (out_phys)
+		*out_phys = phys;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rmi_delegate_range);
+
+int rmi_undelegate_range(phys_addr_t phys,
+			 unsigned long size)
+{
+	unsigned long ret = 0;
+	unsigned long top = phys + size;
+	unsigned long out_top;
+
+	while (phys < top) {
+		ret = rmi_granule_range_undelegate(phys, top, &out_top);
+		if (ret == RMI_SUCCESS)
+			phys = out_top;
+		else if (ret == RMI_BUSY || ret == RMI_BLOCKED)
+			cpu_relax();
+		else
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rmi_undelegate_range);
+
+static unsigned long donate_req_to_size(unsigned long donatereq)
+{
+	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
+
+	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - unit_size));
+}
+
+static void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs_in,
+			     struct arm_smccc_1_2_regs *regs_out)
+{
+	struct arm_smccc_1_2_regs regs = *regs_in;
+	unsigned long status;
+
+	while (1) {
+		arm_smccc_1_2_invoke(&regs, regs_out);
+		status = RMI_RETURN_STATUS(regs_out->a0);
+		if (status != RMI_BUSY && status != RMI_BLOCKED)
+			break;
+		cpu_relax();
+	}
+}
+
+static void rmi_op_continue(unsigned long sro_handle, unsigned long flags,
+			    struct arm_smccc_1_2_regs *out_regs)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_CONTINUE, sro_handle, flags
+	};
+
+	rmi_smccc_invoke(&regs, out_regs);
+}
+
+static void rmi_op_cancel(unsigned long sro_handle,
+			  struct arm_smccc_1_2_regs *out_regs)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_CANCEL, sro_handle
+	};
+
+	rmi_smccc_invoke(&regs, out_regs);
+}
+
+static void rmi_op_mem_donate(unsigned long sro_handle, unsigned long list_addr,
+			      unsigned long list_count, unsigned long flags,
+			      struct arm_smccc_1_2_regs *out_regs)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_MEM_DONATE, sro_handle, list_addr, list_count, flags
+	};
+
+	rmi_smccc_invoke(&regs, out_regs);
+}
+
+static void rmi_op_mem_reclaim(unsigned long sro_handle,
+			       unsigned long list_addr,
+			       unsigned long list_count,
+			       struct arm_smccc_1_2_regs *out_regs)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_OP_MEM_RECLAIM, sro_handle, list_addr, list_count
+	};
+
+	rmi_smccc_invoke(&regs, out_regs);
+}
+
+int free_delegated_page(phys_addr_t phys)
+{
+	if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
+		/* Undelegate failed: leak the page */
+		return -EBUSY;
+	}
+
+	free_page((unsigned long)phys_to_virt(phys));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(free_delegated_page);
+
+static int rmi_sro_ensure_capacity(struct rmi_sro_state *sro,
+				   unsigned long count)
+{
+	if (WARN_ON_ONCE(sro->addr_count > RMI_MAX_ADDR_LIST))
+		return -EOVERFLOW;
+
+	if (count > RMI_MAX_ADDR_LIST - sro->addr_count)
+		return -ENOSPC;
+
+	return 0;
+}
+
+static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
+				 unsigned long sro_handle,
+				 unsigned long donatereq,
+				 struct arm_smccc_1_2_regs *out_regs,
+				 gfp_t gfp)
+{
+	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
+	unsigned long unit_size_bytes = donate_req_to_size(donatereq);
+	unsigned long count = RMI_DONATE_COUNT(donatereq);
+	unsigned long state = RMI_DONATE_STATE(donatereq);
+	unsigned long size = unit_size_bytes * count;
+	unsigned long addr_range;
+	int ret;
+	void *virt;
+	phys_addr_t phys;
+
+	for (int i = 0; i < sro->addr_count; i++) {
+		unsigned long entry = sro->addr_list[i];
+
+		if (RMI_ADDR_RANGE_SIZE(entry) == unit_size &&
+		    RMI_ADDR_RANGE_COUNT(entry) == count &&
+		    RMI_ADDR_RANGE_STATE(entry) == state &&
+		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
+			sro->addr_count--;
+			swap(sro->addr_list[sro->addr_count],
+			     sro->addr_list[i]);
+
+			goto out;
+		}
+	}
+
+	ret = rmi_sro_ensure_capacity(sro, 1);
+	if (ret)
+		return ret;
+
+	virt = alloc_pages_exact(size, gfp);
+	if (!virt)
+		return -ENOMEM;
+	phys = virt_to_phys(virt);
+
+	if (state == RMI_OP_MEM_DELEGATED) {
+		phys_addr_t delegated_phys;
+
+		if (rmi_delegate_range(phys, size, &delegated_phys)) {
+			if (!rmi_undelegate_range(phys, delegated_phys - phys))
+				free_pages_exact(virt, size);
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
+	rmi_op_mem_donate(sro_handle,
+			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
+			  0, out_regs);
+
+	unsigned long donated_granules = out_regs->a1;
+	unsigned long donated_size = donated_granules << PAGE_SHIFT;
+
+	if (donated_granules == 0) {
+		/* No pages used by the RMM */
+		sro->addr_count++;
+	} else if (donated_size < size) {
+		phys = sro->addr_list[sro->addr_count] & RMI_ADDR_RANGE_ADDR_MASK;
+
+		/* Not all granules used by the RMM, free the remaining pages */
+		for (long i = donated_size; i < size; i += PAGE_SIZE) {
+			if (state == RMI_OP_MEM_DELEGATED)
+				free_delegated_page(phys + i);
+			else
+				__free_page(phys_to_page(phys + i));
+		}
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
+	unsigned long unit_size_bytes = donate_req_to_size(donatereq);
+	unsigned long count = RMI_DONATE_COUNT(donatereq);
+	unsigned long state = RMI_DONATE_STATE(donatereq);
+	unsigned long found = 0;
+	unsigned long addr_list_start = sro->addr_count;
+	int ret;
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
+	ret = rmi_sro_ensure_capacity(sro, count - found);
+	if (ret)
+		return ret;
+
+	while (found < count) {
+		unsigned long addr_range;
+		void *virt = alloc_pages_exact(unit_size_bytes, gfp);
+		phys_addr_t phys;
+
+		if (!virt)
+			return -ENOMEM;
+
+		phys = virt_to_phys(virt);
+
+		if (state == RMI_OP_MEM_DELEGATED) {
+			phys_addr_t delegated_phys;
+
+			if (rmi_delegate_range(phys, unit_size_bytes,
+					       &delegated_phys)) {
+				if (!rmi_undelegate_range(phys, delegated_phys - phys))
+					free_pages_exact(virt, unit_size_bytes);
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
+	rmi_op_mem_donate(sro_handle,
+			  virt_to_phys(&sro->addr_list[addr_list_start]),
+			  found, 0, out_regs);
+
+	unsigned long donated_granules = out_regs->a1;
+	unsigned long granules_per_unit = unit_size_bytes >> PAGE_SHIFT;
+	unsigned long consumed_units;
+
+	/*
+	 * The RMM shouldn't report more granules than we provided, but clamp
+	 * just in case.
+	 */
+	if (WARN_ON_ONCE(donated_granules > found * granules_per_unit))
+		donated_granules = found * granules_per_unit;
+
+	/*
+	 * The RMM reports the consumed memory in terms of granules, but we
+	 * track in the address lists in unit-sized ranges. So divide to get
+	 * the number of (complete) consumed units.
+	 */
+	consumed_units = donated_granules / granules_per_unit;
+	if (donated_granules % granules_per_unit) {
+		/*
+		 * A unit has been partially consumed, the start is owned by
+		 * the RMM, the tail is owned by the host
+		 */
+		unsigned long entry =
+			sro->addr_list[addr_list_start + consumed_units];
+		phys_addr_t phys = RMI_ADDR_RANGE_ADDR(entry);
+		unsigned long donated_size =
+			(donated_granules % granules_per_unit) << PAGE_SHIFT;
+
+		/* Free the tail back */
+		for (unsigned long i = donated_size; i < unit_size_bytes;
+		     i += PAGE_SIZE) {
+			if (state == RMI_OP_MEM_DELEGATED)
+				free_delegated_page(phys + i);
+			else
+				__free_page(phys_to_page(phys + i));
+		}
+
+		/*
+		 * This unit is now fully 'consumed' (either held by the RMM or
+		 * freed)
+		 */
+		consumed_units++;
+	}
+
+	/* Keep just the units the RMM didn't use in addr_list */
+	for (unsigned long i = consumed_units; i < found; i++)
+		sro->addr_list[addr_list_start + i - consumed_units] =
+			sro->addr_list[addr_list_start + i];
+
+	sro->addr_count -= consumed_units;
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
+	if (WARN_ON_ONCE(!count))
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
+	unsigned long capacity;
+	int ret;
+
+	ret = rmi_sro_ensure_capacity(sro, 1);
+	if (ret)
+		rmi_sro_free(sro);
+
+	capacity = RMI_MAX_ADDR_LIST - sro->addr_count;
+
+	rmi_op_mem_reclaim(sro_handle,
+			   virt_to_phys(&sro->addr_list[sro->addr_count]),
+			   capacity, out_regs);
+
+	if (WARN_ON_ONCE(out_regs->a1 > capacity))
+		out_regs->a1 = capacity;
+
+	sro->addr_count += out_regs->a1;
+
+	return 0;
+}
+
+void rmi_sro_free(struct rmi_sro_state *sro)
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
+			if (WARN_ON_ONCE(rmi_undelegate_range(addr, size))) {
+				/* Leak the pages */
+				continue;
+			}
+		}
+		free_pages_exact(phys_to_virt(addr), size);
+	}
+
+	sro->addr_count = 0;
+}
+EXPORT_SYMBOL_GPL(rmi_sro_free);
+
+unsigned long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
+{
+	unsigned long sro_handle;
+	struct arm_smccc_1_2_regs *regs = &sro->regs;
+
+	rmi_smccc_invoke(regs, regs);
+
+	sro_handle = regs->a1;
+
+	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
+		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
+		int ret = 0;
+
+		switch (RMI_RETURN_MEMREQ(regs->a0)) {
+		case RMI_OP_MEM_REQ_NONE:
+			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
+					regs);
+			break;
+		case RMI_OP_MEM_REQ_DONATE:
+			ret = rmi_sro_donate(sro, sro_handle, regs->a2, regs,
+					     gfp);
+			break;
+		case RMI_OP_MEM_REQ_RECLAIM:
+			ret = rmi_sro_reclaim(sro, sro_handle, regs);
+			break;
+		default:
+			ret = WARN_ON_ONCE(1);
+			break;
+		}
+
+		if (ret) {
+			if (can_cancel)
+				rmi_op_cancel(sro_handle, regs);
+
+			if (WARN_ON_ONCE(RMI_RETURN_STATUS(regs->a0) != RMI_INCOMPLETE))
+				return ret;
+		}
+	}
+
+	return regs->a0;
+}
+EXPORT_SYMBOL_GPL(rmi_sro_memxfer_execute);
+
+/* For RMI commands that are stateful but not memory-transferring */
+unsigned long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
+{
+	unsigned long sro_handle;
+
+	rmi_smccc_invoke(regs, regs);
+
+	sro_handle = regs->a1;
+
+	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
+		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
+
+		switch (RMI_RETURN_MEMREQ(regs->a0)) {
+		case RMI_OP_MEM_REQ_NONE:
+			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
+					regs);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			if (!can_cancel)
+				return regs->a0;
+
+			rmi_op_cancel(sro_handle, regs);
+		}
+	}
+
+	return regs->a0;
+}
+EXPORT_SYMBOL_GPL(rmi_sro_execute);
 
 static int rmi_check_version(void)
 {
@@ -80,8 +562,9 @@ static int rmi_configure(void)
 {
 	unsigned long ret;
 	struct rmm_config *config __free(free_page) = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
+	struct rmi_sro_state *sro __free(kfree) = (struct rmi_sro_state *)kmalloc_obj(*sro);
 
-	if (!config)
+	if (!config || !sro)
 		return -ENOMEM;
 
 	switch (PAGE_SIZE) {
@@ -112,6 +595,12 @@ static int rmi_configure(void)
 		return -EINVAL;
 	}
 
+	ret = rmi_rmm_activate(sro);
+	if (ret) {
+		pr_err("RMM activate failed\n");
+		return -ENXIO;
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index c038c1d685fa..138983ab4e3c 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -19,10 +19,45 @@ struct rtt_entry {
 	int ripas;
 };
 
+#define RMI_MAX_ADDR_LIST	256
+
+struct rmi_sro_state {
+	struct arm_smccc_1_2_regs regs;
+	unsigned long addr_count;
+	unsigned long addr_list[RMI_MAX_ADDR_LIST];
+};
+
 unsigned long rmi_feat_reg(unsigned long id);
 
+int rmi_delegate_range(phys_addr_t phys, unsigned long size,
+		       phys_addr_t *out_phys);
+int rmi_undelegate_range(phys_addr_t phys, unsigned long size);
+int free_delegated_page(phys_addr_t phys);
+
+static inline int rmi_delegate_page(phys_addr_t phys)
+{
+	return rmi_delegate_range(phys, PAGE_SIZE, NULL);
+}
+
+static inline int rmi_undelegate_page(phys_addr_t phys)
+{
+	return rmi_undelegate_range(phys, PAGE_SIZE);
+}
+
 bool is_rmi_available(void);
 
+unsigned long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp);
+void rmi_sro_free(struct rmi_sro_state *sro);
+unsigned long rmi_sro_execute(struct arm_smccc_1_2_regs *regs);
+
+#define rmi_sro_memxfer_cmd(sro, gfp, ...) ({				\
+	struct rmi_sro_state *__sro = (sro);				\
+	*__sro = (struct rmi_sro_state){ .regs = {__VA_ARGS__} };	\
+	int __ret = rmi_sro_memxfer_execute(__sro, gfp);		\
+	rmi_sro_free(__sro);						\
+	__ret;								\
+})
+
 /**
  * rmi_rmm_config_set() - Configure the RMM
  * @cfg_ptr: PA of a struct rmm_config
@@ -40,6 +75,17 @@ static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
 	return res.a0;
 }
 
+/**
+ * rmi_rmm_activate() - Activate the RMM
+ * @sro: Preallocated SRO context to be used
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rmm_activate(struct rmi_sro_state *sro)
+{
+	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
+}
+
 /**
  * rmi_granule_tracking_get() - Get configuration of a Granule tracking region
  * @start: Base PA of the tracking region
@@ -70,6 +116,21 @@ static inline int rmi_granule_tracking_get(unsigned long start,
 	return res.a0;
 }
 
+/**
+ * rmi_gpt_l1_create() - Create a Level 1 GPT
+ * @addr: Base of physical address region described by the L1GPT
+ * @sro: Preallocated SRO context to be used
+ * @gfp: Allocation flags for SRO memory donation requests
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_gpt_l1_create(unsigned long addr,
+				    struct rmi_sro_state *sro,
+				    gfp_t gfp)
+{
+	return rmi_sro_memxfer_cmd(sro, gfp, SMC_RMI_GPT_L1_CREATE, addr);
+}
+
 /**
  * rmi_features() - Read feature register
  * @index: Feature register index
@@ -88,4 +149,57 @@ static inline int rmi_features(unsigned long index, unsigned long *out)
 	return res.a0;
 }
 
+/**
+ * rmi_granule_range_delegate() - Delegate granules
+ * @base: PA of the first granule of the range
+ * @top: PA of the first granule after the range
+ * @out_top: PA of the first granule not delegated
+ *
+ * Delegate a range of granule for use by the realm world. If the entire range
+ * was delegated then @out_top == @top, otherwise the function should be called
+ * again with @base == @out_top.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_granule_range_delegate(unsigned long base,
+					     unsigned long top,
+					     unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_GRANULE_RANGE_DELEGATE, base, top
+	};
+	int ret = rmi_sro_execute(&regs);
+
+	if (out_top)
+		*out_top = regs.a1;
+
+	return ret;
+}
+
+/**
+ * rmi_granule_range_undelegate() - Undelegate a range of granules
+ * @base: Base PA of the target range
+ * @top: Top PA of the target range
+ * @out_top: Returns the top PA of range whose state is undelegated
+ *
+ * Undelegate a range of granules to allow use by the normal world. Will fail if
+ * the granules are in use.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_granule_range_undelegate(unsigned long base,
+					       unsigned long top,
+					       unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_GRANULE_RANGE_UNDELEGATE, base, top
+	};
+	int ret = rmi_sro_execute(&regs);
+
+	if (out_top)
+		*out_top = regs.a1;
+
+	return ret;
+}
+
 #endif
-- 
2.43.0

