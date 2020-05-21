Return-Path: <SRS0=uiGx=7D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77300C433E1
	for <kvmarm@archiver.kernel.org>; Thu, 21 May 2020 15:20:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F059620826
	for <kvmarm@archiver.kernel.org>; Thu, 21 May 2020 15:20:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1X0EAO5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F059620826
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE484B173;
	Thu, 21 May 2020 11:20:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1LE9PAH7PTIM; Thu, 21 May 2020 11:20:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 299564B167;
	Thu, 21 May 2020 11:20:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB55C4B167
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 May 2020 11:20:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1aw-uB0mQQQg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 May 2020 11:20:08 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3CE24B14B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 May 2020 11:20:07 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id ABAE320826;
 Thu, 21 May 2020 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590074407;
 bh=f1nY7jMdmh7McepRPv1Zarzh/Gloc+JyYZU3lokNqRw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=S1X0EAO5sYAiIS6QlUdEH52gOZOm948HKqbAmgyDoW3t0QgRZKNjh7F7ocqqR55sS
 bldU9fFYFue5Ov5s0b/tw80ZCMdwoccF2LmPyw19HXmdsqXnYKe+K1Hx5p0h3VvYpr
 hxBsW8VxOT+dmePNZna11IYbp9hZMN65jdcmOt+s=
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V4 00/17] arm64/cpufeature: Introduce ID_PFR2, ID_DFR1,
 ID_MMFR5 and other changes
Date: Thu, 21 May 2020 16:19:58 +0100
Message-Id: <159007243559.201193.1705879548179051424.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1589881254-10082-1-git-send-email-anshuman.khandual@arm.com>
References: <1589881254-10082-1-git-send-email-anshuman.khandual@arm.com>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, maz@kernel.org
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

On Tue, 19 May 2020 15:10:37 +0530, Anshuman Khandual wrote:
> This series is primarily motivated from an adhoc list from Mark Rutland
> during our previous ID_ISAR6 discussion [1]. The current proposal also
> accommodates some more suggestions from Will and Suzuki.
> 
> This series adds missing 32 bit system registers (ID_PFR2, ID_DFR1 and
> ID_MMFR5), adds missing features bits on all existing system registers
> (32 and 64 bit) and some other miscellaneous changes. While here it also
> includes a patch which does macro replacement for various open bits shift
> encodings for various CPU ID registers. There is a slight re-order of the
> patches here as compared to the previous version (V1).
> 
> [...]

Applied to arm64 (for-next/cpufeature), thanks!

[01/17] arm64/cpufeature: Add explicit ftr_id_isar0[] for ID_ISAR0 register
        https://git.kernel.org/arm64/c/2a5bc6c47bc3
[02/17] arm64/cpufeature: Drop TraceFilt feature exposure from ID_DFR0 register
        https://git.kernel.org/arm64/c/1ed1b90a0594
[03/17] arm64/cpufeature: Make doublelock a signed feature in ID_AA64DFR0
        https://git.kernel.org/arm64/c/e965bcb06256
[04/17] arm64/cpufeature: Introduce ID_PFR2 CPU register
        https://git.kernel.org/arm64/c/16824085a7dd
[05/17] arm64/cpufeature: Introduce ID_DFR1 CPU register
        https://git.kernel.org/arm64/c/dd35ec070457
[06/17] arm64/cpufeature: Introduce ID_MMFR5 CPU register
        https://git.kernel.org/arm64/c/152accf8476f
[07/17] arm64/cpufeature: Add remaining feature bits in ID_PFR0 register
        https://git.kernel.org/arm64/c/0ae43a99fe91
[08/17] arm64/cpufeature: Add remaining feature bits in ID_MMFR4 register
        https://git.kernel.org/arm64/c/fcd6535322cc
[09/17] arm64/cpufeature: Add remaining feature bits in ID_AA64ISAR0 register
        https://git.kernel.org/arm64/c/7cd51a5a84d1
[10/17] arm64/cpufeature: Add remaining feature bits in ID_AA64PFR0 register
        https://git.kernel.org/arm64/c/011e5f5bf529
[11/17] arm64/cpufeature: Add remaining feature bits in ID_AA64PFR1 register
        https://git.kernel.org/arm64/c/14e270fa5c4c
[12/17] arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR0 register
        (no commit info)
[13/17] arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR1 register
        (no commit info)
[14/17] arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR2 register
        (no commit info)
[15/17] arm64/cpufeature: Add remaining feature bits in ID_AA64DFR0 register
        (no commit info)
[16/17] arm64/cpufeature: Replace all open bits shift encodings with macros
        (no commit info)
[17/17] arm64/cpuinfo: Add ID_MMFR4_EL1 into the cpuinfo_arm64 context
        https://git.kernel.org/arm64/c/858b8a8039d0

Note that Suzuki had comments on 12-16, so assume you'll respin those (I fixed
up the trivial comments on earlier patches myself).

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
