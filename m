From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH 1/3] kvm: arm/arm64: vgic-vits: separate
 vgic_its_free_list() function
Date: Tue, 12 Sep 2017 12:08:27 +0200
Message-ID: <325be1c0-48cf-444f-8ca2-263cd8ee3b4f@redhat.com>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
 <1504703110-10744-2-git-send-email-wanghaibin.wang@huawei.com>
 <59B79FDA.7090901@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A5E049C0F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Sep 2017 06:06:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i0zO1ercOowh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Sep 2017 06:05:54 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 340AF40FA7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Sep 2017 06:05:54 -0400 (EDT)
In-Reply-To: <59B79FDA.7090901@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: wanghaibin <wanghaibin.wang@huawei.com>
Cc: marc.zyngier@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wanghaibin,

On 12/09/2017 10:50, wanghaibin wrote:
> On 2017/9/6 21:05, wanghaibin wrote:
> =

>> We slightly refactor vgic_its_destroy, separate vgic_its_free_list()
>> function for later patch invoke.
>>
>> The patch also take a functional change. If the its->device_list.next
>> is NULL, we still should free the its.
> =

> =

> Hi, Eric
> =

> Does this its->device_list.next is NULL can happened ?

I don't get why we have this check.

The kvm device is removed by kvm_destroy_devices which loops on all
devices added to kvm->devices. kvm_ioctl_create_device only adds the
device to kvm_devices once the lists have been initialized (in
vgic_create_its). So it looks safe to me without the check.

Andr=E9, do we miss something?

Thanks

Eric

> =

> Thanks
> =

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
>> @@ -1624,10 +1624,8 @@ static void vgic_its_free_device(struct kvm *kvm,=
 struct its_device *dev)
>>  	kfree(dev);
>>  }
>>  =

>> -static void vgic_its_destroy(struct kvm_device *kvm_dev)
>> +static void vgic_its_free_list(struct kvm *kvm, struct vgic_its *its)
>>  {
>> -	struct kvm *kvm =3D kvm_dev->kvm;
>> -	struct vgic_its *its =3D kvm_dev->private;
>>  	struct list_head *cur, *temp;
>>  =

>>  	/*
>> @@ -1653,7 +1651,14 @@ static void vgic_its_destroy(struct kvm_device *k=
vm_dev)
>>  		kfree(coll);
>>  	}
>>  	mutex_unlock(&its->its_lock);
>> +}
>> +
>> +static void vgic_its_destroy(struct kvm_device *kvm_dev)
>> +{
>> +	struct kvm *kvm =3D kvm_dev->kvm;
>> +	struct vgic_its *its =3D kvm_dev->private;
>>  =

>> +	vgic_its_free_list(kvm, its);
>>  	kfree(its);
>>  }
>>  =

> =

> =

> =

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> =
