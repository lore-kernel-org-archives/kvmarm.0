From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 02/22] KVM: arm/arm64: Add GICV3 pending table save API
 documentation
Date: Wed, 26 Apr 2017 10:26:24 +0200
Message-ID: <a5ab9181-8398-f62b-12f1-032961b12c28@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-3-git-send-email-eric.auger@redhat.com>
 <CAFEAcA_0N9Jx5ym+=jjmxAzSaXPjt-m+gW1cq90of8Qhw3LOzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50BE440C4A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:23:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rv1DFuoDVGbV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Apr 2017 04:23:42 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A21F40C22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Apr 2017 04:23:41 -0400 (EDT)
In-Reply-To: <CAFEAcA_0N9Jx5ym+=jjmxAzSaXPjt-m+gW1cq90of8Qhw3LOzg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: "prasun.kapoor" <Prasun.Kapoor@cavium.com>, kvm-devel <kvm@vger.kernel.org>, Juan Quintela <quintela@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Kumar,
 Vijaya" <Vijaya.Kumar@cavium.com>, Vijaya Kumar K <vijayak@caviumnetworks.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,

On 25/04/2017 12:43, Peter Maydell wrote:
> On 14 April 2017 at 11:15, Eric Auger <eric.auger@redhat.com> wrote:
>> Add description for how to save GICV3 LPI pending bit into
>> guest RAM pending tables.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v5: creation
>> ---
>>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> index c1a2461..9293b45 100644
>> --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> @@ -167,11 +167,17 @@ Groups:
>>      KVM_DEV_ARM_VGIC_CTRL_INIT
>>        request the initialization of the VGIC, no additional parameter in
>>        kvm_device_attr.addr.
>> +    KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
>> +      save all LPI pending bits into guest RAM pending tables.
>> +
>> +      The first kB of the pending table is not altered by this operation.
>>    Errors:
>>      -ENXIO: VGIC not properly configured as required prior to calling
>>       this attribute
>>      -ENODEV: no online VCPU
>>      -ENOMEM: memory shortage when allocating vgic internal data
>> +    -EFAULT: Invalid guest ram access
>> +    -EBUSY:  One or more VCPUS are running
>>
>>
>>    KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
>> --
>> 2.5.5
> 
> When does the -EFAULT return happen? (if the guest points GITS_BASER<n>
> etc at invalid memory, presumably?)
Yes that's correct, when GICR_PENDBASER contains a bad GPA.
 How does the QEMU migration code
> handle this case? Failing migration because the guest has done something
> silly doesn't seem too palatable, but trying to avoid that could be
> more effort than an obscure corner case really merits.
The kvm_device_access will cause an abort() as for other errors returned
by kvm_device_ioctl().

Thanks

Eric
> 
> thanks
> -- PMM
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
