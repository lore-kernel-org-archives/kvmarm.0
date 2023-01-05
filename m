Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFEB7C
	for <kvmarm@lists.linux.dev>; Thu,  5 Jan 2023 03:00:11 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id o21so8350724pjw.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Jan 2023 19:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bu6yuaCwskYNHXwEqcn9yeZ5SPgG6rLyg1H7QYQGX4Y=;
        b=HgswJJvy2Ss68DpGymvgLT2S5MWmEX6pIAzXCVl4As7J46jR7cQBfnlzki4qipoxgO
         W49ExsatZLCUlkltiVEb42URQDXPefBuGloLErK5SDc1D2hbeoGakC/Iqra5qqZzIHf2
         G3Tw+7UoSnEHVVJsbFxecMDB/SefrzBnNfecU2g6d7hx/ved1y85N/HBLhqrVTSNWM7O
         gE6R03OgWIehc0i1SpKAqqY/XLtNBs+r90q4X5iIVI4qGuSGAc5q45/eeBozeXPSSags
         /z+LqjpVXvzMZgzvzVUor1iM4hL2fjZgc4plf0p/J2tfhJWqNioymszGWTEQr3tDHCoI
         qEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bu6yuaCwskYNHXwEqcn9yeZ5SPgG6rLyg1H7QYQGX4Y=;
        b=7x4x5HG73/PZpEaaIUaSOSM1hlDt1IerbJTstx73hHEj2OBY7La4TYd7DYlckqtPLp
         SSB8NcwFwVpzJ8Wpumg76NK5IEoNppTZKkXsJfT4mLMX9DrmxVXxLbYR7O66JaiMFGA5
         rdImKswJy/rcR44lHQmcAkCxDzMBfIdE/aYLrk0sojIxQHlsb8n4aHJNOGfYpmgcLrtl
         qY/ksqpRo0kZ+zDOFB020GOfQ96lDr0ELOU5dRHbG8NXQqHjYocYwWjM7ZrVh2fQujUT
         rtMLsROeZrDUEMiHHqd9aO5t0vYyFMzGyUdrK3+e8y2HSjWvppfky0Gr1141iXErmMyQ
         tq9A==
X-Gm-Message-State: AFqh2kpWwYfTD7vYgztMDzJHf6Hf+a4xRVv2DgkCofx2ZU/h7R5CtOlT
	kO1fvrn9FWl/GoUDW3IjDkC0daF+oKny3UgIWyk1Gg==
X-Google-Smtp-Source: AMrXdXv7WnKXFndu0n03X9Zi+Ep0aPm3EPNqQPJF+S/hHnu9Lo5DKcOHN20h2Cyfap+CocmSz39Ue0lxJMXJJJUgzSk=
X-Received: by 2002:a17:902:f80c:b0:189:9a36:a5a1 with SMTP id
 ix12-20020a170902f80c00b001899a36a5a1mr4263932plb.154.1672887610625; Wed, 04
 Jan 2023 19:00:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com> <20230103124034.000027aa@Huawei.com>
 <86y1qj7pk9.wl-maz@kernel.org>
In-Reply-To: <86y1qj7pk9.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 4 Jan 2023 18:59:54 -0800
Message-ID: <CAAeT=FyuEuRZn7J5d3gdKGm7G1oEfh1C0heJp6HM7QhHoMid7g@mail.gmail.com>
Subject: Re: [PATCH 0/7] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
To: Marc Zyngier <maz@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20230105025954.IMpmss1vXNhkb5qWYU2BYTN_dojRNwRnBapVlP1ANhA@z>

Hi Jonathan,

On Tue, Jan 3, 2023 at 4:47 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 03 Jan 2023 12:40:34 +0000,
> Jonathan Cameron <Jonathan.Cameron@Huawei.com> wrote:
> >
> > On Thu, 29 Dec 2022 19:59:21 -0800
> > Reiji Watanabe <reijiw@google.com> wrote:
> >
> > > The goal of this series is to allow userspace to limit the number
> > > of PMU event counters on the vCPU.
> >
> > Hi Rieji,
> >
> > Why do you want to do this?
> >
> > I can conjecture a bunch of possible reasons, but they may not
> > match up with your use case. It would be useful to have that information
> > in the cover letter.
>
> The most obvious use case is to support migration across systems that
> implement different numbers of counters. Similar reasoning could also
> apply to the debug infrastructure (watchpoints, breakpoints).

Exactly, this is to unblock migration support between systems
that implement different numbers of counters.
I will include this information in the cover letter when I update
the series for the v2.

Thanks,
Reiji



>
> In any case, being able to decouple the VM from the underlying HW
> within the extent that the architecture permits it seems like a
> valuable goal.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
