Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCF6428475
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779894166; cv=none; b=tJaqrtB75ic+3h96G2e0zKQL/Z7bzjazF9JdKFWdFpgK3sLqWtPkaCh1YtIVOc7y3qqZ4OTlyQz6/ZSGkdAVXpYkOgsd7RpcNT/+FXuKjVGn30dFPwCWhtX7/OWGDKrSZZzPMa+0IWuW24/FrQtwiw9MWSnkf6YmX8Tfd5YpJus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779894166; c=relaxed/simple;
	bh=nVHQfEBe5Y36t7KgHNwVV7teEKw/67gXK02IHth2zZI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B2VSZMMwNMQ0VEKObf+lKuYM2aEZlKBKoFu+joC8KlBuLOZc9dOYJ178XOjYgUx20l6atDAy183JfEmaInE0vy+uhByVNIwF5kQnhj+tSYqZ069ytk4J4vIhGAApdJ812icZk1sRWU5cnra7qQpiljfPRg/gTsAEwt3G7hXsi6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=brSXLPNa; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="brSXLPNa"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso8087035f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779894162; x=1780498962; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4uj7BV8+9rgP0MrIxwz4V0ep9E/T0g3B6x2bWAPAPVY=;
        b=brSXLPNaOvkk1gV9FCdQ2wyyHrMeqcFS4hZd+WuBy0oKrOpYd+r1DVKAmP9JjTJi9P
         zSJ5tlWTtdj9+k+NRX/jlvSE+lw8YUIirXrRZnsInmpg6t6LtRNCnDy4zu8kAOTpBWik
         4l9W6vZqAQlJXJkIorq08Rl0ARC1FR0hm3KqQoWtH0MSOxKI6HHi3xZLmIX0TZQFR71a
         a1QnY+4KOOEVzVgBNlTydmNDe/Uv4ayOHZAsAELmwNy6LzCHtZor6M/RyKJGlmFeDeYF
         E1ZwXFa6X/+xcegYwaxYWY9huAhP3IJ5QaoJtCGywDfvKHg4/21OIqnSoRQ67K5THt55
         5btg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779894162; x=1780498962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4uj7BV8+9rgP0MrIxwz4V0ep9E/T0g3B6x2bWAPAPVY=;
        b=X8vyOHRYJpNtfMsONGWyemO9urPmGrzDZ86NuEIBY/C36w5dvSX+40zII7806/NNwc
         Paw0N8SwwBON9EdMgT5CTtTrqbBBBoKONLDoUkGfvgd29LNGvFz85LoftSTpKNt5jed4
         JPirPh55fERmtl7wWTlgaLsMTUk4E2gJKZ/DqcblUOQAZeYj1adSL0QG2EaXe7ar6GRd
         GmVrr1XnPZUvu0h826432Vxzm85kphdjAZcFyqe7Cet8654b/RcMtoeJKKjlaDH/1ft1
         ZQfG08Hr9089j3UW+C6RCdj9+VB6KFhAuwNInoXHYDmBbq6mV2VC7wm+iqfGSVSrpHfR
         fdOQ==
X-Forwarded-Encrypted: i=1; AFNElJ/TJbVwbNFqymyFCZn9/LdhK/BzibPCEulNxPkhSdIDFeXMb7hIQh88SbR+wEsbaA6RuwO/i7U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUy20mLVgBnhDgWsUw1ztl3GWO3n9DWIUi9KDdCjifiaumdtxo
	xp7jyj86GnByuzqFIyjuU5bNBX4bs0ZtFN4uHmwhiX7Uewl2r+kNgbTupfO2E0rVUBK8TVoBj7g
	kCeDVOr2djiP31g==
X-Received: from wmmu10.prod.google.com ([2002:a05:600c:ca:b0:490:5e18:ff1c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8499:20b0:48a:5970:1fe1 with SMTP id 5b1f17b1804b1-4904248ad4cmr298003375e9.4.1779894162134;
 Wed, 27 May 2026 08:02:42 -0700 (PDT)
Date: Wed, 27 May 2026 15:02:32 +0000
In-Reply-To: <20260527150236.1978655-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260527150236.1978655-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260527150236.1978655-3-smostafa@google.com>
Subject: [PATCH v6 2/6] firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
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
Fixes: 111a833dc5cb ("firmware: arm_ffa: Set reserved/MBZ fields to zero in the memory descriptors")
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

