Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646FFC2BA83
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 22:03:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE13221775
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 22:03:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE13221775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BCEA4A4F7;
	Fri,  7 Feb 2020 17:03:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wlStAXrY26zP; Fri,  7 Feb 2020 17:03:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7DB4A4C0;
	Fri,  7 Feb 2020 17:03:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BF8C4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 17:03:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nszopcIbN0-V for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 17:03:27 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B3A74A4AA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 17:03:27 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 07 Feb 2020 14:03:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,415,1574150400"; d="scan'208";a="280100123"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2020 14:03:25 -0800
Date: Fri, 7 Feb 2020 14:03:25 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 17/19] KVM: Terminate memslot walks via used_slots
Message-ID: <20200207220325.GO2401@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-18-sean.j.christopherson@intel.com>
 <20200206210944.GD700495@xz-x1>
 <20200207183325.GI2401@linux.intel.com>
 <20200207203909.GE720553@xz-x1>
 <20200207211016.GN2401@linux.intel.com>
 <20200207214623.GF720553@xz-x1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200207214623.GF720553@xz-x1>
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

On Fri, Feb 07, 2020 at 04:46:23PM -0500, Peter Xu wrote:
> On Fri, Feb 07, 2020 at 01:10:16PM -0800, Sean Christopherson wrote:
> > On Fri, Feb 07, 2020 at 03:39:09PM -0500, Peter Xu wrote:
> > > On Fri, Feb 07, 2020 at 10:33:25AM -0800, Sean Christopherson wrote:
> > > > On Thu, Feb 06, 2020 at 04:09:44PM -0500, Peter Xu wrote:
> > > > > On Tue, Jan 21, 2020 at 02:31:55PM -0800, Sean Christopherson wrote:
> > > > > > @@ -9652,13 +9652,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > > > > >  		if (IS_ERR((void *)hva))
> > > > > >  			return PTR_ERR((void *)hva);
> > > > > >  	} else {
> > > > > > -		if (!slot->npages)
> > > > > > +		if (!slot || !slot->npages)
> > > > > >  			return 0;
> > > > > >  
> > > > > > -		hva = 0;
> > > > > > +		hva = slot->userspace_addr;
> > > > > 
> > > > > Is this intended?
> > > > 
> > > > Yes.  It's possible to allow VA=0 for userspace mappings.  It's extremely
> > > > uncommon, but possible.  Therefore "hva == 0" shouldn't be used to
> > > > indicate an invalid slot.
> > > 
> > > Note that this is the deletion path in __x86_set_memory_region() not
> > > allocation.  IIUC userspace_addr won't even be used in follow up code
> > > path so it shouldn't really matter.  Or am I misunderstood somewhere?
> > 
> > No, but that's precisely why I don't want to zero out @hva, as doing so
> > implies that '0' indicates an invalid hva, which is wrong.
> > 
> > What if I change this to 
> > 
> > 			hva = 0xdeadull << 48;
> > 
> > and add a blurb in the changelog about stuff hva with a non-canonical value
> > to indicate it's being destroyed.
> 
> IMO it's fairly common to have the case where "when A is XXX then
> parameters B is invalid" happens in C.

I'm not arguing that's not the case.  My point is that there's nothing
special about '0', so why use it?  E.g. "hva = 1" would also be ok from a
functional perspective, but more obviously "wrong".
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
