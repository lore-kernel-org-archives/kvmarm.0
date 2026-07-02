Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820D83988EB
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 10:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988759; cv=none; b=PzMvw7fxcM1Ko2f7BFnUEsMxRVM54fZja3NSTuYMoS+W3XajmYz0of8G9tiofNo1giznKSicMwsAgnvAcvfadYIBJWawqokFvkvJ7eXCmIDPal2SJ4bkS+mfGqp/Jp6JlNoGaNNADzK2FYVlC32lOVjbWi8GKYPKPpti2Z/TirI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988759; c=relaxed/simple;
	bh=Jf+lw/4DCyppm63tP7dCDq4VU5ytrIjHJpO97z4Nh8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cHSvBeO+HqKs2l5XHOIUA0JoJOazjDfX1ys8cANd1zw4b61P8sq4WzSd+9NRb5f1dukRacrS+kJm/Shf5S/TtcgkPRLAYv6XbQQqK1fdRA4KjNy3VTJlfiBWVP6MDAGlSadQO18RxJmLHas+pVgb6On4aM7humiMILkTs2SOi2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sQf6VSzq; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sQf6VSzq"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c123ffaf33bso132191066b.0
        for <kvmarm@lists.linux.dev>; Thu, 02 Jul 2026 03:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782988757; x=1783593557; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S/B2rsvapQSn12m5d81J+topBC1cosRCvCMomhxQt+E=;
        b=sQf6VSzq8zawwRqAsPACg4HBhkMwKszLTRZshkm9++WIF+hNYt5QVExJ+8Xlcr1kao
         BttQyctH+d4GCbGyTEgvm2314QIvN59xOaEU5nc2XlgWYdMxmBdMhAheTXZqx0ULUEXx
         9SMZBZdVAO6I+0gq90KAYcdE/WqUc++ORXCODbQUUcToUd6DFN/o8t2TJ7YGMGsh7mBS
         8PGnH9ZM3TfXB0s+1sjLj0upCgury40P5GAyZQFYMa5WQ+lqr/8Ysg3YT7+y6XIt0rJR
         3bbPJgi7qiaSyGCOnKjlG1rpjuGO7BnXtFAx+B4IkcxtZNhQVw+MGLkyJNUWcUF60Ad2
         HpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782988757; x=1783593557;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S/B2rsvapQSn12m5d81J+topBC1cosRCvCMomhxQt+E=;
        b=Vp4IwpzFgm6b8OR6ut/ORFA9B/W5izGIP3D3PwRoY+RncsvgzFGxV0u45iPU8XGSrw
         ov49l82ViMJtIPlDip08g53oX36Vw48cawxgaZcV3mqakauSeRdyOEzbpv7BUCJRnFVq
         CiEkFebCRMHiVHE5yn1m7Xr4zaA0jNwdHgMrer0GkB6ejGlAFQ3isP1erFZZ5xihYKnZ
         U4pkuTLVZ4BPbZesK9SAmZe+uf1n7v6Z7uyvam9LYpmz3+tDYwUqsLrdgkJH8ZHYMsqe
         tgDyuYmj5M2gphFaryqov9fC8Cm6rUPsrCJYCCyRrvIJdFTjzTSFNUWPfKAWCXhhU3cv
         tz/Q==
X-Forwarded-Encrypted: i=1; AHgh+RrL6S4ooLQdE0+cBaZMyg+qiVrd36w48J4dJz5c6uUtp1QQtvSJ7hu2QzbvXoUXmeToi78BACg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/VjU6IYdT5nu33BmorN2VWlBHDrAh6TlfS9nv1KLoz9yl7wLq
	YGjBmK510qI7JBmwrSIy3bGfr1/vTkGKuXmShW+NuPZ6jJAMxi6GKfmQFLM7AJOwT3mcxx21B2e
	BOi1HFMNUS7xiA7EDq02yJHJNFBvivQ==
X-Received: from ejcht18.prod.google.com ([2002:a17:907:6092:b0:c07:60f4:6d56])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6c12:b0:bd5:18e8:1ac1 with SMTP id a640c23a62f3a-c12ae3ab429mr242035966b.5.1782988756892;
 Thu, 02 Jul 2026 03:39:16 -0700 (PDT)
Date: Thu,  2 Jul 2026 10:38:42 +0000
In-Reply-To: <20260702103848.1647249-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702103848.1647249-1-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260702103848.1647249-6-sebastianene@google.com>
Subject: [PATCH v9 5/6] KVM: arm64: Ensure FFA ranges are page aligned
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
index 2e7ab7e3319d..9c96e72e522e 100644
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

