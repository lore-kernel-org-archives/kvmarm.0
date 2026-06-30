Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9742A3C81AF
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 10:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814885; cv=none; b=I7ijYr1G22Theu8MR8HFnhD5IfGq2xsKF4U7pAnKeupwXJS5Z1BfZLghLGfwBaWj2KD5h9eyPuEQUrlzU5h6o56/C/xpy9QHCasfbjZEQo4OBGsNNuTBMuhocrsKII0yGxQiJDeIgcEXpoiLpze9Ycpuit4BFRcZEXndniTmOYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814885; c=relaxed/simple;
	bh=cqpqWComKRWiCpCFlRr5CCe1UaqVwupCKxUEyOVLkh0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YvzRQ3eHkl+uSRk7Nk4+0q/oZ0BiRW8LfPEarelogZNhZVz2fH2F7BxeXkCpEcEJ0vnOSUg1+WziOch3Y7M6vNGrcsfL8Nke1/lePgwFQpFvHG3vA/em4VFdDUhoPbTOGxOwQs43/gD9oY9l7t1P5lyaHY2sjdzKoeVbl1i709Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Npov3FCe; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Npov3FCe"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c1265eb65e9so205427566b.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 03:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782814881; x=1783419681; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3srY3du6pUShZyOw/nlifUO0efjUMM7goX5s1Ul3bUU=;
        b=Npov3FCeykhsGDSjG8wQ/5ZUPWHi7HqT6RX5QwOo4aYKMa9ckWVGlEeHXRq8Ve1oDr
         QoMC05L2+GJgQx/ZyRQzMW1XOO8qsZjfecci9PwFaPgFwk9gb5LksCVyvCeZVw6Jz7k1
         /EFUQX+JZisPgoM6aU4ejrpeh8hrZuK7kCIAeia4FjL7PYaBlnl6Jidn08WvQVqnX+tn
         Jlwf60D7SKIPTsD8EMmHh2JrzzgzdmODvPXwcn2cmBbaflftsiOJbIY+ZiEZke0KVv4d
         4SUa8kbI1/HBPLNpRHE1bL2lKSJsyE6SV6lBlxB5NNKJjY99LTb5iy7o8TzIp11gR/WT
         GO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782814881; x=1783419681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3srY3du6pUShZyOw/nlifUO0efjUMM7goX5s1Ul3bUU=;
        b=VNi3yUP8vbK20zmTKtuHd3F3AI6MMbXobDpVzWc6tXYB7uCIdDox3gLFrQkt7U8RWK
         EwFx9m5S7asSpb4dj+O1SMMnewPws6JWL+tjD3s5/L8kzo63mRsO/66QVgR2PHziHZcG
         BMu4fRHtdV0wbApYjjf7DIb1soJn78AJIsudYiHu49lvoGHC2wTR9j6gkrEYjEroFtCQ
         JbNM5Z8S+dn1hon98WiKeHVhYCfoqHvytqmD23Rfg3SRAM1A3y1lqCiir1INEAxyN3vX
         6TSocEbx+URD2K/XEJpP2H21YTY5ygG8Vxdf5AfblpbrXaU9DL+6ouf5aKPS6/XaLrPP
         PFYw==
X-Forwarded-Encrypted: i=1; AHgh+RqQFq0lsPqq6+YojqzllPY4YfrQLt9ggcW5rdgHuBMbOMa8BqrkIOgQxWOLNXygxP78ZvN3Kpw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxrfdi0IWJyiSibRC5lQguqutnTzAmOITBTkdYPKWtvI0tQRGd/
	EmHLDfJTLynC/B/pCxgC37c/mMcMyo8XtTjNdY/lPTSS/uwZdoQ1tllNHZVeQzOcTLVgcNugJR1
	geOCrTAUoI7fn8DMNwSWvy9rcqk/Kow==
X-Received: from ejbgw23.prod.google.com ([2002:a17:906:f157:b0:c12:5da6:868c])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:fe46:b0:c12:8d49:48cd with SMTP id a640c23a62f3a-c128d4953fbmr93701066b.37.1782814880689;
 Tue, 30 Jun 2026 03:21:20 -0700 (PDT)
Date: Tue, 30 Jun 2026 10:20:54 +0000
In-Reply-To: <20260630102058.3219867-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260630102058.3219867-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260630102058.3219867-3-sebastianene@google.com>
Subject: [PATCH v8 1/6] firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
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

From: Mostafa Saleh <smostafa@google.com>

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
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 drivers/firmware/arm_ffa/driver.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 0f468362c288..01301213896a 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -725,11 +725,10 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
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
@@ -769,7 +768,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 			constituents = buffer;
 		}
 
-		if ((void *)constituents - buffer > max_fragsize) {
+		if ((void *)constituents + sizeof(*constituents) - buffer > max_fragsize) {
 			pr_err("Memory Region Fragment > Tx Buffer size\n");
 			return -EFAULT;
 		}
@@ -778,7 +777,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		constituents->pg_cnt = args->sg->length / FFA_PAGE_SIZE;
 		constituents->reserved = 0;
 		constituents++;
-		frag_len += sizeof(struct ffa_mem_region_addr_range);
+		frag_len += sizeof(*constituents);
 	} while ((args->sg = sg_next(args->sg)));
 
 	return ffa_transmit_fragment(func_id, addr, buf_sz, frag_len,
-- 
2.55.0.rc0.799.gd6f94ed593-goog

