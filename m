From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] KVM: Protect device ops->create and list_add with
 kvm->lock
Date: Tue, 9 Aug 2016 17:20:15 +0200
Message-ID: <cf294284-42dd-250a-05e5-cc9f35ca5f58@redhat.com>
References: <20160809122035.16196-1-christoffer.dall@linaro.org>
 <20160809122035.16196-3-christoffer.dall@linaro.org>
 <27023cbf-294f-b316-97ef-8da4e726cc98@redhat.com>
 <20160809125519.GG9175@cbox>
 <44eacdbf-5ec2-6b8c-d2cb-4fe09dbf001d@redhat.com>
 <20160809144937.GJ9175@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F287549B2C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 11:13:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ExzyayVYGnpD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 11:13:14 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F8F749AFA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 11:13:13 -0400 (EDT)
In-Reply-To: <20160809144937.GJ9175@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, paulus@ozlabs.org, borntraeger@de.ibm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 09/08/2016 16:49, Christoffer Dall wrote:
> On Tue, Aug 09, 2016 at 03:16:26PM +0200, Paolo Bonzini wrote:
>>
>>
>> On 09/08/2016 14:55, Christoffer Dall wrote:
>>> On Tue, Aug 09, 2016 at 02:37:43PM +0200, Paolo Bonzini wrote:
>>>>
>>>>
>>>> On 09/08/2016 14:20, Christoffer Dall wrote:
>>>>> KVM devices were manipulating list data structures without any form of
>>>>> synchronization, and some implementations of the create operations also
>>>>> suffered from a lack of synchronization.
>>>>>
>>>>> Now when we've split the xics create operation into create and init, we
>>>>> can hold the kvm->lock mutex while calling the create operation and when
>>>>> manipulating the devices list.
>>>>>
>>>>> The error path in the generic code gets slightly ugly because we have to
>>>>> take the mutex again and delete the device from the list, but holding
>>>>> the mutex during anon_inode_getfd or releasing/locking the mutex in the
>>>>> common non-error path seemed wrong.
>>>>>
>>>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>>
>>>> Very nice (and small), but please add a comment to the create member in
>>>> kvm_device_ops.
>>>
>>> Like this?:
>>>
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index d3c9b82..9c28b4d 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -1113,6 +1113,12 @@ struct kvm_device {
>>>  /* create, destroy, and name are mandatory */
>>>  struct kvm_device_ops {
>>>  	const char *name;
>>> +
>>> +	/*
>>> +	 * create is called holding kvm->lock and any operations not suitable
>>> +	 * to do while holding the lock should be deferred to init (see
>>> +	 * below).
>>> +	 */
>>>  	int (*create)(struct kvm_device *dev, u32 type);
>>>  
>>>  	/*
>>>
>>
>> That's okay, series
>>
>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Thanks, I'll send a v2.  Will you just apply the patches to kvm/master
> or would you like me to include it in my pull request for -rc2 ?

The tree is currently in Radim's hands, but I expect this to be applied
directly by one of us.

> Also, do you want to wait for a tested-by from the other arch
> maintainers?

That would be nice, but not mandatory.

Paolo
