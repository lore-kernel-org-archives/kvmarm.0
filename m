Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F5A3E9C2A
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 11:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264459; cv=pass; b=TRcRkqX3htUuZBYqp4MEOBGr3cojL3D4EeJRHHmEMBUDSngBtzfuXz4wlvdrsg9UONCW+m97MEC84jJ6WTzrSe/cQZ//NyKkgnLjuRKlcIwUFPBGN3EOvmRV6VlsAUw21QF3ZnSo9RZ9tr2A/gwO2fqkGzogjC59AiUrj6kmTfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264459; c=relaxed/simple;
	bh=HivkvM3TNYKTQw5J/jvFbqF0KMpP8ehDZ8K+MXP7UKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TCPCW27s3N+PiOBbOguZCozRa/u7mLFA2M1R1HHBo2p+5YYrZd5GLWU5fCgNSfLjuOeoJOSriiPZrEdhmUaTXqvZbmOokudf6LTLP0GcgikV1Ag8jyO0tSmyxK5BELGjXQPfDt7TH97eaiscMQtUAIQrQG9kDVBemrpOR9XMW8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FF9CGies; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FF9CGies"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5175d339e8bso499661cf.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 04:40:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781264457; cv=none;
        d=google.com; s=arc-20240605;
        b=Be86tldGYQ7uNUOgLgWSRdo/QujbWLRHBxVE0uu+AMCsMdfETEo9FVIjCl5ohhQNUG
         nfJRjUWGmVj/Hs6Y14KBNbXX4gwcthK6Nb/p5V5bWaulzmthQ/yJ7sAfRS+auKT5hT8g
         sRVVfSY4w5oezKXITKFARJz0FgTwq/C4BjlTdgeUOrxr/Ya9d4/9D8xXKeYS4lW/3je8
         BSJvJHiEJ0oLm/AAEKxTmCDzt1vjiS2afXueBUg3ORIv4hBeci6m6icR6ZyW1HLfkbK7
         5gomPNc9SeKmzPjX4vX+ymLXGKxz6njRELtsVANUoXX4N63tKJV+d2vEx6Ap2udV7Gdj
         2h/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j4CHXEt3LXP1hxO45XtMy4L5DsTueLZ4o7Y1H011dEM=;
        fh=Y+frDPbSARFaL5cte5F5JXj5zQViI6xOprV1hD4XwPM=;
        b=Z8dh3ui1Qnj+mWipLE8iYluYPy1vQlKMaXWtSKe9zG5UiKy4BsqhHSjEiRCmD8toKO
         87WvY4rgowMCyR1HbnSbwOoChG71lVgvJMOVQ/ZG6PoiUiJxxiu90AS9aqcBLPBCXIxx
         KyM4Zhk1mjSrA4O+U6IG2lr6BHsigezEbLXpSgO2x4koMY5y/1G4DjD1uPlUzKgSCF2W
         mIkrAU4EJTI1rVS5Ax+CAteBEbYs1n0m5hDD0hXKbrbWv/Wcb8aYvzYujXpk4yvlVOqF
         ZlSPnYYFQRI+5q4fIABEcG2djx6hE8Tl/EXqWiemsEc14lMn6j1JtfS2P0neM9OtUe4p
         T4dg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781264457; x=1781869257; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4CHXEt3LXP1hxO45XtMy4L5DsTueLZ4o7Y1H011dEM=;
        b=FF9CGies/SqazRXzQLaoEzyZ9FQ6M/wzBWZkNQWQHVnbIdeCCXTEZFBtjXjVmX/7j6
         G8e8520GuYpp79ngwrkkzzAIRKLk59b6wAkYr8EcAFqex/f/7rUA1qr7oFS6Luyt4bIm
         v7QKl+ZNuTrza/yENq3kSSJv3YbEntrfqvRego1q2D0SKdoEq4sBD4jQCvWWIDxFBbA/
         f+yL1pAYQ1Tu+Mg97xzaSfwvwjtKp3ZVvEj6SIDYAE8MSNj6lTjDrXRCk9YSuyvfeWYI
         m1oOH3WJPBKHXPXdE2MrLoFFiMqRIPK6yTG3SD0LIH5HUktCG4xWhwVA+uoPLObuuDqZ
         5s3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781264457; x=1781869257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j4CHXEt3LXP1hxO45XtMy4L5DsTueLZ4o7Y1H011dEM=;
        b=Q6NMBFLRaMAHsBwjnqOil9EtkBOWHyiuK7UD/g4xLLnle4Tn18bkqgSSKkWc/FQZ2a
         OXCps32DfUFowgcnfDrbYHLUN71Idnncfr0wCAr4QFYEjFdXBV8/tlHL8m2MNPPWvHsm
         VWt0Egt2P5Ebm+Pn/OM7K1NXlUgu7BcB4Swo1hCSQBYEFgJr0rq2mm6qQXxAL+GkgLkn
         cknUdZWKko1rOTU7Bm7/tEexho/utFVID6AgPXEE5mFJiPej0EzU9lEv60NMlg03HQ2H
         8HL878tQQzA/72pQKEYKzQFnerQiR02gwBSNpc1OzivO4EMb89mKIaSPsttRcK5cMquu
         kSTw==
X-Gm-Message-State: AOJu0YwRs8bkLdTCSrp3TwKSbAFu2E5iY+/JTPkJDGgOPZeHyViy/zed
	GPtkD29rpRbVWPH3DIR92ZVbgHlV95dpUQxEw9+N1QJBJJdttLh8dN9IC8kTGx8M2MDUmRDYiOl
	KC+r14yoimlL/2MtizJssg5rT+lkehvAbxpzinlwW
X-Gm-Gg: Acq92OEhXE4fCeDsLGcw2TbDrSsfWwXvK+VvQatBlMu1IibQumhCZ9wr1FcfirhZ6YA
	OTY+nfM2s3i7CppgzuQaT7yEw/CvKQhQ1KzZmiH4ThlNDeD537/rFv+1RCKz6NPmZqUAMV86gtZ
	3LXiNeM0ChuBm4JPXoYLwafnc3RtTxgQAUzRQ5h5aUJRlqjhrlpHw6q6l12XNw7Vkh+QD9DB99E
	v+7U+A8GDwb9gx1f7dX0hHSvmnYhO4XdV1oTlsYCsyylMcKEbnM88PK/ewo4d/Hi54QZOax1KWt
	tOkzwWhtqIHuEI6nof4=
X-Received: by 2002:a05:622a:230d:b0:516:8fad:8fd3 with SMTP id
 d75a77b69052e-517fc5074a9mr6271241cf.11.1781264456375; Fri, 12 Jun 2026
 04:40:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612102347.914994-1-tabba@google.com> <20260612104020.DD4EE1F000E9@smtp.kernel.org>
In-Reply-To: <20260612104020.DD4EE1F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 12 Jun 2026 12:40:19 +0100
X-Gm-Features: AVVi8CfDXoez7BtiqSVl_jKaBJFCkBYh2vPTNbYvrYnlqu_EtniUVJUGzwZzUx4
Message-ID: <CA+EHjTzyRA3Vur9T_mURSPJCkMdx2ZYL8TusPReLLj52R15g0w@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Sync SCTLR_EL1 when injecting an exception
 into a pVM
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello again,

On Fri, 12 Jun 2026 at 11:40, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] inject_sync64() fails to write the trapped PSTATE into the guest=
's hardware SPSR_EL1 register, causing the guest to observe a stale SPSR_EL=
1 when it handles the injected exception.
> --
>
> commit 0025a59d79e472c72e387019776838f814e85578
> Author: tabba@google.com <tabba@google.com>
>
> KVM: arm64: Sync SCTLR_EL1 when injecting an exception into a pVM
>
> This commit updates pKVM exception injection to synchronize SCTLR_EL1
> alongside VBAR_EL1 so that the newly injected exception observes the
> correct PAN and SSBS bits.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nv=
he/sys_regs.c
> > index 8c3fbb413a06d..7608cc4030b88 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -257,10 +257,11 @@ static void inject_sync64(struct kvm_vcpu *vcpu, =
u64 esr)
> >       *vcpu_cpsr(vcpu) =3D read_sysreg_el2(SYS_SPSR);
> >
> >       /*
> > -      * Make sure we have the latest update to VBAR_EL1, as pKVM
> > -      * handles traps very early, before sysregs are resync'ed
> > +      * Sync VBAR_EL1 and SCTLR_EL1, both read by enter_exception64(),
> > +      * as pKVM handles traps before sysregs are resync'ed.
> >        */
> >       __vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));
> > +     __vcpu_assign_sys_reg(vcpu, SCTLR_EL1, read_sysreg_el1(SYS_SCTLR)=
);
> >
> >       kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
> >
>
> [Severity: High]
> This is a pre-existing issue, but looking at the end of inject_sync64(), =
it
> appears we fail to write the trapped PSTATE into the guest's hardware
> SPSR_EL1 register.
>
> Later in inject_sync64(), the code updates the hardware exception registe=
rs
> for EL1:
>
>         write_sysreg_el1(esr, SYS_ESR);
>         write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
>         write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
>         write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
>
> While SYS_ESR and SYS_ELR are manually updated for EL1, SYS_SPSR (EL1) is
> omitted. Since pKVM returns control directly to the guest without restori=
ng
> sys_regs from memory, will the guest's exception handler read a stale
> SPSR_EL1 from hardware?
>
> Should the code also sync the memory-backed SPSR_EL1 to the hardware
> register here to prevent corrupted exception state?

Good catch, real pre-existing bug. inject_sync64() omits the SPSR_EL1
write, so the guest's handler reads a stale SPSR_EL1 and eret's with
the wrong PSTATE. Separate fix sent:

https://lore.kernel.org/all/20260612113414.1022901-1-tabba@google.com/

Cheers,
/fuad

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612102347.91=
4994-1-tabba@google.com?part=3D1
