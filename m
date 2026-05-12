Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD143911DB
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 12:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589894; cv=none; b=FaZ8qJ1m6dmjMttBJPs1cdatip3Uky3EmhlEKE/NGbSMBbx4q3sCPSk6+aRlP8pspRIMS9gQlbeA89zuSAicIEShqR3AneW55KKTXz2gF9a81knxg1x4WXJ9n6nEISbtxMOoNvslXu8nQiYqTnZ11/mbFpc/7L28+1gPBym01qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589894; c=relaxed/simple;
	bh=fc0BwgY/sxg9lBbZXx+RPQE1eC2p+OonaIf/G8VokH4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kp4NgG3h27mO+FTjJarE4TqBxgTyn4iJvmnQmZv7JbUDtxADQpimXikIsuEhGV6pKz6BBYbeFCM3n+AIhK/ZwtBZQZt4rnbDOgmfi7nUfJVCTqcAX8qOJLyZzf5Cw2kQAHnMrY5Hn6z3Qf0dYSF5hCDAP645NkqpAYbOOP7oi10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vHeSdU4g; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vHeSdU4g"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48eb0da933fso2680765e9.0
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 05:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778589885; x=1779194685; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d24wrYQaXGsSCPSg2rGnw1RTPAIojJGcxLwZrJaJw28=;
        b=vHeSdU4gDT+P/lqk/1/1aLz4Ys3iaQLE8hrk9STQg7hdfNtAYEmkIUtTDj1HvnI5O6
         SIYL8OMrMpdzIz1bYoB6YLqunx0E4hkJClCboVjeza5v53YrN9tVA632hFA2VVFdbYXi
         JRQLN4KuYPkvOejXHlCZZMpLIfrkEOSE08UAgICJPAFyk+guIFlL6AvSNPJzQI5mkXTQ
         D47vmcojv8iK9qX3ioyX9+gkmONM6q48onmIyOl8J4XeZch+nGVI5mBr3zEGVc6HPrYG
         hnsb/RnOOM7v5tRBA421NqFSeY1FQNl25ur1zV9ZtIIoivPVBKU5Hzv7EN85XPrE8mPH
         +OSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778589885; x=1779194685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d24wrYQaXGsSCPSg2rGnw1RTPAIojJGcxLwZrJaJw28=;
        b=Ll2U1rtTR56UwHgmg0GSZPDBHyjcbMBmp/+nvaxTN8PQUt0xSgtuXiYW4hMx2jwhfn
         zi6RIxhSxiwAEsDz4G2VOYgFFXM6D/XHfb1cOocuJ80Ou3ZeKle7y3qQZjpKNpaH65yN
         NPzvtn0GeksfTWPCzXTsZKkS6e9Dcu14JWMtVJK8YXtt82QMcOqCKYsUPf5JWUmfGdcq
         lINGSo4fKLSiSJgRXUzWPdPJvzIbhVz3jfDztZMqx5q52gRy7uVwo+vv8P/NBFTCHMMX
         lTWLGqSk92wKbMFnL7jQ0D1yJiQ+8yR/uMbXJYZCmJgQn6RMGlrC4sRD5YGHR8EFpydx
         2oJQ==
X-Forwarded-Encrypted: i=1; AFNElJ/bFeNea1jECUCIk5fzWOZpZVHSzHrJEaizhH7ao6aBTUG/OEd+e1OIzyjOz3DCBb5x3XySLJY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMvwgwEuXoVsLJ1SmnvLM92LG9iiTnaIDYYCTJ4DzlEysBYu5G
	eqfgnM8qc1Jl722NElwjNJK6P5AiTPPZudN40IRvjBbbx1RE1MvS6Rhs9UUwCBy+Lf1zfo859Nw
	s9gvNFNVh0UkkRMyAmz3ZASPYDnrjwA==
X-Received: from wma11.prod.google.com ([2002:a05:600c:890b:b0:48a:5547:c79e])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:2b01:b0:48e:978f:c45a with SMTP id 5b1f17b1804b1-48e978fc469mr17151565e9.19.1778589885365;
 Tue, 12 May 2026 05:44:45 -0700 (PDT)
Date: Tue, 12 May 2026 12:44:41 +0000
In-Reply-To: <20260512124442.1899107-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260512124442.1899107-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512124442.1899107-2-sebastianene@google.com>
Subject: [PATCH v3 1/2] firmware: arm_ffa: Fix Endpoint Memory Access
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
2.54.0.563.g4f69b47b94-goog

