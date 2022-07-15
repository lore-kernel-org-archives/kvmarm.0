Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAFBC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:44:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 515674BD74;
	Fri, 15 Jul 2022 02:44:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ap55H95Ud0Py; Fri, 15 Jul 2022 02:44:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A3084BD6D;
	Fri, 15 Jul 2022 02:44:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A1C24BD5A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:44:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NG8OtuOv6hop for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:44:38 -0400 (EDT)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com
 [209.85.222.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E5EA4BC8B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:44:38 -0400 (EDT)
Received: by mail-ua1-f50.google.com with SMTP id v17so167968uam.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=p6aDTSAubguJZg+3J+aZpS+pct8nChj++g4A7S8KF7M=;
 b=Jnbw9hVnECgNwloAV8Mr84FXTmguVIg5NfAo3mkCvlZ4hKp8wmbAxT8ZXMLH50tbHb
 2AtcqfP7CDR/M2LkGerzE4RjbEo3t0+wZ9znySMf0cboWxAHISnGNymaU4u4n+DgDwhw
 xYDBbeKC7uGCempsmTNjSBbKGkPxxwW3Lqd2C0PTh/i165tqfnkbP9i7mbujFw+EPnEZ
 0W1uYTZ92SNd5HFvJYLmeUvWHvtwMq0ad8SjNTIwuNai2ZMDD4PXZt1XZSsnuQ2QBtGi
 BNiQD6ngvkYHgXMzozebc4+/+kt2uNmiAg7HN/zBnwKI+0QIme1wAPU4861wQ7qFEZXb
 9YRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=p6aDTSAubguJZg+3J+aZpS+pct8nChj++g4A7S8KF7M=;
 b=R+k4GnkI/lwzBPJRxAD+ZDVCqBBJpqDLUelcE6Ba+TZs2fRE0uodSW4uax8sVj6k/R
 OxfZUUQBBel6qEusuZG+NcmqEYBDSDPUlIZ00xMIauJY9yTfBYhmGucw4w0uEP1BWq8g
 6A7HVE01ctwDrdvyRGGshBvQdI70rnHXrHQha12yqVLGcLAHYOgya/Ux3v2yazZgvdpn
 FgmN8ubljNBFNn1IxV0B5YC/Tysq49iVfAFGMHtFThxLAbllb3k+zciqMpE73ghunZzk
 rjeR/fzXPC6XxIRn7K1iSkITXb83fRaqjfpvZkxrjP+d/mtsXGBHtkuJnOMKrsLCpomA
 IwXA==
X-Gm-Message-State: AJIora8gHF0OpDKoIuGdsTbmlJScyYoYgEYkVr1YEUH0MtqRivMlwJ18
 Hc85Ri5EJFmzA6X1OfOLbevJAVrMnv58aVkWP6uQ3Q==
X-Google-Smtp-Source: AGRyM1uWE0AM135v8bgmHTfGGyyoJpV55Gqxr8UiXmUhCXS1dGfLbxzAYnRhlP4kgcMpR7lq+JXvgxe6eP5xZy9syp8=
X-Received: by 2002:a05:6130:90:b0:362:891c:edef with SMTP id
 x16-20020a056130009000b00362891cedefmr5471902uaf.106.1657867477456; Thu, 14
 Jul 2022 23:44:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-16-maz@kernel.org>
 <CAAeT=FzgBpwcf7oEGeCLCHO+XadP+i7vyPFWx6VJxmiWC94-7g@mail.gmail.com>
 <877d4gyy7y.wl-maz@kernel.org>
In-Reply-To: <877d4gyy7y.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 14 Jul 2022 23:44:21 -0700
Message-ID: <CAAeT=FwwO5=v3vLJ0qAw3V0NaPEnPeP1VmgLXXBL4jdm80aeew@mail.gmail.com>
Subject: Re: [PATCH 15/19] KVM: arm64: vgic-v2: Add helper for legacy
 dist/cpuif base address setting
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Jul 14, 2022 at 12:01 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 14 Jul 2022 07:37:25 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > We carry a legacy interface to set the base addresses for GICv2.
> > > As this is currently plumbed into the same handling code as
> > > the modern interface, it limits the evolution we can make there.
> > >
> > > Add a helper dedicated to this handling, with a view of maybe
> > > removing this in the future.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/arm.c                  | 11 ++-------
> > >  arch/arm64/kvm/vgic/vgic-kvm-device.c | 32 +++++++++++++++++++++++++++
> > >  include/kvm/arm_vgic.h                |  1 +
> > >  3 files changed, 35 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 83a7f61354d3..bf39570c0aef 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1414,18 +1414,11 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> > >  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> > >                                         struct kvm_arm_device_addr *dev_addr)
> > >  {
> > > -       unsigned long dev_id, type;
> > > -
> > > -       dev_id = (dev_addr->id & KVM_ARM_DEVICE_ID_MASK) >>
> > > -               KVM_ARM_DEVICE_ID_SHIFT;
> > > -       type = (dev_addr->id & KVM_ARM_DEVICE_TYPE_MASK) >>
> > > -               KVM_ARM_DEVICE_TYPE_SHIFT;
> > > -
> > > -       switch (dev_id) {
> > > +       switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {
> > >         case KVM_ARM_DEVICE_VGIC_V2:
> > >                 if (!vgic_present)
> > >                         return -ENXIO;
> > > -               return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
> > > +               return kvm_set_legacy_vgic_v2_addr(kvm, dev_addr);
> > >         default:
> > >                 return -ENODEV;
> > >         }
> > > diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > index fbbd0338c782..0dfd277b9058 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > @@ -41,6 +41,38 @@ static int vgic_check_type(struct kvm *kvm, int type_needed)
> > >                 return 0;
> > >  }
> > >
> > > +int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr)
> > > +{
> > > +       struct vgic_dist *vgic = &kvm->arch.vgic;
> > > +       int r;
> > > +
> > > +       mutex_lock(&kvm->lock);
> > > +       switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {
> >
> > Shouldn't this be KVM_ARM_DEVICE_TYPE_MASK (not KVM_ARM_DEVICE_ID_MASK) ?
>
> Damn, you just ruined my attempt at deprecating this API ;-).

Oops, I should have pretended not to notice:)

> More seriously, thanks for catching this one!

Thank you for cleaning up the code so much!
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
