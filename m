From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 02/13] KVM: extend struct kvm_msi to hold a 32-bit device
 ID
Date: Mon, 29 Jun 2015 15:53:12 +0100
Message-ID: <55915BD8.4050103@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <1432893209-27313-3-git-send-email-andre.przywara@arm.com>
 <20150628191234.GI28244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38E4F569C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 10:41:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 36W-NpxUfIhZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 10:41:40 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2A26569BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 10:41:39 -0400 (EDT)
In-Reply-To: <20150628191234.GI28244@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

thanks for your time to reviewing this! Was probably no pleasure ;-)

On 28/06/15 20:12, Christoffer Dall wrote:
> On Fri, May 29, 2015 at 10:53:18AM +0100, Andre Przywara wrote:
>> The ARM GICv3 ITS MSI controller requires a device ID to be able to
>> assign the proper interrupt vector. On real hardware, this ID is
>> sampled from the bus. To be able to emulate an ITS controller, extend
>> the KVM MSI interface to let userspace provide such a device ID. For
>> PCI devices, the device ID is simply the 16-bit bus-device-function
>> triplet, which should be easily available to the userland tool.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  Documentation/virtual/kvm/api.txt | 8 ++++++--
>>  include/uapi/linux/kvm.h          | 4 +++-
>>  2 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 9fa2bf8..891d64a 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2121,10 +2121,14 @@ struct kvm_msi {
>>  	__u32 address_hi;
>>  	__u32 data;
>>  	__u32 flags;
>> -	__u8  pad[16];
>> +	__u32 devid;
>> +	__u8  pad[12];
>>  };
>>  
>> -No flags are defined so far. The corresponding field must be 0.
>> +flags: KVM_MSI_VALID_DEVID: devid is valid, otherwise ignored.
> 
> I don't see what the 'otherwise ignored' part of the sentence here is
> meant to say, that the flags field is otherwise ignored for other value?

No, that the devid field is ignored if this bit isn't set. I can
rephrase this to be more explicit.

> That's not what the current API doc specifies, it specifies that the
> remainder of the field must be 0.
> 
>> +devid: If KVM_MSI_VALID_DEVID is set, contains a value to identify the device
>> +       that wrote the MSI message. For PCI, this is usually a BFD
>> +       identifier in the lower 16 bits.
> 
> I assume plus something else that uniquely identifies the PCI
> controller?

Well yes, the device ID is a unique device identifier within a system,
the BFD use case was just to illustrate this and give a hint to
userspace what to fill in there. I will explain this better in v2.

So are you OK with that extension of the API in general? Just asking
because there is a lot that depends on it.

Cheers,
Andre.
