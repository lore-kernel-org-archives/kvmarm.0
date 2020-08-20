Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F21C433E3
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 09:43:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4382A2173E
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 09:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxUe/5zO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4382A2173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B0264B83C;
	Thu, 20 Aug 2020 05:43:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id weP1KmYHgjZs; Thu, 20 Aug 2020 05:43:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0B84B83F;
	Thu, 20 Aug 2020 05:43:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E6BB4B83C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 05:43:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oufOjX3Lf9Dk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 05:43:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C0C74B839
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 05:43:22 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C285F20724;
 Thu, 20 Aug 2020 09:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1597916602;
 bh=CnunxCsOvBU/gUFXe+EXz0IAGG4b1qj7pIVDUrpfZWg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=LxUe/5zOhpUu0yX3QPQi/2NIS3QBRStNZyzIAXegfpS5FX55TPD3T3rBBxX49W404
 pxpLHhvfzBFfEL+qweR6QBJe8n8M0SifTa+Y0PGkqpTqM1J2zqQNThqD9utBYHkaWm
 UJ3W7NW4FCAaIbpLQhWuXnyKqLZ+xGPa//aVByaE=
Date: Thu, 20 Aug 2020 10:43:15 +0100
From: Will Deacon <will@kernel.org>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via
 SMCCC
Message-ID: <20200820094314.GA18838@willie-the-truck>
References: <20200619130120.40556-1-jianyong.wu@arm.com>
 <20200619130120.40556-3-jianyong.wu@arm.com>
 <HE1PR0802MB255577943C260898A6C686ABF4720@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <20200727113821.GB20437@willie-the-truck>
 <HE1PR0802MB25551F426910F76E95523383F4730@HE1PR0802MB2555.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <HE1PR0802MB25551F426910F76E95523383F4730@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "maz@kernel.org" <maz@kernel.org>, Justin He <Justin.He@arm.com>,
 Wei Chen <Wei.Chen@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Steven Price <Steven.Price@arm.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, nd <nd@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Tue, Jul 28, 2020 at 01:07:14AM +0000, Jianyong Wu wrote:
> 
> 
> > -----Original Message-----
> > From: Will Deacon <will@kernel.org>
> > Sent: Monday, July 27, 2020 7:38 PM
> > To: Jianyong Wu <Jianyong.Wu@arm.com>
> > Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> > tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> > maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> > <Mark.Rutland@arm.com>; Suzuki Poulose <Suzuki.Poulose@arm.com>;
> > Steven Price <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-
> > arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> > kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> > <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; Wei Chen
> > <Wei.Chen@arm.com>; nd <nd@arm.com>
> > Subject: Re: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests
> > via SMCCC
> > 
> > On Mon, Jul 27, 2020 at 03:45:37AM +0000, Jianyong Wu wrote:
> > > > From: Will Deacon <will@kernel.org>
> > > >
> > > > We can advertise ourselves to guests as KVM and provide a basic
> > > > features bitmap for discoverability of future hypervisor services.
> > > >
> > > > Cc: Marc Zyngier <maz@kernel.org>
> > > > Signed-off-by: Will Deacon <will@kernel.org>
> > > > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > > > ---
> > > >  arch/arm64/kvm/hypercalls.c | 29 +++++++++++++++++++----------
> > > >  1 file changed, 19 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/hypercalls.c
> > > > b/arch/arm64/kvm/hypercalls.c index 550dfa3e53cd..db6dce3d0e23
> > > > 100644
> > > > --- a/arch/arm64/kvm/hypercalls.c
> > > > +++ b/arch/arm64/kvm/hypercalls.c
> > > > @@ -12,13 +12,13 @@
> > > >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
> > > >  	u32 func_id = smccc_get_function(vcpu);
> > > > -	long val = SMCCC_RET_NOT_SUPPORTED;
> > > > +	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
> > >
> > > There is a risk as this u32 value will return here and a u64 value
> > > will be obtained in guest. For example, The val[0] is initialized as
> > > -1 of 0xffffffff and the guest get 0xffffffff then it will be compared
> > > with -1 of 0xffffffffffffffff Also this problem exists for the
> > > transfer of address in u64 type. So the following assignment to "val"
> > > should be split into two
> > > u32 value and assign to val[0] and val[1] respectively.
> > > WDYT?
> > 
> > Yes, I think you're right that this is a bug, but isn't the solution just to make
> > that an array of 'long'?
> > 
> > 	long val [4];
> > 
> > That will sign-extend the negative error codes as required, while leaving the
> > explicitly unsigned UID constants alone.
> 
> Ok, that's much better. I will fix it at next version.
> 
> By the way, I wonder when will you update this patch set. I see someone like me
> adopt this patch set as code base and need rebase it every time, so expect your update.

I'm not working on it, so please feel free to include it along with the
patches that add an upstream user.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
