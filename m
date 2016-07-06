From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH v8 03/17] KVM: extend struct kvm_msi to hold a 32-bit
 device ID
Date: Wed, 6 Jul 2016 22:54:58 +0100
Message-ID: <8e1bab2c-b584-0723-6b23-fb2d5dd959c1@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-4-andre.przywara@arm.com> <20160706210648.GD12608@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160706210648.GD12608@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/07/16 22:06, Christoffer Dall wrote:
> On Tue, Jul 05, 2016 at 12:22:55PM +0100, Andre Przywara wrote:
>> The ARM GICv3 ITS MSI controller requires a device ID to be able to
>> assign the proper interrupt vector. On real hardware, this ID is
>> sampled from the bus. To be able to emulate an ITS controller, extend
>> the KVM MSI interface to let userspace provide such a device ID. For
>> PCI devices, the device ID is simply the 16-bit bus-device-function
>> triplet, which should be easily available to the userland tool.
>>
>> Also there is a new KVM capability which advertises whether the
>> current VM requires a device ID to be set along with the MSI data.
>> This flag is still reported as not available everywhere, later we will
>> enable it when ITS emulation is used.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> Reviewed-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  Documentation/virtual/kvm/api.txt | 12 ++++++++++--
>>  include/uapi/linux/kvm.h          |  5 ++++-
>>  2 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 09efa9e..6551311 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2175,10 +2175,18 @@ struct kvm_msi {
>>  	__u32 address_hi;
>>  	__u32 data;
>>  	__u32 flags;
>> -	__u8  pad[16];
>> +	__u32 devid;
>> +	__u8  pad[12];
>>  };
>>  
>> -No flags are defined so far. The corresponding field must be 0.
>> +flags: KVM_MSI_VALID_DEVID: devid contains a valid value
>> +devid: If KVM_MSI_VALID_DEVID is set, contains a unique device identifier
>> +       for the device that wrote the MSI message.
>> +       For PCI, this is usually a BFD identifier in the lower 16 bits.
>> +
>> +The per-VM KVM_CAP_MSI_DEVID capability advertises the need to provide
>> +the device ID. If this capability is not set, userland cannot rely on
>> +the kernel to allow the KVM_MSI_VALID_DEVID flag being set.
> 
> If KVM_CAP_MSI_DEVID is set, is it an error to provide a struct kvm_msi
> without the KVM_MSI_VALID_DEVID flag set, or not necessarily?

In the moment we return an error when the bit is not set. But
theoretically a guest could have other (in-kernel emulated) MSI
controllers which don't require a device ID, though currently there is none.
The reason for both the KVM capability and the flag on the ioctl is for
mutual assurance that both userland and the kernel know about this ITS
specific extension.
This KVM_SIGNAL_MSI API is rather generic, so I don't want to
unnecessarily slam the door on other emulated ITS controllers.

>>  4.71 KVM_CREATE_PIT2
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 05ebf47..7de96f5 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -866,6 +866,7 @@ struct kvm_ppc_smmu_info {
>>  #define KVM_CAP_ARM_PMU_V3 126
>>  #define KVM_CAP_VCPU_ATTRIBUTES 127
>>  #define KVM_CAP_MAX_VCPU_ID 128
>> +#define KVM_CAP_MSI_DEVID 129
>>  
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>  
>> @@ -1024,12 +1025,14 @@ struct kvm_one_reg {
>>  	__u64 addr;
>>  };
>>  
>> +#define KVM_MSI_VALID_DEVID	(1U << 0)
>>  struct kvm_msi {
>>  	__u32 address_lo;
>>  	__u32 address_hi;
>>  	__u32 data;
>>  	__u32 flags;
>> -	__u8  pad[16];
>> +	__u32 devid;
>> +	__u8  pad[12];
>>  };
>>  
>>  struct kvm_arm_device_addr {
>> -- 
>> 2.9.0
>>
> 
> Looks good to me, but you probably need an ack from Paolo or Radim
> before we can queue this.
> 
> FWIW: Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks!
Andre

