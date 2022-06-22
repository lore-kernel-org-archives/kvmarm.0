Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F4CCCA47D
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 14:19:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19F9C4B4C2;
	Wed, 22 Jun 2022 10:19:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NKL1RwI5Giqe; Wed, 22 Jun 2022 10:19:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D68044B4C7;
	Wed, 22 Jun 2022 10:19:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFA224B4C5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 10:19:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sq3fj3Zl4c7C for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 10:19:50 -0400 (EDT)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC3414B4C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 10:19:50 -0400 (EDT)
Received: by mail-pj1-f51.google.com with SMTP id
 t3-20020a17090a510300b001ea87ef9a3dso16933630pjh.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 07:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=BzxAUPe5okJNZee9MSLP9PbTGm5gfg8v2qRMcdUL4+0=;
 b=O5heBvklZbSxZj/ed0HHu9xg0cdTwcYZ8+1Mjr1qOthOBcuL3F9RzDjiYKE75UUzAP
 WobpdUABHfVrVHR4WoRgqgX79lY4x9h/QuPsPLqYJExoaBsPkFWX19IOZLZGbQkTHleX
 mg+UFVEr82lEQV/7FHyoPxYREI10yKRjqDF0+BgNbaGNtjmwGrEUOHfsnV0MdXCsAKDk
 ZTF0mGNGbdPoDUnH6eMhHUiZCdLcIDDHE3nvqC9Rjgh7OxSxwlT693WnktZnMplJdla6
 eEOEq3SwN+x7zeTkBSI2ha03O/T2Ch7h4aYsWxOgsb8+k7k2Jf3TbVINN3tzzz/Ji1y6
 rQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=BzxAUPe5okJNZee9MSLP9PbTGm5gfg8v2qRMcdUL4+0=;
 b=ZXqHwr55QYaG+UvfsxCUcNzFORzfF1n+13iw/+il5K6mVI1NZyx6DYb1FymNyXavnM
 VvdryA2Vm2xODnCZaVDWJ5tNYMIM0xXsd1nKCw0UnL7f9j/Aa+3kEVS7M5fbuuS2eKV4
 IU9Up1sJyk/X5XkTiFNPFmrvcu5CCkjIGdCRq6NoZVDhKTNWX39giYYjBO4Ij8JE33qG
 PvyRHKKbNF2DOzlJ/JsQjU/WPHrwyv6DRT8LepR93Jro3oFjxKvkpcSoYiinDIuBjSDL
 JjQVD9pPIiUs3XWRC2FO34Sf6EFQvlXM21F/oQhQlrAlCotmcBW9E1jJvG7VU1nNPVxi
 CwoQ==
X-Gm-Message-State: AJIora9yhwneYEBHvXvLkJNTjptkbDv+zll9TMSmTfpTeOIaYC124FWZ
 HUJDQAu5IL4xuhsyl5uhttv3iA==
X-Google-Smtp-Source: AGRyM1s6BHwkunCCOtr1rJlpNZ/lT0ticChntRH0O/W4Ed8+WafDWpg6DiHb+22bQYkLURbtDY22vg==
X-Received: by 2002:a17:902:8689:b0:14e:f1a4:d894 with SMTP id
 g9-20020a170902868900b0014ef1a4d894mr34493773plo.65.1655907589586; 
 Wed, 22 Jun 2022 07:19:49 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 i6-20020a626d06000000b0051c09cdd71fsm13518188pfc.72.2022.06.22.07.19.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Jun 2022 07:19:47 -0700 (PDT)
Date: Wed, 22 Jun 2022 14:19:43 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 03/22] KVM: x86/mmu: Stop passing @direct to
 mmu_alloc_root()
Message-ID: <YrMk/z4HCvX0ASPm@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-4-dmatlack@google.com>
 <Yqt6rBPMxfwAPjp1@google.com>
 <bb22c823-f12f-90d8-e8d6-0cddba95f60a@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bb22c823-f12f-90d8-e8d6-0cddba95f60a@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 David Matlack <dmatlack@google.com>, maciej.szmigiero@oracle.com,
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

On Wed, Jun 22, 2022, Paolo Bonzini wrote:
> On 6/16/22 20:47, Sean Christopherson wrote:
> > > The argument @direct is vcpu->arch.mmu->root_role.direct, so just use
> > > that.
> > It's worth calling out that, unlike non-root page tables, it's impossible to have
> > a direct root in an indirect MMU.  I.e. provide a hint as to why there's a need to
> > pass @direct in the first place.
> > 
> 
> I suppose there's *no* need to pass direct?  Also, there's the trivial (but
> less interesting) justification that kvm_mmu_load does
> 
>         if (vcpu->arch.mmu->root_role.direct)
>                 r = mmu_alloc_direct_roots(vcpu);
>         else
>                 r = mmu_alloc_shadow_roots(vcpu);
> 
> and those are the only callers of mmu_alloc_root.

Duh, you're right, grabbing root_role.direct in mmu_alloc_root() is much better.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
