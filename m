Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3264C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 11:43:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E73A610CE
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 11:43:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E73A610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE1FA4B661;
	Thu,  1 Apr 2021 07:43:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NoMTjrSzTR8P; Thu,  1 Apr 2021 07:43:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB2934B65D;
	Thu,  1 Apr 2021 07:43:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF5984B659
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 07:43:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f8sL0r1kwmn6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 07:43:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 069814B5CD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 07:43:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617277433;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cc3k8MO13oibHy+9e3XEGxkpJb9ZoYiN6eARau7Wqk8=;
 b=cCHgmRSm6LfBhAnb6hq099KUNJWEM5Szm4ocX4Vk0QTSdDRY/ZjcMFL+UoxxojNoc3BX48
 Pd77+0//rRrz89lzaZHzaOvvL/oMQyVfmyo8xrxkVHC7pEbpkXkm4ZX8n4koZziVHtQbne
 RwtSBXykMR+DXvbzk2AiiSIZITxF2sU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-7sofkHCGOwurHwhGCrWEYQ-1; Thu, 01 Apr 2021 07:43:52 -0400
X-MC-Unique: 7sofkHCGOwurHwhGCrWEYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93E7B801814;
 Thu,  1 Apr 2021 11:43:50 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E04B716917;
 Thu,  1 Apr 2021 11:43:47 +0000 (UTC)
Subject: Re: [PATCH v4 1/8] KVM: arm64: vgic-v3: Fix some error codes when
 setting RDIST base
To: Marc Zyngier <maz@kernel.org>
References: <20210401085238.477270-1-eric.auger@redhat.com>
 <20210401085238.477270-2-eric.auger@redhat.com>
 <87wntmp99c.wl-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <419be8ac-6fbb-a712-a398-311ca68d52f9@redhat.com>
Date: Thu, 1 Apr 2021 13:43:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <87wntmp99c.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

On 4/1/21 12:52 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On Thu, 01 Apr 2021 09:52:31 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> KVM_DEV_ARM_VGIC_GRP_ADDR group doc says we should return
>> -EEXIST in case the base address of the redist is already set.
>> We currently return -EINVAL.
>>
>> However we need to return -EINVAL in case a legacy REDIST address
>> is attempted to be set while REDIST_REGIONS were set. This case
>> is discriminated by looking at the count field.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v1 -> v2:
>> - simplify the check sequence
>> ---
>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 15 +++++++--------
>>  1 file changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index 15a6c98ee92f0..013b737b658f8 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -791,10 +791,6 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>>  	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
>>  	int ret;
>>  
>> -	/* single rdist region already set ?*/
>> -	if (!count && !list_empty(rd_regions))
>> -		return -EINVAL;
>> -
>>  	/* cross the end of memory ? */
>>  	if (base + size < base)
>>  		return -EINVAL;
>> @@ -805,11 +801,14 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>>  	} else {
>>  		rdreg = list_last_entry(rd_regions,
>>  					struct vgic_redist_region, list);
>> -		if (index != rdreg->index + 1)
>> -			return -EINVAL;
>>  
>> -		/* Cannot add an explicitly sized regions after legacy region */
>> -		if (!rdreg->count)
>> +		if ((!count) != (!rdreg->count))
>> +			return -EINVAL; /* Mix REDIST and REDIST_REGION */
> 
> Urgh... The triple negation killed me. Can we come up with a more
> intuitive expression? Something like:

Yes sometimes I can be "different" ;-)
> 
> 		/* Don't mix single region and discrete redist regions */
> 		if (!count && rdreg->count)
> 			return -EINVAL;>
> Does it capture what you want to express?

yes it does!

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
