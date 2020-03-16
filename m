Return-Path: <SRS0=WgPl=5B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC06C0044D
	for <kvmarm@archiver.kernel.org>; Mon, 16 Mar 2020 11:09:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DAE30205ED
	for <kvmarm@archiver.kernel.org>; Mon, 16 Mar 2020 11:09:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXh7WLR8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAE30205ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E25D4B092;
	Mon, 16 Mar 2020 07:09:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XR+9j1AcEHKM; Mon, 16 Mar 2020 07:09:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49BBA4B080;
	Mon, 16 Mar 2020 07:09:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F4AD4ACC9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 07:09:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PtlTzCGTTXY7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Mar 2020 07:09:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 327F74A588
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 07:09:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0371C205ED;
 Mon, 16 Mar 2020 11:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584356945;
 bh=7GnxZNUgFtH4VyMWdhOlCXj+A6q4k8+r/Ert4LPiEUg=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=fXh7WLR86Zz7FIHD9/0xetiYssyqwbwXtbSusOmYKXIZUVB57528z/q+NGy6FA0zS
 uyFKf/ZYX3TH9TVaLtgy7bkAZvRI9/ESDSsLxCKo6SlK4RTHvEF9LJgvNHauqpITXU
 3IRFo6Uwdgo4ma5B8B81byHZPU6ckH3rloLCWW5Y=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jDncF-00D3fu-D8; Mon, 16 Mar 2020 11:09:03 +0000
MIME-Version: 1.0
Date: Mon, 16 Mar 2020 11:09:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Use the correct timer for accessing CNT
In-Reply-To: <7ed91b9b-e968-770c-28f9-0ca479359657@huawei.com>
References: <1584351546-5018-1-git-send-email-karahmed@amazon.de>
 <7ed91b9b-e968-770c-28f9-0ca479359657@huawei.com>
Message-ID: <a8b72d6c0a28e0554050e98d011f32d9@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, karahmed@amazon.de,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: KarimAllah Ahmed <karahmed@amazon.de>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On 2020-03-16 10:49, Zenghui Yu wrote:
> Hi,
> 
> On 2020/3/16 17:39, KarimAllah Ahmed wrote:
>> Use the physical timer object when reading the physical timer counter
>> instead of using the virtual timer object. This is only visible when
>> reading it from user-space as kvm_arm_timer_get_reg() is only executed 
>> on
>> the get register patch from user-space.
> 
> s/patch/path/
> 
> I think the physical counter hasn't yet been accessed by the current
> userspace, wrong?

I don't think userspace can access it, as the ONE_REG API only exposes 
the virtual
timer so far, and userspace is much better off just reading the counter 
directly
(it has access to the virtual counter, and the guarantee that cntvoff is 
0 in this
context).

But as we move towards a situation where we can save/restore the 
physical timer
just like the virtual one, we're going to use this path and hit this 
bug.

> 
>> 
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.cs.columbia.edu
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> 
> And this might also deserve:
> 
> Fixes: 84135d3d18da ("KVM: arm/arm64: consolidate arch timer trap 
> handlers")

Indeed. Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
