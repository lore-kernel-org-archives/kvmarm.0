Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8093246ED
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 13:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221339; cv=none; b=e2NJdX/GPuSVvXiWjuJWMGXIfxCbsZvRSQyOOuCbcarzCM1Lz5oew9hy7iJlLv1W5hj6lJxmrH+RxTHxeS/+8uJe1pCwzDo/Esu72GDp8ff/CQL5qd55JQIJi5ogqcwdSNkQtKzc5664AEmp9h09eRnLc+P8bmTakLaKSKdJvB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221339; c=relaxed/simple;
	bh=uVKfO6ncg/PGTTBfsU+Wi1xqY76vwNEhFuFMY8lh9ck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SnTzlZhZ0fMLrHlEKW4JwP3CYBJKEzWjKQ+1RGAKJjAwSA4LzSWW6FFWxKxgBmBByAbd51wJT1g9IyPy06ym5Z8Ot4J7UTYze89ZGi0GxrlDHZ2iUUcvUyVERkcCiE3QZCL7GIYtmFKpDHU3+TTYtl6h44GuHQSQmJ/wLkVHStE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nxBquGls; arc=none smtp.client-ip=91.218.175.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nxBquGls"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=uVKfO6ncg/PGTTBfsU+Wi1xqY76vwNEhFuFMY8lh9ck=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789221327; v=1; x=1789826127;
 b=nxBquGlsSPf3sbgDAET8vPhUln5rGdMByvpGu0453LLXKkdw/ivp/8Lxr01MsBr5q7DH+XsA
 oSVIbOYCOYRpbhUxTcPovsMlqP4rByNzRudn2luGtr8l4clvSoZiUx5E9J1/sUVDyB8r7rTpTOS
 sjWj+Gz6MWx3S4fwMvjJg9KA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 24005510728ef1cc;
	Sat, 12 Sep 2026 13:55:27 +0000
X-Mizu-Trace-ID: 24005510728ef1cc
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so1986e87.0
        for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 06:55:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwB23JFD0ab8iVjYjApOeAf47xHoa5aHx3il7GyfKmc8ZnUkpRmA2RbjWVfyl84eU75/X2JQrI=@lists.linux.dev
X-Gm-Message-State: AFuF++n4zIB0H0vQDK9bgpX0tUBMNac8rf8ObBhuQlW4w831ZyNUJPhH
	BZiz+FmyxXB7BslbnbzRHRSE+cn3fOJAKuFtcCwv+JxH7xBOv9dqLJ1oaGkVKJ89oyknm2nk2K3
	VDVVB12Z9RslIV2n/RvXm13oOrcWBraiAcmqehjnd
X-Received: by 2002:a05:6512:640a:b0:5b7:6707:e44c with SMTP id
 2adb3069b0e04-5b8a7942a1cmr77184e87.12.1789221324429; Sat, 12 Sep 2026
 06:55:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
 <20260831192406.1341841-2-fuad.tabba@linux.dev> <3bb3d57a-1862-4645-a5e2-789d70e9fc73@arm.com>
In-Reply-To: <3bb3d57a-1862-4645-a5e2-789d70e9fc73@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sat, 12 Sep 2026 14:54:48 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwCs8B4du2=rAdoTOpOfh64p5cbW902e5g0u6NZT=r=gA@mail.gmail.com>
X-Gm-Features: AcwNN1XXru80mbEi-flRa5yydU4FWkY-cYPHjVpGY3RKCxyPaNbWIT0oyGhQsoc
Message-ID: <CA+EHjTwCs8B4du2=rAdoTOpOfh64p5cbW902e5g0u6NZT=r=gA@mail.gmail.com>
Subject: Re: [PATCH kvmtool 1/5] arm64: Do not abort on register-dump failures
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Andre Przywara <andre.przywara@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Sat, 12 Sept 2026 at 08:33, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> On 31/08/2026 20:24, Fuad Tabba wrote:
> > kvm_cpu__show_registers() and kvm_cpu__show_code() read the vCPU's core
> > registers with KVM_GET_ONE_REG, and die() if the ioctl fails. Both are
> > diagnostics. They run from the KVM_EXIT_DEBUG case in kvm_cpu__start(),
> > from the "lkvm debug -d" dump path in handle_sigusr1(), and from the
> > panic dump in kvm_cpu_thread().
> >
> > Once a protected vCPU has run, its registers belong to the guest and
> > KVM_GET_ONE_REG returns -EPERM. Dying on that turns a diagnostic into a
> > VMM abort.
>
> Marc once suggested that these could always succeed with junk values for
> protected/Realm VMs. Do you think that is an option for pKVM ?

It's possible, the host copy is still there, but I'd rather not. Once
the vCPU has run that copy is a mix rather than junk: the boot state
the VMM wrote, plus what the exit handlers copy out (the PSTATE mode,
x0 for an MMIO write, x0 to x2 for a forwarded PSCI call). A dump
would show a live PSTATE beside the PC from boot, and the VMM has no
way to distinguish them. With the error it prints that the state is
unavailable, which is what this patch does.

It's also what the tree does for protected state elsewhere: s390
returns -EINVAL from KVM_GET/SET_ONE_REG on a protected VM, and x86
does the same from the register ioctls for the SEV-ES VM type, SNP and
TDX. Legacy SEV-ES is the one place that succeeds silently, kept for
backwards compatibility, and the commit that added the errors
(517987e3fb19) describes that as a problem. Sean's rationale for TDX:
KVM can't provide sane data, so it's userspace's job not to ask for it
[1].

>
> If we go with this approach :
>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks, I'll add the tag. :)

Cheers,
/fuad

[1] https://lore.kernel.org/all/482264f17fa0652faad9bd5364d652d11cb2ecb8.1625186503.git.isaku.yamahata@intel.com/

>
>
> >
> > Report that the register state is unavailable, with the errno, and
> > return instead of dying.
> >
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >   arm64/kvm-cpu.c | 36 ++++++++++++++++++++++++------------
> >   1 file changed, 24 insertions(+), 12 deletions(-)
> >
> > diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
> > index 3aa7684..c58d61f 100644
> > --- a/arm64/kvm-cpu.c
> > +++ b/arm64/kvm-cpu.c
> > @@ -476,15 +476,19 @@ void kvm_cpu__show_code(struct kvm_cpu *vcpu)
> >
> >       dprintf(debug_fd, "\n*pc:\n");
> >       reg.id = ARM64_CORE_REG(regs.pc);
> > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > -             die("KVM_GET_ONE_REG failed (show_code @ PC)");
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > +             pr_err("register state unavailable (pc): %s", strerror(errno));
> > +             return;
> > +     }
>
> >
> >       kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
> >
> >       dprintf(debug_fd, "\n*lr:\n");
> >       reg.id = ARM64_CORE_REG(regs.regs[30]);
> > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > -             die("KVM_GET_ONE_REG failed (show_code @ LR)");
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > +             pr_err("register state unavailable (lr): %s", strerror(errno));
> > +             return;
> > +     }
> >
> >       kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
> >   }
> > @@ -499,23 +503,31 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
> >       dprintf(debug_fd, "\n Registers:\n");
> >
> >       reg.id          = ARM64_CORE_REG(regs.pc);
> > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > -             die("KVM_GET_ONE_REG failed (pc)");
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > +             pr_err("register state unavailable (pc): %s", strerror(errno));
> > +             return;
> > +     }
> >       dprintf(debug_fd, " PC:    0x%lx\n", data);
> >
> >       reg.id          = ARM64_CORE_REG(regs.pstate);
> > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > -             die("KVM_GET_ONE_REG failed (pstate)");
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > +             pr_err("register state unavailable (pstate): %s", strerror(errno));
> > +             return;
> > +     }
> >       dprintf(debug_fd, " PSTATE:    0x%lx\n", data);
> >
> >       reg.id          = ARM64_CORE_REG(sp_el1);
> > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > -             die("KVM_GET_ONE_REG failed (sp_el1)");
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > +             pr_err("register state unavailable (sp_el1): %s", strerror(errno));
> > +             return;
> > +     }
> >       dprintf(debug_fd, " SP_EL1:    0x%lx\n", data);
> >
> >       reg.id          = ARM64_CORE_REG(regs.regs[30]);
> > -     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> > -             die("KVM_GET_ONE_REG failed (lr)");
> > +     if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> > +             pr_err("register state unavailable (lr): %s", strerror(errno));
> > +             return;
> > +     }
> >       dprintf(debug_fd, " LR:    0x%lx\n", data);
> >   }
> >
>
