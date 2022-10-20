Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB0FEC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 18:59:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 239BA4B9FB;
	Thu, 20 Oct 2022 14:59:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tJB2CwRAhB4b; Thu, 20 Oct 2022 14:59:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA78C4B9FF;
	Thu, 20 Oct 2022 14:59:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC984B9FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 14:59:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id USMvnF4saTn6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 14:59:00 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C49484B9F9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 14:59:00 -0400 (EDT)
Date: Thu, 20 Oct 2022 21:58:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666292339;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=mFdDcgKlE3XXuFjEiY8riBIIBCcAHkobBQ7341g9M90=;
 b=GBvTT4pg9b2Mv+zTUr/jo41QG91tUZ/UsI3TdPofqrz7XnlrVadmYDpGENJWcjvANT1Xfm
 cI9/haQ1cXe+qrw7EQf0hZsacBftfAyDGUm318EGanAuncotmKPu9TAR2sVGTfH9gu/eNx
 LCymui04NS4GxPFRTL5nX7pbcsaG3fg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1GacKRhwBqKKekw@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com> <Y07PNJZ+RJrWxDUP@x1n>
 <12746816-0d9e-15ee-bb08-2025aa4d9ed3@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <12746816-0d9e-15ee-bb08-2025aa4d9ed3@redhat.com>
X-Migadu-Flow: FLOW_OUT
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 catalin.marinas@arm.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
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

On Wed, Oct 19, 2022 at 06:20:32AM +0800, Gavin Shan wrote:
> Hi Peter,
> 
> On 10/19/22 12:07 AM, Peter Xu wrote:
> > On Tue, Oct 11, 2022 at 02:14:42PM +0800, Gavin Shan wrote:

[...]

> > IMHO it'll be great to start with something like below to describe the
> > userspace's responsibility to proactively detect the WITH_BITMAP cap:
> > 
> >    Before using the dirty rings, the userspace needs to detect the cap of
> >    KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP to see whether the ring structures
> >    need to be backed by per-slot bitmaps.
> > 
> >    When KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP returns 1, it means the arch can
> >    dirty guest pages without vcpu/ring context, so that some of the dirty
> >    information will still be maintained in the bitmap structure.
> > 
> >    Note that the bitmap here is only a backup of the ring structure, and it
> >    doesn't need to be collected until the final switch-over of migration
> >    process.  Normally the bitmap should only contain a very small amount of
> >    dirty pages only, which needs to be transferred during VM downtime.
> > 
> >    To collect dirty bits in the backup bitmap, the userspace can use the
> >    same KVM_GET_DIRTY_LOG ioctl.  Since it's always the last phase of
> >    migration that needs the fetching of dirty bitmap, KVM_CLEAR_DIRTY_LOG
> >    ioctl should not be needed in this case and its behavior undefined.
> > 
> > That's how I understand this new cap, but let me know if you think any of
> > above is inproper.
> > 
> 
> Yes, It looks much better to describe how KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
> is used. However, the missed part is the capability is still need to be enabled
> prior to KVM_CAP_DIRTY_LOG_RING_ACQ_REL on ARM64. It means the capability needs
> to be acknowledged (confirmed) by user space. Otherwise, KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> can't be enabled successfully. It seems Oliver, you and I aren't on same page for
> this part. Please refer to below reply for more discussion. After the discussion
> is finalized, I can amend the description accordingly here.

I'll follow up on the details of the CAP below, but wanted to explicitly
note some stuff for documentation:

Collecting the dirty bitmap should be the very last thing that the VMM
does before transmitting state to the target VMM. You'll want to make
sure that the dirty state is final and avoid missing dirty pages from
another ioctl ordered after bitmap collection.

[...]

> > > +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
> > > +		kvm->dirty_ring_with_bitmap = true;
> > 
> > IIUC what Oliver wanted to suggest is we can avoid enabling of this cap,
> > then we don't need dirty_ring_with_bitmap field but instead we can check
> > against CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP when needed.
> > 
> > I think that'll make sense, because without the bitmap the ring won't work
> > with arm64, so not valid to not enable it at all.  But good to double check
> > with Oliver too.
> > 
> > The rest looks good to me, thanks,
> > 
> 
> It was suggested by Oliver to expose KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP. The
> user space also needs to enable the capability prior to KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> on ARM64. I may be missing something since Oliver and you had lots of discussion
> on this particular new capability.
> 
> I'm fine to drop the bits to enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP. It means
> the capability is exposed to user space on ARM64 and user space need __not__ to
> enable it prior to KVM_CAP_DIRTY_LOG_RING_ACQ_REL. I would like Oliver helps to
> confirm before I'm able to post v7.

IMO you really want the explicit buy-in from userspace, as failure to
collect the dirty bitmap will result in a dead VM on the other side of
migration. Fundamentally we're changing the ABI of
KVM_CAP_DIRTY_LOG_RING[_ACQ_REL].

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
