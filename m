Return-Path: <SRS0=kG2x=5J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6411CC43331
	for <kvmarm@archiver.kernel.org>; Tue, 24 Mar 2020 18:20:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 020C8208DB
	for <kvmarm@archiver.kernel.org>; Tue, 24 Mar 2020 18:20:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 020C8208DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 719774B088;
	Tue, 24 Mar 2020 14:20:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SWBBVz6JpX2v; Tue, 24 Mar 2020 14:20:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 746C94A534;
	Tue, 24 Mar 2020 14:20:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1A764A534
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2020 14:20:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VhIRWST--qtx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Mar 2020 14:20:53 -0400 (EDT)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C687A4A4FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2020 14:20:52 -0400 (EDT)
IronPort-SDR: 1rCHWtK6NwAbt81UNTxPXyydDpsekNcB9fK7UrmycbkcdUV9b/haNeKF72l1A2RPLNXNSctN7X
 zjUVZug3MvVQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 Mar 2020 11:20:51 -0700
IronPort-SDR: y/USM2b3SPl0LjjMZJcqAmjb2PYOuW/QAtqFht1aEDTm2RWTprcUGxDRQvFy8adhtqpy78sfUX
 6Y7gyFMhw+XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; d="scan'208";a="246803473"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by orsmga003.jf.intel.com with ESMTP; 24 Mar 2020 11:20:48 -0700
Date: Tue, 24 Mar 2020 11:20:48 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v4 19/19] KVM: selftests: Add test for
 KVM_SET_USER_MEMORY_REGION
Message-ID: <20200324182048.GF5998@linux.intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-20-sean.j.christopherson@intel.com>
 <f962fafb-3956-746f-d077-3dbcefaae7c8@de.ibm.com>
 <20191218163958.GC25201@linux.intel.com>
 <78b21097-52e4-b851-fc78-da3442fd0904@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <78b21097-52e4-b851-fc78-da3442fd0904@de.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, James Hogan <jhogan@kernel.org>,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
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

On Tue, Mar 24, 2020 at 10:43:07AM +0100, Christian Borntraeger wrote:
> 
> On 18.12.19 17:39, Sean Christopherson wrote:
> > On Wed, Dec 18, 2019 at 12:39:43PM +0100, Christian Borntraeger wrote:
> >>
> I started looking into this what it would cost to implement this on s390.
> s390 is also returning EFAULT if no memory slot is available.
> 
> According to the doc this is not documented at all. So this part of the test
>         vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
>         vm_vcpu_add(vm, VCPU_ID);
>         /* Fails with ENOSPC because the MMU can't create pages (no slots). */
>         TEST_ASSERT(_vcpu_run(vm, VCPU_ID) == -1 && errno == ENOSPC,
>                     "Unexpected error code = %d", errno);
>         kvm_vm_free(vm);
> 
> is actually just testing that the implementation for x86 does not change the error
> from ENOSPC to something else.

It's even worse than that.  There error isn't directly due to no having
a memslots, it occurs because the limit on number of pages in the MMU is
zero.  On x86, that limit is automatically derived from the total size of
memslots.

The selftest could add an explicit ioctl() call to manually override the
number of allowed MMU pages, but that didn't seem any cleaner as it'd still
rely on undocumented internal KVM behavior.

TL;DR: I'm not a huge fan of the code either.

> The question is: do we want to document the error for the "no memslot" case
> and then change all existing platforms?

At first blush, I like the idea of adding an explicit check in KVM_RUN to
return an error if there isn't at least one usable memslot.  But, it'd be a
little weird/kludgy on x86/VMX due to the existence of "private" memslots,
i.e. the check should really fire on "no public memslots".  At that point,
I'm not sure whether the well defined errno would be worth the extra code.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
