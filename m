Return-Path: <SRS0=W8aC=VM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF969C7618F
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jul 2019 12:49:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 55094206B8
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jul 2019 12:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55094206B8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4A3C4A417;
	Mon, 15 Jul 2019 08:49:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gLuRZPYHQr9k; Mon, 15 Jul 2019 08:49:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D9104A4E1;
	Mon, 15 Jul 2019 08:49:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8493B4A418
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 08:49:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nCqz+wUyMDWd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jul 2019 08:49:01 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C50C4A417
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 08:49:01 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id EEE895BDD5044EDA5ADB;
 Mon, 15 Jul 2019 20:48:56 +0800 (CST)
Received: from [127.0.0.1] (10.133.216.73) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Mon, 15 Jul 2019
 20:48:49 +0800
Subject: Re: ARM/gic-v4: deadlock occurred
To: Marc Zyngier <marc.zyngier@arm.com>
References: <9efe0260-4a84-7489-ecdd-2e9561599320@huawei.com>
 <86lfzl9ofe.wl-marc.zyngier@arm.com>
 <0b413592-7d98-ebe8-35c5-da330f800326@huawei.com>
 <86a7fx9lg8.wl-marc.zyngier@arm.com>
 <4d60d130-b7ce-96cb-5f8a-11e83329601a@huawei.com>
 <868svg9igl.wl-marc.zyngier@arm.com>
 <dbbf516d-3326-a948-8617-db6b6ec0ceed@huawei.com>
 <20190713123704.2d8a308c@why>
 <2697d96e-8f84-6a45-521a-d2270b6be1eb@huawei.com>
 <a2f51bcf-3a31-7b60-6790-78bf3fa940b2@arm.com>
 <4051528c-e282-1a04-5fa6-befd147bdbf5@huawei.com>
 <d9015d8b-45d9-bd39-a451-1932518710e8@arm.com>
From: Guoheyi <guoheyi@huawei.com>
Message-ID: <e7f01ea8-c906-ad9f-56e7-5808abbfd67b@huawei.com>
Date: Mon, 15 Jul 2019 20:48:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <d9015d8b-45d9-bd39-a451-1932518710e8@arm.com>
X-Originating-IP: [10.133.216.73]
X-CFilter-Loop: Reflected
Cc: linux-kernel@vger.kernel.org, kvmarm <kvmarm@lists.cs.columbia.edu>
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


On 2019/7/15 19:13, Marc Zyngier wrote:
> On 15/07/2019 11:43, Guoheyi wrote:
>>
>> On 2019/7/15 17:07, Marc Zyngier wrote:
>>> On 15/07/2019 07:32, Guoheyi wrote:
>>>> Hi Marc,
>>>>
>>>> The issue only occurs after applying the vlpi_map_rework patches, and we
>>>> can see the patches only affect VM; it changes its_create_device() a
>>>> little so it may affect host booting in some ways, so I took the lazy
>>>> way to send it out for some insights.
>>>>
>>>> I am suspecting below code; if alloc_lpis == false, what will happen?
>>> If !alloc_lpis, then we don't allocate the lpi_map, which is the
>>> intended effect.
>>>
>>>> Anyway, I will investigate more on this.
>>>>
>>>>
>>>> 	if  (alloc_lpis)  {
>>>> 		lpi_map  =  its_lpi_alloc(nvecs,  &lpi_base,  &nr_lpis);
>>>> 		if  (lpi_map)
>>>> 			col_map  =  kcalloc(nr_lpis,  sizeof(*col_map),
>>>> 					GFP_KERNEL);
>>>> 	}  else  {
>>>> 		col_map  =  kcalloc(nr_ites,  sizeof(*col_map),  GFP_KERNEL);
>>>> 		nr_lpis  =  0;
>>>> 		lpi_base  =  0;
>>>> 	}
>>>> 	if  (its->is_v4)
>>>> 		vlpi_map  =  kcalloc(nr_lpis,  sizeof(*vlpi_map),  GFP_KERNEL);
>>>>
>>>> 	if  (!dev  ||  !itt  ||   !col_map  ||  (!lpi_map  &&  alloc_lpis)  ||
>>>> 	(!vlpi_map  &&  its->is_v4))  {
>>>> 		kfree(dev);
>>>> 		kfree(itt);
>>>> 		kfree(lpi_map);
>>>> 		kfree(col_map);
>>>> 		kfree(vlpi_map);
>>>> 		return  NULL;
>>>> 	}
>>> How does this relate to the patch posted in this discussion? The
>>> proposed changes turn the locking from a mutex into a raw_spinlock.
>> I'm testing the patchset in
>> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=irq/vlpi-map-rework,
>> not only the patch posted in the mail directly. The first patch
>> *"**irqchip/gic-v3-its: Make vlpi_map allocations atomic" works well in
>> our internal tree, and my new testing is against the other 3 patches in
>> your vlpi-map-rework branch, as I promised. I'm sorry if I didn't state
>> this clearly.
> Ah, I had completely forgot about this branch. As I said, it is
> completely untested. I'll see if I can get some brain bandwidth in the
> next couple of weeks to get back to it...
Yes, a bit too long ago...

And finally I found the panic is caused by this patch: 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=irq/vlpi-map-rework&id=fe3dd7e06ee0e82bade4f2a107ef6422e5c9021e

diff --git a/drivers/irqchip/irq-gic-v3-its.c 
b/drivers/irqchip/irq-gic-v3-its.c
index 18aa04b..6f55886 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2458,6 +2458,8 @@ static void its_free_device(struct its_device 
*its_dev)
      list_del(&its_dev->entry);
      raw_spin_unlock_irqrestore(&its_dev->its->lock, flags);
      kfree(its_dev->itt);
+    kfree(its_dev->event_map.lpi_map);
+    kfree(its_dev->event_map.col_map);
      kfree(its_dev);
  }

This patch causes double free for both lpi_map and col_map in 
its_irq_domain_free():

         if (!its_dev->shared &&
             bitmap_empty(its_dev->event_map.lpi_map,
                          its_dev->event_map.nr_lpis)) {
its_lpi_free(its_dev->event_map.lpi_map, ----> 
its_dev->event_map.lpi_map is freed
                              its_dev->event_map.lpi_base,
                              its_dev->event_map.nr_lpis);
                 kfree(its_dev->event_map.col_map);                ----> 
its_dev->event_map.col_map is freed

                 /* Unmap device/itt */
                 its_send_mapd(its_dev, 0);
                 its_free_device(its_dev);                         ----> 
lpi_map and col_map are freed again
         }

Thanks,

Heyi

>
> Thanks,
>
> 	M.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
