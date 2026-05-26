Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03D130DECE
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808792; cv=none; b=NXggTJrNuA54A/OvftBpAk/AIXtKBYyP1XsH4PvD5VCLseDS3zuC1P2ZKuwh+P4CAx+rJIELlqLkGgYRIDyU5L8a5d1LXVQqimFa7+ciQNYfTdO9bE7xopxjFsM+jAp5nmFX6jSliez/1yMwdbWhc+BT7rqrMAyCWI/cbXd6RLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808792; c=relaxed/simple;
	bh=Lnu2EVY7kGgMFYCr5nzfpDHkYvIQQ8dedbk4JRz62MQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uJKzeD7NHllk5+ifRXkp37belMJtaoU7qi3SCtIkXtxOZ69LaMCAEhqa5ke+YTeyua2drcm7unNGD6cFo5BW03+hjGFoFBIOPhNHQCtDFO4TlI4W7+vI+JgM1Jd8fbeuk53Y3f+lH5EetZ8b0d+mzFcSY4Rcgzhf1kLTw7g5iOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jhnfphej; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jhnfphej"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-49045243094so62019525e9.2
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779808789; x=1780413589; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UUC6GCpgb9EEQ0qn5/HP42C7vK2niyP/8gA1+StmENE=;
        b=JhnfphejitjIH122QbD3jP+/ca13tk6iLUMheb/CJn1NtmUF+jIKk875GYl/IuJeNT
         znY3oKO1JmK29ZObV+5eRy9HyyEUdtr0Pq5dq3zp6QJd1xlZtBqjCWjUv3pz+TnSJRru
         IuPLsO4vKndOhvxbiQXUexfhZyRsoA9ORX/0S3kx1JPwnUBdcr3yJVRTqrldeFo/2hRJ
         JlXhui22qKCG07BxYfZaHUTLhtTt+n4yBuRRiBik0Dzm3NgFH0LrGEamh6zgEOVGkuUt
         JMU94d/lH4NThAw6+f9fWAtzIo6vxrsgVWXHEUeVW0HLv9yBmqr1efwVB8VlrrBApdYo
         25TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808789; x=1780413589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUC6GCpgb9EEQ0qn5/HP42C7vK2niyP/8gA1+StmENE=;
        b=cclV+jhrhMp6TsZns89ocQ/uL83v227+Cx6ofTs7nUN5odepgSAx/ghYycotiRhTnb
         g5G4vJN6i3zI+SzMkyk+5IGB9/GFpv0U4P7YzPuHXF3lghhI+ysvG8QYNGVYuiwsMSp+
         HvN5tt4TPpv7wE3iVz5PfRnZEt15WaTWqdkTdMIL9ZGOpsjp2FpVougiuGXYrjEmpb+O
         UvPtxshvb/vCyVkheiyIzF6YXpFOmz/5RxuVJWds3YWIhYQorFMn70Rfr81+dlyrqcAF
         TgR49pZ7Titab+dg1GL5suQ+fWoNTaZ/w2H4/tF0AH4VYb/frL2uCd73jTIdQJtwrxhP
         1+Vw==
X-Forwarded-Encrypted: i=1; AFNElJ/UcyZnpw2HCU/IVcpKJQIh/rOnyEirglXff5dS+ejJcGMxgrpNPxpZYx7s2LLLYZTa7WDYr74=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoMoyI9NkMB/Ja7QDTVUXVl83Zp+FUxYsVWsVf2SbJxmxe1OWS
	xlAQUO2AtoOxJZHJR9UJgeLPYo9CjnAhPCFFW6bXbg93A8KBypZAkKZr6qIADDvSjPOa3EEe0N+
	8gHsjyBwYZ13+vQ==
X-Received: from wmgb20.prod.google.com ([2002:a05:600c:1514:b0:48f:de5b:469b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3488:b0:490:6869:7d8b with SMTP id 5b1f17b1804b1-49068697e08mr140072435e9.15.1779808788818;
 Tue, 26 May 2026 08:19:48 -0700 (PDT)
Date: Tue, 26 May 2026 15:19:31 +0000
In-Reply-To: <20260526151934.3783707-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260526151934.3783707-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260526151934.3783707-4-smostafa@google.com>
Subject: [PATCH v5 3/6] firmware: arm_ffa: Fix Endpoint Memory Access
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

