Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997B4466B44
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707912; cv=none; b=IupApL9z06YoKmdSV7lM6c/QTQjVtN9UhWmeTS2Vm9q4eYIOegEO49At2B20RrPGeiSnB+s4X0Wd29pIWksTFcDG96k6NRV9sHKKbRs3OMv4r/dhIhTC8ZLntUjmwy+V7VEBUk15yMXFGyR4fWTjucLO5aAoeSQbfyRvNwMbfks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707912; c=relaxed/simple;
	bh=0Gnoj5mVkYvfotoTTL4oke5ZLGjP0C1k2XZl/76sd5A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bs8XZbX9rZsx6FlVqTBUWoPYfPCuEqw3udPscrZ+FeslrhCII9/r7HbBRIxHi8njBzXa2LbnWbBkbVEsRvUwImkjxWWz2NUh+UNz7VmjU2HPeB/yvHuTBXe7uvXSjK7QqT/uztySbSiSk9ZveC27D01rW8X8/0DomjnJT6nsCjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mnx6Ez2F; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mnx6Ez2F"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b2f22ea2so53655135e9.1
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 07:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707909; x=1782312709; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qkRBbhHB4iuN7xSPIITChDuTjwYpXvbOBnslFsQsEpc=;
        b=mnx6Ez2FwLjiQFN8cy302JNkETVFE0n+Aj7OihRVWmKYpiJ8wB7f3Pblss91OF335+
         fHWIBBrNP/ifp9D7M+py/k4jvk5lGvoO2SsGc6QZi0jHLztis2bwq1FQK0vqqMOUAncu
         bZRX0MJC076uCg1OvYThwQ9QJd4qlRf1gUUFbuInU2zsV6io/a3EhB7Pp6i4dy/ywEf4
         sJCTNUMNlJjeZa03ixGcS2vcjPZK2JQm5OoY/Ljw8aOteUQwCwT+G4BR+5eg3PjLXLLG
         LyfQhtCyzUmarkr5dGRj91mEmAoksXf3jiWkjCa74/FbC3VPuibI9Jzw7Rht4M3Q94iw
         MrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707909; x=1782312709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qkRBbhHB4iuN7xSPIITChDuTjwYpXvbOBnslFsQsEpc=;
        b=hgpn84EhoMtA61hi3elacW4f7b1wherTZnQQWqmb5Kiu1q+pLSVnWhhWT8psoo5K8I
         IASG3NL80bQDl6CrTuaSlYfSQ1Dak0Iv21iORhe06DQZn7OuEW1Z2NNA1TLOXIwKvZ9S
         5bf+ZCT7vOM2LEFp43ObEa72CGNNijXqvxQD/uPDUce3w20KL2yN4pX3QGcg8cV95A7h
         BliGod6LTc9TvL70VGqHr4/oNYloNjQKeq5BGDNAo47WImIMxgeS4b47CCvV+fN410nk
         vcDrdf+jbK3uIr6jBqHcJGJMr4DqREs2Gz6Kv4YEHSTmTAEL1P6yi6cFhdBSgU3HlnVA
         n+cg==
X-Forwarded-Encrypted: i=1; AFNElJ8BX505Wp5K56HX4bh2YJ/510cjMNZ3jaMhF4AMT11QaNJ5V+QBPPXbx3c0HcnWWZT8at/X7oU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQbpHLqyCveJ8H4LMGoXjHZ3O4Xw5hX4s4w+JXpuBAtaP/2Rri
	nmb6dQyODSRMvCUemRw3sRORSfXxrUgiSdVl3rFM0YKUZDWDAhtXnM06olKiud8ChNluxmw6j6U
	xSV9D93erg6WL634Nz8ZVQ1OLmL9U1g==
X-Received: from wmbc22.prod.google.com ([2002:a7b:c016:0:b0:491:41a:40d4])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:37ce:b0:490:bd66:e526 with SMTP id 5b1f17b1804b1-49236791faemr29047845e9.32.1781707908701;
 Wed, 17 Jun 2026 07:51:48 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:51:28 +0000
In-Reply-To: <20260617145130.3729015-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260617145130.3729015-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617145130.3729015-6-sebastianene@google.com>
Subject: [PATCH v7 5/7] KVM: arm64: Validate the offset to the mem access descriptor
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
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 2d211661952e..1a2abd0154c6 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -476,11 +476,14 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	DECLARE_REG(u32, fraglen, ctxt, 2);
 	DECLARE_REG(u64, addr_mbz, ctxt, 3);
 	DECLARE_REG(u32, npages_mbz, ctxt, 4);
+	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
-	u32 offset, nr_ranges, checked_offset;
 	int ret = 0;
+	size_t mem_region_len = !FFA_MEM_REGION_HAS_EP_MEM_OFFSET(hyp_ffa_version) ?
+		offsetof(struct ffa_mem_region, ep_mem_offset) :
+		sizeof(struct ffa_mem_region);
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
@@ -488,8 +491,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 		goto out;
 	}
 
-	if (fraglen < sizeof(struct ffa_mem_region) +
-		      sizeof(struct ffa_mem_region_attributes)) {
+	if (fraglen < mem_region_len + ffa_emad_size_get(hyp_ffa_version)) {
 		ret = FFA_RET_INVALID_PARAMETERS;
 		goto out;
 	}
@@ -508,8 +510,13 @@ static void __do_ffa_mem_xfer(const u64 func_id,
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
@@ -574,9 +581,9 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
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
@@ -599,8 +606,14 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
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
-- 
2.54.0.1136.gdb2ca164c4-goog

