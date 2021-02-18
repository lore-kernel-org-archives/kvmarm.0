Return-Path: <SRS0=5K0R=HU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A30BC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 12:10:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9371F64E6F
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 12:10:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9371F64E6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA3E44B397;
	Thu, 18 Feb 2021 07:10:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qbq3Ev6DaRKT; Thu, 18 Feb 2021 07:10:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82494B3AD;
	Thu, 18 Feb 2021 07:10:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8988B4B326
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 07:10:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vOgzwQdcZhr9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Feb 2021 07:10:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F21B4B2F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 07:10:05 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 030481FB;
 Thu, 18 Feb 2021 04:10:05 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF9863F73D;
 Thu, 18 Feb 2021 04:10:03 -0800 (PST)
Date: Thu, 18 Feb 2021 12:09:02 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool 07/21] hw/i8042: Switch to new trap handlers
Message-ID: <20210218120902.630dcb2b@slackpad.fritz.box>
In-Reply-To: <a995ed28-27c0-888c-c3d4-ecb70c08a13e@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-8-andre.przywara@arm.com>
 <a995ed28-27c0-888c-c3d4-ecb70c08a13e@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, 12 Feb 2021 10:41:20 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> On 12/10/20 2:28 PM, Andre Przywara wrote:
> > Now that the PC keyboard has a trap handler adhering to the MMIO fault
> > handler prototype, let's switch over to the joint registration routine.
> >
> > This allows us to get rid of the ioport shim routines.
> >
> > Make the kbd_init() function static on the way.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  hw/i8042.c          | 30 ++++--------------------------
> >  include/kvm/i8042.h |  1 -
> >  2 files changed, 4 insertions(+), 27 deletions(-)
> >
> > diff --git a/hw/i8042.c b/hw/i8042.c
> > index eb1f9d28..91d79dc4 100644
> > --- a/hw/i8042.c
> > +++ b/hw/i8042.c
> > @@ -325,40 +325,18 @@ static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> >  		ioport__write8(data, value);
> >  }
> >  
> > -/*
> > - * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
> > - */
> > -static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> > -{
> > -	kbd_io(vcpu, port, data, size, false, NULL);
> > -
> > -	return true;
> > -}
> > -
> > -static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> > -{
> > -	kbd_io(vcpu, port, data, size, true, NULL);
> > -
> > -	return true;
> > -}
> > -
> > -static struct ioport_operations kbd_ops = {
> > -	.io_in		= kbd_in,
> > -	.io_out		= kbd_out,
> > -};
> > -
> > -int kbd__init(struct kvm *kvm)
> > +static int kbd__init(struct kvm *kvm)
> >  {
> >  	int r;
> >  
> >  	kbd_reset();
> >  	state.kvm = kvm;
> > -	r = ioport__register(kvm, I8042_DATA_REG, &kbd_ops, 2, NULL);
> > +	r = kvm__register_pio(kvm, I8042_DATA_REG, 2, kbd_io, NULL);  
> 
> I guess you are registering two addresses here to cover I8042_PORT_B_REG, right?
> Might be worth a comment.

I am registering two ports because the original code did, and I didn't
dare to touch this. I guess we put this on the wishlist for the device
emulation fixup series? ;-)

Maybe the intention was to just *reserve* those ports?

> 
> >  	if (r < 0)
> >  		return r;
> > -	r = ioport__register(kvm, I8042_COMMAND_REG, &kbd_ops, 2, NULL);
> > +	r = kvm__register_pio(kvm, I8042_COMMAND_REG, 2, kbd_io, NULL);  
> 
> Shouldn't length be 1? The emulation should work only for address 0x64
> (command/status register), right? Or am I missing something?

I don't think you are, same as above. Maybe some weird guest is using
half-word accesses (outw)?

Cheers,
Andre


> 
> Thanks,
> 
> Alex
> 
> >  	if (r < 0) {
> > -		ioport__unregister(kvm, I8042_DATA_REG);
> > +		kvm__deregister_pio(kvm, I8042_DATA_REG);
> >  		return r;
> >  	}
> >  
> > diff --git a/include/kvm/i8042.h b/include/kvm/i8042.h
> > index 3b4ab688..cd4ae6bb 100644
> > --- a/include/kvm/i8042.h
> > +++ b/include/kvm/i8042.h
> > @@ -7,6 +7,5 @@ struct kvm;
> >  
> >  void mouse_queue(u8 c);
> >  void kbd_queue(u8 c);
> > -int kbd__init(struct kvm *kvm);
> >  
> >  #endif  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
