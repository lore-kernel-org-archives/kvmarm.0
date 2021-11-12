Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5599C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 00:51:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 33C1B614C8
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 00:51:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 33C1B614C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1BD04B17B;
	Thu, 11 Nov 2021 19:51:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EcPfQ33-0gQr; Thu, 11 Nov 2021 19:51:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 287204B1E3;
	Thu, 11 Nov 2021 19:51:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74C614B177
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 19:51:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YDrT3UfBd9ba for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Nov 2021 19:51:09 -0500 (EST)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 379614B17B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 19:51:09 -0500 (EST)
Received: by mail-pl1-f170.google.com with SMTP id y7so7238704plp.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 16:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=7VoEwbSPzrTyOh3w99mGEcK1Otv61yXE8VpDyQ7XU/Q=;
 b=aR0iTUNTxKf6faFpqVLtDxLZ+Z93VjgfuMSy8Y9h3wnwVUTL/oHfhEOsrg0V7yOdYT
 7fq8GTKIKG9OH6zETAjAXEzMtYxKZ4n8vzmgKUi//wtyVazuE6xgdlSVa2YM1WXEZK7o
 ckgTdbQk1CrwriNKigDb1ZxyhMDgLtfKnE3RIVuAKQjcg2mMhNzjvwVYycKmLb0GnSZ1
 GYcRaJBvetbHNGisq5tuHOigfRUZHZConfP9luv9GZtaibkXsyjw/cHwj8DSAwBW3aaZ
 7VyKPKnacS2ZdpG3N5SRXdGPcXpnFm1QD3uLEDYX71FQ35qKY9q+/DI/dPGPqFGBB6ib
 ajeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7VoEwbSPzrTyOh3w99mGEcK1Otv61yXE8VpDyQ7XU/Q=;
 b=F7Lgy6TdKl5Xul20GTT8U+SKZ06QbNJXBJ9DqKnOOffpvQ9VsmJbVwN8HXfD5curzH
 dzqW5ZKsR4866ZhQhSS1TuB4tjN5tQn2EWYoFMJCbv36JMxZ3EV5y3zV/l1K4fmsL0fN
 6l5qWcRvvaHFhj5EB+YGBl5KMcpNTAMHRgTXgebSqN7FdU3LKZ2J0AiWtTyqrlw+jPz+
 X+193OBV3nBtbkD4awAUEy/XnezOtu68jZQtALZahOfnxeeIkCg0eikg8RD0bkydfq3o
 m3IuzLd+aZ3LQdB7r7/Xk8ej08huYAuH6oFZ5hkzCPQNwvPpbCA4kBb5QV4UiBkxwtoZ
 bQPQ==
X-Gm-Message-State: AOAM5329LyykH73mykn8DgSQaLax9D3/UJJyTHmwRrrWfEBt1zPLNX9/
 gNFFm//pNjUpTPSmMstMoUGuuA==
X-Google-Smtp-Source: ABdhPJxC4jGH9js/28DTzQpRvZ4IBLyKiJDKoUfHaiXaxCscmtOSb6+KYszrts8CNNHGQNLMJ/jO0g==
X-Received: by 2002:a17:90a:c58f:: with SMTP id
 l15mr12870593pjt.168.1636678268099; 
 Thu, 11 Nov 2021 16:51:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id s21sm4279773pfk.3.2021.11.11.16.51.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Nov 2021 16:51:07 -0800 (PST)
Date: Fri, 12 Nov 2021 00:51:03 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 26/30] KVM: Keep memslots in tree-based structures
 instead of array-based ones
Message-ID: <YY26dxv2kM3m2H7Z@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-27-seanjc@google.com>
 <5f5c80ce-9189-def3-9c50-d5a504925253@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5f5c80ce-9189-def3-9c50-d5a504925253@oracle.com>
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

On Fri, Nov 12, 2021, Maciej S. Szmigiero wrote:
> On 04.11.2021 01:25, Sean Christopherson wrote:
> > -	/*
> > -	 * Remove the old memslot from the hash list and interval tree, copying
> > -	 * the node data would corrupt the structures.
> > -	 */
> > +	int as_id = kvm_memslots_get_as_id(old, new);
> > +	struct kvm_memslots *slots = kvm_get_inactive_memslots(kvm, as_id);
> > +	int idx = slots->node_idx;
> > +
> >   	if (old) {
> > -		hash_del(&old->id_node);
> > -		interval_tree_remove(&old->hva_node, &slots->hva_tree);
> > +		hash_del(&old->id_node[idx]);
> > +		interval_tree_remove(&old->hva_node[idx], &slots->hva_tree);
> > -		if (!new)
> > +		if ((long)old == atomic_long_read(&slots->last_used_slot))
> > +			atomic_long_set(&slots->last_used_slot, (long)new);
> 
> Open-coding cmpxchg() is way less readable than a direct call.

Doh, I meant to call this out and/or add a comment.

My objection to cmpxchg() is that it implies atomicity is required (the kernel's
version adds the lock), which is very much not the case.  So this isn't strictly
an open-coded version of cmpxchg().

> The open-coded version also compiles on x86 to multiple instructions with
> a branch, instead of just a single instruction.

Yeah.  The lock can't be contended, so that part of cmpxchg is a non-issue.  But
that's also why I don't love using cmpxchg.

I don't have a strong preference, I just got briefly confused by the atomicity part.

> > +static void kvm_invalidate_memslot(struct kvm *kvm,
> > +				   struct kvm_memory_slot *old,
> > +				   struct kvm_memory_slot *working_slot)
> > +{
> > +	/*
> > +	 * Mark the current slot INVALID.  As with all memslot modifications,
> > +	 * this must be done on an unreachable slot to avoid modifying the
> > +	 * current slot in the active tree.
> > +	 */
> > +	kvm_copy_memslot(working_slot, old);
> > +	working_slot->flags |= KVM_MEMSLOT_INVALID;
> > +	kvm_replace_memslot(kvm, old, working_slot);
> > +
> > +	/*
> > +	 * Activate the slot that is now marked INVALID, but don't propagate
> > +	 * the slot to the now inactive slots. The slot is either going to be
> > +	 * deleted or recreated as a new slot.
> > +	 */
> > +	kvm_swap_active_memslots(kvm, old->as_id);
> > +
> > +	/*
> > +	 * From this point no new shadow pages pointing to a deleted, or moved,
> > +	 * memslot will be created.  Validation of sp->gfn happens in:
> > +	 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
> > +	 *	- kvm_is_visible_gfn (mmu_check_root)
> > +	 */
> > +	kvm_arch_flush_shadow_memslot(kvm, old);
> 
> This should flush the currently active slot (that is, "working_slot",
> not "old") to not introduce a behavior change with respect to the existing
> code.
> 
> That's also what the previous version of this patch set did.

Eww.  I would much prefer to "fix" the existing code in a prep patch.  It shouldn't
matter, but arch code really should not get passed an INVALID slot.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
