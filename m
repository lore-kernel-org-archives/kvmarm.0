Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF6123A0
	for <kvmarm@lists.linux.dev>; Tue, 10 Jan 2023 05:50:35 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id r18so7471601pgr.12
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 21:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JOUhOZSlmXFHrfw3S1GaBPaFMlh3z5ZEWqn41g9S5Ko=;
        b=UaycJRgTsqOzVALgtWgM56Ei4nmGn5Q3uZXaA4EexEuuDjZjCiylhl2zJXf7j/oNX7
         +a/ZwP52116qTxu0kJcdU3ICt3P+LoMeY2KfkGEwOSkwnwSBSpYlF7c6uizTgVp0rsdg
         07iqzbJIv4nie+SyXz/KKrvWwO6jqNSeGGeGPhedBOvvGBZ8NljIOv9wla80O0xqvtC7
         Sl9idgpSWAO/WCn8qJMdm71A6lOwUO+uBa8t6XgomgKhDodfar6mlopAqw3SASe6cagJ
         DIp7HtYTM/P27sd9hTpm1E1+JAil0LhGqNzC8obfspIeiLWwuoOEjcSggHbbAfQ6zRBp
         6USA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JOUhOZSlmXFHrfw3S1GaBPaFMlh3z5ZEWqn41g9S5Ko=;
        b=Z9b21FujVj43hpY74TFwOgeej851fIXHSZI5Nk3imvWbt2A2JPnvAhKBZrWT1tPYYk
         9CDESSbB4YdPBjKtmiajpKlCJBq4u7VjJFX3R3tZwaIDgVgdiG/tDdIXjW2BZCdFqJ/e
         s5n5Q8DCyNbMiDfWJ5XWXQQ9vntwEx2YDXL+OIYsQy3C7+Md51OT6IS2EO3QdvxqaEuH
         B1dIgzF9BcIMLoX3yaWnqA23dEW34eoZMD2ND5jAT9h1mBmkjAeYTxhlQofBy2cTf2e+
         zFJQQ8xHyY/3+msLjNFCCdTuy/I4RWBm89Nr9naUyTWsNNegVKbiLd2aNM8TDAL6tkyU
         7GeQ==
X-Gm-Message-State: AFqh2kokBQk3eOaEzEKh/6/490cbYMXq2/gwbuWfCGA1rMU0ol7OBABS
	Q1ftHQdXIj3sGJdFcJagn7j+VAma/RZPHEvVRXQcog==
X-Google-Smtp-Source: AMrXdXuiSTzgHe3ZlWnQSlCLlfsU67QOuqUdkb3Vh86x1KlYT9Dm7UrWXt5myDp5MN0bTM7uJTy2K61dylYmwPBX0eY=
X-Received: by 2002:a62:5283:0:b0:576:a748:8fa3 with SMTP id
 g125-20020a625283000000b00576a7488fa3mr5121698pfb.37.1673329834528; Mon, 09
 Jan 2023 21:50:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com> <20221230035928.3423990-2-reijiw@google.com>
 <Y7sUggVq+D6R82qK@thinky-boi>
In-Reply-To: <Y7sUggVq+D6R82qK@thinky-boi>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 9 Jan 2023 21:50:18 -0800
Message-ID: <CAAeT=FwRO49JdANRWGJBj41ef+YyokOw6rw6VO174ESJrcKv7A@mail.gmail.com>
Subject: Re: [PATCH 1/7] KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Sun, Jan 8, 2023 at 11:07 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Thu, Dec 29, 2022 at 07:59:22PM -0800, Reiji Watanabe wrote:
> > On vCPU reset, PMCNTEN{SET,CLR}_EL1 and PMOVS{SET,CLR}_EL1 for
> > a vCPU are reset by reset_pmu_reg(). This function clears RAZ bits
> > of those registers corresponding to unimplemented event counters
> > on the vCPU, and sets bits corresponding to implemented event counters
> > to a predefined pseudo UNKNOWN value (some bits are set to 1).
> >
> > The function identifies (un)implemented event counters on the
> > vCPU based on the PMCR_EL1.N value on the host. Using the host
> > value for this would be problematic when KVM supports letting
> > userspace set PMCR_EL1.N to a value different from the host value
> > (some of the RAZ bits of those registers could end up being set to 1).
> >
> > Fix reset_pmu_reg() to clear the registers so that it can ensure
> > that all the RAZ bits are cleared even when the PMCR_EL1.N value
> > for the vCPU is different from the host value.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 10 +---------
> >  1 file changed, 1 insertion(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index c6cbfe6b854b..ec4bdaf71a15 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -604,19 +604,11 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
> >
> >  static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> >  {
> > -     u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
> > -
> >       /* No PMU available, any PMU reg may UNDEF... */
> >       if (!kvm_arm_support_pmu_v3())
> >               return;
> >
> > -     n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> > -     n &= ARMV8_PMU_PMCR_N_MASK;
> > -     if (n)
> > -             mask |= GENMASK(n - 1, 0);
> > -
> > -     reset_unknown(vcpu, r);
> > -     __vcpu_sys_reg(vcpu, r->reg) &= mask;
> > +     __vcpu_sys_reg(vcpu, r->reg) = 0;
>
> I've personally found KVM's UNKNOWN reset value to be tremendously
> useful in debugging guest behavior, as seeing that value is quite a
> 'smoking gun' IMO.
>
> Rather than zeroing the entire register, is it possible to instead
> derive the mask based on what userspace wrote to PMCR_EL1.N instead of
> what's in hardware?

Yeah, it's feasible.
Then, I am considering having KVM to clear new RAZ bits of those
registers based on the new PMCR_EL0.N value that userspace sets
when userspace updates PMCR_EL0.N, as clearing the new RAZ bits
should be done anyway by either KVM or userspace.
What do you think ?

Thank you,
Reiji
