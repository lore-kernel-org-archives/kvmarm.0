Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009E3C33CAC
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 16:28:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88FDA214AF
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 16:28:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88FDA214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CD3B4A4A9;
	Thu,  6 Feb 2020 11:28:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Je3G7GYt7W27; Thu,  6 Feb 2020 11:28:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 159164A4E1;
	Thu,  6 Feb 2020 11:28:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C2E4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 11:28:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LdeRjF4z2tj0 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 11:28:21 -0500 (EST)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1698E4A3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 11:28:20 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 06 Feb 2020 08:28:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; d="scan'208";a="344968003"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 06 Feb 2020 08:28:18 -0800
Date: Thu, 6 Feb 2020 08:28:18 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 12/19] KVM: Move memslot deletion to helper function
Message-ID: <20200206162818.GD13067@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-13-sean.j.christopherson@intel.com>
 <20200206161415.GA695333@xz-x1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200206161415.GA695333@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
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

On Thu, Feb 06, 2020 at 11:14:15AM -0500, Peter Xu wrote:
> On Tue, Jan 21, 2020 at 02:31:50PM -0800, Sean Christopherson wrote:
> > Move memslot deletion into its own routine so that the success path for
> > other memslot updates does not need to use kvm_free_memslot(), i.e. can
> > explicitly destroy the dirty bitmap when necessary.  This paves the way
> > for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
> > NULL for @dont.
> > 
> > Add a comment above the code to make a copy of the existing memslot
> > prior to deletion, it is not at all obvious that the pointer will become
> > stale during sorting and/or installation of new memslots.
> 
> Could you help explain a bit on this explicit comment?  I can follow
> up with the patch itself which looks all correct to me, but I failed
> to catch what this extra comment wants to emphasize...

It's tempting to write the code like this (I know, because I did it):

	if (!mem->memory_size)
		return kvm_delete_memslot(kvm, mem, slot, as_id);

	new = *slot;

Where @slot is a pointer to the memslot to be deleted.  At first, second,
and third glances, this seems perfectly sane.

The issue is that slot was pulled from struct kvm_memslots.memslots, e.g.

	slot = &slots->memslots[index];

Note that slots->memslots holds actual "struct kvm_memory_slot" objects,
not pointers to slots.  When update_memslots() sorts the slots, it swaps
the actual slot objects, not pointers.  I.e. after update_memslots(), even
though @slot points at the same address, it's could be pointing at a
different slot.  As a result kvm_free_memslot() in kvm_delete_memslot()
will free the dirty page info and arch-specific points for some random
slot, not the intended slot, and will set npages=0 for that random slot.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
