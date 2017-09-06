From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Fix wrong return value check in
 vgic_its_restore_device_tables
Date: Wed, 6 Sep 2017 21:13:57 +0800
Message-ID: <59AFF495.4050604@huawei.com>
References: <1504675565-13641-1-git-send-email-vkilari@codeaurora.org>
 <65a66715-4f22-07d4-879a-1181c8dad889@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB68D49C27
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 09:14:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j-iOi-0j5qQL for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Sep 2017 09:14:13 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D207940C5A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 09:14:11 -0400 (EDT)
In-Reply-To: <65a66715-4f22-07d4-879a-1181c8dad889@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 2017/9/6 15:22, Auger Eric wrote:

> Hi Vijaya,
> 
> On 06/09/2017 07:26, Vijaya Kumar K wrote:
>> scan_its_table() return 1 on success.
> 
> As mentioned in the kernel-doc comment of scan_its_table, this latter
> returns 1 if the last element is not found. Than can happen while
> scanning an L2 table but shouldn't happen if we scan an L1 table.
> 
>  * Return: < 0 on error, 0 if last element was identified, 1 otherwise
>  * (the last element may not be found on second level tables)
> 

I think there maybe something wrong.
A weeks ago, I met the migrate failed both the save interface and restore interface.
The restore failed reason is that vm is in booting, and haven't to probe pci devs at that moment.
and all dtes is invalid at that moment.

In this case, the interface will return -EINVAL. I think we should take this as success.

Not only for dtes, but the ites.

Thanks.


> 
>  In the function vgic_its_restore_device_tables()
>> the return value of scan_its_table() is checked against success value
>> and returns -EINVAL. Hence migration fails for VM with ITS.
>>
>> With this patch the failure return value is checked while returning
>> -EINVAL.
>>
>> Signed-off-by: Vijaya Kumar K <vkilari@codeaurora.org>
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index aa6b68d..63f8ac3 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -2142,7 +2142,7 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
>>  				     vgic_its_restore_dte, NULL);
>>  	}
>>  
>> -	if (ret > 0)
>> +	if (ret <= 0)
>>  		ret = -EINVAL;
> your modification would return -EINVAL for whatever error encountered
> during the scan table or if last element is found. I don't think this is
> what we want.
> 
> Thanks
> 
> Eric
>>  
>>  	return ret;
>>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
> 
