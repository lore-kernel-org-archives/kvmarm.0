Return-Path: <SRS0=kREJ=EV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC85C2D0E4
	for <kvmarm@archiver.kernel.org>; Sun, 15 Nov 2020 17:04:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 983562244C
	for <kvmarm@archiver.kernel.org>; Sun, 15 Nov 2020 17:04:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tWwIjkCo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 983562244C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 106864BEEF;
	Sun, 15 Nov 2020 12:04:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3unvc8e8-VuA; Sun, 15 Nov 2020 12:04:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC7F94BED3;
	Sun, 15 Nov 2020 12:04:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79BAC4BEC5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Nov 2020 12:04:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3yEZMQcJTGZx for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Nov 2020 12:04:04 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9064F4BE9E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Nov 2020 12:04:04 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3A7F2223FB;
 Sun, 15 Nov 2020 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605459843;
 bh=47Yg3gRFv07hkRm946gKdQt9gA1sJtG0nNWa6xf0C/4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=tWwIjkCozPQsYmXmcuNE1AUahp+dOfl95+iNZIM/P4bLp6VYNMnrBqlIjVkkNBWwo
 9rH+4FQExc4s+GkE5zlJMIUKciQYYg3xxPlWXX34AKG9HdThv7oI6qL6LAFza+Uy85
 k//45RpJvVLbH9IPaJYsbqpAEUXv+o0cLsa68o4M=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1keLRZ-00AoQd-Ho; Sun, 15 Nov 2020 17:04:01 +0000
MIME-Version: 1.0
Date: Sun, 15 Nov 2020 17:04:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Forbid invalid userspace
 Redistributor accesses
In-Reply-To: <20201113142801.1659-2-yuzenghui@huawei.com>
References: <20201113142801.1659-1-yuzenghui@huawei.com>
 <20201113142801.1659-2-yuzenghui@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <724c43702b52aac0d3c9beb9604d1bfb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, wanghaibin.wang@huawei.com, zhukeqian1@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

Hi Zenghui,

On 2020-11-13 14:28, Zenghui Yu wrote:
> It's expected that users will access registers in the redistributor 
> *if*
> the RD has been initialized properly. Unfortunately userspace can be 
> bogus
> enough to access registers before setting the RD base address, and KVM
> implicitly allows it (we handle the access anyway, regardless of 
> whether
> the base address is set).
> 
> Bad thing happens when we're handling the user read of GICR_TYPER. We 
> end
> up with an oops when deferencing the unset rdreg...
> 
> 	gpa_t last_rdist_typer = rdreg->base + GICR_TYPER +
> 			(rdreg->free_index - 1) * KVM_VGIC_V3_REDIST_SIZE;
> 
> Fix this issue by informing userspace what had gone wrong (-ENXIO).

I'm worried about the "implicit" aspect of the access that this patch
now forbids.

The problem is that the existing documentation doesn't cover this case,
and -ENXIO's "Getting or setting this register is not yet supported"
is way too vague. There is a precedent with the ITS, but that's 
undocumented
as well. Also, how about v2? If that's the wasy we are going to fix 
this,
we also nned to beef up the documentation.

Of course, the other horrible way to address the issue is to return a 
value
that doesn't have the Last bit set, since we can't synthetise it. It 
doesn't
change the userspace API, and I can even find some (admittedly  twisted)
logic to it (since there is no base address, there is no last RD...).

Thoughts?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
