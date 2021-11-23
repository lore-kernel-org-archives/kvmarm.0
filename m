Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD459C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 18:48:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C1524B1D2;
	Tue, 23 Nov 2021 13:48:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z2a3j4OpukHT; Tue, 23 Nov 2021 13:48:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E1F24B20C;
	Tue, 23 Nov 2021 13:48:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 653CC4B20C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 13:48:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hmEg18TXEeFI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 13:48:33 -0500 (EST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com
 [209.85.219.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 258964B207
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 13:48:33 -0500 (EST)
Received: by mail-yb1-f181.google.com with SMTP id v7so283964ybq.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 10:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=f0cDGU3aBL/JtvFU6Lqj9TIEFTKrrsLTWwNQVeTfm7s=;
 b=UJ+RaSYUdCuTpsCZQj9E3Oh9qJbvyuGy/4UukrBI48rk2Nj58gRp22Q5xYhb4vPTYQ
 S836CgyDfUSjbbUntu1fu6hwQgtOU+NNXS/hpd+ZkuuL5OGlxrNQooDduy8It3MuFzWg
 gzVzhOfTT8FoN4wNgjAdm4R5OlALjGaiHZfAconX1StgxWhu+iNLBHUfAnl5n86L7fsx
 xugVpbFgqEXK+5rIKSzhKsDpTeR+iYDBDYjBvthud8qfespy38O0nRnjyHMQZkeXPBYz
 KmDQil4XmOWKq9l38u9bPGnUPDJhIpUvifcD2bTWFK+f+zh+qcZC+ere/4WKN9vvBo6n
 7EgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=f0cDGU3aBL/JtvFU6Lqj9TIEFTKrrsLTWwNQVeTfm7s=;
 b=LgZxzHSXPH1BEDq4I09BopuXqM7DSuvU9UXTP4wgwVB6ssQSf0nvfY/baoUkShtRRd
 kOcAibwHTTqJoMWswEWFF2uGSC8lEzcZ7jBc4GaRIAuIki1J9laCNFxYcAR9TDgvJjOt
 pyHBN26CNE8w+zScTj3hLs57gxNuDrW2fFMm24c0nbXzA6iKxJRPXTUMG316rIHt/VVA
 M/9df4K0/NUMh56u3Nq048bxaaJFkKP4ndT+kE6Fv14yaPJx+qp24h7nVr+B5mgDyX5v
 ilP3hvvtI4ISI9UNdLQUn1GX9Ta8ryGDa4mAq/FLRykL2uBQRC4KcdXoW69VLW8UKh5n
 ubgA==
X-Gm-Message-State: AOAM532jaR7FATuGWp/CdF9/6VuZMZgCVcgw4ySXMAeA6b0SeJvywfJK
 sIkKj+5urcjs/VZvdtca3kRqtIcImlVSGZ3wld364A==
X-Google-Smtp-Source: ABdhPJzU9v6xYxlXR916SwfBpEwyCUWNGSP479wu5nIbbs9AwafRNm4AxCs/8CG3O42oR0mI9qJxiWj7/+VUFrV8ogU=
X-Received: by 2002:a25:a169:: with SMTP id z96mr8003600ybh.491.1637693312457; 
 Tue, 23 Nov 2021 10:48:32 -0800 (PST)
MIME-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
 <20211113012234.1443009-4-rananta@google.com>
 <87y25gcfti.wl-maz@kernel.org>
In-Reply-To: <87y25gcfti.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 23 Nov 2021 10:48:21 -0800
Message-ID: <CAJHc60yF6BbeQGsYsSLMKd_A1SAVBiZLXBdWMO9NFH1Y2h4JRg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/11] KVM: Introduce kvm_vm_has_run_once
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Nov 22, 2021 at 8:31 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 13 Nov 2021 01:22:26 +0000,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > The upcoming patches need a way to detect if the VM, as
> > a whole, has started. Hence, unionize kvm_vcpu_has_run_once()
> > of all the vcpus of the VM and build kvm_vm_has_run_once()
> > to achieve the functionality.
> >
> > No functional change intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  include/linux/kvm_host.h |  2 ++
> >  virt/kvm/kvm_main.c      | 17 +++++++++++++++++
> >  2 files changed, 19 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index b373929c71eb..102e00c0e21c 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1854,4 +1854,6 @@ static inline bool kvm_vcpu_has_run_once(struct kvm_vcpu *vcpu)
> >       return vcpu->has_run_once;
> >  }
> >
> > +bool kvm_vm_has_run_once(struct kvm *kvm);
> > +
> >  #endif
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 1ec8a8e959b2..3d8d96e8f61d 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4339,6 +4339,23 @@ static int kvm_vm_ioctl_get_stats_fd(struct kvm *kvm)
> >       return fd;
> >  }
> >
> > +bool kvm_vm_has_run_once(struct kvm *kvm)
> > +{
> > +     int i, ret = false;
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     mutex_lock(&kvm->lock);
> > +
> > +     kvm_for_each_vcpu(i, vcpu, kvm) {
> > +             ret = kvm_vcpu_has_run_once(vcpu);
> > +             if (ret)
> > +                     break;
> > +     }
> > +
> > +     mutex_unlock(&kvm->lock);
> > +     return ret;
> > +}
>
> This is horribly racy. Nothing prevents a vcpu from running behind
> your back. If you want any sort of guarantee, look at what we do in
> kvm_vgic_create(). Alexandru has patches that extract it to make it
> generally available (at least for arm64).
>
Yes, I looked into kvm_lock_all_vcpus(), but the fact that the series
would call the function with the current vcpu lock held caused me to
back off..
Perhaps I can come up with a similar function, kvm_lock_all_vcpus_except(vcpu) ?

Regards,
Raghavendra

>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
