Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A46C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 10 Oct 2022 23:43:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67E724B62E;
	Mon, 10 Oct 2022 19:43:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zCZbRud5b98x; Mon, 10 Oct 2022 19:43:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDC114089E;
	Mon, 10 Oct 2022 19:43:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C80D94089E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 19:43:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XU4OJtU07m3Z for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 19:43:39 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F41A404CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 19:43:39 -0400 (EDT)
Date: Mon, 10 Oct 2022 23:43:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1665445417;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Yg4lTXp1QUgmpzbNaO9NXgw64ysFWUkKZAacHYeQ82A=;
 b=OYxY+tOT9TS44cuuvzFYnKEQXeG3nH7gsWIMcWQK+wtOpcCesOJaNLP8YAbxpFyzoengTF
 7CtEAAEuVWzQXNlN6DigiFJelVrYL2KEca7X+ZTw9z906+MSWElSFBK3JO53a2Vtyr+BgQ
 j9qBQbgkdPYRIC58u3lNoU0dbGMqd9A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0SuJee3oWL2QCqM@google.com>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com> <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n> <Y0SoX2/E828mbxuf@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y0SoX2/E828mbxuf@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: shuah@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, kvmarm@lists.linux.dev, shan.gavin@gmail.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Mon, Oct 10, 2022 at 11:18:55PM +0000, Oliver Upton wrote:
> On Fri, Oct 07, 2022 at 10:31:49AM -0400, Peter Xu wrote:
> 
> [...]
> 
> > > - In kvm_vm_ioctl_enable_dirty_log_ring(), set 'dirty_ring_allow_bitmap' to
> > >   true when the capability is KVM_CAP_DIRTY_LONG_RING_ACQ_REL
> > 
> > What I wanted to do is to decouple the ACQ_REL with ALLOW_BITMAP, so mostly
> > as what you suggested, except..
> 
> +1
> 
> > > 
> > >   static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 cap, u32 size)
> > >   {
> > >     :
> > >     mutex_lock(&kvm->lock);
> > > 
> > >     if (kvm->created_vcpus) {
> > >        /* We don't allow to change this value after vcpu created */
> > >        r = -EINVAL;
> > >     } else {
> > >        kvm->dirty_ring_size = size;
> > 
> > .. here I'd not set dirty_ring_allow_bitmap at all so I'd drop below line,
> > instead..
> > 
> > >        kvm->dirty_ring_allow_bitmap = (cap == KVM_CAP_DIRTY_LOG_RING_ACQ_REL);
> > >        r = 0;
> > >     }
> > > 
> > >     mutex_unlock(&kvm->lock);
> > >     return r;
> > >   }
> > > - In kvm_vm_ioctl_check_extension_generic(), KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP
> > >   is always flase until KVM_CAP_DIRTY_LOG_RING_ACQ_REL is enabled.
> > > 
> > >   static long kvm_vm_ioctl_check_extension_generic(...)
> > >   {
> > >     :
> > >     case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
> > >         return kvm->dirty_ring_allow_bitmap ? 1 : 0;
> > 
> > ... here we always return 1, OTOH in kvm_vm_ioctl_enable_cap_generic():
> > 
> >       case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
> >            if (kvm->dirty_ring_size)
> >                 return -EINVAL;
> >            kvm->dirty_ring_allow_bitmap = true;
> >            return 0;
> > 
> > A side effect of checking dirty_ring_size is then we'll be sure to have no
> > vcpu created too.  Maybe we should also check no memslot created to make
> > sure the bitmaps are not created.
> 
> I'm not sure I follow... What prevents userspace from creating a vCPU
> between enabling the two caps?
> 
> > Then if the userspace wants to use the bitmap altogether with the ring, it
> > needs to first detect KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP and enable it
> > before it enables KVM_CAP_DIRTY_LOG_RING.
> > 
> > One trick on ALLOW_BITMAP is in mark_page_dirty_in_slot() - after we allow
> > !vcpu case we'll need to make sure it won't accidentally try to set bitmap
> > for !ALLOW_BITMAP, because in that case the bitmap pointer is NULL so
> > set_bit_le() will directly crash the kernel.
> > 
> > We could keep the old flavor of having a WARN_ON_ONCE(!vcpu &&
> > !ALLOW_BITMAP) then return, but since now the userspace can easily trigger
> > this (e.g. on ARM, a malicious userapp can have DIRTY_RING &&
> > !ALLOW_BITMAP, then it can simply trigger the gic ioctl to trigger host
> > warning), I think the better approach is we can kill the process in that
> > case.  Not sure whether there's anything better we can do.
> 
> I don't believe !ALLOW_BITMAP && DIRTY_RING is a valid configuration for
> arm64 given the fact that we'll dirty memory outside of a vCPU context.
> 
> Could ALLOW_BITMAP be a requirement of DIRTY_RING, thereby making
> userspace fail fast? Otherwise (at least on arm64) your VM is DOA on the
> target. With that the old WARN() could be preserved, as you suggest. On
> top of that there would no longer be a need to test for memslot creation
> when userspace attempts to enable KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP.

Just to be explicit...

I don't believe ALLOW_BITMAP needs to be generally advertized on
architectures that select DIRTY_RING. Instead, architectures (just arm64
right now) should select ALLOW_BITMAP if they need to dirty memory
outside of a vCPU.

When ALLOW_BITMAP is selected, KVM_CAP_DIRTY_LOG_RING[_ACQ_REL] has the
additional restriction that KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP has been
enabled first.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
