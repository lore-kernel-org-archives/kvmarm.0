Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB9CC32772
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 14:44:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C87234D127;
	Tue, 23 Aug 2022 10:44:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QyjiGqbVC6f9; Tue, 23 Aug 2022 10:44:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85FEF4D112;
	Tue, 23 Aug 2022 10:44:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 582764D107
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 10:44:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k8+zsco+D40i for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 10:44:50 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B57514D0FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 10:44:50 -0400 (EDT)
Date: Tue, 23 Aug 2022 09:44:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661265889;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wYTxuO09xQHamH8HB9DanmNLqgTyS7iN+66gFB/iGcs=;
 b=KzS2iPpdIzfHDC3yepdSeojEKRrJeBGV61JZxpWQCWAB5NKd2i2D94pZKSuDM3G2eJ+izs
 YH21AVjrNOZyMSuuQy6w0ir/+3q7zjahK2l6toOyZkSk/VUDgyVAMtk9rvwdQk0szY003u
 jUrrEx4Pa3dRbNvCt5aPDinF0ofcJvA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
Message-ID: <YwTn2r6FLCx9mAU7@google.com>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com>
 <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87fshovtu0.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, will@kernel.org,
 shan.gavin@gmail.com, drjones@redhat.com, zhenyzha@redhat.com,
 dmatlack@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com
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

On Mon, Aug 22, 2022 at 10:42:15PM +0100, Marc Zyngier wrote:
> Hi Gavin,
> 
> On Mon, 22 Aug 2022 02:58:20 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
> > 
> > Hi Marc,
> > 
> > On 8/19/22 6:00 PM, Marc Zyngier wrote:
> > > On Fri, 19 Aug 2022 01:55:57 +0100,
> > > Gavin Shan <gshan@redhat.com> wrote:
> > >> 
> > >> The ring-based dirty memory tracking has been available and enabled
> > >> on x86 for a while. The feature is beneficial when the number of
> > >> dirty pages is small in a checkpointing system or live migration
> > >> scenario. More details can be found from fb04a1eddb1a ("KVM: X86:
> > >> Implement ring-based dirty memory tracking").
> > >> 
> > >> This enables the ring-based dirty memory tracking on ARM64. It's
> > >> notable that no extra reserved ring entries are needed on ARM64
> > >> because the huge pages are always split into base pages when page
> > >> dirty tracking is enabled.
> > > 
> > > Can you please elaborate on this? Adding a per-CPU ring of course
> > > results in extra memory allocation, so there must be a subtle
> > > x86-specific detail that I'm not aware of...
> > > 
> > 
> > Sure. I guess it's helpful to explain how it works in next revision.
> > Something like below:
> > 
> > This enables the ring-based dirty memory tracking on ARM64. The feature
> > is enabled by CONFIG_HAVE_KVM_DIRTY_RING, detected and enabled by
> > CONFIG_HAVE_KVM_DIRTY_RING. A ring buffer is created on every vcpu and
> > each entry is described by 'struct kvm_dirty_gfn'. The ring buffer is
> > pushed by host when page becomes dirty and pulled by userspace. A vcpu
> > exit is forced when the ring buffer becomes full. The ring buffers on
> > all vcpus can be reset by ioctl command KVM_RESET_DIRTY_RINGS.
> > 
> > Yes, I think so. Adding a per-CPU ring results in extra memory allocation.
> > However, it's avoiding synchronization among multiple vcpus when dirty
> > pages happen on multiple vcpus. More discussion can be found from [1]
> 
> Oh, I totally buy the relaxation of the synchronisation (though I
> doubt this will have any visible effect until we have something like
> Oliver's patches to allow parallel faulting).
> 

Heh, yeah I need to get that out the door. I'll also note that Gavin's
changes are still relevant without that series, as we do write unprotect
in parallel at PTE granularity after commit f783ef1c0e82 ("KVM: arm64:
Add fast path to handle permission relaxation during dirty logging").

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
