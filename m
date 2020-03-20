Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC2DC43332
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 09:14:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 253DA20767
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 09:14:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 253DA20767
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A45DE4B082;
	Fri, 20 Mar 2020 05:14:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aQ7YhWgYNNKq; Fri, 20 Mar 2020 05:14:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 098AD4B08A;
	Fri, 20 Mar 2020 05:14:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 186484A4FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 05:14:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OI0tcw0H8xUD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 05:14:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FE874A4CD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 05:14:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F326830E;
 Fri, 20 Mar 2020 02:14:50 -0700 (PDT)
Received: from [192.168.0.106] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB82B3F305;
 Fri, 20 Mar 2020 02:14:49 -0700 (PDT)
Subject: Re: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
To: Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>
References: <20200221165532.90618-1-andre.przywara@arm.com>
 <20200318215847.GC8477@willie-the-truck>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1a9578a8-8907-94f6-0f8f-ad8ff08b5028@arm.com>
Date: Fri, 20 Mar 2020 09:15:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200318215847.GC8477@willie-the-truck>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Raphael Gault <raphael.gault@arm.com>,
 Sami Mujawar <sami.mujawar@arm.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On 3/18/20 9:58 PM, Will Deacon wrote:

> On Fri, Feb 21, 2020 at 04:55:32PM +0000, Andre Przywara wrote:
>> From: Raphael Gault <raphael.gault@arm.com>
>>
>> The EDK II UEFI firmware implementation requires some storage for the EFI
>> variables, which is typically some flash storage.
>> Since this is already supported on the EDK II side, we add a CFI flash
>> emulation to kvmtool.
>> This is backed by a file, specified via the --flash or -F command line
>> option. Any flash writes done by the guest will immediately be reflected
>> into this file (kvmtool mmap's the file).
>> The flash will be limited to the nearest power-of-2 size, so only the
>> first 2 MB of a 3 MB file will be used.
>>
>> This implements a CFI flash using the "Intel/Sharp extended command
>> set", as specified in:
>> - JEDEC JESD68.01
>> - JEDEC JEP137B
>> - Intel Application Note 646
>> Some gaps in those specs have been filled by looking at real devices and
>> other implementations (QEMU, Linux kernel driver).
>>
>> At the moment this relies on DT to advertise the base address of the
>> flash memory (mapped into the MMIO address space) and is only enabled
>> for ARM/ARM64. The emulation itself is architecture agnostic, though.
>>
>> This is one missing piece toward a working UEFI boot with kvmtool on
>> ARM guests, the other is to provide writable PCI BARs, which is WIP.
>>
>> Signed-off-by: Raphael Gault <raphael.gault@arm.com>
>> [Andre: rewriting and fixing]
>> Signed-off-by: Andre Przywra <andre.przywara@arm.com>
>> ---
>> Hi,
>>
>> an update fixing Alexandru's review comments (many thanks for those!)
>> The biggest change code-wise is the split of the MMIO handler into three
>> different functions. Another significant change is the rounding *down* of
>> the present flash file size to the nearest power-of-two, to match flash
>> hardware chips and Linux' expectations.
> Alexandru -- are you happy with this now?

I really appreciate taking the time to look at it, but at the moment I'm busy
testing v3 of the reassignable BARs and PCIE support [1]. I'll try to send the
patches as soon as possible, then I'll review this patch.

[1] https://www.spinics.net/lists/kvm/msg204878.html

Thanks,
Alex
>
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
