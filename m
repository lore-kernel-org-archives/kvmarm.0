Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A73045BD41
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707907; cv=none; b=o1ScwzHM4THrV+zGdRVk5lXJqK5JrRRCt3D3ES+IQyI51Klwj1O8M8ljZV2IoOTgdTyzUuibphXpktI/B6shRQm3P/DDiwxkvP74RQ8OGxIKYhN7GI9s/teMZmcfmACKEjbg474FpXTgk6hoi1LSKCNUhYbAVqcGqg6jcWMzvYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707907; c=relaxed/simple;
	bh=aN8Nyn9ckrh0MM/LzHi6OOLo2IpLuaUhgYlQz9xxDvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uQsULQ6uXhcHUMaX5BhXoMmU3VlCE/ceINLeMhOv9mLRHKUzeHSRnm9PVtIUVesOtXD/gU0qSAB8mivkewSFPIZCESVP4rMJpOu0T4gUic6toUdg+DpF/42nKvxTY+VeSHP8wcE/T0MVEI32u8P464qAfvS+ix4JRJytofrWVek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PS4M5iSJ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PS4M5iSJ"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-49221de4ed4so29758145e9.0
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 07:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707905; x=1782312705; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iSPN5hE9gskxSS4lEDSt/fOL7Hb/rZVNl7XMRMHJyec=;
        b=PS4M5iSJGjnefL5VlXhEJEfwIjoV8gubhv7zDRYe4ISA4ooDAlSvQVkaOWhAP2mRND
         FWkf0szltMTk3+IWk0xDxqQyGvn1vYw0OfUmRusufu6gXPS+iSUKBmW9giVAwuaiCWFP
         QKzxsPVVsngIodRCR1biE/atyoQ3mfDzi9MEys1NDrm4qRmbd6CbnyMjI5SQxsXLEIR0
         U1RukvY7P3mO98nSINc8/sdRm5rpcKhAxK4q2sn0Ul4jFipoos0qibQNL5dhC/mArtyj
         kKgyzngiBdUO/PvQowtzHRTvu3DY66WbhS8CebBTO/tUgUd5Uk++CYjkZ0spBhmSeu0M
         DUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707905; x=1782312705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iSPN5hE9gskxSS4lEDSt/fOL7Hb/rZVNl7XMRMHJyec=;
        b=nlfT33/e5gBgeUvs965AUJOLho3oZ7B9tjW31+jn1e1fxunvEv1PLcIx35YpcIEZxT
         pTHtIPKjSGPuY7NLVNaWRMe2IQ+ohS3iOf09QIBzIHLJWWvLq7/5B5SIWbA7Lt0eiXpY
         xWzv2uY6uiiRzTeDB/m3e4l4gdXxRIPxyznDulX0/BOfwOSIJI+xMv0UAQPch9/v1BNi
         jrV6/oinxoLKf21tc9EV7Uc/ZjelIqQQyflQ+RCp2GTxlpszLRGRFv5UdG5K8aISKxu1
         0FsG1XYR3Dkb8/ZwXeRKEtfFYSIawwfKYDq1Vp3iMMsfGxou1L4TFikM/aUzQryO5H2S
         PLdA==
X-Forwarded-Encrypted: i=1; AFNElJ90fkzmuEps8vJc2Cz8XRaJrzzkWbAjdZAq/cGMP4UAgdRnv8M7Goj12NUDSGhupy0fgwgD/VQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxg/cU7G8QrR3o85sUX1sJIjf08ojIKiQCuw4xGes6eqATMZQeF
	+wodqTFueDHLdMysqd/hIURsG40yYZdi1d7Czy2KyihzydOOmDOTeez8f2NNNVTWfsrQGIWEsY2
	hNHSkEtYWxFsdR2/uK7Ctbo1YLzn7GA==
X-Received: from wmbgx24.prod.google.com ([2002:a05:600c:8598:b0:490:b0f1:3417])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f8f:b0:492:3670:85a7 with SMTP id 5b1f17b1804b1-4923677d803mr26521325e9.35.1781707904134;
 Wed, 17 Jun 2026 07:51:44 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:51:26 +0000
In-Reply-To: <20260617145130.3729015-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260617145130.3729015-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617145130.3729015-4-sebastianene@google.com>
Subject: [PATCH v7 3/7] firmware: arm_ffa: Fix Endpoint Memory Access
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
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/firmware/arm_ffa/driver.c | 20 +++++++++++++++-----
 include/linux/arm_ffa.h           |  2 +-
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 059e2aae7ca0..92edf397bcd2 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -703,19 +703,30 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
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
@@ -725,7 +736,6 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
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
2.54.0.1136.gdb2ca164c4-goog

