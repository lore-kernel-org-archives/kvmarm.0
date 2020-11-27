Return-Path: <SRS0=tVNh=FB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514F3C2D0E4
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 08:50:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85B1622249
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 08:50:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="efktCWKG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85B1622249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B80684B893;
	Fri, 27 Nov 2020 03:50:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1VrCU0EtUrSb; Fri, 27 Nov 2020 03:50:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BEE64C256;
	Fri, 27 Nov 2020 03:50:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E88B94B8FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 03:50:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HNHUyTEZ97bF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2020 03:50:06 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A3D34B850
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 03:50:05 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9496722249;
 Fri, 27 Nov 2020 08:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606467004;
 bh=MX9vJKbH3cxWgpHtoGd0wZlzLIS8UOK+zuJffSAUtew=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=efktCWKGLzw7Um1ysYIPbSerZihvqFnqpGW/vr/Hcc/V/ddM4k8d485Tton7Q0I6i
 kPiXyzJHwrofdgbqqSOcB0hdrD+IvsHqBo1t48D2iXD6jctmEbVLhLbHIi4EVRhrxN
 8+OEVPuekmlC2pHLxhVYrhqMa2a7sC0TEisotaL8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kiZS6-00E0id-EK; Fri, 27 Nov 2020 08:50:02 +0000
MIME-Version: 1.0
Date: Fri, 27 Nov 2020 08:50:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 5/8] KVM: arm64: Remove PMU RAZ/WI handling
In-Reply-To: <cb7ebedb-5525-8493-007f-72c81b16189b@arm.com>
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-6-maz@kernel.org>
 <cb7ebedb-5525-8493-007f-72c81b16189b@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7ae93087a57bd5f6a348f0d4d6a7db2d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

On 2020-11-26 15:06, Alexandru Elisei wrote:
> Hi Marc,
> 
> This patch looks correct to me, I checked in the Arm ARM DDI 0487F.b 
> and indeed
> all accesses to the PMU registers are UNDEFINED if the PMU is not 
> present.
> 
> I checked all the accessors and now all the PMU registers that KVM 
> emulates will
> inject an undefined exception if the VCPU feature isn't set. There's
> one register
> that we don't emulate, PMMIR_EL1, I suppose that's because it's part of 
> PMU
> ARMv8.4 and KVM advertises ARMv8.1; if the guest tries to access it, it 
> will get
> an undefined exception and KVM will print a warning in 
> emulate_sys_reg().

Funny that. I wrote a patch for that a long while ago, and obviously
never did anything with it [1]... Actually, the whole series was 
silently
dropped. I guess I had other things to think about at the time!

Let me pick that up again.

> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!

         M.

[1] 
https://lore.kernel.org/kvmarm/20200216185324.32596-6-maz@kernel.org/
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
