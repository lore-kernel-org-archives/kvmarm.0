Return-Path: <SRS0=FDwM=5C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284BEC0044D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 02:02:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A94F220679
	for <kvmarm@archiver.kernel.org>; Tue, 17 Mar 2020 02:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A94F220679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4A794A4BE;
	Mon, 16 Mar 2020 22:02:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sKMmt43loE8p; Mon, 16 Mar 2020 22:02:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9FFE4A4C0;
	Mon, 16 Mar 2020 22:02:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E04044A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 22:02:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rkMUffWo4ght for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Mar 2020 22:02:40 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60EFC40456
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2020 22:02:39 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 23FA33684FC3E1E40F3F;
 Tue, 17 Mar 2020 10:02:35 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 17 Mar 2020
 10:02:14 +0800
Subject: Re: [PATCH v5 09/23] irqchip/gic-v4.1: Add initial SGI configuration
To: Auger Eric <eric.auger@redhat.com>, Marc Zyngier <maz@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-10-maz@kernel.org>
 <4ccc36c5-1e0a-b4f6-b014-8691fdb50c84@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <aed58073-0494-ee38-4d2f-287888ed8840@huawei.com>
Date: Tue, 17 Mar 2020 10:02:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <4ccc36c5-1e0a-b4f6-b014-8691fdb50c84@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
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

Hi Eric,

On 2020/3/17 1:53, Auger Eric wrote:
> Hi Marc,
> 
> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>> The GICv4.1 ITS has yet another new command (VSGI) which allows
>> a VPE-targeted SGI to be configured (or have its pending state
>> cleared). Add support for this command and plumb it into the
>> activate irqdomain callback so that it is ready to be used.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>>   drivers/irqchip/irq-gic-v3-its.c   | 79 +++++++++++++++++++++++++++++-
>>   include/linux/irqchip/arm-gic-v3.h |  3 +-
>>   2 files changed, 80 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index 112b452fcb40..e0db3f906f87 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -380,6 +380,15 @@ struct its_cmd_desc {
>>   		struct {
>>   			struct its_vpe *vpe;
>>   		} its_invdb_cmd;
>> +
>> +		struct {
>> +			struct its_vpe *vpe;
>> +			u8 sgi;
>> +			u8 priority;
>> +			bool enable;
>> +			bool group;
>> +			bool clear;
>> +		} its_vsgi_cmd;
>>   	};
>>   };
>>   
>> @@ -528,6 +537,31 @@ static void its_encode_db(struct its_cmd_block *cmd, bool db)
>>   	its_mask_encode(&cmd->raw_cmd[2], db, 63, 63);
>>   }
>>   
>> +static void its_encode_sgi_intid(struct its_cmd_block *cmd, u8 sgi)
>> +{
>> +	its_mask_encode(&cmd->raw_cmd[0], sgi, 35, 32);
>> +}
>> +
>> +static void its_encode_sgi_priority(struct its_cmd_block *cmd, u8 prio)
>> +{
>> +	its_mask_encode(&cmd->raw_cmd[0], prio >> 4, 23, 20);
>> +}
>> +
>> +static void its_encode_sgi_group(struct its_cmd_block *cmd, bool grp)
>> +{
>> +	its_mask_encode(&cmd->raw_cmd[0], grp, 10, 10);
>> +}
>> +
>> +static void its_encode_sgi_clear(struct its_cmd_block *cmd, bool clr)
>> +{
>> +	its_mask_encode(&cmd->raw_cmd[0], clr, 9, 9);
>> +}
>> +
>> +static void its_encode_sgi_enable(struct its_cmd_block *cmd, bool en)
>> +{
>> +	its_mask_encode(&cmd->raw_cmd[0], en, 8, 8);
>> +}
>> +
>>   static inline void its_fixup_cmd(struct its_cmd_block *cmd)
>>   {
>>   	/* Let's fixup BE commands */
>> @@ -893,6 +927,26 @@ static struct its_vpe *its_build_invdb_cmd(struct its_node *its,
>>   	return valid_vpe(its, desc->its_invdb_cmd.vpe);
>>   }
>>   
>> +static struct its_vpe *its_build_vsgi_cmd(struct its_node *its,
>> +					  struct its_cmd_block *cmd,
>> +					  struct its_cmd_desc *desc)
>> +{
>> +	if (WARN_ON(!is_v4_1(its)))
>> +		return NULL;
>> +
>> +	its_encode_cmd(cmd, GITS_CMD_VSGI);
>> +	its_encode_vpeid(cmd, desc->its_vsgi_cmd.vpe->vpe_id);
>> +	its_encode_sgi_intid(cmd, desc->its_vsgi_cmd.sgi);
>> +	its_encode_sgi_priority(cmd, desc->its_vsgi_cmd.priority);
>> +	its_encode_sgi_group(cmd, desc->its_vsgi_cmd.group);
>> +	its_encode_sgi_clear(cmd, desc->its_vsgi_cmd.clear);
>> +	its_encode_sgi_enable(cmd, desc->its_vsgi_cmd.enable);
>> +
>> +	its_fixup_cmd(cmd);
>> +
>> +	return valid_vpe(its, desc->its_vsgi_cmd.vpe);
>> +}
>> +
>>   static u64 its_cmd_ptr_to_offset(struct its_node *its,
>>   				 struct its_cmd_block *ptr)
>>   {
>> @@ -3870,6 +3924,21 @@ static struct irq_chip its_vpe_4_1_irq_chip = {
>>   	.irq_set_vcpu_affinity	= its_vpe_4_1_set_vcpu_affinity,
>>   };
>>   
>> +static void its_configure_sgi(struct irq_data *d, bool clear)
>> +{
>> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> +	struct its_cmd_desc desc;
>> +
>> +	desc.its_vsgi_cmd.vpe = vpe;
>> +	desc.its_vsgi_cmd.sgi = d->hwirq;
>> +	desc.its_vsgi_cmd.priority = vpe->sgi_config[d->hwirq].priority;
>> +	desc.its_vsgi_cmd.enable = vpe->sgi_config[d->hwirq].enabled;
>> +	desc.its_vsgi_cmd.group = vpe->sgi_config[d->hwirq].group;
>> +	desc.its_vsgi_cmd.clear = clear;
>> +
>> +	its_send_single_vcommand(find_4_1_its(), its_build_vsgi_cmd, &desc);
> I see we pick up the first 4.1 ITS with find_4_1_its(). Can it happen
> that not all of them have a mapping for that vPEID and if so we should
> rather use one that has this mapping?

It can't happen in GICv4.1, and you may find the answer in patch #16
("Eagerly vmap vPEs").  I also failed to follow this logic the first
time looking at it [*], so I think it may worth adding some comments
on top of find_4_1_its()?

[*] 
https://lore.kernel.org/lkml/c94061be-d029-69c8-d34f-4d21081d5aba@huawei.com/

> 
> The spec says:
> The ITS controls must only be used on an ITS that has a mapping for that
> vPEID.
> Where multiple ITSs have a mapping for the vPEID, any ITS with a mapping
> may be used.
> 
>> +}
>> +
>>   static int its_sgi_set_affinity(struct irq_data *d,
>>   				const struct cpumask *mask_val,
>>   				bool force)
>> @@ -3915,13 +3984,21 @@ static void its_sgi_irq_domain_free(struct irq_domain *domain,
>>   static int its_sgi_irq_domain_activate(struct irq_domain *domain,
>>   				       struct irq_data *d, bool reserve)
>>   {
>> +	/* Write out the initial SGI configuration */
>> +	its_configure_sgi(d, false);
>>   	return 0;
>>   }
>>   
>>   static void its_sgi_irq_domain_deactivate(struct irq_domain *domain,
>>   					  struct irq_data *d)
>>   {
>> -	/* Nothing to do */
>> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> +
>> +	/* First disable the SGI */
>> +	vpe->sgi_config[d->hwirq].enabled = false;
>> +	its_configure_sgi(d, false);
>> +	/* Now clear the potential pending bit (yes, this is clunky) */
> nit: Without carefuly reading the VSGI cmd notes, it is difficult to
> understand why those 2 steps are needed: maybe replace this comment by
> something like:
> to change the config, clear must be set to false. Then clear is set and
> this leaves the config unchanged. Both steps cannot be done concurrently.
> 
> "

I think it makes sense.


Thanks,
Zenghui

>> +	its_configure_sgi(d, true);
>>   }
>>   
>>   static struct irq_domain_ops its_sgi_domain_ops = {
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index b28acfa71f82..fd3be49ac9a5 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -502,8 +502,9 @@
>>   #define GITS_CMD_VMAPTI			GITS_CMD_GICv4(GITS_CMD_MAPTI)
>>   #define GITS_CMD_VMOVI			GITS_CMD_GICv4(GITS_CMD_MOVI)
>>   #define GITS_CMD_VSYNC			GITS_CMD_GICv4(GITS_CMD_SYNC)
>> -/* VMOVP and INVDB are the odd ones, as they dont have a physical counterpart */
>> +/* VMOVP, VSGI and INVDB are the odd ones, as they dont have a physical counterpart */
>>   #define GITS_CMD_VMOVP			GITS_CMD_GICv4(2)
>> +#define GITS_CMD_VSGI			GITS_CMD_GICv4(3)
>>   #define GITS_CMD_INVDB			GITS_CMD_GICv4(0xe)
>>   
>>   /*
>>
> Thanks
> 
> Eric
> 
> 
> .
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
