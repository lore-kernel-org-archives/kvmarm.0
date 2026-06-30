Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F883F076D
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 10:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814892; cv=none; b=b3x3+Qx9yAKJGfQ49OXNgnwuBBH6bW5007ZDk2mEmkbu+/K7qIHgYgL8hyiW0LQf/vzePD6ZYpF/BW9eyBDgDaiyPokxcXf1C3gBYr3HWNix+/UpxCY2+EHKte+UpdCzKWQsAQAZ3UWUW6bYBaYeHDNjZP9FzEfOOgT2+LRjPXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814892; c=relaxed/simple;
	bh=AUwidHasjkRfCuksUik7oojH9RAiyJ76u4Xbcp4FZnc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AbS8UN8WbJtNLbCTezEToNqSu94kGDPGzBF47J1+pzka8uuuD80Ts6bLVguE8PEkaJtAxxDMuD7eKbD2b3aqw/TCpJmmc7y6NRWpBeUCIjfuU+o1LOpIPlg7kcG7LnVrwQbSKHw4Yf12TcMFkcuwAd0OhwD/3DTIJhSXpQ4z62M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uqZGp1tg; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uqZGp1tg"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493bb6a4336so3938985e9.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 03:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782814889; x=1783419689; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gyGZakZ2i/l8Ijp+dx1ly7m47WNFgufwNDcjOd78FW4=;
        b=uqZGp1tgWFlnZapBc61LEp66eyHOti1csyqCg/vsdYxC5V0kSSo53O9Wn2R2dVkg2e
         8C0P0d5svBvuFa71IsyAkfeG0CLQopSjBc864xWaSjMwEjiryawbQZCQ2HYODfaddC63
         +c68/Ia/emL0TJOVfBArj+2jf/aYKR2pwOw7Rjz/jT4WDjB3FloOFlDOqlKWDjax5h7E
         iijsAEByEhC/+UAA/kvbHuwx6+Yy0EwJ/8SNgoyOjTWyD0VtOrDN+UbOVgfFEsgUn59f
         aRxWKVdb7F4Wek+GByQ8Xk7PubpiaIvJMQhfc/voZeP6bcg/ErN3s07vXjiIc9OKAaSG
         QDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782814889; x=1783419689;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gyGZakZ2i/l8Ijp+dx1ly7m47WNFgufwNDcjOd78FW4=;
        b=AOZ8U4FklCJ75FOxaNbYpwJob7+Bcz1mL+wszVbsrVvCoCppcFMRQWTEzWmM6B57B1
         nV0QpVa+efKHIapBqLvdJ+bMgxqQvmZwRfKffwAWaTBBBXz5sJuH4Cb12YKvokvrMTBZ
         W6waD+LanvL7+7kJIslx3h25KeCKx+hvzZhQW8kcOS90rggNMlJLkBIt8gqKqWBKbYas
         FBp/+60NZhDAUV4tG85hPFsRmxk9oimQQEIwn4OTZoyoqM6waRSLIQ5dl4MhH95xdEGi
         4XEoK5CuUnbZQai81lVq7Gopd1xaGNI5X02e851Cii+5CUhr7MtCCkMKAiCnVezGFVdE
         eRLQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mo5FeTZOwkp7wHlpVU2cD6IcSWxvAaPSt3XrTtuYu2/hozScCy8pPVTol6Tk5ENw9IMvbIx0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6RCy1wa1sVKcyuw28f7anPjvo0fNFH4fbfGGgbPbp6MT0rqMf
	s7zOl3vhxPczSgz4tILS8ORCCv/ny/VOb4cvMHo7cxr5jEftP7oTTpEorGbWTnhiW64tgvPWkTT
	hwh73Otgx0MJepxYccoPDj07FE0l+yQ==
X-Received: from wmlv8.prod.google.com ([2002:a05:600c:2148:b0:493:b8dc:89a7])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b32:b0:490:d354:bd00 with SMTP id 5b1f17b1804b1-493b82b504emr46612095e9.25.1782814889210;
 Tue, 30 Jun 2026 03:21:29 -0700 (PDT)
Date: Tue, 30 Jun 2026 10:20:58 +0000
In-Reply-To: <20260630102058.3219867-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260630102058.3219867-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260630102058.3219867-7-sebastianene@google.com>
Subject: [PATCH v8 5/6] KVM: arm64: Ensure FFA ranges are page aligned
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

Harden the check for the constituent memory region page alignment
to prevent over-sharing when the negotiated FFA_PAGE_SIZE size is
smaller than the system PAGE_SIZE.
At the moment we only check that the size of the range is page
aligned, and truncate the address to the page boundary which can
annotate more memory than needed as being used by the FF-A.

Fixes: 436090001776 ("KVM: arm64: Handle FFA_MEM_SHARE calls from the host")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 14aa37846059..bb01d8f83056 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -352,7 +352,7 @@ static u32 __ffa_host_share_ranges(struct ffa_mem_region_addr_range *ranges,
 		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
 		u64 pfn = hyp_phys_to_pfn(range->address);
 
-		if (!PAGE_ALIGNED(sz))
+		if (!PAGE_ALIGNED(sz | range->address))
 			break;
 
 		if (__pkvm_host_share_ffa(pfn, sz / PAGE_SIZE))
@@ -372,7 +372,7 @@ static u32 __ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
 		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
 		u64 pfn = hyp_phys_to_pfn(range->address);
 
-		if (!PAGE_ALIGNED(sz))
+		if (!PAGE_ALIGNED(sz | range->address))
 			break;
 
 		if (__pkvm_host_unshare_ffa(pfn, sz / PAGE_SIZE))
-- 
2.55.0.rc0.799.gd6f94ed593-goog

