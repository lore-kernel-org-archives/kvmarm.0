Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29264C432BE
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 16:52:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD799610FF
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 16:52:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AD799610FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 359234A3A3;
	Mon,  2 Aug 2021 12:52:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kCH545w4hvpj; Mon,  2 Aug 2021 12:52:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12E3D40667;
	Mon,  2 Aug 2021 12:52:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8194340667
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 12:52:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uUwSWOqzuQwM for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 12:52:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C60040623
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 12:52:20 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89CCB610FF;
 Mon,  2 Aug 2021 16:52:17 +0000 (UTC)
Date: Mon, 2 Aug 2021 17:52:14 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Unregister HYP sections from kmemleak
 in protected mode
Message-ID: <20210802165214.GK18685@arm.com>
References: <20210802123830.2195174-1-maz@kernel.org>
 <20210802123830.2195174-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210802123830.2195174-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, Aug 02, 2021 at 01:38:30PM +0100, Marc Zyngier wrote:
> Booting a KVM host in protected mode with kmemleak quickly results
> in a pretty bad crash, as kmemleak doesn't know that the HYP sections
> have been taken away. This is specially true for the BSS section,
> which is part of the kernel BSS section and registered at boot time
> by kmemleak itself.
> 
> Unregister the HYP part of the BSS before making that section
> HYP-private. The rest of the HYP-specific data is obtained via
> the page allocator or lives in other sections, none of which is
> subjected to kmemleak.
> 
> Fixes: 90134ac9cabb ("KVM: arm64: Protect the .hyp sections from the host")
> Reviewed-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: stable@vger.kernel.org # 5.13

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
