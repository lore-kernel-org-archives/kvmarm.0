Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C372AD4A
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 17:44:56 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id 3-20020a17090a0f8300b00212d5cd4e5eso7225118pjz.4
        for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 10:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q5c4/+RxPj63577Cu1nifyDq83AUirvqoeSZewd7dIg=;
        b=S4cOj3RJR3KlfSSTVpWantzeoh1YFXAN4WpGbDxghDi4XuxFuN5Esc5cYHQIlN34qT
         CzL7/bbQp18QzSLOK7OHVHdjdHdDF6aHPxX6wahjuNh4Fz8yh8XYEkmb6udcHthyJPVn
         1ZNqJrKYE7s0irC3dUkr1gSsBBVvMvRU7tixYF1iOQ/uUdVpdkn4czh6TorZE1cdQ0Gb
         vWAheqJhK1LCA6uYqc+EZ89IyncuoBUZWJ8kN8nDMnYOtiShaY4fp0EvRdzB2o8sUiWd
         gyN7VdqESv2E9rtfRWuRKHCQ89x8xENTU1w4ASJWUwDA9cfEUaeZANZGKnltm8bBigAU
         uR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5c4/+RxPj63577Cu1nifyDq83AUirvqoeSZewd7dIg=;
        b=e9QDXyEAE3iAltaAFYfqwrjdR+toaBhJ+k7nCzWFZNR9r77PwRLobWTz5gcKSfWfz8
         NXq8XfO9oCk/IIZv+q8J7faMlHs/b+FsOYOgzC/G1rsB7jTWRMGh86Xswoe5F4GWTizj
         vUgVmXNznH7PDPIfT5g17ruS8MI6gX3vVCMYFIrdi1kyJ/AR34ypyJhiIgAFxs6kuqdk
         ue9lwhnZxuy2lawEL4nRSjsI5ECCyKo0hZKyOojYXddAhDoeRn7pVnkR3cPyZfuPrUK9
         R3nGFCke3L0Xmk81d3xAnY4cf7pcvvNzr+KyoLb692xGGvbMk2pfGc/lrLM/7O/Y5XLQ
         xWXQ==
X-Gm-Message-State: ACrzQf2oq+tymJl285VbKuTdJjgxJDcbQpoGhkFpcIesI98UqxKAqWAM
	FZWuSsYx42Q6lsOEmmiqEqxMSA==
X-Google-Smtp-Source: AMsMyM7G6q7BzXM3ZQI4nRtOz8jjvF+NAsGCL1JUEV6PD+ITzkr1az8n26v3M5B4mb3+kD4l+1Zmaw==
X-Received: by 2002:a17:903:120d:b0:178:a6ca:b974 with SMTP id l13-20020a170903120d00b00178a6cab974mr49920600plh.8.1666892695634;
        Thu, 27 Oct 2022 10:44:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s15-20020a170902b18f00b00185002f0c6csm1456085plr.134.2022.10.27.10.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 10:44:55 -0700 (PDT)
Date: Thu, 27 Oct 2022 17:44:51 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Gavin Shan <gshan@redhat.com>,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, peterx@redhat.com, will@kernel.org,
	catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
	andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
	zhenyzha@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1rDkz6q8+ZgYFWW@google.com>
References: <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com>
 <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com>
 <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com>
 <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org>
 <Y1ghIKrAsRFwSFsO@google.com>
 <877d0lhdo9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877d0lhdo9.wl-maz@kernel.org>
Message-ID: <20221027174451.d799sSyXS-qBsCWi1ABg6zNxtsVwXDdmGpvGKjkxkMQ@z>

On Thu, Oct 27, 2022, Marc Zyngier wrote:
> On Tue, 25 Oct 2022 18:47:12 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > Call us incompetent, but I have zero confidence that KVM will never
> > unintentionally add a path that invokes mark_page_dirty_in_slot()
> > without a running vCPU.
> 
> Well, maybe it is time that KVM acknowledges there is a purpose to
> dirtying memory outside of a vcpu context, and that if a write happens
> in a vcpu context, this vcpu must be explicitly passed down rather
> than obtained from kvm_get_running_vcpu(). Yes, this requires some
> heavy surgery.

Heh, preaching to the choir on this one.

  On Mon, Dec 02, 2019 at 12:10:36PM -0800, Sean Christopherson wrote:
  > IMO, adding kvm_get_running_vcpu() is a hack that is just asking for future
  > abuse and the vcpu/vm/as_id interactions in mark_page_dirty_in_ring() look
  > extremely fragile.

I'm all in favor of not using kvm_get_running_vcpu() in this path.

That said, it's somewhat of an orthogonal issue, as I would still want a sanity
check in mark_page_dirty_in_slot() that a vCPU is provided when there is no
dirty bitmap.

> > By completely dropping the rule that KVM must have an active vCPU on
> > architectures that support ring+bitmap, those types of bugs will go
> > silently unnoticed, and will manifest as guest data corruption after
> > live migration.
> 
> The elephant in the room is still userspace writing to its view of the
> guest memory for device emulation. Do they get it right? I doubt it.

I don't see what that has to do with KVM though.  There are many things userspace
needs to get right, that doesn't mean that KVM shouldn't strive to provide
safeguards for the functionality that KVM provides.

> > And ideally such bugs would detected without relying on userspace to
> > enabling dirty logging, e.g. the Hyper-V bug lurked for quite some
> > time and was only found when mark_page_dirty_in_slot() started
> > WARNing.
> > 
> > I'm ok if arm64 wants to let userspace shoot itself in the foot with
> > the ITS, but I'm not ok dropping the protections in the common
> > mark_page_dirty_in_slot().
> > 
> > One somewhat gross idea would be to let architectures override the
> > "there must be a running vCPU" rule, e.g. arm64 could toggle a flag
> > in kvm->arch in its kvm_write_guest_lock() to note that an expected
> > write without a vCPU is in-progress:
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 8c5c69ba47a7..d1da8914f749 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3297,7 +3297,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> >         struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> >  
> >  #ifdef CONFIG_HAVE_KVM_DIRTY_RING
> > -       if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
> > +       if (!kvm_arch_allow_write_without_running_vcpu(kvm) && WARN_ON_ONCE(!vcpu))
> > +               return;
> > +
> > +       if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
> >                 return;
> >  #endif
> >  
> > @@ -3305,10 +3308,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> >                 unsigned long rel_gfn = gfn - memslot->base_gfn;
> >                 u32 slot = (memslot->as_id << 16) | memslot->id;
> >  
> > -               if (kvm->dirty_ring_size)
> > +               if (kvm->dirty_ring_size && vcpu)
> >                         kvm_dirty_ring_push(&vcpu->dirty_ring,
> >                                             slot, rel_gfn);
> > -               else
> > +               else if (memslot->dirty_bitmap)
> >                         set_bit_le(rel_gfn, memslot->dirty_bitmap);
> >         }
> >  }
> 
> I think this is equally wrong. Writes occur from both CPUs and devices
> *concurrently*, and I don't see why KVM should keep ignoring this
> pretty obvious fact.
>
> Yes, your patch papers over the problem, and it can probably work if
> the kvm->arch flag only gets set in the ITS saving code, which is
> already exclusive of vcpus running.
> 
> But in the long run, with dirty bits being collected from the IOMMU
> page tables or directly from devices, we will need a way to reconcile
> the dirty tracking. The above doesn't quite cut it, unfortunately.

Oooh, are you referring to IOMMU page tables and devices _in the guest_?  E.g. if
KVM itself were to emulate a vIOMMU, then KVM would be responsible for updating
dirty bits in the vIOMMU page tables.

Not that it really matters, but do we actually expect KVM to ever emulate a vIOMMU?
On x86 at least, in-kernel acceleration of vIOMMU emulation seems more like VFIO
territory.

Regardless, I don't think the above idea makes it any more difficult to support
in-KVM emulation of non-CPU stuff, which IIUC is the ITS case.  I 100% agree that
the above is a hack, but that's largely due to the use of kvm_get_running_vcpu().

A slightly different alternative would be have a completely separate API for writing
guest memory without an associated vCPU.  I.e. start building up proper device emulation
support.  Then the vCPU-based APIs could yell if a vCPU isn't provided (or there
is no running vCPU in the current mess).  And the deviced-based API could be
provided if and only if the architecture actually supports emulating writes from
devices, i.e. x86 would not opt-in and so would even have access to the API.
