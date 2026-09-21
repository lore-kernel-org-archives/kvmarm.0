Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446244D4895
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009299; cv=none; b=pM0SfXtKVAcAvSNTk7ZiYaYlqpMwB7Qccdp4BqiguUK9M3E19/LV9onsrT6ieFkTTkEnSyYJqksKXOrGFvDAGujXxTuu17knFy67nEh0PssNCSCvRprncJefY9JN3N7p+HmyxkAuSjvWYNCnt/PD6aYsVaeRyhOZ3pA3PCPmObw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009299; c=relaxed/simple;
	bh=E9l9/OzmnC+8t7QEGgstq55nV1kKkLSE68Bl7z3n0+8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XCgc3PBN27TjRQRtNqq8W4Nfhldx70UfV5fzdijL2PLpUH65Le+Bc9N/rlhHheSbY0jMELMQ/GSk1A2e0g6q343rO62isnvWPZbs3YUwbKIvGxClsbJZG2mUlr7s909Hd/OLENqYzglx+jAgm0Up9anId2m1Ow9U+xp2zmf+6jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YPSgF/qv; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YPSgF/qv"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e65bee41aso746805e9.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 09:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790009295; x=1790614095; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SRMphI5T1L64WHuwz6aodMyAcWwTtLqR1TEhwEfUsrw=;
        b=YPSgF/qvqdA+tRGRVmlZ+VUByno3mu2u9gwHlpkIp3pbui82I3TfHihY2XLdLsR5jo
         k1IWYOGDKMdwevVA54qTrhD8A5fitd3jS0cwmAQPDLLdsdNXvqXHHF4NY7QhUQb//s3G
         IVgdVO6xvyUkNeUhNKs20Vf5ksMMoK706pibUPl0WCj4hGjQHnV7T+qGE5bE1H2/kNk+
         /7a752Z768Xg8eJL4xeURXCPA6pFkeiiMdZ7yNVNsijta6Z1o3iiDwcOdEg2YoXj79Y6
         O5l1vLw4tjPAassKj1xJZizZh9T+c3ZjxO8w4P5fXvE36S/eRwjy5exVQDx6LqHceINM
         iGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790009295; x=1790614095;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SRMphI5T1L64WHuwz6aodMyAcWwTtLqR1TEhwEfUsrw=;
        b=Gg+cc3ar+Msix3WoC4dmaJ/ViZrnpl7Hisb0bVOCl8oTK+UOUQPE6lxwGn+GhKhHQA
         bvQGbi4O0AFNjcSCuTRrzQP700fX3RrAPwg7ctMdZRUz6+PjxEFCAIjE+2zCkkGfxDKX
         Jom/EH2Y+E1tkiAG3Eo+ohD/xMF4rf8z6xznJLRDey3cetldxP/TZWOOV8Om71u21e+r
         eWv1efPiEu0Ntc6tQaSSp2R+Yx3qsqu3xTQi4XpS3vLD8Xu8S736VJ80Xz2QjX0ua9z5
         KaFAkZRUT4xlB3AN2BmBtCDl2x7Dw8VSvrcGnyVJ46UriCdDZDP7zd1eK+VxpgGYBNOG
         h7LQ==
X-Forwarded-Encrypted: i=1; AKwUvByv7Sn00tn/gASvEtRsUXRCd/YqDBflas4dVK2ewwW9CZxE8SLbeQoOHwGgRfuW1/q+e6dxKGE=@lists.linux.dev
X-Gm-Message-State: AFuF++nzWsyas9jJtFg1wk+74opUfAqj/9nvteumezCumhwresdmdf4b
	15WXME095zNm8k7PK0DwUKhmCEyAj79ePAtooZ9LtxjVgnIsPNrC2nSIH8GFLRCIhSD7XfazUJs
	ePO5K/npI/3H7WJEl+ihnRHUSWw==
X-Received: from wrbfm9.prod.google.com ([2002:a05:6000:2809:b0:488:5e25:c0aa])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:4443:20b0:49f:bb49:9cca with SMTP id 5b1f17b1804b1-49fd883ccd1mr3241865e9.5.1790009295199;
 Mon, 21 Sep 2026 09:48:15 -0700 (PDT)
Date: Mon, 21 Sep 2026 16:47:48 +0000
In-Reply-To: <20260921164748.2958578-1-snehalreddy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260921164748.2958578-1-snehalreddy@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921164748.2958578-3-snehalreddy@google.com>
Subject: [PATCH 2/2] KVM: arm64: Support FFA_FN64_MEM_RECLAIM2 in host handler
From: Snehal Koukuntla <snehalreddy@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sudeep Holla <sudeep.holla@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Snehal Koukuntla <snehalreddy@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

FF-A v1.3 ALP5 (DEN0140 rev J) adds the FFA_MEM_RECLAIM2 interface,
allowing an Owner to reclaim a subset of pages from a shared or lent
memory region by populating constituent memory region descriptors in
its TX buffer along with a starting descriptor byte offset and initial
page index. Upon completion, the Relayer returns the number of 4K pages
reclaimed in x3.

Support FFA_FN64_MEM_RECLAIM2 in the host FF-A proxy handler. Validate
the register arguments, descriptor bounds, and initial page index
against the host TX buffer before forwarding the SMC call to the SPMD,
and unshare the reclaimed page ranges in the host stage-2 page tables.

Link: https://support.arm.com/documentation/den0140/j
Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 117 ++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 5ad74ab265b5..e0fba07a67bc 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -232,6 +232,19 @@ static void ffa_mem_reclaim(struct arm_smccc_1_2_regs *res, u32 handle_lo,
 	}, res);
 }
 
+static void ffa_mem_reclaim2(struct arm_smccc_1_2_regs *res, u64 handle,
+			     u64 flags, u64 x3, u64 x4, u64 x5)
+{
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+		.a0 = FFA_FN64_MEM_RECLAIM2,
+		.a1 = handle,
+		.a2 = flags,
+		.a3 = x3,
+		.a4 = x4,
+		.a5 = x5,
+	}, res);
+}
+
 static void ffa_retrieve_req(struct arm_smccc_1_2_regs *res, u32 len)
 {
 	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
@@ -611,6 +624,107 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 		__do_ffa_mem_xfer((fid), (res), (ctxt));	\
 	} while (0);
 
+static void do_ffa_mem_reclaim2(struct arm_smccc_1_2_regs *res,
+				struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u64, handle, ctxt, 1);
+	DECLARE_REG(u64, flags, ctxt, 2);
+	DECLARE_REG(u64, x3, ctxt, 3);
+	DECLARE_REG(u64, x4, ctxt, 4);
+	DECLARE_REG(u64, x5, ctxt, 5);
+	u32 req_desc_cnt = (u32)(x3 >> 32);
+	u32 total_pages = (u32)x3;
+	u32 desc_size = (u32)x4;
+	u32 offset = (u32)x5;
+	u32 page_index = (u32)(x5 >> 32);
+	struct ffa_mem_region_addr_range *range;
+	u32 reclaimed_pages;
+	u32 reclaimed_count = 0;
+	u32 in_idx;
+	int ret = 0;
+
+	if (ffa_check_unused_args_sbz(ctxt, 6) || (flags & ~1ULL) || (x4 >> 32)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (!req_desc_cnt || !total_pages) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (desc_size != sizeof(struct ffa_mem_region_addr_range)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if ((u64)req_desc_cnt * desc_size > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (offset % desc_size != 0) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	if (offset >= (u64)req_desc_cnt * desc_size) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
+
+	hyp_spin_lock(&host_buffers.lock);
+	if (!host_buffers.tx) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	memcpy(hyp_buffers.tx, host_buffers.tx, (u64)req_desc_cnt * desc_size);
+
+	range = (void *)hyp_buffers.tx + offset;
+	if (page_index >= range->pg_cnt) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	ffa_mem_reclaim2(res, handle, flags, x3, x4, x5);
+	if (res->a0 != FFA_SUCCESS)
+		goto out_unlock;
+
+	reclaimed_pages = res->a3;
+
+	for (in_idx = offset / desc_size; in_idx < req_desc_cnt; in_idx++) {
+		struct ffa_mem_region_addr_range temp;
+		u32 pg_cnt, to_reclaim;
+
+		if (reclaimed_count >= reclaimed_pages)
+			break;
+
+		range = (void *)hyp_buffers.tx + in_idx * desc_size;
+		if (!range->pg_cnt)
+			continue;
+
+		pg_cnt = range->pg_cnt - page_index;
+		to_reclaim = min(pg_cnt, reclaimed_pages - reclaimed_count);
+
+		temp = (struct ffa_mem_region_addr_range) {
+			.address = range->address + (u64)page_index * FFA_PAGE_SIZE,
+			.pg_cnt = to_reclaim,
+		};
+
+		WARN_ON(ffa_host_unshare_ranges(&temp, 1));
+
+		reclaimed_count += to_reclaim;
+		page_index = 0;
+	}
+
+out_unlock:
+	hyp_spin_unlock(&host_buffers.lock);
+
+	if (ret)
+		ffa_to_smccc_res(res, ret);
+}
+
 static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 			       struct kvm_cpu_context *ctxt)
 {
@@ -1107,6 +1221,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_MEM_RECLAIM:
 		do_ffa_mem_reclaim(&res, host_ctxt);
 		goto out_handled;
+	case FFA_FN64_MEM_RECLAIM2:
+		do_ffa_mem_reclaim2(&res, host_ctxt);
+		goto out_handled;
 	case FFA_MEM_LEND:
 	case FFA_FN64_MEM_LEND:
 		do_ffa_mem_xfer(FFA_FN64_MEM_LEND, &res, host_ctxt);
-- 
2.55.0.1082.g2b9226bbc0-goog

