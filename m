Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F84CC56201
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 19:12:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CBBB8208D5
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 19:12:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXvWCxF8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBBB8208D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28F794B53F;
	Thu, 19 Nov 2020 14:12:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DfdupgqpmLhx; Thu, 19 Nov 2020 14:11:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDBBB4B548;
	Thu, 19 Nov 2020 14:11:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F33D4B53F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 14:11:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fb0vpyMQVjoF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 14:11:58 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 255114B4A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 14:11:58 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BB77A208D5;
 Thu, 19 Nov 2020 19:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605813116;
 bh=XyD+uyMaviImuATuD/h4kUXMXfBH+Udbo+OGArJdcB4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=lXvWCxF8cD+nUERBpe5nbs32UMfizZuC8mx5wH0gw+SOer45PM7TBYg0vTztvJoke
 9yb8vAB926OI2q0x6zS1+P/r/32sAjZ22cHmbqSbEnzy818YvqDRb3rfNmcKF8R6Op
 Qs7I7BYnH4Hb4+ikyoXYgmwJcfYVLv5DNTtzqy/M=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kfpLW-00C3aD-GL; Thu, 19 Nov 2020 19:11:54 +0000
MIME-Version: 1.0
Date: Thu, 19 Nov 2020 19:11:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
In-Reply-To: <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, peter.maydell@linaro.org,
 steven.price@arm.com, mark.rutland@arm.com, dgilbert@redhat.com,
 Haibo.Xu@arm.com, suzuki.poulose@arm.com, qemu-devel@nongnu.org,
 catalin.marinas@arm.com, quintela@redhat.com, richard.henderson@linaro.org,
 linux-kernel@vger.kernel.org, Dave.Martin@arm.com, james.morse@arm.com,
 linux-arm-kernel@lists.infradead.org, tglx@linutronix.de, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: QEMU Developers <qemu-devel@nongnu.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, "Dr. David Alan
 Gilbert" <dgilbert@redhat.com>, Steven Price <steven.price@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-19 18:42, Andrew Jones wrote:
> On Thu, Nov 19, 2020 at 03:45:40PM +0000, Peter Maydell wrote:
>> On Thu, 19 Nov 2020 at 15:39, Steven Price <steven.price@arm.com> 
>> wrote:
>> > This series adds support for Arm's Memory Tagging Extension (MTE) to
>> > KVM, allowing KVM guests to make use of it. This builds on the existing
>> > user space support already in v5.10-rc1, see [1] for an overview.
>> 
>> > The change to require the VMM to map all guest memory PROT_MTE is
>> > significant as it means that the VMM has to deal with the MTE tags even
>> > if it doesn't care about them (e.g. for virtual devices or if the VMM
>> > doesn't support migration). Also unfortunately because the VMM can
>> > change the memory layout at any time the check for PROT_MTE/VM_MTE has
>> > to be done very late (at the point of faulting pages into stage 2).
>> 
>> I'm a bit dubious about requring the VMM to map the guest memory
>> PROT_MTE unless somebody's done at least a sketch of the design
>> for how this would work on the QEMU side. Currently QEMU just
>> assumes the guest memory is guest memory and it can access it
>> without special precautions...
>> 
> 
> There are two statements being made here:
> 
> 1) Requiring the use of PROT_MTE when mapping guest memory may not fit
>    QEMU well.
> 
> 2) New KVM features should be accompanied with supporting QEMU code in
>    order to prove that the APIs make sense.
> 
> I strongly agree with (2). While kvmtool supports some quick testing, 
> it
> doesn't support migration. We must test all new features with a 
> migration
> supporting VMM.
> 
> I'm not sure about (1). I don't feel like it should be a major problem,
> but (2).
> 
> I'd be happy to help with the QEMU prototype, but preferably when 
> there's
> hardware available. Has all the current MTE testing just been done on
> simulators? And, if so, are there regression tests regularly running on
> the simulators too? And can they test migration? If hardware doesn't
> show up quickly and simulators aren't used for regression tests, then
> all this code will start rotting from day one.

While I agree with the sentiment, the reality is pretty bleak.

I'm pretty sure nobody will ever run a migration on emulation. I also 
doubt
there is much overlap between MTE users and migration users, 
unfortunately.

No HW is available today, and when it becomes available, it will be in
the form of a closed system on which QEMU doesn't run, either because
we are locked out of EL2 (as usual), or because migration is not part of
the use case (like KVM on Android, for example).

So we can wait another two (five?) years until general purpose HW 
becomes
available, or we start merging what we can test today. I'm inclined to
do the latter.

And I think it is absolutely fine for QEMU to say "no MTE support with 
KVM"
(we can remove all userspace visibility, except for the capability).

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
