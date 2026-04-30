Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677664779A8
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777564974; cv=none; b=dTIGDzxRzFrDaU8vq6AANE3yrrp8g8M/aEQkxJFFZsVmXiY1CLGneBJijCPg11Sf1kt4lnmRN6MCNQFsQ90kbaogPQDYJJCi7psMeyHiAS0Lmimcrx47KKhiovHBQ1PrX2MKts5A6QWDPQDiGvQO9RFOvk+kTLMtosPFyauvfHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777564974; c=relaxed/simple;
	bh=nSYWLOgCg9cYKYP1SSRIy1jcqnUttFghlsW4Zh+PYH4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o6GwjTvNZAh/JJyzaz74mxEAjQWIeSwnRU+sn5YuRK5rZB0pfK+r7YY5onsj0I1WFutuT46SrO+9J40nZttqb9toLKC3Q242iWrUmlyeeg2kBzVe+pGo4y3INuzTmff1GVCuBSTnhtouxuyLNxFVFsyuD9kIfYwgPztQTzFaXCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dAPk3Zdd; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dAPk3Zdd"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48a5523fd53so5216535e9.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 09:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777564971; x=1778169771; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4coEQbrBUmFUrjDBw9QngC1TQrHyKn5HQ1tDIlRoapE=;
        b=dAPk3Zdd80ULLWbb45m+IL76unVUz3B83smedhu7noY98ExoxNexeLB+pbCcwGhTha
         Xr6OjLx1ozYjKdkxa6d3DHZNJoF+NBd41ohlmSyeWt3VjUv81uQZUpP7UoubuRS8B6gN
         0u2NRMn4Fel3efiwEl7g45VjoX2DInszZnbeWEAN2rRR7hmXAmwcw+YNcXD2TuCp2eug
         SGDuBbC5aMV1yCtAYDdQLQ+v2pslIAugAngtGwK5YhOwOz/fNTYxHb0yW0dsPUfPw4a8
         pM7DrwZPbLQqrsjvyKUksrg2goF/a5mR+mRM7eubzorBmfiXHEZx2HIO1xNilZkYXIGX
         0i2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777564971; x=1778169771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4coEQbrBUmFUrjDBw9QngC1TQrHyKn5HQ1tDIlRoapE=;
        b=KuiY6jAn3R/TVFvp97UtoSrQM1kUq538+RxuOmQJOlSHa7xQ9fRU8LdeLnY7ilzZRD
         abx9Wu+zdINws6LAEw4T3ff7PAztq+43O3w1Uswz9GerBerSS4IG+sZKua+nhWjAGJJ8
         ttxWkqkfrlkZkSwD0BXblJz8jEhCCPVopzHB84bIa1kFLoWuctypOEHiohRQBDf9wtay
         vyxczqYL2p79rCOP9KY2ghgypbx9lpf+CskKzlIsG081oWsRFLoc0bMaIp0WspRocNPi
         6/1P6bIpWZHADvUJ1isHAXRGvcwrAkgxbv7GhLW3U86XiJNshu+q1S5bkweopTVkZ61o
         f+kw==
X-Forwarded-Encrypted: i=1; AFNElJ/YfcG25LSKHeYhtuOpxO/WL1eaRZ0Aozjs4e1YQIXdElGv5k1oFz4iv9ZQYVZTAHKDDBhyWjY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPfK5tiXXOHtnBkoG3dALpkMRk2fpJcWFvS8O0pWnWlmExFPMQ
	lpYqvPwCAGPyAIDkNKbmwDeYgEk/zB++aB+m3oaFJNsV3toXWw6ouSbjwZyqPLIGyyeVzcp62kb
	+hc1zsNtzwM/yAAwTrJQeeNo1OZ6YEg==
X-Received: from wmjx19.prod.google.com ([2002:a05:600c:21d3:b0:487:2186:fcf7])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a14:b0:488:af7f:7707 with SMTP id 5b1f17b1804b1-48a84451bccmr53589865e9.18.1777564970647;
 Thu, 30 Apr 2026 09:02:50 -0700 (PDT)
Date: Thu, 30 Apr 2026 16:02:41 +0000
In-Reply-To: <20260430160241.1934777-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260430160241.1934777-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260430160241.1934777-3-sebastianene@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: Validate the offset to the mem access descriptor
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org, 
	sudeep.holla@kernel.org, will@kernel.org
Cc: joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, 
	sebastianene@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Prevent the pKVM hypervisor from making assumptions that the
endpoint memory access descriptor (EMAD) comes right after the
FF-A memory region header.
Prior to FF-A version 1.1 the header of the memory region
didn't contain an offset to the endpoint memory access descriptor.
The layout of a memory transaction looks like this from 1.1 onward:
Type | Field name | Offset
[ Header | ffa_mem_region  | 0
  EMAD 1 | ffa_mem_region_attributes) | ffa_mem_region.ep_mem_offset
]
Verify that the offset to the first endpoint memory access descriptor
is within the mailbox buffer bounds.

Signed-off-by: Sebastian Ene <sebastianene@google.com>

---
v1 -> v2:
 * don't enforce a strict placement for the ep_mem_offset since this is
   not compliant with the spec and we should not make assumptions about
   the driver.

Link to v1: https://lore.kernel.org/all/ae9KN9nkOgDYJcGP@google.com/T/#t

---
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 1af722771178..8e9017fc8e39 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -479,7 +479,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
 	struct ffa_mem_region *buf;
-	u32 offset, nr_ranges, checked_offset;
+	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
 	int ret = 0;
 
 	if (addr_mbz || npages_mbz || fraglen > len ||
@@ -508,8 +508,14 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
-	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	if (em_mem_access_off >
+	    KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE - (struct ffa_mem_region_attributes)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	ep_mem_access = (void *)buf + em_mem_access_off;
 	offset = ep_mem_access->composite_off;
 	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -576,7 +582,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	DECLARE_REG(u32, flags, ctxt, 3);
 	struct ffa_mem_region_attributes *ep_mem_access;
 	struct ffa_composite_mem_region *reg;
-	u32 offset, len, fraglen, fragoff;
+	u32 offset, len, fraglen, fragoff, em_mem_access_off;
 	struct ffa_mem_region *buf;
 	int ret = 0;
 	u64 handle;
@@ -599,8 +605,14 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 	len = res->a1;
 	fraglen = res->a2;
 
-	ep_mem_access = (void *)buf +
-			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
+	if (em_mem_access_off >
+	    KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE - (struct ffa_mem_region_attributes)) {
+		ret = FFA_RET_INVALID_PARAMETERS;
+		goto out_unlock;
+	}
+
+	ep_mem_access = (void *)buf + em_mem_access_off;
 	offset = ep_mem_access->composite_off;
 	/*
 	 * We can trust the SPMD to get this right, but let's at least
-- 
2.54.0.545.g6539524ca2-goog

