Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4E6186C
	for <kvmarm@lists.linux.dev>; Sun, 23 Jul 2023 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690131199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7Q6jB5+JjJCoMhkXTEgRxsVxQLYVK7nw0Y30rzdcso=;
	b=bgX3hPY2mN4xFNL7OYRFvzVAhL6aMI/Y6l1FsGpRlk+rnAj8dW4M+FOJzeIdv/esYeh6XH
	YaN53B02ywuKSpC46jbJLAy5I4JXRwMK5onVWmn1mDVdb5f502DFisxLAliOsYEotiKuxh
	aPu4zxEgAykfiWIxcjzJi22A2Jp7AVI=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-A-r7JG2LNOK9yoihEft-Lg-1; Sun, 23 Jul 2023 12:53:18 -0400
X-MC-Unique: A-r7JG2LNOK9yoihEft-Lg-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-796db7924e0so960717241.2
        for <kvmarm@lists.linux.dev>; Sun, 23 Jul 2023 09:53:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690131197; x=1690735997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K7Q6jB5+JjJCoMhkXTEgRxsVxQLYVK7nw0Y30rzdcso=;
        b=RHHGu9wgZlUN+dccSqlVdaFmV9cOPdlaHo2YRQvhB0Mb6RxGjd8yD5ku0xVGTA0QOt
         BPbYX8DGBnV94Mn7lyeM0Y1/g1QlSc7b0bpkbx2uyvPM/S4dGElYRpWOpLvwc41It6MQ
         sjto8q+yVXRW4EHIK5Hf3ntpwVVC+UoI0TW+gDOy9tbX2wdhca4+xw+wStE+WQAFFWCT
         tjYXr0szfcLM36+ez7aRTpa88eLlSwkajYi0sALN36FjKZwU9vkqtu4yTf5jW/lpGuj1
         P89fAywwwAjUPKaha/RhQgcDFnmWrYeOnk2nr3q9VnwhCPdKYIKk4vMQyTc2nyzegTfd
         132Q==
X-Gm-Message-State: ABy/qLa30VmV04jIE4o9TMcakYOZjdhFwH3Sa0vcDrYLUasQkSkv/f1J
	bjrxsf/e/Oc6D3JicJrfw2kh4V9PPySDi4QBOjbQPuN8bI+Cv7fIS3PCiIPKie0DnjrWZuqWdNu
	kXaDoWzL6RaPckdm8bCBi1tYybYDBDTNt
X-Received: by 2002:a05:6102:3d6:b0:444:c2cb:d525 with SMTP id n22-20020a05610203d600b00444c2cbd525mr2140240vsq.31.1690131197562;
        Sun, 23 Jul 2023 09:53:17 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHE7PFTbUUGsD4fJxXrXa4KpCiAW59I3ahU68nmE+/HLCmOCRZ11smJOZnJGNMvvyP98i3mAp5k/Co+1iNu4PY=
X-Received: by 2002:a05:6102:3d6:b0:444:c2cb:d525 with SMTP id
 n22-20020a05610203d600b00444c2cbd525mr2140234vsq.31.1690131197316; Sun, 23
 Jul 2023 09:53:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZLYnolPWJubKLZY8@thinky-boi> <ZLYn/RAovUs+U0r+@thinky-boi>
In-Reply-To: <ZLYn/RAovUs+U0r+@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 23 Jul 2023 18:53:05 +0200
Message-ID: <CABgObfYC9UmCdnDryryPGPp_BOdOjH8bRK=e7f-R5CJXJ-Ae_Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.5, part #1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Mostafa Saleh <smostafa@google.com>, Xiang Chen <chenxiang66@hisilicon.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 7:49=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> +cc lists, because I'm an idiot.
>
> On Mon, Jul 17, 2023 at 10:48:23PM -0700, Oliver Upton wrote:
> > Hi Paolo,
> >
> > Quite a pile of fixes for the first batch. The most noteworthy here is
> > the BTI + pKVM finalization fixes, which address an early boot failure
> > when using the split hypervisor on systems that support BTI and make th=
e
> > overall pKVM flow more robust to failures.
> >
> > Otherwise, we have a respectable collection of one-offs described in th=
e
> > tag message.
> >
> > Please pull.

Pulled, thanks. Should be in time for -rc3.

Paolo

> >
> > --
> > Thanks,
> > Oliver
> >
> > The following changes since commit 06c2afb862f9da8dc5efa4b6076a0e48c3fb=
aaa5:
> >
> >   Linux 6.5-rc1 (2023-07-09 13:53:13 -0700)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/=
kvmarm-fixes-6.5-1
> >
> > for you to fetch changes up to 9d2a55b403eea26cab7c831d8e1c00ef1e6a6850=
:
> >
> >   KVM: arm64: Fix the name of sys_reg_desc related to PMU (2023-07-14 2=
3:34:05 +0000)
> >
> > ----------------------------------------------------------------
> > KVM/arm64 fixes for 6.5, part #1
> >
> >  - Avoid pKVM finalization if KVM initialization fails
> >
> >  - Add missing BTI instructions in the hypervisor, fixing an early boot
> >    failure on BTI systems
> >
> >  - Handle MMU notifiers correctly for non hugepage-aligned memslots
> >
> >  - Work around a bug in the architecture where hypervisor timer control=
s
> >    have UNKNOWN behavior under nested virt.
> >
> >  - Disable preemption in kvm_arch_hardware_enable(), fixing a kernel BU=
G
> >    in cpu hotplug resulting from per-CPU accessor sanity checking.
> >
> >  - Make WFI emulation on GICv4 systems robust w.r.t. preemption,
> >    consistently requesting a doorbell interrupt on vcpu_put()
> >
> >  - Uphold RES0 sysreg behavior when emulating older PMU versions
> >
> >  - Avoid macro expansion when initializing PMU register names, ensuring
> >    the tracepoints pretty-print the sysreg.
> >
> > ----------------------------------------------------------------
> > Marc Zyngier (3):
> >       KVM: arm64: timers: Use CNTHCTL_EL2 when setting non-CNTKCTL_EL1 =
bits
> >       KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
> >       KVM: arm64: vgic-v4: Make the doorbell request robust w.r.t preem=
ption
> >
> > Mostafa Saleh (1):
> >       KVM: arm64: Add missing BTI instructions
> >
> > Oliver Upton (2):
> >       KVM: arm64: Correctly handle page aging notifiers for unaligned m=
emslot
> >       KVM: arm64: Correctly handle RES0 bits PMEVTYPER<n>_EL0.evtCount
> >
> > Sudeep Holla (1):
> >       KVM: arm64: Handle kvm_arm_init failure correctly in finalize_pkv=
m
> >
> > Xiang Chen (1):
> >       KVM: arm64: Fix the name of sys_reg_desc related to PMU
> >
> >  arch/arm64/include/asm/kvm_host.h    |  2 ++
> >  arch/arm64/include/asm/kvm_pgtable.h | 26 +++++++-------------
> >  arch/arm64/include/asm/virt.h        |  1 +
> >  arch/arm64/kvm/arch_timer.c          |  6 ++---
> >  arch/arm64/kvm/arm.c                 | 28 ++++++++++++++++++---
> >  arch/arm64/kvm/hyp/hyp-entry.S       |  8 ++++++
> >  arch/arm64/kvm/hyp/nvhe/host.S       | 10 ++++++++
> >  arch/arm64/kvm/hyp/nvhe/psci-relay.c |  2 +-
> >  arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++=
+-------
> >  arch/arm64/kvm/mmu.c                 | 18 ++++++--------
> >  arch/arm64/kvm/pkvm.c                |  2 +-
> >  arch/arm64/kvm/sys_regs.c            | 42 ++++++++++++++++------------=
----
> >  arch/arm64/kvm/vgic/vgic-v3.c        |  2 +-
> >  arch/arm64/kvm/vgic/vgic-v4.c        |  7 ++++--
> >  include/kvm/arm_vgic.h               |  2 +-
> >  15 files changed, 133 insertions(+), 70 deletions(-)
>

