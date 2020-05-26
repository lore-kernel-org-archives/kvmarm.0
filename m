Return-Path: <SRS0=x9SY=7I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E236DC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 10:10:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 64A5E2073B
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 10:10:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64A5E2073B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C99C24B1F3;
	Tue, 26 May 2020 06:10:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EKoYLzk-xPIF; Tue, 26 May 2020 06:10:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 846E54B278;
	Tue, 26 May 2020 06:10:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 291994B278
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 06:10:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RU2pDemqPe4M for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2020 06:10:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3300A4B1F3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 06:10:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F6941FB;
 Tue, 26 May 2020 03:10:26 -0700 (PDT)
Received: from bogus (unknown [10.37.8.209])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56E413F52E;
 Tue, 26 May 2020 03:10:22 -0700 (PDT)
Date: Tue, 26 May 2020 11:10:19 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
Message-ID: <20200526101019.GB11414@bogus>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-4-jianyong.wu@arm.com>
 <20200522131206.GA15171@bogus>
 <HE1PR0802MB255537CD21C5E7F7F4A899A2F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <HE1PR0802MB255537CD21C5E7F7F4A899A2F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Justin He <Justin.He@arm.com>, Wei Chen <Wei.Chen@arm.com>,
 "maz@kernel.org" <maz@kernel.org>, Steven Price <Steven.Price@arm.com>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>, nd <nd@arm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Sudeep Holla <sudeep.holla@arm.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
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

On Mon, May 25, 2020 at 01:37:56AM +0000, Jianyong Wu wrote:
> Hi Sudeep,
> 
> > -----Original Message-----
> > From: Sudeep Holla <sudeep.holla@arm.com>
> > Sent: Friday, May 22, 2020 9:12 PM
> > To: Jianyong Wu <Jianyong.Wu@arm.com>
> > Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> > tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> > maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> > <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> > <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>; Justin
> > He <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>;
> > kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; linux-
> > kernel@vger.kernel.org; Kaly Xin <Kaly.Xin@arm.com>; nd <nd@arm.com>;
> > Sudeep Holla <Sudeep.Holla@arm.com>; kvmarm@lists.cs.columbia.edu;
> > linux-arm-kernel@lists.infradead.org
> > Subject: Re: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
> > 
> > On Fri, May 22, 2020 at 04:37:16PM +0800, Jianyong Wu wrote:
> > > Export arm_smccc_1_1_get_conduit then modules can use smccc helper
> > > which adopts it.
> > >
> > > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > > ---
> > >  drivers/firmware/psci/psci.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/firmware/psci/psci.c
> > > b/drivers/firmware/psci/psci.c index 2937d44b5df4..fd3c88f21b6a 100644
> > > --- a/drivers/firmware/psci/psci.c
> > > +++ b/drivers/firmware/psci/psci.c
> > > @@ -64,6 +64,7 @@ enum arm_smccc_conduit
> > > arm_smccc_1_1_get_conduit(void)
> > >
> > >  	return psci_ops.conduit;
> > >  }
> > > +EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
> > >
> > 
> > I have moved this into drivers/firmware/smccc/smccc.c [1] Please update
> > this accordingly.
> 
> Ok, I will remove this patch next version.

You may need it still, just that this patch won't apply as the function
is moved to a new file.

-- 
Regards,
Sudeep
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
