Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF4A3C17
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 12:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4D3C433EF;
	Wed, 19 Apr 2023 12:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681906875;
	bh=JQAd7sZNBD2IwEvq9q/vPlYzxrkqhWqe6JJHE/c3x/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsI1Ch/+aD6bfIcXISkQJ4LYR/HRCLDwDrOySFX3bdVeYMlKrMiI2Eiw4x/tWxVqH
	 KLJAqcVd/PQc/1EoEUoq2I92KmP9wuBxMuKBYme3f0vJixQyPHCI/H7U0TB/NQB0v0
	 M7huIRKdED6YbCNIob90mx/lqlMgJDJ8C1wS87+YPQxuCspjrlLB4VkZ7pjZ/x5Zqq
	 Hv1CB+F7zTZo4vWw/m7jVWDhU27vEXMvZ/FdKhQC5Azl7qz3os2C29PCXjGxNwafPn
	 iSSFE0RUhpph1EXfMo62+p7D/LyKh8V4o7Zb+j1up2tZCpFVCmNSo/j4ITlJxkCofi
	 XATxhzj3yVX1g==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	kernel-team@android.com,
	Andrew Walbran <qwandor@google.com>
Subject: [PATCH v2 06/10] KVM: arm64: Handle FFA_MEM_SHARE calls from the host
Date: Wed, 19 Apr 2023 13:20:47 +0100
Message-Id: <20230419122051.1341-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230419122051.1341-1-will@kernel.org>
References: <20230419122051.1341-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intercept FFA_MEM_SHARE/FFA_FN64_MEM_SHARE calls from the host and
transition the host stage-2 page-table entries from the OWNED state to
the SHARED_OWNED state prior to forwarding the call onto EL3.

Co-developed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 155 ++++++++++++++++++++++++++++++++++
 1 file changed, 155 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 9ee3be517e1e..95bc70e52e91 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -116,6 +116,14 @@ static int spmd_unmap_ffa_buffers(void)
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
@@ -224,6 +232,149 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_res *res,
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
 /*
  * Is a given FFA function supported, either by forwarding on directly
  * or by handling at EL2?
@@ -273,6 +424,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 	case FFA_RXTX_UNMAP:
 		do_ffa_rxtx_unmap(&res, host_ctxt);
 		goto out_handled;
+	case FFA_MEM_SHARE:
+	case FFA_FN64_MEM_SHARE:
+		do_ffa_mem_share(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
-- 
2.40.0.634.g4ca3ef3211-goog

