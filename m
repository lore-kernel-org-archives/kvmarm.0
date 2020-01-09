Return-Path: <SRS0=UWlR=26=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3815FC33C9E
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 03:07:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A88AF2067D
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 03:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A88AF2067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E06F84B193;
	Wed,  8 Jan 2020 22:07:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 31fSiB+BLm7m; Wed,  8 Jan 2020 22:07:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF2514B194;
	Wed,  8 Jan 2020 22:07:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84D8A4B192
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 22:07:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LW2PVPquO92Y for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jan 2020 22:07:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40F574B18E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 22:07:47 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F353131B;
 Wed,  8 Jan 2020 19:07:45 -0800 (PST)
Received: from [10.162.40.138] (p8cg001049571a15.blr.arm.com [10.162.40.138])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 B53F93F534; Wed,  8 Jan 2020 19:07:41 -0800 (PST)
Subject: Re: [PATCH 0/1] arm/arm64: add support for folded p4d page tables
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20191230082734.28954-1-rppt@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <19fc0640-2b7e-a06f-a4c8-2736d54dd565@arm.com>
Date: Thu, 9 Jan 2020 08:38:54 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191230082734.28954-1-rppt@kernel.org>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Marc Zyngier <maz@kernel.org>,
 Mike Rapoport <rppt@linux.ibm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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



On 12/30/2019 01:57 PM, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Hi,

Hello Mike,

> 
> This is a part of clean up of the page table manipulation code that aims to
> remove asm-generic/5level-fixup.h and asm-generic/pgtable-nop4d-hack.h
> 
> There is a single patch for both arm and arm64 because doing the conversion
> separately would mean breaking the shared mmu bits in virt/kvm/arm.
> 
> The patch is build tested and boot tested on qemu-system-{arm,aarch64}.

There are lots of code changes here for a single patch but as you have
mentioned shared KVM bits would have prevented splitting arm and arm64
changes into separate patches. Just curious, are you planning to respin
this patch sooner after fixing the reported build problems caused by
missing p4d_offset_kimg() and p4d_sect() definitions ?

- Anshuman
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
