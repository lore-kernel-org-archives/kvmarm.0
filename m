From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Mon, 06 Jul 2015 17:35:06 +0200
Message-ID: <559AA02A.6060703@linaro.org>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
 <1436184692-20927-4-git-send-email-eric.auger@linaro.org>
 <559A7425.4050506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D88E957C73
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 11:24:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LMSL9w0v5Iee for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 11:24:01 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E922657C72
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 11:24:00 -0400 (EDT)
Received: by widjy10 with SMTP id jy10so164462232wid.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 08:35:27 -0700 (PDT)
In-Reply-To: <559A7425.4050506@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,
On 07/06/2015 02:27 PM, Paolo Bonzini wrote:
> 
> 
> On 06/07/2015 14:11, Eric Auger wrote:
>> diff --git a/kernel/irq/bypass.c b/kernel/irq/bypass.c
>> index 5d0f92b..efadbe5 100644
>> --- a/kernel/irq/bypass.c
>> +++ b/kernel/irq/bypass.c
>> @@ -19,6 +19,42 @@ static LIST_HEAD(producers);
>>  static LIST_HEAD(consumers);
>>  static DEFINE_MUTEX(lock);
>>  
>> +/* lock must be hold when calling connect */
> 
> If a lock must be held while callbacks are called, you have to document
> that producers and consumers must _not_ call back into the IRQ bypass
> manager.  (If they have to, you have to document explicitly "This
> function can be called from producer and consumer callbacks" whenever
> relevant).
OK Thanks

Eric
> 
>> +static void connect(struct irq_bypass_producer *prod,
>> +		    struct irq_bypass_consumer *cons)
>> +{
>> +	if (prod->stop)
>> +		prod->stop(prod);
>> +	if (cons->stop)
>> +		cons->stop(cons);
>> +	if (prod->add_consumer)
>> +		prod->add_consumer(prod, cons);
>> +	if (cons->add_producer)
>> +		cons->add_producer(cons, prod);
>> +	if (cons->resume)
>> +		cons->resume(cons);
>> +	if (prod->resume)
>> +		prod->resume(prod);
>> +}
>> +
>> +/* lock must be hold when calling disconnect */
>> +static void disconnect(struct irq_bypass_producer *prod,
>> +		       struct irq_bypass_consumer *cons)
>> +{
>> +	if (prod->stop)
>> +		prod->stop(prod);
>> +	if (cons->stop)
>> +		cons->stop(cons);
>> +	if (cons->del_producer)
>> +		cons->del_producer(cons, prod);
>> +	if (prod->del_consumer)
>> +		prod->del_consumer(prod, cons);
>> +	if (cons->resume)
>> +		cons->resume(cons);
>> +	if (prod->resume)
>> +		prod->resume(prod);
>> +}
>> +
