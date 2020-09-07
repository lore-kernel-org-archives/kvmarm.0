Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70AA8C43461
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 09:47:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF0AF20C09
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 09:47:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="19AbdD+E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF0AF20C09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33C364B5CE;
	Mon,  7 Sep 2020 05:47:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9P0+R5ZIlnI7; Mon,  7 Sep 2020 05:47:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E6164B5CF;
	Mon,  7 Sep 2020 05:47:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 725E34B5CD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 05:47:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P3fRrM6BpoLd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 05:47:04 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 664204B5C9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 05:47:04 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 49EFA2078E;
 Mon,  7 Sep 2020 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599472023;
 bh=cFHskjvmHO3vzxD+eGBoRNZ+sFpiHGFme6jLOuWP8Uc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=19AbdD+EC1bO4XviCsVbOEsgKBlvuTcIcRwYpDXdAbiyDIC2ngljNeSByIj6g2WwR
 pwHlJAa2zca7ViqS+HXJHlbRqiyn/WpxFytm5SMsvxtaqOBqDi0a5jaudF1eVdGURu
 jTZbUs3gK3gLc/gZXJVqSV1JOAEE6FHqZ7nCuP54=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kFDjp-009iuT-BE; Mon, 07 Sep 2020 10:47:01 +0100
MIME-Version: 1.0
Date: Mon, 07 Sep 2020 10:47:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
In-Reply-To: <HE1PR0802MB25551446DC85DB3684D09211F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
 <20200904092744.167655-9-jianyong.wu@arm.com> <874kocmqqx.wl-maz@kernel.org>
 <HE1PR0802MB2555CC56351616836A95FB19F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <366387fa507f9c5d5044549cea958ce1@kernel.org>
 <HE1PR0802MB25551446DC85DB3684D09211F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <67f3381467d02c8d3f25682cd99898e9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, netdev@vger.kernel.org,
 yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
 pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com,
 Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com,
 Steven.Price@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Steve.Capper@arm.com, Justin.He@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Justin He <Justin.He@arm.com>, kvm@vger.kernel.org, netdev@vger.kernel.org,
 richardcochran@gmail.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, Steven Price <Steven.Price@arm.com>,
 john.stultz@linaro.org, yangbo.lu@nxp.com, pbonzini@redhat.com,
 tglx@linutronix.de, nd <nd@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-09-07 10:28, Jianyong Wu wrote:
>> -----Original Message-----
>> From: Marc Zyngier <maz@kernel.org>
>> Sent: Monday, September 7, 2020 4:55 PM
>> To: Jianyong Wu <Jianyong.Wu@arm.com>

[...]

>> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATUR
>> >> ES_FUNC_ID,
>> >> > +			     &hvc_res);
>> >> > +	if (!(hvc_res.a0 | BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
>> >> > +		return -EOPNOTSUPP;
>> >> > +
>> >> > +	return 0;
>> >>
>> >> What happens if the
>> >> ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID function isn't
>> implemented
>> >> (on an old kernel or a non-KVM hypervisor)? The expected behaviour is
>> >> that a0 will contain SMCCC_RET_NOT_SUPPORTED, which is -1.
>> >> The result is that this function always returns "supported". Not an
>> >> acceptable behaviour.
>> >>
>> > Oh!  it's really a stupid mistake, should be "&" not "|".
>> 
>> But even then. (-1 & whatever) is always true.
> 
> Yeah, what about checking if a0 is non-negative first? Like:
> if (hvc_res.a0 < 0 || !(hvc_res.a0 & BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
> 	return -EOPNOTSUPP;

I don't get it. You already carry a patch from Will that gives
you a way to check for a service (kvm_arm_hyp_service_available()).

Why do you need to reinvent the wheel?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
