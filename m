From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: Re: [RFC PATCH 1/3] kvm: arm/arm64: vgic-vits: separate
 vgic_its_free_list() function
Date: Sat, 16 Sep 2017 09:59:21 +0800
Message-ID: <59BC8579.5030700@huawei.com>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
 <1504703110-10744-2-git-send-email-wanghaibin.wang@huawei.com>
 <20170913191405.GH1631@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B31949C27
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Sep 2017 21:57:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kwae-s0pwJ72 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Sep 2017 21:57:13 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A396C40FB0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Sep 2017 21:57:12 -0400 (EDT)
In-Reply-To: <20170913191405.GH1631@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 2017/9/14 3:14, Christoffer Dall wrote:

> On Wed, Sep 06, 2017 at 09:05:08PM +0800, wanghaibin wrote:
>> We slightly refactor vgic_its_destroy, separate vgic_its_free_list()
>> function for later patch invoke.
>>
>> The patch also take a functional change. If the its->device_list.next
> 
> I don't see a functional change in this patch?


I mean, if this check can its->device_list.next happened, this patch will
free the its structure compared with the original implementation.

Thanks

> 
> Thanks,
> -Christoffer
> 
>> is NULL, we still should free the its.
>> Honestly, I can't understand How does the its->device_list.next is NULL
>> happened at this moment.
>>
>> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 11 ++++++++---
>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index aa6b68d..25d614f 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -1624,10 +1624,8 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *dev)
>>  	kfree(dev);
>>  }
>>  
>> -static void vgic_its_destroy(struct kvm_device *kvm_dev)
>> +static void vgic_its_free_list(struct kvm *kvm, struct vgic_its *its)
>>  {
>> -	struct kvm *kvm = kvm_dev->kvm;
>> -	struct vgic_its *its = kvm_dev->private;
>>  	struct list_head *cur, *temp;
>>  
>>  	/*
>> @@ -1653,7 +1651,14 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
>>  		kfree(coll);
>>  	}
>>  	mutex_unlock(&its->its_lock);
>> +}
>> +
>> +static void vgic_its_destroy(struct kvm_device *kvm_dev)
>> +{
>> +	struct kvm *kvm = kvm_dev->kvm;
>> +	struct vgic_its *its = kvm_dev->private;
>>  
>> +	vgic_its_free_list(kvm, its);
>>  	kfree(its);
>>  }
>>  
>> -- 
>> 1.8.3.1
>>
>>
> 
> .
> 
