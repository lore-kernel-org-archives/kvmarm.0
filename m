Return-Path: <SRS0=AWUd=7R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF66C433DF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:32:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F2A0207DF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JVtK6dMT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F2A0207DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E0E4B108;
	Thu,  4 Jun 2020 09:32:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4AeFYqhETB73; Thu,  4 Jun 2020 09:32:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE2724B2C4;
	Thu,  4 Jun 2020 09:32:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FCF44B34E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:32:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y2YxN+zG-B73 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2020 09:32:29 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9920F4B108
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:32:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1591277549;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=6gFuGnbbAHXxpuAojW9oFJ+0WJHlOe4n0dRuEFIwAsc=;
 b=JVtK6dMT04iYBxdFFGiNG0LX9hqDjdlj+AylV3KeyU9XunGAJ6rnVDUERB6iRkQSRpIyAd
 KYabP+e7YvyeuO+KrmMt5ep7ntgZGy0SVGFNWga0AO7s5e3r9UbfKCl0GoigwdOkuIQmRV
 cyIeFV/wkmnKh8I/NMRpNCEorTAr15Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-plk2IwRBMYma-b8Ea5M9_w-1; Thu, 04 Jun 2020 09:32:27 -0400
X-MC-Unique: plk2IwRBMYma-b8Ea5M9_w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B05B107ACF3;
 Thu,  4 Jun 2020 13:32:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.197])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 64C9E78FBF;
 Thu,  4 Jun 2020 13:32:24 +0000 (UTC)
Date: Thu, 4 Jun 2020 15:32:21 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: kvm_target, QEMU_KVM_ARM_TARGET_GENERIC_V8 questions
Message-ID: <20200604133221.zpqv5segdv7qwio6@kamzik.brq.redhat.com>
References: <20200604125544.GW28566@vanye>
 <CAFEAcA-ACvx19HZBk-nusMCOkr-D3KReUJRTouL02rLEXOUanQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-ACvx19HZBk-nusMCOkr-D3KReUJRTouL02rLEXOUanQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Paolo Bonzini <pbonzini@redhat.com>, Leif Lindholm <leif@nuviainc.com>,
 QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
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

On Thu, Jun 04, 2020 at 02:10:08PM +0100, Peter Maydell wrote:
> [added kvm-arm to the cc list; the kernel folks tend to hang out
> there, not on qemu-devel, so KVM related questions are usually
> worth raising there as well.]
> 
> On Thu, 4 Jun 2020 at 13:55, Leif Lindholm <leif@nuviainc.com> wrote:
> > However, while looking at this, I noticed aarch64_a72_initfn doesn't
> > initialise kvm_target at all.
> 
> Yep. The kernel doesn't support "give me a CPU that looks like
> a Cortex-A72".
> 
> > So, then I decided to actually test things, and found that
> > (with -enable-kvm):
> > - on Cortex-A53 hardware
> >   - "max" kvm_target gets initialized to 4 (KVM_ARM_TARGET_CORTEX_A53)
> >     by kvm_arm_get_host_cpu_features (as returned from the kernel for
> >     vm_arm_create_scratch_host_vcpu)
> >   - cortex-A72 fails to start with "KVM is not supported for this guest
> >     CPU type"
> >   (fair enough, it's later than A53)
> 
> Untested, but I assume that -cpu cortex-a53 works on the A53...
> 
> > - on Cortex-A72 hardware
> >   - "max" kvm_target gets initialized to 5 (KVM_ARM_TARGET_GENERIC_V8)
> >     by kvm_arm_get_host_cpu_features
> >   - "cortex-A72" fails to start (umm...)
> 
> ...and fails on the A72 host.
> 
> > However ... if I haven't managed to confuse myself somewhere in here
> > (which is completely possible), would it be OK if I submitted a set of
> > patches that:
> > - add a QEMU_KVM_ARM_TARGET_GENERIC_V8 to match the kernel one
> > - set kvm_target for Cortex-A72 to QEMU_KVM_ARM_TARGET_GENERIC_V8
> 
> This would be wrong -- it would mean that you could tell QEMU "give
> me a guest CPU that's a Cortex-A72" and it would not error on
> non-A72 hardware but not actually give a guest CPU that looks
> like a Cortex-A72.
> 
>  * If what you want is "give me something that works" then that's
>    -cpu host or -cpu max.
> 
>  * If what you want is "give me something that's always this kind of
>    CPU regardless of the host hardware" then that's a lot of kernel
>    dev work nobody's been enthusiastic enough to undertake yet
>    (notably the "what do we do about CPU errata workarounds" question
>    would need to be solved...)
> 
>  * If what you want is "allow me to say '-cpu cortex-a72' and have
>    it work on an A72 host and not anywhere else" then I guess we could
>    implement that on the QEMU side by querying the MIDR and checking
>    whether it was what we expected.

It would match what we have for A53 and A57, so in that case it sounds
reasonable. OTOH, it may cause headaches when we want to finally say that
CPU models work, because it won't be clear to a user that just using
'-cpu cortex-a72' will really work, or just work on an A72 hosts like
before. We'll have that problem with A53 and A57 too, but maybe we
shouldn't add any more.

> 
> >   - alternatively drop the explicit settings for A57/A53
> 
> These explicit settings are correct, because for these CPUs
> the kernel does have a "give me what I want in particular"
> setting (which it will fail on the wrong h/w), and also as
> back-compat for older kernels that predate the GENERIC_V8
> define and only recognize the explicit "give me an A53" value.

Actually, I think the failing for the wrong hardware is about all these
older targets do. I didn't look real closely, but I think all targets
produce the same result for the guest, which is to pass through the host
ID registers.

> 
> > - drop the call from aarch64_max_initfn to aarch64_a57_initfn, and
> >   copy the relevant bits into the former for the !kvm case
> 
> Not sure why you care about this -- it's an implementation
> detail of the TCG handling of the 'max' CPU. There's an argument
> for disentangling TCG 'max' so it's not literally implemented
> as "a57 plus newer stuff", granted.
> 
> thanks
> -- PMM
>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
