Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8244FC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 13:31:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C39644B13D;
	Tue, 10 May 2022 09:31:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lD4eYmhRkpoH; Tue, 10 May 2022 09:31:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B4E34B0F5;
	Tue, 10 May 2022 09:31:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 564BF4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 09:31:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CNdC67ql-6PQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 09:31:27 -0400 (EDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AAF04B0ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 09:31:27 -0400 (EDT)
Received: by mail-pj1-f43.google.com with SMTP id
 l11-20020a17090a49cb00b001d923a9ca99so2155586pjm.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 06:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=eAkpZobv3rZ1Hb3Ti+DnJgCEz5o6zS6z0CRMJI9AM3s=;
 b=jBI/IJVRvrcXrn0dmybmF38aVhy0igFdbEZFkPme71/HQ9GvoJ+XAo/584Dy/1j/IA
 eKmiNsg0QRnSUTK2r3JdsiSVecH2pp3BGQdPp8VUZP0AqAKfmpxphSqIYnjeLfeiFQPG
 4Oyh1vHBKMAuToyEeJKAEgJwkwHU1mz4dTg0y1Ydho5V/mtT1ywbMxTJ9EVQ5RngOgK4
 eRanlq+s+j1OL6oL8R7ETXaFshDMsAfkYQ7LzPnxpf6kZ6VCMXr3Kv9r4owShVPjEnc9
 5kAIxQgrPSRtOygh+uwcCxIwjofUsWOOJSGJo5Md3peUgiztJejwvlLNLjWbLn4m1Njx
 nmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eAkpZobv3rZ1Hb3Ti+DnJgCEz5o6zS6z0CRMJI9AM3s=;
 b=tVpIOYYCdO6e336YBetMtRIWJ/nanaGYU/xOLUadNV3xJ/r/H1o3uT52fvkg0quxf+
 zOOQYd0tWhMpGI1MJWNZyzA12OIgnoIad1MDyIcEIy0cNL54w09Aijm0QwWHmoN2cQcU
 KT1c9jJoJZqKwk20Yfxxk+1RpIIBToE74/twjkFEzKPe7HEV+ZO0DaF3EirJGeqNqJ3H
 OpaCfc84T2OUHACwOwwvkpE8DkT8An8GEyYrTt83opuF8Wlzf6tUHRL3H4TSJAJB6+1i
 H4Ima0bbomCpQvJ61P/8zt89GK6s7KAvxVU9QxA6Tbbd6z0rfjBIGUCuDy6GjNxgZTgN
 k1jA==
X-Gm-Message-State: AOAM533QehbKIg3mZylUZkIRcXj6edGEv5wGm1Fah6dJ/yU5M11OL82+
 /XOpNXNuRSEMJKVMrP1JGQl15Q==
X-Google-Smtp-Source: ABdhPJy7im86kJAw08T88EHkeZvOY5JH1GuJc2LoV3L/ahvJpYDIzSXEONMZQ/5L8AsbQATcBcnd/Q==
X-Received: by 2002:a17:902:d4ce:b0:15e:90f8:216c with SMTP id
 o14-20020a170902d4ce00b0015e90f8216cmr21440392plg.65.1652189485589; 
 Tue, 10 May 2022 06:31:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 r5-20020a170902ea4500b0015eddb8e450sm2048059plg.25.2022.05.10.06.31.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 10 May 2022 06:31:25 -0700 (PDT)
Date: Tue, 10 May 2022 13:31:21 +0000
From: Sean Christopherson <seanjc@google.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v4 03/20] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <YnppKY8j78Z1E6bH@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-4-dmatlack@google.com>
 <75fbbcb6-d9bb-3d30-0bf4-fbf925517d09@gmail.com>
 <CALzav=dmseUw6khErkiSV7T5K88QvaRvWvBpvrb6VNOQTE3bQQ@mail.gmail.com>
 <CAJhGHyDQn=atFmn5o2TREW9cSY5Tv1F1vsSekzor6uYQxDgcfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJhGHyDQn=atFmn5o2TREW9cSY5Tv1F1vsSekzor6uYQxDgcfQ@mail.gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)" <kvm@vger.kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Tue, May 10, 2022, Lai Jiangshan wrote:
> ()
> 
> On Tue, May 10, 2022 at 5:04 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Sat, May 7, 2022 at 1:28 AM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
> > > > +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> > > > +{
> > > > +     struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> > > > +     union kvm_mmu_page_role role;
> > > > +
> > > > +     role = parent_sp->role;
> > > > +     role.level--;
> > > > +     role.access = access;
> > > > +     role.direct = direct;
> > > > +
> > > > +     /*
> > > > +      * If the guest has 4-byte PTEs then that means it's using 32-bit,
> > > > +      * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> > > > +      * directories, each mapping 1/4 of the guest's linear address space
> > > > +      * (1GiB). The shadow pages for those 4 page directories are
> > > > +      * pre-allocated and assigned a separate quadrant in their role.
> > >
> > >
> > > It is not going to be true in patchset:
> > > [PATCH V2 0/7] KVM: X86/MMU: Use one-off special shadow page for special roots
> > >
> > > https://lore.kernel.org/lkml/20220503150735.32723-1-jiangshanlai@gmail.com/
> > >
> > > The shadow pages for those 4 page directories are also allocated on demand.
> >
> > Ack. I can even just drop this sentence in v5, it's just background information.
> 
> No, if one-off special shadow pages are used.
> 
> kvm_mmu_child_role() should be:
> 
> +       if (role.has_4_byte_gpte) {
> +               if (role.level == PG_LEVEL_4K)
> +                       role.quadrant = (sptep - parent_sp->spt) % 2;
> +               if (role.level == PG_LEVEL_2M)

If the code ends up looking anything like this, please use PT32_ROOT_LEVEL instead
of PG_LEVEL_2M.  PSE paging has 4M huge pages, using PG_LEVEL_2M is confusing.

Or even better might be to do:

		if (role.level == PG_LEVEL_4k)
			...
		else
			...

Or arithmetic using role.level directly, a la the current code.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
