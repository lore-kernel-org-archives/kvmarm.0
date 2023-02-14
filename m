Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF63C0A3
	for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 21:59:46 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id b21so355683qtr.13
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 13:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G9CGSOp3cnMbqbIfyoqOt2E4VaTIulHyrGeP2LlvMsY=;
        b=ERbDpCpt2Tk4VGox/mEQVipV7nprtmIHi/II9V7O+StTtFAxdKi65RNqDJcFbNVb1X
         9CQJYjwsoLZrgFVz+cKyqcItgaS2yg/xt94wT430K6f4WoEDlHPS6qoY6ybpy6x00JBh
         SdYrx5Rf/RQLfo47T+A2IxYeoz2D6yKkjNahTRQQOqJyGCn4qrG1WOxPEio99ROGwJZK
         H6jCUN7og67rkf4ykYgx7cSGFeMzQa3kIfaAWSdZI4iLICf18nt6ZWr9zwO1zEQDd/1O
         CjRHt4nwDjXPZ1TmIJNvu/1FjNBKa9jkUWpJal1G/dJCSC1KFc0lzY0xCEtcs3HhHJNv
         +R/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9CGSOp3cnMbqbIfyoqOt2E4VaTIulHyrGeP2LlvMsY=;
        b=quOwKHuue0mNl81PA0e2V7PrA7Haw4jiDGZo1OLJ2krz/M4/i+RqSgZFwK5xeT9/WN
         ATtldB/IvA6OSZ/x+LrGvq5ngz6MQOcua/p758vZ4VfvhwNnN9bNNmfg5tTBiInhG1v0
         zueuHYkOKeT3j6amjGWbB/LoGx1y4ZFj031ot3AmMfykeUFx+tr/1DnyELcXGLLOlPyi
         wsKYneg56AzZG+jLrZqlfI6ADxNrqTsUq89Qtn8+zT66WQPIQ3TFA0o6DlMi5cd1hPNV
         +LUabp4dKMZR347W6YRr0UfbMr9/BOm9Sa9hMshjDDvtR7SFTZxuxQotjGsJptOggV3V
         /85Q==
X-Gm-Message-State: AO0yUKVDGR/EY6+lZQu0I3xYtQuOZ8+Dzg/bqKGPym+1YDRHoOz3BLTg
	9Ihm1zsSuZc+LnelLDkYZdpJAgMy4IBg6D8y8k3PXQ==
X-Google-Smtp-Source: AK7set+Gv3LXwX2MMsG93isRy47g9jzZQtswzEk9WEDLngAXTM0ZyBRQotqzN6+CLBFyCY5T0/n3zT94zcb6C5sRpEU=
X-Received: by 2002:a05:622a:148c:b0:3ba:240b:99ad with SMTP id
 t12-20020a05622a148c00b003ba240b99admr543512qtx.65.1676411985281; Tue, 14 Feb
 2023 13:59:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <1a3afa6d-3478-31dd-6f34-52075875c2fa@redhat.com>
 <Y+s5PwV1l60jXal1@linux.dev>
In-Reply-To: <Y+s5PwV1l60jXal1@linux.dev>
From: Ricardo Koller <ricarkol@google.com>
Date: Tue, 14 Feb 2023 13:59:34 -0800
Message-ID: <CAOHnOrzXjwJ+WZJhvBQFT3y6iLHMAD54BveVCdhy0zksmUcZhQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] Implement Eager Page Splitting for ARM.
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Gavin Shan <gshan@redhat.com>, pbonzini@redhat.com, maz@kernel.org, 
	oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 13, 2023 at 11:33 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Gavin,
>
> On Tue, Feb 14, 2023 at 04:57:59PM +1100, Gavin Shan wrote:
> > On 2/7/23 3:58 AM, Ricardo Koller wrote:
>
> <snip>
>
> > > Eager Page Splitting fixes the above two issues by eagerly splitting
> > > huge-pages when enabling dirty logging. The goal is to avoid doing it
> > > while faulting on write-protected pages.
>
> </snip>
>
> > I'm not sure why we can't eagerly split the PMD mapping into 512 PTE
> > mapping in the page fault handler?
>
> The entire goal of the series is to avoid page splitting at all on the
> stage-2 abort path. Ideally we want to minimize the time taken to handle
> a fault so we can get back to running the guest. The requirement to
> perform a break-before-make operation to change the mapping granularity
> can, as Ricardo points out, be a bottleneck on contemporary implementations.
>
> There is a clear uplift with the proposed implementation already, and I
> would expect that margin to widen if/when we add support for lockless
> (i.e. RCU-protected) permission relaxation.

There's also the issue of allocating 513 pages on fault when splitting PUDs.

>
> > In the implementation, the newly introduced API
> > kvm_pgtable_stage2_split() calls to kvm_pgtable_stage2_create_unlinked()
> > and then stage2_map_walker(), which is part of kvm_pgtable_stage2_map(),
> > to create the unlinked page tables.
>
> This is deliberate code reuse. Page table construction in the fault path
> is largely similar to that of eager split besides the fact that one is
> working on 'live' page tables whereas the other is not. As such I gave
> the suggestion to Ricardo to reuse what we have today for the sake of
> eager splitting.
>
> --
> Thanks,
> Oliver
