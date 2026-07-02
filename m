Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6FE399377
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 10:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988755; cv=none; b=RcfFTLuocw3cwmH6MmQkBqn33mlRxOld3xxiaBGO0CbFgwfoQOV4B4jaD5rwpfaUHkhdweBLND6tsmzBaq3BH4JDuVQGdtO4Tc+g2eVvwIFKC9qsw14dC/VIUXF45et1cQ2Urk2m2ja5+JNqOvVpFOjWvFd5CILMFLqTc8KxJeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988755; c=relaxed/simple;
	bh=RVonFDWpygT8oBcy9USOgqohMRqC4xEQf3kgUS7+Kzs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UQanHBdCOWckk8qjsUWCDrY2odd79peIHlHOhMIUWBt/mGyMUsmTYlhwm63tnBEtTec8wTYKJ7WEXjYl3kehswv5EZYH2gelVo0Mk88nfgp2nusNDixFVHvnlsoQFEkxzAIrgziKhwSjZn9SO4XwBEWzxeFt8m6cGRh7j1HEmos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CmmpCxYk; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CmmpCxYk"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c126f9928f6so172028166b.0
        for <kvmarm@lists.linux.dev>; Thu, 02 Jul 2026 03:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782988753; x=1783593553; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pvvBZVAHxjCca8xpuD4vg6YCLTc80qN7YLXWi5qiQXY=;
        b=CmmpCxYkoMierREBo+6UF9L2ecTxw1tVvktn/mbMouNJmP+Uk8+EIi3vhqSoE3OQC7
         oAJMhWrgho10Yvg2juBKxHUhLQKjwN4xP7/ST9uaA3nE5cqfsxYF5mJyBVSOdhPgusV8
         zcyLvccx0wGcQm2CW2kwcC/wL59g6rg3NMRz3iZbgC7AKxpUylnyIP6TcdvyuXylcgQS
         lN9PzPvL2RFXsgLWHdnkrVtiZnzU8VrsaVjRbkLzVc01KKQE1G2SGbs039C5aIzyARSt
         2x3cVXkY9ul+g0chrjLrNsB4Uvk9e4BVwVgkFqSZgIp5AAo1L/lADDI5gYLI4hsUu7hs
         4buw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782988753; x=1783593553;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pvvBZVAHxjCca8xpuD4vg6YCLTc80qN7YLXWi5qiQXY=;
        b=XPlhFoTfqArbPADOypTv9mf/IeF4NcMIit9FAtFfGM6Kwpe62XtwfL3EqZnzlnwkmC
         TYR5UKEknhchEkVgxR2IAWsqlbBu5FlIAO6KjfZOAbJ9Ubpl3SuSOPFmaIZJ6AG4zNSP
         4AtIfcOInuhFfzZKE2Kz8zccVOKtQjMmTDBAawYtbWmF7GEvYXxF1ND1LrsQQOz1h5zz
         yCOLzaD3PTkVAudN2x+bnGXn8O/Sr/O6OIl++h4vwJH4ftpHMgicaPLFqBMOOGrqKkp6
         bidf/Na/he4R315Hn4MrYt5NBenSwJ1Cr2O+SCkOqWDEuDvmPs3nURg69K0KZDMrSP8m
         a8eA==
X-Forwarded-Encrypted: i=1; AHgh+Rp/kh0yUOvhvShEKIQgYcCbWW9kBl1ivNyJQfueKLRJGtt9cernOlJmc0Q1dNdv4b6Adeg42Uo=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywym4xqfoamaie3Jk9z6lMQyDyKTr6eeKuv5olWoauqKXkhRE33
	91lZiW/xU3tnahAZniTnK3mxguIGxtDRv7wU+7nyWJvjpkF05zotfRcLMvwB+ECJa4IY0RMU0DJ
	DWHe7PM34489ZUOReomySE4QYhgeJkQ==
X-Received: from ejcxl38.prod.google.com ([2002:a17:907:d866:b0:c12:69ca:c04d])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:6290:b0:c12:34ed:e0fc with SMTP id a640c23a62f3a-c12aa1d60f1mr264254366b.58.1782988752409;
 Thu, 02 Jul 2026 03:39:12 -0700 (PDT)
Date: Thu,  2 Jul 2026 10:38:41 +0000
In-Reply-To: <20260702103848.1647249-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702103848.1647249-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260702103848.1647249-5-sebastianene@google.com>
Subject: [PATCH v9 4/6] KVM: arm64: Validate the offset to the mem access descriptor
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org, 
	will@kernel.org
Cc: jens.wiklander@linaro.org, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, maz@kernel.org, mrigendra.chaubey@gmail.com, 
	op-tee@lists.trustedfirmware.org, perlarsen@google.com, 
	sebastianene@google.com, seiden@linux.ibm.com, smostafa@google.com, 
	sumit.garg@kernel.org, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Prevent the pKVM hypervisor from making assumptions that the
endpoint memory access descriptor (EMAD) comes right after the
FF-A memory region header.
Prior to FF-A version 1.1 the header of the memory region
didn't contain an offset to the endpoint memory access descriptor.
The layout of a memory transaction looks like this from 1.1 onward:
Type | Field name | Offset
[ Header | ffa_mem_region  | 0
  EMAD 1 | ffa_mem_region_attributes) | ffa_mem_region.ep_mem_offset
]
Verify that the offset to the first endpoint memory access descriptor
is within the mailbox buffer bounds.

Also, fix one hardcoded sizeof(struct ffa_mem_region_attributes) that
should be replaced ffa_emad_size_get() for compatibility with FFA v1.0.

Fixes: 42fb33dde42b ("KVM: arm64: Use FF-A 1.1 with pKVM")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 27 +++++++++++++++++++--------
 include/linux/arm_ffa.h       |  7 +++++++
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 41cc4c1bafeb..2e7ab7e3319d 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -476,11 +476,12 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	DECLARE_REG(u32, fraglen, ctxt, 2);
 	DECLARE_REG(u64, addr_mbz, ctxt, 3);
 	DECLARE_REG(u32, npages_mbz, ctxt, 4);
+	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
-	u32 offset, nr_ranges, checked_offset;
 	int ret = 0;
+	size_t mem_region_len = FFA_MEM_REGION_SZ(hyp_ffa_version);
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
@@ -488,8 +489,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 		goto out;
 	}
 
-	if (fraglen < sizeof(struct ffa_mem_region) +
-		      sizeof(struct ffa_mem_region_attributes)) {
+	if (fraglen < mem_region_len + ffa_emad_size_get(hyp_ffa_version)) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto out;
 	}
@@ -508,8 +508,13 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
-	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	ep_mem_access = (void *)buf + em_mem_access_off;
 	offset = ep_mem_access->composite_off;
 	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -574,9 +579,9 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, handle_lo, ctxt, 1);
 	DECLARE_REG(u32, handle_hi, ctxt, 2);
 	DECLARE_REG(u32, flags, ctxt, 3);
+	u32 offset, len, fraglen, fragoff, em_mem_access_off;
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
-	u32 offset, len, fraglen, fragoff;
 	struct ffa_mem_region *buf;
 	int ret = 0;
 	u64 handle;
@@ -599,8 +604,14 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	len = res->a1;
 	fraglen = res->a2;
 
-	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		ffa_rx_release(res);
+		goto out_unlock;
+	}
+
+	ep_mem_access = (void *)buf + em_mem_access_off;
 	offset = ep_mem_access->composite_off;
 	/*
 	 * We can trust the SPMD to get this right, but let's at least
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 033c630b271b..e71d83ee0aef 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -421,6 +421,13 @@ struct ffa_mem_region {
 #define FFA_EMAD_HAS_IMPDEF_FIELD(version)	((version) >= FFA_VERSION_1_2)
 #define FFA_MEM_REGION_HAS_EP_MEM_OFFSET(version) ((version) > FFA_VERSION_1_0)
 
+/* The layout changed from FFA_VERSION_1_0 and the region includes an
+ * ep_mem_offset.
+ */
+#define FFA_MEM_REGION_SZ(version)		(!FFA_MEM_REGION_HAS_EP_MEM_OFFSET((version)) ?\
+						 offsetof(struct ffa_mem_region, ep_mem_offset) :\
+						 sizeof(struct ffa_mem_region))
+
 static inline u32 ffa_emad_size_get(u32 ffa_version)
 {
 	u32 sz;
-- 
2.55.0.rc0.799.gd6f94ed593-goog

