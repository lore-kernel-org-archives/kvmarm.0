Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BA9C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 11:04:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C128020706
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 11:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SgqE45v2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C128020706
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31BD94B0D8;
	Mon, 22 Jun 2020 07:04:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ts93p7Uzn30N; Mon, 22 Jun 2020 07:04:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1943C4B0D9;
	Mon, 22 Jun 2020 07:04:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F3424B098
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 07:04:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BqAt3zZ1P541 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 07:04:19 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35CEB4B07F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 07:04:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1592823859;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HwoXt7dWc/TfAIRj91iznyBV7/bA+rjYgR8i8jpfDTE=;
 b=SgqE45v2ICvhkx9YeyGhY0edPFIAlGft+oMF0iX0sFhZvMhq85hy/au3rquz92aJYyq14a
 FvWFlbV03FHAjpIfYhlNBIE2CCOMMkS4FKnQ+e04qsb76ssQuoGigVVpRZuqt4lLsEayeA
 Rs6HFSctwg/olPCB/HNV57Q+jHsawso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-IgmcrROOOgeLbYC8UUVz8A-1; Mon, 22 Jun 2020 07:04:13 -0400
X-MC-Unique: IgmcrROOOgeLbYC8UUVz8A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 269A9107ACCD;
 Mon, 22 Jun 2020 11:04:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.179])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 788935BAD8;
 Mon, 22 Jun 2020 11:04:10 +0000 (UTC)
Date: Mon, 22 Jun 2020 13:04:07 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/4] arm64/x86: KVM: Introduce steal time cap
Message-ID: <20200622110407.sna3uftgwybpp6cb@kamzik.brq.redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
 <20200619184629.58653-3-drjones@redhat.com>
 <5b1e895dc0c80bef3c0653894e2358cf@kernel.org>
 <20200622084110.uosiqx3oy22lremu@kamzik.brq.redhat.com>
 <5a52210e5f123d52459f15c594e77bad@kernel.org>
 <20200622103146.fwtr7z3l3mnq4foh@kamzik.brq.redhat.com>
 <7118fcbe911bdb30374b400dc01ca8de@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7118fcbe911bdb30374b400dc01ca8de@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 steven.price@arm.com
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

On Mon, Jun 22, 2020 at 11:39:49AM +0100, Marc Zyngier wrote:
> On 2020-06-22 11:31, Andrew Jones wrote:
> > On Mon, Jun 22, 2020 at 10:51:47AM +0100, Marc Zyngier wrote:
> > > On 2020-06-22 09:41, Andrew Jones wrote:
> > > > On Mon, Jun 22, 2020 at 09:20:02AM +0100, Marc Zyngier wrote:
> > > > > Hi Andrew,
> > > > >
> > > > > On 2020-06-19 19:46, Andrew Jones wrote:
> > > > > > arm64 requires a vcpu fd (KVM_HAS_DEVICE_ATTR vcpu ioctl) to probe
> > > > > > support for steal time. However this is unnecessary and complicates
> > > > > > userspace (userspace may prefer delaying vcpu creation until after
> > > > > > feature probing). Since probing steal time only requires a KVM fd,
> > > > > > we introduce a cap that can be checked.
> > > > >
> > > > > So this is purely an API convenience, right? You want a way to
> > > > > identify the presence of steal time accounting without having to
> > > > > create a vcpu? It would have been nice to have this requirement
> > > > > before we merged this code :-(.
> > > >
> > > > Yes. I wish I had considered it more closely when I was reviewing the
> > > > patches. And, I believe we have yet another user interface issue that
> > > > I'm looking at now. Without the VCPU feature bit I'm not sure how easy
> > > > it will be for a migration to fail when attempting to migrate from a
> > > > host
> > > > with steal-time enabled to one that does not support steal-time. So it's
> > > > starting to look like steal-time should have followed the pmu pattern
> > > > completely, not just the vcpu device ioctl part.
> > > 
> > > Should we consider disabling steal time altogether until this is
> > > worked out?
> > 
> > I think we can leave it alone and just try to resolve it before merging
> > QEMU patches (which I'm working on now). It doesn't look like kvmtool or
> > rust-vmm (the only other two KVM userspaces I'm paying some attention
> > to)
> > do anything with steal-time yet, so they won't notice. And, I'm not sure
> > disabling steal-time for any other userspaces is better than just trying
> > to keep them working the best we can while improving the uapi.
> 
> Is it only migration that is affected? Or do you see issues that would
> affect non-migrating userspace?

If we don't consider the need to check sched_info_on(), then other than
the probing requiring a vcpu fd (which isn't a show stopper, just not
super convenient), then I don't see any other issues for non-migrating
userspace.

> 
> [...]
> 
> > > Accepting the pvtime attributes (setting up the per-vcpu area) has two
> > > effects: we promise both the guest and userspace that we will provide
> > > the guest with steal time. By not checking sched_info_on(), we lie to
> > > both, with potential consequences. It really feels like a bug.
> > 
> > Yes, I agree now. Again, following the pmu pattern looks best here. The
> > pmu will report that it doesn't have the attr support when its
> > underlying
> > kernel support (perf counters) doesn't exist. That's a direct analogy
> > with
> > steal-time relying on sched_info_on().
> 
> Indeed. I'd be happy to take a fix early if you can spin one.

I'll post just that patch now then.

> 
> > I'll work up another version of this series doing that, but before
> > posting
> > I'll look at the migration issue a bit more and likely post something
> > for
> > that as well.
> 
> OK. I'll park this series for now.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
