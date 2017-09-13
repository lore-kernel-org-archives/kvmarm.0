From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH 3/3] kvm: arm/arm64: vgic-its: fix return value for
 restore
Date: Wed, 13 Sep 2017 23:25:01 +0200
Message-ID: <6246fa89-50cb-488a-008c-1290ced290e7@redhat.com>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
 <1504703110-10744-4-git-send-email-wanghaibin.wang@huawei.com>
 <fd0534b6-7e95-45cd-f90d-188c93a98f4a@redhat.com> <20170913200248.GK1631@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCD5049C19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 17:22:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oI+la-r8O+i3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Sep 2017 17:22:27 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D891C40FAE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 17:22:26 -0400 (EDT)
In-Reply-To: <20170913200248.GK1631@lvm>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 13/09/2017 22:02, Christoffer Dall wrote:
> Hi Eric,
> 
> On Wed, Sep 06, 2017 at 05:18:35PM +0200, Auger Eric wrote:
>> Hi Wanghaibin,
>>
>> On 06/09/2017 15:05, wanghaibin wrote:
>>> This patch fix the migrate restore tables failure.
>>>
>>> The same scene, at the destination, the restore tables interface traversal guest
>>> memory, and check the dte/ite is valid or not.
>>> If all dtes/ites are invalid, we will do try next one, and the last it will take
>>> the 1 return value, but currently, it be treated as error. That's not correct.
>> There's indeed a bug here! In case all entries are invalid we shouldn't
>> return an error.
>>
>> One solution could be to relax the error checking in scan_its_table()
>> and do not return 1 when the whole length has been scanned. This would
>> fix your issue.
If you do not return 1 in scan_its_table if the whole size has been
scanned, you achieve the same thing as in this patch and you simplify
the error handling.
>>
>> drawback of that change:
>> at the moment we check the consistency of the entry data (next offset
>> field). At the moment if the next_offset points to an entry outside of
>> the table scope we are able to return an error (for top level tables).
>>
>> Otherwise, if we want to keep that check, I think we would need to add a
>> bool *valid parameter to entry_fn_t. in scan_its_table() we would return
>> 1 only if last fn() call returns valid and len <= 0.
>>
> 
> I don't really understand what you're proposing.
The above method or Wanghaibin's patch removes a consistency check on
the entry next offset field. But maybe this is better to drop it and
have a code that gains in readability.

Thanks

Eric
> 
> I think Wanghaibin's patch actually looks correct.  Is there any problem
> with it that you see?
> 
> Thanks,
> -Christoffer
> 
>>>
>>> This patch try to fix this problem.
>>>
>>> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 5 +----
>>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 5c20352..2c69aeb 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -2025,7 +2025,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
>>>  		return PTR_ERR(dev);
>>>  
>>>  	ret = vgic_its_restore_itt(its, dev);
>>> -	if (ret) {
>>> +	if (ret < 0) {
>>>  		vgic_its_free_device(its->dev->kvm, dev);
>>>  		return ret;
>>>  	}
>>> @@ -2147,9 +2147,6 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
>>>  				     vgic_its_restore_dte, NULL);
>>>  	}
>>>  
>>> -	if (ret > 0)
>>> -		ret = -EINVAL;
>>> -
>>>  	return ret;
>>>  }
>>>  
>>>
