Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1E82F7F02
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808790; cv=none; b=U6m1a6m25gI5aGUh/qvAWz0CExF8IPFiQvn9ktFhTsyOn6fUHewfvzTXTyQ6HS5eafr9HBempNSSnST2lRSJoPNxG8Y01f0PmuUJ/qDyG+7Y6Ln+mPLiODRZfuKb53xB6/+3Qic6FM1Oo4emgNzmjBpBYY0MAncsRvsMPm8KE1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808790; c=relaxed/simple;
	bh=EdC0W0VohOtxX3lnJG6sv4pnvdbySAnfsJeVaWHFx0w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RizYGAYgfzusDn+exDQOCBKREj8NJSMR+ZGf3u2j06tPATd7ySpAzvTXD2+UlDx1q98yzoPUgrWRIz0IICXR8OoaFwRTz8WhczAeLzzsyG/NPd6BiLKV6GPJfyTAyEoFAe+uMbfEBcTZPNZu4PfmHf4DI7RKKCaGkD8zRgPVZpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z8SuWaH4; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z8SuWaH4"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49048bcbeb8so48530705e9.2
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 08:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779808787; x=1780413587; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iM960fEPaAF4GKD2H7L6vb8i4u8uWo0JTw5z3e0opLs=;
        b=Z8SuWaH4qY3kAgyTA48TlhNFCoranmVnF77VY/XHGyBClvnrBKfG2Pnbh8otWR7j5H
         nORoqWlro984ia6rYXXvb7Ra1puZL1vjYTMXEA+g/nZsj/wh4ThPnKE5o/SYCQjZnCIx
         d/2S/S7z5hTPa1I6WiDTVizFQD2OpXwD8fPGOPKZWM7mm0IGHGALQTEH4fu9gAuoxjGj
         JkFJ15yhhjf/kgEiGQP38VG9/6nHjq0E0/ykMqk2T/ItlcLxrnEXdWasFP6pg6R6IwqP
         /RizL9Ad+/9Y8NLOrUUKBbxuLnTeoAv2E5Q6/ybfHRPUliLbeMnDTqWpopTtj0eLPJ+7
         ubeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808787; x=1780413587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iM960fEPaAF4GKD2H7L6vb8i4u8uWo0JTw5z3e0opLs=;
        b=HNBS/3n8zHuLY6WB1MLnCJcfgQoYQbZ3b8djDwJaO1wxSnk4TIUF36jm3Ove6VYyF1
         p3O6fR796MggFFJFaVUQGkk4+4nY3FO2lKM428ww6jd0eJKzMFBbJ8emDtjcNyFQiURx
         6PfXfj1YyFrIHfiXeUYqwr4vkZqzZsIYI0Oa7sABkyRp/oovgOziQGxILah4LHpBMiAe
         Fgo1jSXcaOG2J3xRtCBMFrAwacLLFRwt2Wmo2t9lMeBCFl7IUgR7Pv0Q+36Ev77DTjjz
         HqCMZEwpXhoKd9oxZ/F/WOruIa9m1w66NLCkiZshkKpVEUhOga6zrz5LYsdW1eGItuG4
         DGEw==
X-Forwarded-Encrypted: i=1; AFNElJ8DRjxFpr/fLIqYOOjSI3aVqpeP9bTFH4sIs4jKSVLKhryJhlxhxUURM7ZUhI7hUD2XtK/v2tU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1TAxXiYHtkzXHztfPKdWO6lZb/An7+JX6fNljeb/88yud4BcL
	elkFOYnNfouEQyB2tKc51qD9+z60P4IkUJEcS/XFdvQPzCa9OXT3CKGWTIgjfyWWjZeYvvJzGMX
	VoM6U7oOYDp3e3Q==
X-Received: from wmni10.prod.google.com ([2002:a05:600c:70a:b0:48a:5334:11e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83c8:b0:490:601f:d783 with SMTP id 5b1f17b1804b1-490601fd8f3mr182526495e9.4.1779808787137;
 Tue, 26 May 2026 08:19:47 -0700 (PDT)
Date: Tue, 26 May 2026 15:19:30 +0000
In-Reply-To: <20260526151934.3783707-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260526151934.3783707-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260526151934.3783707-3-smostafa@google.com>
Subject: [PATCH v5 2/6] firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
From: Mostafa Saleh <smostafa@google.com>
To: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, jens.wiklander@linaro.org, 
	sumit.garg@kernel.org, sebastianene@google.com, vdonnefort@google.com, 
	sudeep.holla@kernel.org, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Sashiko (locally) reports multiple out-of-bound issues in
ffa_setup_and_transmit:
1) Writing ep_mem_access->reserved can write out of bounds for FFA
   versions < 1.2 as ffa_emad_size_get() returns 16 bytes in that case
   while reserved has an offset of 24.
   Instead of zeroing fields, memset the struct to zero first based on
   the FFA version.

2) Make sure there is enough size to write constituents.

While at it, convert the only sizeof() in the driver that uses a
type instead of variable.

Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/firmware/arm_ffa/driver.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index b9f17fda7243..059e2aae7ca0 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -715,11 +715,10 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 	for (idx = 0; idx < args->nattrs; idx++) {
 		ep_mem_access = buffer +
 			ffa_mem_desc_offset(buffer, idx, drv_info->version);
+		memset(ep_mem_access, 0, ffa_emad_size_get(drv_info->version));
 		ep_mem_access->receiver = args->attrs[idx].receiver;
 		ep_mem_access->attrs = args->attrs[idx].attrs;
 		ep_mem_access->composite_off = composite_offset;
-		ep_mem_access->flag = 0;
-		ep_mem_access->reserved = 0;
 		ffa_emad_impdef_value_init(drv_info->version,
 					   ep_mem_access->impdef_val,
 					   args->attrs[idx].impdef_val);
@@ -759,7 +758,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 			constituents = buffer;
 		}
 
-		if ((void *)constituents - buffer > max_fragsize) {
+		if ((void *)constituents + sizeof(*constituents) - buffer > max_fragsize) {
 			pr_err("Memory Region Fragment > Tx Buffer size\n");
 			return -EFAULT;
 		}
@@ -768,7 +767,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		constituents->pg_cnt = args->sg->length / FFA_PAGE_SIZE;
 		constituents->reserved = 0;
 		constituents++;
-		frag_len += sizeof(struct ffa_mem_region_addr_range);
+		frag_len += sizeof(*constituents);
 	} while ((args->sg = sg_next(args->sg)));
 
 	return ffa_transmit_fragment(func_id, addr, buf_sz, frag_len,
-- 
2.54.0.746.g67dd491aae-goog

