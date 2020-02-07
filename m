Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118FBC2BA83
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 18:52:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A4D0F217BA
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 18:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4D0F217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 230804A3A5;
	Fri,  7 Feb 2020 13:52:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8NcTZ8cIbMGB; Fri,  7 Feb 2020 13:52:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0D874A54B;
	Fri,  7 Feb 2020 13:52:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 373AB4A541
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 13:52:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZrjzSLF+TIoB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 13:52:49 -0500 (EST)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 876144A3A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 13:52:49 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 07 Feb 2020 10:52:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; d="scan'208";a="265095893"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga002.fm.intel.com with ESMTP; 07 Feb 2020 10:52:47 -0800
Date: Fri, 7 Feb 2020 10:52:47 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v4 16/19] KVM: Ensure validity of memslot with respect to
 kvm_get_dirty_log()
Message-ID: <20200207185247.GJ2401@linux.intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-17-sean.j.christopherson@intel.com>
 <20191224181930.GC17176@xz-x1>
 <20200114182506.GF16784@linux.intel.com>
 <20200206220355.GH700495@xz-x1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200206220355.GH700495@xz-x1>
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
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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

On Thu, Feb 06, 2020 at 05:03:55PM -0500, Peter Xu wrote:
> On Tue, Jan 14, 2020 at 10:25:07AM -0800, Sean Christopherson wrote:
> > On Tue, Dec 24, 2019 at 01:19:30PM -0500, Peter Xu wrote:
> > > On Tue, Dec 17, 2019 at 12:40:38PM -0800, Sean Christopherson wrote:
> > > > +int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> > > > +		      int *is_dirty, struct kvm_memory_slot **memslot)
> > > >  {
> > > >  	struct kvm_memslots *slots;
> > > > -	struct kvm_memory_slot *memslot;
> > > >  	int i, as_id, id;
> > > >  	unsigned long n;
> > > >  	unsigned long any = 0;
> > > >  
> > > > +	*memslot = NULL;
> > > > +	*is_dirty = 0;
> > > > +
> > > >  	as_id = log->slot >> 16;
> > > >  	id = (u16)log->slot;
> > > >  	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
> > > >  		return -EINVAL;
> > > >  
> > > >  	slots = __kvm_memslots(kvm, as_id);
> > > > -	memslot = id_to_memslot(slots, id);
> > > > -	if (!memslot->dirty_bitmap)
> > > > +	*memslot = id_to_memslot(slots, id);
> > > > +	if (!(*memslot)->dirty_bitmap)
> > > >  		return -ENOENT;
> > > >  
> > > > -	n = kvm_dirty_bitmap_bytes(memslot);
> > > > +	kvm_arch_sync_dirty_log(kvm, *memslot);
> > > 
> > > Should this line belong to previous patch?
> > 
> > No.
> > 
> > The previous patch, "KVM: Provide common implementation for generic dirty
> > log functions", is consolidating the implementation of dirty log functions
> > for architectures with CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y.
> > 
> > This code is being moved from s390's kvm_vm_ioctl_get_dirty_log(), as s390
> > doesn't select KVM_GENERIC_DIRTYLOG_READ_PROTECT.  It's functionally a nop
> > as kvm_arch_sync_dirty_log() is empty for PowerPC, the only other arch that
> > doesn't select KVM_GENERIC_DIRTYLOG_READ_PROTECT.
> > 
> > Arguably, the call to kvm_arch_sync_dirty_log() should be moved in a
> > separate prep patch.  It can't be a follow-on patch as that would swap the
> > ordering of kvm_arch_sync_dirty_log() and kvm_dirty_bitmap_bytes(), etc...
> > 
> > My reasoning for not splitting it to a separate patch is that prior to this
> > patch, the common code and arch specific code are doing separate memslot
> > lookups via id_to_memslot(), i.e. moving the kvm_arch_sync_dirty_log() call
> > would operate on a "different" memslot.   It can't actually be a different
> > memslot because slots_lock is held, it just felt weird.
> > 
> > All that being said, I don't have a strong opinion on moving the call to
> > kvm_arch_sync_dirty_log() in a separate patch; IIRC, I vascillated between
> > the two options when writing the code.  If anyone wants it to be a separate
> > patch I'll happily split it out.
> 
> (Sorry to respond so late)
> 
> I think the confusing part is the subject, where you only mentioned
> the memslot change.  IMHO you can split the change to make it clearer,
> or at least would you mind mention that kvm_arch_sync_dirty_log() move
> in the commit message?  Thanks,

I'll add a few paragraphs to the changelog.  Splitting it out still feels
weird.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
