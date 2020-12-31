Return-Path: <SRS0=RZNQ=GD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C265DC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 31 Dec 2020 12:22:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 301C7223E4
	for <kvmarm@archiver.kernel.org>; Thu, 31 Dec 2020 12:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 301C7223E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A43264B1F0;
	Thu, 31 Dec 2020 07:22:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jw94g8wCyZnn; Thu, 31 Dec 2020 07:22:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79FAA4B296;
	Thu, 31 Dec 2020 07:22:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90A174B1F0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Dec 2020 07:22:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SS3k5zLuAKAf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Dec 2020 07:22:16 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 539B74B294
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Dec 2020 07:22:16 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0E7FB223DB;
 Thu, 31 Dec 2020 12:22:15 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kuwy4-004iEa-Tk; Thu, 31 Dec 2020 12:22:12 +0000
MIME-Version: 1.0
Date: Thu, 31 Dec 2020 12:22:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [PATCH RFC] KVM: arm64: vgic: Decouple the check of the
 EnableLPIs bit from the ITS LPI translation
In-Reply-To: <cf530279-4c68-c7de-f87e-1236ce0241cf@huawei.com>
References: <20201231062813.714-1-lushenming@huawei.com>
 <683134bdea8a22d3bb784117dcfe17a1@kernel.org>
 <cf530279-4c68-c7de-f87e-1236ce0241cf@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <85dd45f580eaa7a0b8ec91ac0b7ca066@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, will@kernel.org,
 eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
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

On 2020-12-31 11:58, Shenming Lu wrote:
> On 2020/12/31 16:57, Marc Zyngier wrote:
>> Hi Shemming,
>> 
>> On 2020-12-31 06:28, Shenming Lu wrote:
>>> When the EnableLPIs bit is set to 0, any ITS LPI requests in the
>>> Redistributor would be ignored. And this check is independent from
>>> the ITS LPI translation. So it might be better to move the check
>>> of the EnableLPIs bit out of the LPI resolving, and also add it
>>> to the path that uses the translation cache.
>> 
>> But by doing that, you are moving the overhead of checking for
>> EnableLPIs from the slow path (translation walk) to the fast
>> path (cache hit), which seems counter-productive.
> 
> Oh, I didn't notice the overhead of the checking, I thought it would
> be negligible...

It probably doesn't show on a modern box, but some of the slower
systems might see it. Overall, this is a design decision to keep
the translation cache as simple and straightforward as possible:
if anything affects the output of the cache, we invalidate it,
and that's it.

> 
>> 
>>> Besides it seems that
>>> by this the invalidating of the translation cache caused by the LPI
>>> disabling is unnecessary.
>>> 
>>> Not sure if I have missed something... Thanks.
>> 
>> I am certainly missing the purpose of this patch.
>> 
>> The effect of EnableLPIs being zero is to drop the result of any
>> translation (a new pending bit) on the floor. Given that, it is
>> immaterial whether this causes a new translation or hits in the
>> cache, as the result is still to not pend a new interrupt.
>> 
>> I get the feeling that you are trying to optimise for the unusual
>> case where EnableLPIs is 0 *and* you have a screaming device
>> injecting tons of interrupt. If that is the case, I don't think
>> this is worth it.
> 
> In fact, I just found (imagining) that if the EnableLPIs bit is 0,
> the kvm_vgic_v4_set_forwarding() would fail when performing the LPI
> translation, but indeed we don't try to pend any interrupts there...
> 
> By the way, it seems that the LPI disabling would not affect the
> injection of VLPIs...

Yes, good point. We could unmap the VPE from all ITS, which would result
in all translations to be discarded, but this has the really bad side
effect of *also* preventing the delivery of vSGIs, which isn't what
you'd expect.

Overall, I don't think there is a good way to support this, and maybe
we should just prevent EnableLPIs to be turned off when using direct
injection. After all, the architecture does allow that for GICv3
implementations, which is what we emulate.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
