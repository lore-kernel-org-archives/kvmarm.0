From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 07/31] KVM: arm/arm64: vgic-v3: Add accessors for the ICH_APxRn_EL2 registers
Date: Mon, 22 May 2017 19:52:23 +0100
Message-ID: <87zie4lo60.fsf@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
        <20170503104606.19342-8-marc.zyngier@arm.com>
        <632e0b74-4d39-99b6-02aa-340f4d929bc6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <632e0b74-4d39-99b6-02aa-340f4d929bc6@redhat.com> (Auger Eric's
        message of "Wed, 17 May 2017 11:54:23 +0200")
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 17 2017 at 11:54:23 am BST, Auger Eric <eric.auger@redhat.com> wrote:
> Hi,
>
> On 03/05/2017 12:45, Marc Zyngier wrote:
>> As we're about to access the Active Priority registers a lot more,
>> let's define accessors that take the register number as a parameter.
>> 
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/hyp/vgic-v3-sr.c | 116 ++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 100 insertions(+), 16 deletions(-)
>> 
>> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
>> index 32c3295929b0..990d9d1e85d0 100644
>> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
>> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
>> @@ -118,6 +118,90 @@ static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
>>  	}
>>  }
>>  
>> +static void __hyp_text __vgic_v3_write_ap0rn(u32 val, int n)
>> +{
>> +	switch (n) {
>> +	case 0:
>> +		write_gicreg(val, ICH_AP0R0_EL2);
>> +		break;
>> +	case 1:
>> +		write_gicreg(val, ICH_AP0R1_EL2);
>> +		break;
>> +	case 2:
>> +		write_gicreg(val, ICH_AP0R2_EL2);
>> +		break;
>> +	case 3:
>> +		write_gicreg(val, ICH_AP0R3_EL2);
>> +		break;
>> +	}
>> +}
>> +
>> +static void __hyp_text __vgic_v3_write_ap1rn(u32 val, int n)
>> +{
>> +	switch (n) {
>> +	case 0:
>> +		write_gicreg(val, ICH_AP1R0_EL2);
>> +		break;
>> +	case 1:
>> +		write_gicreg(val, ICH_AP1R1_EL2);
>> +		break;
>> +	case 2:
>> +		write_gicreg(val, ICH_AP1R2_EL2);
>> +		break;
>> +	case 3:
>> +		write_gicreg(val, ICH_AP1R3_EL2);
>> +		break;
>> +	}
>> +}
>> +
>> +static u32 __hyp_text __vgic_v3_read_ap0rn(int n)
>> +{
>> +	u32 val;
>> +
>> +	switch (n) {
>> +	case 0:
>> +		val = read_gicreg(ICH_AP0R0_EL2);
>> +		break;
>> +	case 1:
>> +		val = read_gicreg(ICH_AP0R1_EL2);
>> +		break;
>> +	case 2:
>> +		val = read_gicreg(ICH_AP0R2_EL2);
>> +		break;
>> +	case 3:
>> +		val = read_gicreg(ICH_AP0R3_EL2);
>> +		break;
>> +	default:
>> +		unreachable();
> I am not familiar with that macro. For my curiosity why is it used here
> and not in write functions.

I probably have looked at the assembly code and realised that using this
macro was helping the compiler not to generate horrible code because it
doesn't know that it will always return a value.

The "write" part doesn't need this not to be awful, so I didn't feel the
need to add it. Can do though.

>
> Besides Mark's comment,
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks,

	M.
-- 
Jazz is not dead, it just smell funny.
