Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C3828F2
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 15:02:29 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id hk2-20020a17090b224200b0023d079647bdso1351317pjb.6
        for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 08:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678719749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l+tH8lYD9x2/FqbeqH0oWvF0Gi+WrvY+7IS1lzP+zYs=;
        b=n8D68KLWWq8tQn8XxYjWWU/BDuop/hKc0pOUBZvDtn5d7r4dAs/veh4PJ+rjlj07KL
         cu29BCAB1IDdf0T/RCDxj26joaO6eorfftwZTcLhuLAdKYmNSoMDAXzrzRuitsF+Q9tM
         aMvVJr2hRlNMyDjDdHILz2rhoLym6W+ZIvksjnzhGkcRRncpTyu9IKfZOprFjYA7MCap
         Y26mH24RxFuRoJIW5U1szfekcPe6L0grrOr3I0XWCP2xpUFno3hZ7tVlinQd856NOYb+
         QZOHStb5CXv/OZQ8EMkUdqSzl+f9r1zxSaI7w/skGjuCC0zYVEn1Ctv+NyMXqU7pYHJL
         sq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678719749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+tH8lYD9x2/FqbeqH0oWvF0Gi+WrvY+7IS1lzP+zYs=;
        b=OKKRyeoWPLOXr2A39FNswdjSFT1p9nDsnRXBjWvY2+p9HvGncdc6NGKnSeeeizrxDV
         OjTDzlW7s4kRYXaacads5s1gcdkgNCbVndGwhNRwL9itOkrnAsROMCNmyxq47wQ9wZFc
         BrbNfExuVV13gAfuFjb8E2nqQpzJLrIMB3weSjZTuGqv/1LUHWD+23/ueIXPJ8lzAjbu
         XnpyBC9FMkSalvFdSjgvri+CZnRCa1ID0+TOjQNvNMn336X7KrDg8KV4ARXcDPxXz3jb
         dzL47Ahf/onaspQzKsfibM1gM/ADpIEkgVjwHFNu9Cji15R856GBet1nNYrzpDEJY8B7
         ip3g==
X-Gm-Message-State: AO0yUKUtjQFvJcC0c4x9yN1qE7vIBLpqxwzxy8lvTUFrqR0zFgUEHDzX
	36S/LiflwHItbtfe9ZQ+MdIhvbx7E/I=
X-Google-Smtp-Source: AK7set9/P9VcoKAyPGBT+s9BFnNAj7bBNTRTadNvzfty2TE+20Q7oBhsWJZF6JCCdROoRlN4cXRBFS5+rP4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1d0c:b0:233:eccf:ea10 with SMTP id
 c12-20020a17090a1d0c00b00233eccfea10mr12524574pjd.1.1678719749210; Mon, 13
 Mar 2023 08:02:29 -0700 (PDT)
Date: Mon, 13 Mar 2023 08:02:27 -0700
In-Reply-To: <87fsaa5kyv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230310221414.811690-1-seanjc@google.com> <20230310221414.811690-3-seanjc@google.com>
 <87fsaa5kyv.wl-maz@kernel.org>
Message-ID: <ZA86UINtWH3aw4Mv@google.com>
Subject: Re: [PATCH 2/2] KVM: Don't enable hardware after a restart/shutdown
 is initiated
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Sun, Mar 12, 2023, Marc Zyngier wrote:
> On Fri, 10 Mar 2023 22:14:14 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > Reject hardware enabling, i.e. VM creation, if a restart/shutdown has
> > been initiated to avoid re-enabling hardware between kvm_reboot() and
> > machine_{halt,power_off,restart}().  The restart case is especially
> > problematic (for x86) as enabling VMX (or clearing GIF in KVM_RUN on
> > SVM) blocks INIT, which results in the restart/reboot hanging as BIOS
> > is unable to wake and rendezvous with APs.
> > 
> > Note, this bug, and the original issue that motivated the addition of
> > kvm_reboot(), is effectively limited to a forced reboot, e.g. `reboot -f`.
> > In a "normal" reboot, userspace will gracefully teardown userspace before
> > triggering the kernel reboot (modulo bugs, errors, etc), i.e. any process
> > that might do ioctl(KVM_CREATE_VM) is long gone.
> > 
> > Fixes: 8e1c18157d87 ("KVM: VMX: Disable VMX when system shutdown")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 6cdfbb2c641b..b2bf4c105181 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -5182,7 +5182,20 @@ static void hardware_disable_all(void)
> >  static int hardware_enable_all(void)
> >  {
> >  	atomic_t failed = ATOMIC_INIT(0);
> > -	int r = 0;
> > +	int r;
> > +
> > +	/*
> > +	 * Do not enable hardware virtualization if the system is going down.
> > +	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
> > +	 * possible for an in-flight KVM_CREATE_VM to trigger hardware enabling
> > +	 * after kvm_reboot() is called.  Note, this relies on system_state
> > +	 * being set _before_ kvm_reboot(), which is why KVM uses a syscore ops
> > +	 * hook instead of registering a dedicated reboot notifier (the latter
> > +	 * runs before system_state is updated).
> > +	 */
> > +	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
> > +	    system_state == SYSTEM_RESTART)
> > +		return -EBUSY;
> 
> Since we now seem to be relying on system_state for most things, is
> there any use for 'kvm_rebooting' other than the ease of evaluation in
> __svm_vcpu_run?

Sadly, yes.  The x86 implementations of emergency_restart(), __crash_kexec() and
other emergency reboot flows disable virtualization and set 'kvm_rebooting'
without touching system_state.  VMX and SVM rely on 'kvm_rebooting' being set to
avoid triggering (another) BUG() during the emergency.

On my todo list is to better understand whether or not the other architectures
that utilize the generic hardware enabling (ARM, RISC-V, MIPS) truly need to disable
virtualization during a reboot, versus KVM simply being polite.  E.g. on x86, if VMX
is left enabled, reboot may hang depending on how the reboot is performed.   If
other architectures really truly need to disable virtualization, then they likely
need something similar to x86's emergency reboot shenanigans.
