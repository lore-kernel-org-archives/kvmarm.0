Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147F1C433E4
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 19:41:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9145520786
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 19:41:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9145520786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F8254B0DC;
	Mon, 22 Jun 2020 15:41:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KISdjM1CCcnT; Mon, 22 Jun 2020 15:41:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC304B0DD;
	Mon, 22 Jun 2020 15:41:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7B7C4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 15:40:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WGd7iVp5B0ij for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 15:40:58 -0400 (EDT)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51E674B0D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 15:40:58 -0400 (EDT)
IronPort-SDR: Zlk1os865ejrW8X4z8GlgNupE5EF+S/Q87N1YuuREiVGu9WSkvOIUA4uQVib6IdYSTul/ERbg4
 MR7yaYdOy21Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142914086"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="142914086"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Jun 2020 12:40:56 -0700
IronPort-SDR: O2b/9H8givv7m7N6NdtbF7yIVm6rD/0I5UzGQRLHIHJLsztvgSIXbC7QNG8I+x4aNniWrNxrWX
 DnQr+RzAI2QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="264595386"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.152])
 by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 12:40:55 -0700
Date: Mon, 22 Jun 2020 12:40:55 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 10/21] KVM: x86/mmu: Make __GFP_ZERO a property of the
 memory cache
Message-ID: <20200622194055.GC6151@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-11-sean.j.christopherson@intel.com>
 <CANgfPd9_BR_2NThfEs8faDxWeooZ6OeF2HAB5mUmted5sHwDPg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd9_BR_2NThfEs8faDxWeooZ6OeF2HAB5mUmted5sHwDPg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
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

On Wed, Jun 10, 2020 at 11:57:32AM -0700, Ben Gardon wrote:
> > ---
> >  arch/x86/include/asm/kvm_host.h | 1 +
> >  arch/x86/kvm/mmu/mmu.c          | 7 ++++++-
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index e7a427547557..fb99e6776e27 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -251,6 +251,7 @@ struct kvm_kernel_irq_routing_entry;
> >   */
> >  struct kvm_mmu_memory_cache {
> >         int nobjs;
> > +       gfp_t gfp_zero;
> This would make more sense to me if it could be used for general extra
> gfp flags and was called gfp_flags or something, or it was a boolean
> that was later translated into the flag being set. Storing the
> gfp_zero flag here is a little counter-intuitive. Probably not worth
> changing unless you're sending out a v2 for some other reason.

Ideally, this would be a generic gfp_flags field, but that's basically a
non-starter for patch 5, which uses GFP_ATOMIC for the "oh crap the cache
is empty" error handling.  Allowing arbitrary flags would be a mess.

I went with storing a full gfp_t because that produces more optimal code.
This isn't a super critical path and it's only a few cycles, but it seems
worthwhile given the frequency with which this code will be called, and
since this happens under mmu_lock.


348             gfp_flags |= mc->gfp_zero;
   0x00000000000058ab <+59>:    mov    0x4(%rbx),%eax
   0x00000000000058ae <+62>:    or     $0x400cc0,%eax

versus

349                     gfp_flags |= __GFP_ZERO;
   0x00000000000058a7 <+55>:    cmpb   $0x1,0x4(%rbx)
   0x00000000000058ab <+59>:    mov    0x8(%rbx),%rdi <-- unrelated interleaved code
   0x00000000000058af <+63>:    sbb    %eax,%eax
   0x00000000000058b1 <+65>:    xor    %al,%al
   0x00000000000058b3 <+67>:    add    $0x400dc0,%eax

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
