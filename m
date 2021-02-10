Return-Path: <SRS0=D7pb=HM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8FDC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Feb 2021 16:03:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AFDF664E0B
	for <kvmarm@archiver.kernel.org>; Wed, 10 Feb 2021 16:03:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFDF664E0B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 170484B3D5;
	Wed, 10 Feb 2021 11:03:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ep80mKuVVHmL; Wed, 10 Feb 2021 11:03:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F0B4B3E8;
	Wed, 10 Feb 2021 11:03:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BAC64B3D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2021 11:03:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6mKNInmSXN7v for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Feb 2021 11:03:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CDC64B3C9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2021 11:03:17 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E0BA113E;
 Wed, 10 Feb 2021 08:03:16 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE5D83F73B;
 Wed, 10 Feb 2021 08:03:13 -0800 (PST)
Subject: Re: [RFC PATCH v8 5/5] KVM: arm64: ioctl to fetch/store tags in a
 guest
To: Peter Maydell <peter.maydell@linaro.org>
References: <20210205135803.48321-1-steven.price@arm.com>
 <20210205135803.48321-6-steven.price@arm.com>
 <CAFEAcA99kV_d6ev9wC4ySiyoD7Cp=HCD0v2bBhGSOU-KrzkqaQ@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <1e09d70a-1443-c7bd-2d16-f50bc3993a83@arm.com>
Date: Wed, 10 Feb 2021 16:03:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA99kV_d6ev9wC4ySiyoD7Cp=HCD0v2bBhGSOU-KrzkqaQ@mail.gmail.com>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dave Martin <Dave.Martin@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On 08/02/2021 17:31, Peter Maydell wrote:
> On Fri, 5 Feb 2021 at 13:58, Steven Price <steven.price@arm.com> wrote:
>>
>> The VMM may not wish to have it's own mapping of guest memory mapped
>> with PROT_MTE because this causes problems if the VMM has tag checking
>> enabled (the guest controls the tags in physical RAM and it's unlikely
>> the tags are correct for the VMM).
>>
>> Instead add a new ioctl which allows the VMM to easily read/write the
>> tags from guest memory, allowing the VMM's mapping to be non-PROT_MTE
>> while the VMM can still read/write the tags for the purpose of
>> migration.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/uapi/asm/kvm.h | 13 +++++++
>>   arch/arm64/kvm/arm.c              | 57 +++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h          |  1 +
>>   3 files changed, 71 insertions(+)
> 
> Missing the update to the docs in Documentation/virtual/kvm/api.txt :-)

Good point - although I was secretly hoping to get some feedback on the 
concepts before writing the documentation! But I guess the documentation 
will help with the review. I'll include some in the next posting.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
