Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2ACC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:55:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CB952073B
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:55:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQfUN1SS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CB952073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 564AC4B195;
	Wed, 27 May 2020 03:55:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sNE3mBEe635B; Wed, 27 May 2020 03:55:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 490764B1B6;
	Wed, 27 May 2020 03:55:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E304B195
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 03:55:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8zZR6XFefMkL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 03:55:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 289174B193
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 03:55:22 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1272C206DF;
 Wed, 27 May 2020 07:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590566121;
 bh=jzOmuKHr7MlkKhB0uHGzKnveUIYCQtnDxs2JjhAI0Qw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=IQfUN1SSOnwGbA+wQOaXCUtXhUe/1PYgxn+dBcov9P1qwLHE1jEo++wGH2RrhqjNF
 kWQpzqI991EMT2EFP/jykooRM94vdRXLiSCFAUmRwPm1btiDP9GdDvo90nhr7gPubd
 LG1u151RsnIxhDv4CAeA++tUcpAG6m+m9it6yv88=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jdquF-00FdO9-Bn; Wed, 27 May 2020 08:55:19 +0100
MIME-Version: 1.0
Date: Wed, 27 May 2020 08:55:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Allow in-atomic injection of SPIs
In-Reply-To: <47d6d521-f05e-86fe-4a94-ce21754100ae@huawei.com>
References: <20200526161136.451312-1-maz@kernel.org>
 <47d6d521-f05e-86fe-4a94-ce21754100ae@huawei.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <1d3658f4b92a690ba05367f2a22a7331@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, eric.auger@redhat.com,
 kernel-team@android.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
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

Hi Zenghui,

On 2020-05-27 08:41, Zenghui Yu wrote:
> On 2020/5/27 0:11, Marc Zyngier wrote:
>> On a system that uses SPIs to implement MSIs (as it would be
>> the case on a GICv2 system exposing a GICv2m to its guests),
>> we deny the possibility of injecting SPIs on the in-atomic
>> fast-path.
>> 
>> This results in a very large amount of context-switches
>> (roughly equivalent to twice the interrupt rate) on the host,
>> and suboptimal performance for the guest (as measured with
>> a test workload involving a virtio interface backed by vhost-net).
>> Given that GICv2 systems are usually on the low-end of the spectrum
>> performance wise, they could do without the aggravation.
>> 
>> We solved this for GICv3+ITS by having a translation cache. But
>> SPIs do not need any extra infrastructure, and can be immediately
>> injected in the virtual distributor as the locking is already
>> heavy enough that we don't need to worry about anything.
>> 
>> This halves the number of context switches for the same workload.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   arch/arm64/kvm/vgic/vgic-irqfd.c | 20 ++++++++++++++++----
>>   arch/arm64/kvm/vgic/vgic-its.c   |  3 +--
>>   2 files changed, 17 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c 
>> b/arch/arm64/kvm/vgic/vgic-irqfd.c
>> index d8cdfea5cc96..11a9f81115ab 100644
>> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
>> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
>> @@ -107,15 +107,27 @@ int kvm_arch_set_irq_inatomic(struct 
>> kvm_kernel_irq_routing_entry *e,
>>   			      struct kvm *kvm, int irq_source_id, int level,
>>   			      bool line_status)
> 
> ... and you may also need to update the comment on top of it to
> reflect this change.
> 
> /**
>  * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
>  *
>  * Currently only direct MSI injection is supported.
>  */

As far as I can tell, it is still valid (at least from the guest's
perspective). You could in practice use that to deal with level
interrupts, but we only inject the rising edge on this path, never
the falling edge. So effectively, this is limited to edge interrupts,
which is mostly MSIs.

Unless you are thinking of something else which I would have missed?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
