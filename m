Return-Path: <SRS0=1Ej7=XV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3307C4360C
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 15:34:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5149621D6C
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 15:34:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5149621D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDE544A715;
	Thu, 26 Sep 2019 11:34:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PuuTbnli3cSN; Thu, 26 Sep 2019 11:34:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66E4F4A716;
	Thu, 26 Sep 2019 11:34:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37BD84A714
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 11:34:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B7znh0VEtsnm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Sep 2019 11:34:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF5D14A712
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 11:34:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7860E28;
 Thu, 26 Sep 2019 08:34:16 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 702483F534; Thu, 26 Sep 2019 08:34:15 -0700 (PDT)
Subject: Re: [PATCH 03/35] irqchip/gic-v3-its: Allow LPI invalidation via the
 DirectLPI interface
To: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-4-maz@kernel.org>
 <92ff82ca-ebcb-8f5f-5063-313f65bbc5e3@huawei.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <fe2a5258-4a48-28d9-9cd5-793358ceb4eb@kernel.org>
Date: Thu, 26 Sep 2019 16:34:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <92ff82ca-ebcb-8f5f-5063-313f65bbc5e3@huawei.com>
Content-Language: en-US
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>
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

Hi Zenghui,

On 26/09/2019 15:57, Zenghui Yu wrote:
> Hi Marc,
> 
> I get one kernel panic with this patch on D05.

Ah, surprise! I haven't had time to test this on a D05 yet, such in a
hurry to push the damn thing out of the building...

> 
> (I don't have the GICv4.1 board at the moment. I have to wait for the
>   appropriate HW to do more tests.)
> 
> On 2019/9/24 2:25, Marc Zyngier wrote:
>> We currently don't make much use of the DirectLPI feature, and it would
>> be beneficial to do this more, if only because it becomes a mandatory
>> feature for GICv4.1.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   drivers/irqchip/irq-gic-v3-its.c | 51 +++++++++++++++++++++++---------
>>   1 file changed, 37 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index 58cb233cf138..c94eb287393b 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -175,6 +175,12 @@ static DEFINE_IDA(its_vpeid_ida);
>>   #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>>   #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
>>   
>> +static inline u32 its_get_event_id(struct irq_data *d)
>> +{
>> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>> +	return d->hwirq - its_dev->event_map.lpi_base;
>> +}
>> +
>>   static struct its_collection *dev_event_to_col(struct its_device *its_dev,
>>   					       u32 event)
>>   {
>> @@ -183,6 +189,13 @@ static struct its_collection *dev_event_to_col(struct its_device *its_dev,
>>   	return its->collections + its_dev->event_map.col_map[event];
>>   }
>>   
>> +static struct its_collection *irq_to_col(struct irq_data *d)
>> +{
>> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>> +
>> +	return dev_event_to_col(its_dev, its_get_event_id(d));
>> +}
>> +
> 
> irq_to_col uses device's event_map and col_map to get the target
> collection, yes it works well with device's LPI.
> But direct_lpi_inv also pass doorbells to it...
> 
> We don't allocate doorbells for any devices, instead for each vPE.

Hmm. Yes, you're right. It looks like I've been carried away on this
one. I'll have a look.

> 
> And see below,
> 
>>   static struct its_collection *valid_col(struct its_collection *col)
>>   {
>>   	if (WARN_ON_ONCE(col->target_address & GENMASK_ULL(15, 0)))
>> @@ -1031,12 +1044,6 @@ static void its_send_vinvall(struct its_node *its, struct its_vpe *vpe)
>>    * irqchip functions - assumes MSI, mostly.
>>    */
>>   
>> -static inline u32 its_get_event_id(struct irq_data *d)
>> -{
>> -	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>> -	return d->hwirq - its_dev->event_map.lpi_base;
>> -}
>> -
>>   static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
>>   {
>>   	irq_hw_number_t hwirq;
>> @@ -1081,12 +1088,28 @@ static void wait_for_syncr(void __iomem *rdbase)
>>   		cpu_relax();
>>   }
>>   
>> +static void direct_lpi_inv(struct irq_data *d)
>> +{
>> +	struct its_collection *col;
>> +	void __iomem *rdbase;
>> +
>> +	/* Target the redistributor this LPI is currently routed to */
>> +	col = irq_to_col(d);
>> +	rdbase = per_cpu_ptr(gic_rdists->rdist, col->col_id)->rd_base;
>> +	gic_write_lpir(d->hwirq, rdbase + GICR_INVLPIR);
>> +
>> +	wait_for_syncr(rdbase);
>> +}
>> +
>>   static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
>>   {
>>   	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>>   
>>   	lpi_write_config(d, clr, set);
>> -	its_send_inv(its_dev, its_get_event_id(d));
>> +	if (gic_rdists->has_direct_lpi && !irqd_is_forwarded_to_vcpu(d))
>> +		direct_lpi_inv(d);
>> +	else
>> +		its_send_inv(its_dev, its_get_event_id(d));
>>   }
>>   
>>   static void its_vlpi_set_doorbell(struct irq_data *d, bool enable)
>> @@ -2912,15 +2935,15 @@ static void its_vpe_send_cmd(struct its_vpe *vpe,
>>   
>>   static void its_vpe_send_inv(struct irq_data *d)
>>   {
>> -	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> -
>>   	if (gic_rdists->has_direct_lpi) {
>> -		void __iomem *rdbase;
>> -
>> -		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
>> -		gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_INVLPIR);
>> -		wait_for_syncr(rdbase);
>> +		/*
>> +		 * Don't mess about. Generating the invalidation is easily
>> +		 * done by using the parent irq_data, just like below.
>> +		 */
>> +		direct_lpi_inv(d->parent_data);
> 
> "GICv4-vpe"'s parent is "GICv3", not "ITS".  What do we expect with
> irq_data_get_irq_chip_data(parent's irq_data)?

Yup, terrible mix up. d->parent_data comes from the fact that we want to
invalidate the LPI and not d->hwirq (which is the VPEID). But doing so,
we also confuse direct_lpi_inv(), which expects to find meaningful data
(the its_dev) as chip data (and the irq_to_col doesn't help either).

To sum it up, the whole thing is busted, I'll have a brown paper bag,
thank you very much... :-(. Let me work on a fix.

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
