Received: from mail-lj1-f202.google.com (mail-lj1-f202.google.com [209.85.208.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6293E9C06
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 10:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814886; cv=none; b=VTUnXxOzz+ldS9fcKsYn7233agotb7N84IjN551i7NjH837QKh2aPfF+OlpXKW19eQ/ksZljS2f4HwsRZGxuIfxxH5/Bg6gy9CHrTnA/gUP32VPKUNrwJ5ao3J+kkOQQw8ULR2agwjVBone292hPOZfXgRFccOWzQTC1keYzag8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814886; c=relaxed/simple;
	bh=9TOnq1jD0pgHaO1v5HJoXAFTZmNdtts5+PujmRUbv1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i8yWPNydb/JnJr3DHcSTOhbSUU23l7BzDlTPKxrurxLJNkV0yS4SDEPkezrq9l20lfkUiP9ryXLqMqIVEbw47reDwULDEgR0XYcypMg01fc48BCInZzyQD9oAzNSuo6L0m+MiV5cZEVsF9fzh1zBAvfi8YE3rrvRLX3yz+Jc/ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OJvvfwo+; arc=none smtp.client-ip=209.85.208.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OJvvfwo+"
Received: by mail-lj1-f202.google.com with SMTP id 38308e7fff4ca-39adcede08cso16790831fa.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 03:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782814883; x=1783419683; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kMc7IH1jEIo7aTQO6+OKWeTUOGgdg0YUEMVyYCucVMQ=;
        b=OJvvfwo+Hl6Hqk9WWmTWDbujSAZtV93rrjjH5TVaIZ8l3VPuEfe70wzJBWFqp3Oq7O
         tdo29XEshJ6NJjftyfcydhPq6rNIU4NsI/O7uxOWpO3HpyebKr25+C0Pb0dWj2o1MI45
         CzqLZbOcgO7Kk7O5i2Rw7pWWSPJWD4w4qen/nGesdmYoOEYcWlEbOHrm1VQEPCUGmw3u
         uSPoLZI/cr1RyLGGqvtrESpqdiiJIBZScyRibq0cBhysLz6WskXUrvURa/atdj66uuzS
         vsJz0hU2DY4JjVkBSKaPAzOMYXNmdbiXgrpOl4eBbxoGLe5wGnMeI+DOwc3Pp6Rf1VGZ
         XQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782814883; x=1783419683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kMc7IH1jEIo7aTQO6+OKWeTUOGgdg0YUEMVyYCucVMQ=;
        b=qcksYrlDwLAC+/lPBjfrKWwwqujcnrgQfeUXROwtNYpL9JLLVo+Erf1rqMZG+GbTDo
         UppHnqLccXpD1Oj6ajHJcdV5HvI2+7kdlRcmCdqPTsZyA0L76FNU682xRXpr3coDzIi8
         Vsur3l7PqrrBS0BzASc/sPgz0cy8RnfPGNUzS3SK2P4UpPouOpQSM8ADVM/vUp5llSjA
         7gwv429hm+UlK70rwhr348kpiBunajgD52edAowIUkT07XLaMiZPvzfVJqUk6JzDozYI
         yS3f4t+UihBvaEWO8TL8gE2puE9+NwV7PvL/0HmzrK5tXHOovi2B5H3Bi6/eYbEKuSfV
         dWWg==
X-Forwarded-Encrypted: i=1; AHgh+RqC3wdZm/QX9NW+EfBhjGLY3xqTlexnnKHLZvAPgWgQig1tHB5HQx8fOlN1LPFQ11mpwZKfEuQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YylwMNq9jxYkcf94nfo+O9icuvMto9HnPN+hFVSwtvLsF43sT52
	QdSQWG4mJJAjqd5K/1ioNp17fcxG+39ZPgZMZ7psNdZ/Umu+oo5iH541TLk/4APLJw2Oy/DZ570
	B0j5B419XYnR2N0dG6QBxQtZepZj4yA==
X-Received: from ljvg16-n1.prod.google.com ([2002:a05:651c:2550:10b0:39b:23be:9b9d])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:651c:1603:b0:39b:f64:1af3 with SMTP id 38308e7fff4ca-39b28d2233fmr386661fa.8.1782814882959;
 Tue, 30 Jun 2026 03:21:22 -0700 (PDT)
Date: Tue, 30 Jun 2026 10:20:55 +0000
In-Reply-To: <20260630102058.3219867-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260630102058.3219867-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260630102058.3219867-4-sebastianene@google.com>
Subject: [PATCH v8 2/6] firmware: arm_ffa: Fix Endpoint Memory Access
 Descriptor offset calculation
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

Use the descriptor's `ep_mem_offset` to calculate the start of the endpoint
memory access array and to comply with the FF-A spec instead of defaulting
to `sizeof(struct ffa_mem_region)`.
This requires moving `ffa_mem_region_additional_setup()` earlier in the setup
flow.
Also, add sanity checks to ensure the calculated descriptor offsets do not
exceed `max_fragsize`.

Fixes: 113580530ee7 ("firmware: arm_ffa: Update memory descriptor to support v1.1 format")
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 drivers/firmware/arm_ffa/driver.c | 20 +++++++++++++++-----
 include/linux/arm_ffa.h           |  2 +-
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 01301213896a..7c1b747797b4 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -713,19 +713,30 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 	struct ffa_composite_mem_region *composite;
 	struct ffa_mem_region_addr_range *constituents;
 	struct ffa_mem_region_attributes *ep_mem_access;
-	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg);
+	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg), ep_offset;
+	u32 emad_end, emad_size = ffa_emad_size_get(drv_info->version);
 
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
+		if (check_add_overflow(ep_offset, emad_size, &emad_end))
+			return -ENXIO;
+
+		if (emad_end > max_fragsize)
+			return -ENXIO;
+
+		ep_mem_access = buffer + ep_offset;
+		memset(ep_mem_access, 0, emad_size);
 		ep_mem_access->receiver = args->attrs[idx].receiver;
 		ep_mem_access->attrs = args->attrs[idx].attrs;
 		ep_mem_access->composite_off = composite_offset;
@@ -735,7 +746,6 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 	}
 	mem_region->handle = 0;
 	mem_region->ep_count = args->nattrs;
-	ffa_mem_region_additional_setup(drv_info->version, mem_region);
 
 	composite = buffer + composite_offset;
 	composite->total_pg_cnt = ffa_get_num_pages_sg(args->sg);
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 17eca3dfc59e..033c630b271b 100644
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
2.55.0.rc0.799.gd6f94ed593-goog

