Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DFCC8300B
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 11:39:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1DC620775
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 11:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="k29nbFT/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1DC620775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 639EE4B27C;
	Thu, 30 Apr 2020 07:39:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zJjrzGI-oHEU; Thu, 30 Apr 2020 07:39:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5384B280;
	Thu, 30 Apr 2020 07:39:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C0FA4B27B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:39:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c4bxO3ARpyKG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 07:39:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0902B4B275
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:39:27 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BE2192076D;
 Thu, 30 Apr 2020 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588246765;
 bh=2rv/Th+U2tvUwoYnI9XJB61R1uEh9ov5BSgYIC5BZ7Y=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=k29nbFT/ev2JNmZkIbIni5U6RVaAGwptOaa/IDd9bcTSXbPY2vVCM9jpToRNnIHv8
 r9meXIEYdgsv59NHVeo/qW74RI3hVsR0P2ropIAUdsdmYpEX/OHdGqS8CG5u8nwsY0
 iflC7ZZNThZCxtLxZoJiH6z06rlyNZrLdZGiEIPg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jU7XI-0080nh-3G; Thu, 30 Apr 2020 12:39:24 +0100
MIME-Version: 1.0
Date: Thu, 30 Apr 2020 12:39:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Initialize GICv4.1 even in the
 absence of a virtual ITS
In-Reply-To: <5b23b938-f71f-5523-6d7e-027bcca98dd4@huawei.com>
References: <20200425094426.162962-1-maz@kernel.org>
 <5b23b938-f71f-5523-6d7e-027bcca98dd4@huawei.com>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <cd9743fabceee2a821808046081930cd@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On 2020-04-30 12:24, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/4/25 17:44, Marc Zyngier wrote:
>> KVM now expects to be able to use HW-accelerated delivery of vSGIs
>> as soon as the guest has enabled thm. Unfortunately, we only
> them
>> initialize the GICv4 context if we have a virtual ITS exposed to
>> the guest.
>> 
>> Fix it by always initializing the GICv4.1 context if it is
>> available on the host.
>> 
>> Fixes: 2291ff2f2a56 ("KVM: arm64: GICv4.1: Plumb SGI implementation 
>> selection in the distributor")
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   virt/kvm/arm/vgic/vgic-init.c    | 9 ++++++++-
>>   virt/kvm/arm/vgic/vgic-mmio-v3.c | 3 ++-
>>   2 files changed, 10 insertions(+), 2 deletions(-)
>> 
>> diff --git a/virt/kvm/arm/vgic/vgic-init.c 
>> b/virt/kvm/arm/vgic/vgic-init.c
>> index a963b9d766b73..8e6f350c3bcd1 100644
>> --- a/virt/kvm/arm/vgic/vgic-init.c
>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>> @@ -294,8 +294,15 @@ int vgic_init(struct kvm *kvm)
>>   		}
>>   	}
>>   -	if (vgic_has_its(kvm)) {
>> +	if (vgic_has_its(kvm))
>>   		vgic_lpi_translation_cache_init(kvm);
>> +
>> +	/*
>> +	 * If we have GICv4.1 enabled, unconditionnaly request enable the
>> +	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
>> +	 * enable it if we present a virtual ITS to the guest.
>> +	 */
>> +	if (vgic_supports_direct_msis(kvm)) {
>>   		ret = vgic_v4_init(kvm);
>>   		if (ret)
>>   			goto out;
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index e72dcc4542475..26b11dcd45524 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -50,7 +50,8 @@ bool vgic_has_its(struct kvm *kvm)
>>     bool vgic_supports_direct_msis(struct kvm *kvm)
>>   {
>> -	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
>> +	return (kvm_vgic_global_state.has_gicv4_1 ||
>> +		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
>>   }
> 
> Not related to this patch, but I think that the function name can be
> improved a bit after this change. It now indicates whether the vGIC
> supports direct MSIs injection *or* direct SGIs injection, not just
> MSIs. And if vgic_has_its() is false, we don't even support MSIs.

Yes, I noticed that too. But in the spirit of keeping the change minimal
and avoid later conflicts with potential fixes, I decided against 
changing
it right now.

> The fix itself looks correct to me,
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
