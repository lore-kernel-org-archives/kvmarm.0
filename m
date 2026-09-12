Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BF02E7631
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 14:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221783; cv=none; b=mOUrXhzD7Mnk+YIVRIoZFeXJBaxA1TUmMGw6JwD1qiAgn6fpSdPzEm3WOYhZPeDaLYf1fqdX8pINFtJppIijswrZDmVPbyMLq2ye8rlaSjNiHD9megH+LMxLKnvbMYUlktm7M4BL+wIHt6j6Rarw1mjtBD5bvc6nrlE9rbzJX8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221783; c=relaxed/simple;
	bh=OhAI97tVs34vcfR5NH+E75BFGJ0Lnytnc4W4K6D7toM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f5pfNF3A6PNeTlMCSMl3daizxP6Spegx7KdCILV5MhJCsd37fG9JvM2nu3v8w57lL36nexwQLuPSYklOgTIst+CAzXOMIojM83sBJwrfrRgYplAdBTA7mI6qx/wbT4tI9fQaX5nhllg7b8Wk3XXQcMGwwbioYriDtK6plmdBuoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hDXL71C0; arc=none smtp.client-ip=91.218.175.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hDXL71C0"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=OhAI97tVs34vcfR5NH+E75BFGJ0Lnytnc4W4K6D7toM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789221779; v=1; x=1789826579;
 b=hDXL71C0eZn+CZAO9t18uYhWKQL5fY86H7dz2r0Dd+9CVMpfEcftZ9mGE+nBZLIM8meeTuiA
 Gaebm6MmSHKakv+FB329UHQEMYDFRxsBEbJemSMpI2YR6/ocS2XHfuS45SpF1m5jWgoc4cqaz68
 gkJhQsN/32VxJXtL356SeFmk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2f1245e45e09ddfe;
	Sat, 12 Sep 2026 14:02:59 +0000
X-Mizu-Trace-ID: 2f1245e45e09ddfe
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so1711e87.1
        for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 07:02:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwgJJuQIC3XHKi7jORpblz8YaaacL/KjNqtsEdhBMi7nmaM5vCpTo9aDPH2yJEcAYlZxP/d5YI=@lists.linux.dev
X-Gm-Message-State: AFuF++muFrHQwBkdDhMpPTVBwm1Hj/Ic93qRKLHAhEEUii4BivoEg0b7
	tdxzsKTvu/ZrQeoWAolrHQRRYY8mnRbMSDvxVSBqH0hltDuobjBTcl1TVwEl7SJv/vCemStNe9r
	KhSkr+yqxMK+FTAQbw4XF4TSrWtR5Okl454Ag1lXt
X-Received: by 2002:a05:6512:4285:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5b8a794105fmr82688e87.8.1789221776276; Sat, 12 Sep 2026
 07:02:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
 <20260831192406.1341841-2-fuad.tabba@linux.dev> <3bb3d57a-1862-4645-a5e2-789d70e9fc73@arm.com>
 <CA+EHjTwCs8B4du2=rAdoTOpOfh64p5cbW902e5g0u6NZT=r=gA@mail.gmail.com>
In-Reply-To: <CA+EHjTwCs8B4du2=rAdoTOpOfh64p5cbW902e5g0u6NZT=r=gA@mail.gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sat, 12 Sep 2026 15:02:20 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx5N1x5GzyHK62WqMnxtG3+=qejMZ36Oc1QkwJEUZgRAw@mail.gmail.com>
X-Gm-Features: AcwNN1XJHDPeX0RhyojTi65TAyg0_8ErLTm97oGXKlVK8u5mVdgNbDMEshcsle0
Message-ID: <CA+EHjTx5N1x5GzyHK62WqMnxtG3+=qejMZ36Oc1QkwJEUZgRAw@mail.gmail.com>
Subject: Re: [PATCH kvmtool 1/5] arm64: Do not abort on register-dump failures
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Andre Przywara <andre.przywara@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 12 Sept 2026 at 14:54, Fuad Tabba <fuad.tabba@linux.dev> wrote:
>
> Hi Suzuki,
>
> On Sat, 12 Sept 2026 at 08:33, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> >
> > On 31/08/2026 20:24, Fuad Tabba wrote:
> > > kvm_cpu__show_registers() and kvm_cpu__show_code() read the vCPU's core
> > > registers with KVM_GET_ONE_REG, and die() if the ioctl fails. Both are
> > > diagnostics. They run from the KVM_EXIT_DEBUG case in kvm_cpu__start(),
> > > from the "lkvm debug -d" dump path in handle_sigusr1(), and from the
> > > panic dump in kvm_cpu_thread().
> > >
> > > Once a protected vCPU has run, its registers belong to the guest and
> > > KVM_GET_ONE_REG returns -EPERM. Dying on that turns a diagnostic into a
> > > VMM abort.
> >
> > Marc once suggested that these could always succeed with junk values for
> > protected/Realm VMs. Do you think that is an option for pKVM ?
>
> It's possible, the host copy is still there, but I'd rather not. Once
> the vCPU has run that copy is a mix rather than junk: the boot state
> the VMM wrote, plus what the exit handlers copy out (the PSTATE mode,
> x0 for an MMIO write, x0 to x2 for a forwarded PSCI call). A dump
> would show a live PSTATE beside the PC from boot, and the VMM has no
> way to distinguish them. With the error it prints that the state is
> unavailable, which is what this patch does.
>
> It's also what the tree does for protected state elsewhere: s390
> returns -EINVAL from KVM_GET/SET_ONE_REG on a protected VM, and x86
> does the same from the register ioctls for the SEV-ES VM type, SNP and
> TDX. Legacy SEV-ES is the one place that succeeds silently, kept for
> backwards compatibility, and the commit that added the errors
> (517987e3fb19) describes that as a problem. Sean's rationale for TDX:
> KVM can't provide sane data, so it's userspace's job not to ask for it
> [1].
>
> >
> > If we go with this approach :
> >
> > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>
> Thanks, I'll add the tag. :)

Unless I misunderstood what "this" refers to exactly, please shout if
that's the case, or continue the discussion :)

/fuad

>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/482264f17fa0652faad9bd5364d652d11cb2ecb8.1625186503.git.isaku.yamahata@intel.com/
>
> >
> >
> > >
> > > Report that the register state is unavailable, with the errno, and
> > > return instead of dying.
> > >
> > > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > > ---
> > >   arm64/kvm-cpu.c | 36 ++++++++++++++++++++++++------------
> > >   1 file changed, 24 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
> > > index 3aa7684..c58d61f 100644
> > > --- a/arm64/kvm-cpu.c
> > > +++ b/arm64/kvm-cpu.c
> > > @@ -476,15 +476,19 @@ void kvm_cpu__show_code(struct kvm_cpu *vcpu)
> > >
> > >       dprintf(debug_fd, "\n*pc:\n");
> > >       reg.id = ARM64_CORE_REG(regs.pc);
> > > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > > -             die("KVM_GET_ONE_REG failed (show_code @ PC)");
> > > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > > +             pr_err("register state unavailable (pc): %s", strerror(errno));
> > > +             return;
> > > +     }
> >
> > >
> > >       kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
> > >
> > >       dprintf(debug_fd, "\n*lr:\n");
> > >       reg.id = ARM64_CORE_REG(regs.regs[30]);
> > > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > > -             die("KVM_GET_ONE_REG failed (show_code @ LR)");
> > > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > > +             pr_err("register state unavailable (lr): %s", strerror(errno));
> > > +             return;
> > > +     }
> > >
> > >       kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
> > >   }
> > > @@ -499,23 +503,31 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
> > >       dprintf(debug_fd, "\n Registers:\n");
> > >
> > >       reg.id          = ARM64_CORE_REG(regs.pc);
> > > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > > -             die("KVM_GET_ONE_REG failed (pc)");
> > > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > > +             pr_err("register state unavailable (pc): %s", strerror(errno));
> > > +             return;
> > > +     }
> > >       dprintf(debug_fd, " PC:    0x%lx\n", data);
> > >
> > >       reg.id          = ARM64_CORE_REG(regs.pstate);
> > > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > > -             die("KVM_GET_ONE_REG failed (pstate)");
> > > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > > +             pr_err("register state unavailable (pstate): %s", strerror(errno));
> > > +             return;
> > > +     }
> > >       dprintf(debug_fd, " PSTATE:    0x%lx\n", data);
> > >
> > >       reg.id          = ARM64_CORE_REG(sp_el1);
> > > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > > -             die("KVM_GET_ONE_REG failed (sp_el1)");
> > > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > > +             pr_err("register state unavailable (sp_el1): %s", strerror(errno));
> > > +             return;
> > > +     }
> > >       dprintf(debug_fd, " SP_EL1:    0x%lx\n", data);
> > >
> > >       reg.id          = ARM64_CORE_REG(regs.regs[30]);
> > > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > > -             die("KVM_GET_ONE_REG failed (lr)");
> > > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > > +             pr_err("register state unavailable (lr): %s", strerror(errno));
> > > +             return;
> > > +     }
> > >       dprintf(debug_fd, " LR:    0x%lx\n", data);
> > >   }
> > >
> >
