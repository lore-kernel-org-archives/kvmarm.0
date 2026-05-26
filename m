Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ED23161AD
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808796; cv=none; b=SQnkm5N83TIWYm37jARw6pwCKLEMNDDoj1wYNpGedIqLA+hsN7VRl+AudGPtqd1DDgn9Sm3OeZarS6Vwh5HKC0IlRiRsPLiC6q1c1o9GYy10nenz0quL5dWKlwgGtZ5q8A2FP5pb7hoeZnJDM4Lmk1xgCx7C/4WnWxzz2UfMs8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808796; c=relaxed/simple;
	bh=g2V0AM6ILggz6CDLnm+0G6e8Ih7ixVmLsP2s6I6BhEI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VqEdIgH1doLBwC+9/WyRu/BEo91XoBTJ6mJjDHX+n2LEjkVn364Z85kKfanm/SdkQi3C8BZtAbJgZuvXVdJRWxT677kXTdYRr0uBr3qh1takSV66icNqbuf7wxPft7rTjzkIvmGexc7Ag68DFwVt7k5ak52ezorPMlsToqT4VE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RKShglbt; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RKShglbt"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4411a2c034fso9815068f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 08:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779808793; x=1780413593; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=85gj1ffDyGndAMiyS2A+jf4wwjz9v1ON8M3WpC1uUQ4=;
        b=RKShglbtUqEdgq9d7uDpzf+PpPmRmeVwD+HZlnCBQVy4TMEspp7bBiuuQSSIlsJUG4
         iR6u79JKIvwBP/kDQeIAjg0By6/EgBAPKm0pspysu3CWg//qHfIq6EH2W2hMQ3rzD4Ps
         zZ275V6HLPUoKN4ByFMa6SyYeAJTxCkvq5De/j8KLD/9Q5h1gy/Bvi4rHAic+uW5OJBr
         K8ESS48x81JDWMhmJVUO606HxpzXxAnsHER22YuSPUsW+UQxevcvU7ptNBcLd0g1rz2U
         J8GndU3TnMCO3/V43cDyOM/WGqBQ7Cs/ylIUfxM+d2kclsCqJ/lMoLX1J84+apTHVLjy
         9O7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808793; x=1780413593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=85gj1ffDyGndAMiyS2A+jf4wwjz9v1ON8M3WpC1uUQ4=;
        b=BEif0jRBBK3/ryZs0voWM6pSDuIfCMyVt7U4vG9oXhpxU81KzlwKQiVSpm48pXGOCa
         /yjpZ4jNni0gwfGSklO7K+mKxT4xP8WsYiYKDtgy2fzb32kK3OgHSun2VmJ7KSJBqmFt
         5WmqYPVblR0a7oIt8hk7mBEVi6+iAnLDszvDtMMf1DiF2Q3GlQ7ClI9RNgZ89cDE9c0P
         KXCL/CRoUy+5tZJtMyxhA5UuS55Cqat8JaNbMNGHJAkasvyst+5ymTXgSbHBVTT7cQxT
         LsEPaKUHhbCMc+J/AjUc5lQqi5bo6OHgHb9PNs4gMdfX/WJHRr6hAhinqrnZ0di1wiVp
         dq0A==
X-Forwarded-Encrypted: i=1; AFNElJ8aJoVFx6kwl++kSQZUEX6iYyqWUFAHX9UlvQ8Lk4xZC7HaSdqo+FvYOUn2JZZh9DALJifkTSY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZaINdTtJq8VMjNAhTNPNsI6l2lqE78y8BgkYEylw41WWs/6gA
	V9Rtuhg7d8hHrIqTTnjFiKPgUu29SLHI6LWbmVFS709Yn6CaAHTef4n3IiAsVY8ImLcwSIHjYWZ
	+M+z4mzctNxsBHw==
X-Received: from wrbdq16.prod.google.com ([2002:a05:6000:cd0:b0:43f:dbbf:52fd])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2883:b0:43c:f66e:f24 with SMTP id ffacd0b85a97d-45eb38c8b80mr33942919f8f.35.1779808792997;
 Tue, 26 May 2026 08:19:52 -0700 (PDT)
Date: Tue, 26 May 2026 15:19:34 +0000
In-Reply-To: <20260526151934.3783707-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260526151934.3783707-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260526151934.3783707-7-smostafa@google.com>
Subject: [PATCH v5 6/6] KVM: arm64: Ensure FFA ranges are page aligned
From: Mostafa Saleh <smostafa@google.com>
To: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, jens.wiklander@linaro.org, 
	sumit.garg@kernel.org, sebastianene@google.com, vdonnefort@google.com, 
	sudeep.holla@kernel.org, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

At the moment we only check that the size of the range is page
aligned, and truncate the address to the page boundary.
This make an assumption that TZ will do the same.

Harden this check by also checking that the base address is aligned
and reject it otherwise.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 79de358333e4..ea39e3362efe 100644
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
2.54.0.746.g67dd491aae-goog

