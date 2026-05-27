Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E058401A25
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779894173; cv=none; b=Kufmg4zxzb+mpKtSfWuCkMvccGfgOQrB/OZ+2WvlkZigOXcQlyHL7pgeb1stfIZ41DKAmN9VZ5GEQ2N4dDKGtMJIf6kobCVAVMI9FblMvIloeM/TewYjSR8HwXd7K0xO1N/GS9QL5d8eKITpC6engvKFcxbhlxntQUBy1by4VFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779894173; c=relaxed/simple;
	bh=t39kgrMOHIHzsvf+eHb06eEnxgvz7gZgtivjOJ2TDw0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sUVykKKtA2/u2/kAJKJ/VGEX9uDKfTwMEoT6xz6F8ehCPQEi8/5tLMBTHhiP9MRYOtKIcTyUEJhdSMUugZhGmvYM9MX21B24li+VY2DRbsAhF85WaSZgj1ibpqOIfFepO4mrTN2UeFgqLswd3uw4yL1lNI/ShepQJu/DB3mcS0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lIG/sQhO; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lIG/sQhO"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49045243094so76155935e9.2
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779894167; x=1780498967; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BckYBENK6hhz+ff2bUCfdnEivIY8LabEaYEeFq/XAWw=;
        b=lIG/sQhO0ToZAK8IyXa+3iM0UkOGBIslvi9ay3cKp849DaYANucxjpvsnkM7muDHFV
         jPaPfT+5uhM17s7OK3nUI+YILc6oLC+dKetZrxMo9bRIWcxl6sjpCXYNHIunM3PR3zWr
         0TFX5eIj6QJF4llcv5U6KRklEgOcPQmog6uICxtiJgi3xaOPqc4FD+TmH7tJkPrKH3um
         3UlJgJql4bHpMMYV9FyPkxx9K6a8DI629uI2ta4B8Q8lUQiFVq4m37eb9g92jxTWLCgU
         FRYAIqARjaQpUQHuZnliopoi0yHxau+4Mf9U1rocSw32JRKxqjahPnskRSTLRty8XgB6
         oeeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779894167; x=1780498967;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BckYBENK6hhz+ff2bUCfdnEivIY8LabEaYEeFq/XAWw=;
        b=MXfFAE3oMQoPrdZOJEPppr7unMy/qyx0pN6C98DSrFcUVbOJVMZu/avSG5vZot7Alc
         tddvn/rpc8xXQzBWQE0ffiS2HhjsLWWPJMUUw3tbZwvG0yPKmXQpyMJ+YUWAa9Tmw0yG
         oqjiMLvuaeC5itRJzOklaPmXnIoY7HxvF1kR6nLsLr2/M+ZtQGW+t9lu2iH8hwk7L5kF
         qjiz8k5jgD6Y/vNkHDEw/PU7bE7Z+utBRrMx/qIOra8sNjob5ZmihY/HFn0zkeu8Z9h3
         54619auvXKkzIJFVp8vUcxkZpF8GD9W3xXM6nONQkve54m2ZiKw5QFPqplLINDDk+XTp
         Bexw==
X-Forwarded-Encrypted: i=1; AFNElJ+J+p+jlVQhjjOABCIjyjWlc6wejcyUCl3QK21ZAm9Sl7a9sG6Wucon7k6/xGSfqP3yRDQLoPM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzatQ6gyGLaDBx3+9f5ubAXhLnWz2yEEN6V9AnyaC5Rl2SB9D8J
	UMa2gjKiqvEa0xoyw0HtdeSmU0kdNDxlyqrLcumhz8ItF7mKom94R7Xocm1gZVojjRBqqGhBpvX
	dFBxr8Z86kTmbQA==
X-Received: from wrjb1.prod.google.com ([2002:adf:e301:0:b0:44c:f833:f80e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:e011:0:20b0:43f:e9ee:5610 with SMTP id ffacd0b85a97d-45eb38b0408mr28581235f8f.43.1779894166481;
 Wed, 27 May 2026 08:02:46 -0700 (PDT)
Date: Wed, 27 May 2026 15:02:35 +0000
In-Reply-To: <20260527150236.1978655-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260527150236.1978655-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260527150236.1978655-6-smostafa@google.com>
Subject: [PATCH v6 5/6] KVM: arm64: Validate the offset to the mem access descriptor
From: Mostafa Saleh <smostafa@google.com>
To: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, jens.wiklander@linaro.org, 
	sumit.garg@kernel.org, sebastianene@google.com, vdonnefort@google.com, 
	sudeep.holla@kernel.org, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Sebastian Ene <sebastianene@google.com>

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

[@Mostafa, Add missing call to ffa_rx_release() and use fraglen
 as the max buffer size as it is the only intialised part]

Fixes: 42fb33dde42b ("KVM: arm64: Use FF-A 1.1 with pKVM")
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index b6cf9ad82e12..a12e01883314 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -476,10 +476,10 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	DECLARE_REG(u32, fraglen, ctxt, 2);
 	DECLARE_REG(u64, addr_mbz, ctxt, 3);
 	DECLARE_REG(u32, npages_mbz, ctxt, 4);
+	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
-	u32 offset, nr_ranges, checked_offset;
 	int ret = 0;
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
@@ -489,7 +489,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	}
 
 	if (fraglen < sizeof(struct ffa_mem_region) +
-		      sizeof(struct ffa_mem_region_attributes)) {
+		      ffa_emad_size_get(hyp_ffa_version)) {
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
-- 
2.54.0.746.g67dd491aae-goog

