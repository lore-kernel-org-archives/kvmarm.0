From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v4 5/5] KVM: eventfd: add irq bypass consumer management
Date: Mon, 10 Aug 2015 10:44:14 +0200
Message-ID: <55C8645E.6060505@linaro.org>
References: <1438622444-25444-1-git-send-email-eric.auger@linaro.org>	
 <1438622444-25444-6-git-send-email-eric.auger@linaro.org>
 <1438978155.4023.263.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 704575A58A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 04:31:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nVo4qTYeSiLP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 04:31:57 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CF525A589
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 04:31:57 -0400 (EDT)
Received: by wicja10 with SMTP id ja10so28171511wic.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 01:44:57 -0700 (PDT)
In-Reply-To: <1438978155.4023.263.camel@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: feng.wu@intel.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, joro@8bytes.org, mtosatti@redhat.com, linux-kernel@vger.kernel.org, avi.kivity@gmail.com, pbonzini@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,
On 08/07/2015 10:09 PM, Alex Williamson wrote:
> On Mon, 2015-08-03 at 19:20 +0200, Eric Auger wrote:
>> This patch adds the registration/unregistration of an
>> irq_bypass_consumer on irqfd assignment/deassignment.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> Signed-off-by: Feng Wu <feng.wu@intel.com>
>>
>> ---
>>
>> v2 -> v3 (Feng Wu):
>> - Use kvm_arch_irq_bypass_start
>> - Remove kvm_arch_irq_bypass_update
>> - Add member 'struct irq_bypass_producer *producer' in
>>   'struct kvm_kernel_irqfd', it is needed by posted interrupt.
>> - Remove 'irq_bypass_unregister_consumer' in kvm_irqfd_deassign()
>>
>> v1 -> v2:
>> - populate of kvm and gsi removed
>> - unregister the consumer on irqfd_shutdown
>> ---
>>  include/linux/kvm_irqfd.h |  2 ++
>>  virt/kvm/eventfd.c        | 10 ++++++++++
>>  2 files changed, 12 insertions(+)
>>
>> diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
>> index f926b39..0c1de05 100644
>> --- a/include/linux/kvm_irqfd.h
>> +++ b/include/linux/kvm_irqfd.h
>> @@ -64,6 +64,8 @@ struct kvm_kernel_irqfd {
>>  	struct list_head list;
>>  	poll_table pt;
>>  	struct work_struct shutdown;
>> +	struct irq_bypass_consumer consumer;
>> +	struct irq_bypass_producer *producer;
>>  };
>>  
>>  #endif /* __LINUX_KVM_IRQFD_H */
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 647ffb8..08855de 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -35,6 +35,7 @@
>>  #include <linux/srcu.h>
>>  #include <linux/slab.h>
>>  #include <linux/seqlock.h>
>> +#include <linux/irqbypass.h>
>>  #include <trace/events/kvm.h>
>>  
>>  #include <kvm/iodev.h>
>> @@ -140,6 +141,7 @@ irqfd_shutdown(struct work_struct *work)
>>  	/*
>>  	 * It is now safe to release the object's resources
>>  	 */
>> +	irq_bypass_unregister_consumer(&irqfd->consumer);
>>  	eventfd_ctx_put(irqfd->eventfd);
>>  	kfree(irqfd);
>>  }
>> @@ -380,6 +382,14 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>>  	 */
>>  	fdput(f);
>>  
>> +	irqfd->consumer.token = (void *)irqfd->eventfd;
>> +	irqfd->consumer.add_producer = kvm_arch_irq_bypass_add_producer;
>> +	irqfd->consumer.del_producer = kvm_arch_irq_bypass_del_producer;
>> +	irqfd->consumer.stop = kvm_arch_irq_bypass_stop;
>> +	irqfd->consumer.start = kvm_arch_irq_bypass_start;
>> +	ret = irq_bypass_register_consumer(&irqfd->consumer);
>> +	WARN_ON(ret);
> 
> This seems like a lazy way to handle this error.  What is the stack
> trace from this WARN_ON going to tell us that we didn't already know?
> If we get the WARN_ON, it's probably means that an incompatible producer
> registered the token first.  It means we can't do bypass, but it doesn't
> tell us anything about whether bypass is or is not enabled.  Wouldn't a
> pr_info/debug() suffice for that?  Thanks,

Sure I will output some more relevant traces.

Thanks

Eric
> 
> Alex
> 
>> +
>>  	return 0;
>>  
>>  fail:
> 
> 
> 
