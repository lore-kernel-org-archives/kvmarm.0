Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F99CA9EB9
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 15:22:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66D9A21928
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 15:22:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66D9A21928
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7C174A971;
	Tue, 22 Oct 2019 11:22:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2yvctuZaVQNM; Tue, 22 Oct 2019 11:22:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A80004A988;
	Tue, 22 Oct 2019 11:22:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A248F4A97D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 11:22:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 865cyN9wSKMh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 11:22:27 -0400 (EDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F07484A971
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 11:22:26 -0400 (EDT)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 22 Oct 2019 08:22:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,216,1569308400"; d="scan'208";a="196468247"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.41])
 by fmsmga008.fm.intel.com with ESMTP; 22 Oct 2019 08:22:24 -0700
Date: Tue, 22 Oct 2019 08:22:24 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 15/15] KVM: Dynamically size memslot array based on
 number of used slots
Message-ID: <20191022152223.GB2343@linux.intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-16-sean.j.christopherson@intel.com>
 <2609aedc-4fc9-ab92-8877-55c64cf19165@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2609aedc-4fc9-ab92-8877-55c64cf19165@redhat.com>
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

On Tue, Oct 22, 2019 at 04:04:21PM +0200, Paolo Bonzini wrote:
> On 22/10/19 02:35, Sean Christopherson wrote:
> > +	struct kvm_memory_slot memslots[];
> > +	/*
> > +	 * WARNING: 'memslots' is dynamically-sized.  It *MUST* be at the end.
> > +	 */
> 
> Isn't that obvious from the flexible array member?

Probably.  It's also unnecessary as the compiler (at least as of gcc 5.4)
will throw an error if it's not at the end.  I think I even verified this
during development and still decided to leave the obnoxious warning in for
some reason...

include/linux/kvm_host.h:436:25: error: flexible array member not at end of struct
  struct kvm_memory_slot memslots[];
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
