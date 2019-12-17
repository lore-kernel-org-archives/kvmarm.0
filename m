Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D895C43603
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:21:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0338A205ED
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:21:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0338A205ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E9F04A65C;
	Tue, 17 Dec 2019 17:21:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id toUklgXH7fnk; Tue, 17 Dec 2019 17:21:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 339814A50F;
	Tue, 17 Dec 2019 17:21:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28E334A418
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:21:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6nnja5-ADHuP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 17:21:00 -0500 (EST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7BCB4A389
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:21:00 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 17 Dec 2019 14:20:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; d="scan'208";a="209859511"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by orsmga008.jf.intel.com with ESMTP; 17 Dec 2019 14:20:58 -0800
Date: Tue, 17 Dec 2019 14:20:59 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v4 01/19] KVM: x86: Allocate new rmap and large page
 tracking when moving memslot
Message-ID: <20191217222058.GD11771@linux.intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-2-sean.j.christopherson@intel.com>
 <20191217215640.GI7258@xz-x1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191217215640.GI7258@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
 kvm-ppc@vger.kernel.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Tue, Dec 17, 2019 at 04:56:40PM -0500, Peter Xu wrote:
> On Tue, Dec 17, 2019 at 12:40:23PM -0800, Sean Christopherson wrote:
> > Reallocate a rmap array and recalcuate large page compatibility when
> > moving an existing memslot to correctly handle the alignment properties
> > of the new memslot.  The number of rmap entries required at each level
> > is dependent on the alignment of the memslot's base gfn with respect to
> > that level, e.g. moving a large-page aligned memslot so that it becomes
> > unaligned will increase the number of rmap entries needed at the now
> > unaligned level.

...

> I think the error-prone part is:
> 
> 	new = old = *slot;

Lol, IMO the error-prone part is the entire memslot mess :-)

> Where IMHO it would be better if we only copy pointers explicitly when
> under control, rather than blindly copying all the pointers in the
> structure which even contains sub-structures.

Long term, yes, that would be ideal.  For the immediate bug fix, reworking
common KVM and other arch code would be unnecessarily dangerous and would
make it more difficult to backport the fix to stable branches.

I actually briefly considered moving the slot->arch handling into arch
code as part of the bug fix, but the memslot code has many subtle
dependencies, e.g. PPC and x86 rely on common KVM code to copy slot->arch
when flags are being changed.

I'll happily clean up the slot->arch code once this series is merged.
There is refactoring in this series that will make it a lot easier to do
additional clean up.

> For example, I see PPC has this:
> 
> struct kvm_arch_memory_slot {
> #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> 	unsigned long *rmap;
> #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
> };
> 
> I started to look into HV code of it a bit, then I see...
> 
>  - kvm_arch_create_memslot(kvmppc_core_create_memslot_hv) init slot->arch.rmap,
>  - kvm_arch_flush_shadow_memslot(kvmppc_core_flush_memslot_hv) didn't free it,
>  - kvm_arch_prepare_memory_region(kvmppc_core_prepare_memory_region_hv) is nop.
> 
> So Does it have similar issue?

No, KVM doesn't allow a memslot's size to be changed, and PPC's rmap
allocation is directly tied to the size of the memslot.  The x86 bug exists
because the size of its metadata arrays varies based on the alignment of
the base gfn.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
