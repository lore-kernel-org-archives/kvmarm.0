Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AAEC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 19:14:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DA974B9B5;
	Wed,  9 Nov 2022 14:14:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id im0MY6SA4anb; Wed,  9 Nov 2022 14:14:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 542A74B97A;
	Wed,  9 Nov 2022 14:14:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33CBC4B97A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 14:14:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kzjrroozdpgq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 14:14:17 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14C404B974
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 14:14:17 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 94AC1B81FFA;
 Wed,  9 Nov 2022 19:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF08C433C1;
 Wed,  9 Nov 2022 19:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668021254;
 bh=1uVDPNJRQ+D3xfqxDufJ9hfMqQFP0sCRLukEn84C9tc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bqEgvkKsUshQBVyh05e4wb4YfxyMwRH1UulPWrOWqpOtoNuwcva78j9sr3AGlX1GK
 SUaJpgJZ0MR3VDUnzXk64yKL+xO35EwSlp6e6g8pH//Uxcoq/EoQ0t8Gc65g7uTArl
 Fo+7DHewb1AydQT641SYKiRl8eViJTyw9r7sKuKRHPjkjbVLYlH1mlFZwN34tleoTj
 6SXL8gKdpkyOxgnCvcvs1alzDCWABQQRJrECrkRBtLdefzVWetFYM+E6mUpQzpmc9M
 7es1n20IMzpLYxGUKfGuGulLiXY7khojzo3/hSzxRDi5Ujq+6aJpBNmq8gQd3deSmn
 9pa4COGZY2Nww==
From: Will Deacon <will@kernel.org>
To: mark.rutland@arm.com, linux-kernel@vger.kernel.org,
 Usama Arif <usama.arif@bytedance.com>, steven.price@arm.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 linux@armlinux.org.uk, yezengruan@huawei.com, catalin.marinas@arm.com,
 virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] arm64: paravirt: remove conduit check in
 has_pv_steal_clock
Date: Wed,  9 Nov 2022 19:14:00 +0000
Message-Id: <166801751676.863548.12274621159317849693.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221104061659.4116508-1-usama.arif@bytedance.com>
References: <20221104061659.4116508-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Cc: punit.agrawal@bytedance.com, Will Deacon <will@kernel.org>,
 liangma@liangbit.com, kernel-team@android.com, fam.zheng@bytedance.com
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

On Fri, 4 Nov 2022 06:16:59 +0000, Usama Arif wrote:
> arm_smccc_1_1_invoke() which is called later on in the function
> will return failure if there's no conduit (or pre-SMCCC 1.1),
> hence the check is unnecessary.
> 
> 

Applied to arm64 (for-next/trivial), thanks!

[1/1] arm64: paravirt: remove conduit check in has_pv_steal_clock
      https://git.kernel.org/arm64/c/1e55b44d9ecd

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
