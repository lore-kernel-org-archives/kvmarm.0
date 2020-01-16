Return-Path: <SRS0=uwID=3F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A9CC33CB1
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jan 2020 07:28:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD068206D9
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jan 2020 07:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hS8dlpQ9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD068206D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F3EE4B145;
	Thu, 16 Jan 2020 02:28:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wQAZ2sJG2X5c; Thu, 16 Jan 2020 02:28:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEBFF4B156;
	Thu, 16 Jan 2020 02:28:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C58134B112
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jan 2020 02:28:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fo-obLH5E4ih for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jan 2020 02:28:52 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A93F14B103
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jan 2020 02:28:52 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6CF10206D9;
 Thu, 16 Jan 2020 07:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579159731;
 bh=pRRQpXth0TXpHnnIZoTynOLbI277epXRK/djArfkqqg=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=hS8dlpQ99rHWL0kTk5ZTYzoWlF+J25ZQgpqOCCSNP9QRRFrh4ST6wgTBWIxY18DIE
 LNp5gkGHlGi2/6LMyenbRn4s8rV1IGTp2AusKhQwbPGYgRWzfoJ9Z8HfxtqWPQToBi
 QmN3YnO0LOt/4zJx8GDSRa1AKsyKkXQy3cdeZPCE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1irzaD-00058d-LD; Thu, 16 Jan 2020 07:28:49 +0000
MIME-Version: 1.0
Date: Thu, 16 Jan 2020 07:28:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 0/3] arm64: Workaround for Cortex-A55 erratum 1530923
In-Reply-To: <20200114164543.GD2579@willie-the-truck>
References: <20191216115631.17804-1-steven.price@arm.com>
 <20200114164543.GD2579@willie-the-truck>
Message-ID: <3292551ef07b2c5354d48faedad849ff@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, steven.price@arm.com,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Steven Price <steven.price@arm.com>
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

On 2020-01-14 16:45, Will Deacon wrote:
> On Mon, Dec 16, 2019 at 11:56:28AM +0000, Steven Price wrote:
>> Version 5 is a rebasing of version 4 (no changes).
>> 
>> This series enables a workaround for Cortex-A55 erratum 1530923. The
>> erratum potentially allows TLB entries to be allocated as a result of 
>> a
>> speculative AT instruction. This may happen in the middle of a guest
>> world switch while the relevant VMSA configuration is in an 
>> inconsistent
>> state, leading to erroneous content being allocated into TLBs.
>> 
>> There are existing workarounds for similar issues, 1165522 is
>> effectively the same, and 1319367/1319537 is similar but without VHE
>> support.  Rather than add to the selection of errata, the first patch
>> renames 1165522 to WORKAROUND_SPECULATIVE_AT which can be reused (in 
>> the
>> final patch) for 1530923.
>> 
>> The workaround for errata 1319367 and 1319537 although similar cannot
>> use VHE (not available on those CPUs) so cannot share the workaround.
>> However, to keep some sense of symmetry the workaround is renamed to
>> SPECULATIVE_AT_NVHE.
>> 
>> Changes since v4:
>>  * Rebased to v5.5-rc1
> 
> Looks fine to me. Marc, are you ok with me queueing this via arm64 
> (that's
> where the existing workarounds came from), or would you prefer to take 
> them
> via kvm-arm?

Please go ahead and take it (with my ack) via the arm64 tree.

Thanks,

        M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
