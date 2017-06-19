From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 20/33] irqchip/gic-v3-its: Add VPE domain
 infrastructure
Date: Mon, 19 Jun 2017 14:54:21 +0100
Message-ID: <4874f84b-c71b-f916-4083-994cabcd0fd4@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-21-git-send-email-marc.zyngier@arm.com>
 <alpine.DEB.2.20.1702131138480.3619@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1702131138480.3619@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

[yeah, blast from the past. finally found some bandwidth to pick this up
again...]

On 13/02/17 10:40, Thomas Gleixner wrote:
> On Tue, 17 Jan 2017, Marc Zyngier wrote:
>> @@ -2266,6 +2294,8 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
>>  		    struct irq_domain *parent_domain)
>>  {
>>  	struct device_node *of_node;
>> +	struct its_node *its;
>> +	bool has_v4 = false;
>>  
>>  	its_parent = parent_domain;
>>  	of_node = to_of_node(handle);
>> @@ -2283,5 +2313,11 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
>>  	its_alloc_lpi_tables();
>>  	its_lpi_init(rdists->id_bits);
>>  
>> +	list_for_each_entry(its, &its_nodes, entry)
>> +		has_v4 |= its->is_v4;
> 
> Hmm, can you have mixed version its nodes? If not, you probably should have
> some sanity check (not necessarily here). If yes, then how does that work?

You definitely can have mixed versions. The trick is to not allow a
GICv4 operation on an interrupt that is not routed through a GICv4 ITS.
That's why the code is sprinkled with its->is_v4 tests in a number of
command handlers...

And yes, people have built this. Shrug...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
