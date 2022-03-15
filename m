Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C87BC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 09:54:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A8B049F26;
	Tue, 15 Mar 2022 05:54:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 57uYL-Iofusx; Tue, 15 Mar 2022 05:54:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6898B49F27;
	Tue, 15 Mar 2022 05:54:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4273C49F13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 05:54:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HH3KdcsdKsKH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 05:54:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D16849EFB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 05:54:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647338060;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Xo7vEvs61DjOwm+OclljyKsVMA7zeYl4GrMr0rJ3aPA=;
 b=FAFXlZAgGmK5NvWaqs3uMxKqjDh40qjEPm+E8EsYxtST+nGSQ/KUh6Y5qDFAPXOMN7HcjK
 I3Htf5aLBUPi3heVoeYU4zRdIPjS6HmlB0lhLR8LmPxewmICpBd9y1+F1JM1N4zTHPmmFS
 6jdk1S4HoYr8Nr5wJQjmsnYJPZ1SexE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-DxWtAmFPOWGrox9-YVqTyQ-1; Tue, 15 Mar 2022 05:54:19 -0400
X-MC-Unique: DxWtAmFPOWGrox9-YVqTyQ-1
Received: by mail-pj1-f72.google.com with SMTP id
 md4-20020a17090b23c400b001bf675ff745so1676292pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 02:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Xo7vEvs61DjOwm+OclljyKsVMA7zeYl4GrMr0rJ3aPA=;
 b=p3ZtjFYfOJyFkmDmWwLLZgeL/v85iHOJOJ3pE9BrlPRXRMEdAGNVzbSLdIlj2KzGpC
 Qx41hQSmmsrVmTd/gN/Ocvg16+xVW1/vdMpijqvKYOkEwjpjeeuijetabarIPRqhsBb9
 BO9zIHKyV8/ChG8CINZteOKQLLcmBvaOLsEj6seuRB6uwL5CJ+MxqDAu8MqELPB1QsAO
 7v9F4S9yQiit+hcPWnpQyMxDc+Igct7VaiUZOWusaRkkgoKw5I6Q9ANz3HU+jH0hbY10
 DbhW1j0ULv6yBlb2o7NderjUHyVAU0G6O8yOW1wJ3tUlaUW65S6mYPCzy8zcLgUgYlQK
 45NA==
X-Gm-Message-State: AOAM530mAVqy+xqZw/23yruh1nNSLMsEDweijKwWjCc7qRzn89Y7eiZC
 3CXFTp+1LiFG+j8IiZA1KETJuPps69XovrQjgAS/dLGIOTqE9EwtTswOy45wFe0mBTwAjLQdk6P
 kDi89CRGigtBE1fFB/Qi/+geg
X-Received: by 2002:a63:6a87:0:b0:37c:917a:9ce8 with SMTP id
 f129-20020a636a87000000b0037c917a9ce8mr23252016pgc.373.1647338058391; 
 Tue, 15 Mar 2022 02:54:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk6toqw8g9xhAX2SCrS3+aOdMM5AnKaYY+MCoYdIf9gIGOszMtcDKZxExIC2OWuD0eFQebMA==
X-Received: by 2002:a63:6a87:0:b0:37c:917a:9ce8 with SMTP id
 f129-20020a636a87000000b0037c917a9ce8mr23251985pgc.373.1647338057995; 
 Tue, 15 Mar 2022 02:54:17 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 b5-20020a056a000cc500b004f6ff0f51f4sm23591315pfv.5.2022.03.15.02.54.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 02:54:17 -0700 (PDT)
Date: Tue, 15 Mar 2022 17:54:09 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 07/26] KVM: x86/mmu: Separate shadow MMU sp allocation
 from initialization
Message-ID: <YjBiQd0rlAk7/fZW@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-8-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-8-dmatlack@google.com>
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
 maciej.szmigiero@oracle.com,
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

On Fri, Mar 11, 2022 at 12:25:09AM +0000, David Matlack wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 519910938478..e866e05c4ba5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1716,16 +1716,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
>  	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
>  	if (!direct)
>  		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> +
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);

Trivial nit:

I read Ben's comment in previous version and that sounds reasonable to keep
the two linkages together.  It's just a bit of a pity we need to set the
private manually for each allocation.

Meanwhile we have another counter example in the tdp mmu code
(tdp_mmu_init_sp()), so we may want to align the tdp/shadow cases at some
point..

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
