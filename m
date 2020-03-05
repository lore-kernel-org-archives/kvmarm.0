Return-Path: <SRS0=Em7b=4W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B77C3F2CD
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 03:40:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5EE412064A
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 03:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EE412064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC40C4AED6;
	Wed,  4 Mar 2020 22:40:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9yS6kCVecXMF; Wed,  4 Mar 2020 22:40:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A13AC4AEB5;
	Wed,  4 Mar 2020 22:40:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 836EF4AEB5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2020 22:40:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0KSaQ78qxTV6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2020 22:40:08 -0500 (EST)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 016EF4AEB4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2020 22:40:07 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id AD4361CEF13762CC0BFD;
 Thu,  5 Mar 2020 11:40:00 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Mar 2020
 11:39:52 +0800
Subject: Re: [PATCH v5 00/23] irqchip/gic-v4: GICv4.1 architecture support
To: Marc Zyngier <maz@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5613bec0-a207-1e59-82d0-8d44fc65a0a4@huawei.com>
Date: Thu, 5 Mar 2020 11:39:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-1-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
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

Hi Marc,

On 2020/3/5 4:33, Marc Zyngier wrote:
> This (now shorter) series expands the existing GICv4 support to deal
> with the new GICv4.1 architecture, which comes with a set of major
> improvements compared to v4.0:
> 
> - One architectural doorbell per vcpu, instead of one doorbell per VLPI
> 
> - Doorbell entirely managed by the HW, with an "at most once" delivery
>    guarantee per non-residency phase and only when requested by the
>    hypervisor
> 
> - A shared memory scheme between ITSs and redistributors, allowing for an
>    optimised residency sequence (the use of VMOVP becomes less frequent)
> 
> - Support for direct virtual SGI delivery (the injection path still involves
>    the hypervisor), at the cost of losing the active state on SGIs. It
>    shouldn't be a big deal, but some guest operating systems might notice
>    (Linux definitely won't care).
> 
> On the other hand, public documentation is not available yet, so that's a
> bit annoying...
> 
> The series is roughly organised in 3 parts:
> 
> (0) Fixes
> (1) v4.1 doorbell management
> (2) Virtual SGI support
> (3) Plumbing of virtual SGIs in KVM
> 
> Notes:
> 
>    - The whole thing is tested on a FVP model, which can be obtained
>      free of charge on ARM's developer website. It requires you to
>      create an account, unfortunately... You'll need a fix for the
>      devicetree that is in the kernel tree (should be merged before
>      the 5.6 release).
> 
>    - This series has uncovered a behaviour that looks like a HW bug on
>      the Cavium ThunderX (aka TX1) platform. I'd very much welcome some
>      clarification from the Marvell/Cavium folks on Cc, as well as an
>      official erratum number if this happens to be an actual bug.
> 
>      [v3 update]
>      People have ignored for two months now, and it is fairly obvious
>      that support for this machine is slowly bit-rotting. Maybe I'll
>      drop the patch and instead start the process of removing all TX1
>      support from the kernel (we'd certainly be better off without it).
> 
>      [v4 update]
>      TX1 is now broken in mainline, and nobody cares. Make of this what
>      you want.
> 
>    - I'm extremely grateful for Zenghui Yu's huge effort in carefully
>      reviewing this rather difficult series (if we ever get to meet
>      face to face, drinks are definitely on me!).

It's a pleasure to review this work and it's pretty useful for
understanding how Linux works as a GICv4.1-capable hypervisor.
Yay, cheers ;-)!

I'll go through the v4.1 spec one more time before the final
review of this series, as we still have plenty of time to do
some reviews (and even some tests) before the 5.7 MW.

> 
>    - Unless someone cries wolf, I plan to take this into 5.7.

Good news!


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
