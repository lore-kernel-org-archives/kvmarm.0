From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 4/7] KVM: arm/arm64: vgic-its: Check result of allocation
 before use
Date: Tue, 21 Nov 2017 11:12:59 +0000
Message-ID: <dc4ff723-3477-b636-2e74-3bddc48ce9a6@arm.com>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
 <20171116175821.26544-5-marc.zyngier@arm.com> <20171120145814.GM28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171120145814.GM28855@cbox>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Kristina Martsenko <kristina.martsenko@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 20/11/17 14:58, Christoffer Dall wrote:
> On Thu, Nov 16, 2017 at 05:58:18PM +0000, Marc Zyngier wrote:
>> We miss a test against NULL after allocation.
>>
>> Fixes: 6d03a68f8054 ("KVM: arm64: vgic-its: Turn device_id validation into generic ID validation")
>> Cc: stable@vger.kernel.org # 4.8
>> Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 370086006838..30f7c7e6d2f4 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -821,6 +821,8 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
>>  		return E_ITS_MAPC_COLLECTION_OOR;
>>  
>>  	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
>> +	if (!collection)
>> +		return -ENOMEM;
> 
> Our processing of this return value seems to be "shrug, something went
> wrong, let's move on to the next command".  Is this really a valid thing
> to do if we're so much under memory pressure that we dannot allocate a
> collection structure?

The main issue is that we don't currently have a good story when
returning error in general. The current implementation of the vITS
doesn't implement the stalling behaviour which would give the guest the
opportunity to do something. From a host PoV, I'm not really sure what
we can do. Killing the guest doesn't seem very appropriate.

So I'd rather implement stalling the command queue (see 6.3.2 in the
GICv3 spec), and implement something to report the error (even though
this is IMPDEF). Thoughts?

> 
> My question notwithstanding:
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
