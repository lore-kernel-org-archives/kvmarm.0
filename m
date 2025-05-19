Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9CD6AD3
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747665978; cv=none; b=R8jbrpxYtTWNkixJkVphNYV/Mw/ptMOMkkt/H6ticCKWFFY3Fruf/INBJQEsnr8uptyl2tNCnyU6+0bwuTpqa5ucFeS8zOaoERS9GazTR9vGXg71okp3ywTWHR7aB0X7eftLOC/ZgZ8EEi+gM7GAwz0Xi9+LHpxCTLbzlkP1+Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747665978; c=relaxed/simple;
	bh=b407WGJFqvxUfiereTRtKfvLxMRLPUiIXKAC5mokj5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iqcYAYtV9Ptg8j7+dOLjiPQgRQ1qW/y+KuBGC/dPZx516WNIVxdJjd/4kFT/BVOyjWx24yPiWc4R/rN8Bi2oYD6RfKdv3Wdyw529b9X1y2b/lI0otlTv4+6ay4FGXrb4k98OgTMs0S4g4exbqYYFodYNozGlm7BssYGMicXkikE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s+N62zQ6; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s+N62zQ6"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-601ad859ec0so3569948a12.0
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 07:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747665974; x=1748270774; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QSIIDWdlqzl+xIuuE81sCKCMdcV/4Mu0UdNur2XU8WE=;
        b=s+N62zQ6EvYZvVkcsZPw/j2sVWlbcRutNX+drVU+EyxndAHyc8Ny+fbJFukbwJvRXx
         ioR3AN0QMoTCkPR0QtDWigQEkbQpJhLgxHMO+KxgyEzFyjhDp2njhZ7gBPVH4OtIQIzE
         /gw6OFoEMWNWIgZ9eHvRpVs1dcgo54L5Lvn88JwT4BtEb1lvvf0WcgdVIEbpiE0MbYTS
         ocxxOCnvUu49awCUxJtAKnfqkYpWxnOB96a4yTnv06nq21wp0iW/4+Qn9pzScCh8Sc9x
         voUIptdEbyTCVkEOeg8vEUzBX/zkKh/K92KRGLljqyN8n/W7wWGkA1wRBV3KA0U68GUL
         en5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747665974; x=1748270774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSIIDWdlqzl+xIuuE81sCKCMdcV/4Mu0UdNur2XU8WE=;
        b=TGt/Yt3Lvu6bvDXA3P4DZjOHAPeQEC51TNLGCh5xSoEQ5GjavwmGAsWktoMPWYySOE
         lrwQvyooqmg5jGMLcaV3f3C6jOJKJe7bvLQj9tfuMiik8XaGArNKk9tNmHMVYGHqwCZE
         zv04v3v88utV9GXc30PHRfJ/JuSnBSg8S5+DLUUXBIMNvhdhZpUVvlJZR/Cmssmgn4Ft
         VRegUGYadYwKB1DQW/yjiIhnmoT71holtBeklo6wacH8dn0z6Ck1JysmA6l4alqeBLoZ
         oYV2RSw0P6dx/u7GPxsuJOKXMKCH9l7DeQ8l9Q9k3W88rv8f/wvBURHiceBFvIOpybON
         XbOw==
X-Forwarded-Encrypted: i=1; AJvYcCVwqarVj5tesPrW0LEruVjOPywM/st+/0zvNc91HOynZzSybLmNAiXiZMb+hbehIgdTaMdSQJI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyc0QeiwUvQOvS4kEEjbguH5duX4Z+eGWTaL+D3dgtdaFA27I7Y
	3yw4XSlFL+vSLC2P/Gvcyx7AH8IjKra4gReYt895uFrDWnit56LXQGfoqMLxCpiG5A==
X-Gm-Gg: ASbGncsWSJqkPi8dbyM1+BTBDofnQMUROuneViaGB0k+OCsJxSry3hWS6ORtB06QSsC
	3iMmf7E3qK2KEs7z+AOgPp4dxrvGMWPRv2aui3DEgB1lOQ1wsVGFioW1z6jF8qaioHeyavc68dV
	D6phtHwAhV+ISlGn+Hf9OkT6HneUSc20ikYiyGb0uLZ8gEaA9IrbLHv+/QNCkuvxP0HLroN/N8b
	7oOmplGbkTQZqZ2XMjMoS2zK50rE+pB3rpPdQpplYmPiPnHcjq3use1hUK0s+SFE5FMUdblCWlU
	awryQzXMk4X1ODub/4zzVSH5p1pa2BxzVHGJFXt4YlHhbOZVMj0dO5aHALX71YJ6u8v+pLJQgAA
	5DefhE+BvvA==
X-Google-Smtp-Source: AGHT+IEC3KHkrShBXny3Q7Ir1m0+6kZ8RmzKZn0Y25hUeD6jm+0Maqs5MW8iW3AbNc6hR400bbV0fQ==
X-Received: by 2002:a05:6402:4415:b0:5fb:1c08:d8f7 with SMTP id 4fb4d7f45d1cf-6008a5a8caemr11231023a12.12.1747665974299;
        Mon, 19 May 2025 07:46:14 -0700 (PDT)
Received: from google.com (68.57.204.35.bc.googleusercontent.com. [35.204.57.68])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005a6e5383sm5849380a12.37.2025.05.19.07.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 07:46:13 -0700 (PDT)
Date: Mon, 19 May 2025 14:46:10 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v4 02/10] KVM: arm64: Introduce for_each_hyp_page
Message-ID: <aCtEMoZSCfRAPHXN@google.com>
References: <20250509131706.2336138-1-vdonnefort@google.com>
 <20250509131706.2336138-3-vdonnefort@google.com>
 <86a57cg1bj.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a57cg1bj.wl-maz@kernel.org>

On Friday 16 May 2025 at 13:57:52 (+0100), Marc Zyngier wrote:
> On Fri, 09 May 2025 14:16:58 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > Add a helper to iterate over the hypervisor vmemmap. This will be
> > particularly handy with the introduction of huge mapping support
> > for the np-guest stage-2.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > index eb0c2ebd1743..676a0a13c741 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > @@ -96,24 +96,24 @@ static inline struct hyp_page *hyp_phys_to_page(phys_addr_t phys)
> >  #define hyp_page_to_virt(page)	__hyp_va(hyp_page_to_phys(page))
> >  #define hyp_page_to_pool(page)	(((struct hyp_page *)page)->pool)
> >  
> > -static inline enum pkvm_page_state get_host_state(phys_addr_t phys)
> > +static inline enum pkvm_page_state get_host_state(struct hyp_page *p)
> >  {
> > -	return (enum pkvm_page_state)hyp_phys_to_page(phys)->__host_state;
> > +	return (enum pkvm_page_state)p->__host_state;
> 
> I'm not quite sure why we have this cast the first place. If we are so
> keen on type consistency, why isn't __host_state an enum pkvm_page_state
> the first place?

Purely for cosmetic reasons TBH. The *hyp* state (as you've seen below)
really needs accessors with some logic to decode whatever we store in
hyp_page (the _complement_ of the hyp state in practice). So we
introduced accessors for the *host* state for consistency and obfuscated
the __host_state type in hyp_page to encourage the usage of these
accessors. None of that is strictly necessary, though. And the explicit
cast can go, it is already implicit from the return type of the accessor
and the compiler should be happy enough I think.

> >  }
> >  
> > -static inline void set_host_state(phys_addr_t phys, enum pkvm_page_state state)
> > +static inline void set_host_state(struct hyp_page *p, enum pkvm_page_state state)
> >  {
> > -	hyp_phys_to_page(phys)->__host_state = state;
> > +	p->__host_state = state;
> >  }
> >  
> > -static inline enum pkvm_page_state get_hyp_state(phys_addr_t phys)
> > +static inline enum pkvm_page_state get_hyp_state(struct hyp_page *p)
> >  {
> > -	return hyp_phys_to_page(phys)->__hyp_state_comp ^ PKVM_PAGE_STATE_MASK;
> > +	return p->__hyp_state_comp ^ PKVM_PAGE_STATE_MASK;
> 
> And we don't seem that bothered here.

Cheers,
Quentin
