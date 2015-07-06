From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 16/17] KVM: eventfd: add irq bypass consumer management
Date: Mon, 06 Jul 2015 13:19:46 +0200
Message-ID: <559A6452.7030303@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-17-git-send-email-eric.auger@linaro.org>
 <E959C4978C3B6342920538CF579893F0025EB7C5@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 276FC57633
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 07:08:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jkeExXrD74cS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 07:08:41 -0400 (EDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C32E57632
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 07:08:40 -0400 (EDT)
Received: by wgqq4 with SMTP id q4so137411529wgq.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 04:20:07 -0700 (PDT)
In-Reply-To: <E959C4978C3B6342920538CF579893F0025EB7C5@SHSMSX104.ccr.corp.intel.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Wu, Feng" <feng.wu@intel.com>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Feng,
On 07/06/2015 09:55 AM, Wu, Feng wrote:
> 
> 
>> -----Original Message-----
>> From: Eric Auger [mailto:eric.auger@linaro.org]
>> Sent: Thursday, July 02, 2015 9:17 PM
>> To: eric.auger@st.com; eric.auger@linaro.org;
>> linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
>> kvm@vger.kernel.org; christoffer.dall@linaro.org; marc.zyngier@arm.com;
>> alex.williamson@redhat.com; pbonzini@redhat.com; avi.kivity@gmail.com;
>> mtosatti@redhat.com; Wu, Feng; joro@8bytes.org;
>> b.reynal@virtualopensystems.com
>> Cc: linux-kernel@vger.kernel.org; patches@linaro.org
>> Subject: [RFC 16/17] KVM: eventfd: add irq bypass consumer management
>>
>> This patch adds the registration/unregistration of an
>> irq_bypass_consumer on irqfd assignment/deassignment.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  virt/kvm/eventfd.c | 22 +++++++++++++++++++---
>>  1 file changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index f3da161..425a47b 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -34,6 +34,7 @@
>>  #include <linux/srcu.h>
>>  #include <linux/slab.h>
>>  #include <linux/seqlock.h>
>> +#include <linux/irqbypass.h>
>>  #include <trace/events/kvm.h>
>>
>>  #include <kvm/iodev.h>
>> @@ -93,6 +94,7 @@ struct _irqfd {
>>  	struct list_head list;
>>  	poll_table pt;
>>  	struct work_struct shutdown;
>> +	struct irq_bypass_consumer *cons;
>>  };
>>
>>  static struct workqueue_struct *irqfd_cleanup_wq;
>> @@ -429,7 +431,21 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd
>> *args)
>>  	 */
>>  	fdput(f);
>>
>> -	/* irq_bypass_register_consumer(); */
>> +	irqfd->cons = kzalloc(sizeof(struct irq_bypass_consumer),
>> +			      GFP_KERNEL);
>> +	if (!irqfd->cons) {
>> +		ret = -ENOMEM;
>> +		goto fail;
>> +	}
>> +	irqfd->cons->token = (void *)irqfd->eventfd;
>> +	irqfd->cons->gsi = irqfd->gsi;
>> +	irqfd->cons->kvm = kvm;
>> +	irqfd->cons->add_producer = kvm_arch_add_producer;
>> +	irqfd->cons->del_producer = kvm_arch_del_producer;
>> +	irqfd->cons->stop_consumer = kvm_arch_stop_consumer;
>> +	irqfd->cons->resume_consumer = kvm_arch_resume_consumer;
>> +	ret = irq_bypass_register_consumer(irqfd->cons);
>> +	WARN_ON(ret);
>>
>>  	return 0;
>>
>> @@ -530,8 +546,6 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd
>> *args)
>>  	struct _irqfd *irqfd, *tmp;
>>  	struct eventfd_ctx *eventfd;
>>
>> -	/* irq_bypass_unregister_consumer() */
>> -
>>  	eventfd = eventfd_ctx_fdget(args->fd);
>>  	if (IS_ERR(eventfd))
>>  		return PTR_ERR(eventfd);
>> @@ -550,6 +564,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd
>> *args)
>>  			irqfd->irq_entry.type = 0;
>>  			write_seqcount_end(&irqfd->irq_entry_sc);
>>  			irqfd_deactivate(irqfd);
>> +			irq_bypass_unregister_consumer(irqfd->cons);
>> +			kfree(irqfd->cons);
> 
> There may be an issue here. 'irqfd' is freed in irqfd_deactivate() --> ... --.>irqfd_shutdown(),
> and irqfd_deactivate() can be called in the other two places below:
> 	- irqfd_wakeup()
> 	- kvm_irqfd_release()
> I think we also need to call irq_bypass_unregister_consumer() there, right?
yes you're right. what about doing the unregistration in irqfd_shutdown
then?

Thanks for spotting this.

Eric

> 
> Thanks,
> Feng
> 
> 
>>  		}
>>  	}
>>
>> --
>> 1.9.1
> 
