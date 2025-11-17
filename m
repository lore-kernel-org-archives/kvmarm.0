Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EFC30F812
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 08:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763367766; cv=none; b=eo9a8L8JB+dXjHwepMDZ6QmZYQQu9OOsDyniZdPiruhs/kTAMSbOCuxfhxo/VADU/pfVKTwUAwD4lsBXt0RBQP4HY75BwVpFN/Os+gI0+LoBTh4mddrq4E4v+pMzyRWGo3D2NPB1CjOeh+CNms0qZ8opLV5+NGTaTgv+0AY8Ygw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763367766; c=relaxed/simple;
	bh=33xNOYm4zTfF2BJPSq4BbTwUMZIYNP78A9yQW2BR168=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jme/S6G9/gjJAjyTs0ECYPilcZ0hulTEh+7Kauc+oQ5pt7OVY9+e78meEmsRX7pctPvKqOZQvUMu9F0cLsYaS4bPjuezMWNwlEXD3XJ0DsgDFmaplGVF4rKPnrFa3jtPkRe8MvfWxYA1fR+lX7nliDyfSqrLeDKXtUKXuDsySkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zpyne44U; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zpyne44U"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ed67a143c5so508001cf.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 00:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763367762; x=1763972562; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F4mw/d+cHuQSW2nKT/VCWC66VyQfn5ntftKqNloGog0=;
        b=Zpyne44UNZMS1TRb8HIP2yyS1ygkD/cTkqdZehmbUFueS3a8bI8PY1LhsO4lOIz9T5
         PiRGvJq39OEnaguqDq4csskk3S4mACMcEV3NAi77b1Q0bHL0lHBCcVKsLxH0ACX3DVPm
         XVnAfhHoHg8MTZCszxyV20AWV8GGkrhhgJomJOUw7JDtueD9e9hS/svk2GTBgsYjVc+c
         y0rrX0yyPhYs5p3jpBCqRUUWh/gm6CigeO5r1hjDZbD/rAk1qxTwT8Y9iK1rRQvM/3DH
         SCXuhSrweMTdrV07fsJdy2OjSdbpG4z8WgmW5XI9OfbjfNlgq4HZAXu6kJMxeWoAAQ/Q
         r18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763367762; x=1763972562;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4mw/d+cHuQSW2nKT/VCWC66VyQfn5ntftKqNloGog0=;
        b=ZQPZWQZw+tBY5eBnLhsEV0DMi+EUidigpktXx0WLMhGEuM0VYXKL5Kvkc6SqgGughW
         d91ShjpV+hNGgPabwDRtaWkKmiKlEQGHNN2iQKnbQjEBoEiEWlya/MN8S3+it5wTjZQN
         iM04nThJWbHXS/Qqtj86w0j2ef3KeOvJ0OQZJFM+Tif56biPVhtuXPxhvWY0ETIBlXJd
         /6C2ErIsQSoK3nTQkqTta/LhSgDmK4H6n500Tf/I7deXjGJ3YKYhi4eavap30uxL8Ppc
         LOx5SIDMz/6ccPp2iwVSancwYvtdUc3VyY3A1c2vRG/f3vOGe9s8K0D1LWOsHZwD+9FX
         vS6A==
X-Gm-Message-State: AOJu0Yz55MRWIvM8UA0PhZq7S8ues75cz2WEjS9y1q27k3LkHxn38uSs
	eIZmcwAPWPeyPuiq2YJcwLZHjZjYgvWDoavw6AwQeCWx9ZRYtt+/5oy5Q4sgfpyIjD70k7fvxK3
	3wjLxRkGY+Q5dEVuYzGEJl/Xy5R1tDzbhs+A0ntYa
X-Gm-Gg: ASbGncs7M6xtXXe/p5u90ePcWzddvolDWAqVaD88Nij+YNUxyb7M+ePlL9Q/L5jM6BS
	yYYj8ioyWwIN0hAKbcotFvGBySDlbhOhgDj2qaIh/yM7Ir07LW/ERPih1RaCg49mwEe0TWfk0HF
	ZA44YOm/VwM4g5LbkFTApLROLS02t0VszyrQOCMdOBxKVM/R+FaB9K8MOqNQBJau6ZZPLXdPOu9
	VzNX4mFKwjtyFI48QaDD/GURzf1dZp2iB4k4oFvNSp8gvRBRQE0wFxN5xD9QgkVu8Yv9Og=
X-Google-Smtp-Source: AGHT+IEwrJtjWNdFAKXP4Cq6tm8luNUUXLzjFmpWEc5T/ifpGhnOTJaKY/1iZ6Vy1SGx0WQsbM+vgRDsvnbfJpkP4eE=
X-Received: by 2002:ac8:5893:0:b0:4ed:341a:5499 with SMTP id
 d75a77b69052e-4ee02c20affmr10129241cf.11.1763367762168; Mon, 17 Nov 2025
 00:22:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251109171619.1507205-1-maz@kernel.org> <20251109171619.1507205-30-maz@kernel.org>
 <CA+EHjTzRwswNq+hZQDD5tXj+-0nr04OmR201mHmi82FJ0VHuJA@mail.gmail.com>
 <86cy5ku06v.wl-maz@kernel.org> <CA+EHjTzi9Q9hqAu1Xk51hO3uz0FdUGjdPSViN4RAD6tuXJkvYQ@mail.gmail.com>
 <86a50otsuh.wl-maz@kernel.org>
In-Reply-To: <86a50otsuh.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 08:22:05 +0000
X-Gm-Features: AWmQ_bmqi9yyjBAanZdrMqxT0R_6WY6hFkqKJWlr94OwYemsxfqLBAjqPjPKDzk
Message-ID: <CA+EHjTwcf7HXypmt-1gS2G8GK5iBt3VQrpmRiHysr571J96VvA@mail.gmail.com>
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

On Fri, 14 Nov 2025 at 17:41, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 14 Nov 2025 15:53:33 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Fri, 14 Nov 2025 at 15:02, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Fri, 14 Nov 2025 14:20:46 +0000,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > Hi Marc,
> > > >
> > > > On Sun, 9 Nov 2025 at 17:17, Marc Zyngier <maz@kernel.org> wrote:
> > > > >
> > > > > Now that we are ready to handle deactivation through ICV_DIR_EL1,
> > > > > set the trap bit if we have active interrupts outside of the LRs.
> > > > >
> > > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > > ---
> > > > >  arch/arm64/kvm/vgic/vgic-v3.c | 7 +++++++
> > > > >  1 file changed, 7 insertions(+)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > > > > index 1026031f22ff9..26e17ed057f00 100644
> > > > > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > > > > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > > > > @@ -42,6 +42,13 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
> > > > >                 ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
> > > > >         cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
> > > > >                 ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
> > > > > +
> > > > > +       /*
> > > > > +        * Note that we set the trap irrespective of EOIMode, as that
> > > > > +        * can change behind our back without any warning...
> > > > > +        */
> > > > > +       if (irqs_active_outside_lrs(als))
> > > > > +               cpuif->vgic_hcr |= ICH_HCR_EL2_TDIR;
> > > > >  }
> > > >
> > > > I just tested these patches as they are on kvmarm/next
> > > > 2ea7215187c5759fc5d277280e3095b350ca6a50 ("Merge branch
> > > > 'kvm-arm64/vgic-lr-overflow' into kvmarm/next"), without any
> > > > additional pKVM patches. I tried running it with pKVM (non-protected)
> > > > and with just plain nVHE. In both cases, I get a trap to EL2 (0x18)
> > > > when booting a non-protected guest, which triggers a bug in
> > > > handle_trap() arch/arm64/kvm/hyp/nvhe/hyp-main.c:706
> > > >
> > > > This trap is happening because of setting this particular trap (TDIR).
> > > > Just removing this trap from vgic_v3_configure_hcr() from the ToT on
> > > > kvmarm/next boots fine.
> > >
> > > This is surprising, as I'm not hitting this on actual HW. Are you
> > > getting a 0x18 trap? If so, is it coming from the host? Can you
> > > correlate the PC with what the host is doing?
> >
> > I should have given you that earlier, sorry.
> >
> > Yes, it's an 0x18 trap from the host (although it happens when I boot
> > a guest). Here is the relevant part of the backtrace addr2lined and
> > the full one below.
> >
> > handle_percpu_devid_irq+0x90/0x120 (kernel/irq/chip.c:930)
> > generic_handle_domain_irq+0x40/0x64 (include/linux/irqdesc.h:?)
> > gic_handle_irq+0x4c/0x110 (include/linux/irqdesc.h:?)
> > call_on_irq_stack+0x30/0x48 (arch/arm64/kernel/entry.S:893)
> >
> > [   28.454804] Code: d65f03c0 92800008 f9000008 17fffffa (d4210000)
> > [   28.454873] kvm [266]: Hyp Offset: 0xfff1205c3fe00000
> > [   28.455157] Kernel panic - not syncing: HYP panic:
> > [   28.455157] PS:204023c9 PC:000e5fa4413e39bc ESR:00000000f2000800
> > [   28.455157] FAR:ffff800082733d3c HPFAR:0000000000500000 PAR:0000000000000000
>
> I expect you have a write to ICC_DIR_EL1 at this address?

It almost surely must be, but tracking it down hasn't been that easy.
That said, I think it's ending up in gic_eoimode1_eoi_irq(), which
calls gic_write_dir() if !gic_arm64_erratum_2941627_needed(d).

I wonder if your hardware needs that erratum.

> > [   28.455157] VCPU:0000000000000000
> > [   28.459703] CPU: 5 UID: 0 PID: 266 Comm: kvm-vcpu-0 Not tainted
> > 6.18.0-rc3-g2ea7215187c5 #8 PREEMPT
> > [   28.460247] Hardware name: linux,dummy-virt (DT)
> > [   28.460615] Call trace:
> > [   28.460900]  show_stack+0x18/0x24 (C)
> > [   28.461234]  dump_stack_lvl+0x40/0x84
> > [   28.461421]  dump_stack+0x18/0x24
> > [   28.461566]  vpanic+0x11c/0x364
> > [   28.461698]  vpanic+0x0/0x364
> > [   28.461838]  nvhe_hyp_panic_handler+0x118/0x190
> > [   28.462056]  handle_percpu_devid_irq+0x90/0x120
> > [   28.462248]  handle_percpu_devid_irq+0x90/0x120
> > [   28.462439]  generic_handle_domain_irq+0x40/0x64
> > [   28.462643]  gic_handle_irq+0x4c/0x110
> > [   28.462814]  call_on_irq_stack+0x30/0x48
> > [   28.463003]  do_interrupt_handler+0x4c/0x6c
> > [   28.463184]  el1_interrupt+0x3c/0x60
> > [   28.463348]  el1h_64_irq_handler+0x18/0x24
> > [   28.463525]  el1h_64_irq+0x6c/0x70
> > [   28.463799]  local_daif_restore+0x8/0xc (P)
> > [   28.463980]  el0t_64_sync_handler+0x84/0x12c
> > [   28.464164]  el0t_64_sync+0x198/0x19c
> >
> > > It would indicate that we are leaking trap bits on exit, and that QEMU
> > > is trapping ICC_DIR_EL1 on top of ICV_DIR_EL1 (which the HW I have
> > > access to doesn't seem to do).
> > >
> > > > I'm running this on QEMU with '-machine virt,gic-version=3 -cpu max'
> > > > and the kernel with 'kvm-arm.mode=protected' and with
> > > > 'kvm-arm.mode=nvhe'.
> > > >
> > > > Let me know if you need any more info or help testing.
> > >
> > > On top of the above, could you give the hack below a go? I haven't
> > > tested it at all (I'm in the middle of a bisect from hell...)
> >
> > With the hack it boots, both nvhe and protected mode.
>
> OK. At least we know what the issue is, and it shouldn't be too hard
> to fix. I guess there is an opportunity for cleanup here, and I'll
> look into it shortly (probably not before Monday though).

No hurry on my part. I'm just here for the reviews :)

Cheers,
/fuad

> Thanks again,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
