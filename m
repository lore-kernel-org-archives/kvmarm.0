Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88485345CBD
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 20:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310199; cv=none; b=q0Wli62y6lZeklLd8ZWR6y4CA494wQtcGoFKk4mx3Y16tM4E/SfXJNRH8CWfaT0pb4FdvtRHY8OK5ZZ3v9V3nzmsdbGgQW7lcmqS9jFiEs6UmCnn9F0/fDElE3iE3i6SRN6lhJPfYNgvtkQTcHw1Y/9k8dbwiHMACowxM8RxXgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310199; c=relaxed/simple;
	bh=yEi7Y+sVV03MbE//ByLa4jBWlRzkala7BxfSNn0p1q4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m/SnZBuwUfnpE6w5xgy/jFXnlj2Ul2ifY4iLZohpe0ObpRk+19hL7NXjkoiFlGmpZkLd7hc0yE1nWFL5vV/mNiB/lfWDUSScDeX+V9BLS7CpNtafOY1kuWm8ygfWcmLLWZ4dkfZ/1kGsDoGroD8XQDGO5gzX1nNKB+UfQsyXDrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cLGkW9ht; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cLGkW9ht"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48a589c7879so40996485e9.1
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 13:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779310196; x=1779914996; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h6pS+fRCyL3l4ecLcUFyDog+3129i4iHhu9NlGGm/nY=;
        b=cLGkW9htvzS/Xl5RDVxZHuTkrQqppxt3LNQEjUlLkkNWFb4OAvMSiU0t4FWQwMb3N/
         JN8Wa7cp6eaK4s4xoTyEIkvhdfcpGxqj4/vM+XjjIJNOlC+mDl9q5eaiiHHfZ0SaYIs/
         OVcxQGYebSQ1JnVLhc+P6QKDlFzyiVgdA4gJzI3zQMrHMxERKikOQ26l+fRdMsvVXjcG
         DufjUmxCKJYcDl05lqwmLdohTf8YzXt4h6osmsW61stAM3gpBnB43DRxpWuhI4FhVFCx
         D8upC7Rv5sExRt3/AgkwLnu9qLRzc/WnvlDXTrJwiXAAq6E60Q98jGyepTfZKE65Fh3/
         ePmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310196; x=1779914996;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h6pS+fRCyL3l4ecLcUFyDog+3129i4iHhu9NlGGm/nY=;
        b=RrEpcZ4MMHP/7+Bo4hEv+R3l4/rTWwlaJ6Jm0gzZwx43ZUG0muvbJPn8wjYYx67nTH
         Tzx56i0HFXI43uRDWt8HBivhiu47KQfEVoI7GRVeqjhNvz0gaAMTqkjn2B2i741/2HvD
         4fDNiqcG4USKWCnU66QuerDt661mniWsmAxMs+XKVCIEpg2GJVvm2RisaVb138MmUEls
         NUSnmnOI3khEGQZ4ERQuBUWMzO1TeQALBCcZ9vZdKABEuJWEJwO6ZSuva4KYUezsH2FP
         dtoncIloeUkeoguSPS67m3Vv0eyFJ9dpEWNZz2LE1UBV1w9WJLWbg0XPbnmltnHTAGU3
         B4Xg==
X-Forwarded-Encrypted: i=1; AFNElJ98sKTm3L6U8kya+HEeAHAPIAy8ddibhqbQxmO5qp1Gj20r6jOKR0JaBF7EKg/ZVS5EcRWCpbo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJQgKPYmYHWLhMhixZJEPy6shsuET5htBj3PRB7yCOA0UNbSlQ
	ca6wNvuTVmfS40kx9S4MOJYWe8vcVfuuq3olAFVOtvlFYnIamiJFPA2iDQClke5ObOj8m85E6qM
	ZUYNKoFtSwxr9Lg==
X-Received: from wmfo22.prod.google.com ([2002:a05:600c:2e16:b0:489:d74d:f20])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c08b:b0:48a:79d8:a8d6 with SMTP id 5b1f17b1804b1-49035f37f95mr624375e9.7.1779310196037;
 Wed, 20 May 2026 13:49:56 -0700 (PDT)
Date: Wed, 20 May 2026 20:49:46 +0000
In-Reply-To: <20260520204948.2440882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520204948.2440882-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.669.g59709faab0-goog
Message-ID: <20260520204948.2440882-4-smostafa@google.com>
Subject: [PATCH v4 3/5] firmware: arm_ffa: Fix Endpoint Memory Access
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

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/firmware/arm_ffa/driver.c | 16 +++++++++++-----
 include/linux/arm_ffa.h           |  2 +-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index b700b2e93e72..8573a7a6556e 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -685,19 +685,26 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
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
@@ -707,7 +714,6 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
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
2.54.0.669.g59709faab0-goog

