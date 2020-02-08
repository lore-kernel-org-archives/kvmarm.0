Return-Path: <SRS0=+HCw=34=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD61DC35242
	for <kvmarm@archiver.kernel.org>; Sat,  8 Feb 2020 00:42:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E2D822464
	for <kvmarm@archiver.kernel.org>; Sat,  8 Feb 2020 00:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E2D822464
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D31884A4CD;
	Fri,  7 Feb 2020 19:42:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7B29L5UJQWPB; Fri,  7 Feb 2020 19:42:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93ACF4A591;
	Fri,  7 Feb 2020 19:42:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81E1C4A542
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 19:42:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IaFYzTTL0Tsv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 19:42:37 -0500 (EST)
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6A594A535
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 19:42:36 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 07 Feb 2020 16:42:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,415,1574150400"; d="scan'208";a="346332007"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by fmsmga001.fm.intel.com with ESMTP; 07 Feb 2020 16:42:34 -0800
Date: Fri, 7 Feb 2020 16:42:33 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200208004233.GA15581@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
 <20200206200200.GC700495@xz-x1>
 <20200206212120.GF13067@linux.intel.com>
 <20200206214106.GG700495@xz-x1>
 <20200207194532.GK2401@linux.intel.com>
 <20200208001832.GA823968@xz-x1>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200208001832.GA823968@xz-x1>
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

On Fri, Feb 07, 2020 at 07:18:32PM -0500, Peter Xu wrote:
> On Fri, Feb 07, 2020 at 11:45:32AM -0800, Sean Christopherson wrote:
> > +Vitaly for HyperV
> > 
> > On Thu, Feb 06, 2020 at 04:41:06PM -0500, Peter Xu wrote:
> > > On Thu, Feb 06, 2020 at 01:21:20PM -0800, Sean Christopherson wrote:
> > > > On Thu, Feb 06, 2020 at 03:02:00PM -0500, Peter Xu wrote:
> > > > > But that matters to this patch because if MIPS can use
> > > > > kvm_flush_remote_tlbs(), then we probably don't need this
> > > > > arch-specific hook any more and we can directly call
> > > > > kvm_flush_remote_tlbs() after sync dirty log when flush==true.
> > > > 
> > > > Ya, the asid_flush_mask in kvm_vz_flush_shadow_all() is the only thing
> > > > that prevents calling kvm_flush_remote_tlbs() directly, but I have no
> > > > clue as to the important of that code.
> > > 
> > > As said above I think the x86 lockdep is really not necessary, then
> > > considering MIPS could be the only one that will use the new hook
> > > introduced in this patch...  Shall we figure that out first?
> > 
> > So I prepped a follow-up patch to make kvm_arch_dirty_log_tlb_flush() a
> > MIPS-only hook and use kvm_flush_remote_tlbs() directly for arm and x86,
> > but then I realized x86 *has* a hook to do a precise remote TLB flush.
> > There's even an existing kvm_flush_remote_tlbs_with_address() call on a
> > memslot, i.e. this exact scenario.  So arguably, x86 should be using the
> > more precise flush and should keep kvm_arch_dirty_log_tlb_flush().
> > 
> > But, the hook is only used when KVM is running as an L1 on top of HyperV,
> > and I assume dirty logging isn't used much, if at all, for L1 KVM on
> > HyperV?
> > 
> > I see three options:
> > 
> >   1. Make kvm_arch_dirty_log_tlb_flush() MIPS-only and call
> >      kvm_flush_remote_tlbs() directly for arm and x86.  Add comments to
> >      explain when an arch should implement kvm_arch_dirty_log_tlb_flush().
> > 
> >   2. Change x86 to use kvm_flush_remote_tlbs_with_address() when flushing
> >      a memslot after the dirty log is grabbed by userspace.
> > 
> >   3. Keep the resulting code as is, but add a comment in x86's
> >      kvm_arch_dirty_log_tlb_flush() to explain why it uses
> >      kvm_flush_remote_tlbs() instead of the with_address() variant.
> > 
> > I strongly prefer to (2) or (3), but I'll defer to Vitaly as to which of
> > those is preferable.
> > 
> > I don't like (1) because (a) it requires more lines code (well comments),
> > to explain why kvm_flush_remote_tlbs() is the default, and (b) it would
> > require even more comments, which would be x86-specific in generic KVM,
> > to explain why x86 doesn't use its with_address() flush, or we'd lost that
> > info altogether.
> > 
> 
> I proposed the 4th solution here:
> 
> https://lore.kernel.org/kvm/20200207223520.735523-1-peterx@redhat.com/
> 
> I'm not sure whether that's acceptable, but if it can, then we can
> drop the kvm_arch_dirty_log_tlb_flush() hook, or even move on to
> per-slot tlb flushing.

This effectively is per-slot TLB flushing, it just has a different name.
I.e. s/kvm_arch_dirty_log_tlb_flush/kvm_arch_flush_remote_tlbs_memslot.
I'm not opposed to that name change.  And on second and third glance, I
probably prefer it.  That would more or less follow the naming of
kvm_arch_flush_shadow_all() and kvm_arch_flush_shadow_memslot().

I don't want to go straight to kvm_arch_flush_remote_tlb_with_address()
because that loses the important distinction (on x86) that slots_lock is
expected to be held.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
