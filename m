Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0D8399CF8
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 12:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589894; cv=none; b=gCKf++dn8Ge9Fpazv/LPm/1H5PARjP6sdpo+RLyFqA8X045XQ/W7rOHFivf+4aJCf/UL8Q2xCwDo6wAvhLO8p2XGHzkWi5LUiHjtgUMNvL8qCQmrcDtBWLeY2q+a0RqASU5skVkIFei+OMZbl4nz6nAyxExtqgkwGqmJ2Gv5IC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589894; c=relaxed/simple;
	bh=bKVcDqwHwK/xbpDT9Uz7ToiCHD6FOj4O/mRSqjJ7G0Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kZc/X1ELIaEbwx7Gb0if8iSBDWskYTEM3S8u40e/7W0p1Y53PfISfNeYe3+kkUW6DxrIw+Dmzon8IbJLO2Ta+xYIPB1vmbYFURkyUdtZb0UPfM36EWwagJFJVIjhpu8CHnqWbd84w5hbQ8PjZQihlvTZg//XuCXYO9vyNnj6JW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ixjeuUma; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ixjeuUma"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48e6af7a9cdso27629925e9.3
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 05:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778589886; x=1779194686; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NTRlEigdkhn6bOKBOZmqHGKnjSXcZHjG0+RY5EH/5oA=;
        b=ixjeuUmauCEabNWKoBqMEadDqjMJor4v+O45L50XR2heFGYWW3Yj4IZEmRkUiFrZpQ
         gC66JzSx2wzB4CLOW0MJboVeYrSjSJ84dTsSSN78x3FIryISBElpgUB1W9K6VqrmDWdR
         MzfNrYQtehUNlpTtsbTx22JpVOyeTJQt3NeDw90LMnPb9sUP2g8qWqNBOVyQ99ny/Mdf
         zLBzJzTdOLt100rCL22ZzxnBMpc6qnaIACfiPXkMBBv/+/zjj8kPMMqfdHkkzV9U421b
         gqlpzJd2qF2j7D2Ppo0xI/YKWUDSZ0N4HQSuII2Lm1RY69mB6zaGSwMzpxAG+Bp7MP5M
         FGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778589886; x=1779194686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NTRlEigdkhn6bOKBOZmqHGKnjSXcZHjG0+RY5EH/5oA=;
        b=NZPDnPGWJyS9m87VoJXHg1QX3uceZAb4hCVtoIUOQETciXyLBgrg9BtCEtEwYdf37A
         10wB2ndMx4AovCKMyj19RsrY9f900e9xeWyG7lUDNvXAnGiICmupg+Q4ronPfcyusvxk
         rg4Zn+n3TPeY8bKJFyUsdMKPCyEOVi6Bc+yL+ZCk+avhlLUiL6r8q11osQclwnkNxqcV
         dNoeeZsqseKYQ3u0GGxB3bSKmjwVGbLCfW9QrPRMGU9s4j39EceiGVxt4q5RTs4TEhuF
         XRfEA+BBRGtm2vp5wupwn5kkwCUMmY/hcD4gmJ6l6BR7barDoMVLT3IUW3GeMfz9PGCL
         23iQ==
X-Forwarded-Encrypted: i=1; AFNElJ+/aEkcwF2UhbZa1RYHIzBkprFtmjp4zyE1UVUhRyCaH8pUxsOZErkqSFx8HnwZ0u+142Ke5So=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyIUEW35WfV1BKzs1zMIfPm3HDPQ44UWIeuCw5DOJH9NM338U+
	8vY5D6LWwO/XaZV2KtwAvxckgyvPKA56hwBw/eHS7Gv+1i4TaKcvp/GFtrB2ygC9Drv+J+J801R
	Ov5y2FB/TsAuQcG6TUx5D3dic5oFuyQ==
X-Received: from wrpy15.prod.google.com ([2002:adf:f6cf:0:b0:43d:7331:91dd])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6211:b0:48a:5301:bb5c with SMTP id 5b1f17b1804b1-48e8fe72215mr45081965e9.16.1778589886397;
 Tue, 12 May 2026 05:44:46 -0700 (PDT)
Date: Tue, 12 May 2026 12:44:42 +0000
In-Reply-To: <20260512124442.1899107-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260512124442.1899107-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512124442.1899107-3-sebastianene@google.com>
Subject: [PATCH v3 2/2] KVM: arm64: Validate the offset to the mem access descriptor
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	sudeep.holla@kernel.org, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
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

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..34927bc1239b 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -479,7 +479,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
-	u32 offset, nr_ranges, checked_offset;
+	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
 	int ret = 0;
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
@@ -508,8 +508,14 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
-	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	if (em_mem_access_off >
+	    KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE - sizeof(struct ffa_mem_region_attributes)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	ep_mem_access = (void *)buf + em_mem_access_off;
 	offset = ep_mem_access->composite_off;
 	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -576,7 +582,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, flags, ctxt, 3);
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
-	u32 offset, len, fraglen, fragoff;
+	u32 offset, len, fraglen, fragoff, em_mem_access_off;
 	struct ffa_mem_region *buf;
 	int ret = 0;
 	u64 handle;
@@ -599,8 +605,14 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	len = res->a1;
 	fraglen = res->a2;
 
-	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	if (em_mem_access_off >
+	    KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE - sizeof(struct ffa_mem_region_attributes)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	ep_mem_access = (void *)buf + em_mem_access_off;
 	offset = ep_mem_access->composite_off;
 	/*
 	 * We can trust the SPMD to get this right, but let's at least
-- 
2.54.0.563.g4f69b47b94-goog

