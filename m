Return-Path: <SRS0=v4UO=24=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED98AC33C99
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jan 2020 09:34:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 803F620848
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jan 2020 09:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4MhWpEv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 803F620848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1636A4AF0D;
	Tue,  7 Jan 2020 04:34:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7Ph9mvBdorYu; Tue,  7 Jan 2020 04:34:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BB854AF0A;
	Tue,  7 Jan 2020 04:34:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 713F94AF0A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jan 2020 04:33:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gGK1Cfg3YC7C for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jan 2020 04:33:58 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 648F04AEC4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jan 2020 04:33:58 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1D9B7206DB;
 Tue,  7 Jan 2020 09:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1578389637;
 bh=0RwFzwAEmrIP5sG0tKGrxv2D/cxDWEkx4BvAxCF7YcY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=H4MhWpEv9OaFCgT3pOtwNa8691FoPe9u0TYSCg/+0HvXNb3xrg8Z0UMTp3WlgCN9V
 sZneQrxj1cZTzcdnNMP4HyRW3GUYvhQYxpSdzhrj9w+ugT+W+e09aturGqr6jVjdnQ
 EuPegGrp4+ChfhOaNGONnb4I074kMSLOP/LCXt6g=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1iolFL-000143-D1; Tue, 07 Jan 2020 09:33:55 +0000
MIME-Version: 1.0
Date: Tue, 07 Jan 2020 09:33:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v9 0/8] Enable ptp_kvm for arm64
In-Reply-To: <bf333cdc-3455-7c64-89c2-014639614904@redhat.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <HE1PR0801MB1676CFC9A06B6CE800052A99F43C0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <bf333cdc-3455-7c64-89c2-014639614904@redhat.com>
Message-ID: <7a589be6dc0d5562caf8c8f795b31efc@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, Jianyong.Wu@arm.com,
 netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, sean.j.christopherson@intel.com, richardcochran@gmail.com,
 Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com,
 Steven.Price@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com, Justin.He@arm.com,
 nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Justin He <Justin.He@arm.com>, kvm@vger.kernel.org, netdev@vger.kernel.org,
 richardcochran@gmail.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, Steven Price <Steven.Price@arm.com>,
 john.stultz@linaro.org, yangbo.lu@nxp.com, tglx@linutronix.de, nd <nd@arm.com>,
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

On 2020-01-07 08:15, Paolo Bonzini wrote:
> On 06/01/20 10:38, Jianyong Wu wrote:
>> Ping ...
>> Any comments to this patch set?
> 
> Marc, Will, can you ack it?  Since the sticky point was the detection 
> of
> the clocksource and it was solved by Thomas's patch, I don't have any
> more problems including it.

Boo. I had forgotten about this series. :-(

Going back to it, there is a few ugly points in the arm-specific code
(I'm OK with the generic changes though).

Another thing is that the whole series depends on three patches that 
have
never been posted to any list, hence never reviewed.

Jianyong: Please repost this series *with* the dependencies so that they
can be reviewed, once you've addressed my comments on two of the 
patches.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
