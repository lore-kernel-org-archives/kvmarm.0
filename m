Return-Path: <SRS0=BQox=HT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35552C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 17 Feb 2021 17:47:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93C3764E4A
	for <kvmarm@archiver.kernel.org>; Wed, 17 Feb 2021 17:47:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93C3764E4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22EF74B4C1;
	Wed, 17 Feb 2021 12:47:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DrZqVnxx46EW; Wed, 17 Feb 2021 12:47:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD7CD4B393;
	Wed, 17 Feb 2021 12:47:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6148A4B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 12:47:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ORGm7R4aPAXF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2021 12:47:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0A664B2B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2021 12:47:45 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 664391FB;
 Wed, 17 Feb 2021 09:47:45 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29C803F73D;
 Wed, 17 Feb 2021 09:47:44 -0800 (PST)
Date: Wed, 17 Feb 2021 17:46:32 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool 05/21] hw/i8042: Clean up data types
Message-ID: <20210217174632.660934f7@slackpad.fritz.box>
In-Reply-To: <04b5f537-1594-61b9-b7ef-4062e732e380@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-6-andre.przywara@arm.com>
 <04b5f537-1594-61b9-b7ef-4062e732e380@arm.com>
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

On Thu, 11 Feb 2021 16:55:43 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> On 12/10/20 2:28 PM, Andre Przywara wrote:
> 
> > The i8042 is clearly an 8-bit era device, so there is little room for
> > 32-bit registers.
> > Clean up the data types used.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  hw/i8042.c | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/hw/i8042.c b/hw/i8042.c
> > index 37a99a2d..36ee183f 100644
> > --- a/hw/i8042.c
> > +++ b/hw/i8042.c
> > @@ -64,11 +64,11 @@
> >  struct kbd_state {
> >  	struct kvm		*kvm;
> >  
> > -	char			kq[QUEUE_SIZE];	/* Keyboard queue */
> > +	u8			kq[QUEUE_SIZE];	/* Keyboard queue */
> >  	int			kread, kwrite;	/* Indexes into the queue */
> >  	int			kcount;		/* number of elements in queue */
> >  
> > -	char			mq[QUEUE_SIZE];
> > +	u8			mq[QUEUE_SIZE];
> >  	int			mread, mwrite;
> >  	int			mcount;  
> 
> I think the write_cmd field further down should also be u8 because it stores the
> first byte of a command (and it's set only to an 8 bit value in kbd_write_command()).

Yes, looks like it, will change it on the way. I guess I wanted to
suppress my rewrite-everything complex ;-)

If you allow, I will also fix the confusing indentation bug in the big
switch statement on the way.
 
> Otherwise, it looks ok to me. osdev wiki seems to confirm that the device is
> indeed 8 bit only, and all the registers are 8 bit now:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!
Andre

> 
> >  
> > @@ -173,9 +173,9 @@ static void kbd_write_command(struct kvm *kvm, u8 val)
> >  /*
> >   * Called when the OS reads from port 0x60 (PS/2 data)
> >   */
> > -static u32 kbd_read_data(void)
> > +static u8 kbd_read_data(void)
> >  {
> > -	u32 ret;
> > +	u8 ret;
> >  	int i;
> >  
> >  	if (state.kcount != 0) {
> > @@ -202,9 +202,9 @@ static u32 kbd_read_data(void)
> >  /*
> >   * Called when the OS read from port 0x64, the command port
> >   */
> > -static u32 kbd_read_status(void)
> > +static u8 kbd_read_status(void)
> >  {
> > -	return (u32)state.status;
> > +	return state.status;
> >  }
> >  
> >  /*
> > @@ -212,7 +212,7 @@ static u32 kbd_read_status(void)
> >   * Things written here are generally arguments to commands previously
> >   * written to port 0x64 and stored in state.write_cmd
> >   */
> > -static void kbd_write_data(u32 val)
> > +static void kbd_write_data(u8 val)
> >  {
> >  	switch (state.write_cmd) {
> >  	case I8042_CMD_CTL_WCTR:
> > @@ -304,8 +304,8 @@ static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *
> >  		break;
> >  	}
> >  	case I8042_DATA_REG: {
> > -		u32 value = kbd_read_data();
> > -		ioport__write32(data, value);
> > +		u8 value = kbd_read_data();
> > +		ioport__write8(data, value);
> >  		break;
> >  	}
> >  	case I8042_PORT_B_REG: {
> > @@ -328,7 +328,7 @@ static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void
> >  		break;
> >  	}
> >  	case I8042_DATA_REG: {
> > -		u32 value = ioport__read32(data);
> > +		u8 value = ioport__read8(data);
> >  		kbd_write_data(value);
> >  		break;
> >  	}  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
