Return-Path: <SRS0=pHiG=XO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D571C4CECE
	for <kvmarm@archiver.kernel.org>; Thu, 19 Sep 2019 19:39:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10F1A21927
	for <kvmarm@archiver.kernel.org>; Thu, 19 Sep 2019 19:39:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10F1A21927
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 646BF4A6DB;
	Thu, 19 Sep 2019 15:39:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Boyl3m2632cB; Thu, 19 Sep 2019 15:39:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EA5E4A663;
	Thu, 19 Sep 2019 15:39:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17E7E4A663
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 15:39:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1EJvO6ZeMfGE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Sep 2019 15:39:17 -0400 (EDT)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 636404A662
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 15:39:17 -0400 (EDT)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 19 Sep 2019 12:39:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,524,1559545200"; d="scan'208";a="217417278"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.41])
 by fmsmga002.fm.intel.com with ESMTP; 19 Sep 2019 12:39:15 -0700
Date: Thu, 19 Sep 2019 12:39:15 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH 10/13] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20190919193915.GC30495@linux.intel.com>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
 <20190911185038.24341-11-sean.j.christopherson@intel.com>
 <20190919002242.GA19503@blackberry>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190919002242.GA19503@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, David Hildenbrand <david@redhat.com>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
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

On Thu, Sep 19, 2019 at 10:22:42AM +1000, Paul Mackerras wrote:
> On Wed, Sep 11, 2019 at 11:50:35AM -0700, Sean Christopherson wrote:
> > Move the implementations of KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG
> > for CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT into common KVM code.
> > The arch specific implemenations are extremely similar, differing
> > only in whether the dirty log needs to be sync'd from hardware (x86)
> > and how the TLBs are flushed.  Add new arch hooks to handle sync
> > and TLB flush; the sync will also be used for non-generic dirty log
> > support in a future patch (s390).
> > 
> > The ulterior motive for providing a common implementation is to
> > eliminate the dependency between arch and common code with respect to
> > the memslot referenced by the dirty log, i.e. to make it obvious in the
> > code that the validity of the memslot is guaranteed, as a future patch
> > will rework memslot handling such that id_to_memslot() can return NULL.
> 
> I notice you add empty definitions of kvm_arch_sync_dirty_log() for
> PPC, both Book E and Book 3S.  Given that PPC doesn't select
> CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT, why is this necessary?

s390 has a non-empty kvm_arch_sync_dirty_log() but doesn't select
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT.  Patch 11/13 moves s390's call
of kvm_arch_sync_dirty_log() from s390's kvm_vm_ioctl_get_dirty_log() into
the common (but not "generic") kvm_get_dirty_log() so that it's obvious
that kvm_vm_ioctl_get_dirty_log() and kvm_get_dirty_log() are operating on
the same memslot, i.e. aren't independently querying id_to_memslot().

I originally made kvm_arch_sync_dirty_log() opt-in with a __KVM_HAVE_ARCH
macro, but the resulting #ifdeffery felt uglier than having PPC and ARM
provide empty functions.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
