From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm64: its: Fix missing dynamic allocation check in
 scan_its_table
Date: Fri, 13 Oct 2017 13:21:46 +0100
Message-ID: <cc5715e9-af5b-679d-d8a9-5596d25156d1@arm.com>
References: <20171013105259.9728-1-christoffer.dall@linaro.org>
 <0fbee4b3-c555-76d6-4a9e-8a869e87d8ee@arm.com> <20171013115742.GA10539@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C94649D24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 08:21:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uSPurpws6wTB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Oct 2017 08:21:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ABBC49C4E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 08:21:04 -0400 (EDT)
In-Reply-To: <20171013115742.GA10539@cbox>
Content-Language: en-GB
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
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 13/10/17 12:57, Christoffer Dall wrote:
> On Fri, Oct 13, 2017 at 12:00:50PM +0100, Marc Zyngier wrote:
>> On 13/10/17 11:52, Christoffer Dall wrote:
>>> We currently allocate an entry dynamically, but we never check if the
>>> allocation actually succeeded.  We actually don't need a dynamic
>>> allocation, because we know the maximum size of an ITS table entry, so
>>> we can simply use an allocation on the stack.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 19 ++++++++-----------
>>>  1 file changed, 8 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index f51c1e1..555f42f 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -176,6 +176,7 @@ static const struct vgic_its_abi its_table_abi_versions[] = {
>>>  };
>>>  
>>>  #define NR_ITS_ABIS	ARRAY_SIZE(its_table_abi_versions)
>>> +#define MAX_ENTRY_SIZE	8	/* Max Entry size across all ABI versions */
>>>  
>>>  inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
>>>  {
>>> @@ -1801,37 +1802,33 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
>>>  static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
>>>  			  int start_id, entry_fn_t fn, void *opaque)
>>>  {
>>> -	void *entry = kzalloc(esz, GFP_KERNEL);
>>>  	struct kvm *kvm = its->dev->kvm;
>>>  	unsigned long len = size;
>>>  	int id = start_id;
>>>  	gpa_t gpa = base;
>>> +	char entry[MAX_ENTRY_SIZE];
>>
>> Nit: you can drop the memset below if you initialize immediately, and
>> GCC supporting dynamic arrays allows you to write this:
>>
>> 	char entry[esz] = { 0, };
>>
>> so that you don't have to add the MAX_ENTRY_SIZE.
>>
> 
> Using a dynamic sized array is a great idea, but trying to initalize it
> at the same time gives me:
> 
>     error: variable-sized object may not be initialized
> 
> Is there a trick I'm unfamiliar with?

No, it is just that these two things are mutually incompatible, and I
didn't realize it. You have to choose one or the other... :-(

I suggest you keep the memset...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
