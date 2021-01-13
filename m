Return-Path: <SRS0=/ONs=GQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E14C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 17:18:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AFE8823441
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 17:18:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFE8823441
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 482614B1CA;
	Wed, 13 Jan 2021 12:18:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jXJxbXLkda7u; Wed, 13 Jan 2021 12:18:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39C644B17D;
	Wed, 13 Jan 2021 12:18:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 508BD4B179
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 12:18:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0BUw0k+pn9Ri for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2021 12:18:52 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7897B4B17D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 12:18:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610558332;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=V0lROAkdY9acdw8Y4RAB+mGlGxEAhxNtbJbaRarkeyY=;
 b=XVDF0QspBTzJ0FfxPXRSeqTY4ejoSd2D2SgLFA81Y+1qF0IsgH51wqKbMqDtkTdghOt9O8
 1l2pALPsO7PGql/bXG73Q3BvIADxckQLXBTMY19TB6MgFLdWU9bVP9o9RwCbnfIRubsebo
 oAlkOD+tocBINHar3Sk0b9rMIlnHdnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-bSqzembON_KnranJUeX09A-1; Wed, 13 Jan 2021 12:18:48 -0500
X-MC-Unique: bSqzembON_KnranJUeX09A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D70FD56BF4;
 Wed, 13 Jan 2021 17:18:46 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40AA95D9DD;
 Wed, 13 Jan 2021 17:18:44 +0000 (UTC)
Subject: Re: [PATCH 3/9] KVM: arm64: vgic-v3: Fix error handling in
 vgic_v3_set_redist_base()
To: Marc Zyngier <maz@kernel.org>
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-4-eric.auger@redhat.com> <87a6tyoseo.wl-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <3b073d69-dd4a-3f82-3a96-5361dabbce80@redhat.com>
Date: Wed, 13 Jan 2021 18:18:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87a6tyoseo.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

On 12/28/20 4:35 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On Sat, 12 Dec 2020 18:50:04 +0000,
> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> vgic_register_all_redist_iodevs may succeed while
>> vgic_register_all_redist_iodevs fails. For example this can happen
> 
> The same function cannot both fail and succeed ;-) Can you shed some
> light on what you had in mind?

Damn, I meant vgic_v3_insert_redist_region() can be successful and then
vgic_register_all_redist_iodevs() fails due to detection of overlap.
> 
>> while adding a redistributor region overlapping a dist region. The
>> failure only is detected on vgic_register_all_redist_iodevs when
>> vgic_v3_check_base() gets called.
>>
>> In such a case, remove the newly added redistributor region and free
>> it.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index 8e8a862def76..581f0f490000 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -866,8 +866,14 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
>>  	 * afterwards will register the iodevs when needed.
>>  	 */
>>  	ret = vgic_register_all_redist_iodevs(kvm);
>> -	if (ret)
>> +	if (ret) {
>> +		struct vgic_redist_region *rdreg =
>> +			vgic_v3_rdist_region_from_index(kvm, index);
>> +
> 
> nit: consider splitting declaration and assignment so that we avoid
> the line split if you insist on the 80 character limit.
Sure

Thanks

Eric
> 
>> +		list_del(&rdreg->list);
>> +		kfree(rdreg);
>>  		return ret;
>> +	}
>>  
>>  	return 0;
>>  }
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
