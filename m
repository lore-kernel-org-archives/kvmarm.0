Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495F1C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 20 May 2022 13:48:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B35004B354;
	Fri, 20 May 2022 09:48:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bjiSt2+OrSMe; Fri, 20 May 2022 09:48:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68E144B374;
	Fri, 20 May 2022 09:48:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53EE84B344
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 09:48:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mfqy-rivRhcH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2022 09:48:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBECC4B340
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 09:48:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3504A1477;
 Fri, 20 May 2022 06:48:14 -0700 (PDT)
Received: from [10.57.8.29] (unknown [10.57.8.29])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10A803F73D;
 Fri, 20 May 2022 06:48:12 -0700 (PDT)
Message-ID: <a0162c84-3dc9-7a25-2db6-3943073e693a@arm.com>
Date: Fri, 20 May 2022 14:48:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH kvmtool] aarch64: Give up with MTE for AArch32 guest
Content-Language: en-US
To: Alexandru Elisei <alexandru.elisei@arm.com>
References: <20220520123844.127733-1-vladimir.murzin@arm.com>
 <YoeYF/J2O/cLXmXZ@monolith.localdoman>
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <YoeYF/J2O/cLXmXZ@monolith.localdoman>
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alexandru,

On 5/20/22 14:31, Alexandru Elisei wrote:
> Hi Vladimir,
> 
> When I run an --aarch32 guest with --debug this is the message that I'm
> getting:
> 
>   Info: (arm/aarch64/kvm.c) kvm__arch_enable_mte:146: MTE capability not available
> 
> Would you mind elaborating on the merits of the message that you are
> proposing:
> 
>   Info: (arm/aarch64/kvm.c) kvm__arch_enable_mte:124: MTE is incompatible with AArch32
> 
> Is it because it explains why the capability is not available?

Hmm, without this patch I'm getting

 lkvm run -k /opt/kvm/guest-0/Image -d /opt/kvm/guest-0/fs.ext2 -c 4 -m 681 --console virtio '--irqchip=gicv3' --params 'console=hvc earlycon swiotlb=1024' --aarch32 --debug

+ lkvm run -k /opt/kvm/guest-0/Image -m 681 -c 4 --name guest-115
  Info: (arm/aarch64/kvm.c) kvm__get_vm_type:76: max_ipa aa8fffff ipa_bits 32 max_ipa_bits 40
  Info: (arm/aarch64/kvm.c) kvm__arch_enable_mte:104: MTE capability enabled
  Info: (arm/kvm.c) kvm__arch_load_kernel_image:118: Loaded kernel to 0x80008000 (17280980 bytes)
  Info: (arm/kvm.c) kvm__arch_load_kernel_image:134: Placing fdt at 0x8fe00000 - 0x8fffffff
  Fatal: Unable to initialise vcpu

with patch applied

lkvm run -k /opt/kvm/guest-0/Image -d /opt/kvm/guest-0/fs.ext2 -c 4 -m 681 --console virtio '--irqchip=gicv3' --params 'console=hvc earlycon swiotlb=1024' --aarch32 --debug
+ lkvm run -k /opt/kvm/guest-0/Image -d /opt/kvm/guest-0/fs.ext2 -c 4 -m 681 --console virtio '--irqchip=gicv3' --params 'console=hvc earlycon swiotlb=1024' --aarch32 --debug
  # lkvm run -k /opt/kvm/guest-0/Image -m 681 -c 4 --name guest-114
  Info: (arm/aarch64/kvm.c) kvm__get_vm_type:76: max_ipa aa8fffff ipa_bits 32 max_ipa_bits 40
  Info: (arm/aarch64/kvm.c) kvm__arch_enable_mte:92: MTE is incompatible with AArch32
  Info: (arm/kvm.c) kvm__arch_load_kernel_image:118: Loaded kernel to 0x80008000 (17280980 bytes)
  Info: (arm/kvm.c) kvm__arch_load_kernel_image:134: Placing fdt at 0x8fe00000 - 0x8fffffff
  Info: (virtio/mmio.c) virtio_mmio_init:325: virtio-mmio.devices=0x200@0x3000000:36
  Info: (virtio/mmio.c) virtio_mmio_init:325: virtio-mmio.devices=0x200@0x3000200:37
  Info: (virtio/mmio.c) virtio_mmio_init:325: virtio-mmio.devices=0x200@0x3000400:38

My host and guest kernel is 5.15, maybe I'm just missing some backport?

Cheers
Vladimir

> 
> Thanks,
> Alex
> 
> On Fri, May 20, 2022 at 01:38:44PM +0100, Vladimir Murzin wrote:
>> KVM doesn't support combination of MTE and AArch32 guest, so do not
>> even try.
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>  arm/aarch64/kvm.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
>> index 1b992dd..f3fe854 100644
>> --- a/arm/aarch64/kvm.c
>> +++ b/arm/aarch64/kvm.c
>> @@ -120,6 +120,11 @@ void kvm__arch_enable_mte(struct kvm *kvm)
>>  		.cap = KVM_CAP_ARM_MTE,
>>  	};
>>  
>> +	if (kvm->cfg.arch.aarch32_guest) {
>> +		pr_debug("MTE is incompatible with AArch32");
>> +		return;
>> +	}
>> +
>>  	if (kvm->cfg.arch.mte_disabled) {
>>  		pr_debug("MTE disabled by user");
>>  		return;
>> -- 
>> 2.25.1
>>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
