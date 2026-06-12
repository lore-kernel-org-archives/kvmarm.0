Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0EE3D647E
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247573; cv=none; b=kke4VT+LOAikpRyuUwMEBU5EQaJE6iCulnMl2OjFJFAwsz85uU07PcFUWmgqPU8AxgPeWR060BaYwooXzpHHe693h5D9apcEzHvn3Yqa1yxtdFbfqNFbk/vTwcxCPjVAj5K02oqzuL5QUvce1Y9+arumRkdBd5zs/rdQemqBSdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247573; c=relaxed/simple;
	bh=tMEF1HrgoUwbF1xYwZZut3txJCutVhkrKKXDcdwZTo8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rYEcEnUmVC5Q5AnT7SgGV4FilEPl6Tj95oEvwJFQFZULU4rMVF5INlLWKDAf/B5aYsSE+cG6UE4bLtvPRMx0ai8ltg7VQdgWq8cOPXeZE3tyCRJ2Ab29icbX0ig1MnUK3aPeADpckF1MTg3dZBdoysMWOTgXRHWTLA6LX/yTXfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jjPW+4RG; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jjPW+4RG"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-68fa01a88f8so504445a12.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247569; x=1781852369; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kk0/+2CjcY2+fUUwbJIId7ZPArsTXXXhFqe+Sv45Y7A=;
        b=jjPW+4RGt+3eocYnqrFSzsrrihuQU85umgo+IQuGE03ydPWPTmnUEVeY8rkQnEQjs6
         tUs1nuYvvR96F8TIIcLNvxK4rlyYKMB4sHKlvVJfaMe6FUITBZCJmERFFUyCqYGvSxQM
         Nuc27syeDtYzpuxftJ+UN+9R7kRE7WJ4vpi0TvLrBYCYu4DfUx//jvsAjoGsDNN9+gj6
         EfpxnpKfnW5D4IMQoO148c7WD8GunL6DQ67O+/N3vqGx+HQ57Ma82S/moEdxZIHa5ms2
         gJ9vb6A2WFlYeNbbHSkm1Ig2q0M0apavXcZJANuExUVG/zlis0xXcusQhcFKOtzH/VXl
         o9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247569; x=1781852369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kk0/+2CjcY2+fUUwbJIId7ZPArsTXXXhFqe+Sv45Y7A=;
        b=IAHo9svH3Yiv53iZeo53PkGAwGTbV0+PoIgK/2skYnhhrxs/gZ3PewWImUNgps+Zxc
         47WFOeDWWpcJOhA7kTf3vABBXVxwZ5TRRypHCzIkXQbE4Kw81uLFRupxNGDnks2bZxnA
         a9Lamj0+nC6nxnuxIYgLAWk1zuB4OuCth7by2pfwFIHWky6BbKK6QRUgQt6gcte+aR1m
         Mpcavyzy1KhyXDZYs7mSuorTPJFunaJhiHUTtG0nto2NYHfH5GK6rmg1UK1V6z/NUAs/
         6ZibNBjWUot7pTaTpzthZQyKCMT41bc6UPwse/HVP6lN/WTziNEli3qgBkia77AuxMFF
         znhA==
X-Forwarded-Encrypted: i=1; AFNElJ9BncKjdqXKayYyOeQYlhkDFxwzS+0cKJoY/hKu0iFSpsNP1QvYlYP2mSoCJEyRZGpwStIldFI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqjQvIDF+ORnAUyGH+wiVTXuUFaDMPI8Ujouexg2lVB87EVpzH
	aTA4qrjvRWZoPYebZ6IgeUhsczd9hPfNc3sjQeViMHZpaHiu+nEmT9mYuo8faceW/5fZOj8S0A2
	YFA==
X-Received: from edpg14.prod.google.com ([2002:aa7:d1ce:0:b0:67d:1c0:a45b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:ea9:b0:674:1fe8:407b
 with SMTP id 4fb4d7f45d1cf-693788f842amr526512a12.9.1781247568420; Thu, 11
 Jun 2026 23:59:28 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:16 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-3-tabba@google.com>
Subject: [PATCH v1 02/11] KVM: arm64: Use guard(hyp_spinlock) in pKVM
 hypervisor code
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Convert the manual hyp_spin_lock()/hyp_spin_unlock() pairs in
arch/arm64/kvm/hyp/nvhe/{pkvm,mm,page_alloc,ffa}.c to
guard(hyp_spinlock) and scoped_guard(hyp_spinlock), dropping several
unlock-only goto labels in favour of direct returns.

hyp_fixblock_lock in mm.c is left as an explicit lock/unlock pair: it is
acquired in hyp_fixblock_map() and released in hyp_fixblock_unmap(), so
its critical section spans two functions and cannot be expressed as a
single lexical scope.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c        | 154 +++++++++++----------------
 arch/arm64/kvm/hyp/nvhe/mm.c         |  37 ++-----
 arch/arm64/kvm/hyp/nvhe/page_alloc.c |  13 +--
 arch/arm64/kvm/hyp/nvhe/pkvm.c       |  86 +++++----------
 4 files changed, 105 insertions(+), 185 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..46cd4fa924be 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -313,17 +313,16 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
 			      struct kvm_cpu_context *ctxt)
 {
 	DECLARE_REG(u32, id, ctxt, 1);
-	int ret = 0;
 
 	if (id != HOST_FFA_ID) {
-		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out;
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
 	}
 
-	hyp_spin_lock(&host_buffers.lock);
+	guard(hyp_spinlock)(&host_buffers.lock);
 	if (!host_buffers.tx) {
-		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
 	}
 
 	hyp_unpin_shared_mem(host_buffers.tx, host_buffers.tx + 1);
@@ -336,10 +335,7 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
 
 	ffa_unmap_hyp_buffers();
 
-out_unlock:
-	hyp_spin_unlock(&host_buffers.lock);
-out:
-	ffa_to_smccc_res(res, ret);
+	ffa_to_smccc_res(res, 0);
 }
 
 static u32 __ffa_host_share_ranges(struct ffa_mem_region_addr_range *ranges,
@@ -418,18 +414,20 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, fraglen, ctxt, 3);
 	DECLARE_REG(u32, endpoint_id, ctxt, 4);
 	struct ffa_mem_region_addr_range *buf;
-	int ret = FFA_RET_INVALID_PARAMETERS;
+	int ret;
 	u32 nr_ranges;
 
-	if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)
-		goto out;
+	if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE ||
+	    fraglen % sizeof(*buf)) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
 
-	if (fraglen % sizeof(*buf))
-		goto out;
-
-	hyp_spin_lock(&host_buffers.lock);
-	if (!host_buffers.tx)
-		goto out_unlock;
+	guard(hyp_spinlock)(&host_buffers.lock);
+	if (!host_buffers.tx) {
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
+	}
 
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
@@ -444,19 +442,14 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
 		 */
 		ffa_mem_reclaim(res, handle_lo, handle_hi, 0);
 		WARN_ON(res->a0 != FFA_SUCCESS);
-		goto out_unlock;
+		ffa_to_smccc_res(res, ret);
+		return;
 	}
 
 	ffa_mem_frag_tx(res, handle_lo, handle_hi, fraglen, endpoint_id);
 	if (res->a0 != FFA_SUCCESS && res->a0 != FFA_MEM_FRAG_RX)
 		WARN_ON(ffa_host_unshare_ranges(buf, nr_ranges));
 
-out_unlock:
-	hyp_spin_unlock(&host_buffers.lock);
-out:
-	if (ret)
-		ffa_to_smccc_res(res, ret);
-
 	/*
 	 * If for any reason this did not succeed, we're in trouble as we have
 	 * now lost the content of the previous fragments and we can't rollback
@@ -465,7 +458,6 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
 	 * sharing/donating them again and may possibly lead to subsequent
 	 * failures, but this will not compromise confidentiality.
 	 */
-	return;
 }
 
 static void __do_ffa_mem_xfer(const u64 func_id,
@@ -480,29 +472,29 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
 	u32 offset, nr_ranges, checked_offset;
-	int ret = 0;
+	int ret;
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
-		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out;
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
 	}
 
 	if (fraglen < sizeof(struct ffa_mem_region) +
 		      sizeof(struct ffa_mem_region_attributes)) {
-		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out;
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
 	}
 
-	hyp_spin_lock(&host_buffers.lock);
+	guard(hyp_spinlock)(&host_buffers.lock);
 	if (!host_buffers.tx) {
-		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
 	}
 
 	if (len > ffa_desc_buf.len) {
-		ret = FFA_RET_NO_MEMORY;
-		goto out_unlock;
+		ffa_to_smccc_res(res, FFA_RET_NO_MEMORY);
+		return;
 	}
 
 	buf = hyp_buffers.tx;
@@ -512,53 +504,41 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
 	offset = ep_mem_access->composite_off;
 	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
-		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
 	}
 
 	if (check_add_overflow(offset, sizeof(struct ffa_composite_mem_region), &checked_offset)) {
-		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
 	}
 
 	if (fraglen < checked_offset) {
-		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
 	}
 
 	reg = (void *)buf + offset;
 	nr_ranges = ((void *)buf + fraglen) - (void *)reg->constituents;
 	if (nr_ranges % sizeof(reg->constituents[0])) {
-		ret = FFA_RET_INVALID_PARAMETERS;
-		goto out_unlock;
+		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+		return;
 	}
 
 	nr_ranges /= sizeof(reg->constituents[0]);
 	ret = ffa_host_share_ranges(reg->constituents, nr_ranges);
-	if (ret)
-		goto out_unlock;
+	if (ret) {
+		ffa_to_smccc_res(res, ret);
+		return;
+	}
 
 	ffa_mem_xfer(res, func_id, len, fraglen);
 	if (fraglen != len) {
-		if (res->a0 != FFA_MEM_FRAG_RX)
-			goto err_unshare;
-
-		if (res->a3 != fraglen)
-			goto err_unshare;
+		if (res->a0 != FFA_MEM_FRAG_RX || res->a3 != fraglen)
+			WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
 	} else if (res->a0 != FFA_SUCCESS) {
-		goto err_unshare;
+		WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
 	}
-
-out_unlock:
-	hyp_spin_unlock(&host_buffers.lock);
-out:
-	if (ret)
-		ffa_to_smccc_res(res, ret);
-	return;
-
-err_unshare:
-	WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
-	goto out_unlock;
 }
 
 #define do_ffa_mem_xfer(fid, res, ctxt)				\
@@ -578,12 +558,11 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	struct ffa_composite_mem_region *reg;
 	u32 offset, len, fraglen, fragoff;
 	struct ffa_mem_region *buf;
-	int ret = 0;
 	u64 handle;
 
 	handle = PACK_HANDLE(handle_lo, handle_hi);
 
-	hyp_spin_lock(&host_buffers.lock);
+	guard(hyp_spinlock)(&host_buffers.lock);
 
 	buf = hyp_buffers.tx;
 	*buf = (struct ffa_mem_region) {
@@ -594,7 +573,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	ffa_retrieve_req(res, sizeof(*buf));
 	buf = hyp_buffers.rx;
 	if (res->a0 != FFA_MEM_RETRIEVE_RESP)
-		goto out_unlock;
+		return;
 
 	len = res->a1;
 	fraglen = res->a2;
@@ -609,15 +588,15 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	 */
 	if (WARN_ON(offset > len ||
 		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
-		ret = FFA_RET_ABORTED;
 		ffa_rx_release(res);
-		goto out_unlock;
+		ffa_to_smccc_res(res, FFA_RET_ABORTED);
+		return;
 	}
 
 	if (len > ffa_desc_buf.len) {
-		ret = FFA_RET_NO_MEMORY;
 		ffa_rx_release(res);
-		goto out_unlock;
+		ffa_to_smccc_res(res, FFA_RET_NO_MEMORY);
+		return;
 	}
 
 	buf = ffa_desc_buf.buf;
@@ -627,8 +606,8 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	for (fragoff = fraglen; fragoff < len; fragoff += fraglen) {
 		ffa_mem_frag_rx(res, handle_lo, handle_hi, fragoff);
 		if (res->a0 != FFA_MEM_FRAG_TX) {
-			ret = FFA_RET_INVALID_PARAMETERS;
-			goto out_unlock;
+			ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
+			return;
 		}
 
 		fraglen = res->a3;
@@ -638,17 +617,12 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 
 	ffa_mem_reclaim(res, handle_lo, handle_hi, flags);
 	if (res->a0 != FFA_SUCCESS)
-		goto out_unlock;
+		return;
 
 	reg = (void *)buf + offset;
 	/* If the SPMD was happy, then we should be too. */
 	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
 					reg->addr_range_cnt));
-out_unlock:
-	hyp_spin_unlock(&host_buffers.lock);
-
-	if (ret)
-		ffa_to_smccc_res(res, ret);
 }
 
 /*
@@ -774,13 +748,13 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
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
@@ -793,7 +767,7 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
 			.a1 = ffa_req_version,
 		}, res);
 		if ((s32)res->a0 == FFA_RET_NOT_SUPPORTED)
-			goto unlock;
+			return;
 
 		hyp_ffa_version = ffa_req_version;
 	}
@@ -804,8 +778,6 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *res,
 		smp_store_release(&has_version_negotiated, true);
 		res->a0 = hyp_ffa_version;
 	}
-unlock:
-	hyp_spin_unlock(&version_lock);
 }
 
 static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
@@ -818,10 +790,10 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, flags, ctxt, 5);
 	u32 count, partition_sz, copy_sz;
 
-	hyp_spin_lock(&host_buffers.lock);
+	guard(hyp_spinlock)(&host_buffers.lock);
 	if (!host_buffers.rx) {
 		ffa_to_smccc_res(res, FFA_RET_BUSY);
-		goto out_unlock;
+		return;
 	}
 
 	hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
@@ -834,16 +806,16 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
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
@@ -854,12 +826,10 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
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
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 3b0bee496bff..56c3eb4a2251 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -35,13 +35,8 @@ static DEFINE_PER_CPU(struct hyp_fixmap_slot, fixmap_slots);
 static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 				  unsigned long phys, enum kvm_pgtable_prot prot)
 {
-	int err;
-
-	hyp_spin_lock(&pkvm_pgd_lock);
-	err = kvm_pgtable_hyp_map(&pkvm_pgtable, start, size, phys, prot);
-	hyp_spin_unlock(&pkvm_pgd_lock);
-
-	return err;
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+	return kvm_pgtable_hyp_map(&pkvm_pgtable, start, size, phys, prot);
 }
 
 static int __pkvm_alloc_private_va_range(unsigned long start, size_t size)
@@ -80,10 +75,9 @@ int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
 	unsigned long addr;
 	int ret;
 
-	hyp_spin_lock(&pkvm_pgd_lock);
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
 	addr = __io_map_base;
 	ret = __pkvm_alloc_private_va_range(addr, size);
-	hyp_spin_unlock(&pkvm_pgd_lock);
 
 	*haddr = addr;
 
@@ -137,13 +131,8 @@ int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot
 
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 {
-	int ret;
-
-	hyp_spin_lock(&pkvm_pgd_lock);
-	ret = pkvm_create_mappings_locked(from, to, prot);
-	hyp_spin_unlock(&pkvm_pgd_lock);
-
-	return ret;
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+	return pkvm_create_mappings_locked(from, to, prot);
 }
 
 int hyp_back_vmemmap(phys_addr_t back)
@@ -340,22 +329,17 @@ static int create_fixblock(void)
 	if (i >= hyp_memblock_nr)
 		return -EINVAL;
 
-	hyp_spin_lock(&pkvm_pgd_lock);
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
 	addr = ALIGN(__io_map_base, PMD_SIZE);
 	ret = __pkvm_alloc_private_va_range(addr, PMD_SIZE);
 	if (ret)
-		goto unlock;
+		return ret;
 
 	ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, PMD_SIZE, phys, PAGE_HYP);
 	if (ret)
-		goto unlock;
+		return ret;
 
-	ret = kvm_pgtable_walk(&pkvm_pgtable, addr, PMD_SIZE, &walker);
-
-unlock:
-	hyp_spin_unlock(&pkvm_pgd_lock);
-
-	return ret;
+	return kvm_pgtable_walk(&pkvm_pgtable, addr, PMD_SIZE, &walker);
 #else
 	return 0;
 #endif
@@ -437,7 +421,7 @@ int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr)
 	size_t size;
 	int ret;
 
-	hyp_spin_lock(&pkvm_pgd_lock);
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
 
 	prev_base = __io_map_base;
 	/*
@@ -463,7 +447,6 @@ int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr)
 		if (ret)
 			__io_map_base = prev_base;
 	}
-	hyp_spin_unlock(&pkvm_pgd_lock);
 
 	*haddr = addr + size;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index a1eb27a1a747..f43d8ad507e9 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -167,18 +167,16 @@ void hyp_put_page(struct hyp_pool *pool, void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
 
-	hyp_spin_lock(&pool->lock);
+	guard(hyp_spinlock)(&pool->lock);
 	__hyp_put_page(pool, p);
-	hyp_spin_unlock(&pool->lock);
 }
 
 void hyp_get_page(struct hyp_pool *pool, void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
 
-	hyp_spin_lock(&pool->lock);
+	guard(hyp_spinlock)(&pool->lock);
 	hyp_page_ref_inc(p);
-	hyp_spin_unlock(&pool->lock);
 }
 
 void hyp_split_page(struct hyp_page *p)
@@ -200,22 +198,19 @@ void *hyp_alloc_pages(struct hyp_pool *pool, u8 order)
 	struct hyp_page *p;
 	u8 i = order;
 
-	hyp_spin_lock(&pool->lock);
+	guard(hyp_spinlock)(&pool->lock);
 
 	/* Look for a high-enough-order page */
 	while (i <= pool->max_order && list_empty(&pool->free_area[i]))
 		i++;
-	if (i > pool->max_order) {
-		hyp_spin_unlock(&pool->lock);
+	if (i > pool->max_order)
 		return NULL;
-	}
 
 	/* Extract it from the tree at the right order */
 	p = node_to_page(pool->free_area[i].next);
 	p = __hyp_extract_page(pool, p, order);
 
 	hyp_set_page_refcounted(p);
-	hyp_spin_unlock(&pool->lock);
 
 	return hyp_page_to_virt(p);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index eb1c10120f9f..7d843afd8c0a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -258,32 +258,27 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 	if (__this_cpu_read(loaded_hyp_vcpu))
 		return NULL;
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	hyp_vm = get_vm_by_handle(handle);
 	if (!hyp_vm || hyp_vm->kvm.arch.pkvm.is_dying)
-		goto unlock;
+		return NULL;
 
 	if (hyp_vm->kvm.created_vcpus <= vcpu_idx)
-		goto unlock;
+		return NULL;
 
 	/* Pairs with smp_store_release() in register_hyp_vcpu(). */
 	hyp_vcpu = smp_load_acquire(&hyp_vm->vcpus[vcpu_idx]);
 	if (!hyp_vcpu)
-		goto unlock;
+		return NULL;
 
 	/* Ensure vcpu isn't loaded on more than one cpu simultaneously. */
-	if (unlikely(hyp_vcpu->loaded_hyp_vcpu)) {
-		hyp_vcpu = NULL;
-		goto unlock;
-	}
+	if (unlikely(hyp_vcpu->loaded_hyp_vcpu))
+		return NULL;
 
 	hyp_vcpu->loaded_hyp_vcpu = this_cpu_ptr(&loaded_hyp_vcpu);
 	hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
-unlock:
-	hyp_spin_unlock(&vm_table_lock);
 
-	if (hyp_vcpu)
-		__this_cpu_write(loaded_hyp_vcpu, hyp_vcpu);
+	__this_cpu_write(loaded_hyp_vcpu, hyp_vcpu);
 	return hyp_vcpu;
 }
 
@@ -291,11 +286,10 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	hyp_vcpu->loaded_hyp_vcpu = NULL;
 	__this_cpu_write(loaded_hyp_vcpu, NULL);
 	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
-	hyp_spin_unlock(&vm_table_lock);
 }
 
 struct pkvm_hyp_vcpu *pkvm_get_loaded_hyp_vcpu(void)
@@ -308,20 +302,18 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
 {
 	struct pkvm_hyp_vm *hyp_vm;
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	hyp_vm = get_vm_by_handle(handle);
 	if (hyp_vm)
 		hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
-	hyp_spin_unlock(&vm_table_lock);
 
 	return hyp_vm;
 }
 
 void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm)
 {
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
-	hyp_spin_unlock(&vm_table_lock);
 }
 
 struct pkvm_hyp_vm *get_np_pkvm_hyp_vm(pkvm_handle_t handle)
@@ -620,13 +612,8 @@ static int __insert_vm_table_entry(pkvm_handle_t handle,
 static int insert_vm_table_entry(pkvm_handle_t handle,
 				 struct pkvm_hyp_vm *hyp_vm)
 {
-	int ret;
-
-	hyp_spin_lock(&vm_table_lock);
-	ret = __insert_vm_table_entry(handle, hyp_vm);
-	hyp_spin_unlock(&vm_table_lock);
-
-	return ret;
+	guard(hyp_spinlock)(&vm_table_lock);
+	return __insert_vm_table_entry(handle, hyp_vm);
 }
 
 /*
@@ -701,9 +688,8 @@ int __pkvm_reserve_vm(void)
 {
 	int ret;
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	ret = allocate_vm_table_entry();
-	hyp_spin_unlock(&vm_table_lock);
 
 	if (ret < 0)
 		return ret;
@@ -722,10 +708,9 @@ void __pkvm_unreserve_vm(pkvm_handle_t handle)
 	if (unlikely(!vm_table))
 		return;
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	if (likely(idx < KVM_MAX_PVMS && vm_table[idx] == RESERVED_ENTRY))
 		remove_vm_table_entry(handle);
-	hyp_spin_unlock(&vm_table_lock);
 }
 
 #ifdef CONFIG_NVHE_EL2_DEBUG
@@ -785,9 +770,8 @@ struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
 
 void teardown_selftest_vm(void)
 {
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	remove_vm_table_entry(selftest_vm.kvm.arch.pkvm.handle);
-	hyp_spin_unlock(&vm_table_lock);
 }
 #endif /* CONFIG_NVHE_EL2_DEBUG */
 
@@ -973,20 +957,15 @@ static struct pkvm_hyp_vm *get_pkvm_unref_hyp_vm_locked(pkvm_handle_t handle)
 int __pkvm_start_teardown_vm(pkvm_handle_t handle)
 {
 	struct pkvm_hyp_vm *hyp_vm;
-	int ret = 0;
 
-	hyp_spin_lock(&vm_table_lock);
+	guard(hyp_spinlock)(&vm_table_lock);
 	hyp_vm = get_pkvm_unref_hyp_vm_locked(handle);
-	if (!hyp_vm || hyp_vm->kvm.arch.pkvm.is_dying) {
-		ret = -EINVAL;
-		goto unlock;
-	}
+	if (!hyp_vm || hyp_vm->kvm.arch.pkvm.is_dying)
+		return -EINVAL;
 
 	hyp_vm->kvm.arch.pkvm.is_dying = true;
-unlock:
-	hyp_spin_unlock(&vm_table_lock);
 
-	return ret;
+	return 0;
 }
 
 int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
@@ -996,22 +975,19 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	struct kvm *host_kvm;
 	unsigned int idx;
 	size_t vm_size;
-	int err;
 
-	hyp_spin_lock(&vm_table_lock);
-	hyp_vm = get_pkvm_unref_hyp_vm_locked(handle);
-	if (!hyp_vm || !hyp_vm->kvm.arch.pkvm.is_dying) {
-		err = -EINVAL;
-		goto err_unlock;
+	scoped_guard(hyp_spinlock, &vm_table_lock) {
+		hyp_vm = get_pkvm_unref_hyp_vm_locked(handle);
+		if (!hyp_vm || !hyp_vm->kvm.arch.pkvm.is_dying)
+			return -EINVAL;
+
+		host_kvm = hyp_vm->host_kvm;
+
+		/* Ensure the VMID is clean before it can be reallocated */
+		__kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
+		remove_vm_table_entry(handle);
 	}
 
-	host_kvm = hyp_vm->host_kvm;
-
-	/* Ensure the VMID is clean before it can be reallocated */
-	__kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
-	remove_vm_table_entry(handle);
-	hyp_spin_unlock(&vm_table_lock);
-
 	/* Reclaim guest pages (including page-table pages) */
 	mc = &host_kvm->arch.pkvm.teardown_mc;
 	stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
@@ -1042,10 +1018,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	teardown_donated_memory(mc, hyp_vm, vm_size);
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return 0;
-
-err_unlock:
-	hyp_spin_unlock(&vm_table_lock);
-	return err;
 }
 
 static u64 __pkvm_memshare_page_req(struct kvm_vcpu *vcpu, u64 ipa)
-- 
2.54.0.1136.gdb2ca164c4-goog

