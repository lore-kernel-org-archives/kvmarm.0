Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCC0C2D0C3
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 14:49:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71B5B2176D
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 14:49:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71B5B2176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD524A5A0;
	Wed, 18 Dec 2019 09:49:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HsP1Sj+5ttBJ; Wed, 18 Dec 2019 09:48:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C56DD4A531;
	Wed, 18 Dec 2019 09:48:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2914A4BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 09:48:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GZy9PQi+klQD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 09:48:57 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A3284A3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 09:48:57 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ihadC-0002xn-Ku; Wed, 18 Dec 2019 15:48:54 +0100
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 22/36] irqchip/gic-v4.1: Advertise support v4.1 to KVM
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Wed, 18 Dec 2019 14:48:54 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <14462a79-fc0b-b8e5-115a-dfb505351acb@huawei.com>
References: <20191027144234.8395-1-maz@kernel.org>
 <20191027144234.8395-23-maz@kernel.org>
 <14462a79-fc0b-b8e5-115a-dfb505351acb@huawei.com>
Message-ID: <c9f8f2590662cfe9e28e90cf8f79e708@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, eric.auger@redhat.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, tglx@linutronix.de,
 jason@lakedaemon.net, lorenzo.pieralisi@arm.com, andrew.murray@arm.com,
 jnair@marvell.com, rrichter@marvell.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
 Robert Richter <rrichter@marvell.com>, Jayachandran C <jnair@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
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

On 2019-11-01 12:55, Zenghui Yu wrote:
> Hi Marc,
>
> On 2019/10/27 22:42, Marc Zyngier wrote:
>> Tell KVM that we support v4.1. Nothing uses this information so far.
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   drivers/irqchip/irq-gic-v3-its.c       | 9 ++++++++-
>>   drivers/irqchip/irq-gic-v3.c           | 1 +
>>   include/linux/irqchip/arm-gic-common.h | 2 ++
>>   3 files changed, 11 insertions(+), 1 deletion(-)
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index df259e202482..6483f8051b3e 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -4580,6 +4580,7 @@ int __init its_init(struct fwnode_handle 
>> *handle, struct rdists *rdists,
>>   	struct device_node *of_node;
>>   	struct its_node *its;
>>   	bool has_v4 = false;
>> +	bool has_v4_1 = false;
>>   	int err;
>>
>>   	gic_rdists = rdists;
>> @@ -4600,8 +4601,14 @@ int __init its_init(struct fwnode_handle 
>> *handle, struct rdists *rdists,
>>   	if (err)
>>   		return err;
>>   -	list_for_each_entry(its, &its_nodes, entry)
>> +	list_for_each_entry(its, &its_nodes, entry) {
>>   		has_v4 |= is_v4(its);
>> +		has_v4_1 |= is_v4_1(its);
>> +	}
>> +
>> +	/* Don't bother with inconsistent systems */
>> +	if (WARN_ON(!has_v4_1 && rdists->has_rvpeid))
>> +		rdists->has_rvpeid = false;
>>
>>   	if (has_v4 & rdists->has_vlpis) {
>>   		if (its_init_vpe_domain() ||
>> diff --git a/drivers/irqchip/irq-gic-v3.c 
>> b/drivers/irqchip/irq-gic-v3.c
>> index f0d33ac64a99..94dddfb21076 100644
>> --- a/drivers/irqchip/irq-gic-v3.c
>> +++ b/drivers/irqchip/irq-gic-v3.c
>> @@ -1758,6 +1758,7 @@ static void __init 
>> gic_of_setup_kvm_info(struct device_node *node)
>>   		gic_v3_kvm_info.vcpu = r;
>>
>>   	gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
>> +	gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
>
> Also set gic_v3_kvm_info.has_v4_1 in gic_acpi_setup_kvm_info().

Indeed. Now fixed.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
