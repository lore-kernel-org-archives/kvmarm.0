Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EC2C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 09:05:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 99C0620857
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 09:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXXFrd6s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99C0620857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE14A4BD62;
	Tue, 24 Nov 2020 04:05:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3U7BSno7dNY9; Tue, 24 Nov 2020 04:05:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 374724BD20;
	Tue, 24 Nov 2020 04:05:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 870594BD18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 04:05:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8+wnmHK57n1u for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 04:05:01 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C48C4BD12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 04:05:01 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B27A82075A;
 Tue, 24 Nov 2020 09:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606208699;
 bh=4dd2MKJS6YNqUDm2WfT0Eu4BA+fK0d9nlPFSmVAq7GY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=VXXFrd6sYgV0FGjunKo/ajZ40yGekO24Gi7WxGW9SzG9TnexvSCBR/WMuglY2+msF
 MMltO5oe/o8yrwATRTrpb6cskzP2RWV9wFzKZAjVD1peSe7W/gW3iTjgb4bTVqmUNR
 YmMs8gsuNfPW+1Ktf/0rTBtKM2RXdF8dhvsQn3zM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1khUFt-00DC9a-CY; Tue, 24 Nov 2020 09:04:57 +0000
MIME-Version: 1.0
Date: Tue, 24 Nov 2020 09:04:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
In-Reply-To: <HE1PR0802MB2555C5D09EA2BF0BA369BE37F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-8-jianyong.wu@arm.com>
 <7bd3a66253ca4b7adbe2294eb598a23f@kernel.org>
 <HE1PR0802MB2555C5D09EA2BF0BA369BE37F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <5dc5480d125ace6566ae616206c3ce3f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, netdev@vger.kernel.org,
 yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
 pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com,
 Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com,
 Andre.Przywara@arm.com, Steven.Price@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Steve.Capper@arm.com, Justin.He@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Justin He <Justin.He@arm.com>, kvm@vger.kernel.org, netdev@vger.kernel.org,
 richardcochran@gmail.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, Steven Price <Steven.Price@arm.com>,
 Andre Przywara <Andre.Przywara@arm.com>, john.stultz@linaro.org,
 yangbo.lu@nxp.com, pbonzini@redhat.com, tglx@linutronix.de, nd <nd@arm.com>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Jianyong,

On 2020-11-24 05:37, Jianyong Wu wrote:
> Hi Marc,

[...]

>> > +
>> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
>> NC_ID,
>> > +			     ARM_PTP_NONE_COUNTER, &hvc_res);
>> 
>> I really don't see the need to use a non-architectural counter ID.
>> Using the virtual counter ID should just be fine, and shouldn't lead 
>> to any
>> issue.
>> 
> 
>> Am I missing something?
> 
> In this function, no counter data is needed. If virtual counter ID is
> used here, user may be confused with why we get virtual counter
> data and do nothing with it. So I explicitly add a new "NONE" counter
> ID to make it clear.
> 
> WDYT?

ITIABI (I Think It's A Bad Idea). There are two counters, and the API
allows to retrieve the data for any of these two. If the "user" doesn't
want to do anything with the data, that's their problem.

Here, you can just sue the virtual counter, and that will give you the
exact same semantic, without inventing non-architectural state.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
