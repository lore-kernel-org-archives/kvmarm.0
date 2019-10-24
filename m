Return-Path: <SRS0=tvNx=YR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EEECA9EAF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 20:48:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5ADFB21D7B
	for <kvmarm@archiver.kernel.org>; Thu, 24 Oct 2019 20:48:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5ADFB21D7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCBCC4A4A0;
	Thu, 24 Oct 2019 16:48:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FaSx7pfgMKKI; Thu, 24 Oct 2019 16:48:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85CDC4A588;
	Thu, 24 Oct 2019 16:48:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 829B54A578
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 16:48:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rgtiRcaTlycI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Oct 2019 16:48:29 -0400 (EDT)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9F9F4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Oct 2019 16:48:28 -0400 (EDT)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 24 Oct 2019 13:48:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; d="scan'208";a="201596808"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.41])
 by orsmga003.jf.intel.com with ESMTP; 24 Oct 2019 13:48:26 -0700
Date: Thu, 24 Oct 2019 13:48:26 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 14/15] KVM: Terminate memslot walks via used_slots
Message-ID: <20191024204826.GE28043@linux.intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
 <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
 <20191022152827.GC2343@linux.intel.com>
 <625e511f-bd35-3b92-0c6d-550c10fc5827@redhat.com>
 <20191022155220.GD2343@linux.intel.com>
 <5c61c094-ee32-4dcf-b3ae-092eba0159c5@redhat.com>
 <20191024193856.GA28043@linux.intel.com>
 <5320341c-1abb-610b-8f5e-090a6726a9b1@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5320341c-1abb-610b-8f5e-090a6726a9b1@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Thu, Oct 24, 2019 at 10:24:09PM +0200, Paolo Bonzini wrote:
> On 24/10/19 21:38, Sean Christopherson wrote:
> > only
> >  * its new index into the array is update.
> 
> s/update/tracked/?

Ya, tracked is better.  Waffled between updated and tracked, chose poorly :-)

>   Returns the changed memslot's
> >  * current index into the memslots array.
> >  */
> > static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
> > 					    struct kvm_memory_slot *memslot)
> > {
> > 	struct kvm_memory_slot *mslots = slots->memslots;
> > 	int i;
> > 
> > 	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
> > 	    WARN_ON_ONCE(!slots->used_slots))
> > 		return -1;
> > 
> > 	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
> > 		if (memslot->base_gfn > mslots[i + 1].base_gfn)
> > 			break;
> > 
> > 		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
> > 
> > 		/* Shift the next memslot forward one and update its index. */
> > 		mslots[i] = mslots[i + 1];
> > 		slots->id_to_index[mslots[i].id] = i;
> > 	}
> > 	return i;
> > }
> > 
> > /*
> >  * Move a changed memslot forwards in the array by shifting existing slots with
> >  * a lower GFN toward the back of the array.  Note, the changed memslot itself
> >  * is not preserved in the array, i.e. not swapped at this time, only its new
> >  * index into the array is updated
> 
> Same here?
> 
> >  * Note, slots are sorted from highest->lowest instead of lowest->highest for
> >  * historical reasons.
> 
> Not just that, the largest slot (with all RAM above 4GB) is also often
> at the highest address at least on x86.

Ah, increasing the odds of a quick hit on lookup...but only when using a
linear search.  The binary search starts in the middle, so that
optimization is also historical :-)

> But we could sort them by size now, so I agree to call these historical
> reasons.

That wouldn't work with the binary search though.

> The code itself is fine, thanks for the work on documenting it.
> 
> Paolo
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
