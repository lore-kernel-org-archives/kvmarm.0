From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 03/10] KVM: arm/arm64: vgic-its: Check CBASER/BASER
 validity before enabling the ITS
Date: Wed, 25 Oct 2017 10:46:23 +0100
Message-ID: <86y3nzef0w.fsf@arm.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
 <1508767709-15256-4-git-send-email-eric.auger@redhat.com>
 <863767ftyy.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF36940D25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 05:45:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bdqYHWSajDuw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Oct 2017 05:45:09 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DB7040418
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 05:45:09 -0400 (EDT)
In-Reply-To: <863767ftyy.fsf@arm.com> (Marc Zyngier's message of "Wed, 25 Oct
 2017 10:38:13 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, cdall@linaro.org, andre.przywara@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 25 2017 at 10:38:13 am BST, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On Mon, Oct 23 2017 at  4:08:22 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
>> The spec says it is UNPREDICTABLE to enable the ITS
>> if any of the following conditions are true:
>>
>> - GITS_CBASER.Valid == 0.
>> - GITS_BASER<n>.Valid == 0, for any GITS_BASER<n> register
>>   where the Type field indicates Device.
>> - GITS_BASER<n>.Valid == 0, for any GITS_BASER<n> register
>>   where the Type field indicates Interrupt Collection and
>>   GITS_TYPER.HCC == 0.
>>
>> In that case, let's keep the ITS disabled.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reported-by: Andre Przywara <andre.przywara@arm.com>
>>
>> ---
>>
>> need to be CC'ed stable
>>
>> v4 -> v5:
>> - check the condition before updating its->enabled and
>>   fix its->cbaser && GITS_CBASER_VALID
>>
>> v3: creation
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index b0ba80f..1eb355e 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -1466,6 +1466,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
>>  {
>>  	mutex_lock(&its->cmd_lock);
>>  
>> +	/*
>> +	 * It is UNPREDICTABLE to enable the ITS if any of the CBASER or
>> +	 * device/collection BASER are invalid
>> +	 */
>> +	if (!its->enabled && (val & GITS_CTLR_ENABLE) &&
>> +		(!(its->baser_device_table & GITS_BASER_VALID) ||
>> +		 !(its->baser_coll_table & GITS_BASER_VALID) ||
>> +		 !(its->cbaser & GITS_CBASER_VALID)))
>> +		goto out;
>> +
>>  	its->enabled = !!(val & GITS_CTLR_ENABLE);
>>  
>>  	/*
>> @@ -1474,6 +1484,7 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
>>  	 */
>>  	vgic_its_process_commands(kvm, its);
>>  
>> +out:
>>  	mutex_unlock(&its->cmd_lock);
>>  }
>
> While this is definitely a good hardening of the implementation, I don't
> think it fixes anything for the guest which is already misbehaving and
> would just not get anything out of this misconfigurarion (in line with
> the UNPRED requirement).
>
> So I don't think we need to Cc stable for this.

I'm having second thoughts. If the guest has written junk in one of the
BASER registers, enabled the ITS (which won't work), and is then
save/restored, userspace is going to get an -EFAULT as part of the
restore process. Not great.

So cc-stable is probably justified here.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
