Return-Path: <SRS0=P9fm=2N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCBEC2D0CF
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 14:07:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B5A520715
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 14:07:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B5A520715
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DDA04AF58;
	Mon, 23 Dec 2019 09:07:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m8w9PGs7O7r6; Mon, 23 Dec 2019 09:07:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 800F04AF2F;
	Mon, 23 Dec 2019 09:07:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD52A4AF23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 09:07:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6qhuTl7RWyuv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Dec 2019 09:07:25 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 975EA4AEEE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 09:07:25 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ijOMh-0006s5-8h; Mon, 23 Dec 2019 15:07:19 +0100
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Handle =?UTF-8?Q?GICR=5FPENDBAS?=
 =?UTF-8?Q?ER=2EPTZ=20filed=20as=20RAZ?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 23 Dec 2019 14:07:19 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <3a729559-d0eb-e042-d6bd-b69bacb0dd23@huawei.com>
References: <20191220111833.1422-1-yuzenghui@huawei.com>
 <3a729559-d0eb-e042-d6bd-b69bacb0dd23@huawei.com>
Message-ID: <c084aa29c029f97cdfb1b5dc9e6b29ac@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, andre.przywara@arm.com,
 eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Zenghui,

On 2019-12-23 13:43, Zenghui Yu wrote:
> On 2019/12/20 19:18, Zenghui Yu wrote:
>> Although guest will hardly read and use the PTZ (Pending Table Zero)
>> bit in GICR_PENDBASER, let us emulate the architecture strictly.
>> As per IHI 0069E 9.11.30, PTZ field is WO, and reads as 0.
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>> Noticed when checking all fields of GICR_PENDBASER register.
>> But _not_ sure whether it's worth a fix, as Linux never sets
>> the PTZ bit before enabling LPI (set GICR_CTLR_ENABLE_LPIS).
>> And I wonder under which scenarios can this bit be written as 1.
>> It seems difficult for software to determine whether the pending
>> table contains all zeros when writing this bit.
>> virt/kvm/arm/vgic/vgic-mmio-v3.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 7dfd15dbb308..ebc218840fc2 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -414,8 +414,11 @@ static unsigned long 
>> vgic_mmio_read_pendbase(struct kvm_vcpu *vcpu,
>>   					     gpa_t addr, unsigned int len)
>>   {
>>   	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	u64 value = vgic_cpu->pendbaser;
>>   -	return extract_bytes(vgic_cpu->pendbaser, addr & 7, len);
>> +	value &= ~GICR_PENDBASER_PTZ;
>> +
>> +	return extract_bytes(value, addr & 7, len);
>>   }
>>   static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
>>
>
> I noticed there is no userspace access callbacks for GICR_PENDBASER,
> so this patch will make the PTZ field also 'Read As Zero' by 
> userspace.
> Should we consider adding a uaccess_read callback for GICR_PENDBASER
> which just returns the unchanged vgic_cpu->pendbaser to userspace?
> (Though this is really not a big deal. We now always emulate the PTZ
> field to guest as RAZ. And 'vgic_cpu->pendbaser & GICR_PENDBASER_PTZ'
> only indicates whether KVM will optimize the LPI enabling process,
> where Read As Zero indicates never optimize..)

I don't think adding a userspace accessor would help much. All this
bit tells userspace is that the guest has programmed a zero filled
table. On restore, we'd avoid a rescan of the table if there was
no LPI mapped.

And thinking of it, this fixes a bug for non-Linux guests: If you write
PTZ=1, we never clear it. Which means that if userspace saves and 
restores
PENDBASER with PTZ set, we'll never restore the pending bits, which is
pretty bad (see vgic_enable_lpis()).

This patch on its own fixes more than one bug!

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
