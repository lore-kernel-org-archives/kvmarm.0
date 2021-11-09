Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94E0C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 01:13:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D08361A8D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 01:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5D08361A8D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0BFC4B1AF;
	Mon,  8 Nov 2021 20:13:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8aYQA93iKN32; Mon,  8 Nov 2021 20:13:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B42014B116;
	Mon,  8 Nov 2021 20:13:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E47674B0C0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 20:13:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZOSrpx44lovm for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 20:13:14 -0500 (EST)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 740174B0BF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 20:13:14 -0500 (EST)
Received: by mail-pl1-f171.google.com with SMTP id k4so17830146plx.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 17:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=OY5KYqUbBGpBDQ1k/TLXaDPEogjFGrqFLQuez5gL1qA=;
 b=te7Nw2DvzfZp/BOqwknAvOUpfBhundhcdPJe1dNUemJpr+5tBnfyFRHnMzcPLxJFqN
 KujEpDxbDQg9UP19BIas9xWrfjlUr8iNQnw44E4nNiuCXPw9XE2oUUEO4vm6LObg4EhG
 d4Eh18RhxnXj0DeQQGDa0fItbHkrWTp2aGHdm8SLozmyzGYlENGO46rSxB1omAxCZquV
 0SE2otTQgQ85nJvIEamMaKTrGUdltz0CPMYpQRIdj8uIl5/rXQOmwBDoJILcZ8QF1Jqs
 zpka1GweINt+W1Mdx9Gb5XIPiYSJXz2XTgcNv6K30CkWtk/7XN35z66PabO6xsFDyCBN
 K+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OY5KYqUbBGpBDQ1k/TLXaDPEogjFGrqFLQuez5gL1qA=;
 b=TtG+3Xr3MN8dyBRwmyAKYB8Wa4ZzN2lWcg0pAAv/epQbzxRrTufHCeqqfuYRBsyoR/
 tcbRxPQslTVHtbtB6U6ZD0Om+qxewqSLpcAYcaimHmHD9a4YAHf7qbqYQGm8iF9jxKRr
 f6cmD5djCd5OyGwL9WQdTD6K8QefXOLf+r6NPyV6Ygv9wSav08oX+NC1kCV5qZd4jZ4G
 LDmQeg9r1rU6ld28p2SAYdEo9r2z7MLPdOMxqbMgL8Sh9EZDJtXP3zhGq5WntAsaiPDe
 UOh5lQhc7KO1x8wwXdYcJ5WlebJBSp4x4wBlJZpia8x72xF+TCu6RhXDjeBq8w3KcocE
 +jJw==
X-Gm-Message-State: AOAM530NX993FIDh1DuBJ1n5cSOoy22rGdB83huXbiiPyYf+BkKAOVRr
 om8jgbI5VmCz8jrfi42aFLoGSQ==
X-Google-Smtp-Source: ABdhPJzcevbnubHEXgv1M6rLX2JGTzdlefd4kCjCHHTj8uzt2X4SJm7iMiDLodL/pGyJRFtYyjZrnw==
X-Received: by 2002:a17:902:7c0e:b0:142:53c3:39d9 with SMTP id
 x14-20020a1709027c0e00b0014253c339d9mr3570608pll.66.1636420393180; 
 Mon, 08 Nov 2021 17:13:13 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id t135sm13421760pgc.51.2021.11.08.17.13.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 08 Nov 2021 17:13:12 -0800 (PST)
Date: Tue, 9 Nov 2021 01:13:08 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 07/30] KVM: Let/force architectures to deal with
 arch specific memslot data
Message-ID: <YYnLJKyt0aYsl1H0@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-8-seanjc@google.com>
 <e12ecff3-ee69-9e2c-02f9-0e54a1cb9519@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e12ecff3-ee69-9e2c-02f9-0e54a1cb9519@oracle.com>
Cc: Anup Patel <anup.patel@wdc.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 kvm-ppc@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, Nov 09, 2021, Maciej S. Szmigiero wrote:
> On 04.11.2021 01:25, Sean Christopherson wrote:
> > Pass the "old" slot to kvm_arch_prepare_memory_region() and force arch
> > code to handle propagating arch specific data from "new" to "old" when
> > necessary.  This is a baby step towards dynamically allocating "new" from
> > the get go, and is a (very) minor performance boost on x86 due to not
> > unnecessarily copying arch data.
> > 
> > For PPC HV, copy the rmap in the !CREATE and !DELETE paths, i.e. for MOVE
> > and FLAGS_ONLY.  This is functionally a nop as the previous behavior
> > would overwrite the pointer for CREATE, and eventually discard/ignore it
> > for DELETE.
> > 
> > For x86, copy the arch data only for FLAGS_ONLY changes.  Unlike PPC HV,
> > x86 needs to reallocate arch data in the MOVE case as the size of x86's
> > allocations depend on the alignment of the memslot's gfn.
> > 
> > Opportunistically tweak kvm_arch_prepare_memory_region()'s param order to
> > match the "commit" prototype.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/arm64/kvm/mmu.c               |  7 ++++---
> >   arch/mips/kvm/mips.c               |  3 ++-
> >   arch/powerpc/include/asm/kvm_ppc.h | 18 ++++++++++--------
> >   arch/powerpc/kvm/book3s.c          | 12 ++++++------
> >   arch/powerpc/kvm/book3s_hv.c       | 17 ++++++++++-------
> >   arch/powerpc/kvm/book3s_pr.c       | 17 +++++++++--------
> >   arch/powerpc/kvm/booke.c           |  5 +++--
> >   arch/powerpc/kvm/powerpc.c         |  5 +++--
> >   arch/s390/kvm/kvm-s390.c           |  3 ++-
> >   arch/x86/kvm/x86.c                 | 15 +++++++++++----
> >   include/linux/kvm_host.h           |  3 ++-
> >   virt/kvm/kvm_main.c                |  5 +----
> >   12 files changed, 63 insertions(+), 47 deletions(-)
> > 
> 
> You didn't include the RISCV kvm_arch_prepare_memory_region() change here
> (that's actually in patch 13 of this series) so bisection on that arch
> will be broken between this patch and patch 13.

Argh, I thought I had found all of those.  :-/  Thanks.  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
