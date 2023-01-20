Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B80020EF
	for <kvmarm@lists.linux.dev>; Fri, 20 Jan 2023 18:53:20 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id c85so4655609pfc.8
        for <kvmarm@lists.linux.dev>; Fri, 20 Jan 2023 10:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hbVkhmbwrxHdRnc6988uVhgGX0OwIVVngeM3AP0vwwM=;
        b=YyZ2GQPJLnmNMqIOhj29cQEAc2wXHLAdR8q265VO2GVcMv9W4doftcJuxezu6FeMMd
         AmvJJde8mojg96TsP8yugvRvdUMypU+170DfXgEIIODZznKsXIv7KjhdxJtQQfUna4ml
         r8xVDRNxdf+XoQ1l7NSaB7kXGnsHTw+Hk8AtKsulhEEphZeUm0ozgiFovnLOOkFAuYF/
         /Tf2H5rNtukMv2qaQXMg6PMeICYvsx3baVQ4CeuzEiQYTpGAJhgli2+abXL+xZp8BgT3
         IG+5Kx8QsAJv0F31/SIIce3oLwYRLcg57DTbur3J+NT5ab+qdmwGwrp5vH9XG3ECQqwC
         TX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hbVkhmbwrxHdRnc6988uVhgGX0OwIVVngeM3AP0vwwM=;
        b=0dEzlXVQ3E6AaEhmI4zhkYJQXFS0OS57e0IW9ZS7bcaiNyOHUu8v/9wiuDnGI+gO5c
         N4xi/3DPsRWxgy2T3JYIDan7TQzRB7bK/kj0FWpwrPlmqcQqu5rp9z4lRDHdLnNuBXZ1
         2NYl4rX1nS+CzvjMmjcYHCVievdlnLS+RuFEgOWVieAW3uCGs850esW5BKNev3ZZgB2u
         2ibhoKS4n8DRWLVkhJRdeYWGDGTYXYqDRjhskKeGUQYkUIZN2uqkOlk6Ith5WeCD7rRe
         akicSchTfj7+FIJQpCd4Vz/aSGodP5IE6X6eVQakrjvLt7Wcu3Mpcg0traTWVTppo3rg
         2pwA==
X-Gm-Message-State: AFqh2krxFdPl5SM00y9EN/UJBBgpaP4wzJg+kyMCvGAX11Z3QSVgFbGZ
	GKfVPIOx+pLRpFu4YqL0TtvDi3lsawaO4KDzd5+TaQ==
X-Google-Smtp-Source: AMrXdXtaABkqdOaqTa0aNwcY5jjakms9UPj5X9miquUpJAfFjmwpqsB8bwMVYIqvgg7fGfBCNdeZ9t7RkQfzzZfa1Aw=
X-Received: by 2002:a62:6084:0:b0:582:392e:8bbf with SMTP id
 u126-20020a626084000000b00582392e8bbfmr1484138pfb.75.1674240799468; Fri, 20
 Jan 2023 10:53:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com> <20230117013542.371944-4-reijiw@google.com>
 <Y8ngqRHhiXHjc0vA@google.com> <86pmb9mmkv.wl-maz@kernel.org> <Y8rXx+7EUob7qPXh@google.com>
In-Reply-To: <Y8rXx+7EUob7qPXh@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 20 Jan 2023 10:53:02 -0800
Message-ID: <CAAeT=FyYspSieevHO3gD_Snvn19HXdzbUD3z-Q=1qQ1BBX-Jjw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value
 on vCPU reset
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver, Marc,

Thank you for the review!

On Fri, Jan 20, 2023 at 10:05 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hey Marc,
>
> On Fri, Jan 20, 2023 at 12:12:32PM +0000, Marc Zyngier wrote:
> > On Fri, 20 Jan 2023 00:30:33 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > > I think we need to derive a sanitised value for PMCR_EL0.N, as I believe
> > > nothing in the architecture prevents implementers from gluing together
> > > cores with varying numbers of PMCs. We probably haven't noticed it yet
> > > since it would appear all Arm designs have had 6 PMCs.
> >
> > This brings back the question of late onlining. How do you cope with
> > with the onlining of such a CPU that has a smaller set of counters
> > than its online counterparts? This is at odds with the way the PMU
> > code works.
>
> You're absolutely right, any illusion we derived from the online set of
> CPUs could fall apart with a late onlining of a different core.
>
> > If you have a different set of counters, you are likely to have a
> > different PMU altogether:
> >
> > [    1.192606] hw perfevents: enabled with armv8_cortex_a57 PMU driver, 7 counters available
> > [    1.201254] hw perfevents: enabled with armv8_cortex_a53 PMU driver, 7 counters available
> >
> > This isn't a broken system, but it has two set of cores which are
> > massively different, and two PMUs.
> >
> > This really should tie back to the PMU type we're counting on, and to
> > the set of CPUs that implements it. We already have some
> > infrastructure to check for the affinity of the PMU vs the CPU we're
> > running on, and this is already visible to userspace.
> >
> > Can't we just leave this responsibility to userspace?
>
> Believe me, I'm always a fan of offloading things to userspace :)
>
> If the VMM is privy to the details of the system it is on then the
> differing PMUs can be passed through to the guest w/ pinned vCPU
> threads. I just worry about the case of a naive VMM that assumes a
> homogenous system. I don't think I could entirely blame the VMM in this
> case either as we've gone to lengths to sanitise the feature set
> exposed to userspace.
>
> What happens when a vCPU gets scheduled on a core where the vPMU
> doesn't match? Ignoring other incongruences, it is not possible to
> virtualize more counters than are supported by the vPMU of the core.

I believe KVM_RUN will fail with KVM_EXIT_FAIL_ENTRY (Please see
the code that handles ON_UNSUPPORTED_CPU).

> Stopping short of any major hacks in the kernel to fudge around the
> problem, I believe we may need to provide better documentation of how
> heterogeneous CPUs are handled in KVM and what userspace can do about
> it.

Documentation/virt/kvm/devices/vcpu.rstDocumentation/virt/kvm/devices/vcpu.rst
for KVM_ARM_VCPU_PMU_V3_SET_PMU
has some description for the current behavior at least.
(perhaps we may need to update documents for this though)

Now I'm a bit worried about the validation code for PMCR_EL0.N
as well, as setting (restoring) PMCR_EL0 could be done on any
pCPUs (even before using KVM_ARM_VCPU_PMU_V3_SET_PMU).

What I am currently looking at is something like this:
 - Set the sanitised (min) value of PMCR_EL0.N among all PMUs
   for vCPUs by default.
 - Validate the PMCR_EL0.N value that userspace tries to set
   against the max value on the system (this is to ensure that
   restoring PMCR_EL0 for a vCPU works on any pCPUs)
 - Make KVM_RUN fail when PMCR_EL0.N for the vCPU indicates
   more counters than the PMU that is set for the vCPU.

What do you think ?

Thank you,
Reiji
