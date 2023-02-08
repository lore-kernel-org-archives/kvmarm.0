Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7380D6AB9
	for <kvmarm@lists.linux.dev>; Wed,  8 Feb 2023 18:05:11 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id j32-20020a05600c1c2000b003dc4fd6e61dso2068707wms.5
        for <kvmarm@lists.linux.dev>; Wed, 08 Feb 2023 10:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x02q9uoJGB5PTSSJIw24o9Jea6+NDxOC/jyY+iHe9oc=;
        b=gh+nF0QW3SIJkW9ssaIlbkf3N6mrKaJ3LTaZ71UwOljqiYQrul1BIvUGeD1LCV4WJZ
         ej+6avKgIiMQnwCegA5tOEyVdKsunGK6bsCAz0+F+gRwTqy7EVyW8XtWtWrrESNxAGm2
         wONQv6MTdhZFLo3P/or8VBY8NS65/biAGbmVK+UkmJ1I54r8uELpnLRSZhN8oktuh7z2
         6Z7DHnCMVG/XVZeEv5L7gMU1EXnMAkDhLl/q1WOyv464UslSDJwA8aTaZXLXYyLI7Fde
         Jdy0Ny4Lvj4TFk/Rz5mPg1YlAM1Wdt4PEOl1hRWxueSQkUE1B9Q7mgUcNAwT8lFeSQKG
         B0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x02q9uoJGB5PTSSJIw24o9Jea6+NDxOC/jyY+iHe9oc=;
        b=muN00oW0yr4JEKBVKpmSp0cRfBugf9+85B+B/Vt7qRfBX6eM3Vcz2CIYMdl07L5did
         VkMVl7GKRloTafhwmvw5YuIw9UOcv7+jA85oKA2m4cheTr4JFucVml50aeApWEp3FMre
         WH1mPg8Jc7V/nBJecX0PpkwBJ+cVRCHkHCBuGwCNI+rrf7vVP18W63wghuvT2zoeP/4N
         yZLDBsvKjwQEHx9aKJAV7naFGhsnj2BEOLZldOrAmyjHyCIEKiM3dhIXDbCgECWFuM7k
         0tI6t0nKB94NsU3wjyqNnNWCrfLhkm4Yj5ByZr4YGmz9BhSzNLgL9faGOwoqsdyGar/D
         DILw==
X-Gm-Message-State: AO0yUKVy/OU3f1YueUw03mEcR9Jt4AoSQhFEgX79iPQUfwsQck64HoQs
	B4rUHpwkxHqMEfBkiTnHmygNVg==
X-Google-Smtp-Source: AK7set+W06Prs3ldglNlH/CR5qGN6zMpZQMUiKbzJFHQN9NR2HUt4HV6QpQ6PGtb3inJ39rw2JKPfw==
X-Received: by 2002:a05:600c:1609:b0:3dc:53a2:2690 with SMTP id m9-20020a05600c160900b003dc53a22690mr7373934wmn.7.1675879509767;
        Wed, 08 Feb 2023 10:05:09 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id bg2-20020a05600c3c8200b003db0bb81b6asm3009865wmb.1.2023.02.08.10.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:05:09 -0800 (PST)
Date: Wed, 8 Feb 2023 18:05:04 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 19/45] KVM: arm64: iommu: Add domains
Message-ID: <Y+PkUKe72Q2WJGlp@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-20-jean-philippe@linaro.org>
 <Y+JOhEfi8mu1RuOt@google.com>
 <CAFgf54q+R6nQBUAz9Quj8pQiTgKe7R_7BdQ=PWWay0WqDVzL1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFgf54q+R6nQBUAz9Quj8pQiTgKe7R_7BdQ=PWWay0WqDVzL1Q@mail.gmail.com>

On Wed, Feb 08, 2023 at 12:31:15PM +0000, Mostafa Saleh wrote:
> On Tue, Feb 7, 2023 at 1:13 PM Mostafa Saleh <smostafa@google.com> wrote:
> 
> > I was wondering about the need for pre-allocation of the domain array.
> >
> > An alternative way I see:
> > - We don’t pre-allocate any domain.
> >
> > - When the EL1 driver has a request to domain_alloc, it will allocate
> > both kernel(iommu_domain) and hypervisor domains(kvm_hyp_iommu_domain).
> >
> > - In __pkvm_host_iommu_alloc_domain, it will take over the hyp struct
> > from the kernel (via donation).

That also requires an entire page for each domain no?  I guess this domain
table would only be worse in memory use if we have fewer than 2 domains,
since it costs one page for the root table, and then stores 256 domains
per leaf page.

What I've been trying to avoid with this table is introducing a malloc in
the hypervisor, but we might have to bite the bullet eventually (although
with a malloc, access will probably worse than O(1)).

Thanks,
Jean

> >
> > - In all other hypercalls, the kernel address of kvm_hyp_iommu_domain will
> > be used as domain ID, which guarantees uniqueness and O(1) access.
> >
> > - The hypervisor would just need to transform the address(kern_hyp_va)
> > to get the domain pointer.
> 
> 
> This actually will not work with the current sequence, as we can't
> guarantee that the domain_id sent later from the host is trusted, and as
> the domain points to the page table this can be dangerous, I will have a
> closer look to see if we can make this work somehow.
