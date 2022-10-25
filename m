Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B1AFA373E
	for <kvmarm@archiver.kernel.org>; Tue, 25 Oct 2022 17:47:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 480464086D;
	Tue, 25 Oct 2022 13:47:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EJ-Xyk9GJPxO; Tue, 25 Oct 2022 13:47:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05E2140BEE;
	Tue, 25 Oct 2022 13:47:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4186040BFA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2022 13:47:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9HqH9tLs8PI5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Oct 2022 13:47:18 -0400 (EDT)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E36DC4086D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2022 13:47:17 -0400 (EDT)
Received: by mail-pg1-f178.google.com with SMTP id f9so7791953pgj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2022 10:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=x6UfT0PkVqIEzg/b40U6Tv01tgKpXvFjmUedkL8F3Tg=;
 b=k9xkeoWG7NOtnMXuG+hqgpNBFiz/FSbXfzuE99SEhrJRcvzvqP80ltZHkPZPY9WSwI
 gNuPui67QMgeQuj+lRzNd5N5ILXaF5PsgCig6DpqUbx/X9OPHqiNJVnQyKkFA2ldMTHD
 piwSOkYwBqXD/Dk2IXhkQaSTt56Qx4vUjG+pB3JgVLfe/yY46rTrAbuSKZ7ZoSRM0N29
 cSzriVL/KShzU/XXfRAjFvvmYcYm2SVG/atD/P6NQoKq2BaO+4wkUiiiMwteyws3SDpo
 n1PMg7PZ5MF3G5N/TOK26D7h8fdbM29BXEjtGpj3sEiIyFkfwEKaR2PzCBGeRmoyO6Tp
 IZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=x6UfT0PkVqIEzg/b40U6Tv01tgKpXvFjmUedkL8F3Tg=;
 b=MvUrB5vaxkDc+28EfSMRzECU+ITU7KDjc6OdY8Y/Y8c9XoBokfe3YKQX2sIOWyR515
 OQR2DUuTEUwtl4eWYB9qLp5lK8DMHd8eLT1lozZMFd6XbQ61nGgN0skgEsKWe0zzjvUQ
 xw8Mum1CVn/KugVfoiyiTcj+dmC7hp0pW9+4iH1x5mjpIsM0heW1lQItDw0amVxyqJT3
 0UvDltxA8TDFNHP+7W0JMaQzd7GMrCd3YbWxgZoQqfYzx9F0NOiIgdW+BgKt2nc6fWnJ
 eGMV1WooqzNnWtGXoISd6zUO6VBnsvRl5g6QbBEObbwZHE3RYK5fcebuN0Sfmx98tYS3
 2nTw==
X-Gm-Message-State: ACrzQf31m0Gkh7GSOrsP+v/XWVkJgmGUgnQ/5COOLORu4MYPltzeBemj
 nQCCgc2AU2D3BdsqLuGA4Ied+w==
X-Google-Smtp-Source: AMsMyM6syD6+lDTSRfRbcyIlniv5azX8Mx2fGe41xjA6NoF9ZiWiWSLmIYef4Sn3GEMHlbCIh03c/A==
X-Received: by 2002:a63:5144:0:b0:43b:ed4b:224 with SMTP id
 r4-20020a635144000000b0043bed4b0224mr34000005pgl.594.1666720036605; 
 Tue, 25 Oct 2022 10:47:16 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 u8-20020a170902e80800b001869394a372sm1464101plg.201.2022.10.25.10.47.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 Oct 2022 10:47:16 -0700 (PDT)
Date: Tue, 25 Oct 2022 17:47:12 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1ghIKrAsRFwSFsO@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com> <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com> <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com> <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <878rl4gxzx.wl-maz@kernel.org>
Cc: shuah@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 bgardon@google.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Oct 25, 2022, Marc Zyngier wrote:
> On Tue, 25 Oct 2022 01:24:19 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> > > That's why I asked if it's possible for KVM to require a dirty_bitmap when KVM
> > > might end up collecting dirty information without a vCPU.  KVM is still
> > > technically prescribing a solution to userspace, but only because there's only
> > > one solution.
> > 
> > I was trying to allude to something like this by flat-out requiring
> > ring + bitmap on arm64.
> 
> And I claim that this is wrong. It may suit a particular use case, but
> that's definitely not a universal truth.

Agreed, KVM should not unconditionally require a dirty bitmap for arm64.

> > Otherwise, we'd either need to:
> > 
> >  (1) Document the features that explicitly depend on ring + bitmap (i.e.
> >  GIC ITS, whatever else may come) such that userspace sets up the
> >  correct configuration based on what its using. The combined likelihood
> >  of both KVM and userspace getting this right seems low.
> 
> But what is there to get wrong? Absolutely nothing.

I strongly disagree.  On x86, we've had two bugs escape where KVM attempted to
mark a page dirty without an active vCPU.

  2efd61a608b0 ("KVM: Warn if mark_page_dirty() is called without an active vCPU") 
  42dcbe7d8bac ("KVM: x86: hyper-v: Avoid writing to TSC page without an active vCPU")

Call us incompetent, but I have zero confidence that KVM will never unintentionally
add a path that invokes mark_page_dirty_in_slot() without a running vCPU.

By completely dropping the rule that KVM must have an active vCPU on architectures
that support ring+bitmap, those types of bugs will go silently unnoticed, and will
manifest as guest data corruption after live migration.

And ideally such bugs would detected without relying on userspace to enabling
dirty logging, e.g. the Hyper-V bug lurked for quite some time and was only found
when mark_page_dirty_in_slot() started WARNing.

I'm ok if arm64 wants to let userspace shoot itself in the foot with the ITS, but
I'm not ok dropping the protections in the common mark_page_dirty_in_slot().

One somewhat gross idea would be to let architectures override the "there must be
a running vCPU" rule, e.g. arm64 could toggle a flag in kvm->arch in its
kvm_write_guest_lock() to note that an expected write without a vCPU is in-progress:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8c5c69ba47a7..d1da8914f749 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3297,7 +3297,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
        struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 #ifdef CONFIG_HAVE_KVM_DIRTY_RING
-       if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
+       if (!kvm_arch_allow_write_without_running_vcpu(kvm) && WARN_ON_ONCE(!vcpu))
+               return;
+
+       if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
                return;
 #endif
 
@@ -3305,10 +3308,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
                unsigned long rel_gfn = gfn - memslot->base_gfn;
                u32 slot = (memslot->as_id << 16) | memslot->id;
 
-               if (kvm->dirty_ring_size)
+               if (kvm->dirty_ring_size && vcpu)
                        kvm_dirty_ring_push(&vcpu->dirty_ring,
                                            slot, rel_gfn);
-               else
+               else if (memslot->dirty_bitmap)
                        set_bit_le(rel_gfn, memslot->dirty_bitmap);
        }
 }

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
