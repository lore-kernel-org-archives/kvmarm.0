Return-Path: <SRS0=5K0R=HU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A4AC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 14:06:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A81860C41
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 14:06:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A81860C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D4FC4B29B;
	Thu, 18 Feb 2021 09:06:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jYaNq+ZEulvD; Thu, 18 Feb 2021 09:06:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EC744B2DC;
	Thu, 18 Feb 2021 09:06:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 007BE4B299
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 09:06:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cl62F6y2WmOO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Feb 2021 09:06:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ABD14B268
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 09:06:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BD3FED1;
 Thu, 18 Feb 2021 06:06:28 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E17B53F73B;
 Thu, 18 Feb 2021 06:06:26 -0800 (PST)
Date: Thu, 18 Feb 2021 14:05:29 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool 09/21] x86/ioport: Switch to new trap handlers
Message-ID: <20210218140529.1d23c397@slackpad.fritz.box>
In-Reply-To: <b5eb332b-392e-3b4f-8797-9b7a1e4b5e56@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-10-andre.przywara@arm.com>
 <b5eb332b-392e-3b4f-8797-9b7a1e4b5e56@arm.com>
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

On Fri, 12 Feb 2021 11:27:59 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi Alex,

> On 12/10/20 2:28 PM, Andre Przywara wrote:
> > Now that the x86 I/O ports have trap handlers adhering to the MMIO fault
> > handler prototype, let's switch over to the joint registration routine.
> >
> > This allows us to get rid of the ioport shim routines.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  x86/ioport.c | 113 ++++++++++++++-------------------------------------
> >  1 file changed, 30 insertions(+), 83 deletions(-)
> >
> > diff --git a/x86/ioport.c b/x86/ioport.c
> > index 932da20a..87955da1 100644
> > --- a/x86/ioport.c
> > +++ b/x86/ioport.c
> > @@ -8,16 +8,6 @@ static void dummy_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> >  {
> >  }
> >  
> > -static bool debug_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> > -{
> > -	dummy_mmio(vcpu, port, data, size, true, NULL);
> > -	return 0;
> > -}  
> 
> 0 is false in boolean logic, which means that emulation fails according to the
> (old) ioport emulation code (ioport.c::kvm__emulate_io()).
> 
> So I guess I have a few questions:
> 
> - Is this a bug in the emulation code, where the author thought that
> debug_io_out() returns an int, and in that case 0 actually means success?

Wading through the swamp of the git history it looks like failure is
intentional, it should be used together with --debug-ioport, to trigger
that print there.
 
> - If writing to the debug port is rightfully considered an error, do we care
> enough about it to print something to stdout like kvm__emulate_io() does when
> debug_io_out() returns false?

I think you are right, we should print something here.

Cheers,
Andre

> > -
> > -static struct ioport_operations debug_ops = {
> > -	.io_out		= debug_io_out,
> > -};
> > -
> >  static void seabios_debug_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> >  			       u32 len, u8 is_write, void *ptr)
> >  {
> > @@ -31,37 +21,6 @@ static void seabios_debug_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> >  	putchar(ch);
> >  }
> >  
> > -static bool seabios_debug_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> > -{
> > -	seabios_debug_mmio(vcpu, port, data, size, true, NULL);
> > -	return 0;
> > -}
> > -
> > -static struct ioport_operations seabios_debug_ops = {
> > -	.io_out		= seabios_debug_io_out,
> > -};
> > -
> > -static bool dummy_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> > -{
> > -	dummy_mmio(vcpu, port, data, size, false, NULL);
> > -	return true;
> > -}
> > -
> > -static bool dummy_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> > -{
> > -	dummy_mmio(vcpu, port, data, size, true, NULL);
> > -	return true;
> > -}
> > -
> > -static struct ioport_operations dummy_read_write_ioport_ops = {
> > -	.io_in		= dummy_io_in,
> > -	.io_out		= dummy_io_out,
> > -};
> > -
> > -static struct ioport_operations dummy_write_only_ioport_ops = {
> > -	.io_out		= dummy_io_out,
> > -};
> > -
> >  /*
> >   * The "fast A20 gate"
> >   */
> > @@ -76,17 +35,6 @@ static void ps2_control_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> >  		ioport__write8(data, 0x02);
> >  }
> >  
> > -static bool ps2_control_a_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> > -{
> > -	ps2_control_mmio(vcpu, port, data, size, false, NULL);
> > -	return true;
> > -}
> > -
> > -static struct ioport_operations ps2_control_a_ops = {
> > -	.io_in		= ps2_control_a_io_in,
> > -	.io_out		= dummy_io_out,
> > -};
> > -
> >  void ioport__map_irq(u8 *irq)
> >  {
> >  }
> > @@ -98,75 +46,75 @@ static int ioport__setup_arch(struct kvm *kvm)
> >  	/* Legacy ioport setup */
> >  
> >  	/* 0000 - 001F - DMA1 controller */
> > -	r = ioport__register(kvm, 0x0000, &dummy_read_write_ioport_ops, 32, NULL);
> > +	r = kvm__register_pio(kvm, 0x0000, 32, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* 0x0020 - 0x003F - 8259A PIC 1 */
> > -	r = ioport__register(kvm, 0x0020, &dummy_read_write_ioport_ops, 2, NULL);
> > +	r = kvm__register_pio(kvm, 0x0020, 2, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* PORT 0040-005F - PIT - PROGRAMMABLE INTERVAL TIMER (8253, 8254) */
> > -	r = ioport__register(kvm, 0x0040, &dummy_read_write_ioport_ops, 4, NULL);
> > +	r = kvm__register_pio(kvm, 0x0040, 4, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* 0092 - PS/2 system control port A */
> > -	r = ioport__register(kvm, 0x0092, &ps2_control_a_ops, 1, NULL);
> > +	r = kvm__register_pio(kvm, 0x0092, 1, ps2_control_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* 0x00A0 - 0x00AF - 8259A PIC 2 */
> > -	r = ioport__register(kvm, 0x00A0, &dummy_read_write_ioport_ops, 2, NULL);
> > +	r = kvm__register_pio(kvm, 0x00A0, 2, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* 00C0 - 001F - DMA2 controller */
> > -	r = ioport__register(kvm, 0x00C0, &dummy_read_write_ioport_ops, 32, NULL);
> > +	r = kvm__register_pio(kvm, 0x00c0, 32, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* PORT 00E0-00EF are 'motherboard specific' so we use them for our
> >  	   internal debugging purposes.  */
> > -	r = ioport__register(kvm, IOPORT_DBG, &debug_ops, 1, NULL);
> > +	r = kvm__register_pio(kvm, IOPORT_DBG, 1, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* PORT 00ED - DUMMY PORT FOR DELAY??? */
> > -	r = ioport__register(kvm, 0x00ED, &dummy_write_only_ioport_ops, 1, NULL);
> > +	r = kvm__register_pio(kvm, 0x00ed, 1, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* 0x00F0 - 0x00FF - Math co-processor */
> > -	r = ioport__register(kvm, 0x00F0, &dummy_write_only_ioport_ops, 2, NULL);
> > +	r = kvm__register_pio(kvm, 0x00f0, 2, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* PORT 0278-027A - PARALLEL PRINTER PORT (usually LPT1, sometimes LPT2) */
> > -	r = ioport__register(kvm, 0x0278, &dummy_read_write_ioport_ops, 3, NULL);
> > +	r = kvm__register_pio(kvm, 0x0278, 3, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* PORT 0378-037A - PARALLEL PRINTER PORT (usually LPT2, sometimes LPT3) */
> > -	r = ioport__register(kvm, 0x0378, &dummy_read_write_ioport_ops, 3, NULL);
> > +	r = kvm__register_pio(kvm, 0x0378, 3, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* PORT 03D4-03D5 - COLOR VIDEO - CRT CONTROL REGISTERS */
> > -	r = ioport__register(kvm, 0x03D4, &dummy_read_write_ioport_ops, 1, NULL);
> > +	r = kvm__register_pio(kvm, 0x03d4, 1, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> > -	r = ioport__register(kvm, 0x03D5, &dummy_write_only_ioport_ops, 1, NULL);
> > +	r = kvm__register_pio(kvm, 0x03d5, 1, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> > -	r = ioport__register(kvm, 0x402, &seabios_debug_ops, 1, NULL);
> > +	r = kvm__register_pio(kvm, 0x0402, 1, seabios_debug_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> >  	/* 0510 - QEMU BIOS configuration register */
> > -	r = ioport__register(kvm, 0x510, &dummy_read_write_ioport_ops, 2, NULL);
> > +	r = kvm__register_pio(kvm, 0x0510, 2, dummy_mmio, NULL);
> >  	if (r < 0)
> >  		return r;
> >  
> > @@ -176,22 +124,21 @@ dev_base_init(ioport__setup_arch);
> >  
> >  static int ioport__remove_arch(struct kvm *kvm)
> >  {
> > -	ioport__unregister(kvm, 0x510);
> > -	ioport__unregister(kvm, 0x402);
> > -	ioport__unregister(kvm, 0x03D5);
> > -	ioport__unregister(kvm, 0x03D4);
> > -	ioport__unregister(kvm, 0x0378);
> > -	ioport__unregister(kvm, 0x0278);
> > -	ioport__unregister(kvm, 0x00F0);
> > -	ioport__unregister(kvm, 0x00ED);
> > -	ioport__unregister(kvm, IOPORT_DBG);
> > -	ioport__unregister(kvm, 0x00C0);
> > -	ioport__unregister(kvm, 0x00A0);
> > -	ioport__unregister(kvm, 0x0092);
> > -	ioport__unregister(kvm, 0x0040);
> > -	ioport__unregister(kvm, 0x0020);
> > -	ioport__unregister(kvm, 0x0000);
> > -
> > +	kvm__deregister_pio(kvm, 0x510);
> > +	kvm__deregister_pio(kvm, 0x402);
> > +	kvm__deregister_pio(kvm, 0x3d5);
> > +	kvm__deregister_pio(kvm, 0x3d4);
> > +	kvm__deregister_pio(kvm, 0x378);
> > +	kvm__deregister_pio(kvm, 0x278);
> > +	kvm__deregister_pio(kvm, 0x0f0);
> > +	kvm__deregister_pio(kvm, 0x0ed);
> > +	kvm__deregister_pio(kvm, IOPORT_DBG);
> > +	kvm__deregister_pio(kvm, 0x0c0);
> > +	kvm__deregister_pio(kvm, 0x0a0);
> > +	kvm__deregister_pio(kvm, 0x092);
> > +	kvm__deregister_pio(kvm, 0x040);
> > +	kvm__deregister_pio(kvm, 0x020);
> > +	kvm__deregister_pio(kvm, 0x000);
> >  	return 0;
> >  }
> >  dev_base_exit(ioport__remove_arch);  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
