Return-Path: <SRS0=5K0R=HU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60302C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 11:49:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9974264E6F
	for <kvmarm@archiver.kernel.org>; Thu, 18 Feb 2021 11:49:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9974264E6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12A654B3CE;
	Thu, 18 Feb 2021 06:49:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jR-Tp2H25iMW; Thu, 18 Feb 2021 06:49:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B90E84B3C4;
	Thu, 18 Feb 2021 06:49:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33F494B2CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 06:49:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HM+1SGtlZCDZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Feb 2021 06:49:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB61B4B366
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2021 06:49:06 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AD36106F;
 Thu, 18 Feb 2021 03:49:06 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0CD673F73D;
 Thu, 18 Feb 2021 03:49:04 -0800 (PST)
Date: Thu, 18 Feb 2021 11:48:07 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool 06/21] hw/i8042: Refactor trap handler
Message-ID: <20210218114808.5ea4ba60@slackpad.fritz.box>
In-Reply-To: <5d2d7233-46f6-3056-e2b2-813a3fc56d88@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-7-andre.przywara@arm.com>
 <288df0e8-997c-7691-2dda-017876dba3f4@arm.com>
 <20210218103425.26a27000@slackpad.fritz.box>
 <5d2d7233-46f6-3056-e2b2-813a3fc56d88@arm.com>
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

On Thu, 18 Feb 2021 11:17:58 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Hi Andre,
> 
> On 2/18/21 10:34 AM, Andre Przywara wrote:
> > On Thu, 11 Feb 2021 17:23:13 +0000
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >  
> >> Hi Andre,
> >>
> >> On 12/10/20 2:28 PM, Andre Przywara wrote:  
> >>> With the planned retirement of the special ioport emulation code, we
> >>> need to provide an emulation function compatible with the MMIO
> >>> prototype.
> >>>
> >>> Adjust the trap handler to use that new function, and provide shims to
> >>> implement the old ioport interface, for now.
> >>>
> >>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >>> ---
> >>>  hw/i8042.c | 68 +++++++++++++++++++++++++++---------------------------
> >>>  1 file changed, 34 insertions(+), 34 deletions(-)
> >>>
> >>> diff --git a/hw/i8042.c b/hw/i8042.c
> >>> index 36ee183f..eb1f9d28 100644
> >>> --- a/hw/i8042.c
> >>> +++ b/hw/i8042.c
> >>> @@ -292,52 +292,52 @@ static void kbd_reset(void)
> >>>  	};
> >>>  }
> >>>  
> >>> -/*
> >>> - * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
> >>> - */
> >>> -static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> >>> +static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> >>> +		   u8 is_write, void *ptr)
> >>>  {
> >>> -	switch (port) {
> >>> -	case I8042_COMMAND_REG: {
> >>> -		u8 value = kbd_read_status();
> >>> -		ioport__write8(data, value);
> >>> +	u8 value;
> >>> +
> >>> +	if (is_write)
> >>> +		value = ioport__read8(data);
> >>> +
> >>> +	switch (addr) {
> >>> +	case I8042_COMMAND_REG:
> >>> +		if (is_write)
> >>> +			kbd_write_command(vcpu->kvm, value);
> >>> +		else
> >>> +			value = kbd_read_status();
> >>>  		break;
> >>> -	}
> >>> -	case I8042_DATA_REG: {
> >>> -		u8 value = kbd_read_data();
> >>> -		ioport__write8(data, value);
> >>> +	case I8042_DATA_REG:
> >>> +		if (is_write)
> >>> +			kbd_write_data(value);
> >>> +		else
> >>> +			value = kbd_read_data();
> >>>  		break;
> >>> -	}
> >>> -	case I8042_PORT_B_REG: {
> >>> -		ioport__write8(data, 0x20);
> >>> +	case I8042_PORT_B_REG:
> >>> +		if (!is_write)
> >>> +			value = 0x20;
> >>>  		break;
> >>> -	}
> >>>  	default:
> >>> -		return false;
> >>> +		return;    
> >> Any particular reason for removing the false return value? I don't see it
> >> mentioned in the commit message. Otherwise this is identical to the two functions
> >> it replaces.  
> > Because the MMIO handler prototype is void, in contrast to the PIO one.
> > Since on returning "false" we only seem to panic kvmtool, this is of
> > quite limited use, I'd say.  
> 
> Actually, in ioport.c::kvm__emulate_io(), if kvm->cfg.ioport_debug is true, it
> will print an error and then panic in kvm_cpu__start(); otherwise the error is
> silently ignored. serial.c is another device where an unknown register returns
> false. In rtc.c, the unknown register is ignored. cfi_flash.c prints debugging
> information. So I guess kvmtool implements all possible methods of handling an
> unknown register *at the same time*, so it's up to you how you want to handle it.

Well, the MMIO prototype we are going to use is void anyway, so it's
just one patch earlier that we get this new behaviour.
For handling MMIO errors:
- Hardware MMIO doesn't have a back channel: if the MMIO write triggers
  some error condition, the device would need to deal with it (setting
  internal error state, ignore, etc.). On some systems the device could
  throw some kind of bus error or SError, but this is a rather drastic
  measure, and is certainly not exercised by those ancient devices.
- Any kind of error reporting which can be triggered by a guest is
  frowned upon: it could spam the console or some log file, and so
  impact host operation. At the end an administrator can't do much about
  it, anyway.
- Which leaves the only use to some kvmtool developer debugging some
  device emulation or investigating weird guest behaviour. And in this
  case we can more easily have a debug message *inside* the device
  emulation code, can't we?

And since the MMIO handler prototype is void, we have no choice anyway,
at least not without another huge (and pointless) series to change
those user as well ;-)

Cheers,
Andre

> >>>  	}
> >>>  
> >>> +	if (!is_write)
> >>> +		ioport__write8(data, value);
> >>> +}
> >>> +
> >>> +/*
> >>> + * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
> >>> + */
> >>> +static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> >>> +{
> >>> +	kbd_io(vcpu, port, data, size, false, NULL);    
> >> is_write is an u8, not a bool.  
> > Right, will fix this.
> >  
> >> I never could wrap my head around the ioport convention of "in" (read) and "out"
> >> (write). To be honest, changing is_write changed to an enum so it's crystal clear
> >> what is happening would help with that a lot, but I guess that's a separate patch.  
> > "in" and "out" are the x86 assembly mnemonics, but it's indeed
> > confusing, because the device side has a different view (CPU "in" means
> > pushing data "out" of the device). I usually look at the code to see
> > what it's actually meant to do.
> > So yeah, I feel like a lot of those device emulations could use
> > some update. but that's indeed something for another day.  
> 
> Agreed.
> 
> Thanks,
> 
> Alex
> 
> >
> > Cheers,
> > Andre
> >  
> >>> +
> >>>  	return true;
> >>>  }
> >>>  
> >>>  static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> >>>  {
> >>> -	switch (port) {
> >>> -	case I8042_COMMAND_REG: {
> >>> -		u8 value = ioport__read8(data);
> >>> -		kbd_write_command(vcpu->kvm, value);
> >>> -		break;
> >>> -	}
> >>> -	case I8042_DATA_REG: {
> >>> -		u8 value = ioport__read8(data);
> >>> -		kbd_write_data(value);
> >>> -		break;
> >>> -	}
> >>> -	case I8042_PORT_B_REG: {
> >>> -		break;
> >>> -	}
> >>> -	default:
> >>> -		return false;
> >>> -	}
> >>> +	kbd_io(vcpu, port, data, size, true, NULL);
> >>>  
> >>>  	return true;
> >>>  }    

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
