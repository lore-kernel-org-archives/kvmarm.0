Return-Path: <SRS0=9EBG=ZF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0
	tests=BUG6152_INVALID_DATE_TZ_ABSURD,INVALID_DATE_TZ_ABSURD,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BA8C43331
	for <kvmarm@archiver.kernel.org>; Wed, 13 Nov 2019 09:47:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC074222D0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Nov 2019 09:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC074222D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D26204B15D;
	Wed, 13 Nov 2019 04:47:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wErk9tyJSqwJ; Wed, 13 Nov 2019 04:47:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2FDA4B071;
	Wed, 13 Nov 2019 04:47:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7137D4B071
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Nov 2019 04:47:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HceyUXLnZ4gU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Nov 2019 04:47:05 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47BD84B06D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Nov 2019 04:47:05 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iUpEs-0007KN-22; Wed, 13 Nov 2019 10:47:02 +0100
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 12/36] irqchip/gic-v4.1: Implement the v4.1 flavour of
 VMAPP
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Wed, 13 Nov 2019 10:56:22 +0109
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <c9ef4c0f-bb34-82ff-c286-8430c1c7c583@huawei.com>
References: <20191027144234.8395-1-maz@kernel.org>
 <20191027144234.8395-13-maz@kernel.org>
 <c9ef4c0f-bb34-82ff-c286-8430c1c7c583@huawei.com>
Message-ID: <c3830faf33c7f8b983ad4863fe02b86b@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, eric.auger@redhat.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, tglx@linutronix.de,
 jason@lakedaemon.net, lorenzo.pieralisi@arm.com, andrew.murray@arm.com,
 jnair@marvell.com, rrichter@marvell.com, wanghaibin.wang@huawei.com,
 jiayanlei@huawei.com, liangboyan@hisilicon.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, jiayanlei@huawei.com,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Jayachandran C <jnair@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
 liangboyan@hisilicon.com, kvmarm@lists.cs.columbia.edu
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

On 2019-11-13 09:11, Zenghui Yu wrote:
> Hi Marc,
>
> On 2019/10/27 22:42, Marc Zyngier wrote:
>> The ITS VMAPP command gains some new fields with GICv4.1:
>> - a default doorbell, which allows a single doorbell to be used for
>>    all the VLPIs routed to a given VPE
>> - a pointer to the configuration table (instead of having it in a 
>> register
>>    that gets context switched)
>> - a flag indicating whether this is the first map or the last unmap 
>> for
>>    this particulat VPE
>> - a flag indicating whether the pending table is known to be zeroed, 
>> or not
>> Plumb in the new fields in the VMAPP builder, and add the map/unmap
>> refcounting so that the ITS can do the right thing.
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>
> [...]
>
>> @@ -605,19 +626,45 @@ static struct its_vpe 
>> *its_build_vmapp_cmd(struct its_node *its,
>>   					   struct its_cmd_block *cmd,
>>   					   struct its_cmd_desc *desc)
>>   {
>> -	unsigned long vpt_addr;
>> +	unsigned long vpt_addr, vconf_addr;
>>   	u64 target;
>> -
>> -	vpt_addr = 
>> virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->vpt_page));
>> -	target = desc->its_vmapp_cmd.col->target_address + 
>> its->vlpi_redist_offset;
>> +	bool alloc;
>>
>>   	its_encode_cmd(cmd, GITS_CMD_VMAPP);
>>   	its_encode_vpeid(cmd, desc->its_vmapp_cmd.vpe->vpe_id);
>>   	its_encode_valid(cmd, desc->its_vmapp_cmd.valid);
>> +
>> +	if (!desc->its_vmapp_cmd.valid) {
>> +		if (is_v4_1(its)) {
>> +			alloc = 
>> !atomic_dec_return(&desc->its_vmapp_cmd.vpe->vmapp_count);
>> +			its_encode_alloc(cmd, alloc);
>> +		}
>> +
>> +		goto out;
>> +	}
>> +
>> +	vpt_addr = 
>> virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->vpt_page));
>> +	target = desc->its_vmapp_cmd.col->target_address + 
>> its->vlpi_redist_offset;
>> +
>>   	its_encode_target(cmd, target);
>>   	its_encode_vpt_addr(cmd, vpt_addr);
>>   	its_encode_vpt_size(cmd, LPI_NRBITS - 1);
>>   +	if (!is_v4_1(its))
>> +		goto out;
>> +
>> +	vconf_addr = 
>> virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->its_vm->vprop_page));
>> +
>> +	alloc = 
>> atomic_inc_and_test(&desc->its_vmapp_cmd.vpe->vmapp_count);
>
> As the comment block on top of atomic_inc_and_test(atomic *v) says,
>
>  * Atomically increments @v by 1
>  * and returns true if the result is zero, or false for all
>  * other cases.
>  */
>
> We will always get the 'alloc' as false here, even if this is the
> first mapping of this vPE.  This is not as expected, I think.

As usual, a very good observation!

Indeed, I cocked up the logic here, as we need to test the value before
the increment (and not after). What we want is probably something like:

   alloc = !atomic_fetch_inc(&desc->its_vmapp_cmd.vpe->vmapp_count);

> And on the other hand, I wonder what is the reason for 'vmapp_count'
> to be atomic_t?

The rational is that we could end-up with multiple VMAPP commands 
emitted
in parallel, for example. That's probably not strictly necessary right 
now,
but I'm trying to be cautious.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
