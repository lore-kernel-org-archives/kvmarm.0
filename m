Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1144A386450
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 10:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988747; cv=none; b=HJ4QWyd/mMZFwd1J05V+vVxP23RyWpKCm4+TBCqx+ILU0OtDNdDdo2ye+lP4nAplb5xZzcelNfeh2pZY/uxN6rLmSMjOhyqnkGTPHf+rr4sXbRZ3EpxF9HzDISTDYZkbQGJB2ICKEtKpBqivfd5pjDJv18wrCn+6mo7QcGjMPLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988747; c=relaxed/simple;
	bh=9TOnq1jD0pgHaO1v5HJoXAFTZmNdtts5+PujmRUbv1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PCueKJyiCH/his3KfH0TP3SNOisYOF+9xr3agFmlHpbegqxeSYN4/axkMXVNFe2gpr8uRRcQc4Ho5dAJTANrt6t3fzNoNqYw7rT8neRkbVFXisakkX559gsBeEcboNceesouWV5tUzYsFfa64Vsk0M/Xu7O4fqxHi83CHGOOboU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XuZB90Zm; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XuZB90Zm"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493c47a09b5so5679385e9.2
        for <kvmarm@lists.linux.dev>; Thu, 02 Jul 2026 03:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782988744; x=1783593544; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kMc7IH1jEIo7aTQO6+OKWeTUOGgdg0YUEMVyYCucVMQ=;
        b=XuZB90ZmE0yvH/isoYApVspYIZKaUUTUZ440RtjTpfraj8Mc9KzHrmyR4MtHE9jQvW
         rvNRsobb0r5Du1dDVuKrnARDpwx3GJ37A9U4OzW5jasMTrys3+zSvbpzYiIHz3zKWEVH
         yUiFsd4pmixd0zLcB3s4xtAx5/r6GQ1sprTurq1tDLO8IkV6+9BsFC4yvzH1ld74iqU2
         4ur9+65GFoj+3NE5PlPI6IJgOk1caHp2ghWSeOrRxSwmaCfenN82Ip2bBJYATJYkA5Sa
         m8HCdd9/NwvL9/maz2UNG4/HhxoL2jF8IOKIbRSkOw2Ic/nEVe7CgLTEbtaZp4hUjlDO
         /IiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782988744; x=1783593544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kMc7IH1jEIo7aTQO6+OKWeTUOGgdg0YUEMVyYCucVMQ=;
        b=so/DJMLQmyHg9Up4Cr158lgQ6rcMemRMwhHd8h8KTZiSN3/+iZxHi63DwDqWiqSYw1
         ScCqrW/YDoHHEB9UD4oIz1oJ9jS85Z41bQKtU0dtxWIpJpyr9aYb+z7KtdMYq7mVvXCQ
         NBHuuX7IBOW//nox55rr3nYwtevKHqCcBlPVUV/zgnVaLkFGFpleZvmUYbgZoir1Q1dp
         bZbUQjVNFUwvNj1mnZMwjX575Msi5480GY/nvjY+RQD1rYMUw3wNz5A8xChjC47X6/G/
         7AkPv/7dk9GqDY3CbrbE7v9fn7zyVrDLvCjIF8ZR6TyYoV/O+xfLb6c2MuF3ISxlyeRy
         Nhhw==
X-Forwarded-Encrypted: i=1; AFNElJ9aY2pQcoQrBv/IBw5K4JgmZXNGP5r2SjVvgGu7lpQOlyAOAn8M6nyWTrTrYaapYX88uZ376B0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiCVsZExxsbO95qSqKflWDlXnUMEc2sOzuCPXc6rpRWuXT5VOL
	BIqsfCTid5OoeHH7ErEXplH/F7yhKo8QTraOnzUFJfFzIjUObN47L/IXYjp5Xuf1TBVZWROuF0Y
	Q7OWR4HkBGUOno/bTz+i9iu/2+3UZzw==
X-Received: from wmbf13.prod.google.com ([2002:a05:600c:594d:b0:493:b636:4ee9])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5010:b0:493:c453:600f with SMTP id 5b1f17b1804b1-493c453616emr44043235e9.6.1782988744277;
 Thu, 02 Jul 2026 03:39:04 -0700 (PDT)
Date: Thu,  2 Jul 2026 10:38:39 +0000
In-Reply-To: <20260702103848.1647249-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702103848.1647249-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260702103848.1647249-3-sebastianene@google.com>
Subject: [PATCH v9 2/6] firmware: arm_ffa: Fix Endpoint Memory Access
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

