Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66379D504
	for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 17:04:01 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id e8-20020a5b0cc8000000b006bca0fa3ab6so16528178ybr.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 09:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kO5XlRLmK3X8yXuHSC9GCM5rHDlrcfte6dUBAr7snZ0=;
        b=Y3JgUHSpN2o2TEbLvsP9DwLQXgzSZaz8ke99wrsW6mIKrokYNfHgnkzf0ja40+rIff
         /bftVCEeJbQFZOCn+ViODY4NOrlOqWLmD0TT6HDlMMgjp9f959RL3FVj4CVQ98bKjhQa
         tTVU3PWe4CZSYpYkTNetpwgFsYCDtCvK57SXuxzMF6TC0SOOjzatLsRiHrWBrm1baKzz
         xk3K/OxjTRMiXbgJGcofSKrg/7k3Rv9456GiNmHqZwfxlN+waLnAuClNMcnxMu4QX/0Q
         UdOHZsILlMcXyGZDE7cclykOjm3nLH9vcUOiK84XqZJmuK4BfQsnSWEv/jGQq5+fEfqW
         NXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kO5XlRLmK3X8yXuHSC9GCM5rHDlrcfte6dUBAr7snZ0=;
        b=c0KEN9NAWL1QPXXEi5FZ8Uo2HlbT7FuB355+NKLFatuZ6gWLCCt6BloSK05TIomX4s
         OmSf6XIu5lWrweo7UW4Fk5wcD2zInGGKSFkfBw+cgj7/P5Q9XSujryn/OENRENdX2asI
         doXUXKDXp4puBMEaAz3mJFUqiRjFL8UNOUGQJjh3idaxNSnVswuRgYUCS5bWcqh/ChF5
         XjQ9L0sD9ViWg9dQkmoVDc4hlwp1IPrFoiHl6jGj1kaLgitDyzj5e/id6akGXi2AEuti
         tuaQr8HW5JILM+o5/dV5QX/E3jTLXSL3lRQ5zUuf6LQJ/U9Kc69Lp/KMWq3mOxF1clY2
         WGmQ==
X-Gm-Message-State: ACrzQf3R7b41YIfHjMgylEhEymR5yPEbEyZHhz1YGZd3XCfJHy8SDhjQ
	6YSYQnjEJALNoPJj9OpDomaFBWlCs//u
X-Google-Smtp-Source: AMsMyM7GE8le/jzj4qfxiRqiuoLCuJYhLYOD1uZIoZ1/9pgFDEeEFX2WZV7am/Up/It4weMCnd8Pp8GZR2e6
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a81:1dce:0:b0:34c:e500:b95b with SMTP id
 d197-20020a811dce000000b0034ce500b95bmr63847085ywd.109.1668618240086; Wed, 16
 Nov 2022 09:04:00 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:32 +0000
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221116170335.2341003-1-qperret@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-10-qperret@google.com>
Subject: [PATCH 09/12] KVM: arm64: Handle FFA_MEM_SHARE calls from the host
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Andrew Walbran <qwandor@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221116170332.zVc7uUwG7Rp-ZHuZJMcr7CItJROP-TMRx53UxCgUKIw@z>

From: Will Deacon <will@kernel.org>

Intercept FFA_MEM_SHARE/FFA_FN64_MEM_SHARE calls from the host and
transition the host stage-2 page-table entries from the OWNED state to
the SHARED_OWNED state prior to forwarding the call onto EL3.

Co-developed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 153 ++++++++++++++++++++++++++++++++++
 1 file changed, 153 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 8388cc901c97..e6d85849c617 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -122,6 +122,14 @@ static int spmd_unmap_ffa_buffers(void)
 	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
 }
 
+static void spmd_mem_share(struct arm_smccc_res *res, u32 len, u32 fraglen)
+{
+	arm_smccc_1_1_smc(FFA_FN64_MEM_SHARE,
+			  len, fraglen,
+			  0, 0, 0, 0, 0,
+			  res);
+}
+
 static void do_ffa_rxtx_map(struct arm_smccc_res *res,
 			    struct kvm_cpu_context *ctxt)
 {
@@ -230,6 +238,149 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_res *res,
 	ffa_to_smccc_res(res, ret);
 }
 
+static u32 __ffa_host_share_ranges(struct ffa_mem_region_addr_range *ranges,
+				   u32 nranges)
+{
+	u32 i;
+
+	for (i = 0; i < nranges; ++i) {
+		struct ffa_mem_region_addr_range *range = &ranges[i];
+		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
+		u64 pfn = hyp_phys_to_pfn(range->address);
+
+		if (!PAGE_ALIGNED(sz))
+			break;
+
+		if (__pkvm_host_share_ffa(pfn, sz / PAGE_SIZE))
+			break;
+	}
+
+	return i;
+}
+
+static u32 __ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
+				     u32 nranges)
+{
+	u32 i;
+
+	for (i = 0; i < nranges; ++i) {
+		struct ffa_mem_region_addr_range *range = &ranges[i];
+		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
+		u64 pfn = hyp_phys_to_pfn(range->address);
+
+		if (!PAGE_ALIGNED(sz))
+			break;
+
+		if (__pkvm_host_unshare_ffa(pfn, sz / PAGE_SIZE))
+			break;
+	}
+
+	return i;
+}
+
+static int ffa_host_share_ranges(struct ffa_mem_region_addr_range *ranges,
+				 u32 nranges)
+{
+	u32 nshared = __ffa_host_share_ranges(ranges, nranges);
+	int ret = 0;
+
+	if (nshared != nranges) {
+		WARN_ON(__ffa_host_unshare_ranges(ranges, nshared) != nshared);
+		ret = FFA_RET_DENIED;
+	}
+
+	return ret;
+}
+
+static int ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
+				   u32 nranges)
+{
+	u32 nunshared = __ffa_host_unshare_ranges(ranges, nranges);
+	int ret = 0;
+
+	if (nunshared != nranges) {
+		WARN_ON(__ffa_host_share_ranges(ranges, nunshared) != nunshared);
+		ret = FFA_RET_DENIED;
+	}
+
+	return ret;
+}
+
+static void do_ffa_mem_share(struct arm_smccc_res *res,
+			     struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, len, ctxt, 1);
+	DECLARE_REG(u32, fraglen, ctxt, 2);
+	DECLARE_REG(u64, addr_mbz, ctxt, 3);
+	DECLARE_REG(u32, npages_mbz, ctxt, 4);
+	struct ffa_composite_mem_region *reg;
+	struct ffa_mem_region *buf;
+	int ret = 0;
+	u32 offset;
+
+	if (addr_mbz || npages_mbz || fraglen > len ||
+	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	if (fraglen < len) {
+		ret = FFA_RET_ABORTED;
+		goto out;
+	}
+
+	if (fraglen < sizeof(struct ffa_mem_region) +
+		      sizeof(struct ffa_mem_region_attributes)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	hyp_spin_lock(&host_buffers.lock);
+	if (!host_buffers.tx) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	buf = hyp_buffers.tx;
+	memcpy(buf, host_buffers.tx, fraglen);
+
+	offset = buf->ep_mem_access[0].composite_off;
+	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	if (fraglen < offset + sizeof(struct ffa_composite_mem_region)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	reg = (void *)buf + offset;
+	if (fraglen < offset + sizeof(struct ffa_composite_mem_region) +
+		      reg->addr_range_cnt *
+		      sizeof(struct ffa_mem_region_addr_range)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	ret = ffa_host_share_ranges(reg->constituents, reg->addr_range_cnt);
+	if (ret)
+		goto out_unlock;
+
+	spmd_mem_share(res, len, fraglen);
+	if (res->a0 != FFA_SUCCESS) {
+		WARN_ON(ffa_host_unshare_ranges(reg->constituents,
+						reg->addr_range_cnt));
+	}
+
+out_unlock:
+	hyp_spin_unlock(&host_buffers.lock);
+out:
+	if (ret)
+		ffa_to_smccc_res(res, ret);
+	return;
+}
+
 static bool ffa_call_unsupported(u64 func_id)
 {
 	switch (func_id) {
@@ -308,6 +459,8 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 		goto out_handled;
 	case FFA_MEM_SHARE:
 	case FFA_FN64_MEM_SHARE:
+		do_ffa_mem_share(&res, host_ctxt);
+		goto out_handled;
 	case FFA_MEM_LEND:
 	case FFA_FN64_MEM_LEND:
 	case FFA_MEM_RECLAIM:
-- 
2.38.1.431.g37b22c650d-goog

