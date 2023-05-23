Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874581EA6B
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 10:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F76C4339E;
	Tue, 23 May 2023 10:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684837142;
	bh=AOtcb8bCM2Xw/5OPTeNCDb5WOiyiiUnEmqHECwp2Kd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxBmyUIN/03O47hDNSBk1gQb8TKxoDggr4kE7zA4kDZBMYSGsaEK3PN+Oetgzafpb
	 HXKfbCvUTqbReGFgEyaaDeAEoiriqyAEZ6XebuyUt/JAPT1sYL6QpwXpE/QhWG7lgZ
	 ZYKAyutsSzN+jLiKpU7LRSm2cV30txzdKz7PBPcY+Fhz7vcA7hBB8xSuqvSU/Cagam
	 9X2T9eS1wBbMYQvXOepfVxvgeltF0+eE9UN43a2fCN2O5dnE97ffvlGeYR/lYBBvSk
	 JDYw8zya5MCDB80HGgoscwrgQUktPcIysTmSbYCh5WOY++Z3Ss43JS16lVW6Plxzlr
	 Khuq5lmHDgI7w==
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
Subject: [PATCH v3 10/10] KVM: arm64: pkvm: Add support for fragmented FF-A descriptors
Date: Tue, 23 May 2023 11:18:27 +0100
Message-Id: <20230523101828.7328-11-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230523101828.7328-1-will@kernel.org>
References: <20230523101828.7328-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Quentin Perret <qperret@google.com>

FF-A memory descriptors may need to be sent in fragments when they don't
fit in the mailboxes. Doing so involves using the FRAG_TX and FRAG_RX
primitives defined in the FF-A protocol.

Add support in the pKVM FF-A relayer for fragmented descriptors by
monitoring outgoing FRAG_TX transactions and by buffering large
descriptors on the reclaim path.

Co-developed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h |  17 ++-
 arch/arm64/kvm/hyp/nvhe/ffa.c     | 170 ++++++++++++++++++++++++++----
 2 files changed, 162 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 2b495ec59deb..e46250a02017 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -6,7 +6,9 @@
 #ifndef __ARM64_KVM_PKVM_H__
 #define __ARM64_KVM_PKVM_H__
 
+#include <linux/arm_ffa.h>
 #include <linux/memblock.h>
+#include <linux/scatterlist.h>
 #include <asm/kvm_pgtable.h>
 
 /* Maximum number of VMs that can co-exist under pKVM. */
@@ -110,8 +112,19 @@ static inline unsigned long host_s2_pgtable_pages(void)
 
 static inline unsigned long hyp_ffa_proxy_pages(void)
 {
-	/* A page each for the hypervisor's RX and TX mailboxes. */
-	return 2 * KVM_FFA_MBOX_NR_PAGES;
+	size_t desc_max;
+
+	/*
+	 * The hypervisor FFA proxy needs enough memory to buffer a fragmented
+	 * descriptor returned from EL3 in response to a RETRIEVE_REQ call.
+	 */
+	desc_max = sizeof(struct ffa_mem_region) +
+		   sizeof(struct ffa_mem_region_attributes) +
+		   sizeof(struct ffa_composite_mem_region) +
+		   SG_MAX_SEGMENTS * sizeof(struct ffa_mem_region_addr_range);
+
+	/* Plus a page each for the hypervisor's RX and TX mailboxes. */
+	return (2 * KVM_FFA_MBOX_NR_PAGES) + DIV_ROUND_UP(desc_max, PAGE_SIZE);
 }
 
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 926314a9b9d7..58dcd92bf346 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -42,6 +42,18 @@
  */
 #define HOST_FFA_ID	0
 
+/*
+ * A buffer to hold the maximum descriptor size we can see from the host,
+ * which is required when the SPMD returns a fragmented FFA_MEM_RETRIEVE_RESP
+ * when resolving the handle on the reclaim path.
+ */
+struct kvm_ffa_descriptor_buffer {
+	void	*buf;
+	size_t	len;
+};
+
+static struct kvm_ffa_descriptor_buffer ffa_desc_buf;
+
 struct kvm_ffa_buffers {
 	hyp_spinlock_t lock;
 	void *tx;
@@ -122,6 +134,24 @@ static int ffa_unmap_hyp_buffers(void)
 	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
 }
 
+static void ffa_mem_frag_tx(struct arm_smccc_res *res, u32 handle_lo,
+			     u32 handle_hi, u32 fraglen, u32 endpoint_id)
+{
+	arm_smccc_1_1_smc(FFA_MEM_FRAG_TX,
+			  handle_lo, handle_hi, fraglen, endpoint_id,
+			  0, 0, 0,
+			  res);
+}
+
+static void ffa_mem_frag_rx(struct arm_smccc_res *res, u32 handle_lo,
+			     u32 handle_hi, u32 fragoff)
+{
+	arm_smccc_1_1_smc(FFA_MEM_FRAG_RX,
+			  handle_lo, handle_hi, fragoff, HOST_FFA_ID,
+			  0, 0, 0,
+			  res);
+}
+
 static void ffa_mem_xfer(struct arm_smccc_res *res, u64 func_id, u32 len,
 			  u32 fraglen)
 {
@@ -327,6 +357,64 @@ static int ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
 	return ret;
 }
 
+static void do_ffa_mem_frag_tx(struct arm_smccc_res *res,
+			       struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, handle_lo, ctxt, 1);
+	DECLARE_REG(u32, handle_hi, ctxt, 2);
+	DECLARE_REG(u32, fraglen, ctxt, 3);
+	DECLARE_REG(u32, endpoint_id, ctxt, 4);
+	struct ffa_mem_region_addr_range *buf;
+	int ret = FFA_RET_INVALID_PARAMETERS;
+	u32 nr_ranges;
+
+	if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)
+		goto out;
+
+	if (fraglen % sizeof(*buf))
+		goto out;
+
+	hyp_spin_lock(&host_buffers.lock);
+	if (!host_buffers.tx)
+		goto out_unlock;
+
+	buf = hyp_buffers.tx;
+	memcpy(buf, host_buffers.tx, fraglen);
+	nr_ranges = fraglen / sizeof(*buf);
+
+	ret = ffa_host_share_ranges(buf, nr_ranges);
+	if (ret) {
+		/*
+		 * We're effectively aborting the transaction, so we need
+		 * to restore the global state back to what it was prior to
+		 * transmission of the first fragment.
+		 */
+		ffa_mem_reclaim(res, handle_lo, handle_hi, 0);
+		WARN_ON(res->a0 != FFA_SUCCESS);
+		goto out_unlock;
+	}
+
+	ffa_mem_frag_tx(res, handle_lo, handle_hi, fraglen, endpoint_id);
+	if (res->a0 != FFA_SUCCESS && res->a0 != FFA_MEM_FRAG_RX)
+		WARN_ON(ffa_host_unshare_ranges(buf, nr_ranges));
+
+out_unlock:
+	hyp_spin_unlock(&host_buffers.lock);
+out:
+	if (ret)
+		ffa_to_smccc_res(res, ret);
+
+	/*
+	 * If for any reason this did not succeed, we're in trouble as we have
+	 * now lost the content of the previous fragments and we can't rollback
+	 * the host stage-2 changes. The pages previously marked as shared will
+	 * remain stuck in that state forever, hence preventing the host from
+	 * sharing/donating them again and may possibly lead to subsequent
+	 * failures, but this will not compromise confidentiality.
+	 */
+	return;
+}
+
 static __always_inline void do_ffa_mem_xfer(const u64 func_id,
 					    struct arm_smccc_res *res,
 					    struct kvm_cpu_context *ctxt)
@@ -337,8 +425,8 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
 	DECLARE_REG(u32, npages_mbz, ctxt, 4);
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
+	u32 offset, nr_ranges;
 	int ret = 0;
-	u32 offset;
 
 	BUILD_BUG_ON(func_id != FFA_FN64_MEM_SHARE &&
 		     func_id != FFA_FN64_MEM_LEND);
@@ -349,11 +437,6 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
 		goto out;
 	}
 
-	if (fraglen < len) {
-		ret = FFA_RET_ABORTED;
-		goto out;
-	}
-
 	if (fraglen < sizeof(struct ffa_mem_region) +
 		      sizeof(struct ffa_mem_region_attributes)) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -381,21 +464,26 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
 	}
 
 	reg = (void *)buf + offset;
-	if (fraglen < offset + sizeof(struct ffa_composite_mem_region) +
-		      reg->addr_range_cnt *
-		      sizeof(struct ffa_mem_region_addr_range)) {
+	nr_ranges = ((void *)buf + fraglen) - (void *)reg->constituents;
+	if (nr_ranges % sizeof(reg->constituents[0])) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto out_unlock;
 	}
 
-	ret = ffa_host_share_ranges(reg->constituents, reg->addr_range_cnt);
+	nr_ranges /= sizeof(reg->constituents[0]);
+	ret = ffa_host_share_ranges(reg->constituents, nr_ranges);
 	if (ret)
 		goto out_unlock;
 
 	ffa_mem_xfer(res, func_id, len, fraglen);
-	if (res->a0 != FFA_SUCCESS) {
-		WARN_ON(ffa_host_unshare_ranges(reg->constituents,
-						reg->addr_range_cnt));
+	if (fraglen != len) {
+		if (res->a0 != FFA_MEM_FRAG_RX)
+			goto err_unshare;
+
+		if (res->a3 != fraglen)
+			goto err_unshare;
+	} else if (res->a0 != FFA_SUCCESS) {
+		goto err_unshare;
 	}
 
 out_unlock:
@@ -404,6 +492,10 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
 	if (ret)
 		ffa_to_smccc_res(res, ret);
 	return;
+
+err_unshare:
+	WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
+	goto out_unlock;
 }
 
 static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
@@ -413,9 +505,9 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
 	DECLARE_REG(u32, handle_hi, ctxt, 2);
 	DECLARE_REG(u32, flags, ctxt, 3);
 	struct ffa_composite_mem_region *reg;
+	u32 offset, len, fraglen, fragoff;
 	struct ffa_mem_region *buf;
 	int ret = 0;
-	u32 offset;
 	u64 handle;
 
 	handle = PACK_HANDLE(handle_lo, handle_hi);
@@ -433,11 +525,8 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
 	if (res->a0 != FFA_MEM_RETRIEVE_RESP)
 		goto out_unlock;
 
-	/* Check for fragmentation */
-	if (res->a1 != res->a2) {
-		ret = FFA_RET_ABORTED;
-		goto out_unlock;
-	}
+	len = res->a1;
+	fraglen = res->a2;
 
 	offset = buf->ep_mem_access[0].composite_off;
 	/*
@@ -445,16 +534,36 @@ static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
 	 * check that we end up with something that doesn't look _completely_
 	 * bogus.
 	 */
-	if (WARN_ON(offset > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
+	if (WARN_ON(offset > len ||
+		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
 		ret = FFA_RET_ABORTED;
 		goto out_unlock;
 	}
 
-	reg = (void *)buf + offset;
+	if (len > ffa_desc_buf.len) {
+		ret = FFA_RET_NO_MEMORY;
+		goto out_unlock;
+	}
+
+	buf = ffa_desc_buf.buf;
+	memcpy(buf, hyp_buffers.rx, fraglen);
+
+	for (fragoff = fraglen; fragoff < len; fragoff += fraglen) {
+		ffa_mem_frag_rx(res, handle_lo, handle_hi, fragoff);
+		if (res->a0 != FFA_MEM_FRAG_TX) {
+			ret = FFA_RET_INVALID_PARAMETERS;
+			goto out_unlock;
+		}
+
+		fraglen = res->a3;
+		memcpy((void *)buf + fragoff, hyp_buffers.rx, fraglen);
+	}
+
 	ffa_mem_reclaim(res, handle_lo, handle_hi, flags);
 	if (res->a0 != FFA_SUCCESS)
 		goto out_unlock;
 
+	reg = (void *)buf + offset;
 	/* If the SPMD was happy, then we should be too. */
 	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
 					reg->addr_range_cnt));
@@ -569,6 +678,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 	case FFA_FN64_MEM_LEND:
 		do_ffa_mem_xfer(FFA_FN64_MEM_LEND, &res, host_ctxt);
 		goto out_handled;
+	case FFA_MEM_FRAG_TX:
+		do_ffa_mem_frag_tx(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
@@ -584,6 +696,7 @@ int hyp_ffa_init(void *pages)
 {
 	struct arm_smccc_res res;
 	size_t min_rxtx_sz;
+	void *tx, *rx;
 
 	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
 		return 0;
@@ -624,10 +737,21 @@ int hyp_ffa_init(void *pages)
 	if (min_rxtx_sz > PAGE_SIZE)
 		return -EOPNOTSUPP;
 
+	tx = pages;
+	pages += KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE;
+	rx = pages;
+	pages += KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE;
+
+	ffa_desc_buf = (struct kvm_ffa_descriptor_buffer) {
+		.buf	= pages,
+		.len	= PAGE_SIZE *
+			  (hyp_ffa_proxy_pages() - (2 * KVM_FFA_MBOX_NR_PAGES)),
+	};
+
 	hyp_buffers = (struct kvm_ffa_buffers) {
 		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
-		.tx	= pages,
-		.rx	= pages + (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE),
+		.tx	= tx,
+		.rx	= rx,
 	};
 
 	host_buffers = (struct kvm_ffa_buffers) {
-- 
2.40.1.698.g37aff9b760-goog

