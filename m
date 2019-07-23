Return-Path: <SRS0=tngP=VU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648C8C7618B
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 12:48:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1E802239D
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 12:47:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1E802239D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 757ED4A583;
	Tue, 23 Jul 2019 08:47:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WMHaSun1-za2; Tue, 23 Jul 2019 08:47:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 495C74A53F;
	Tue, 23 Jul 2019 08:47:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20EEF4A53F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 08:47:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AHfa5QCwBwMv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jul 2019 08:47:55 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D35F74A52E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 08:47:55 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 0FA4881F12;
 Tue, 23 Jul 2019 12:47:55 +0000 (UTC)
Received: from [10.36.117.239] (ovpn-117-239.ams2.redhat.com [10.36.117.239])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D4A419C58;
 Tue, 23 Jul 2019 12:47:49 +0000 (UTC)
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI
 translation cache on specific commands
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-5-marc.zyngier@arm.com>
 <9ff329a3-44f2-1de3-b6cc-58ed38a63665@redhat.com>
 <1a78d52c-7a31-8981-230b-abe85d11b8ec@arm.com>
 <8b5e029c-a08f-b86b-7021-5d68ec05d3bd@redhat.com>
 <ffb327bf-b05c-b7ca-d509-2a98dea37fdf@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <166921d3-39c4-d13c-bdee-dd404d468e7e@redhat.com>
Date: Tue, 23 Jul 2019 14:47:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <ffb327bf-b05c-b7ca-d509-2a98dea37fdf@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.25]); Tue, 23 Jul 2019 12:47:55 +0000 (UTC)
Cc: "Raslan, KarimAllah" <karahmed@amazon.de>, "Saidi,
 Ali" <alisaidi@amazon.com>
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

On 7/23/19 2:43 PM, Marc Zyngier wrote:
> On 23/07/2019 13:25, Auger Eric wrote:
>> Hi Marc,
>>
>> On 7/22/19 12:54 PM, Marc Zyngier wrote:
>>> Hi Eric,
>>>
>>> On 01/07/2019 13:38, Auger Eric wrote:
>>>> Hi Marc,
>>>>
>>>> On 6/11/19 7:03 PM, Marc Zyngier wrote:
>>>>> The LPI translation cache needs to be discarded when an ITS command
>>>>> may affect the translation of an LPI (DISCARD and MAPD with V=0) or
>>>>> the routing of an LPI to a redistributor with disabled LPIs (MOVI,
>>>>> MOVALL).
>>>>>
>>>>> We decide to perform a full invalidation of the cache, irrespective
>>>>> of the LPI that is affected. Commands are supposed to be rare enough
>>>>> that it doesn't matter.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>> ---
>>>>>  virt/kvm/arm/vgic/vgic-its.c | 8 ++++++++
>>>>>  1 file changed, 8 insertions(+)
>>>>>
>>>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>>>> index 9b6b66204b97..5254bb762e1b 100644
>>>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>>>> @@ -733,6 +733,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
>>>>>  		 * don't bother here since we clear the ITTE anyway and the
>>>>>  		 * pending state is a property of the ITTE struct.
>>>>>  		 */
>>>>> +		vgic_its_invalidate_cache(kvm);
>>>>> +
>>>>>  		its_free_ite(kvm, ite);
>>>>>  		return 0;
>>>>>  	}
>>>>> @@ -768,6 +770,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>>>>>  	ite->collection = collection;
>>>>>  	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>>>>>  
>>>>> +	vgic_its_invalidate_cache(kvm);
>>>>> +
>>>>>  	return update_affinity(ite->irq, vcpu);
>>>>>  }
>>>>>  
>>>>> @@ -996,6 +1000,8 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
>>>>>  	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
>>>>>  		its_free_ite(kvm, ite);
>>>>>  
>>>>> +	vgic_its_invalidate_cache(kvm);
>>>>> +
>>>>>  	list_del(&device->dev_list);
>>>>>  	kfree(device);
>>>>>  }
>>>>> @@ -1249,6 +1255,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>>>>>  		vgic_put_irq(kvm, irq);
>>>>>  	}
>>>>>  
>>>>> +	vgic_its_invalidate_cache(kvm);
>>>> All the commands are executed with the its_lock held. Now we don't take
>>>> it anymore on the fast cache injection path. Don't we have a window
>>>> where the move has been applied at table level and the cache is not yet
>>>> invalidated? Same question for vgic_its_free_device().
>>>
>>> There is definitely a race, but that race is invisible from the guest's
>>> perspective. The guest can only assume that the command has taken effect
>>> once a SYNC command has been executed, and it cannot observe that the
>>> SYNC command has been executed before we have invalidated the cache.
>>>
>>> Does this answer your question?
>>
>> OK make sense. Thank you for the clarification
>>
>> Another question, don't we need to invalidate the cache on  MAPC V=0 as
>> well? Removing the mapping of the collection results in interrupts
>> belonging to that collection being ignored. If we don't flush the
>> pending bit will be set?
> 
> Yup, that's a good point. I think i had that at some point, and ended up 
> dropping it, probably missing the point that the interrupt would be made 
> pending.
> 
> I'll add this:
> 
> @@ -1218,6 +1218,7 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
>  
>  	if (!valid) {
>  		vgic_its_free_collection(its, coll_id);
> +		vgic_its_invalidate_cache(kvm);
>  	} else {
>  		collection = find_collection(its, coll_id);
>  
Yep, with that change feel free to add my R-b

Reviewed-by: Eric Auger <eric.auger@redhat.com>

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
