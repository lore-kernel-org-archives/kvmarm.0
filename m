Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AE8C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 10:08:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57EB92251F
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 10:08:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57EB92251F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FB5B4B2FB;
	Tue,  5 Jan 2021 05:08:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SIgjASn5HL9O; Tue,  5 Jan 2021 05:08:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 959B94B2E5;
	Tue,  5 Jan 2021 05:08:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1C8C4B28B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 05:08:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E381Ly36y36t for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 05:08:53 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADD844B284
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 05:08:53 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2890C224F9;
 Tue,  5 Jan 2021 10:08:50 +0000 (UTC)
Date: Tue, 5 Jan 2021 10:08:47 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH] arm64/smp: Remove unused variable irq in
 arch_show_interrupts()
Message-ID: <20210105100847.GB11802@gaia>
References: <20210105092221.15144-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210105092221.15144-1-zhukeqian1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>
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

On Tue, Jan 05, 2021 at 05:22:21PM +0800, Keqian Zhu wrote:
> The local variable irq is added in commit a26388152531 ("arm64:
> Remove custom IRQ stat accounting"), but forget to remove in
> commit 5089bc51f81f ("arm64/smp: Use irq_desc_kstat_cpu() in
> arch_show_interrupts()"). Just remove it.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>

I already queued a similar fix in arm64 for-next/fixes (it should appear
in linux-next at some point).

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
