From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 07/33] irqchip/gic-v3-its: Macro-ize
 its_send_single_command
Date: Mon, 19 Jun 2017 16:38:32 +0100
Message-ID: <87b7d718-6550-8ffd-38c6-d1ed990f0f5e@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-8-git-send-email-marc.zyngier@arm.com>
 <44927f3a-a1db-f7b8-b9d6-53f0dd7a4ac0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F07BC40A69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jun 2017 11:34:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M+SIOKvUOENy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jun 2017 11:34:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9268040A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jun 2017 11:34:05 -0400 (EDT)
In-Reply-To: <44927f3a-a1db-f7b8-b9d6-53f0dd7a4ac0@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/02/17 06:15, Auger Eric wrote:
> 
> 
> On 17/01/2017 11:20, Marc Zyngier wrote:
>> Most ITS commands do operate on a collection object, and require
>> a SYNC command to be performed on that collection in order to
>> guarantee the execution of the first command.
>>
>> With GICv4 ITS, another set of commands perform similar operations
>> on a VPE object, and a VSYNC operations must be executed to guarantee
>> their execution.
>>
>> Given the similarities (post a command, perform a synchronization
>> operation on a sync object), it makes sense to reuse the same
>> mechanism for both class of commands.
>>
>> Let's start with turning its_send_single_command into a huge macro
>> that performs the bulk of the work, and a set of helpers that
>> make this macro useeable for the GICv3 ITS commands.
> s/useeable/usable
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c | 82 ++++++++++++++++++++++------------------
>>  1 file changed, 45 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index 99f6130..520b764 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -484,43 +484,51 @@ static void its_wait_for_range_completion(struct its_node *its,
>>  	}
>>  }
>>  
>> -static void its_send_single_command(struct its_node *its,
>> -				    its_cmd_builder_t builder,
>> -				    struct its_cmd_desc *desc)
>> -{
>> -	struct its_cmd_block *cmd, *sync_cmd, *next_cmd;
>> -	struct its_collection *sync_col;
>> -	unsigned long flags;
>> -
>> -	raw_spin_lock_irqsave(&its->lock, flags);
>> -
>> -	cmd = its_allocate_entry(its);
>> -	if (!cmd) {		/* We're soooooo screewed... */
>> -		pr_err_ratelimited("ITS can't allocate, dropping command\n");
>> -		raw_spin_unlock_irqrestore(&its->lock, flags);
>> -		return;
>> -	}
>> -	sync_col = builder(cmd, desc);
>> -	its_flush_cmd(its, cmd);
>> -
>> -	if (sync_col) {
>> -		sync_cmd = its_allocate_entry(its);
>> -		if (!sync_cmd) {
>> -			pr_err_ratelimited("ITS can't SYNC, skipping\n");
>> -			goto post;
>> -		}
>> -		its_encode_cmd(sync_cmd, GITS_CMD_SYNC);
>> -		its_encode_target(sync_cmd, sync_col->target_address);
>> -		its_fixup_cmd(sync_cmd);
>> -		its_flush_cmd(its, sync_cmd);
>> -	}
>> -
>> -post:
>> -	next_cmd = its_post_commands(its);
>> -	raw_spin_unlock_irqrestore(&its->lock, flags);
>> -
>> -	its_wait_for_range_completion(its, cmd, next_cmd);
>> -}
>> +#define __its_send_single_cmd(name, buildtype, synctype, buildfn)	\
>> +void name(struct its_node *its,						\
>> +	  buildtype builder,						\
>> +	  struct its_cmd_desc *desc)					\
>> +{									\
>> +	struct its_cmd_block *cmd, *sync_cmd, *next_cmd;		\
>> +	synctype *sync_obj;						\
>> +	unsigned long flags;						\
>> +									\
>> +	raw_spin_lock_irqsave(&its->lock, flags);			\
>> +									\
>> +	cmd = its_allocate_entry(its);					\
> Not related to this patch but I see that its_allocate_entry can spin for
> up to 1s waiting for the ITS queue to drain. What are the circumstances
> that can cause this? Also isn't it an issue in that case to hold the
> spinlock for so long?

here's how this can happen: SW has filled the queue with commands, and
the queue doesn't drain. This is either the result of illegal commands
(and the queue has stalled), or a HW bug (and the queue has stalled).

In either cases, there is not much you can do to rescue your system
(although we could start to support the new stall model once actual
implementations are available).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
