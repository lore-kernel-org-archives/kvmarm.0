From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 01/12] KVM: extend struct kvm_msi to hold a 32-bit
 device ID
Date: Wed, 25 May 2016 17:16:54 +0100
Message-ID: <5745CFF6.6070001@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-2-git-send-email-andre.przywara@arm.com>
 <20160403091508.GA5261@cbox> <e520a5a8-b259-27f3-f33c-f87e008f1c6f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <e520a5a8-b259-27f3-f33c-f87e008f1c6f@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 25/05/16 16:55, Andre Przywara wrote:
> Hi Christoffer,
> 
> On 03/04/16 10:15, Christoffer Dall wrote:
>> On Sat, Mar 26, 2016 at 02:13:59AM +0000, Andre Przywara wrote:
>>> The ARM GICv3 ITS MSI controller requires a device ID to be able to
>>> assign the proper interrupt vector. On real hardware, this ID is
>>> sampled from the bus. To be able to emulate an ITS controller, extend
>>> the KVM MSI interface to let userspace provide such a device ID. For
>>> PCI devices, the device ID is simply the 16-bit bus-device-function
>>> triplet, which should be easily available to the userland tool.
>>>
>>> Also there is a new KVM capability which advertises whether the
>>> current VM requires a device ID to be set along with the MSI data.
>>> This flag is still reported as not available everywhere, later we will
>>> enable it when ITS emulation is used.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> Reviewed-by: Eric Auger <eric.auger@linaro.org>
>>> ---
>>>  Documentation/virtual/kvm/api.txt | 12 ++++++++++--
>>>  include/uapi/linux/kvm.h          |  5 ++++-
>>>  2 files changed, 14 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>>> index cb2ef0b..8f7351d 100644
>>> --- a/Documentation/virtual/kvm/api.txt
>>> +++ b/Documentation/virtual/kvm/api.txt
>>> @@ -2163,10 +2163,18 @@ struct kvm_msi {
>>>  	__u32 address_hi;
>>>  	__u32 data;
>>>  	__u32 flags;
>>> -	__u8  pad[16];
>>> +	__u32 devid;
>>
>> Are we imposing any unfortunate restrictions for other architectures by
>> using a u32 over a u64 for the device ID?
> 
> Mmmh, good point. I guess not only for other architectures, but also for
> the future in general.
> 
> Are there any objections against increasing this to a u64?

I'm not sure this is really necessary. A PCI RID is 16bit, and expanding
it to 32bit is already making quite a bit of space for further extension.

Also, some architecture might be unhappy of having a 64bit quantity that
is not 64bit aligned...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
