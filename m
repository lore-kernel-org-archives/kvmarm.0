Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDE74A8FD8;
	Thu,  1 Oct 2026 08:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844416; cv=none; b=gu+d6TJ9PKV9A6laW50jnwIx9UfqtTjgVt0Ytmk++15MudvC04hoBlauX3VH/5GB+Un37fYAAR/z/4kYVSEXR8RoLJEDjo7rfu7lFzgGF/BQwgpIP2GvApP6X9vMuQzmw1jxP2dbcvQ/nJPRtM3cJ1Eo946ieCKEdFIVLzCf0rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844416; c=relaxed/simple;
	bh=b9Ys1LOWNYJtWL97kkhzDZVQlRS7KKHQklMrcNEsf2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIgHIZMO8qVYYqpoGXOrpp4JBgy9x1trfGDZnPhwaYOy3moFZiyC2UOWxv1pm6eP6vpnnSb6u8YocjS3K6ZJ+tIO/ugvw44sr4MLVD7fzuktXcjqhW6cVPDHppBpQXVGPek/IfBmPPLZAU5S1Jk2GswgzzloMeKyG6zxL8go0Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ioFGVP1V; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ioFGVP1V"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1AB6497;
	Thu,  1 Oct 2026 01:46:49 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 140B43F85F;
	Thu,  1 Oct 2026 01:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790844413; bh=b9Ys1LOWNYJtWL97kkhzDZVQlRS7KKHQklMrcNEsf2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ioFGVP1VxfPAQqwSrXfC1gkNvFfo4pRVNuvwxwgplrKnnkpMbJ6ysVC7gtN8TKEUg
	 oWEP6Jbdq8KY7SZ9jKpeM3Js1mdzmMpniFKydHy7psQ+ChXySbS+me+Nwz0y5AkjNQ
	 lsyMoZPPef4v17T1q3o4hpxlStqY/ktabK0gr+As=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v21 8/9] firmware: arm_rmm: Add wrappers for Realm related RMI commands
Date: Thu,  1 Oct 2026 09:45:54 +0100
Message-ID: <20261001084555.1456543-9-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001084555.1456543-1-suzuki.poulose@arm.com>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

Introduce wrappers for the RMI functions needed for creating and
managing realm guests. This will be used by the KVM to manage the
Realms

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes sicne v20:
  * Add rmi_smccc_invoke_once() and use that for rec_enter
Changes since v19:
  * Use rmi_sro_memxfr_command() for rec_create - Catalin
Changes since v18:
  * Convert the last man standing nesting if - Gavin
  * Pass out_top for RMI_ERROR_RTT for rmi_rtt_destroy()
Changes since v17:
  * Avoid nesting if conditions for output populating RMI calls
  * Clean up comments
  * Always use arm_smccc_1_2_invoke() for RMI calls.
Changes since v16:
  * Split into a separate patch and move away from arch/arm64 to
    include/linux/.
  * Also moved into the firmware_rmm series from the KVM CCA support.
    This is done in a hope to reduce the merge conflicts and make
    the KVM CCA upstreaming in independent parallel chunks
---
 include/linux/arm-rmi-cmds.h | 471 +++++++++++++++++++++++++++++++++++
 1 file changed, 471 insertions(+)

diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 5d005054f3c6c..e3503aba646e2 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -53,6 +53,17 @@ static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
 	}
 }
 
+/*
+ * rmi_smccc_invoke_once: Invoke the RMI call and return the results. Do not
+ * retry the command. Let the caller deal with RMI_BUSY or RMI_BLOCKED.
+ */
+static inline void rmi_smccc_invoke_once(struct arm_smccc_1_2_regs *regs)
+{
+	struct arm_smccc_1_2_regs args = *regs;
+
+	arm_smccc_1_2_invoke(&args, regs);
+}
+
 unsigned long rmi_feat_reg(unsigned int index);
 
 int rmi_delegate_range(phys_addr_t phys, unsigned long size,
@@ -104,4 +115,464 @@ static inline bool is_rmi_available(void)
 }
 #endif	/* CONFIG_ARM_RMM_RMI */
 
+
+/**
+ * rmi_rtt_data_map_init() - Create a mapping at protected IPA, copying contents
+ *			     from a given non-secure source granule.
+ * @rd: PA of the RD
+ * @data: PA of the target granule mapped in the guest
+ * @ipa: IPA at which the granule @data will be mapped in the guest
+ * @src: PA of the source granule with contents
+ * @flags: RMI_MEASURE_CONTENT if the contents should be measured
+ *
+ * Create a mapping from Protected IPA space to conventional memory, copying
+ * contents from a Non-secure Granule provided by the caller.
+ *
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rtt_data_map_init(unsigned long rd, unsigned long data,
+					 unsigned long ipa, unsigned long src,
+					 unsigned long flags)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_DATA_MAP_INIT, rd, data, ipa, src, flags
+	};
+
+	return rmi_sro_execute(&regs);
+}
+
+/**
+ * rmi_rtt_data_map() - Create mappings in protected IPA range with unknown contents
+ * @rd: PA of the RD
+ * @base: Base of the target IPA range
+ * @top: Top of the target IPA range
+ * @flags: Flags
+ * @oaddr: Output address set descriptor
+ * @out_top: Top address of range which was processed.
+ *
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rtt_data_map(unsigned long rd,
+				    unsigned long base,
+				    unsigned long top,
+				    unsigned long flags,
+				    unsigned long oaddr,
+				    unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_DATA_MAP, rd, base, top, flags, oaddr
+	};
+	long ret;
+
+	ret = rmi_sro_execute(&regs);
+
+	if (ret == RMI_SUCCESS && out_top)
+		*out_top = regs.a1;
+
+	return ret;
+}
+
+/**
+ * rmi_rtt_data_unmap() - Remove mappings to conventional memory at a protected
+ *			  IPA range
+ * @rd: PA of the RD
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
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rtt_data_unmap(unsigned long rd,
+				      unsigned long base,
+				      unsigned long top,
+				      unsigned long flags,
+				      unsigned long oaddr,
+				      unsigned long *out_top,
+				      unsigned long *out_range,
+				      unsigned long *out_count)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_DATA_UNMAP, rd, base, top, flags, oaddr
+	};
+	long ret;
+
+	ret = rmi_sro_execute(&regs);
+
+	if (ret != RMI_SUCCESS)
+		return ret;
+
+	if (out_top)
+		*out_top = regs.a1;
+	if (out_range)
+		*out_range = regs.a2;
+	if (out_count)
+		*out_count = regs.a3;
+
+	return RMI_SUCCESS;
+}
+
+/**
+ * rmi_psci_complete() - Complete pending PSCI command
+ * @calling_rec: PA of the calling REC
+ * @status: Status of the PSCI request
+ *
+ * Completes a pending PSCI command.
+ *
+ * Return: RMI return code
+ */
+static inline long rmi_psci_complete(unsigned long calling_rec,
+				     unsigned long status)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_PSCI_COMPLETE, calling_rec, status,
+	};
+
+	rmi_smccc_invoke(&regs);
+	return regs.a0;
+}
+
+/**
+ * rmi_realm_activate() - Activate a realm
+ * @rd: PA of the RD
+ *
+ * Mark a realm as Active, signalling that creation is completed, allowing
+ * execution of the realm.
+ *
+ * Return: RMI return code
+ */
+static inline long rmi_realm_activate(unsigned long rd)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_REALM_ACTIVATE, rd,
+	};
+
+	rmi_smccc_invoke(&regs);
+	return regs.a0;
+}
+
+/**
+ * rmi_realm_create() - Create a realm
+ * @rd: PA of the RD
+ * @params: PA of realm parameters
+ * @sro: Preallocated SRO context
+ *
+ * Create a new realm using the given parameters.
+ *
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_realm_create(unsigned long rd, unsigned long params,
+				    struct rmi_sro_state *sro)
+{
+	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL,
+				   SMC_RMI_REALM_CREATE, rd, params);
+}
+
+/**
+ * rmi_realm_terminate() - Terminate a realm
+ * @rd: PA of the RD
+ * @sro: Preallocated SRO context
+ *
+ * Terminates a realm, moving it into a ZOMBIE state
+ *
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_realm_terminate(unsigned long rd,
+				       struct rmi_sro_state *sro)
+{
+	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL,
+				   SMC_RMI_REALM_TERMINATE, rd);
+}
+
+/**
+ * rmi_realm_destroy() - Destroy a realm
+ * @rd: PA of the RD
+ * @sro: Preallocated SRO context
+ *
+ * Destroys a realm, all objects belonging to the realm must be destroyed first.
+ *
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_realm_destroy(unsigned long rd,
+				     struct rmi_sro_state *sro)
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
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rec_create(unsigned long rd,
+				  unsigned long rec,
+				  unsigned long params,
+				  struct rmi_sro_state *sro)
+{
+	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL,
+				   SMC_RMI_REC_CREATE, rd, rec, params);
+}
+
+/**
+ * rmi_rec_destroy() - Destroy a REC
+ * @rec: PA of the target REC
+ * @sro: Allocated SRO context to be used
+ *
+ * Destroys a REC. The REC must not be running.
+ *
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rec_destroy(unsigned long rec,
+				   struct rmi_sro_state *sro)
+{
+	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_REC_DESTROY, rec);
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
+static inline long rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_REC_ENTER, rec, run_ptr,
+	};
+
+	rmi_smccc_invoke_once(&regs);
+	return regs.a0;
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
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rtt_create(unsigned long rd, unsigned long rtt,
+				  unsigned long ipa, long level)
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
+ * @rd: PA of the RD
+ * @ipa: Base of the IPA range described by the RTT
+ * @level: RTT level
+ * @out_rtt: Pointer to write the PA of the RTT which was destroyed
+ * @out_top: Pointer to write the top IPA of non-live RTT entries, from entry
+ * at which the RTT walk terminated.
+ *
+ * Destroys an RTT. The RTT must be non-live, i.e. none of the entries in the
+ * table are in ASSIGNED or TABLE state.
+ *
+ * Return: 0 on success, positive RMI result code or negative Linux error code.
+ */
+static inline long rmi_rtt_destroy(unsigned long rd,
+				   unsigned long ipa,
+				   long level,
+				   unsigned long *out_rtt,
+				   unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_DESTROY, rd, ipa, level
+	};
+	long ret = rmi_sro_execute(&regs);
+
+	switch (RMI_RESULT_STATUS(ret)) {
+	case RMI_SUCCESS:
+		if (out_rtt)
+			*out_rtt = regs.a1;
+		fallthrough;
+	case RMI_ERROR_RTT:
+		if (out_top)
+			*out_top = regs.a2;
+		break;
+	default:
+		break;
+	}
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
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rtt_fold(unsigned long rd, unsigned long ipa,
+				long level, unsigned long *out_rtt)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_FOLD, rd, ipa, level
+	};
+	long ret = rmi_sro_execute(&regs);
+
+	if (ret == RMI_SUCCESS && out_rtt)
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
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rtt_init_ripas(unsigned long rd, unsigned long base,
+				      unsigned long top, unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_INIT_RIPAS, rd, base, top
+	};
+	long ret = rmi_sro_execute(&regs);
+
+	if (ret == RMI_SUCCESS && out_top)
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
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rtt_unprot_map(unsigned long rd,
+				      unsigned long base,
+				      unsigned long top,
+				      unsigned long flags,
+				      unsigned long oaddr,
+				      unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_UNPROT_MAP, rd, base, top, flags, oaddr
+	};
+	long ret = rmi_sro_execute(&regs);
+
+	if (ret == RMI_SUCCESS && out_top)
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
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rtt_set_ripas(unsigned long rd, unsigned long rec,
+				     unsigned long base, unsigned long top,
+				     unsigned long *out_top)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_SET_RIPAS, rd, rec, base, top
+	};
+	long ret = rmi_sro_execute(&regs);
+
+	if (ret == RMI_SUCCESS && out_top)
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
+ * Return: 0 on success, positive RMI result code or negative Linux error code
+ */
+static inline long rmi_rtt_unprot_unmap(unsigned long rd,
+					unsigned long base,
+					unsigned long top,
+					unsigned long flags,
+					unsigned long oaddr,
+					unsigned long *out_top,
+					unsigned long *out_range,
+					unsigned long *out_count)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_UNPROT_UNMAP, rd, base, top, flags, oaddr
+	};
+	long ret = rmi_sro_execute(&regs);
+
+	if (ret != RMI_SUCCESS)
+		return ret;
+
+	if (out_top)
+		*out_top = regs.a1;
+	if (out_range)
+		*out_range = regs.a2;
+	if (out_count)
+		*out_count = regs.a3;
+
+	return RMI_SUCCESS;
+}
+
 #endif	/* __LINUX_ARM_RMI_CMDS_H_ */
-- 
2.43.0

