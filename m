Return-Path: <SRS0=GJXN=UN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24A0C31E44
	for <kvmarm@archiver.kernel.org>; Fri, 14 Jun 2019 08:32:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 49C9E2084E
	for <kvmarm@archiver.kernel.org>; Fri, 14 Jun 2019 08:32:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49C9E2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFA394A519;
	Fri, 14 Jun 2019 04:32:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CKAiqFPvk9Tc; Fri, 14 Jun 2019 04:32:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1ADF4A502;
	Fri, 14 Jun 2019 04:32:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7FB44A4E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jun 2019 04:32:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sc54HN1TFca3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Jun 2019 04:32:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75A014A4C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jun 2019 04:32:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9D3F2B;
 Fri, 14 Jun 2019 01:32:09 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FEB43F246;
 Fri, 14 Jun 2019 01:32:09 -0700 (PDT)
Subject: Re: [PATCH kvmtool 08/16] arm/pci: Do not use first PCI IO space
 bytes for devices
To: Andre Przywara <andre.przywara@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
 <1551947777-13044-9-git-send-email-julien.thierry@arm.com>
 <20190405163127.4b10a581@donnerap.cambridge.arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <42fb92bf-e58a-41d0-0a7f-b72d7bca481c@arm.com>
Date: Fri, 14 Jun 2019 09:32:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190405163127.4b10a581@donnerap.cambridge.arm.com>
Content-Language: en-US
Cc: Sami.Mujawar@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

Hi Andre,

(sorry for the delay in reply)

On 05/04/2019 16:31, Andre Przywara wrote:
> On Thu, 7 Mar 2019 08:36:09 +0000
> Julien Thierry <julien.thierry@arm.com> wrote:
> 
> Hi,
> 
>> Linux has this convention that the lower 0x1000 bytes of the IO space
>> should not be used. (cf PCIBIOS_MIN_IO).
>>
>> Just allocate those bytes to prevent future allocation assigning it to
>> devices.
>>
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> ---
>>  arm/pci.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arm/pci.c b/arm/pci.c
>> index 83238ca..559e0cf 100644
>> --- a/arm/pci.c
>> +++ b/arm/pci.c
>> @@ -37,6 +37,9 @@ void pci__arm_init(struct kvm *kvm)
>>  
>>  	/* Make PCI port allocation start at a properly aligned address */
>>  	pci_get_io_space_block(align_pad);
>> +
>> +	/* Convention, don't allocate first 0x1000 bytes of PCI IO */
>> +	pci_get_io_space_block(0x1000);
> 
> Is this the same problem with mixing up I/O and MMIO space as in the other patch?
> io_space means MMIO, right?
> 

Oh yes, you're right. Thanks for catching that (and in the other patch
as well).

However, fixing it unveiled a bug which apparently requires me to change
a bunch of things w.r.t. how we handle the configuration. At boot time,
Linux (without probe only) reassigns bars without disabling the device
response (it assumes that none of the devices it can configure are being
used/accessed).

This means that during the reassignment, bars from different or same
devices can temporarily alias/overlap each other during boot time. And
the current handling of PCI io/mmio region doesn't support that.

I'll rework this to make things a little bit more flexible.

Thanks,

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
