Return-Path: <SRS0=ASFk=AZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7EAC433DF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jul 2020 11:34:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 573F622208
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jul 2020 11:34:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uSOPndyO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 573F622208
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA67B4B195;
	Tue, 14 Jul 2020 07:34:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8OFdIrV+9iDy; Tue, 14 Jul 2020 07:34:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB9394B197;
	Tue, 14 Jul 2020 07:34:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A77214B186
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jul 2020 07:34:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iu0zKuQUjN7N for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jul 2020 07:34:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8EA64B145
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jul 2020 07:34:18 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 57BCB22203;
 Tue, 14 Jul 2020 11:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594726457;
 bh=kmxoxxCKYn4praQ9Nl67zZ5JOsPadeFdzaauOFi7Zbs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=uSOPndyObFfsQ/SmCaA+ixqJQHNA7lCVJvrPYIMKkTDCCRtsXDSN3Vb4r6+1VTgjo
 hC+C1ds1Rl0SX/mSSXNJ5R6n4hL6C58D4suvjQ9lqeZi4GhNWkimsaIMYc/HnFrmeV
 +HslyEP9H2h2VLi5lbvbZDz4Xlsv5nFJBTavdeSE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jvJCR-00BeTe-V3; Tue, 14 Jul 2020 12:34:16 +0100
MIME-Version: 1.0
Date: Tue, 14 Jul 2020 12:34:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: zhukeqian <zhukeqian1@huawei.com>
Subject: Re: [Question] About scaling factor of Enhanced Counter Virtualization
In-Reply-To: <e435efd2-f894-ecbb-5eb4-abf446aa1e56@huawei.com>
References: <e435efd2-f894-ecbb-5eb4-abf446aa1e56@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <ccc11488876b8222414389d0cbcead6b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, catalin.marinas@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, yebiaoxiang@huawei.com,
 xiexiangyou@huawei.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, yebiaoxiang@huawei.com,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Keqian,

On 2020-07-14 03:20, zhukeqian wrote:
> Hi all,
> 
> We are studying Enhanced Counter Virtualization (introduced by ARMv8.6
> extension), and here is a question
> raised by Biaoxiang Ye <yebiaoxiang@huawei.com>:
> 
> Described in the ARMv8.6 Extension Specification:
> Note: the scaling factor CNTSCALE is designed as a 2.62 bit fixed
> point number, so permitting a scaling up by
> (nearly) a factor 4. The scaling factor CNTISCALE is signed as an 8.56
> number for the scaling of the values
> written into the timers for comparison with the actual count. This
> implies that the greatest scaling down of the
> counter supported in (nearly) a factor of *512*.
> 
> We think the number "512" should be "256" (2^8), or do we miss 
> something?

This register doesn't seem to be described in ARM DDI 0487F.b,
which is the official documentation and does contain the ARMv8.6
material, including ARMv8.6-ECV.

Either you are looking at confidential information (and nobody
can answer you in public), or obsolete information (and nobody
knows what this is about).

In any case, this is most probably a question for ARM's support
team, and not the kernel mailing lists.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
