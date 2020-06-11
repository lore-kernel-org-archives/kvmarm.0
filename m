Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52B3C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 15:44:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47DC920792
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 15:44:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47DC920792
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A459C4B1A1;
	Thu, 11 Jun 2020 11:44:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 37n1XeVdCNlg; Thu, 11 Jun 2020 11:44:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4504B17D;
	Thu, 11 Jun 2020 11:44:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6885B4B160
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 11:44:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vMocXEqnbMk2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2020 11:44:01 -0400 (EDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC0D34B132
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 11:44:00 -0400 (EDT)
IronPort-SDR: iD9L8IlYgAhph0j/xuAhBc4PKj0He6A5U1vEAeW+jJABontf648ZH8uCPlZNcTSKyp6Ubc0ezA
 sWEh95ZJeI4w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Jun 2020 08:43:59 -0700
IronPort-SDR: +Ydw/4Fg05XSUVeVdaVnYwXl169Eie8ePVgfFpQAiQZ2NUmXKZaRvV2IeZsKgMR2pcPAaKpDpn
 +n8lSwG3SLOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; d="scan'208";a="419144435"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.152])
 by orsmga004.jf.intel.com with ESMTP; 11 Jun 2020 08:43:59 -0700
Date: Thu, 11 Jun 2020 08:43:59 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 17/21] KVM: arm64: Use common code's approach for
 __GFP_ZERO with memory caches
Message-ID: <20200611154359.GF29918@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-18-sean.j.christopherson@intel.com>
 <6cc08074c289cbea7b9c1deeaf18c63f@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6cc08074c289cbea7b9c1deeaf18c63f@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Ben Gardon <bgardon@google.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>
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

On Thu, Jun 11, 2020 at 08:59:05AM +0100, Marc Zyngier wrote:
> >diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> >index 9398b66f8a87..688213ef34f0 100644
> >--- a/arch/arm64/kvm/mmu.c
> >+++ b/arch/arm64/kvm/mmu.c
> >@@ -131,7 +131,8 @@ static int mmu_topup_memory_cache(struct
> >kvm_mmu_memory_cache *cache, int min)
> > 	if (cache->nobjs >= min)
> > 		return 0;
> > 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> >-		page = (void *)__get_free_page(GFP_PGTABLE_USER);
> >+		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT |
> 
> This is definitely a change in the way we account for guest
> page tables allocation, although I find it bizarre that not
> all architectures account for it the same way.

It's not intended to be a functional change, i.e. the allocations should
still be accounted:

  #define GFP_PGTABLE_USER  (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
  |
  -> #define GFP_PGTABLE_KERNEL        (GFP_KERNEL | __GFP_ZERO)

  == GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO

versus 

  #define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)

    with __GFP_ZERO explicitly OR'd in

  == GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO

I can put the above in the changelog, unless of course it's wrong and I've
missed something.

> It seems logical to me that nested page tables would be accounted
> against userspace, but I'm willing to be educated on the matter.
> 
> Another possibility is that depending on the context, some allocations
> should be accounted on either the kernel or userspace (NV on arm64
> could definitely do something like that). If that was the case,
> maybe moving most of the GFP_* flags into the per-cache flags,
> and have the renaming that Ben suggested earlier.
> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
