Return-Path: <SRS0=xA+Y=WP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4424EC3A59B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Aug 2019 08:46:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C837C2082C
	for <kvmarm@archiver.kernel.org>; Mon, 19 Aug 2019 08:46:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C837C2082C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2740D4A5CA;
	Mon, 19 Aug 2019 04:46:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L1WA7rlb+YMB; Mon, 19 Aug 2019 04:46:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1065C4A5A5;
	Mon, 19 Aug 2019 04:46:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54A804A59D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Aug 2019 04:46:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nVZdd0swizgH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Aug 2019 04:46:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 411834A552
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Aug 2019 04:46:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDFE3344;
 Mon, 19 Aug 2019 01:46:25 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 8352C3F718; Mon, 19 Aug 2019 01:46:24 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Allow more than 256 vcpus for
 KVM_IRQ_LINE
To: Will Deacon <will@kernel.org>
References: <20190818140710.23920-1-maz@kernel.org>
 <20190819074150.jv3dyyxqazoawgds@willie-the-truck>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <a7573176-6375-a7df-6fae-ab93155a824c@kernel.org>
Date: Mon, 19 Aug 2019 09:46:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819074150.jv3dyyxqazoawgds@willie-the-truck>
Content-Language: en-US
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On 19/08/2019 08:41, Will Deacon wrote:
> On Sun, Aug 18, 2019 at 03:07:10PM +0100, Marc Zyngier wrote:
>> While parts of the VGIC support a large number of vcpus (we
>> bravely allow up to 512), other parts are more limited.
>>
>> One of these limits is visible in the KVM_IRQ_LINE ioctl, which
>> only allows 256 vcpus to be signalled when using the CPU or PPI
>> types. Unfortunately, we've cornered ourselves badly by allocating
>> all the bits in the irq field.
>>
>> Since the irq_type subfield (8 bit wide) is currently only taking
>> the values 0, 1 and 2 (and we have been careful not to allow anything
>> else), let's reduce this field to only 4 bits, and allocate the
>> remaining 4 bits to a vcpu2_index, which acts as a multiplier:
>>
>>   vcpu_id = 256 * vcpu2_index + vcpu_index
>>
>> With that, and a new capability (KVM_CAP_ARM_IRQ_LINE_LAYOUT_2)
>> allowing this to be discovered, it becomes possible to inject
>> PPIs to up to 4096 vcpus. But please just don't.
> 
> Do you actually need a new capability for this? Older kernels reject
> non-zero upper bits in the 'irq_type', so isn't that enough to probe
> for this directly?

'Probing' is a bit of an overstatement. You'll get an error back when
userspace will try to inject a PPI into a vcpu whose ID is in the new
range. But nothing at VM creation time will indicate the interrupt
injection API supports more than 256 vcpus.

I think userspace should be able to fail the creation of such large VM
immediately, before actually running it.

	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
