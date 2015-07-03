From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 11/13] KVM: arm64: implement ITS command queue command
 handlers
Date: Fri, 3 Jul 2015 23:01:10 +0200
Message-ID: <20150703210110.GA10878@cbox>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <1432893209-27313-12-git-send-email-andre.przywara@arm.com>
 <20150628194148.GM28244@cbox> <5596B0D0.3080505@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B992857362
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 16:49:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 23nZCj94+v-A for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 16:49:55 -0400 (EDT)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B983E572FB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 16:49:54 -0400 (EDT)
Received: by lagx9 with SMTP id x9so96492373lag.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jul 2015 14:01:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5596B0D0.3080505@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 03, 2015 at 04:57:04PM +0100, Andre Przywara wrote:
> Hi Christoffer,
> 
> ....
> 
> >> +
> >> +static struct its_collection *vits_new_collection(struct kvm *kvm, u32 coll_id)
> >> +{
> >> +	struct its_collection *collection;
> >> +
> >> +	collection = kmalloc(sizeof(struct its_collection), GFP_KERNEL);
> > 
> > If I manage to understand the structure here, you're calling all these
> > handler functions with a spinlock held so any operation that may sleep
> > could cause your system to deadlock.
> > 
> > I'll stop looking for these and recommend you go over the whole series
> > for these.
> 
> Do you reckon it would be sufficient to just avoid the kmallocs inside
> the lock? For this case above we could go with some storage space
> preallocated outside of the lock (I hope).
> 

Yes, you can preallocate or you need to grab a mutex instead of a
spinlock...

> > 
> > Perhaps the right thing to do is to synchronize access to your data
> > structure (why you hold the spinlock right?) with RCU if you can...
> 
> Well, the point is that there is not one ITS data structure, but it's a
> mesh of lists connected to each other. I'd like to avoid going down with
> RCU there, so I'd like to keep it all under one lock.
> I wonder if this could be mutex_lock_interruptible, though. From the top
> of your head, is there anything that would prevent that? I reckon ITS
> access contention is rather rare (though possible), so a sleeping VCPU
> wouldn't harm us so much in practice, would it?
> 
We know from experience from x86 that one of the things they had to look
at was to get the run-loop lock-free, and we went through a lot of
effort to do that on ARM too.  Along came the vgic and that was out the
window, and now it feels like we're just grabbing spinlocks all over the
place.

I'm fine with a mutex if other solutions are not easy/possible and it's
in a truly non-critical path, but I wouldn't to speculate about the
level of contention at this point without profiling something.

In any case, let's fix the potential host-kernel deadlock issues in the
most elegant way first and let's try to think about not grabbing too
many spinlocks in this code and take it from there.

Thanks,
-Christoffer
