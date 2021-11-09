Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1089BC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 01:34:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C5CE610A3
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 01:34:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7C5CE610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE1394B1A3;
	Mon,  8 Nov 2021 20:34:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cXq8OTAR4ecb; Mon,  8 Nov 2021 20:34:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87A434B16E;
	Mon,  8 Nov 2021 20:34:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E9004B183
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 20:34:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pPyksw3srxUi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 20:34:30 -0500 (EST)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 491BE4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 20:34:30 -0500 (EST)
Received: by mail-pl1-f173.google.com with SMTP id t21so17929516plr.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 17:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=1YRNoCeeCQqxDvBnoZCtovzT6k/QbqjejEhDlgxJ1xE=;
 b=pNVpk+rCV3HDgb16D6KNssN4BA5U8FFOZNcV6kT2A3hGuTm+OeROOwB3Gc25RBu5yd
 X4Uhm2QzCn6VeLOQwzmDpP+LvkACbbM7DOiiN1F9FMFmdBDaNGhlXPS6Id8TxlqFveUv
 ykpl9sKIWGUMRi9cWNOq4NVL7iOrhHfOKikKZQ1aYP9i+ytWzFlBD/awLiOZyTwIbWYd
 XQYDPLCQNX3Mp2Ht8drmEm0GVWUVRwAlw4IodZrpKgzHqAjOAs0439do5Z+7ssrDyIK1
 8md3BDizbcDwWCcQYcShMQ13fICVIj7mwm722Rbu19AAPS5eH2kbVej7sO/fO5BfTAlH
 wWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1YRNoCeeCQqxDvBnoZCtovzT6k/QbqjejEhDlgxJ1xE=;
 b=V9z3THWa42UaY78kjJb63OyfannsLdoFO1PnI0ZImkWQdqRT1Cmn8ukNZuLqA0bsYJ
 12Oj5pYrCAv6kVdR/xue87xGzeuEb5t5cwxYx4TXaSBhRS9tq+1DaQkLy0gzA+ZaOfUa
 31NE0DWkxYHCN7DN72Uc5Wf5aWyusOGjfdtPzVHkcXHrvJkywLtirh3vgKpyWgx3RLuL
 KGOZdWhxDCDE1jzwPW8YHK7Gcu+0pq/l2LM/k5V06R3RXsTMFS03iY689nCj1gGx2ger
 3hKxG2zBOdGctNSVoNcyHPXzUkTVgiU0PFBSbWDsD+8YmZjEfimnN4f3vfsFoUqUQAd0
 t7nA==
X-Gm-Message-State: AOAM533dkMabwpgOqiFQw/S+zeLm5S7BjQIrzF65R8IQO6kkmxgONfY5
 W53sHj//KBYVBZlc+IMFFosmjQ==
X-Google-Smtp-Source: ABdhPJy0HaVA5X41obakvoewrsg+dddMWtR8SRrwlCTWxcj9Z8BfUyvzJbNA9mrSzEmNcuMJfGzR8Q==
X-Received: by 2002:a17:90b:1c02:: with SMTP id
 oc2mr2968763pjb.65.1636421669237; 
 Mon, 08 Nov 2021 17:34:29 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id h36sm307891pgb.9.2021.11.08.17.34.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 08 Nov 2021 17:34:28 -0800 (PST)
Date: Tue, 9 Nov 2021 01:34:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 20/30] KVM: x86: Use nr_memslot_pages to avoid
 traversing the memslots array
Message-ID: <YYnQIYdsb3wwg86j@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-21-seanjc@google.com>
 <88d64cd0-4db1-34a8-96af-6661a55e971e@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <88d64cd0-4db1-34a8-96af-6661a55e971e@oracle.com>
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
> > From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > 
> > There is no point in recalculating from scratch the total number of pages
> > in all memslots each time a memslot is created or deleted.  Use KVM's
> > cached nr_memslot_pages to compute the default max number of MMU pages.
> > 
> > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > [sean: use common KVM field and rework changelog accordingly]

Heh, and I forgot to add "and introduce bugs"

> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  1 -
> >   arch/x86/kvm/mmu/mmu.c          | 24 ------------------------
> >   arch/x86/kvm/x86.c              | 11 ++++++++---
> >   3 files changed, 8 insertions(+), 28 deletions(-)
> > 
> (..)
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11837,9 +11837,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >   				enum kvm_mr_change change)
> >   {
> >   	if (!kvm->arch.n_requested_mmu_pages &&
> > -	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE))
> > -		kvm_mmu_change_mmu_pages(kvm,
> > -				kvm_mmu_calculate_default_mmu_pages(kvm));
> > +	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
> > +		unsigned long nr_mmu_pages;
> > +
> > +		nr_mmu_pages = kvm->nr_memslot_pages * KVM_PERMILLE_MMU_PAGES;
> 
> Unfortunately, even if kvm->nr_memslot_pages is capped at ULONG_MAX then
> this value multiplied by 20 can still overflow an unsigned long variable.

Doh.  And that likely subtly avoided by the compiler collapsing the "* 20 / 1000"
into "/ 50".

Any objection to adding a patch to cut out the multiplication entirely?  Well, cut
it from the source code, looks like gcc generates some fancy SHR+MUL to do the
divide.

I'm thinking this:

#define KVM_MEMSLOT_PAGES_TO_MMU_PAGES_RATIO 50


	...

	nr_mmu_pages = nr_pages / KVM_MEMSLOT_PAGES_TO_MMU_PAGES_RATIO;


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
