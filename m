Return-Path: <SRS0=T7gh=UM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E01C31E45
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jun 2019 11:23:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6402D208CA
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jun 2019 11:23:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6402D208CA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB3164A4E9;
	Thu, 13 Jun 2019 07:23:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iv7JGgUZRkD5; Thu, 13 Jun 2019 07:23:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B21914A4A3;
	Thu, 13 Jun 2019 07:23:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC0E64A4A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jun 2019 07:23:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VeRWGO3prHb8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jun 2019 07:23:28 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D7D64A409
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jun 2019 07:23:28 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id A7DBEF7C1BDB2B979504;
 Thu, 13 Jun 2019 19:23:24 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Jun 2019
 19:23:16 +0800
Subject: Re: [PATCH v1 1/5] KVM: arm/arm64: Remove kvm_mmio_emulate tracepoint
To: James Morse <james.morse@arm.com>
References: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
 <1560330526-15468-2-git-send-email-yuzenghui@huawei.com>
 <e915c19a-51df-be88-ea3a-7c9a211f4518@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5885c607-1314-ff53-38f1-9f48b1c16de4@huawei.com>
Date: Thu, 13 Jun 2019 19:20:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <e915c19a-51df-be88-ea3a-7c9a211f4518@arm.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: acme@redhat.com, kvm@vger.kernel.org, marc.zyngier@arm.com,
 catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
 acme@kernel.org, linuxarm@huawei.com, linux-perf-users@vger.kernel.org,
 peterz@infradead.org, alexander.shishkin@linux.intel.com, mingo@redhat.com,
 xiexiangyou@huawei.com, ganapatrao.kulkarni@cavium.com, namhyung@kernel.org,
 jolsa@redhat.com, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi James,

On 2019/6/12 20:48, James Morse wrote:
> Hi,
> 
> On 12/06/2019 10:08, Zenghui Yu wrote:
>> In current KVM/ARM code, no one will invoke trace_kvm_mmio_emulate().
>> Remove this TRACE_EVENT definition.
> 
> Oooer. We can't just go removing these things, they are visible to user-space.
> 
> I recall an article on this: https://lwn.net/Articles/737530/
> "Another attempt to address the tracepoint ABI problem"
> 
> I agree this is orphaned, it was added by commit 45e96ea6b369 ("KVM: ARM: Handle I/O
> aborts"), but there never was a caller.
> 
> The problem with removing it is /sys/kernel/debug/tracing/events/kvm/kvm_mmio_emulate
> disappears. Any program relying on that being present (but useless) is now broken.
Thanks for the reminder.

It turned out that I knew little about the tracepoint ABI :( .
I'm OK to just drop this patch in next version.


Thanks,
zenghui


.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
