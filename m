Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2A8C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 15:03:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD1F62072F
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 15:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="miZS9oRo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD1F62072F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7823B4B21B;
	Wed, 10 Jun 2020 11:03:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4oJMK80WxPgK; Wed, 10 Jun 2020 11:03:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76B1E4B1FE;
	Wed, 10 Jun 2020 11:03:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97E7A4B1D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 11:03:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pR0wH-XOhoQf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 11:02:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7E524B198
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 11:02:56 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9EFAF2072F;
 Wed, 10 Jun 2020 15:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591801375;
 bh=PXOXPvrJV7xGGbzYC9/oZT86BtGS3IQuSBt+aeT7chk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=miZS9oRoEjrNMU1meThJvdtBXhi0h+mnI4aLe1ZvYLzne2pS5A2ymCsWzRULdvM9S
 0ypO5Pvib76X09QkaaLDBbZ8rIOJhHK3/OMNBf2gitnzI5QSV7LbgGkbH0NuXtBbdN
 zyZai7/svsw881Su3czNZ57SY+WVUFfSJTBhNs0c=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jj2Fi-001ofe-4F; Wed, 10 Jun 2020 16:02:54 +0100
MIME-Version: 1.0
Date: Wed, 10 Jun 2020 16:02:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] irqchip/gic-v4.1: Use readx_poll_timeout_atomic() to fix
 sleep in atomic
In-Reply-To: <4a9822bd-0362-7ffe-6e56-3f05a7816d9e@huawei.com>
References: <20200605052345.1494-1-yuzenghui@huawei.com>
 <4a9822bd-0362-7ffe-6e56-3f05a7816d9e@huawei.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <2bff9c0af0aa5eeef44b381ee0f8a542@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 tglx@linutronix.de, jason@lakedaemon.net, wanghaibin.wang@huawei.com,
 wangjingyi11@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: jason@lakedaemon.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-06-10 14:59, Zenghui Yu wrote:
> Hi Marc,
> 
> Sorry to ping you in the merge window, but ...
> 
> On 2020/6/5 13:23, Zenghui Yu wrote:
>> readx_poll_timeout() can sleep if @sleep_us is specified by the 
>> caller,
>> and is therefore unsafe to be used inside the atomic context, which is
>> this case when we use it to poll the GICR_VPENDBASER.Dirty bit in
>> irq_set_vcpu_affinity() callback.
> 
> this seems like an urgent thing to me. Without this patch, CPUs are
> easily to get stuck on my board with GICv4.1 enabled. So it'd be good 
> if
> you can have a look and take this as a fix (if it is correct).

No worries. I've earmarked the patch for -rc1 already, just haven't got
a chance to build the branch yet (a bit busy on the KVM side).

I'll probably update the branch tonight or tomorrow.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
