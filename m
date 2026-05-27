Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9F93C9ED8
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779894168; cv=none; b=fiZnm8OmODSx9ZDPdfQ+9hS6v45clTRqznaR+VPhjFMLUCqOJ1CgjHnlrcPS1tUjE0lD6GLtLdehASgh2wAn4qCffcyTosCfLVajPd+5M5tKolWtR++5xr8uM1JPGN0WU1nPUYOhQqJsL80aDeKNzUv9NbEAIWaa0iE7kWDdO40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779894168; c=relaxed/simple;
	bh=frvPG4wGt4lYWaI0hU8auAfAfo8N17uXOLvBwGNEh+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rl6MMckT7idpv4rbyNDNG1ouqHmI2iUvvKb+7i5tLgESwK//wxzoP8zvzAw5FyFho44kWF0Qx+3cWwjCdAfs6Shy5JrDoVAdyN2txA8bnApCS/xxW0PjC/owR1eAl5jY7Uwdv+ACCnk+yDChaamJUxp8GweqgQkpgYcSxQ/pWd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H7m6nBvK; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H7m6nBvK"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fd396daedso65385945e9.0
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779894164; x=1780498964; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u8YigvBWVl26/ICnVgR3tTUB4GzAA0/sj9E2gFe9QwE=;
        b=H7m6nBvK0m3qOG3JTsyzG49VIomf3Ak1yKT4/TsOYA04EgcJmVli/YWmA99aMAaaGq
         fysba6K062W664iEc5sBj+sYqPNm2AKCWOxrBZQPtcrVkBQoPwNMuGztLDJj5xDVosPn
         Es+2u0B+4H/GzmUCDGaNR1WcQdLiQ9j8uCjcGoH6W6I+EXy6+WRlQD5IsjNKdGsf1PgK
         XV8+OYWu7Q5LeqMH1Ss22GRctdjXAno0fx2yOn+8K4Zt+dyV1oVV+I1sOKwxIiB23Fte
         HlCbmNx0n8kNRQyIxe4MEE9VleGxXrJw4whsXecOJzNIc/RYtZH0Krhe9O045KC9mF9k
         1yug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779894164; x=1780498964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u8YigvBWVl26/ICnVgR3tTUB4GzAA0/sj9E2gFe9QwE=;
        b=ElMvidQGRzfJZkV3NSWoZwEBzIyTmY1TYJJ+rHs3kEtYJqdjZUwKQvM0bVb4lhS0T7
         ssR4P+/KDS/dpBdqF9kWNsoi2lyDOxDvVR0lmvS8QmKCktekUAWr/uKhUuyKCO7vSeYm
         GJbbHn4p/S++Zg7Zg4ep4jSXjLBgrw1NaSatogZilYeLBjRLsdTt5LNrKoUT6K+pbyCM
         69d9UctulPbTuhwYm8XAhuGqY0z6rouCCZjBJ6xaTTRiDRGJGsE7rrGb91vQT06qqNBx
         7PZ2UfFIwBvmFN1Dab2zJJGBGiysVOmBF4D/ba1w3v4F8ES2JsM5zAqni3VThO/XXsAb
         RsLw==
X-Forwarded-Encrypted: i=1; AFNElJ++ptXrh24pH9qMwTuYWvVQxKoG+6pSpgySd1neb8UabObZhzwGxF4mKfllNmaSi51Ol1+eMKE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWJQbz+tNVS8Y2FQAsnd88+vfmuzpys4zwLsPhNoy9WeNviq9H
	Cn4ev9goIXkko1kuUZMhrjrTYhYbYseOI3MO9reSyP5rGbY3AxpEhR/3BB/Y81eS3vQT3ygh6Hg
	8V1VHmvg1tZso/A==
X-Received: from wrnc9.prod.google.com ([2002:adf:e749:0:b0:43c:fa78:503f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e0c:b0:488:ac01:72de with SMTP id 5b1f17b1804b1-49042489c30mr450538145e9.5.1779894163610;
 Wed, 27 May 2026 08:02:43 -0700 (PDT)
Date: Wed, 27 May 2026 15:02:33 +0000
In-Reply-To: <20260527150236.1978655-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260527150236.1978655-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260527150236.1978655-4-smostafa@google.com>
Subject: [PATCH v6 3/6] firmware: arm_ffa: Fix Endpoint Memory Access
 Descriptor offset calculation
From: Mostafa Saleh <smostafa@google.com>
To: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, jens.wiklander@linaro.org, 
	sumit.garg@kernel.org, sebastianene@google.com, vdonnefort@google.com, 
	sudeep.holla@kernel.org, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Sebastian Ene <sebastianene@google.com>

Use the descriptor's `ep_mem_offset` to calculate the start of the endpoint
memory access array and to comply with the FF-A spec instead of defaulting
to `sizeof(struct ffa_mem_region)`.
This requires moving `ffa_mem_region_additional_setup()` earlier in the setup
flow.
Also, add sanity checks to ensure the calculated descriptor offsets do not
exceed `max_fragsize`.
[@Mostafa Harden error checking]

Fixes: 113580530ee7 ("firmware: arm_ffa: Update memory descriptor to support v1.1 format")
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/firmware/arm_ffa/driver.c | 16 +++++++++++-----
 include/linux/arm_ffa.h           |  2 +-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 059e2aae7ca0..bed4bd48963f 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -703,19 +703,26 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 	struct ffa_composite_mem_region *composite;
 	struct ffa_mem_region_addr_range *constituents;
 	struct ffa_mem_region_attributes *ep_mem_access;
-	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg);
+	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg), ep_offset;
+	u32 emad_size = ffa_emad_size_get(drv_info->version);
 
 	mem_region->tag = args->tag;
 	mem_region->flags = args->flags;
 	mem_region->sender_id = drv_info->vm_id;
 	mem_region->attributes = ffa_memory_attributes_get(func_id);
+
+	ffa_mem_region_additional_setup(drv_info->version, mem_region);
 	composite_offset = ffa_mem_desc_offset(buffer, args->nattrs,
 					       drv_info->version);
+	if (composite_offset + sizeof(*composite) > max_fragsize)
+		return -ENXIO;
 
 	for (idx = 0; idx < args->nattrs; idx++) {
-		ep_mem_access = buffer +
-			ffa_mem_desc_offset(buffer, idx, drv_info->version);
-		memset(ep_mem_access, 0, ffa_emad_size_get(drv_info->version));
+		ep_offset = ffa_mem_desc_offset(buffer, idx, drv_info->version);
+		if (ep_offset + emad_size > max_fragsize)
+			return -ENXIO;
+		ep_mem_access = buffer + ep_offset;
+		memset(ep_mem_access, 0, emad_size);
 		ep_mem_access->receiver = args->attrs[idx].receiver;
 		ep_mem_access->attrs = args->attrs[idx].attrs;
 		ep_mem_access->composite_off = composite_offset;
@@ -725,7 +732,6 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 	}
 	mem_region->handle = 0;
 	mem_region->ep_count = args->nattrs;
-	ffa_mem_region_additional_setup(drv_info->version, mem_region);
 
 	composite = buffer + composite_offset;
 	composite->total_pg_cnt = ffa_get_num_pages_sg(args->sg);
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 81e603839c4a..62d67dae8b70 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -445,7 +445,7 @@ ffa_mem_desc_offset(struct ffa_mem_region *buf, int count, u32 ffa_version)
 	if (!FFA_MEM_REGION_HAS_EP_MEM_OFFSET(ffa_version))
 		offset += offsetof(struct ffa_mem_region, ep_mem_offset);
 	else
-		offset += sizeof(struct ffa_mem_region);
+		offset += buf->ep_mem_offset;
 
 	return offset;
 }
-- 
2.54.0.746.g67dd491aae-goog

