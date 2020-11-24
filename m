Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408F9C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 09:07:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 497ED20782
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 09:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1TYjrVTN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 497ED20782
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B4654BD10;
	Tue, 24 Nov 2020 04:07:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WUEuTRVh4R5z; Tue, 24 Nov 2020 04:07:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8852A4BD12;
	Tue, 24 Nov 2020 04:07:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6AF44BD0C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 04:07:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I1Ki9RTFXBIN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 04:07:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF9A84BD00
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 04:07:09 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3FB8A2075A;
 Tue, 24 Nov 2020 09:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606208828;
 bh=YKBAEa1S7x5XyrSw9i58+TYmKcHvXHjT1wTkrq7seHc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=1TYjrVTNfjqRUqQ/Iq86CER/48R56RG15mANFIvrlo9mW1LXuq4cPU6J1UPtrskq+
 Y/4ztGT3YKOQUxjApd/8IVwhnC1II+KQXMqYOUxLDqarudt1tbzm7u4Jx2fQvqEsLC
 Dsp1C5/QeN917gO0flLsoG/WxZDDD3SzTT8JrL3c=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1khUHy-00DCBp-50; Tue, 24 Nov 2020 09:07:06 +0000
MIME-Version: 1.0
Date: Tue, 24 Nov 2020 09:07:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
In-Reply-To: <HE1PR0802MB255534CF7A04FB5A6CE99A67F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-7-jianyong.wu@arm.com>
 <d409aa1cb7cfcbf4351e6c5fc34d9c7e@kernel.org>
 <HE1PR0802MB255534CF7A04FB5A6CE99A67F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <9133f26699c5fc08d0ea72acfa9aca3b@kernel.org>
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

On 2020-11-24 05:20, Jianyong Wu wrote:
> Hi Marc,

[...]

>> > +/* ptp_kvm counter type ID */
>> > +#define ARM_PTP_VIRT_COUNTER			0
>> > +#define ARM_PTP_PHY_COUNTER			1
>> > +#define ARM_PTP_NONE_COUNTER			2
>> 
>> The architecture definitely doesn't have this last counter.
> 
> Yeah, this is just represent no counter data needed from guest.
> Some annotation should be added here.

I'd rather you remove it entirely, or explain why you really cannot
do without a fake counter.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
