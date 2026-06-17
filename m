Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F5D4534A7
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707905; cv=none; b=i/ombqEa+4pNPKRo4MZUZ+4w9T74hmywu1opqGtjZMPhw8qcGB7SYf9NTkPi6f/pmUHiNjv5wlHVgzogvara/t7CL9yHxVaXa5FgtqSMhEDTovLGWxe0Rei5cA0aW+wensyeOEZRB0YmJgW8pkHaeBoGFzCI5PMDjpmuRQSSBPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707905; c=relaxed/simple;
	bh=jloxISYPa8ecyFqGXdFDjWOsBC/fPOUeJSLTxLHPu20=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LiZHX+S3ry5woBJYKWWFug82sZkoRrXmkxZzFPL1RNyOKqOUm0FX6pttEKAaejvDJHfeynNgDvuK20l9HipWXa0iK/i9khlSbAtkdKoOOzJSeBotin0aIGOpHhBcqIvmV0VE2MM19dWIMd2kURb/Fg6L+KK6f/R9t6bw+16pab0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rirq6YZg; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rirq6YZg"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-beddb45de58so466474166b.1
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 07:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707902; x=1782312702; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fif2f/B/gn5RkPcFE+VYhypuB1774zSDWaedB+gVp/0=;
        b=Rirq6YZgf1s2QGpl3ZXF+2qLZOhPmVQfqJ44g0cfr2PiEYu4sl/+3WmHU1ZL9hkLMQ
         kQRvtwtiOR9tjq/2q4QuKhFOqqZyt6QP5tIPfnhRK2WrDpyLSqwDDqC5Wb3Oun9wQaQ6
         mMnp2aktg0VBtKtsLWgxh4ltHs8ae3uVbfE4QkC5UEYdna4OW34lKuvyiV8mkzDaf65v
         SnfET2wuRgW6JBmD69yR5X76PsiH69pFNG/aAhF6H/SVlMxPSC10mYiIMQcsqOfqsOYW
         l/MkO1FPhN85JDuCu35MeJFqOX2wIL4UTMaPf/pYGNJjcDsNQ+dgwN50erYp3P5ir+tf
         Bn/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707902; x=1782312702;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fif2f/B/gn5RkPcFE+VYhypuB1774zSDWaedB+gVp/0=;
        b=f/kTuqIoLO692IKh7QllcXCFuMOczV41qcZCv2dZQZNVCF8TEmDdN/jlTERH8kD8cd
         0ub7pNqclriDiOlHIyprJa0ZbYaBt7lU0rzedYG5+z5PySV/L4WwNOIBDlqiPRV/ZEg6
         j3xcX95sEW+Ok3r4JK4Y7G1cWFSnn2TTgW5UOe329gcRB2RAkq65Vex/0e52XViZ2nh0
         vggt65QIUxJ1ZOfBn4CXBBLqkbTHKtzR56THEkhZmOwZITWHXvvYKoAtpDk3iUvgfb6i
         jrIYY8inB1RbqsBf08k8EuAa+PLTVQzvZZeyYglUk/d31d+tp+oRwx9Ub/RgFRlJUEXU
         S5Lg==
X-Forwarded-Encrypted: i=1; AFNElJ/uDnCy85QmlYHEaDMuoLdy1CIvYyMfaX7Y7aScGuRdnaWvYz52cTF4WEQ16EdmHt+71z7Cw3c=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTMGASWQKRy4aGoCvi/Pn0+aE5WKqMR4F5M8EotLUVlsM9ZThD
	aqOMz37DvO2D1YTDMhjNluiX0dkYU1u+aV1LPNhas1nWzYiEqC6hM/vSzsbudo1/ObeK7ruzpn6
	BIBV3DWti48Z0ECMM+32QXTcb1wPrjA==
X-Received: from ejbw3.prod.google.com ([2002:a17:906:1303:b0:b9d:975a:28a8])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:209a:b0:bee:ec3b:6a93 with SMTP id a640c23a62f3a-c05d2182e75mr113081366b.2.1781707901976;
 Wed, 17 Jun 2026 07:51:41 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:51:25 +0000
In-Reply-To: <20260617145130.3729015-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260617145130.3729015-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617145130.3729015-3-sebastianene@google.com>
Subject: [PATCH v7 2/7] firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()
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
index b9f17fda7243..059e2aae7ca0 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -715,11 +715,10 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
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
@@ -759,7 +758,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 			constituents = buffer;
 		}
 
-		if ((void *)constituents - buffer > max_fragsize) {
+		if ((void *)constituents + sizeof(*constituents) - buffer > max_fragsize) {
 			pr_err("Memory Region Fragment > Tx Buffer size\n");
 			return -EFAULT;
 		}
@@ -768,7 +767,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		constituents->pg_cnt = args->sg->length / FFA_PAGE_SIZE;
 		constituents->reserved = 0;
 		constituents++;
-		frag_len += sizeof(struct ffa_mem_region_addr_range);
+		frag_len += sizeof(*constituents);
 	} while ((args->sg = sg_next(args->sg)));
 
 	return ffa_transmit_fragment(func_id, addr, buf_sz, frag_len,
-- 
2.54.0.1136.gdb2ca164c4-goog

