Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03339333450
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 15:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763135653; cv=none; b=XgRKeePewfg6XfbKjeoq9IjNTgH8QtvcXmLh9UYarFfh2sMxnUxEdZb1VkjjnZjGaih8z6xuqvlWPb8gb8nyLXeVTbfLqdWIAhKubI/ORXubiGMgVYQTthCnJxIq6/w2ZaPKMVwCwotJUHgxAJEoL5UOmiP9GM7zfRh0FekkDqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763135653; c=relaxed/simple;
	bh=qaeJ1Sy3igMAYeCKe4kcky2/fH13jjnkXfOpE9B8Dlk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dvwZQq72pagDyRYKiLy8hSu0fdyKdUfvTlmKfL57vuwpV4KcsQgzPiYix1DjiDhk3RvJ2AAaJi4jNlJKZ2BIiThu7fQ7yxeoV/CIA4Q5x2VTuFT7DUnTqoepvwQrIB+4EgfaGbz/IPtfZX8ZUtjyDOceflIijGIsJ29eEFRi9xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aQR8rROy; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aQR8rROy"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ede12521d4so337751cf.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 07:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763135651; x=1763740451; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ets8NwguOS7BugcXiDCmLziy7av2VUMc9zU1Tb1oNaA=;
        b=aQR8rROyBGy1e97QFXeD9sPMxqdprhU/2Qbn1fUhTYGwBLenbQKYtrPNIqHIN/obmK
         2/rKNcoGUpWiedKaa1M2lWHwuGrkm//iRiROT1hSImdFj3P6XT37/tCqBPQ8152yKZU3
         6jjDSGU5SwwHA/iLBkKTTCUSAEe8gOaGSUVh2MMgNplL9GonH5ck2IwQEOjZqvedhoL3
         SOodgkBv8wqSoB6Ljo/QNEsgPErDT/xQIYzbThtr9GrWTWbFra7g48ITF9FrzBkhFm+U
         KhoFIQa5BRSny6Ons3VRfvGTywrQV+3tRnYjRPsZK0KGfXcabcGvHmKep46nSfhwH/GD
         sKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135651; x=1763740451;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ets8NwguOS7BugcXiDCmLziy7av2VUMc9zU1Tb1oNaA=;
        b=MgCzODVY5hCDAK5KU9Z7uKIGKEl37RPRAOYHRPkOs0BE7cDT26kRQ1+++FmfvZ1arC
         TU9LrGjSxQt/Lg/+HtDHkM+K5/uC6esEqrrpvq9JeF/q/8k67SUEUdWrMGHP7WjtIhZ8
         dH/b4ucdXEL3XnBL69L+Qrpu0RZIQLeYYTNxMsEg7HpavIz18nh+ZIErEjqnL/i3+YTE
         bqYGdp23A79RTjaHtH+yk6OZe+0OdIfz48shczjV1SLpcX6gmMKK+YeKUtyezNZJRpCC
         MWXLT6Bl0cjlHyDVNFN4xIMc/phf2RH9LcaulPtEXg4SX6uLJ9gO+WVD+77B7WYLbqeM
         QBOg==
X-Gm-Message-State: AOJu0YwcPayAaTCDFcdDebqe5LwGXbejPPSpp5kl5NDB4uLUkeluiJ9C
	n1FIdi1udTzpJeTgkvy/xVBTF1rqCqFG0H3/KyAG+SU5wvVXb+4W5IgxAQsDHzqNGIPBvz/fz7/
	noGllXHQN5VCYjuug4D4unEFxZ30WiJNBbl7nG89B
X-Gm-Gg: ASbGncsBpwZ1uqDAkAA4G3ROOuSqXH99t8yiPMNZAT0/z8iCgL2YWOmUm1CsVJuAVTQ
	LYdsu20sVTmKdMQnOezrBA+DCAk5c4Ej/picxWXWFgZk8CL5M3bqnCM+iuW4xTaCyNc0qmSDmPy
	jg91TnIUCY+YjyepFUMsutXKyxdm7xMQGFYQNGopusT6+S1xy7aD/XhO4+fSmVfWfcZ3ZiRVc4l
	upcZYin5m6HQWkvjvZOUgXsINXfZgeiRVG+wpMMGP1BgYRALiWfTAazZGd6Ph9AxxVRHQC6maDb
	UZNEPA==
X-Google-Smtp-Source: AGHT+IHiwTWU8jeDp2ELw5Kdfmmit9MUQPX7dTwszSoQEWn92TA+ugQDOGIXhjYg1SCQOH6qRDHLIXyjijT0X6iM6cw=
X-Received: by 2002:ac8:7c41:0:b0:4b7:8de4:52d6 with SMTP id
 d75a77b69052e-4edf313c286mr6619431cf.2.1763135650429; Fri, 14 Nov 2025
 07:54:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251109171619.1507205-1-maz@kernel.org> <20251109171619.1507205-30-maz@kernel.org>
 <CA+EHjTzRwswNq+hZQDD5tXj+-0nr04OmR201mHmi82FJ0VHuJA@mail.gmail.com> <86cy5ku06v.wl-maz@kernel.org>
In-Reply-To: <86cy5ku06v.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 14 Nov 2025 15:53:33 +0000
X-Gm-Features: AWmQ_bkDzrH8JV6r7KfYUXsoDbXfGgi939IKX55rEfFNXq-zUyYJ_6136aB575g
Message-ID: <CA+EHjTzi9Q9hqAu1Xk51hO3uz0FdUGjdPSViN4RAD6tuXJkvYQ@mail.gmail.com>
Subject: Re: [PATCH v2 29/45] KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when
 interrupts overflow LR capacity
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 14 Nov 2025 at 15:02, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 14 Nov 2025 14:20:46 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Sun, 9 Nov 2025 at 17:17, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > Now that we are ready to handle deactivation through ICV_DIR_EL1,
> > > set the trap bit if we have active interrupts outside of the LRs.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic-v3.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > > index 1026031f22ff9..26e17ed057f00 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > > @@ -42,6 +42,13 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
> > >                 ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
> > >         cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
> > >                 ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
> > > +
> > > +       /*
> > > +        * Note that we set the trap irrespective of EOIMode, as that
> > > +        * can change behind our back without any warning...
> > > +        */
> > > +       if (irqs_active_outside_lrs(als))
> > > +               cpuif->vgic_hcr |= ICH_HCR_EL2_TDIR;
> > >  }
> >
> > I just tested these patches as they are on kvmarm/next
> > 2ea7215187c5759fc5d277280e3095b350ca6a50 ("Merge branch
> > 'kvm-arm64/vgic-lr-overflow' into kvmarm/next"), without any
> > additional pKVM patches. I tried running it with pKVM (non-protected)
> > and with just plain nVHE. In both cases, I get a trap to EL2 (0x18)
> > when booting a non-protected guest, which triggers a bug in
> > handle_trap() arch/arm64/kvm/hyp/nvhe/hyp-main.c:706
> >
> > This trap is happening because of setting this particular trap (TDIR).
> > Just removing this trap from vgic_v3_configure_hcr() from the ToT on
> > kvmarm/next boots fine.
>
> This is surprising, as I'm not hitting this on actual HW. Are you
> getting a 0x18 trap? If so, is it coming from the host? Can you
> correlate the PC with what the host is doing?

I should have given you that earlier, sorry.

Yes, it's an 0x18 trap from the host (although it happens when I boot
a guest). Here is the relevant part of the backtrace addr2lined and
the full one below.

handle_percpu_devid_irq+0x90/0x120 (kernel/irq/chip.c:930)
generic_handle_domain_irq+0x40/0x64 (include/linux/irqdesc.h:?)
gic_handle_irq+0x4c/0x110 (include/linux/irqdesc.h:?)
call_on_irq_stack+0x30/0x48 (arch/arm64/kernel/entry.S:893)

[   28.454804] Code: d65f03c0 92800008 f9000008 17fffffa (d4210000)
[   28.454873] kvm [266]: Hyp Offset: 0xfff1205c3fe00000
[   28.455157] Kernel panic - not syncing: HYP panic:
[   28.455157] PS:204023c9 PC:000e5fa4413e39bc ESR:00000000f2000800
[   28.455157] FAR:ffff800082733d3c HPFAR:0000000000500000 PAR:0000000000000000
[   28.455157] VCPU:0000000000000000
[   28.459703] CPU: 5 UID: 0 PID: 266 Comm: kvm-vcpu-0 Not tainted
6.18.0-rc3-g2ea7215187c5 #8 PREEMPT
[   28.460247] Hardware name: linux,dummy-virt (DT)
[   28.460615] Call trace:
[   28.460900]  show_stack+0x18/0x24 (C)
[   28.461234]  dump_stack_lvl+0x40/0x84
[   28.461421]  dump_stack+0x18/0x24
[   28.461566]  vpanic+0x11c/0x364
[   28.461698]  vpanic+0x0/0x364
[   28.461838]  nvhe_hyp_panic_handler+0x118/0x190
[   28.462056]  handle_percpu_devid_irq+0x90/0x120
[   28.462248]  handle_percpu_devid_irq+0x90/0x120
[   28.462439]  generic_handle_domain_irq+0x40/0x64
[   28.462643]  gic_handle_irq+0x4c/0x110
[   28.462814]  call_on_irq_stack+0x30/0x48
[   28.463003]  do_interrupt_handler+0x4c/0x6c
[   28.463184]  el1_interrupt+0x3c/0x60
[   28.463348]  el1h_64_irq_handler+0x18/0x24
[   28.463525]  el1h_64_irq+0x6c/0x70
[   28.463799]  local_daif_restore+0x8/0xc (P)
[   28.463980]  el0t_64_sync_handler+0x84/0x12c
[   28.464164]  el0t_64_sync+0x198/0x19c

> It would indicate that we are leaking trap bits on exit, and that QEMU
> is trapping ICC_DIR_EL1 on top of ICV_DIR_EL1 (which the HW I have
> access to doesn't seem to do).
>
> > I'm running this on QEMU with '-machine virt,gic-version=3 -cpu max'
> > and the kernel with 'kvm-arm.mode=protected' and with
> > 'kvm-arm.mode=nvhe'.
> >
> > Let me know if you need any more info or help testing.
>
> On top of the above, could you give the hack below a go? I haven't
> tested it at all (I'm in the middle of a bisect from hell...)

With the hack it boots, both nvhe and protected mode.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index e950efa22547..71199e1a9294 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -243,7 +243,7 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
>                 cpu_if->vgic_hcr |= val & ICH_HCR_EL2_EOIcount;
>         }
>
> -       write_gicreg(compute_ich_hcr(cpu_if) & ~ICH_HCR_EL2_En, ICH_HCR_EL2);
> +       write_gicreg(0, ICH_HCR_EL2);
>  }
>
>  void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
>
> --
> Without deviation from the norm, progress is not possible.
