Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A7AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 30 Mar 2022 14:28:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A36134B0F7;
	Wed, 30 Mar 2022 10:28:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VFdEZLsJz3Ot; Wed, 30 Mar 2022 10:28:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 724B24B1EF;
	Wed, 30 Mar 2022 10:28:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92E0B4B14C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 10:28:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4RBWEYeUDdS8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Mar 2022 10:28:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 853D34B0F7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 10:28:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1648650497;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=0MdzdhvbcfTH7B0x9nhddVD3XG1EagzEGRM2HvvMoaM=;
 b=URkSKNdrjdGvwpy+7NhX/C2hgs298shyXZ1qiTMwEoKzUTpc5vFGUSmW6+Pl5Bx+QTGSwc
 C0MCHhfzu79GFwJLKwsx2beB7hsnmLnnXn2q60CokUrXTKgkbQiLqP+2w2/LSTH75JuGEd
 tAJmfghaPXFaR+L8dSjVo4q/NIcxhm8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-U059LcO_M0WGdo4NLXe9dg-1; Wed, 30 Mar 2022 10:28:13 -0400
X-MC-Unique: U059LcO_M0WGdo4NLXe9dg-1
Received: by mail-qv1-f71.google.com with SMTP id
 ba7-20020ad45527000000b0044105fb3d5fso16183655qvb.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 07:28:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=0MdzdhvbcfTH7B0x9nhddVD3XG1EagzEGRM2HvvMoaM=;
 b=lXLJFwK+cwg/3Bz5QGqXMG6PoDFcEplgDBRFz1Z67iDCCuJWtbqRuqT2zdLESc7UVQ
 aZMD/YdSEy2Vu8glB+eyqGxJ3rmC6ECXX+v7vTUaYs5E8w/HymWoJZUT14duhcXe/rvQ
 c3wehGgskz4R8O0zH6xGSBd198ukY8TId8XGcPZmPaOnsyapUXUa8lan1jGmjrHDBfXx
 y7R2hcb6lyfgRFD6ux+RymIg6kBKk04xwywirjXgcwRFc6Kr3DClki54Bip3MYrUtY3J
 1K3c81+352mG08OncS4LbMGV5d3K48/+XidaU7quSgUHQxZiCpeTVJIx1QVMupSqDGDN
 EghQ==
X-Gm-Message-State: AOAM533j++cCDhwG67RMVmEMH01lVK6PrAtI3nAUzJ/OOpCHCCZbqje6
 qk5h5v1qfw13pdf4lvv3NLE0Q7tos+46Uq7xRIaAE/Fs2uedTZd+E5Sj/WoNX3GhjrlFTQnwrip
 ljKWyEi+daHeagvigH4pQp0Q2
X-Received: by 2002:ac8:580d:0:b0:2e1:c641:8c21 with SMTP id
 g13-20020ac8580d000000b002e1c6418c21mr32693449qtg.677.1648650492838; 
 Wed, 30 Mar 2022 07:28:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxj9mfWzYsrvAU4I7K8iuYgWUFquDhfKr86ywKhvihB398kljxjsCy0kviStlHnrVX/SZQbLA==
X-Received: by 2002:ac8:580d:0:b0:2e1:c641:8c21 with SMTP id
 g13-20020ac8580d000000b002e1c6418c21mr32693412qtg.677.1648650492602; 
 Wed, 30 Mar 2022 07:28:12 -0700 (PDT)
Received: from xz-m1.local
 (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
 by smtp.gmail.com with ESMTPSA id
 d12-20020a05620a158c00b00648ec3fcbdfsm10572195qkk.72.2022.03.30.07.28.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Mar 2022 07:28:12 -0700 (PDT)
Date: Wed, 30 Mar 2022 10:28:10 -0400
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 05/26] KVM: x86/mmu: Rename shadow MMU functions that
 deal with shadow pages
Message-ID: <YkRo+rJwYJoOmXmW@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-6-dmatlack@google.com>
 <YjBTtz6wo/zQEHCv@xz-m1.local>
 <CALzav=c0ccztDULiVMwR4K20iYc0WH53ApeOCorhjKwaMNL5Sg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALzav=c0ccztDULiVMwR4K20iYc0WH53ApeOCorhjKwaMNL5Sg@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Tue, Mar 22, 2022 at 02:35:25PM -0700, David Matlack wrote:
> On Tue, Mar 15, 2022 at 1:52 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Mar 11, 2022 at 12:25:07AM +0000, David Matlack wrote:
> > > Rename 3 functions:
> > >
> > >   kvm_mmu_get_page()   -> kvm_mmu_get_shadow_page()
> > >   kvm_mmu_alloc_page() -> kvm_mmu_alloc_shadow_page()
> > >   kvm_mmu_free_page()  -> kvm_mmu_free_shadow_page()
> > >
> > > This change makes it clear that these functions deal with shadow pages
> > > rather than struct pages. Prefer "shadow_page" over the shorter "sp"
> > > since these are core routines.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> >
> > Acked-by: Peter Xu <peterx@redhat.com>
> 
> What's the reason to use Acked-by for this patch but Reviewed-by for others?

A weak version of r-b?  I normally don't do the rename when necessary (and
I'm pretty poor at naming..), in this case I don't have a strong opinion.
I should have left nothing then it's less confusing. :)

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
