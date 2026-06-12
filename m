Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F0B3EDE73
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 13:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781270390; cv=pass; b=kerh+WfNhi4i0nHEaBlKb1YFkugUqH87Ddhq2qhGkxm47cOtWRWRPcTcHr86b/mir7+l5YquwNsHcI8/qdU8sSMmbFuVnMoQQnw1WXw1YTtYCa+mYyl/vTAXp2CoIUorNGzKENnVLxuZJVonrkC8bUcUHmLQieP1y0qS2v92L0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781270390; c=relaxed/simple;
	bh=nFyh8t7EajDFt4ntCcUZcAhFL09Lu/fiOAfEpgamjcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e0vCX2f1I30Rx7eoWbsQKjvkrS9uy/JIVrCb5cqmBzIjrse7s78YTTlXxJnygPgwvsZMRm9k6ySsOaZkpG7ShtxvlnZWUFQV86dAgBIlwgkViiN6LZQqmGvc0xk8xrSDhNtWYYOLSxNCvafrSgfbAYuBvYFfjO/VuHn7DgThB44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=auhoh0Ee; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="auhoh0Ee"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51765331535so428611cf.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:19:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781270388; cv=none;
        d=google.com; s=arc-20240605;
        b=LGWNB3pVRMyrYpeV1DiSOrbvSZ9NBuyFxUBn5qaWS/Yava3Mq0+uI3XWCRVNPBVV7t
         AzRNVyRE8zYGEhI3Jz4pAjESF2Gswsjd3mi2muVC1T/NeQ3p3T/Tr7fBQjNVyZTkY/U2
         i/J1edugAr9N9QizdG0efqfHuNjG5Usr5p1xUUg5nZUpOYz8kLdzLy8l5FXFT0ROuFLZ
         FDPIRMt0WtAHF5W/zrmBSOiLNoruPZn8EAoWgMRhUuxianelYt/N0oQnKJXnC5EWz7A1
         FUZzStp08E3g8Mk8uO7uqpU2M6nMRCm6NfzXtlTEsSUtX9htoo2Tv2PYRnU1j2MX0b8O
         snMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jeBSFCbpglspfyD74FVX/lua1owJC/8kPxNkA+8dxq0=;
        fh=Ara2QBSz+elVnVa89rTQ6wHqtPcLquY/1o5pXVsdPwI=;
        b=DPGXM1s8E0TR1Vx8ygt5S8t2m9Q4FxhlnzpHgKG71/KYpE8v9yKxRxrM6gQAYQ8rlj
         Qvq2q21zur9O8N0McF1VAqt7w47ErXE9G9tkvSBhs4icultTI7G6J822+xA9pDof2XQT
         WLp4CToMdNft/sc1ilsnbeNrpVBV4FurgW1wm28kQOfPOKz3+7eIdOKrJgGRVEp9p78m
         lDOP4EX5XlLOdmxOlgBt7UJ/RI94GJVvtHKFw83UysVjYhOdXyKtqRrArGBHshIrsmOz
         PTAfcVhutiPfp7jQTZyiZnT2u6GW9EYI9ypej7eVT9KaRGdl8GUDuVaV6j0R4LhTqSC3
         cQAw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781270388; x=1781875188; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jeBSFCbpglspfyD74FVX/lua1owJC/8kPxNkA+8dxq0=;
        b=auhoh0Eecl3WjzlOLIe2JN5a83kxLm6XuipO7A9Z0ZQ14dAHLi7d5iikX+z5PMaxqL
         e9+i+WHuQiSbtKxNujA47Gj+G9tuCLnB7kVJ8JgxA5OUoX61edm/3K1r5H/4pEXNnR0K
         sYoGxSOHIC201J8amU3JxUHo7xH9KgnlX1fEI7u3ws3auKvw7f3LnLetXph0C6stb32R
         Dx9ljw5ov+FDExodedph/ggOBg4A1TAISWYGSDwXTXaeq0x54LBH+sZsEtcUxzc2nQBh
         bNVXnpBe+0YiwLqP+oLC8ZbbGJWch3P7lQvlJxt+QVHs9LB87c0sJZUw/v3IoC38WpVz
         rsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781270388; x=1781875188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jeBSFCbpglspfyD74FVX/lua1owJC/8kPxNkA+8dxq0=;
        b=noyirLk3iOATR+lCr7TYgQ5d75oArxyF94Q8QjILGzrqRDBXEBhEY4mQrKK9jPWyaU
         gGSz5Q0nueydlRh7Qat5UOi4g5AUn1qutPx3Rl1008HyZoh8wuJflDvYv63L1Ou8bGdb
         lcLy0qwAzyeinI5sucrw2H5dSSbIpYvTIikkt+0+1sYqUFEV2ezITLP4tSknmQYScGtF
         9PbNR90aL9wYo0K0XMwXjSrusazEqwFVRres3isuLaxm3KuB+3FtBi7LzoV8adNsrj6s
         x2MMwjN7v8Q9Hmq/nvPezg+mIOBsWfO3n5zyRUK3SPQL19YKFCD/EE/6uJFkEX2JBCUf
         OTMQ==
X-Forwarded-Encrypted: i=1; AFNElJ9gFDjPNjWhNg8Z0aQrqHsFymdf15DsTwuBDrYikRmSWPJRLlNeJYKFkNS/cWbb0OG3lBqnqC0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzc87ztlQZcazmMZrHfI0M54kekKOyKf7OLFq+iRum/eqRQ72bh
	MqFznZH/MZTwJnKN3z/yRBkFsfrGCOY75kTwDCEUm7lHedQ0N5XB89kdI++kNiy5/obqTT0WvaO
	kaHNKvLrn9mDQ6e/J9wIImIMQI1oGWnyJq2YA6yIG
X-Gm-Gg: Acq92OFo5HI+9lBjf8GtEW/+CLCnAohPLIfmQoq5BsJVtWiBRcBWV1DMxVl2n4L4Rie
	OGxj1Dx26dPsIxfRd8x2b6dTmLMfsxJDP5YZGa4RTAFK+pcn1hiHoScKvcryYyr9jXcrTOzQ6GZ
	NRYBf/s6TdnVuX1F0lVI2dnYjv57+8WmXvR88TH2GFfpCqw/s24gmXrUTe0KZ1kwCSyD+ZxbFs6
	Ry/TXSlQgVdLGv8CDY9f0is/QW/Z9FYJFgGc+BMaNOvbNrP1Wck1POe8+RvgPpoOYI18nFlV/bu
	AuhwTDNC
X-Received: by 2002:ac8:5c84:0:b0:516:4f62:85ee with SMTP id
 d75a77b69052e-517fc539337mr7163811cf.19.1781270387386; Fri, 12 Jun 2026
 06:19:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612113414.1022901-1-tabba@google.com> <20260612115044.16E3B1F000E9@smtp.kernel.org>
In-Reply-To: <20260612115044.16E3B1F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 12 Jun 2026 14:19:10 +0100
X-Gm-Features: AVVi8CeZAvlVseat-uw7HL7_ZEkG6zTq14eM1kOd7oylk537wMpvUkPkSyGidyQ
Message-ID: <CA+EHjTyFFf__9iGFAyAkechiX+gaiK9ksdfgxLSFe8RcAY=HGA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Sync SPSR_EL1 when injecting an exception
 into a pVM
To: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Jun 2026 at 12:50, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Stale `SCTLR_EL1` used during synchronous exception injection in=
 protected VMs leads to incorrect `PSTATE` computation.
> - [High] pKVM's `inject_undef64()` injects an undefined instruction excep=
tion with the `IL` (Instruction Length) bit cleared in `ESR_EL1`, incorrect=
ly indicating a 16-bit instruction to an AArch64 guest.
> --
>
> commit 5157ad995c29fa359271604075525691515c2f95
> Author: Fuad Tabba <tabba@google.com>
>
> KVM: arm64: Sync SPSR_EL1 when injecting an exception into a pVM
>
> When pKVM injects a synchronous exception into a protected guest, it
> re-enters without restoring the guest's EL1 sysregs. This commit ensures
> SPSR_EL1 is written alongside the other exception registers to avoid
> restoring a stale PSTATE on eret.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nv=
he/sys_regs.c
> > index 8c3fbb413a06d..1a7d5cd16d723 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -268,6 +268,7 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u6=
4 esr)
> >
> >       write_sysreg_el1(esr, SYS_ESR);
> >       write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
>
> [Severity: High]
> This isn't a bug introduced by this patch, but since we are fixing sysreg
> synchronization in inject_sync64(), is there also a missing synchronizati=
on
> for SCTLR_EL1 before pending the exception?

How quickly you forget my AI friend. I submitted a fix here, when you
flagged this very issue:
https://lore.kernel.org/all/20260612102347.914994-1-tabba@google.com/

>
> Earlier in inject_sync64(), VBAR_EL1 is explicitly synchronized to memory
> because traps are handled early:
>
> arch/arm64/kvm/hyp/nvhe/sys_regs.c:inject_sync64()
>         /*
>          * Make sure we have the latest update to VBAR_EL1, as pKVM
>          * handles traps very early, before sysregs are resync'ed
>          */
>         __vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));
>
>         kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
>
>         __kvm_adjust_pc(vcpu);
>
> However, when __kvm_adjust_pc() eventually invokes enter_exception64(), i=
t
> reads SCTLR_EL1 from memory to compute the new PSTATE:
>
> arch/arm64/kvm/hyp/exception.c:enter_exception64()
>         sctlr =3D __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>
> Because SCTLR_EL1 wasn't synchronized from hardware like VBAR_EL1 was,
> could the guest's exception handler end up executing with a stale PSTATE.=
PAN
> and PSTATE.SSBS?
>
> > +     write_sysreg_el1(read_sysreg_el2(SYS_SPSR), SYS_SPSR);
> >       write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> >       write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> >  }
>
> [Severity: High]
> This is a pre-existing issue, but looking at the related inject_undef64()
> function located just below inject_sync64():
>
> arch/arm64/kvm/hyp/nvhe/sys_regs.c:inject_undef64()
> static void inject_undef64(struct kvm_vcpu *vcpu)
> {
>         inject_sync64(vcpu, (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT));
> }
>
> Does this need to set the ESR_ELx_IL bit?
>
> According to the ARM Architecture Reference Manual, for an Unknown reason
> exception (EC =3D 0x00) originating from AArch64, the Instruction Length =
(IL)
> bit must be set to 1 to indicate a 32-bit instruction.
>
> Unconditionally leaving it as 0 by only bit-shifting ESR_ELx_EC_UNKNOWN
> exposes an architecturally invalid exception syndrome register to the gue=
st.
>
> Could this cause the guest kernel's exception decoding logic to fail or
> panic?

You're right -- the architecture mandates setting IL here. Like you
said, this is pre-existing, and I'll submit a separate patch to fix
it. But first, Marc: was there a specific reason for not setting it,
or is it just an omission?

Cheers,
/fuad


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612113414.10=
22901-1-tabba@google.com?part=3D1
