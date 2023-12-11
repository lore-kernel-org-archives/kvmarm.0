Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B074F203
	for <kvmarm@lists.linux.dev>; Mon, 11 Dec 2023 17:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VoimflXr"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e1b9b10dc0so197727b3.2
        for <kvmarm@lists.linux.dev>; Mon, 11 Dec 2023 09:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702317068; x=1702921868; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b+QItwKYZkmQjKZfvnmL7h1+BIrbGG/qsUdX1MWn8c0=;
        b=VoimflXrYCSADeQBidbgVfnClbwrU4HoClZDgc28LwcH+j+PpE4ee7cQncsk5hENac
         d0ap4syoLzqrYL5lrprFSIWvdxi4fzIi/rV4jw/1Eu/FixmvSRCJumyUpsNIpu3/iMjf
         5GOimd3uN42jVjfO4seVrqX79PHScHrObwRbnlxM0wmQ8k9Lb9CUVH29/dYenD+FsqIx
         /3ABdZWkxPcDMQt3Ia7yTh/un2vrAIwCY6rtnixyzYWkZ4DPbLv0vSfU0l43TG+pQ6C/
         cP6EDW7nTs2wgMQpt2O5ncF7bI2MZm8mKIXA98W153XpI2Lwe6WKxsoQZSxE4hH4CXYp
         NLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702317068; x=1702921868;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b+QItwKYZkmQjKZfvnmL7h1+BIrbGG/qsUdX1MWn8c0=;
        b=EL25czVGEFMuXz6nLPq1mO3mz0ooAS0Uq12ZACjot+RhBw5jKB7KnGDEVtSQFVgKS5
         b1KR7H70Xq9grPueWZKjHTBs0VzbGtCheSp/sN8UulRQ+rGMmnkyXs3w9bFJT/otTicY
         fStxnz2PUE86dv0NRh2WfugJIHTJWWuLG1YnDAz3Ch/bIYixo9C+gXDgg75QklgwjP7Z
         bjzbdwCl/Kao0zBNrVT8/R9o/XpVoMudgAh588wYKOdach5mLvcCU3d+rSPNrSwQrTfX
         PbkYLhNsrVs1SPcJV2WL3+ZIUpYk4Xsw0oZ/cu66aqlK74HSv2SI/Yj8B/LQcKy0a8iX
         N6/Q==
X-Gm-Message-State: AOJu0YwSlL8s9EJCqDFEb1gSrdXnEFVfmhX+DtQyqU+XRaaJS0BrU4LW
	3zLNhqUcSiEGI+eWrmj8THIG6TjD+jQ=
X-Google-Smtp-Source: AGHT+IEJlbs6t42JuBe9Zaw8UIu5remsf7pFjNUwnZXA86IgYB4Hsz7JOVUF1FGFr+oR81Ahwo5DnMt1rK4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3381:b0:5d5:5183:ebdb with SMTP id
 fl1-20020a05690c338100b005d55183ebdbmr48534ywb.10.1702317068533; Mon, 11 Dec
 2023 09:51:08 -0800 (PST)
Date: Mon, 11 Dec 2023 09:51:07 -0800
In-Reply-To: <ZXdIIBUXcCIK28ys@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230512233127.804012-1-seanjc@google.com> <20230512233127.804012-2-seanjc@google.com>
 <cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com> <ZXdIIBUXcCIK28ys@google.com>
Message-ID: <ZXdMC9rCHqAx2SfF@google.com>
Subject: Re: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to
 hook restart/shutdown
From: Sean Christopherson <seanjc@google.com>
To: James Gowans <jgowans@amazon.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Alexander Graf <graf@amazon.de>, 
	"Jan =?utf-8?Q?Sch=C3=B6nherr?=" <jschoenh@amazon.de>, "ebiederm@xmission.com" <ebiederm@xmission.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "atishp@atishpatra.org" <atishp@atishpatra.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, "james.morse@arm.com" <james.morse@arm.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "maz@kernel.org" <maz@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>, 
	"anup@brainfault.org" <anup@brainfault.org>, 
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 11, 2023, Sean Christopherson wrote:
> On Sat, Dec 09, 2023, James Gowans wrote:
> > Hi Sean,
> >=20
> > Blast from the past but I've just been bitten by this patch when
> > rebasing across v6.4.
> >=20
> > On Fri, 2023-05-12 at 16:31 -0700, Sean Christopherson wrote:
> > > Use syscore_ops.shutdown to disable hardware virtualization during a
> > > reboot instead of using the dedicated reboot_notifier so that KVM dis=
ables
> > > virtualization _after_ system_state has been updated.=C2=A0 This will=
 allow
> > > fixing a race in KVM's handling of a forced reboot where KVM can end =
up
> > > enabling hardware virtualization between kernel_restart_prepare() and
> > > machine_restart().
> >=20
> > The issue is that, AFAICT, the syscore_ops.shutdown are not called when
> > doing a kexec. Reboot notifiers are called across kexec via:
> >=20
> > kernel_kexec
> >   kernel_restart_prepare
> >     blocking_notifier_call_chain
> >       kvm_reboot
> >=20
> > So after this patch, KVM is not shutdown during kexec; if hardware virt
> > mode is enabled then the kexec hangs in exactly the same manner as you
> > describe with the reboot.
> >=20
> > Some specific shutdown callbacks, for example IOMMU, HPET, IRQ, etc are
> > called in native_machine_shutdown, but KVM is not one of these.
> >=20
> > Thoughts on possible ways to fix this:
> > a) go back to reboot notifiers
> > b) get kexec to call syscore_shutdown() to invoke all of these callback=
s
> > c) Add a KVM-specific callback to native_machine_shutdown(); we only
> > need this for Intel x86, right?
>=20
> I don't like (c).  VMX is the most sensitive/problematic, e.g. the whole =
blocking
> of INIT thing, but SVM can also run afoul of EFER.SVME being cleared, and=
 KVM really=20
> should leave virtualization enabled across kexec(), even if leaving virtu=
alization

*shouldn't*

> enabled is relatively benign on other architectures.
>=20
> One more option would be:
>=20
>  d) Add another sycore hook, e.g. syscore_kexec() specifically for this p=
ath.
>=20
> > My slight preference is towards adding syscore_shutdown() to kexec, but
> > I'm not sure that's feasible. Adding kexec maintainers for input.
>=20
> In a vacuum, that'd be my preference too.  It's the obvious choice IMO, e=
.g. the
> kexec_image->preserve_context path does syscore_suspend() (and then resum=
e(), so
> it's not completely uncharted territory.
>=20
> However, there's a rather big wrinkle in that not all of the existing .sh=
utdown()
> implementations are obviously ok to call during kexec.  Luckily, AFAICT t=
here are
> very few users of the syscore .shutdown hook, so it's at least feasible t=
o go that
> route.
>=20
> x86's mce_syscore_shutdown() should be ok, and arguably is correct, e.g. =
I don't
> see how leaving #MC reporting enabled across kexec can work.
>=20
> ledtrig_cpu_syscore_shutdown() is also likely ok and arguably correct.
>=20
> The interrupt controllers though?  x86 disables IRQs at the very beginnin=
g of
> machine_kexec(), so it's likely fine.  But every other architecture?  No =
clue.
> E.g. PPC's default_machine_kexec() sends IPIs to shutdown other CPUs, tho=
ugh I
> have no idea if that can run afoul of any of the paths below.
>=20
>         arch/powerpc/platforms/cell/spu_base.c  .shutdown =3D spu_shutdow=
n,
>         arch/x86/kernel/cpu/mce/core.c	        .shutdown =3D mce_syscore_=
shutdown,
>         arch/x86/kernel/i8259.c                 .shutdown =3D i8259A_shut=
down,
>         drivers/irqchip/irq-i8259.c	        .shutdown =3D i8259A_shutdown=
,
>         drivers/irqchip/irq-sun6i-r.c	        .shutdown =3D sun6i_r_intc_=
shutdown,
>         drivers/leds/trigger/ledtrig-cpu.c	.shutdown =3D ledtrig_cpu_sysc=
ore_shutdown,
>         drivers/power/reset/sc27xx-poweroff.c	.shutdown =3D sc27xx_powero=
ff_shutdown,
>         kernel/irq/generic-chip.c	        .shutdown =3D irq_gc_shutdown,
>         virt/kvm/kvm_main.c	                .shutdown =3D kvm_shutdown,
>=20
> The whole thing is a bit of a mess.  E.g. x86 treats machine_shutdown() f=
rom
> kexec pretty much the same as shutdown for reboot, but other architecture=
s have
> what appear to be unique paths for handling kexec.
>=20
> FWIW, if we want to go with option (b), syscore_shutdown() hooks could us=
e
> kexec_in_progress to differentiate between "regular" shutdown/reboot and =
kexec.
