Return-Path: <SRS0=1n5P=4H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C951C34047
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 15:18:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE87A2465D
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 15:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE87A2465D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5297E4AF14;
	Wed, 19 Feb 2020 10:18:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BzECz-aiNIO9; Wed, 19 Feb 2020 10:18:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D3A14AC86;
	Wed, 19 Feb 2020 10:18:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51D384AC86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 10:18:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g3axmz84MYHS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Feb 2020 10:18:16 -0500 (EST)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D17FE4AC77
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 10:18:15 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 19 Feb 2020 07:18:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,459,1574150400"; d="scan'208";a="235919620"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by orsmga003.jf.intel.com with ESMTP; 19 Feb 2020 07:18:14 -0800
Date: Wed, 19 Feb 2020 07:18:14 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v6 21/22] KVM: x86/mmu: Use ranged-based TLB flush for
 dirty log memslot flush
Message-ID: <20200219151814.GC15888@linux.intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
 <20200218210736.16432-22-sean.j.christopherson@intel.com>
 <fdb72ab9-18d4-5719-2863-78cde4e97fae@cogentembedded.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <fdb72ab9-18d4-5719-2863-78cde4e97fae@cogentembedded.com>
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

On Wed, Feb 19, 2020 at 12:22:58PM +0300, Sergei Shtylyov wrote:
> Hello!
> 
> On 19.02.2020 0:07, Sean Christopherson wrote:
> 
> >Use the with_address() variant to when performing a TLB flush for a
>                                  ^^ is it really needed here?

Doh, thanks.  The subject also has a typo, it should be "range-based", not
"ranged-based".

> >specific memslot via kvm_arch_flush_remote_tlbs_memslot(), i.e. when
> >flushing after clearing dirty bits during KVM_{GET,CLEAR}_DIRTY_LOG.
> >This aligns all dirty log memslot-specific TLB flushes to use the
> >with_address() variant and paves the way for consolidating the relevant
> >code.
> >
> >Note, moving to the with_address() variant only affects functionality
> >when running as a HyperV guest.
> >
> >Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> [...]
> 
> MBR, Sergei
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
