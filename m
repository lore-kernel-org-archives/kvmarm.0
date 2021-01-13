Return-Path: <SRS0=/ONs=GQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2A9C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 17:18:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 874B52343B
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 17:18:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 874B52343B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C59B4B1DC;
	Wed, 13 Jan 2021 12:18:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Acpd6Is4twG8; Wed, 13 Jan 2021 12:18:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C3AC4B17C;
	Wed, 13 Jan 2021 12:18:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD9F4B176
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 12:18:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YigceDm3ulIn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2021 12:18:47 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E80084B122
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 12:18:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610558327;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7zVKCOf+hFcDGtIgPvTN+nqlHkfJziBSJGgxDULseSA=;
 b=KYPHh5NqsiTP4o1k0+7S4FKejT8KNUQmYKwH26/zIPHRYYpcxihghjvAAVwsSKvrID5tgx
 stfQilpaY5Qpcx1TwK+4aLO+OpjG1WuSZC3EKCV1MKyMqM4F9GWVrdn7znVMpiIM0dXdyq
 7hCdkRXpl4FwJAVYPfuW/KGsWHhdOe0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-8ucV_A4hOSWMEuopppGN5w-1; Wed, 13 Jan 2021 12:18:45 -0500
X-MC-Unique: 8ucV_A4hOSWMEuopppGN5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFE94100C604;
 Wed, 13 Jan 2021 17:18:43 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 553EC2BFC7;
 Wed, 13 Jan 2021 17:18:41 +0000 (UTC)
Subject: Re: [PATCH 4/9] KVM: arm/arm64: vgic: Reset base address on
 kvm_vgic_dist_destroy()
To: Marc Zyngier <maz@kernel.org>
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-5-eric.auger@redhat.com> <878s9ios44.wl-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <2291951d-987c-7b9f-e1a6-d4241f84fce5@redhat.com>
Date: Wed, 13 Jan 2021 18:18:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <878s9ios44.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvm@vger.kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 12/28/20 4:41 PM, Marc Zyngier wrote:
> On Sat, 12 Dec 2020 18:50:05 +0000,
> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> On vgic_dist_destroy(), the addresses are not reset. However for
>> kvm selftest purpose this would allow to continue the test execution
>> even after a failure when running KVM_RUN. So let's reset the
>> base addresses.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-init.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
>> index 32e32d67a127..6147bed56b1b 100644
>> --- a/arch/arm64/kvm/vgic/vgic-init.c
>> +++ b/arch/arm64/kvm/vgic/vgic-init.c
>> @@ -335,14 +335,16 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>>  	kfree(dist->spis);
>>  	dist->spis = NULL;
>>  	dist->nr_spis = 0;
>> +	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
>>  
>> -	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
>> +	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
>>  		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list) {
>>  			list_del(&rdreg->list);
>>  			kfree(rdreg);
>>  		}
>>  		INIT_LIST_HEAD(&dist->rd_regions);
>> -	}
>> +	} else
>> +		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
> 
> Since you have converted the hunk above to use dist->, you could do
> the same thing here. And the coding style dictates that you need {} on
> the else side as well.
sure

Thanks

Eric
> 
>>
>>  	if (vgic_has_its(kvm))
>>  		vgic_lpi_translation_cache_destroy(kvm);
>> @@ -362,6 +364,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>>  	vgic_flush_pending_lpis(vcpu);
>>  
>>  	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
>> +	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
>>  }
>>  
>>  /* To be called with kvm->lock held */
>> -- 
>> 2.21.3
>>
>>
> 
> Thanks,
> 
> 	M.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
