Return-Path: <SRS0=dOSa=5Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D3DC43331
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 13:14:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32E4920578
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 13:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFl18EOU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32E4920578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A7B84B08E;
	Tue, 31 Mar 2020 09:14:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S6bK2TAhW34l; Tue, 31 Mar 2020 09:14:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ABD84A4CD;
	Tue, 31 Mar 2020 09:14:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8FB54A49F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 09:14:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nhRe3kUgH6tL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2020 09:14:19 -0400 (EDT)
Received: from mail-lj1-f196.google.com (mail-lj1-f196.google.com
 [209.85.208.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9985440152
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 09:14:19 -0400 (EDT)
Received: by mail-lj1-f196.google.com with SMTP id w1so21887458ljh.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 06:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=RmgdITF6YYuKSl7MHXUnGqYkS54jESASdav1soSTIkw=;
 b=gFl18EOUzvKyK16fYDr411BpFbmohyElh1z5H5kHZQzb+DtN4j69KvMaDM+nvMuA3N
 huL5wHwtfOclYj/ub+wJlb4ct0X+zYUJG2mkkPDeZnVZsIod8qCvKtyNIYpvsl+pCpmf
 79KTGycYhlaoHVXhcGxPgPin9qCtfPM610mx8U+90dpjzHrM9j83ac3Rrsoh5xUSm2lD
 hFmJuo5HAnewXNld4UE1bvBfTJQIxIPLJ+VN6Nghrc1FYgyT3hkuhos5GoI5/cJA5S73
 FqVD8Qc48rVP6r9oPb18T/gA2EJ73RmEIb4wuS+h+nJqnDOGJCNQIumYsJipt88VWdvO
 FTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=RmgdITF6YYuKSl7MHXUnGqYkS54jESASdav1soSTIkw=;
 b=UyLYEkx1n5rgnIlQAN1bzRKXs+dLeoEjsevXQg2kHk03WYNn5q2MPa/9RGGRiVFdBR
 u6W42V2gd3QXP7ZxzwTvOnV0L7gi3Ly8hPa+SJyeGN6KcPLvp9f12dQHYfLpHLbBoTek
 EMCHMiG0YGXVyu11rOleACbDxrS6D54W277Q2sKfYqRQ8k91orX3R8haVoQZRAMGPi2i
 6iwdLWSW1SehzjuQSxTcfUccXk6DfzyjyK5ciCipbRWH6qUjDBqqFoBWW2nKNsSdDumU
 AluRmpu66FebJ6+awY7/bMlLrvrxKtpmtwVcdce1fIyRWUiuxVesj7ICxIwTCsFLKMvU
 5P8Q==
X-Gm-Message-State: AGi0PuYbMnppbB5A6D+i/kIj6V/ifzNpvdRdP/Khh0b23kYsF2zSzhbI
 DM8j0JaR4q4quWF5YM8bkYTjH9hEbxW+90yXAkg=
X-Google-Smtp-Source: APiQypJBmRbnFXdUPc9N/d16YVqV5wgWTNMh20jjM+PhtG+VFKeLb9jUCgj/aMUBVX6HgLrWWQ0bMkYLmzGfN2My3Vw=
X-Received: by 2002:a2e:b8c1:: with SMTP id s1mr10648123ljp.0.1585660458025;
 Tue, 31 Mar 2020 06:14:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAE=NcrY4K-K8eWwW-8+8J8P2Wg3TnJc-TQko117X=aTy8bQFPQ@mail.gmail.com>
 <20200331133609.08e89abc@why>
In-Reply-To: <20200331133609.08e89abc@why>
From: Janne Karhunen <janne.karhunen@gmail.com>
Date: Tue, 31 Mar 2020 16:14:06 +0300
Message-ID: <CAE=NcrYVdfuxcojLqqUe_ienYd6okdJX2wq9eHmazs1V-6QBeg@mail.gmail.com>
Subject: Re: kvm stage 2 mapping logic
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 31, 2020 at 3:36 PM Marc Zyngier <maz@kernel.org> wrote:

> > I'm experimenting with the kvm in order to see how it would work in
> > co-existence with a tiny external hypervisor that also runs the host
> > in el1/vmid 0.
>
> Popular theme these days...

Indeed. In my dream world I would land with a config where the host
and the guest have very minimal understanding of each other. How small
that can be remains to be seen..


> > More about this later on in case it turns out to be
> > anything generally useful, but I've been stuck for a few days now
> > understanding the kvm stage-2 (ipa-to-phys) mapping when the guest is
> > being created. Things I think I've understood so far;
> >
> > - qemu mmaps the guest memory per the machine type (virt in my case)
> > - qemu pushes the machine physical memory model in the kernel through
> > the kvm_vm_ioctl_set_memory_region()
> > - kvm has mmu notifier block set to listen to the changes to these
> > regions and it becomes active after the machine memory model arrives.
> > The mmu notifier calls handle_hva_to_gpa() that dispatches the call to
> > the appropriate map or unmap handler and these do the s2 mapping
> > changes for the vm as needed
>
> Note that these MMU notifiers only make sense when something happens on
> the host: attribute change (for page aging, for example) or unmap
> (e.g. page being swapped out).

Yes. This fooled me for a while as I was thinking it actually does the
job, but no. It was my second miss, first place I was looking at was
the ioctl call itself.


> > - prior to starting the vm, kvm_arch_prepare_memory_region() is given
> > a try to see if any IO areas could be s2 mapped before the host is
> > allowed to execute. This is mostly an optimization?
>
> Yes, and not necessarily a useful one. I think I have a patch to drop
> that.

Ack.


> > - vcpu is started
> > - as the pages are touched when the vcpu starts executing, page faults
> > get generated and the real s2 mappings slowly start to get created.
> > LRU keeps the active pages pinned in memory, others will get evicted
> > and their s2 mapping eventually disappears
> > - all in all, the vm runs and behaves pretty much like a normal
> > userspace process
>
> Indeed, just with a different set of page tables.

Awesome. Took a while to understand the construction.


> > Is this roughly the story? If it is, I'm a bit lost where the stage2
> > page fault handler that is supposed to generate the s2 mappings is.
>
> user_mem_abort() is your friend (or not, it's a very nasty piece of
> code). If you trace the fault handling path all the way from the EL2
> vectors, you will eventually get there.

THANK YOU! My missing piece.


> > It
> > was surprisingly easy to get the external hypervisor (with very
> > minimal changes to the kvm) to the point when the guest is being
> > entered and the vmid 1 starts to refer to the instructions at the vm
> > ram base (0x4000 0000 for virt). Those, of course, currently scream
> > bloody murder as the s2 mapping does not exist.
>
> Well, *something* must be handling the fault, right? But if you've
> wrapped the host with its own S2 page tables, it may not be able to
> populate the S2 pages for the guest (wild guess...).

Let's see. Yes, the 'virt' host is already nicely wrapped and running.
To make this easier for starters I use 1:1 ipa:phys mapping to get one
vm (besides the host) going.


--
Janne
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
