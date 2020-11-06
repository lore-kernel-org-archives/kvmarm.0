Return-Path: <SRS0=uq+A=EM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6031C2D0A3
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 09:57:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0EFA222201
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 09:57:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlvr1Tz1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EFA222201
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 451634B843;
	Fri,  6 Nov 2020 04:57:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2qJfKZGKrBRE; Fri,  6 Nov 2020 04:57:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 472634B823;
	Fri,  6 Nov 2020 04:57:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4054B7C8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 04:57:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZzGt0osvfhxW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2020 04:57:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A84F4B7C2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 04:57:08 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E108B20B80;
 Fri,  6 Nov 2020 09:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604656627;
 bh=7k+t6D9+wpCTXBdefzDfDbiTH2zQDjta8PTrfd8tDa0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=nlvr1Tz1wWGJ1mgrgtClOUmilBn7fgUtvjxfmP49knvor83tz0AID5fpC/e10x3Na
 5fA2yUfgqMKrIMuoafHLqiXDsvLNB1rqknB1iEHYh3GssE78engknOQAV8JEHvx3WC
 50i3UEJibPtZ3FNpe3PTpWvSM0sYHc0xSF0MQUrY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kayUS-00892a-Mm; Fri, 06 Nov 2020 09:57:04 +0000
MIME-Version: 1.0
Date: Fri, 06 Nov 2020 09:57:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/3] KVM: arm64: Allow setting of ID_AA64PFR0_EL1.CSV2
 from userspace
In-Reply-To: <20201105224442.GD8842@willie-the-truck>
References: <20201103171445.271195-1-maz@kernel.org>
 <20201103171445.271195-2-maz@kernel.org>
 <20201105224442.GD8842@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <32241e9ee49133df4e9bcc6c8ebd7551@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 liangpeng10@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 2020-11-05 22:44, Will Deacon wrote:

>> +	if (csv2 > vcpu->kvm->arch.pfr0_csv2)
>> +		return -EINVAL;
>> +	vcpu->kvm->arch.pfr0_csv2 = csv2;
>> +
>> +	/* This is what we mean by invariant: you can't change it. */
>> +	if (val != read_id_reg(vcpu, rd, false))
>> +		return -EINVAL;
> 
> I think it's quite confusing to return -EINVAL in the case that we have
> actually updated arch.pfr0_csv2, as it's indistinguishable from the 
> case
> when csv2 was invalid and the field wasn't updated.

-EINVAL is the right error code here (you're setting an invalid value 
for
the whole register). The bug is that we have now changed CSV2 for 
everyone.

I'll have a look at fixing this, though it might involve some locking.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
