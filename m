Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793628891;
	b=jeIaleJXq3dZmY6YflE+z7lbwRXsioeJEF4QtGXJ7qhtI3ni/qVUy0PMY4xX4Y0TbOoe
	 UFzreGI5Ic+FlJQcFarUOsss4pifpzgn/6VDTLnzCqUBu2qV5J1XQufz+fjVc0w3NEso2
	 5/izQlEH7L/lfPBOFB8WvckmU1h4gHKMHM0ujpzrF/K/KmgWf3VSuvosDH7jiLBzLxHIh
	 aIp5g2yQkNe5BlbyWy3d5DjHlqvbcVadoT+hAgJk23pWEXwX4iYnbqikvXL5SQMcr8tSM
	 kb/CcmNU4bP0lxMXxNU2YZgIkFUOyRk3VNMU0rrsy/EK4BZYuTgoZn9JnINVh9PaDGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628891;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=aObHiAl14ISYnHTiq56WBT9/HZ+h1+3i8W9JjZxKwNA=;
	b=u5JEKilgod3wuRgECPJJIN/v+Iq4vehprUXJCBdMt5q3YzOjVOaEm5h2XDy5xjD0zFbA
	 oYTJpJuJBZzHQS3COscHODGR+ouxXmEhvXk2OgC5ihF+iKn20PexCk2QYf3AmlSxThEYT
	 p5UA0bMlmk353+E12sSc2Fqe9k+tTR++iDeulgXxk8FXp8vU6CZYbMiYzjQtl5CaF1NlK
	 eW1a89NSqwgWbmHUdL65+QWe3xqyV4iv0GQv/sFNly2lDoIb4fSGP53xsxpVdMsR9a0y/
	 6oY6OBEetzdlTbF9GIcXKJ2Ot965anr/h+v6aS2DOO+p/XqAoQVLufvAwC2+tPKzhLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=qO5yYbXu;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA1560A263A
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 14:14:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DA1560A263A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=qO5yYbXu
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4ad3d35e899so15446615e9.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 06:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793628888; x=1794233688; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aObHiAl14ISYnHTiq56WBT9/HZ+h1+3i8W9JjZxKwNA=;
        b=qO5yYbXu1nWGFJMfrLcwD0bRE6VMMDXUPUYRKFuADo4eV2G90jEG2aFWdFGJy1++7v
         DOba4kadsQPtiJ0T/5JKzb732r8obly/xRx5n+iUtC/TowgoPMLEmuiaye8BbBthQM4I
         fy97BSBhDP896u45U82mXoG2OuDdWLouGmkFRMquJjE1mYJb0yp0QaI0WS5JLP9SSOfd
         BE5E/leCk5/O9zF5kA315Ls9/F1UUHk6umBkuDWz6sbCbVW3TrPKQ+7rmS39MNJkY22G
         9N1mVb/uG3BuAGROekn3XN+VTlkKuyJhAK3xOjOw6iLxK7dFK/hpauQO0nmPbARE15tu
         gyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793628888; x=1794233688;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aObHiAl14ISYnHTiq56WBT9/HZ+h1+3i8W9JjZxKwNA=;
        b=MQQn/swQaASNfKbQ8yj7P2vouvUkshtQjAxlq/YtP6LbZFkfkqPSBiJRfZherteWxF
         s8QVoFalwJRGaobA8Xan/z8HHr1wAqE/h2efd7lCE44XtU6uXwOvZxQPey3wGNx/ycdj
         0Kh2i4+xNY6t/uNKxVyZ33d5PazH4Qf/kFxHVScovDw1Y3TNJuZy0W59tY93s39sAVym
         w5Bvux5FI1oQPCdkfV3LUGjjr7mc8GsGiAmWRtfS8VH2WzGMV8WXmBYs8WnJ8YKuhube
         x8X/26cxirnZIQglg8Gv00SHw7cA1IgZtiWduE3mbgHrDW9cXWjNXGsJH0/r0TZtQssi
         T6rQ==
X-Forwarded-Encrypted: i=1; AKwUvByD81vkphHOuYIf56YihozgTgeseuK8Tr7V6ksbIa2BHkJ/vkyHGj29l+5B3Glbp6X6K+eVi/I=@lists.linux.dev
X-Gm-Message-State: AFq9FYKnCSAtTNdURS0n5P5NaaFmwcfMr6fC4uEOwYpMTr6tuIWvUk+J
	Yi75u0Oux2TbAErmhc9l6lhd+qlflyVkhjYJDcePEgla7Q4ETTdmpRRKHSLb4vTU5ZEPHMxpBKm
	qTrLoxZLxAGO4V+pJZSLcPFmJcg==
X-Received: from wrbbn9.prod.google.com ([2002:a05:6000:609:b0:488:62a3:a2ef])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19c8:b0:4a3:59c9:a743 with SMTP id 5b1f17b1804b1-4ac1913ef8fmr237585955e9.27.1793628888027;
 Mon, 02 Nov 2026 06:14:48 -0800 (PST)
Date: Mon,  2 Nov 2026 14:14:44 +0000
In-Reply-To: <20261102141444.1830221-1-snehalreddy@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102141444.1830221-1-snehalreddy@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102141444.1830221-3-snehalreddy@google.com>
Subject: [PATCH v3 2/2] KVM: arm64: Support FFA_MEM_RECLAIM2 in host handler
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

FF-A v1.3 BET0 (DEN0140 rev K) adds the FFA_MEM_RECLAIM2 interface,
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

On a Pixel board (pKVM, 16K pages, EL3 SPMC), reclaiming a single 16K
range drops from 1.3us to 0.7us (~45% faster) by avoiding
FFA_MEM_RETRIEVE_REQ/RX_RELEASE (~0.6us), and single-call
FFA_MEM_RECLAIM2 stays faster across small range counts (1.3us vs 1.9us
at 16 ranges; 2 calls break even). Up to 64MiB (4096 ranges), batching
256 descriptors/call adds 15 preemption points, capping each EL2/EL3
call at ~11us while keeping total SMC time within 5%.

Link: https://support.arm.com/documentation/den0140/k
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
---
Changes in v3:
- Drop RFC tag and update specification reference to FF-A v1.3 BET0
  (DEN0140 rev K)
- Add benchmark numbers to commit description
- Add Vincent's Reviewed-by tag (no code changes)

Changes in v2:
- Rename FFA_FN64_MEM_RECLAIM2 to FFA_MEM_RECLAIM2 (sashiko)
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
2.56.0.317.g454f8302e1-goog

