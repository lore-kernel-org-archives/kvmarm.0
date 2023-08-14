Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACB81842
	for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 07:40:09 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-3fe4b45a336so36376615e9.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 00:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691998807; x=1692603607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2afZnyDCrINJ3gbOl+hmDHdduGv2gb+pC3/Cl898EMU=;
        b=rNv4SZ9DD4JJgoPgEPxYSgWW0nEP0T+Fp9HhbNAxAbGYa0YQsE1nGYv76l/rQtb8Mo
         d1dKqM0OVPAXtbidCKSmRLtA6ZUliYFNGKAS0KYMrM8Blr+ZHlNwdQTb0hkHBQARRWmm
         6+rr9YBdH0fNvEox5Sp7kvCJGXBinOh4DI85gH0tDRTBREZaTxodtJG9Y+qzeCPUKlwx
         yvsgLF0NjdKq+Rxa6a3xBvdu0815oZU6Dmv+18JlAxbtkHee0+iv3I9yU4mOlfVRaqVZ
         iwMZK1KEfBJmpBG24pCc+PRdolZLex+G6bLftXfhtv9q/n4z/qKh64Iu3BTJ8tgEWVUQ
         07kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691998807; x=1692603607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2afZnyDCrINJ3gbOl+hmDHdduGv2gb+pC3/Cl898EMU=;
        b=kRBX7+bcU0LdZYHfr6dBTcflz7IAh2wDKsc7mXpF/HCGr1yF0uaWeER744m8QiT+lx
         JsNshNVKPb255wM0Vf9/1aTO/bdlAd+eVyUinR78cM6tYG2x+Bywtxde2KS11XdFjLfU
         KBWx61DW1OOFokINGvJ3QV16Hk1XxRoLv0Cj1sM4g9Io33Z+/1Ud/iDedkwvM5b6n2s7
         BOZZJJCW9LPIxKmQIJpC8EoXq3mmOriBdVhulrEqo1INmY7x585oajZ6QHobQy7uPF+n
         zeVQztpzdCUesEeWyt2oqGzVeZIVbTN0cBqlpmBRNo5idEyQkFIQweUfnJRQLZKIe/g0
         gp7w==
X-Gm-Message-State: AOJu0YxTvrmOFt9iQth+4WLJnppXTOL+muDRBScjDTgfEjc/yKmsD7VL
	C9aGc5VQGchCUazs9VIT4fGXnQ==
X-Google-Smtp-Source: AGHT+IHPQn7b/waEqxumGoPwt2Usyo7XuvXA7SasCbtEmIiyAPbtjYjI9Xn0ZwtQswpr36KMUaNDLg==
X-Received: by 2002:a05:6000:106:b0:319:6e58:7095 with SMTP id o6-20020a056000010600b003196e587095mr3635276wrx.66.1691998807372;
        Mon, 14 Aug 2023 00:40:07 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id q11-20020adff94b000000b00317c742ca9asm13350110wrr.43.2023.08.14.00.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 00:40:06 -0700 (PDT)
Date: Mon, 14 Aug 2023 08:40:01 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev,
	qperret@google.com, smostafa@google.com,
	linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
	will@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Remove size-order align in the nVHE hyp
 private VA range
Message-ID: <ZNnaUV7d4XhjflAr@google.com>
References: <20230811112037.1147863-1-vdonnefort@google.com>
 <CAC_TJvcwWRSs-YcP-_awLn2VU9m-AT8HzSq+aKHvSPkpRw5=OA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC_TJvcwWRSs-YcP-_awLn2VU9m-AT8HzSq+aKHvSPkpRw5=OA@mail.gmail.com>

[...]

> > +int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr)
> > +{
> > +       unsigned long base;
> > +       size_t size;
> > +       int ret;
> > +
> > +       mutex_lock(&kvm_hyp_pgd_mutex);
> > +       /*
> > +        * Efficient stack verification using the PAGE_SHIFT bit implies
> > +        * an alignment of our allocation on the order of the size.
> > +        */
> > +       size = PAGE_SIZE * 2;
> > +       base = ALIGN_DOWN(io_map_base - size, size);
> > +
> > +       ret = __hyp_alloc_private_va_range(base);
> > +
> > +       mutex_unlock(&kvm_hyp_pgd_mutex);
> > +
> > +       if (ret) {
> > +               kvm_err("Cannot allocate hyp stack guard page\n");
> > +               return ret;
> > +       }
> > +
> > +       /*
> > +        * Since the stack grows downwards, map the stack to the page
> > +        * at the higher address and leave the lower guard page
> > +        * unbacked.
> > +        *
> > +        * Any valid stack address now has the PAGE_SHIFT bit as 1
> > +        * and addresses corresponding to the guard page have the
> > +        * PAGE_SHIFT bit as 0 - this is used for overflow detection.
> > +        */
> > +       ret = __create_hyp_mappings(base + PAGE_SIZE, PAGE_SIZE, phys_addr,
> > +                                   PAGE_HYP);
> > +       if (ret)
> > +               kvm_err("Cannot map hyp stack\n");
> 
> Should we reset the io_map_base if the mapping failed here as well?

I didn't do it on purpose. Here, I'm releasing the lock and I didn't want to add
a non locked __create_hyp_mappings() just for that reset that is probably not
binging much.

> 
> Otherwise lgtm, Reviewed-by: Kalesh Singh <kaleshsingh@google.com>

Thanks for the review!

> 
> Thanks,
> Kalesh
> 
> > +
> > +       *haddr = base + size;
> > +
> > +       return ret;
> > +}
> > +
> >  /**
> >   * create_hyp_io_mappings - Map IO into both kernel and HYP
> >   * @phys_addr: The physical start address which gets mapped
> >
> > base-commit: 52a93d39b17dc7eb98b6aa3edb93943248e03b2f
> > --
> > 2.41.0.640.ga95def55d0-goog
> >
