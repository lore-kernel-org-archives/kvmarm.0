Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB791B909
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:07:07 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1ae64580e9fso127865ad.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722027; x=1688314027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FMkaKlaqwJTd/DkC7vu4HnfzfgualBygVfd+kRFUQbE=;
        b=EXzDdY8wCSoIjbo7zDJ5uqedhFmxLgsuhWOYuFNfD94ySeRv6kgvmSKfiR+3VJgOwf
         JlF3sXuCY01IOlFGu9yJYlhVtIW8CeqmKiv91WB+qQjVEzjgFBQ5jCloTVeKgIWhnbD9
         2S2aboMLxxMwiCEjxjDPLVUMXdRhIsrhfi1dVMRc/B+IGasEE+HGswhgLAFlwQ5IGSLQ
         IT9OPI/6uwdhD1L0jnPcgkNNH8eiUIlUeNce0kD59mm33k6IteY2Jkv7sMq5v5a2tlyC
         HiOfq0Z5zoLuhIX5iOzPAeDrcMWot97GCDdgiDm7uHQrruvdmZjTXxCYbTDL6WESIpV5
         y70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722027; x=1688314027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMkaKlaqwJTd/DkC7vu4HnfzfgualBygVfd+kRFUQbE=;
        b=XsAzNkY36Ib0vGrm7jj4MuBo45L3yzbeLLM72ablq/cUL3Ie0wAP74+cZdSQpNxb14
         vWCwJ272+xAtNUwCrapHZv72LMs/OjSGTx131zL+dziJCBJUje5dkXrraphOvwjAwbMZ
         NDoTqdunPbL/0LYK4OMWF46ZJgaULkllWctwVCNQMcWhsNX2TSqxrCHah92BHFNN5s0G
         QMXDuLeNJaro8ClAkD8h3tvhT5xYplO8jOdjJBiBK2R8bwpZEW0gafPGOkML/BG0V4zW
         AC2tkUC/+hjGNlylb4Sp6q+sSbIvbUb84S2G4x7MUmWF7/DoFq5TgirPmAMtgx9m2ktF
         wlGw==
X-Gm-Message-State: AC+VfDwsGQ4rac8AwCa6lVT4wUuU9d24FcwhXuSUkW/DNZUBmXVDOnV2
	hDUKn6h9k75RjB2FUieAl0cqqA==
X-Google-Smtp-Source: ACHHUZ7lLej5a+2f9uxJc46tq7XqOd8AldjW9+7ogPzbLS9WKXHYX5ue+jY9JcESPp/XddyAGbTJDw==
X-Received: by 2002:a17:903:684:b0:1af:e5e0:a33e with SMTP id ki4-20020a170903068400b001afe5e0a33emr179424plb.7.1685722026950;
        Fri, 02 Jun 2023 09:07:06 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id o23-20020a17090ac09700b0025900a4b86esm11233pjs.34.2023.06.02.09.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 09:07:05 -0700 (PDT)
Date: Fri, 2 Jun 2023 09:07:01 -0700
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 0/4] KVM: arm64: PMU: Fix PMUVer handling on
 heterogeneous PMU systems
Message-ID: <20230602160701.acbxnwk3owq2ru42@google.com>
References: <20230527040236.1875860-1-reijiw@google.com>
 <87zg5njlyn.wl-maz@kernel.org>
 <20230530125324.ijrwrvoll2detpus@google.com>
 <87mt1jkc5q.wl-maz@kernel.org>
 <20230602052323.shjn3q2rslbuwcmc@google.com>
 <874jnqp73o.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jnqp73o.wl-maz@kernel.org>

> > > Also, didn't you have patches for the EL0 side of the PMU? I've been
> > > trying to look for a new version, but couldn't find it...
> > 
> > While I'm working on fixing the series based on the recent comment from
> > Oliver (https://lore.kernel.org/all/ZG%2Fw95pYjWnMJB62@linux.dev/),
> > I have a new PMU EL0 issue, which blocked my testing of the series.
> > So, I am debugging the new PMU EL0 issue.
> > 
> > It appears that arch_perf_update_userpage() defined in
> > drivers/perf/arm_pmuv3.c isn't used, and instead, the weak one in
> > kernel/events/core.c is used.
> 
> Wut??? How comes? /me disassembles the kernel:
> 
> ffff8000082a1ab0 <arch_perf_update_userpage>:
> ffff8000082a1ab0:       d503201f        nop
> ffff8000082a1ab4:       d503201f        nop
> ffff8000082a1ab8:       d65f03c0        ret
> ffff8000082a1abc:       d503201f        nop
> ffff8000082a1ac0:       d503201f        nop
> ffff8000082a1ac4:       d503201f        nop
> 
> What the hell is happening here???
> 
> > This prevents cap_user_rdpmc (, etc)
> > from being set (This prevented my test program from directly
> > accessing counters).  This seems to be caused by the commit 7755cec63ade
> > ("arm64: perf: Move PMUv3 driver to drivers/perf").
> 
> It is becoming more puzzling by the minute.
> 
> > 
> > I have not yet figured out why the one in arm_pmuv3.c isn't used
> > though (The weak one in core.c seems to take precedence over strong
> > ones under drivers/ somehow...).
> > 
> > Anyway, I worked around the new issue for now, and ran the test for
> > my series though. I will post the new version of the EL0 series
> > tomorrow hopefully.
> 
> I have a "fix" for this. It doesn't make any sense, but it seems to
> work here (GCC 10.2.1 from Debian). Can you please give it a shot?
> 
> Thanks,
> 
> 	M.
> 
> From 236ac26bd0e03bf2ca3b40471b61a35b02272662 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Fri, 2 Jun 2023 09:52:25 +0100
> Subject: [PATCH] perf/core: Drop __weak attribute on arch-specific prototypes
> 
> Reiji reports that the arm64 implementation of arch_perf_update_userpage()
> is now ignored and replaced by the dummy stub in core code.
> This seems to happen since the PMUv3 driver was moved to driver/perf.
> 
> As it turns out, dropping the __weak attribute from the *prototype*
> of the function solves the problem. You're right, this doesn't seem
> to make much sense. And yet...
> 
> With this, arm64 is able to enjoy arch_perf_update_userpage() again.

Oh, that's interesting... But, it worked, thank you!
(With the patch, the disassembles of the kernel for
arch_perf_update_userpage look right, and my EL0 test works fine)


> And while we're at it, drop the same __weak attribute from the
> arch_perf_get_page_size() prototype.

The arch_perf_get_page_size() prototype seems to be unnecessary now
(after the commit 8af26be06272 "erf/core: Fix arch_perf_get_page_size()").
So, it appears that we could drop the prototype itself.

Thank you,
Reiji


> 
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/linux/perf_event.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index d5628a7b5eaa..1509aea69a16 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1845,12 +1845,12 @@ int perf_event_exit_cpu(unsigned int cpu);
>  #define perf_event_exit_cpu	NULL
>  #endif
>  
> -extern void __weak arch_perf_update_userpage(struct perf_event *event,
> -					     struct perf_event_mmap_page *userpg,
> -					     u64 now);
> +extern void arch_perf_update_userpage(struct perf_event *event,
> +				      struct perf_event_mmap_page *userpg,
> +				      u64 now);
>  
>  #ifdef CONFIG_MMU
> -extern __weak u64 arch_perf_get_page_size(struct mm_struct *mm, unsigned long addr);
> +extern u64 arch_perf_get_page_size(struct mm_struct *mm, unsigned long addr);
>  #endif
>  
>  /*
> -- 
> 2.39.2
> 
> 
> -- 
> Without deviation from the norm, progress is not possible.
