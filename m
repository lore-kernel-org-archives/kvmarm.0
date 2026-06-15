Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DD3368D46
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 10:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781520771; cv=pass; b=EJkXZ4wCc06EID9oP3P4qpo1vS5pQ1DdjCOLVUI2xAiXhanZzDq/SZA7grsipe5X5N3zQY6pe84JwGAPWankMttEEf0bF1JV4H3OAF8RhV4bPsMrKXpOqd0z0tNhwnKececSoYS4T+KCrAYrhrMMBtiL4GDBOUHIootGpPyaEOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781520771; c=relaxed/simple;
	bh=K0v0Hr2YaujIKTE764VC7CK5/58QWk0Obv39/UL3pN8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jBiUwdNMLQyy8DCGNYwoRfy6ZMGtQN8K9OseHa0FSZWGUizlN8JeKoZyVyU6lqp4sxEndd3aUN3MPWu5mfV++4Q0xQIi9ZpSMQDpnrhoNciULOu4+jtoQOqaWZBOxT9kKcN/6p7OG2aXtgc7KqQtvpMeaLCxquOUKhZUqjgImTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NOUYT0dL; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NOUYT0dL"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51765531803so38151cf.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 03:52:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781520768; cv=none;
        d=google.com; s=arc-20240605;
        b=guXfPtr4V16awJsx6gyZj2GNY/e8+7AgZqKzBw/PY7uS0IP2o/KCMpwdz8LL9YN8+2
         gy0QVzPr8knxx36m7Whl3QR4y6E1NEgPnwPdY/M+FJsnyrwyJWNPe/lAviCK2BRkx2Ph
         zdwuhe7h1ySdT4tYHS5eZrqAJzMR4TdAliXb23GyC0rp6KF/ZY/SAbIfD4GByDBYFGk4
         EefFfpeHrVYDMdnWDm7huknOm1wACFKgyHeHU+MC8p40U8rPn4fpaoW/Xu//kb1feSOS
         Y4Nw2IpsJ11B/qSyyWQv43yhDpHMDqwUKaadMlVHaQW/zRpc+OEKvwYyJargbYTWjgbq
         zbZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1r8iNDwZiaBP/vjXiAImEcIzE/V77CaDhl9Jn5aHp7c=;
        fh=f7PMhl/bRHKuuukL9mfycexqdD5AUGYIp1mTVCo/QlE=;
        b=V395L2ZEopz/yVez9g1UFYdWkpGkq1bFMU3b50EywjXYuIiNCVaYXPEWJeFLius/hx
         r5Wv+IG1KTKPp4Ume/7wklJ2FjD2O5mL5JxRHfFoouh2pamVs5sJg+uKiUOl3rR5PmIt
         4hV/88LosoN5Tll2kK1Nra78gW6+ox+f/Cz8Si49+s752HMbwbP5wD9jp/qFmd/U+Hsd
         mr9q9pH24cvDZlsFog5cz5NAp5rgcJ1u6vTnllD9UPuyFVwNO9ZBk2DjDafjxjBNgS9y
         bP1mSyFDsraItU1PyY5LnhXsYfbulUaj4XX3VrdvPrAlXQTcp9RFRY7Hlo0G+o6bUsZq
         hIIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781520768; x=1782125568; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1r8iNDwZiaBP/vjXiAImEcIzE/V77CaDhl9Jn5aHp7c=;
        b=NOUYT0dLZ3UWDh3OiWCHned47U/ZUcJ4CltnrcCnFjiScWKTI671zc6zVoSmbJSd++
         g8F/p8o0MfGJbq0CVb/N03AJPawLZ0H8Mn5bsgerH7ewAKszKoFW1MgJgf70EwvX7Znz
         QVr2/3VCd6nbhKFgkAQXaVF9wTdw33JaVLbciO41M/igKtt7kMPGOFkvofG9mWAnZm3o
         XpREj8EfMyFPoN/E2hxw5e1IMO597HXigqFez7Tk8uNihhnhgD8UowNLFAf+dPdUkGCw
         o60FIHHNhK71b/srC/SMWUZ2TKJD5N6mL7HYwuy+j6tbQER4+oO+ObUmloUOJmDW+D2K
         qasA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781520768; x=1782125568;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1r8iNDwZiaBP/vjXiAImEcIzE/V77CaDhl9Jn5aHp7c=;
        b=W94qpkPF+KqRzh/kzMlOW7y5Hk941VzzOJbSQ0jI/tgEd26XeGw4ySm6BlqYR37L6b
         AxjzInAOePKqiiXHnVc8FXl4d0gsNrxEWkkqbQXVSn5tUE1fsFvpuaBTCrV2uHrimMNR
         5v4DmFipCPj1HH1kBa1NBDFk+uRLdtsYBqLm5UQ9nUwncB5iek0D/cCWZlCS51KtrORi
         jHiyoYugzFI0QIZt7XSsD4yNE++dNJqxhEuArDLBlSzyO5akpy7dCd2lJRf0caT+X/my
         5dwMPxgRCNv5cXXldj99eN9E7tmfJJsifCugGt73056YgBnaTz9Na2kDP4usKjZZ8DLR
         IEKQ==
X-Forwarded-Encrypted: i=1; AFNElJ+cRX9JsOo9BU5+d45h4ulcCvUWbvXQH24Lni0LwfYs3fGXZ1K/jt4bxYR6j62dXQAvxJWOdjk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXRnSZRxyqSMpXMQw/5SYy1pQB46R7ArSvp+f6vf6XGJqQWNXn
	adQdRrcNMalPJ9swl4eWv8f/+kJeL1y7d5Pm/RjYI4ZyR8PkART4jjZooav9Y6bAerowwR/VBZ0
	9IQVszOchtKwwJ5szrqj2e7qSa65I0984NA8chxGC
X-Gm-Gg: Acq92OFIieUZTLMbl3lEoE2OZgK4f7kKoC5cn7Fe2mXTaBppVsyEfzRaDpg4PahFQ11
	rJwGpUQL3w2AJfHn0h6ElEq7P+8EyIhM8js9ghq7K4yxybTVdqkPOGSoUdWDlJdaGGpt2pwfnn4
	3JhaVEWpnUJuFiWIqA64FZaHfC5h4lKiO/WgHcQUYHhlhJoc3JeYQGinYYfII3WEB8Lq8GEYTsD
	tHiDTl3uHv6Li09/t05EnLs9X5rkVAceN67D1xJuo10iChA2WQqrfjnwTqqUwzgxFIzJWf4aHgK
	3j+5EQ5B
X-Received: by 2002:a05:622a:a591:b0:517:5c70:46bd with SMTP id
 d75a77b69052e-5198734032cmr691851cf.11.1781520767462; Mon, 15 Jun 2026
 03:52:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612113414.1022901-1-tabba@google.com> <ai_OevUNS-OACPm7@willie-the-truck>
In-Reply-To: <ai_OevUNS-OACPm7@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 11:52:10 +0100
X-Gm-Features: AVVi8CdfyuPqDix51ILtu6yDx2NBgsZ4oN-79QG39qHjrQ7hNaohULwLcTkOYSc
Message-ID: <CA+EHjTyMOoCLQ7d6+TgkrnOJF-PV9K-BKtb4CNuAg8p4gtg6wg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Sync SPSR_EL1 when injecting an exception
 into a pVM
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hi Will,


On Mon, 15 Jun 2026 at 11:05, Will Deacon <will@kernel.org> wrote:
>
> On Fri, Jun 12, 2026 at 12:34:14PM +0100, Fuad Tabba wrote:
> > When pKVM injects a synchronous exception into a protected guest, it
> > re-enters without restoring the guest's EL1 sysregs and writes the EL1
> > exception registers to hardware by hand: ESR_EL1 and ELR_EL1, but not
> > SPSR_EL1. enter_exception64() sets SPSR_EL1 (the interrupted PSTATE)
> > only in memory, so the guest's handler reads a stale SPSR_EL1 and
> > restores the wrong PSTATE on eret.
> >
> > Write SPSR_EL1 alongside the other exception registers.
> >
> > Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
> > Reported-by: sashiko <sashiko@sashiko.dev>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > index 8c3fbb413a06..1a7d5cd16d72 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -268,6 +268,7 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
> >
> >       write_sysreg_el1(esr, SYS_ESR);
> >       write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
> > +     write_sysreg_el1(read_sysreg_el2(SYS_SPSR), SYS_SPSR);
> >       write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> >       write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> >  }
>
> Is SPSR_EL1 not set in enter_exception64() using vcpu_cpsr(vcpu), which
> *is* set here? I'm just a bit wary of the report, as I'd have expected
> fireworks if we weren't initialising the guest's SPSR on the exception
> injection path.

Yes, enter_exception64() sets SPSR_EL1, but only in memory:
__vcpu_write_spsr() takes the nVHE path and calls
__vcpu_assign_sys_reg(vcpu, SPSR_EL1, val), which writes
vcpu->arch.ctxt.sys_regs[SPSR_EL1] without touching the hardware
register.

In the normal nVHE entry path that memory value reaches hardware via
__sysreg_restore_state_nvhe() before __guest_enter(). But
inject_sync64() runs inside the fixup_guest_exit() loop, which
re-enters the guest directly without a sysreg restore pass. ESR_EL1
and ELR_EL1 are already written to hardware by hand for this reason
but SPSR_EL1 was missed.

I think we don't see fireworks because inject_sync64() only fires on
error paths, e.g., accesses to restricted or undefined sysregs. A
well-behaved guest shouldn't trigger these, so the stale SPSR_EL1
isn't observed.

Cheers,
/fuad

>
> Will
