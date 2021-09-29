Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6600C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 18:22:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3420361505
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 18:22:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3420361505
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F8F4B0B4;
	Wed, 29 Sep 2021 14:22:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ch97c4OAUzxe; Wed, 29 Sep 2021 14:22:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67C2D4B08E;
	Wed, 29 Sep 2021 14:22:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF0944B08E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 14:22:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8sr8UQkq4+KQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 14:22:18 -0400 (EDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
 [209.85.167.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CC234A4BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 14:22:18 -0400 (EDT)
Received: by mail-lf1-f44.google.com with SMTP id i25so14482406lfg.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 11:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Qtfpl4QD2zskjNpgRMOv1rx5s1LAJUZnW7UP8LdwoyI=;
 b=jNO8noc6wU0vBuBuA5SgzKDJSdjcJtQzSu6NU2uxa8ZSMdSU0rBu5zmLhm+/yKCjoy
 ef+9UZO7RcYlfw89pWUi7lY4xnn8me2aZdS3wY5HXVu5P3KcRiAQQ6flwJa5W7D9nNWE
 +vtTRXVJPaeLOhyI/rzF4EWfzApnPvO8UWRG2sY1OU74NZvn/66Z2/yMf3454os4jWBw
 iQT+Gwy5fTV072sCo8419n5yroRDCEbVmOY6QLwxGPPPnFv8scUz0XuRBI51kwyt2WTW
 3VWE5RJiCfA+/3QrFCWXNZWBAWYucDnltzpZp8V3SPSuPmWyMavydbnEeT8F6fDR5ZBi
 midQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Qtfpl4QD2zskjNpgRMOv1rx5s1LAJUZnW7UP8LdwoyI=;
 b=agqdWiMgYUhE+FAHAfTFIbn20MOPJrBRLGK4+0a9TTloOvLw+wC84jdpyKBIscv2XC
 taWYbR1dUlFSJUJYFanPBlTjKAtobdupoUmrKCwySTtxvDrCaysDeuw+sb+bpEY4rice
 qnhIAW3jFqhfD3Lk2z4ymCxulS+ssxOeoblJCQ9ePXfRy0EfU9B7/ZA9VKPgRTCCIll8
 vrXYWOhIJJgeyuqI7OkZzHupg1KvboDnMw4oLY2GHbdtXiHDdWJcuVsbnSx/f9XTCK28
 1gL9ct5v5muHSdB+CJSRLhR51MFDBLMdWAOD6Hus8+POdXDDSFdkuCxj1Jy/XtmZVh5m
 iMyg==
X-Gm-Message-State: AOAM533HvFvPKgvAo2u1IASzzjLXg06ez7hZQGjT+4zHt8+Zh44oplO5
 LK3WW2gRrMp8icaEt+pTvo7ZNPNgRMF/Oe+mx8CBug==
X-Google-Smtp-Source: ABdhPJzaUBqKkCyaK9Fbh1Rz2z0TQHkOtkLi8JOjPmgJpuI5lcxIdv+YXlRfj2naCQ46/v6CbxB5cMwrUmzNFTnMYlI=
X-Received: by 2002:ac2:4217:: with SMTP id y23mr1086804lfh.361.1632939736699; 
 Wed, 29 Sep 2021 11:22:16 -0700 (PDT)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
 <20210827074011.ci2kzo4cnlp3qz7h@gator.home>
In-Reply-To: <20210827074011.ci2kzo4cnlp3qz7h@gator.home>
From: Oliver Upton <oupton@google.com>
Date: Wed, 29 Sep 2021 11:22:05 -0700
Message-ID: <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, pshier@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, Aug 27, 2021 at 12:40 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Aug 26, 2021 at 06:49:27PM +0000, Oliver Upton wrote:
> > On Thu, Aug 26, 2021 at 09:37:42AM +0100, Marc Zyngier wrote:
> > > On Wed, 25 Aug 2021 19:14:59 +0100,
> > > Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > On Wed, Aug 25, 2021 at 8:07 AM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > [...]
> > >
> > > > > Thanks for including me Marc. I think you've mentioned all the examples
> > > > > of why we don't generally expect N+1 -> N migrations to work that I
> > > > > can think of. While some of the examples like get-reg-list could
> > > > > eventually be eliminated if we had CPU models to tighten our machine type
> > > > > state, I think N+1 -> N migrations will always be best effort at most.
> > > > >
> > > > > I agree with giving userspace control over the exposer of the hypercalls
> > > > > though. Using pseudo-registers for that purpose rather than a pile of
> > > > > CAPs also seems reasonable to me.
> > > > >
> > > > > And, while I don't think this patch is going to proceed, I thought I'd
> > > > > point out that the opt-out approach doesn't help much with expanding
> > > > > our migration support unless we require the VMM to be upgraded first.
> > > > >
> > > > > And, even then, the (N_kern, N+1_vmm) -> (N+1_kern, N_vmm) case won't
> > > > > work as expected, since the source enforce opt-out, but the destination
> > > > > won't.
> > > >
> > > > Right, there's going to need to be a fence in both kernel and VMM
> > > > versions. Before the fence, you can't rollback with either component.
> > > > Once on the other side of the fence, the user may freely migrate
> > > > between kernel + VMM combinations.
> > > >
> > > > > Also, since the VMM doesn't key off the kernel version, for the
> > > > > most part N+1 VMMs won't know when they're supposed to opt-out or not,
> > > > > leaving it to the user to ensure they consider everything. opt-in
> > > > > usually only needs the user to consider what machine type they want to
> > > > > launch.
> > > >
> > > > Going the register route will implicitly require opt-out for all old
> > > > hypercalls. We exposed them unconditionally to the guest before, and
> > > > we must uphold that behavior. The default value for the bitmap will
> > > > have those features set. Any hypercalls added after that register
> > > > interface will then require explicit opt-in from userspace.
> > >
> > > I disagree here. This makes the ABI inconsistent, and means that no
> > > feature can be implemented without changing userspace. If you can deal
> > > with the existing features, you should be able to deal with the next
> > > lot.
> > >
> > > > With regards to the pseudoregister interface, how would a VMM discover
> > > > new bits? From my perspective, you need to have two bitmaps that the
> > > > VMM can get at: the set of supported feature bits and the active
> > > > bitmap of features for a running guest.
> > >
> > > My proposal is that we have a single pseudo-register exposing the list
> > > of implemented by the kernel. Clear the bits you don't want, and write
> > > back the result. As long as you haven't written anything, you have the
> > > full feature set. That's pretty similar to the virtio feature
> > > negotiation.
> >
> > Ah, yes I agree. Thinking about it more we will not need something
> > similar to KVM_GET_SUPPORTED_CPUID.
> >
> > So then, for any register where userspace/KVM need to negotiate
> > features, the default value will return the maximum feature set that is
> > supported. If userspace wants to constrain features, read out the
> > register, make sure everything you want is there, and write it back
> > blowing away the superfluous bits. Given this should we enforce ordering
> > on feature registers, such that a VMM can only write to the registers
> > before a VM is started?
>
> That's a good idea. KVM_REG_ARM64_SVE_VLS has this type of constraint so
> we can model the feature register control off that.
>
> >
> > Also, Reiji is working on making the identity registers writable for the
> > sake of feature restriction. The suggested negotiation interface would
> > be applicable there too, IMO.
>
> This this interesting news. I'll look forward to the posting.
>
> >
> > Many thanks to both you and Drew for working this out with me.
> >
>
> Thanks,
> drew
>

Hey folks,

I have some lingering thoughts on this subject since we last spoke and
wanted to discuss.

I'm having a hard time figuring out how a VMM should handle a new
hypercall identity register introduced on a newer kernel. In order to
maintain guest ABI, the VMM would need to know about that register and
zero it when restoring an older guest.

Perhaps instead we could reserve a range of firmware registers as the
'hypercall identity' registers. Implement all of them as RAZ/WI by
default, encouraging userspace to zero these registers away for older
VMs but still allowing an old userspace to pick up new KVM features.
Doing so would align the hypercall identity registers with the feature
ID registers from the architecture.

Thoughts?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
