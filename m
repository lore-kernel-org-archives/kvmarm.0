Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B2E46AF38
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 16:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777564973; cv=none; b=pcdwZ/tUMFxrSlhUU8jIrvFt2b43zzfjk6imyombAvq1qFm0YkiTUBR1VE3xg3ZainJMKY78de0B4id6/0S3gCEUVIYtkoOqLPU8paVh6rtTi/tpob1wqWmFNohAEvIQhaSsaiIqpS/IWVRG9g/OIvG/YiaI5TqzMpdxlYW6ZZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777564973; c=relaxed/simple;
	bh=rbgtcAYAQRUylV3Lhn5JG2lol9vvZkVALTDMx9L0izU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fF0THPbsAovNbeNseYyToLY96XRzIBGJNN6IsSHno0KZ2Vsu9uU46aTtBZInc1mycGWE10maR2YsMdKZGBR3g2Jqdh9i/zsoWHwWnxuBOh+R3J9ednPoNTR2NC+dDwF0bM2QgO0cNfy6tHM2DS3WPuUy27yx+fVjVVrRkTE/eas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dy4oRMYR; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dy4oRMYR"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488d2cd2674so8644155e9.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 09:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777564969; x=1778169769; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sNzXqsExGNdsaK3Y+3cXtMsfTVlLQ8Rl/2Rw58fPhEE=;
        b=Dy4oRMYR35vFF7TBQvvlIfv8ZnaC+ar+C4toSEq2Ni+UnQe2oeLBh1BvwPEdKZWppm
         6kTbyuSw0KFuB1JBawZ4Xhdt7IXPDdzWEY+VybYSvtP2TCDLxbu1BRzJtkmWzrxFj1b7
         2IpzOpUPyoCAQgipUqGsn5Jk1z+uQBlffwSYQZQGWea5hFiMuiqwjkgRHvTPA1wmEDpK
         cWoSFas0ekCIvMKbfQzIrtIfgVosWAT36HYi8BEA7AYuZPNryEDyfQuJCeXrpvHDBTU2
         owK25rFejEEpUTRya8Mc0PzyHwN7SHM1wV88JbGtS0qtyfRNfe72RlRnF6+b7mlv0EWc
         TTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777564969; x=1778169769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sNzXqsExGNdsaK3Y+3cXtMsfTVlLQ8Rl/2Rw58fPhEE=;
        b=MiWCuN6tz1AOKnq5M9R/MxuO9FG2ln/80rfsuugnS0imduBZxVqkgXQj9rDq0J/IId
         cpksHSxp0Gj0LNmsr8OPE8tY4LXGZFuTgfRhsq3hBOLcSPZEZ1ETN9YBTRmPK2I2T1o/
         9MsP8wZC7muItSMpg0bieoT3uxqGyrH0EjzRS+2kED4kYmhIjtxed4xxupxg8WbcArJ3
         cv79SiF6idAG+G23wG6vjuY6vU/eVo/UlQFtScOLwlOkGQ/LgaApe55SZemF+f8IOHjh
         VZ9LOOoTTaYpDngUBOBm4xCG8IhqQni/epcg44P9Z9+DbOstcYgibZPDhx6um1Uov5cV
         W80A==
X-Forwarded-Encrypted: i=1; AFNElJ9MKsMhAhcy0zhknhimwFlU86EpITiCamASFkyrgivMtJw3sD3ksXgiTUTLsK62lEB4J59ZZUI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoHmGFKCaRHYx5GzvzelA6HnkoAAPgIs+84sVwHbvGIAoaMVqp
	OY/C62g3E0TFuD7aK6VroTWFQ9tduoFcmSw073pGNi0P/b+xCK/SwHyEkmVIlZLd3orzKbD4Hpe
	IuIR2GMpElFQHyRwHgf5VM9MM0OFRPA==
X-Received: from wmcn10.prod.google.com ([2002:a05:600c:c0ca:b0:488:af7f:772a])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:888a:b0:488:9439:881a with SMTP id 5b1f17b1804b1-48a84256354mr40669335e9.2.1777564969247;
 Thu, 30 Apr 2026 09:02:49 -0700 (PDT)
Date: Thu, 30 Apr 2026 16:02:40 +0000
In-Reply-To: <20260430160241.1934777-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260430160241.1934777-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260430160241.1934777-2-sebastianene@google.com>
Subject: [PATCH v2 1/2] firmware: arm_ffa: Fix Endpoint Memory Access
 Descriptor offset calculation
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	sudeep.holla@kernel.org, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Use the descriptor's `ep_mem_offset` to calculate the start of the endpoint
memory access array and to comply with the FF-A spec instead of defaulting
to `sizeof(struct ffa_mem_region)`.
This requires moving `ffa_mem_region_additional_setup()` earlier in the setup
flow.
Also, add sanity checks to ensure the calculated descriptor offsets do not
exceed `max_fragsize`.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 drivers/firmware/arm_ffa/driver.c | 14 ++++++++++----
 include/linux/arm_ffa.h           |  2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index eb2782848283..56b166290b24 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -685,18 +685,25 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 	struct ffa_composite_mem_region *composite;
 	struct ffa_mem_region_addr_range *constituents;
 	struct ffa_mem_region_attributes *ep_mem_access;
-	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg);
+	u32 idx, frag_len, length, buf_sz = 0, num_entries = sg_nents(args->sg), ep_offset;
 
 	mem_region->tag = args->tag;
 	mem_region->flags = args->flags;
 	mem_region->sender_id = drv_info->vm_id;
 	mem_region->attributes = ffa_memory_attributes_get(func_id);
+
+	ffa_mem_region_additional_setup(drv_info->version, mem_region);
 	composite_offset = ffa_mem_desc_offset(buffer, args->nattrs,
 					       drv_info->version);
+	if (composite_offset > max_fragsize - sizeof(struct ffa_composite_mem_region))
+		return -ENXIO;
 
 	for (idx = 0; idx < args->nattrs; idx++) {
-		ep_mem_access = buffer +
-			ffa_mem_desc_offset(buffer, idx, drv_info->version);
+		ep_offset = ffa_mem_desc_offset(buffer, idx, drv_info->version);
+		if (ep_offset > max_fragsize - sizeof(struct ffa_mem_region_attributes))
+			return -ENXIO;
+
+		ep_mem_access = buffer + ep_offset;
 		ep_mem_access->receiver = args->attrs[idx].receiver;
 		ep_mem_access->attrs = args->attrs[idx].attrs;
 		ep_mem_access->composite_off = composite_offset;
@@ -708,7 +715,6 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
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
2.54.0.545.g6539524ca2-goog

