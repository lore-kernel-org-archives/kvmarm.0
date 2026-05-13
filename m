Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917F62E1C4E;
	Wed, 13 May 2026 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678328; cv=none; b=AihIUPxj17bbHTvTMyHp3DC8lCe9sPucMVETqnUsx0PObGQ6njv+bS8VWCX25wMPmqLvjJ7RpHRpFdc3BnIa3M5sjDkD1wWVKHy2lwBep69PcLNyDaK/t+UNxEICZ7Fz0ItJ8rd34kR+P0fztwEHuNiK6nLcaT9iY8ncYK2Vj5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678328; c=relaxed/simple;
	bh=HboZRWJ8Bx4TSM158nLn/dbDk6zg9vnQcHR5oSLPBfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJ8/OFBb4LG8Hs7axMkSTHN35XpdQQM+clD0n4X3zkkBf/ZhTkg0lWAIgNA//Xuufs3mc002wAhxuCmf6YSjbRzD5YCkemiuz1gBco4vMcOv5byEIeUBfuh1BIcSn5HdDvip5+ZnN94ZhrMYECkAhBbVBBN0ylyDeO2qHZtXctY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XaOTCTon; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XaOTCTon"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A65B92008;
	Wed, 13 May 2026 06:18:40 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22F1A3F836;
	Wed, 13 May 2026 06:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678325; bh=HboZRWJ8Bx4TSM158nLn/dbDk6zg9vnQcHR5oSLPBfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaOTCTonVkd4KwjYUouyGDy+lHZ5WYRPv1tjWkgEkzBIkhqyq2v5/OI5Gpu3T/rpJ
	 bfdQFKGma/9Yhoa2/ssF2QiOhfCufN17xsObWMHlwq9AhqJPFMIWgnPivSZQYu1uWp
	 83RfERR7bLKc1fEo0FO2RDAIVi79Ahh/R1/MfDm4=
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
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 05/44] arm64: RMI: Add wrappers for RMI calls
Date: Wed, 13 May 2026 14:17:13 +0100
Message-ID: <20260513131757.116630-6-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The wrappers make the call sites easier to read and deal with the
boiler plate of handling the error codes from the RMM.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes from v13:
 * Update to RMM v2.0-bet1 spec including some SRO support (there still
   some FIXMEs where SRO support is incomplete).
Changes from v12:
 * Update to RMM v2.0 specification
Changes from v8:
 * Switch from arm_smccc_1_2_smc() to arm_smccc_1_2_invoke() in
   rmi_rtt_read_entry() for consistency.
Changes from v7:
 * Minor renaming of parameters and updated comments
Changes from v5:
 * Further improve comments
Changes from v4:
 * Improve comments
Changes from v2:
 * Make output arguments optional.
 * Mask RIPAS value rmi_rtt_read_entry()
 * Drop unused rmi_rtt_get_phys()
---
 arch/arm64/include/asm/rmi_cmds.h | 661 ++++++++++++++++++++++++++++++
 1 file changed, 661 insertions(+)
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
new file mode 100644
index 000000000000..04f7066894e9
--- /dev/null
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -0,0 +1,661 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#ifndef __ASM_RMI_CMDS_H
+#define __ASM_RMI_CMDS_H
+
+#include <linux/arm-smccc.h>
+
+#include <asm/rmi_smc.h>
+
+struct rtt_entry {
+	unsigned long walk_level;
+	unsigned long desc;
+	int state;
+	int ripas;
+};
+
+#define RMI_MAX_ADDR_LIST	256
+
+struct rmi_sro_state {
+	struct arm_smccc_1_2_regs regs;
+	unsigned long addr_count;
+	unsigned long addr_list[RMI_MAX_ADDR_LIST];
+};
+
+#define rmi_smccc(...) do {						\
+	arm_smccc_1_1_invoke(__VA_ARGS__);				\
+} while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY ||			\
+	 RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
+
+unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp);
+void rmi_sro_free(struct rmi_sro_state *sro);
+
+/**
+ * rmi_rmm_config_set() - Configure the RMM
+ * @cfg_ptr: PA of a struct rmm_config
+ *
+ * Sets configuration options on the RMM.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RMM_CONFIG_SET, cfg_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_rmm_activate() - Activate the RMM
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rmm_activate(void)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RMM_ACTIVATE, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_granule_tracking_get() - Get configuration of a Granule tracking region
+ * @start: Base PA of the tracking region
+ * @end: End of the PA region
+ * @out_category: Memory category
+ * @out_state: Tracking region state
+ * @out_top: Top of the memory region
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_granule_tracking_get(unsigned long start,
+					   unsigned long end,
+					   unsigned long *out_category,
+					   unsigned long *out_state,
+					   unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_TRACKING_GET, start, end, &res);
+
+	if (out_category)
+		*out_category = res.a1;
+	if (out_state)
+		*out_state = res.a2;
+	if (out_top)
+		*out_top = res.a3;
+
+	return res.a0;
+}
+
+/**
+ * rmi_gpt_l1_create() - Create a Level 1 GPT
+ * @addr: Base of physical address region described by the L1GPT
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_gpt_l1_create(unsigned long addr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_GPT_L1_CREATE, addr, &res);
+
+	if (RMI_RETURN_STATUS(res.a0) == RMI_INCOMPLETE) {
+		/* FIXME */
+		return WARN_ON(res.a0);
+	}
+
+	return res.a0;
+}
+
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_DATA_MAP_INIT, rd, data, ipa, src,
+			     flags, &res);
+
+	return res.a0;
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_DATA_MAP, rd, base, top, flags, oaddr,
+			     &res);
+
+	if (RMI_RETURN_STATUS(res.a0) == RMI_INCOMPLETE) {
+		/* FIXME */
+		return WARN_ON(res.a0);
+	}
+
+	if (out_top)
+		*out_top = res.a1;
+
+	return res.a0;
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_DATA_UNMAP, rd, base, top, flags,
+			     oaddr, &res);
+
+	/* FIXME: Handle SRO */
+
+	if (out_top)
+		*out_top = res.a1;
+	if (out_range)
+		*out_range = res.a2;
+	if (out_count)
+		*out_count = res.a3;
+
+	return res.a0;
+}
+
+/**
+ * rmi_features() - Read feature register
+ * @index: Feature register index
+ * @out: Feature register value is written to this pointer
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_features(unsigned long index, unsigned long *out)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
+
+	if (out)
+		*out = res.a1;
+	return res.a0;
+}
+
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_RANGE_DELEGATE, base, top, &res);
+
+	if (RMI_RETURN_STATUS(res.a0) == RMI_INCOMPLETE) {
+		/* FIXME - Handle SRO */
+		return WARN_ON(res.a0);
+	}
+
+	if (out_top)
+		*out_top = res.a1;
+
+	return res.a0;
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_RANGE_UNDELEGATE, base, top, &res);
+
+	if (RMI_RETURN_STATUS(res.a0) == RMI_INCOMPLETE) {
+		/* FIXME - Handle SRO */
+		return WARN_ON(res.a0);
+	}
+
+	if (out_top)
+		*out_top = res.a1;
+
+	return res.a0;
+}
+
+/**
+ * rmi_psci_complete() - Complete pending PSCI command
+ * @calling_rec: PA of the calling REC
+ * @target_rec: PA of the target REC
+ * @status: Status of the PSCI request
+ *
+ * Completes a pending PSCI command which was called with an MPIDR argument, by
+ * providing the corresponding REC.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_psci_complete(unsigned long calling_rec,
+				    unsigned long target_rec,
+				    unsigned long status)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PSCI_COMPLETE, calling_rec, target_rec,
+			     status, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_realm_activate() - Active a realm
+ * @rd: PA of the RD
+ *
+ * Mark a realm as Active signalling that creation is complete and allowing
+ * execution of the realm.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_activate(unsigned long rd)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_ACTIVATE, rd, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_realm_create() - Create a realm
+ * @rd: PA of the RD
+ * @params: PA of realm parameters
+ *
+ * Create a new realm using the given parameters.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_create(unsigned long rd, unsigned long params)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_CREATE, rd, params, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_realm_terminate() - Terminate a realm
+ * @rd: PA of the RD
+ *
+ * Terminates a realm, moving it into a ZOMBIE state
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_terminate(unsigned long rd)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_TERMINATE, rd, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_realm_destroy() - Destroy a realm
+ * @rd: PA of the RD
+ *
+ * Destroys a realm, all objects belonging to the realm must be destroyed first.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_destroy(unsigned long rd)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_DESTROY, rd, &res);
+
+	return res.a0;
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
+	ret = rmi_sro_execute(sro, GFP_KERNEL);
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
+	int ret;
+
+	*sro = (struct rmi_sro_state){.regs = {
+		SMC_RMI_REC_DESTROY, rec
+	}};
+	ret = rmi_sro_execute(sro, GFP_KERNEL);
+	rmi_sro_free(sro);
+
+	return ret;
+}
+
+/**
+ * rmi_rec_enter() - Enter a REC
+ * @rec: PA of the target REC
+ * @run_ptr: PA of RecRun structure
+ *
+ * Starts (or continues) execution within a REC.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REC_ENTER, rec, run_ptr, &res);
+
+	return res.a0;
+}
+
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_CREATE, rd, rtt, ipa, level, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_destroy() - Destroy an RTT
+ * @rd: PA of the RD
+ * @ipa: Base of the IPA range described by the RTT
+ * @level: Depth of the RTT within the tree
+ * @out_rtt: Pointer to write the PA of the RTT which was destroyed
+ * @out_top: Pointer to write the top IPA of non-live RTT entries
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_DESTROY, rd, ipa, level, &res);
+
+	if (out_rtt)
+		*out_rtt = res.a1;
+	if (out_top)
+		*out_top = res.a2;
+
+	return res.a0;
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_FOLD, rd, ipa, level, &res);
+
+	if (out_rtt)
+		*out_rtt = res.a1;
+
+	return res.a0;
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_INIT_RIPAS, rd, base, top, &res);
+
+	if (out_top)
+		*out_top = res.a1;
+
+	return res.a0;
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_UNPROT_MAP, rd, base, top, flags,
+			     oaddr, &res);
+
+	/* FIXME: Handle SRO */
+
+	if (out_top)
+		*out_top = res.a1;
+
+	return res.a0;
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_SET_RIPAS, rd, rec, base, top, &res);
+
+	if (out_top)
+		*out_top = res.a1;
+
+	return res.a0;
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
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_UNPROT_UNMAP, rd, base, top,
+			     flags, oaddr, &res);
+
+	/* FIXME: Handle SRO */
+
+	if (out_top)
+		*out_top = res.a1;
+	if (out_range)
+		*out_range = res.a2;
+	if (out_count)
+		*out_count = res.a3;
+
+	return res.a0;
+}
+
+#endif /* __ASM_RMI_CMDS_H */
-- 
2.43.0

