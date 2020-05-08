Return-Path: <SRS0=TDzU=6W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE20C38A2A
	for <kvmarm@archiver.kernel.org>; Fri,  8 May 2020 12:21:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40AB521582
	for <kvmarm@archiver.kernel.org>; Fri,  8 May 2020 12:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0iY3OCVh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40AB521582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF3F24B1C6;
	Fri,  8 May 2020 08:21:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dya2rqhuRvTG; Fri,  8 May 2020 08:20:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4E564B1B4;
	Fri,  8 May 2020 08:20:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A1964B1B0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2020 08:20:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w7ITZTlp5Ljc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 May 2020 08:20:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0678A4B18A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2020 08:20:55 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B22E2208D6;
 Fri,  8 May 2020 12:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588940454;
 bh=FW6rwatJpH3f9YqjBLgABYd8viojkg66m20HhLLxy+E=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=0iY3OCVhd9Xw00lEJKywiWeb5005YOoZLT2lUuSCBbm+9lHODalCeg/IODZ/a1+Mg
 VdZDi9cpYRFrP/8f2kldeQ6u6d5yguyICPpLXjUIH233W2dhLuEgJBMpgw4AB0G00e
 yYfq36Pcx5b+5NY7lMFIe1HBLT+u7dtIXRMCKMDA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jX1zp-00Aacj-2D; Fri, 08 May 2020 13:20:53 +0100
Date: Fri, 8 May 2020 13:20:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 09/26] KVM: arm64: vgic-v3: Take cpu_if pointer directly
 instead of vcpu
Message-ID: <20200508132051.490943f8@why>
In-Reply-To: <3174eaad-7d8d-0c52-d71c-afc6b991b636@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-10-maz@kernel.org>
 <3174eaad-7d8d-0c52-d71c-afc6b991b636@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com,
 jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com,
 prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 linux-arm-kernel@lists.infradead.org
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

On Thu, 7 May 2020 17:26:06 +0100
James Morse <james.morse@arm.com> wrote:

Hi James,

> Hi Marc, Christoffer,
> 
> On 22/04/2020 13:00, Marc Zyngier wrote:
> > From: Christoffer Dall <christoffer.dall@arm.com>
> > 
> > If we move the used_lrs field to the version-specific cpu interface
> > structure, the following functions only operate on the struct
> > vgic_v3_cpu_if and not the full vcpu:
> > 
> >   __vgic_v3_save_state
> >   __vgic_v3_restore_state
> >   __vgic_v3_activate_traps
> >   __vgic_v3_deactivate_traps
> >   __vgic_v3_save_aprs
> >   __vgic_v3_restore_aprs
> > 
> > This is going to be very useful for nested virt,   
> 
> ... because you don't need to consider whether the vcpu is running in vEL2?

That's one of the reasons, as vEL2 is still EL1.

But things become really fun when you run a L2 guest, which is an EL1
guest from the PoV of the guest hypervisor (aka L1). At this stage
what you feed to the HW is not the state that could be populated by L0
for L1, but instead what L1 has created for L2 (with a bit of
additional repainting to adjust some of the interrupt numbers).

So we build a shadow cpu_if on the fly and pass it to the normal vgic
handling functions. I told you it was fun! ;-)

> > so move the used_lrs
> > field and change the prototypes and implementations of these functions to
> > take the cpu_if parameter directly.  
> 
> 
> > No functional change.  
> 
> Looks like no change!
> 
> Reviewed-by: James Morse <james.morse@arm.com>

Thanks!

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
