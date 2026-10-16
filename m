Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8463C8C52
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 08:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139028; cv=none; b=P1TZHUVZAASFaJzVzK2yusJB/ZJl6ZH7fU2CLQbuC6vKBktOQCnQH/0pCaVm2zAWn+RHOmMlex1oFnVcuqkQRqFVe6TSeS5nhqRp6ZAILDV8NLIo8ktg55i5GDalqM5Bhe13gwU7xAYE2ckb43Av9vkzEUxbWLjInM+tD3f3sKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139028; c=relaxed/simple;
	bh=uvUwqGgeRQ8VAPaE5bhqTGEnhLxgi5yq+6U7653uUsc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WLEmhYyMaGaILZrqEUAypSkgPbWGklCLWSIbP+YhmynX0yq1b7I/Bp/kJ0CS7yylCE3/5e75AGhi0Id+dHIpcoC+jT44Av9etAvYJwOkrG9zdy50/TdhMSE2LoA7T0nS6go98ayhCJt4vyPANBH6NKwOzzvQC5GxyIL8fmynR84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vaiKG3eG; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vaiKG3eG"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a027f2e364so42382745e9.3
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 01:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792139025; x=1792743825; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ut85BCycGaEFxyxv7Y5H7I8rAvWGWrQ70tJ77lun2L8=;
        b=vaiKG3eGlns92V6BI6O/P+AFiKq56QfGZ8mLkOQQ2jn1dS1PPuFBxH1cIzyP/xlHti
         7o1WvCfBqMN6Q4dIrrZ9Eh7/zL5JxNEiT2E8L2tRYAxpbyJDp9+txeVq3PDZGYyTZusu
         HQzOWqCydFTNyv+AYzNOKjCouuwMopNCqjxewzf0A/lAiORMIDhj+LIcdjtDS+flVFHr
         OJaA47WluTuizY3QxYk9YE9RBHLDwPM6SmTNwYYqr5bnJJb0N72u0ioaquO33StV6UC4
         DGOyKrHm0VGTMwo4YOXcX+VXLCtckio141g3EZQIVlI9XLevMeyXXZbk6e9+7iB1XCqx
         1fIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792139025; x=1792743825;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ut85BCycGaEFxyxv7Y5H7I8rAvWGWrQ70tJ77lun2L8=;
        b=hIUERIY3Ae3dZMF4g/yR4M4C0qU6NjCFziBGtTjKNdHQwNxvFilLgnl3dj1xi0JvF2
         sSDKWFFOgsTHtyiqACJVL4g5fyWKyJg6iNd3lizQncl4yPN8RReO3pQCgDIxTJcw7Yd/
         iIYkKaNtfG3jvNC7o+R0IuUr8y3uPs1pb6hCUuEE5h+zRDHY2P5a3+jdloqBVpTh3NxS
         qLmdQhmmic88A3AAct2cMy+8jqNMOSzQVUJQ8ga1S9NHE3gj39o6lzeMy547YTVLrnpM
         4pB1kO0gBFDknBPE3CF5tg6hp0DHN4u14cbZqhipE0JYmChAhmLe8dQHdUeQ4nyP6GA0
         KGXA==
X-Forwarded-Encrypted: i=1; AKwUvBxjGgA+oMnEW7YUjy9IFNciBnxJdsqcHyA6Qg4MFfSizw+JXYyplB0zQv8AUlGsSiKkwd3oJUY=@lists.linux.dev
X-Gm-Message-State: AFq9FYJTcea14mLhdUnjSbkqh4VUKQZh6ca+MSEtG0uuihAIOkFF6SmT
	4aog0yGl7O5zW0IWKlZEBC7tOP0qo+3IuYM+3iyTGbTO+y7XrbifPvxRDymFGXsnnjblGASr9NH
	uGO+ezG81PD8dXPJvr2/woqHpEg==
X-Received: from wmqy19.prod.google.com ([2002:a05:600c:3653:b0:4a1:7af8:4771])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6215:b0:49c:fa20:cbfc with SMTP id 5b1f17b1804b1-4a18e4b72e4mr395445945e9.19.1792139024859;
 Fri, 16 Oct 2026 01:23:44 -0700 (PDT)
Date: Fri, 16 Oct 2026 08:23:41 +0000
In-Reply-To: <20261016082341.4030770-1-snehalreddy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261016082341.4030770-1-snehalreddy@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261016082341.4030770-3-snehalreddy@google.com>
Subject: [RFC PATCH v2 2/2] KVM: arm64: Support FFA_MEM_RECLAIM2 in host handler
From: Snehal Koukuntla <snehalreddy@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sudeep Holla <sudeep.holla@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
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

Support FFA_MEM_RECLAIM2 in the host FF-A proxy handler. Validate the
register arguments, copy the constituent descriptors from the host TX
buffer into the hypervisor's TX buffer, and check the descriptor bounds,
the total page count and the initial page index on that copy before
forwarding the call to the SPMD. On success, unshare the reclaimed page
ranges from the host stage-2 page tables.

Link: https://support.arm.com/documentation/den0140/j
Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
---
Changes in v2:
- Rename FFA_FN64_MEM_RECLAIM2 to FFA_MEM_RECLAIM2
- Check that the sum of pg_cnt across all constituent descriptors
  matches total_pages, guarding against overflow (Vincent)
- Simplify the flags and offset alignment checks (Vincent)

 arch/arm64/kvm/hyp/nvhe/ffa.c | 126 ++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 5ad74ab265b5..2f49ffaa9361 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -232,6 +232,19 @@ static void ffa_mem_reclaim(struct arm_smccc_1_2_regs *res, u32 handle_lo,
 	}, res);
 }
 
+static void ffa_mem_reclaim2(struct arm_smccc_1_2_regs *res, u64 handle,
+			     u64 flags, u64 x3, u64 x4, u64 x5)
+{
+	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
+		.a0 = FFA_MEM_RECLAIM2,
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
@@ -611,6 +624,116 @@ static void __do_ffa_mem_xfer(const u64 func_id,
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
+	u32 declared_pages = 0;
+	u32 reclaimed_pages;
+	u32 reclaimed_count = 0;
+	u32 in_idx;
+	int ret = 0;
+
+	if (ffa_check_unused_args_sbz(ctxt, 6) || flags > 1 || (x4 >> 32)) {
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
+	if (offset % desc_size) {
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
+	for (in_idx = 0; in_idx < req_desc_cnt; in_idx++) {
+		range = (void *)hyp_buffers.tx + in_idx * desc_size;
+		if (check_add_overflow(declared_pages, range->pg_cnt, &declared_pages)) {
+			ret = FFA_RET_INVALID_PARAMETERS;
+			goto out_unlock;
+		}
+	}
+
+	range = (void *)hyp_buffers.tx + offset;
+	if (declared_pages != total_pages || page_index >= range->pg_cnt) {
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
@@ -1107,6 +1230,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_MEM_RECLAIM:
 		do_ffa_mem_reclaim(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MEM_RECLAIM2:
+		do_ffa_mem_reclaim2(&res, host_ctxt);
+		goto out_handled;
 	case FFA_MEM_LEND:
 	case FFA_FN64_MEM_LEND:
 		do_ffa_mem_xfer(FFA_FN64_MEM_LEND, &res, host_ctxt);
-- 
2.56.0.176.g3575e65682-goog

