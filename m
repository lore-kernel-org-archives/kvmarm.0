Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B27A23A3
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 23:45:57 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-4c7d35b37e2so77842697b3.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 15:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v2+KX7du7whicN+PS9fU23ysrGOmXoF+0M7DLlUtPuI=;
        b=ZgXn18vNNIICztMBawwC/7R15H4RvIurJtsuiESatewLzdxVJ22qGKGLsYNSGMZ/1J
         kqJLhrCdHZfEqLtaEJm+rwlCpUoN72QGA5WVuZ8lata0hrkjF1Aaiw83E2DGTR1TLzPf
         nNoYt+MXL0z4WrfBV20/KqlOYo8TDx8tKu1JfbOPASVmZzAhUuBLvK+64mgWSBD+BbW3
         ROGwxnI+BsBHpTm0li51OCl/YPPJ7hHh9rpDw68lVJt5LxQOI3tQoU8Js5bzfBdgqGPB
         L2rct/g75bwCkbvS3IGeYwyWqqDw2S7JPd7q5lIniApGK+jI1ovfHWIhIO5+udTgqATx
         hrpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v2+KX7du7whicN+PS9fU23ysrGOmXoF+0M7DLlUtPuI=;
        b=nWyMxb/4lD/ZH7ac60/a3zZgOb80/ma/6gA/Mw6ZzDzu3Pjk4KZJhgQj7S2ZJm5o0q
         YEXcESOUpLE7H4cDP/QSBIE3qsBhvluGEf4/YAJaLww36ns0uyRbC5cLjmyRniN3CdNC
         oZwI5bwfjBPqPx6GLxk9fmNcXgVWfq1YxLFS/hKebjUY4H+lsYuOTqHodiidxrWE8pcL
         m1TxERUhyVX05obJE+sfRxyqUeA6yx3luDHDyT/yGuOQU43jtzPxCXzh0kAdNTSMMs0C
         /4wg6bQFyc47YigwBcwouycLLzFjRggoZpcWSPRn0TZZ8+kCiBHzMoDbAfM7pYqCnFtn
         gBkw==
X-Gm-Message-State: AFqh2kpCp/Zlbqm9V46VkTZZYOAsQQc9bHGoygJV3mMHRXyJvGZHV8xm
	dJ0FYjm8ksNZESrnQaBDLmZkeJNiKqzgDazDRvyMEg==
X-Google-Smtp-Source: AMrXdXtiOGtj7wxlgeBUlNrKN/Gt85LVD0b/yBSFIPRATuoaFVxXPi/DrmaKnwECCcPeNhPtU69RvhrNET3mcgBYxKQ=
X-Received: by 2002:a0d:fc84:0:b0:3df:6a50:40ec with SMTP id
 m126-20020a0dfc84000000b003df6a5040ecmr2231052ywf.340.1673307956007; Mon, 09
 Jan 2023 15:45:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109215347.3119271-1-rananta@google.com> <20230109215347.3119271-4-rananta@google.com>
 <Y7ymEiU1ZC/gzs9s@google.com>
In-Reply-To: <Y7ymEiU1ZC/gzs9s@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 Jan 2023 15:45:30 -0800
Message-ID: <CALzav=cqPv5coe3iei9wMHR_W-PbQWDpaFKzGeUL36Fz0NcB_Q@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] KVM: Define kvm_flush_remote_tlbs_range
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, Reiji Watanabe <reijiw@google.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 9, 2023 at 3:41 PM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, Jan 09, 2023 at 09:53:44PM +0000, Raghavendra Rao Ananta wrote:
> > +{
> > +     kvm_flush_remote_tlbs(kvm);
> > +}
>
> FYI I also proposed a common kvm_flush_remote_tlbs() in my Common MMU
> series [1].
>
> Could I interest you in grabbing patches 29-33 from that series, which
> has the same end result (common kvm_flush_remote_tlbs_range()) but also
> hooks up the KVM/x86 range-based flushing, and folding them into this
> series?
>
> [1] https://lore.kernel.org/kvm/20221208193857.4090582-33-dmatlack@google.com/

(Also they make kvm_arch_flush_remote_tlbs_memslot() common so you
don't need the ARM-specific implementation in patch 4.)

>
> >  #endif
> >
> >  static void kvm_flush_shadow_all(struct kvm *kvm)
> > @@ -637,7 +642,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
> >       }
> >
> >       if (range->flush_on_ret && ret)
> > -             kvm_flush_remote_tlbs(kvm);
> > +             kvm_flush_remote_tlbs_range(kvm, range->start, range->end - 1);
> >
> >       if (locked) {
> >               KVM_MMU_UNLOCK(kvm);
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
