Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3758279336
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682534; cv=none; b=CTJMzVomWpC1rU/xMrJ2KpKu/r5nUTYJXvUGVnR9EnIhy4BSTkGiNKqa+kkywOLgB8OEL6eqJP2YxAXxG9a17hlch9DiUaphjG/0/loNPxcKgSOpYX9/85ECIIYzh6EdrrpZlKFX0qVYR+GqH4KViUMVi9TuYnBqLNPS9hsGioM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682534; c=relaxed/simple;
	bh=C4HiGUQNxtmsv7hJo1lWD9b+fUYFAtTKIh3xr/U3w90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pMZJ17x4KUkcEgciUWSS60VTWaqBczecVMwVlYnZ9dyDxRLdkKAb5siEQ47p2R3dIFjB3bZzrACHlZJsQeeOHG3dki7UmwCVFOAnYcatkC+/rc8nBFUpHSLCO3LagCzhyIsPqvp08yI50s/BEL8Hk1ommB3bDxdeRSb44yjIHI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UQP/GfjZ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UQP/GfjZ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485355493aeso36861395e9.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682531; x=1774287331; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FvueIHWrftpZGm9WwSLw4m+mhIgN4K5gi1wLojgWmOA=;
        b=UQP/GfjZI06EWTLdKzXKa2Il70xG/hedw4onEqa6HHtTwkG2hhaBt0me7cs1tXbQu0
         9ojSjQ0GVQ6es6iFuVzIZtJMIfRMZ9GBukMVbA/ua3r23XmmyDvazZGGiSaqZ/JWGc7U
         iDPQW6Tn/dd4C9vMQuH5YQmzjXw31QGv3EGLILSmjobufLCwpyKZqTPEX+/TW+uI7G2Y
         TJ3XVIUKxELTg1uBnM3jcqcAQG8VCKRmlWjkYMED8avRCVKR88FmOUMKHpJt9RAVS3hA
         otOBQKS8IrLn65SEYqi+tmmcBz7uy84TrA8GAnyRDq8UPNjrvowSdDoVDP6gMa0qSrn5
         AWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682531; x=1774287331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FvueIHWrftpZGm9WwSLw4m+mhIgN4K5gi1wLojgWmOA=;
        b=hNkS+IIhGyo4E+pxOSL6eCanNO2QAOeDkaIwuCxz48g9y1JTgU1EI0LmuJqwCuAypN
         MTiugZC2ZoeRSWhAspOM9sNCKywPqzHw2a7QfE5PbnEswcOFfNR9rTFEA3iL4JgHxvce
         78Kz5Cl3n0nWpf4iTay21/PeXO+KDo85tRlN1yqD1IUC+Xiy7bCsX9I7wTIKefz2LzhI
         O1p2aVXghdghn5OeaWIaM2pgceM/TLI1pSSaB6iFGcIpsI/18CHLBUWQE8NADn0uP+Ej
         xbIUPmzecsZXlXRN0OH5jLTHLF81O6eT/Czq7yT1luHH20WZfQ4sLaWp1xy2RJh+65p2
         /YrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrFU1duShqE7ZR2m4yvmybkP3y4gNYdfPc1/z5wuEs4xO2KTa9Ot8el7h9rGeWmgDDDnUkacY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz231FVF+wKcjNX07GSesr16UCW5yeJ3CP+2yPTPAVsjzxAHIFR
	5DD67A89ekMDWvQGKS6SiqUk2abomDJfqeyFKN3/ri+W9hzEBDhgZQNFTrTk62zi2ojdYd9s+QH
	Fyg==
X-Received: from wmim11.prod.google.com ([2002:a7b:cb8b:0:b0:483:5126:2240])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a4a:b0:477:76bf:e1fb
 with SMTP id 5b1f17b1804b1-485566f7bd0mr229045355e9.16.1773682531263; Mon, 16
 Mar 2026 10:35:31 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:24 +0000
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-3-456875a2c6db@google.com>
Subject: [PATCH 03/10] KVM: arm64: Use guard(hyp_spinlock) in ffa.c
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"

Migrate manual hyp_spin_lock() and hyp_spin_unlock() calls managing
host_buffers.lock and version_lock to use the guard(hyp_spinlock)
macro.

This eliminates manual unlock calls on return paths and simplifies
error handling by replacing goto labels with direct returns.

Change-Id: I52e31c0bed3d2772c800a535af8abdabd81a178b
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 86 +++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 94161ea1cd60..0c772501c3ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -239,6 +239,8 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
 	int ret = 0;
 	void *rx_virt, *tx_virt;
 
+	guard(hyp_spinlock)(&host_buffers.lock);
+
 	if (npages != (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) / FFA_PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto out;
@@ -249,10 +251,9 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
 		goto out;
 	}
 
-	hyp_spin_lock(&host_buffers.lock);
 	if (host_buffers.tx) {
 		ret = FFA_RET_DENIED;
-		goto out_unlock;
+		goto out;
 	}
 
 	/*
@@ -261,7 +262,7 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
 	 */
 	ret = ffa_map_hyp_buffers(npages);
 	if (ret)
-		goto out_unlock;
+		goto out;
 
 	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(tx));
 	if (ret) {
@@ -292,8 +293,6 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
 	host_buffers.tx = tx_virt;
 	host_buffers.rx = rx_virt;
 
-out_unlock:
-	hyp_spin_unlock(&host_buffers.lock);
 out:
 	ffa_to_smccc_res(res, ret);
 	return;
@@ -306,7 +305,7 @@ static void do_ffa_rxtx_map(struct arm_smccc_1_2_regs *res,
 	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(tx));
 err_unmap:
 	ffa_unmap_hyp_buffers();
-	goto out_unlock;
+	goto out;
 }
 
 static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
@@ -315,15 +314,16 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, id, ctxt, 1);
 	int ret = 0;
 
+	guard(hyp_spinlock)(&host_buffers.lock);
+
 	if (id != HOST_FFA_ID) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto out;
 	}
 
-	hyp_spin_lock(&host_buffers.lock);
 	if (!host_buffers.tx) {
 		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		goto out;
 	}
 
 	hyp_unpin_shared_mem(host_buffers.tx, host_buffers.tx + 1);
@@ -336,8 +336,6 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
 
 	ffa_unmap_hyp_buffers();
 
-out_unlock:
-	hyp_spin_unlock(&host_buffers.lock);
 out:
 	ffa_to_smccc_res(res, ret);
 }
@@ -421,15 +419,16 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
 	int ret = FFA_RET_INVALID_PARAMETERS;
 	u32 nr_ranges;
 
+	guard(hyp_spinlock)(&host_buffers.lock);
+
 	if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)
 		goto out;
 
 	if (fraglen % sizeof(*buf))
 		goto out;
 
-	hyp_spin_lock(&host_buffers.lock);
 	if (!host_buffers.tx)
-		goto out_unlock;
+		goto out;
 
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
@@ -444,15 +443,13 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
 		 */
 		ffa_mem_reclaim(res, handle_lo, handle_hi, 0);
 		WARN_ON(res->a0 != FFA_SUCCESS);
-		goto out_unlock;
+		goto out;
 	}
 
 	ffa_mem_frag_tx(res, handle_lo, handle_hi, fraglen, endpoint_id);
 	if (res->a0 != FFA_SUCCESS && res->a0 != FFA_MEM_FRAG_RX)
 		WARN_ON(ffa_host_unshare_ranges(buf, nr_ranges));
 
-out_unlock:
-	hyp_spin_unlock(&host_buffers.lock);
 out:
 	if (ret)
 		ffa_to_smccc_res(res, ret);
@@ -482,6 +479,8 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	u32 offset, nr_ranges, checked_offset;
 	int ret = 0;
 
+	guard(hyp_spinlock)(&host_buffers.lock);
+
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -494,15 +493,14 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 		goto out;
 	}
 
-	hyp_spin_lock(&host_buffers.lock);
 	if (!host_buffers.tx) {
 		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		goto out;
 	}
 
 	if (len > ffa_desc_buf.len) {
 		ret = FFA_RET_NO_MEMORY;
-		goto out_unlock;
+		goto out;
 	}
 
 	buf = hyp_buffers.tx;
@@ -513,30 +511,30 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	offset = ep_mem_access->composite_off;
 	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
 		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		goto out;
 	}
 
 	if (check_add_overflow(offset, sizeof(struct ffa_composite_mem_region), &checked_offset)) {
 		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		goto out;
 	}
 
 	if (fraglen < checked_offset) {
 		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		goto out;
 	}
 
 	reg = (void *)buf + offset;
 	nr_ranges = ((void *)buf + fraglen) - (void *)reg->constituents;
 	if (nr_ranges % sizeof(reg->constituents[0])) {
 		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		goto out;
 	}
 
 	nr_ranges /= sizeof(reg->constituents[0]);
 	ret = ffa_host_share_ranges(reg->constituents, nr_ranges);
 	if (ret)
-		goto out_unlock;
+		goto out;
 
 	ffa_mem_xfer(res, func_id, len, fraglen);
 	if (fraglen != len) {
@@ -549,8 +547,6 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 		goto err_unshare;
 	}
 
-out_unlock:
-	hyp_spin_unlock(&host_buffers.lock);
 out:
 	if (ret)
 		ffa_to_smccc_res(res, ret);
@@ -558,7 +554,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 
 err_unshare:
 	WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
-	goto out_unlock;
+	goto out;
 }
 
 #define do_ffa_mem_xfer(fid, res, ctxt)				\
@@ -583,7 +579,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 
 	handle = PACK_HANDLE(handle_lo, handle_hi);
 
-	hyp_spin_lock(&host_buffers.lock);
+	guard(hyp_spinlock)(&host_buffers.lock);
 
 	buf = hyp_buffers.tx;
 	*buf = (struct ffa_mem_region) {
@@ -594,7 +590,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	ffa_retrieve_req(res, sizeof(*buf));
 	buf = hyp_buffers.rx;
 	if (res->a0 != FFA_MEM_RETRIEVE_RESP)
-		goto out_unlock;
+		goto out;
 
 	len = res->a1;
 	fraglen = res->a2;
@@ -611,13 +607,13 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
 		ret = FFA_RET_ABORTED;
 		ffa_rx_release(res);
-		goto out_unlock;
+		goto out;
 	}
 
 	if (len > ffa_desc_buf.len) {
 		ret = FFA_RET_NO_MEMORY;
 		ffa_rx_release(res);
-		goto out_unlock;
+		goto out;
 	}
 
 	buf = ffa_desc_buf.buf;
@@ -628,7 +624,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 		ffa_mem_frag_rx(res, handle_lo, handle_hi, fragoff);
 		if (res->a0 != FFA_MEM_FRAG_TX) {
 			ret = FFA_RET_INVALID_PARAMETERS;
-			goto out_unlock;
+			goto out;
 		}
 
 		fraglen = res->a3;
@@ -638,15 +634,13 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 
 	ffa_mem_reclaim(res, handle_lo, handle_hi, flags);
 	if (res->a0 != FFA_SUCCESS)
-		goto out_unlock;
+		goto out;
 
 	reg = (void *)buf + offset;
 	/* If the SPMD was happy, then we should be too. */
 	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
 					reg->addr_range_cnt));
-out_unlock:
-	hyp_spin_unlock(&host_buffers.lock);
-
+out:
 	if (ret)
 		ffa_to_smccc_res(res, ret);
 }
@@ -774,13 +768,13 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
 		return;
 	}
 
-	hyp_spin_lock(&version_lock);
+	guard(hyp_spinlock)(&version_lock);
 	if (has_version_negotiated) {
 		if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(hyp_ffa_version))
 			res->a0 = FFA_RET_NOT_SUPPORTED;
 		else
 			res->a0 = hyp_ffa_version;
-		goto unlock;
+		return;
 	}
 
 	/*
@@ -793,7 +787,7 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
 			.a1 = ffa_req_version,
 		}, res);
 		if ((s32)res->a0 == FFA_RET_NOT_SUPPORTED)
-			goto unlock;
+			return;
 
 		hyp_ffa_version = ffa_req_version;
 	}
@@ -804,8 +798,6 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
 		smp_store_release(&has_version_negotiated, true);
 		res->a0 = hyp_ffa_version;
 	}
-unlock:
-	hyp_spin_unlock(&version_lock);
 }
 
 static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
@@ -818,10 +810,10 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, flags, ctxt, 5);
 	u32 count, partition_sz, copy_sz;
 
-	hyp_spin_lock(&host_buffers.lock);
+	guard(hyp_spinlock)(&host_buffers.lock);
 	if (!host_buffers.rx) {
 		ffa_to_smccc_res(res, FFA_RET_BUSY);
-		goto out_unlock;
+		return;
 	}
 
 	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
@@ -834,16 +826,16 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	}, res);
 
 	if (res->a0 != FFA_SUCCESS)
-		goto out_unlock;
+		return;
 
 	count = res->a2;
 	if (!count)
-		goto out_unlock;
+		return;
 
 	if (hyp_ffa_version > FFA_VERSION_1_0) {
 		/* Get the number of partitions deployed in the system */
 		if (flags & 0x1)
-			goto out_unlock;
+			return;
 
 		partition_sz  = res->a3;
 	} else {
@@ -854,12 +846,10 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	copy_sz = partition_sz * count;
 	if (copy_sz > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ffa_to_smccc_res(res, FFA_RET_ABORTED);
-		goto out_unlock;
+		return;
 	}
 
 	memcpy(host_buffers.rx, hyp_buffers.rx, copy_sz);
-out_unlock:
-	hyp_spin_unlock(&host_buffers.lock);
 }
 
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)

-- 
2.53.0.851.ga537e3e6e9-goog

