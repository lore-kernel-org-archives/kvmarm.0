Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6059C38A2D
	for <kvmarm@archiver.kernel.org>; Tue, 25 Oct 2022 00:24:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A5C94B6B2;
	Mon, 24 Oct 2022 20:24:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mwGoy9jzcQIE; Mon, 24 Oct 2022 20:24:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCCD54B647;
	Mon, 24 Oct 2022 20:24:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E273A49F41
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2022 20:24:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nAvvCXF6iGBU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Oct 2022 20:24:26 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C2A548FA4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2022 20:24:26 -0400 (EDT)
Date: Tue, 25 Oct 2022 00:24:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666657465;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=maoLd9aJkDBZtv2kfarXZXxev38GBgnflgG2yK7ZibY=;
 b=YQOwZYg7bd2taR4wifBPFQboPaDfdXazXLGaC4ijMKnCk75ViFTvY9IAlddZIzQXOIhu4o
 XqCzvbruQ6bugkobmf8eUH5UZTzCRm+rLR2kWfLOLpA4LQ3qD5qJhZblrO/XtgZo8bC732
 XAO0Utjdlgzdfl6VKgOvj8H3pq5PI40=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1css8k0gtFkVwFQ@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com> <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com> <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y1ckxYst3tc0LCqb@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: shuah@kernel.org, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 bgardon@google.com, andrew.jones@linux.dev, dmatlack@google.com,
 shan.gavin@gmail.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Mon, Oct 24, 2022 at 11:50:29PM +0000, Sean Christopherson wrote:
> On Sat, Oct 22, 2022, Marc Zyngier wrote:
> > On Fri, 21 Oct 2022 17:05:26 +0100, Sean Christopherson <seanjc@google.com> wrote:

[...]

> > > Would it be possible to require a dirty bitmap when an ITS is
> > > created?  That would allow treating the above condition as a KVM
> > > bug.
> > 
> > No. This should be optional. Everything about migration should be
> > absolutely optional (I run plenty of concurrent VMs on sub-2GB
> > systems). You want to migrate a VM that has an ITS or will collect
> > dirty bits originating from a SMMU with HTTU, you enable the dirty
> > bitmap. You want to have *vcpu* based dirty rings, you enable them.
> > 
> > In short, there shouldn't be any reason for the two are either
> > mandatory or conflated. Both should be optional, independent, because
> > they cover completely disjoined use cases. *userspace* should be in
> > charge of deciding this.
> 
> I agree about userspace being in control, what I want to avoid is letting userspace
> put KVM into a bad state without any indication from KVM that the setup is wrong
> until something actually dirties a page.
> 
> Specifically, if mark_page_dirty_in_slot() is invoked without a running vCPU, on
> a memslot with dirty tracking enabled but without a dirty bitmap, then the migration
> is doomed.  Dropping the dirty page isn't a sane response as that'd all but
> guaranatee memory corruption in the guest.  At best, KVM could kick all vCPUs out
> to userspace with a new exit reason, but that's not a very good experience for
> userspace as either the VM is unexpectedly unmigratable or the VM ends up being
> killed (or I suppose userspace could treat the exit as a per-VM dirty ring of
> size '1').

This only works on the assumption that the VM is in fact running. In the
case of the GIC ITS, I would expect that the VM has already been paused
in preparation for serialization. So, there would never be a vCPU thread
that would ever detect the kick.

> That's why I asked if it's possible for KVM to require a dirty_bitmap when KVM
> might end up collecting dirty information without a vCPU.  KVM is still
> technically prescribing a solution to userspace, but only because there's only
> one solution.

I was trying to allude to something like this by flat-out requiring
ring + bitmap on arm64.

Otherwise, we'd either need to:

 (1) Document the features that explicitly depend on ring + bitmap (i.e.
 GIC ITS, whatever else may come) such that userspace sets up the
 correct configuration based on what its using. The combined likelihood
 of both KVM and userspace getting this right seems low.

 (2) Outright reject the use of features that require ring + bitmap.
 This pulls in ordering around caps and other UAPI.

> > > > > The acquire-release thing is irrelevant for x86, and no other
> > > > > architecture supports the dirty ring until this series, i.e. there's
> > > > > no need for KVM to detect that userspace has been updated to gain
> > > > > acquire-release semantics, because the fact that userspace is
> > > > > enabling the dirty ring on arm64 means userspace has been updated.
> > > > 
> > > > Do we really need to make the API more awkward? There is an
> > > > established pattern of "enable what is advertised". Some level of
> > > > uniformity wouldn't hurt, really.
> > > 
> > > I agree that uniformity would be nice, but for capabilities I don't
> > > think that's ever going to happen.  I'm pretty sure supporting
> > > enabling is actually in the minority.  E.g. of the 20 capabilities
> > > handled in kvm_vm_ioctl_check_extension_generic(), I believe only 3
> > > support enabling (KVM_CAP_HALT_POLL, KVM_CAP_DIRTY_LOG_RING, and
> > > KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2).
> > 
> > I understood that you were advocating that a check for KVM_CAP_FOO
> > could result in enabling KVM_CAP_BAR. That I definitely object to.
> 
> I was hoping KVM could make the ACQ_REL capability an extension of DIRTY_LOG_RING,
> i.e. userspace would DIRTY_LOG_RING _and_ DIRTY_LOG_RING_ACQ_REL for ARM and other
> architectures, e.g.
> 
>   int enable_dirty_ring(void)
>   {
> 	if (!kvm_check(KVM_CAP_DIRTY_LOG_RING))
> 		return -EINVAL;
> 
> 	if (!tso && !kvm_check(KVM_CAP_DIRTY_LOG_RING_ACQ_REL))
> 		return -EINVAL;
> 
> 	return kvm_enable(KVM_CAP_DIRTY_LOG_RING);
>   }
> 
> But I failed to consider that userspace might try to enable DIRTY_LOG_RING on
> all architectures, i.e. wouldn't arbitrarily restrict DIRTY_LOG_RING to x86.

The third option would be to toss DIRTY_LOG_RING_ACQ_REL this release
and instead add DIRTY_LOG_RING2, this time checking the flags.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
