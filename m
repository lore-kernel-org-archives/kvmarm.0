Return-Path: <SRS0=+HCw=34=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E53C2BA83
	for <kvmarm@archiver.kernel.org>; Sat,  8 Feb 2020 00:53:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DF68206CC
	for <kvmarm@archiver.kernel.org>; Sat,  8 Feb 2020 00:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dj41t0/5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DF68206CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 872D24A522;
	Fri,  7 Feb 2020 19:53:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KXnOePhiHfHv; Fri,  7 Feb 2020 19:53:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 526A94A542;
	Fri,  7 Feb 2020 19:53:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A28394A500
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 19:53:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YcRAprisq--j for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 19:53:43 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF124A4E5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 19:53:43 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581123223;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=aeJ50ErBZgIigE1LeoA3RSrYk9aerE36Qrswco8mPEI=;
 b=dj41t0/5LoLo8eFBH7qELW37td220WUMP+fCqJ25gLlkW6pusXG8m9EVLo8f1hjzx6+z+T
 dCoeII+A9nHQtg7xUVenVbhZWdrpA6DPWV8xoXimcF6p2ayysi86twWrdhs8Gd4j68VCVx
 dpF5fE9iJUhYeTu8Sjzm+cDsF078fCo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-QGcJ1qA6NO2vqAbm9OkWyA-1; Fri, 07 Feb 2020 19:53:39 -0500
Received: by mail-qk1-f197.google.com with SMTP id t195so644570qke.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Feb 2020 16:53:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JXjXMB8+l02t7W3QCunMDZ6uJP1WKNZJHojqnKutHCk=;
 b=nnfYzZwMC6NzLKXURD5winamp4sTeGHvm+C7gjv+ZRRR+bQQz/kq8R3sIY+9xuD465
 2P1erL9NeSznDX8BZ/ilB62T7wq9YEY88+Jcjwgdkv+AHERs3t+MDeZLJ6oTPG8gycmu
 zpgi24hzYynVqeW8bLiTcdQK47oH2Vj2cFxk09bpyAcQGLgwe5eR3pSKt/gGGrWoc1xj
 DJfRg2vPUhmJV3DTubEppl4hf93uT6+wdZY+83A0EdLIicxlu0m2ycUdKm7YHMALHu5A
 LCt3UbfI8kxXT+MwEWjyavgDVaZDqtnNxgUo8zASI2XlYMoruaaLx0Ywckqa92bjQ90E
 qifQ==
X-Gm-Message-State: APjAAAWPzQf7lXIbsuEtaHzWGUkvZbAxOgrfoAp7x0u3Vpoz/21J0MrO
 Ld69iGG0s6wVoISRIc7lzCyzMyIqzIDMWP8AQZ9/U+19yTtarYe9CDQm0t9aRHEzy0HDXJiJCn1
 z6+Rmljg9BYpE0spRnR9s5Yyd
X-Received: by 2002:ac8:6ec5:: with SMTP id f5mr969423qtv.137.1581123218872;
 Fri, 07 Feb 2020 16:53:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqzfBGlw4CUmZPsPxFOLtL7frnrx1mxODS7RRyVx/ZknrCPjZQV1DWO/22HCN4/PJDeBYQRbmw==
X-Received: by 2002:ac8:6ec5:: with SMTP id f5mr969400qtv.137.1581123218590;
 Fri, 07 Feb 2020 16:53:38 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id m27sm2307107qta.21.2020.02.07.16.53.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Feb 2020 16:53:37 -0800 (PST)
Date: Fri, 7 Feb 2020 19:53:34 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200208005334.GB823968@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
 <20200206200200.GC700495@xz-x1>
 <20200206212120.GF13067@linux.intel.com>
 <20200206214106.GG700495@xz-x1>
 <20200207194532.GK2401@linux.intel.com>
 <20200208001832.GA823968@xz-x1>
 <20200208004233.GA15581@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200208004233.GA15581@linux.intel.com>
X-MC-Unique: QGcJ1qA6NO2vqAbm9OkWyA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

On Fri, Feb 07, 2020 at 04:42:33PM -0800, Sean Christopherson wrote:
> On Fri, Feb 07, 2020 at 07:18:32PM -0500, Peter Xu wrote:
> > On Fri, Feb 07, 2020 at 11:45:32AM -0800, Sean Christopherson wrote:
> > > +Vitaly for HyperV
> > > 
> > > On Thu, Feb 06, 2020 at 04:41:06PM -0500, Peter Xu wrote:
> > > > On Thu, Feb 06, 2020 at 01:21:20PM -0800, Sean Christopherson wrote:
> > > > > On Thu, Feb 06, 2020 at 03:02:00PM -0500, Peter Xu wrote:
> > > > > > But that matters to this patch because if MIPS can use
> > > > > > kvm_flush_remote_tlbs(), then we probably don't need this
> > > > > > arch-specific hook any more and we can directly call
> > > > > > kvm_flush_remote_tlbs() after sync dirty log when flush==true.
> > > > > 
> > > > > Ya, the asid_flush_mask in kvm_vz_flush_shadow_all() is the only thing
> > > > > that prevents calling kvm_flush_remote_tlbs() directly, but I have no
> > > > > clue as to the important of that code.
> > > > 
> > > > As said above I think the x86 lockdep is really not necessary, then
> > > > considering MIPS could be the only one that will use the new hook
> > > > introduced in this patch...  Shall we figure that out first?
> > > 
> > > So I prepped a follow-up patch to make kvm_arch_dirty_log_tlb_flush() a
> > > MIPS-only hook and use kvm_flush_remote_tlbs() directly for arm and x86,
> > > but then I realized x86 *has* a hook to do a precise remote TLB flush.
> > > There's even an existing kvm_flush_remote_tlbs_with_address() call on a
> > > memslot, i.e. this exact scenario.  So arguably, x86 should be using the
> > > more precise flush and should keep kvm_arch_dirty_log_tlb_flush().
> > > 
> > > But, the hook is only used when KVM is running as an L1 on top of HyperV,
> > > and I assume dirty logging isn't used much, if at all, for L1 KVM on
> > > HyperV?
> > > 
> > > I see three options:
> > > 
> > >   1. Make kvm_arch_dirty_log_tlb_flush() MIPS-only and call
> > >      kvm_flush_remote_tlbs() directly for arm and x86.  Add comments to
> > >      explain when an arch should implement kvm_arch_dirty_log_tlb_flush().
> > > 
> > >   2. Change x86 to use kvm_flush_remote_tlbs_with_address() when flushing
> > >      a memslot after the dirty log is grabbed by userspace.
> > > 
> > >   3. Keep the resulting code as is, but add a comment in x86's
> > >      kvm_arch_dirty_log_tlb_flush() to explain why it uses
> > >      kvm_flush_remote_tlbs() instead of the with_address() variant.
> > > 
> > > I strongly prefer to (2) or (3), but I'll defer to Vitaly as to which of
> > > those is preferable.
> > > 
> > > I don't like (1) because (a) it requires more lines code (well comments),
> > > to explain why kvm_flush_remote_tlbs() is the default, and (b) it would
> > > require even more comments, which would be x86-specific in generic KVM,
> > > to explain why x86 doesn't use its with_address() flush, or we'd lost that
> > > info altogether.
> > > 
> > 
> > I proposed the 4th solution here:
> > 
> > https://lore.kernel.org/kvm/20200207223520.735523-1-peterx@redhat.com/
> > 
> > I'm not sure whether that's acceptable, but if it can, then we can
> > drop the kvm_arch_dirty_log_tlb_flush() hook, or even move on to
> > per-slot tlb flushing.
> 
> This effectively is per-slot TLB flushing, it just has a different name.
> I.e. s/kvm_arch_dirty_log_tlb_flush/kvm_arch_flush_remote_tlbs_memslot.
> I'm not opposed to that name change.  And on second and third glance, I
> probably prefer it.  That would more or less follow the naming of
> kvm_arch_flush_shadow_all() and kvm_arch_flush_shadow_memslot().

Note that the major point of the above patchset is not about doing tlb
flush per-memslot or globally.  It's more about whether we can provide
a common entrance for TLB flushing.  Say, after that series, we should
be able to flush TLB on all archs (majorly, including MIPS) as:

  kvm_flush_remote_tlbs(kvm);

And with the same idea we can also introduce the ranged version.

> 
> I don't want to go straight to kvm_arch_flush_remote_tlb_with_address()
> because that loses the important distinction (on x86) that slots_lock is
> expected to be held.

Sorry I'm still puzzled on why that lockdep is so important and
special for x86...  For example, what if we move that lockdep to the
callers of the kvm_arch_dirty_log_tlb_flush() calls so it protects
even more arch (where we do get/clear dirty log)?  IMHO the callers
must be with the slots_lock held anyways no matter for x86 or not.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
