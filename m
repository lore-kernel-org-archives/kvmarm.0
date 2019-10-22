Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1AACA9EB7
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 15:28:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D79E521906
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 15:28:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D79E521906
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BC774A977;
	Tue, 22 Oct 2019 11:28:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HeG5hkvnVvsw; Tue, 22 Oct 2019 11:28:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65A974A97E;
	Tue, 22 Oct 2019 11:28:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B40B4A977
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 11:28:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e8X5+mVFOW6O for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 11:28:29 -0400 (EDT)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 008144A971
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 11:28:28 -0400 (EDT)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 22 Oct 2019 08:28:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,216,1569308400"; d="scan'208";a="191500433"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.41])
 by orsmga008.jf.intel.com with ESMTP; 22 Oct 2019 08:28:27 -0700
Date: Tue, 22 Oct 2019 08:28:27 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 14/15] KVM: Terminate memslot walks via used_slots
Message-ID: <20191022152827.GC2343@linux.intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
 <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
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

On Tue, Oct 22, 2019 at 04:04:18PM +0200, Paolo Bonzini wrote:
> On 22/10/19 02:35, Sean Christopherson wrote:
> > +static inline int kvm_shift_memslots_forward(struct kvm_memslots *slots,
> > +					     struct kvm_memory_slot *new)
> > +{
> > +	struct kvm_memory_slot *mslots = slots->memslots;
> > +	int i;
> > +
> > +	if (WARN_ON_ONCE(slots->id_to_index[new->id] == -1) ||
> > +	    WARN_ON_ONCE(!slots->used_slots))
> > +		return -1;
> > +
> > +	for (i = slots->id_to_index[new->id]; i < slots->used_slots - 1; i++) {
> > +		if (new->base_gfn > mslots[i + 1].base_gfn)
> > +			break;
> > +
> > +		WARN_ON_ONCE(new->base_gfn == mslots[i + 1].base_gfn);
> > +
> > +		/* Shift the next memslot forward one and update its index. */
> > +		mslots[i] = mslots[i + 1];
> > +		slots->id_to_index[mslots[i].id] = i;
> > +	}
> > +	return i;
> > +}
> > +
> > +static inline int kvm_shift_memslots_back(struct kvm_memslots *slots,
> > +					  struct kvm_memory_slot *new,
> > +					  int start)
> 
> This new implementation of the insertion sort loses the comments that
> were there in the old one.  Please keep them as function comments.

I assume you're talking about this blurb in particular?

	 * The ">=" is needed when creating a slot with base_gfn == 0,
	 * so that it moves before all those with base_gfn == npages == 0.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
