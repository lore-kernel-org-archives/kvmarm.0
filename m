Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D3DC43334
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 19:48:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CED4D4B2A5;
	Thu, 23 Jun 2022 15:48:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WW26Q+nD4E-d; Thu, 23 Jun 2022 15:48:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A34DD4B256;
	Thu, 23 Jun 2022 15:48:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02A834B216
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 15:48:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xCdasrCTM08W for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 15:48:07 -0400 (EDT)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
 [209.85.215.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2F9249F46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 15:48:07 -0400 (EDT)
Received: by mail-pg1-f174.google.com with SMTP id h192so405931pgc.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 12:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fwXOVWaOks5aEB9DnQ0+LscIdibd3v9vBir98C6rDhg=;
 b=CQndzaYspw1/WKtdaLFGLHVaJegMtkhawi5iLktrm/WtozYiFtOC8IG/36xJvdHg4W
 k6vB1z9W/Cs08olUSBnSn32v+KVGz9b0wEvkWCRfKCMpZi3y8M/brwvaxp/GZVlJsdE+
 a5ACIRVUCZAO29t6ZGW5et/uRRD1d3WvAgDAcb2SSxWfqVGM12ELdbBknV/GtDWC6mKA
 vP4/Z9l+Rztp5bFydD/NohQTZcm/AUhsbJonqQaWM8fuRR+S///2Ib7H9EtQuQMn2i4X
 KMVLtUOUN9eYoG6H9iKils1LWKtkKcSn59RJkEiJWSH634OQjWGq5brVdUBGXvOiHxB4
 Yv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fwXOVWaOks5aEB9DnQ0+LscIdibd3v9vBir98C6rDhg=;
 b=7IRg4tMQEdhSFk2ERAqmeU7OCo7fvRXQ5+6GAZbXCh2NQHWLg0eqPmFJbCCoAz3jhi
 E9liSJDXD+Ay8LoXFr/CwKE3IJuv3hf6BOvEsDINU+SRT0+gGSds60YYpYFol73ATQEU
 oHXSLyJ8ssB06EkOr+nB+xcwTiATJM5WHlO9fD2xIklwj3UNXxdotvJxMzwiBI9fr8T4
 OTQM1RR8yVVojWr1sfESrJG7fePnYnrKqY+iYq/1DTiP6XOtQF04bZq33rPEnDypcBS7
 wqQ4J/zyC1Ci+BgtQTVuCv8kC3nbC1mT+Cvsg/XbfwWDgc3A3CC0FL9WpHJ2aZJ1owOX
 Mquw==
X-Gm-Message-State: AJIora9TJFx9hON9kCkTRzBux8sFwPM0+NOMc1MJ/RtMJ6X7Z2GEPgw+
 x5ho3mhGufJMqTwPyCuLnrsr+g==
X-Google-Smtp-Source: AGRyM1sfHJfUUw/z2jILs3RXN+LCGbbXiT6lLVzBDJ8fDqyWZMCpRFSMeph94IMzJrMYodDY7V2XQg==
X-Received: by 2002:a63:790c:0:b0:40c:3c04:e3d3 with SMTP id
 u12-20020a63790c000000b0040c3c04e3d3mr8898464pgc.44.1656013686345; 
 Thu, 23 Jun 2022 12:48:06 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 i13-20020aa787cd000000b00522d329e36esm22686pfo.140.2022.06.23.12.48.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Jun 2022 12:48:05 -0700 (PDT)
Date: Thu, 23 Jun 2022 19:48:02 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v7 22/23] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
Message-ID: <YrTDcrsn0/+alpzf@google.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
 <20220622192710.2547152-23-pbonzini@redhat.com>
 <CALzav=fH_9_LKVE0_UCftwy2KZaB3nSBoWU07aPWALag4_mcHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=fH_9_LKVE0_UCftwy2KZaB3nSBoWU07aPWALag4_mcHQ@mail.gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm list <kvm@vger.kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
 LinuxMIPS <linux-mips@vger.kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Ben Gardon <bgardon@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Thu, Jun 23, 2022, David Matlack wrote:
> On Wed, Jun 22, 2022 at 12:27 PM Paolo Bonzini <pbonzini@redhat.com> wrote:

Please trim replies.

> > +static int topup_split_caches(struct kvm *kvm)
> > +{
> > +       int r;
> > +
> > +       lockdep_assert_held(&kvm->slots_lock);
> > +
> > +       /*
> > +        * It's common to need all SPLIT_DESC_CACHE_MIN_NR_OBJECTS (513) objects
> > +        * when splitting a page, but setting capacity == min would cause
> > +        * KVM to drop mmu_lock even if just one object was consumed from the
> > +        * cache.  So make capacity larger than min and handle two huge pages
> > +        * without having to drop the lock.
> 
> I was going to do some testing this week to confirm, but IIUC KVM will
> only allocate from split_desc_cache if the L1 hypervisor has aliased a
> huge page in multiple {E,N}PT12 page table entries. i.e. L1 is mapping
> a huge page into an L2 multiple times, or mapped into multiple L2s.
> This should be common in traditional, process-level, shadow paging,
> but I think will be quite rare for nested shadow paging.

Ooooh, right, I forgot that that pte_list_add() needs to allocate if and only if
there are multiple rmap entries, otherwise rmap->val points that the one and only
rmap directly.

Doubling the capacity is all but guaranteed to be pointless overhead.  What about
buffering with the default capacity?  That way KVM doesn't have to topup if it
happens to encounter an aliased gfn.  It's arbitrary, but so is the default capacity
size.

E.g. as fixup

---
 arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 22b87007efff..90d6195edcf3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6125,19 +6125,23 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm)

 static int topup_split_caches(struct kvm *kvm)
 {
-	int r;
-
-	lockdep_assert_held(&kvm->slots_lock);
-
 	/*
-	 * It's common to need all SPLIT_DESC_CACHE_MIN_NR_OBJECTS (513) objects
-	 * when splitting a page, but setting capacity == min would cause
-	 * KVM to drop mmu_lock even if just one object was consumed from the
-	 * cache.  So make capacity larger than min and handle two huge pages
-	 * without having to drop the lock.
+	 * Allocating rmap list entries when splitting huge pages for nested
+	 * MMUs is rare as KVM needs to allocate if and only if there is more
+	 * than one rmap entry for the gfn, i.e. requires an L1 gfn to be
+	 * aliased by multiple L2 gfns, which is very atypical for VMMs.  If
+	 * there is only one rmap entry, rmap->val points directly at that one
+	 * entry and doesn't need to allocate a list.  Buffer the cache by the
+	 * default capacity so that KVM doesn't have to topup the cache if it
+	 * encounters an aliased gfn or two.
 	 */
-	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache,
-					 2 * SPLIT_DESC_CACHE_MIN_NR_OBJECTS,
+	const int capacity = SPLIT_DESC_CACHE_MIN_NR_OBJECTS +
+			     KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
+	int r;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache, capacity,
 					 SPLIT_DESC_CACHE_MIN_NR_OBJECTS);
 	if (r)
 		return r;

base-commit: 436b1c29f36ed3d4385058ba6f0d6266dbd2a882
--

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
