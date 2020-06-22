Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AE2C433EA
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 08:10:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D5F620809
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 08:10:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D5F620809
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 146D54B0B3;
	Mon, 22 Jun 2020 04:10:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JoiQBy7sjVbB; Mon, 22 Jun 2020 04:09:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2A174B08F;
	Mon, 22 Jun 2020 04:09:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8B6F4B08F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 04:09:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jZxDPUd7I5+K for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 04:09:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8D104A588
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 04:09:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3EEF31FB;
 Mon, 22 Jun 2020 01:09:56 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F32DF3F6CF;
 Mon, 22 Jun 2020 01:09:54 -0700 (PDT)
Subject: Re: [PATCH 0/4] arm64/x86: KVM: Introduce KVM_CAP_STEAL_TIME
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20200619184629.58653-1-drjones@redhat.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <20aaad52-c45a-7fe1-8295-6c4df748a1d8@arm.com>
Date: Mon, 22 Jun 2020 09:09:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619184629.58653-1-drjones@redhat.com>
Content-Language: en-GB
Cc: pbonzini@redhat.com, maz@kernel.org
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

On 19/06/2020 19:46, Andrew Jones wrote:
> This series introduces a KVM CAP for steal time to arm64 and x86.
> For arm64 the cap resolves a couple issues described in the second
> patch's commit message. The cap isn't necessary for x86, but is
> added for consistency.
> 
> Thanks,
> drew

LGTM, being able to probe whether nodelayacct has been specified makes 
sense and having it available before VCPU creation is even better. FWIW 
feel free to add:

Reviewed-by: Steven Price <steven.price@arm.com>

Thanks,

Steve

> Andrew Jones (4):
>    KVM: Documentation minor fixups
>    arm64/x86: KVM: Introduce steal time cap
>    tools headers kvm: Sync linux/kvm.h with the kernel sources
>    KVM: selftests: Use KVM_CAP_STEAL_TIME
> 
>   Documentation/virt/kvm/api.rst           | 20 ++++++++++++++++----
>   arch/arm64/kvm/arm.c                     |  3 +++
>   arch/x86/kvm/x86.c                       |  3 +++
>   include/uapi/linux/kvm.h                 |  1 +
>   tools/include/uapi/linux/kvm.h           | 15 +++++++++++++++
>   tools/testing/selftests/kvm/steal_time.c |  8 ++++++++
>   6 files changed, 46 insertions(+), 4 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
