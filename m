Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA632180A77
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718208154; cv=none; b=Vy1HAt3trev4HCir8uIFyRQLhgcLlFi0voB8fo6Lcd/gRAJsIV1BBDYwmNgCkZuc19NCDqYko4w9Iog9QJ6ZGrbwbZOgKBW7fhlUl8KN6CKB0p9xxQCiLpHNSRIqo8/RHoOouDvK6S4a7VNJNDzPbqMudPjNFGqBDS9Cgn+pmfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718208154; c=relaxed/simple;
	bh=1TFVrwww23bDZwSiwRJ2jYhuVWiPUIMbmY+tTlCjXjs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JdyuqIR8Yhx2DVUcYkxQ+Av/bLzci6jAZO2LgbC10q0vPF25qugXSVhHpFRWnrg7ghUg3k1/rGgu5pPa5pAOX9PLD/S1G3sey66tRpG9U/3qlT9Tx7lJWtm/sCniou0ppYVJm5V6XGUiPYU/awVPMKZRNI50GpAeadCyyxcIxzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JpQhW0Mi; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JpQhW0Mi"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6e3341c8865so4820820a12.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 09:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718208152; x=1718812952; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aePX0hruEKIOA1+M6OG+w8QdYVFE2Ff801XPria8pOI=;
        b=JpQhW0MiB/LNXMYn5dP4WzYVCtqF84OJgHRBllbAjczDkP++as0tU9DhYGRqlhmSyd
         CytS4A34ejVRQ8NN2hmJSxT1778S0s8ujBMeBT0x2XmzDWulWfArJfE6+gmxIjvc/29t
         8CMSClX2Yg1PegCH3utT6uWIyeCHIG4rS5ngVPdA8m0U+PyQ7d357mUTSYn0wYWTEk1O
         nYGL0FtAV90/tL7zv0ml/OfJIsgtTx6DE8kPwirgkzL/kBQxo4lW4Nmvv2pszcgEOhrx
         HZt2k8G7ZmOWlI5vT4paPTHNxw66jetGfHq2Ul9NquRrkCdejlZE3WDMrhpVKD9jhKzk
         KX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718208152; x=1718812952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aePX0hruEKIOA1+M6OG+w8QdYVFE2Ff801XPria8pOI=;
        b=oO7Rnvh/stQIhfiEJWhafbBMc+yM/y/+RsPmBlrMIQFi1B9nptcgZPcQADkeQ9Y2hB
         rTHBOgGA/ZuyDksDH3Ip06fMhu1DK7J2Z6wG480fBaUDLtxnB9ozEMjCKhjq1RuESiOc
         6pN7SoKbsuLHdpEYjcDti3Sr9REss3KKYCJmszmH4ZW4L7JHSwcPkS7eTQAO3MTQLZWq
         rCz+VcEOEY53E72lAIdR1Ec8Sgk/9ZvBTjjfD4oYpTkSugS/opiJh97ad/tP7QXRyVmL
         uYC8NkOlDAy+T+8/Q3FK0lwm3HhPu0rtbFprB2Ft0yPUIX7g34a2kpWil2PERrRCg7RS
         Kzsg==
X-Forwarded-Encrypted: i=1; AJvYcCVxFBfQRWN2dULCn3FNz3BnkAUDqXKkXamIQby9sQyFQVYaJ93H4/Px9WgfUKqxeT2MtH/KrJCwwuxH58iB4koFkpbvucO4
X-Gm-Message-State: AOJu0YyvZsH9ZxujiP9Z0Ek9T7nD8Y5afhEsk3nRCSQItBVKDDw7GPXx
	4hUu+mAIgnv6+8cm2KgmPVb8yKjl1RkONYNnYsAUEewolIwt9i1V8A+IULXx4ySpdFYhHiMHxPo
	ygg==
X-Google-Smtp-Source: AGHT+IG0uMYRLBiUhOc770oDRl2hP1hRVk0jGwiyLvB3wm+pqn+z8Eju9Zd1H20tziFvsazDeHJOkFbkr74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:9503:0:b0:673:9f86:3f23 with SMTP id
 41be03b00d2f7-6fae0e6eb36mr4827a12.3.1718208151688; Wed, 12 Jun 2024 09:02:31
 -0700 (PDT)
Date: Wed, 12 Jun 2024 09:02:30 -0700
In-Reply-To: <20240611002145.2078921-9-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com> <20240611002145.2078921-9-jthoughton@google.com>
Message-ID: <ZmnGlpBR91TyI3Lt@google.com>
Subject: Re: [PATCH v5 8/9] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 11, 2024, James Houghton wrote:
> diff --git a/mm/rmap.c b/mm/rmap.c
> index e8fc5ecb59b2..24a3ff639919 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -870,13 +870,10 @@ static bool folio_referenced_one(struct folio *folio,
>  			continue;
>  		}
>  
> -		if (pvmw.pte) {
> -			if (lru_gen_enabled() &&
> -			    pte_young(ptep_get(pvmw.pte))) {
> -				lru_gen_look_around(&pvmw);
> +		if (lru_gen_enabled() && pvmw.pte) {
> +			if (lru_gen_look_around(&pvmw))
>  				referenced++;
> -			}
> -
> +		} else if (pvmw.pte) {
>  			if (ptep_clear_flush_young_notify(vma, address,
>  						pvmw.pte))
>  				referenced++;

Random question not really related to KVM/secondary MMU participation.  AFAICT,
the MGLRU approach doesn't flush TLBs after aging pages.  How does MGLRU mitigate
false negatives on pxx_young() due to the CPU not setting Accessed bits because
of stale TLB entries?
