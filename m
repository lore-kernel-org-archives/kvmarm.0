Return-Path: <SRS0=aIiX=IH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A92BC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 14:29:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97C9B651B9
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 14:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97C9B651B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 078154B4B5;
	Tue,  9 Mar 2021 09:29:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VUangG9V8ThG; Tue,  9 Mar 2021 09:29:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A57D4B4B9;
	Tue,  9 Mar 2021 09:29:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B57064B4B6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 09:29:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3JM9qpcK9I3d for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Mar 2021 09:29:25 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 233AD4B4B5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 09:29:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615300165;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=L22KmfOnAOizNF3BC+M4wP56KbnbD9HDy+nSqMmcGak=;
 b=N/otP2uAcBteSch/BmEb7OcVzOt5OYCg8anayTHlh3xipgGlzesuw9OjMu7QaLB7mSV/1a
 AqWtoTFr+S/o0a2yQYYWL6ufHSy2ScyY9LAiN2zPl1Z2zAwNgRbKvre26vohQRWg8Kx7M/
 fUmPOoBUtYjwqLwmu22ozk3ZW+e/m3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-bdKBlJisMQyL4GYvKuDsWg-1; Tue, 09 Mar 2021 09:29:21 -0500
X-MC-Unique: bdKBlJisMQyL4GYvKuDsWg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ECFA80432F;
 Tue,  9 Mar 2021 14:29:19 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.217])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C28961F55;
 Tue,  9 Mar 2021 14:29:15 +0000 (UTC)
Date: Tue, 9 Mar 2021 15:29:10 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Cap default IPA size to the host's own size
Message-ID: <20210309142910.awjhb52tgj5nxs72@kamzik.brq.redhat.com>
References: <20210308174643.761100-1-maz@kernel.org>
 <20210309132021.7vuuf73joybhlhg3@kamzik.brq.redhat.com>
 <87mtvcxx0z.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87mtvcxx0z.wl-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 09, 2021 at 01:43:40PM +0000, Marc Zyngier wrote:
> Hi Andrew,
> 
> On Tue, 09 Mar 2021 13:20:21 +0000,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Mon, Mar 08, 2021 at 05:46:43PM +0000, Marc Zyngier wrote:
> > > KVM/arm64 has forever used a 40bit default IPA space, partially
> > > due to its 32bit heritage (where the only choice is 40bit).
> > > 
> > > However, there are implementations in the wild that have a *cough*
> > > much smaller *cough* IPA space, which leads to a misprogramming of
> > > VTCR_EL2, and a guest that is stuck on its first memory access
> > > if userspace dares to ask for the default IPA setting (which most
> > > VMMs do).
> > > 
> > > Instead, cap the default IPA size to what the host can actually
> > > do, and spit out a one-off message on the console. The boot warning
> > > is turned into a more meaningfull message, and the new behaviour
> > > is also documented.
> > > 
> > > Although this is a userspace ABI change, it doesn't really change
> > > much for userspace:
> > > 
> > > - the guest couldn't run before this change, while it now has
> > >   a chance to if the memory range fits the reduced IPA space
> > > 
> > > - a memory slot that was accepted because it did fit the default
> > >   IPA space but didn't fit the HW constraints is now properly
> > >   rejected
> > 
> > I'm not sure deferring the misconfiguration error until memslot
> > request time is better than just failing to create a VM. If
> > userspace doesn't use KVM_CAP_ARM_VM_IPA_SIZE to determine the
> > limit (which it hasn't been obliged to do) and it is able to
> > successfully create a VM, then it will assume up to 40-bit IPAs
> > are supported. Later, when it tries to add memslots and fails
> > it may be confused, especially if that later is much, much later
> > with memory hotplug.
> 
> That's a fair point. However, no existing userspace will work on these
> systems. Is that what we want to do? I don't care much, but having
> non-usable defaults feel a bit... odd. I do spit out a warning, but I
> agree this isn't great either.

I can send patches for QEMU, KVM selftests, and maybe even rust-vmm.
Can you point me to something about these systems I can reference
in my postings? Or I can just reference this mail thread.

> 
> > > The other thing that's left doing is to convince userspace to
> > > actually use the IPA space setting instead of relying on the
> > > antiquated default.
> > 
> > Failing to create any VM which hasn't selected a valid IPA limit
> > should be pretty convincing :-)
> 
> I'll make sure to redirect the reports your way! :D

What's the current error message when this occurs? Is it good enough, or
should we improve it to help provide people hints? Please don't change
it to "Invalid IPA limit, please mail Andrew Jones" :-)

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
