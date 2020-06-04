Return-Path: <SRS0=AWUd=7R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F65BC433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 16:31:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA4E3206E6
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 16:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nuviainc-com.20150623.gappssmtp.com header.i=@nuviainc-com.20150623.gappssmtp.com header.b="mSbcvKIf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA4E3206E6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nuviainc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01FD84B3FA;
	Thu,  4 Jun 2020 12:31:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@nuviainc-com.20150623.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CIWOkK-ipqld; Thu,  4 Jun 2020 12:31:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7D924B388;
	Thu,  4 Jun 2020 12:31:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27A364B35A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 11:38:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 53OcgskM9oAG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2020 11:38:50 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F20A4B359
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 11:38:50 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id q11so6643050wrp.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Jun 2020 08:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=qCXEcpG31wPJYLx+CXiCODOdNShDZ8WkTXBu5ixfjgY=;
 b=mSbcvKIfERTCbok6Cr+Mg31u8V2shke/NAOnI9WBDNMYfcltPVw19bp7jPXiOHQgjr
 nbQEg2HvwilGsgwB+d3i+zt7oz9/lySDlaMoYjCRBOK0Gs44uA5zlfGdRDp9AQyg93U2
 xWvvMhqz7IPUXbfAbUDgxyavckvebVEPLNcsL3eFMoz1eUSSlpoIW1Eu+aNXBXXWPjH3
 eoAjkOcrsgifM/8Tc7WbJ7EH9yGGxDCo8yfAO9cmLsQpJryutUiU8AulWXAtHIfhT3Xk
 sWlAtm/YWgmQlxzPmqTF+imE48rR1f+0zsLInnByXNZTsgSI+aIysdkrx9qCtALwp9TL
 H2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=qCXEcpG31wPJYLx+CXiCODOdNShDZ8WkTXBu5ixfjgY=;
 b=W2qLb+VWt0M5o7Xl84x5M9hLgsQbVI7gx+A5WMn3hpE8pGBLJeij5AASCFUOTJWiVz
 4Aq9h8rZnkiBeeaw1b17eEh2mBD4Fp/ttpPlIi71um7bsovO8E8b8lO4vhrhAXVyKVQR
 xJGHwNNA3novkkPGjFJYLL6q4UWNCUQcoMtQJiDd99QNlc3OHXKpUulmDgaEDWaU3ppM
 9I8G8xDDb0UmBF9yIctp8S0ym/5y6UG1lJ3ln/5xkaLf2aC7xC58Hiiksei4gNRNt2pr
 prvPrppKftwjndIQgKCukrXuE36heVHwkTHOhagWEBLadvRksjptb7kGrA96IV56aXbl
 1xrQ==
X-Gm-Message-State: AOAM532ek+/eW16Kbksf4mOGI5E3Cx9Ddh6UjQZruvPvpdGnCuwJJtyk
 WgrlSFNi0adFixCvWsBs+DYEfg==
X-Google-Smtp-Source: ABdhPJyc2IRyPbR9peyOCpCoVJwBMgw6GyS4xQyhVta3cyT2cPebISzpEh6rkDByicMV5sfdZ/0taw==
X-Received: by 2002:a5d:4385:: with SMTP id i5mr4877684wrq.420.1591285129546; 
 Thu, 04 Jun 2020 08:38:49 -0700 (PDT)
Received: from vanye ([2001:470:1f09:12f0:b26e:bfff:fea9:f1b8])
 by smtp.gmail.com with ESMTPSA id a14sm8902248wrv.20.2020.06.04.08.38.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Jun 2020 08:38:48 -0700 (PDT)
Date: Thu, 4 Jun 2020 16:38:46 +0100
From: Leif Lindholm <leif@nuviainc.com>
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: kvm_target, QEMU_KVM_ARM_TARGET_GENERIC_V8 questions
Message-ID: <20200604153846.GA28566@vanye>
References: <20200604125544.GW28566@vanye>
 <CAFEAcA-ACvx19HZBk-nusMCOkr-D3KReUJRTouL02rLEXOUanQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFEAcA-ACvx19HZBk-nusMCOkr-D3KReUJRTouL02rLEXOUanQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailman-Approved-At: Thu, 04 Jun 2020 12:31:13 -0400
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm <qemu-arm@nongnu.org>,
 QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 04, 2020 at 14:10:08 +0100, Peter Maydell wrote:
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

Yes.

> > - on Cortex-A72 hardware
> >   - "max" kvm_target gets initialized to 5 (KVM_ARM_TARGET_GENERIC_V8)
> >     by kvm_arm_get_host_cpu_features
> >   - "cortex-A72" fails to start (umm...)
> 
> ...and fails on the A72 host.

From an explicit software test. If I initialize kvm_target to
KVM_ARM_TARGET_GENERIC_V8, I can certainly run EDK2.

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

That's what I thought until I saw the manual A57/A53 setting of
kvm_target.

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

I don't really.

> >   - alternatively drop the explicit settings for A57/A53
> 
> These explicit settings are correct, because for these CPUs
> the kernel does have a "give me what I want in particular"
> setting (which it will fail on the wrong h/w), and also as
> back-compat for older kernels that predate the GENERIC_V8
> define and only recognize the explicit "give me an A53" value.

Right. But then I got somewhat confused also by how
https://git.qemu.org/?p=qemu.git;a=blob;f=target/arm/kvm64.c#l494
doesn't explicitly list KVM_ARM_TARGET_CORTEX_A53.

> > - drop the call from aarch64_max_initfn to aarch64_a57_initfn, and
> >   copy the relevant bits into the former for the !kvm case
> 
> Not sure why you care about this -- it's an implementation
> detail of the TCG handling of the 'max' CPU. There's an argument
> for disentangling TCG 'max' so it's not literally implemented
> as "a57 plus newer stuff", granted.

So ... the reason I care is because I'm adding a new cpu in my local
branch, figured cpu64.c was a good starting point, and then followed a
long string of repeating the questions "why?" and "why not?" while
trying to understand why things were set up the way they are.

And I ended up in a state where it looks like we do some things for
A57 that we don't do for A53, and we do even fewer things for A72, but
then we do (end up doing) all of the A57 bits again for max (for TCG
only), and then overwriting them.

Then I tried to build some sort of consistent working model in my head
and send some questions off to the list rather than try to send out
patches straight away as I figured the likelihood was high I had
missed or misunderstood something.

I guess what I'm really asking is if there is some legacy in here
that can be cleaned up to make the expected behaviour for a new CPU
more clear from looking at available code? And if there are specific
legacy things that need to be kept around for compatibility that
should not be implemented by new CPUs, if they could have some nice
warnings attached.

Regards,

Leif
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
