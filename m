Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A665B3A1A21
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 10:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988743; cv=none; b=AT6a8/KUWaiwWka8uDVuZNTEd6kjQLVWjtLLpyFyzXSoAFu9/cACfnwB13xISKQGyS/i3Z9w+ItU8TPeKxTotHQXMIL5TW6QkptMqYvRgDPaUp3Huod3o0yphKm3/VSAMLFbzQvc8WpqN6EqDZM+JHxX26C2FiZ4YTih0QHPUIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988743; c=relaxed/simple;
	bh=cqpqWComKRWiCpCFlRr5CCe1UaqVwupCKxUEyOVLkh0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HGOl5EY2bLapfwzmjnRrF+0Efo7OPxSk00v4nrZaBlAoYhi0wteaJqOcQXYOoBB69S4hFGPey0B67LL3OwnSK3tInWjeolMJTYcyzhEW/4eSiZY9Hp25AwNhNPEjQSqJHSBgNndzRKRh4U5U8f0Iqtcl4ptu9j5vgUSUBxTTuYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ut+MCRzZ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ut+MCRzZ"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493c55d5ce5so3477905e9.0
        for <kvmarm@lists.linux.dev>; Thu, 02 Jul 2026 03:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782988740; x=1783593540; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3srY3du6pUShZyOw/nlifUO0efjUMM7goX5s1Ul3bUU=;
        b=ut+MCRzZIJfZkuJZVQrsH/QfoXLASdKWDiXPLZ/KqzQ8IT+IKZ1FnScLOePtRrJKi+
         XdPeYai2Lzfk5ruHc0xln/pHaJc9/Z8oIkt9utlZF6Rg8d5qcxGPtWGKrI1JYTzCAlLN
         72NGvHDctUu7yk+0a+SK2a9bGc2vMcYj9OS36JDvggnyqlobzj/Y1/vyiPfkG4uk21hH
         B1gI/aTPZbh+k0daSdgyYEyc4aU5A+PSkyfnZ2LrelGu4NcqbOUbcSn4uZi4pm1jZwu1
         j54eEugTfZKN5dadF+mNJXhBk6FiFGXvt+Br/Bfc81VIKZVEqejmY0ldhOl8OFYixUo8
         14Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782988740; x=1783593540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3srY3du6pUShZyOw/nlifUO0efjUMM7goX5s1Ul3bUU=;
        b=DCPbNL8qCMY9CoGMaqqzgtfNkTCobJ5A0hPEm8O9JyQCpKSiAJwKVxMHIlPKKCndlM
         Bfqfu0gw7NIRtwMIY0c/FsGndmOyX1EgDemERnrjs04jZD6+afvgJ8Q6Do1zb+vckTqU
         Hral+oEImI8UiAncbfjd9jtFsvB8oFkjEhdPscR1GbuKWsp5nvFQ5efTUs8Ru9TpjCib
         Tr8HB0woTu2/1dN8fMcnE2/mArddj5X3RWVXwhlg1F38I54viAEhB2M4HCp+bGh/pssp
         x+Ym94pnbE5WqqTKfKDhcCg3jz4IfKYRqXLTwaNhPmatlJrW4D4+2BbhYLEcKNUOhn19
         Gkdg==
X-Forwarded-Encrypted: i=1; AFNElJ+Te85t4Y2BVejrC4MkEiYUkmj1tXTcDOe5wUoQSQaK5gfuZvJVbiEJff3zgL4TnniffNiye2k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKXfoLNIAUrzEB7FBEpvf3Wpjcc/QmTZILPDRQWm36K0tEGBLj
	8bDXGR32c0EWXBx9d3Oco+NuVKptURTzRNimN3b61jEOZH1aycNncuugrTCqF/wusB6NQP5+DRa
	klLgpMYY21dcLohXSt14/712LsEA/UA==
X-Received: from wmpf36.prod.google.com ([2002:a05:600c:4924:b0:493:b275:289d])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6087:b0:492:1eed:3e67 with SMTP id 5b1f17b1804b1-493c2b96d7emr80737895e9.26.1782988739807;
 Thu, 02 Jul 2026 03:38:59 -0700 (PDT)
Date: Thu,  2 Jul 2026 10:38:38 +0000
In-Reply-To: <20260702103848.1647249-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702103848.1647249-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260702103848.1647249-2-sebastianene@google.com>
Subject: [PATCH v9 1/6] firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
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

From: Mostafa Saleh <smostafa@google.com>

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
Fixes: 111a833dc5cb ("firmware: arm_ffa: Set reserved/MBZ fields to zero in the memory descriptors")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 drivers/firmware/arm_ffa/driver.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 0f468362c288..01301213896a 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -725,11 +725,10 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
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
@@ -769,7 +768,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 			constituents = buffer;
 		}
 
-		if ((void *)constituents - buffer > max_fragsize) {
+		if ((void *)constituents + sizeof(*constituents) - buffer > max_fragsize) {
 			pr_err("Memory Region Fragment > Tx Buffer size\n");
 			return -EFAULT;
 		}
@@ -778,7 +777,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		constituents->pg_cnt = args->sg->length / FFA_PAGE_SIZE;
 		constituents->reserved = 0;
 		constituents++;
-		frag_len += sizeof(struct ffa_mem_region_addr_range);
+		frag_len += sizeof(*constituents);
 	} while ((args->sg = sg_next(args->sg)));
 
 	return ffa_transmit_fragment(func_id, addr, buf_sz, frag_len,
-- 
2.55.0.rc0.799.gd6f94ed593-goog

