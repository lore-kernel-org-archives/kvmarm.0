Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CEC374169
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 20:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310198; cv=none; b=FmhDZt4v4RkT1rXDWQm3HEGDJPAQHt1LfC3gamFaS0bGn78RE1qL0A30kc2TUpwX7qBgKyCVYdc3Li8IXmf4oCgiXcD9F2UcKVanZqjMZv2/P9eexoKb8Dc/rj5DtrVcLPYlcarDsK7VJJjwsuyyncvCSgJmtg/o93JrJpDOv/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310198; c=relaxed/simple;
	bh=+odcoytO7t3DOoLwKe5U/Z+LXQDQFnA0EDO6/U8yfWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y8KAdgWkEnseBljOJx5pdxqOfKjiBs0SZ4DJ5TJUfLZ0ZuKrAuI4DddjgrUYJ4W7Pgnk2I8fFqmqXYEmrP8JJuqZKPX4b3uNCn+qiEKg5xp61dIAjipgoB4yKxzVcSoibs5wpg/luA86jkubwZNchEL6tb8SLlQoGCZryHgWslg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NbJO/fwt; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NbJO/fwt"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48ff0eb77b5so50554275e9.0
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 13:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779310195; x=1779914995; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ov2SNTUzKC8oN0Fvl8Z8REa9PXSOlA6pzj2Ni/hPKe8=;
        b=NbJO/fwtBPAjeooNCWR8q+AYyz3ONcAoqfasO8lsP1JIccVHQhL+SO0r3oTstCNosT
         tv9dd4H/dGDvA7HV+2ubA8cUcNXGMRBo+tXS44anlamxpJZ9HrCFO3AL/qFbiYqmWtW9
         itJrc5Oc5on3Hwsb+l4E4H1zCL+xKu8jq4XzgOKsHSRqJEFeySKBb260yQusjWZKwWrT
         //7oEBT7vXQZ9rwuzzQ3yJ8KE3ZKkWuTqxpjZh0klzYg1cWi0hv+/mHody/nTdJDjiY9
         dL0CBBnaUzt3X1MMOl3kbYPMtTIzgStcANYgrpZmeqCcQykwry2AqIMCzR8LMB/9dW7/
         X/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310195; x=1779914995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ov2SNTUzKC8oN0Fvl8Z8REa9PXSOlA6pzj2Ni/hPKe8=;
        b=JvuT9RDUahpGg9O3RyNLJiE8Ot4k+0PEr+KOGbigolc9kA3jXRuRBBoTn6cr975vNZ
         hmNILZqObYxv1I8vHC5utleM4Pju0/jBsZi59B8x7YNZScjaI4xkkQTe1BNnkaopF6gJ
         UkPYHvQn7EtOrM8Hc716wf5f+u5okU8iYcDF5H0ikYnOJIXQ/GtYDaOhRoOwR10kUBzA
         zt1BLImCa0HdLLWdEoPMCs6Hwl6O56szTI1WcrM5jJR0QT3G3e8Wmtw2rlqn5qtO5ALr
         JFAjiMKl8pNO8sgMcTg0LBFQSdG/ab3hC6haGkNA7UUhwx3u5jTv0GeGK+BkGD0FHuKf
         lhsA==
X-Forwarded-Encrypted: i=1; AFNElJ//9yfOLKHZBg+yH1xYZ4UhmJ+Rwcv3JkGNcgMhWOVltgn44y3gOFgSUVqT6aqdO5eOoIvlf3Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFG0ssnl/seQP32m5JvR+MIo062mDKu21bD0v2O+Q6k/xbdwNu
	vpUzyO42cHyWLkHiLueM7GcNEPYvkVrqADe0fzHV/nQ8v2dnvUAXo43yxhoEEBj4usTOXetGWHf
	4vJUGA5GwhjfC+w==
X-Received: from wmrc10.prod.google.com ([2002:a05:600c:aca:b0:485:3a2f:2f7e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b75:b0:488:7ff6:1f75 with SMTP id 5b1f17b1804b1-48fe6321cdamr430534835e9.21.1779310195138;
 Wed, 20 May 2026 13:49:55 -0700 (PDT)
Date: Wed, 20 May 2026 20:49:45 +0000
In-Reply-To: <20260520204948.2440882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520204948.2440882-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.669.g59709faab0-goog
Message-ID: <20260520204948.2440882-3-smostafa@google.com>
Subject: [PATCH v4 2/5] firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
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

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/firmware/arm_ffa/driver.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index eb2782848283..b700b2e93e72 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -697,11 +697,10 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
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
@@ -741,7 +740,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 			constituents = buffer;
 		}
 
-		if ((void *)constituents - buffer > max_fragsize) {
+		if ((void *)constituents + sizeof(*constituents) - buffer > max_fragsize) {
 			pr_err("Memory Region Fragment > Tx Buffer size\n");
 			return -EFAULT;
 		}
@@ -750,7 +749,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		constituents->pg_cnt = args->sg->length / FFA_PAGE_SIZE;
 		constituents->reserved = 0;
 		constituents++;
-		frag_len += sizeof(struct ffa_mem_region_addr_range);
+		frag_len += sizeof(*constituents);
 	} while ((args->sg = sg_next(args->sg)));
 
 	return ffa_transmit_fragment(func_id, addr, buf_sz, frag_len,
-- 
2.54.0.669.g59709faab0-goog

