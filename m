Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A301C433E2
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 17:15:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A2C5F2166E
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 17:15:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/hkFtaw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2C5F2166E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ADA74B3E8;
	Wed,  9 Sep 2020 13:15:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K59mCjudbUP6; Wed,  9 Sep 2020 13:15:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 079D14B3ED;
	Wed,  9 Sep 2020 13:15:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 363A14B3E9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 13:15:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8CO-Sygex80k for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 13:15:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42CCF4B3ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 13:15:09 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1D32E206E6;
 Wed,  9 Sep 2020 17:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599671708;
 bh=yb6nfxanj9Tiy386s0uxnCmabtNDbe5a6Bii3jABOyk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=n/hkFtawTWuMM9SNDrnaacRfjoFyyzdh5VJskOv8GjzM/5dDE3F6aLCwqaItQYUpg
 l29nqfWFOjEruGBP8EBMHXqVcWA+wcx/3y/0puprz0aKDcN0b2Q+kFHl0a2+vJ/0JR
 n7AN9/hoad/gNsC2RrX1E28h/ePtSeWrwcWK7XXI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kG3gY-00AQbP-D9; Wed, 09 Sep 2020 18:15:06 +0100
MIME-Version: 1.0
Date: Wed, 09 Sep 2020 18:15:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.9
In-Reply-To: <f7afbf0f-2e14-2720-5d23-2cd01982e4d1@redhat.com>
References: <20200904104530.1082676-1-maz@kernel.org>
 <f7afbf0f-2e14-2720-5d23-2cd01982e4d1@redhat.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <fea2e35a29967075e46d25220044c109@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com,
 steven.price@arm.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On 2020-09-09 16:20, Paolo Bonzini wrote:
> On 04/09/20 12:45, Marc Zyngier wrote:
>> Hi Paolo,
>> 
>> Here's a bunch of fixes for 5.9. The gist of it is the stolen time
>> rework from Andrew, but we also have a couple of MM fixes that have
>> surfaced as people have started to use hugetlbfs in anger.
> 
> Hi Marc,
> 
> I'll get to this next Friday.

Thanks. I may have another one for you by then though...

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
