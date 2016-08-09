From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] KVM: Protect device ops->create and list_add with
 kvm->lock
Date: Tue, 9 Aug 2016 15:16:26 +0200
Message-ID: <44eacdbf-5ec2-6b8c-d2cb-4fe09dbf001d@redhat.com>
References: <20160809122035.16196-1-christoffer.dall@linaro.org>
 <20160809122035.16196-3-christoffer.dall@linaro.org>
 <27023cbf-294f-b316-97ef-8da4e726cc98@redhat.com>
 <20160809125519.GG9175@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160809125519.GG9175@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Alexander Graf <agraf@suse.de>, borntraeger@de.ibm.com, paulus@ozlabs.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 09/08/2016 14:55, Christoffer Dall wrote:
> On Tue, Aug 09, 2016 at 02:37:43PM +0200, Paolo Bonzini wrote:
>>
>>
>> On 09/08/2016 14:20, Christoffer Dall wrote:
>>> KVM devices were manipulating list data structures without any form of
>>> synchronization, and some implementations of the create operations also
>>> suffered from a lack of synchronization.
>>>
>>> Now when we've split the xics create operation into create and init, we
>>> can hold the kvm->lock mutex while calling the create operation and when
>>> manipulating the devices list.
>>>
>>> The error path in the generic code gets slightly ugly because we have to
>>> take the mutex again and delete the device from the list, but holding
>>> the mutex during anon_inode_getfd or releasing/locking the mutex in the
>>> common non-error path seemed wrong.
>>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> Very nice (and small), but please add a comment to the create member in
>> kvm_device_ops.
> 
> Like this?:
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d3c9b82..9c28b4d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1113,6 +1113,12 @@ struct kvm_device {
>  /* create, destroy, and name are mandatory */
>  struct kvm_device_ops {
>  	const char *name;
> +
> +	/*
> +	 * create is called holding kvm->lock and any operations not suitable
> +	 * to do while holding the lock should be deferred to init (see
> +	 * below).
> +	 */
>  	int (*create)(struct kvm_device *dev, u32 type);
>  
>  	/*
> 

That's okay, series

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
