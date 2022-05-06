Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE16C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  6 May 2022 14:43:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FBB74B206;
	Fri,  6 May 2022 10:43:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lSZm71JySgyD; Fri,  6 May 2022 10:43:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E797A4B178;
	Fri,  6 May 2022 10:43:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 504D94B166
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:43:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tnulR2pEaNRJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 10:43:41 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 159084B149
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:43:40 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D6E4362166;
 Fri,  6 May 2022 14:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197C1C385A8;
 Fri,  6 May 2022 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651848219;
 bh=0j76hIkpeRs5fyz1Qz1mC/g6UyUpxVbdm5Jx+U7l44I=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=N2K+/iJBbptRanwa5FT4TSVLs3zlcX0SEHtwLRkfgLr6gsyWQLE+2atdhbIUMmSSV
 8jqofE/gE5K+tQqYHrLpRQn1LxXTL+l9ujDSei9K9kQP8ZsOm1y5f1CEdzCTH2VClF
 wds7KTIDaEHlWVN24F1IR8GtSA8Vn3DiQ4kJ4PTfReP2kGG4inoMyvADUrL0h95FaM
 rPm8OTFX3LHmddJgI0FslTVtvHBYoOYA9OGU8dCUWXDqUzrxdlRCuPBMO9BlTQYQB0
 Bok5Ce6XXI1erYRwPrRoKoLcHra3D46q3YIlejqd0q13NsiBRUq1UB5K2V8+/jW85e
 8nEk8hMgLiC3w==
From: Will Deacon <will@kernel.org>
To: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org,
 suzuki.poulose@arm.com, maz@kernel.org, james.morse@arm.com,
 Alexandru Elisei <alexandru.elisei@arm.com>, julien.thierry.kdev@gmail.com,
 mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v3 kvmtool 00/11] arm64: Improve PMU support on
 heterogeneous systems
Date: Fri,  6 May 2022 15:43:28 +0100
Message-Id: <165184327685.738413.15743735905204905136.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220412133231.35355-1-alexandru.elisei@arm.com>
References: <20220412133231.35355-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 Will Deacon <will@kernel.org>
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

On Tue, 12 Apr 2022 14:32:20 +0100, Alexandru Elisei wrote:
> The series can be found at [1].
> 
> The series adds support for the KVM_ARM_VCPU_PMU_V3_SET_PMU PMU attribute,
> which allows userspace to set a PMU for a VCPU. This PMU is used by KVM
> when creating perf events to emulate the guest PMU.
> 
> Without settings this attribute, the PMU used when creating events is the
> first one that successfully probed when booting, but this is unreliable as
> the probe order can change (if the order of the PMUs is changed in the DTB
> or if asynchronous driver probing is enabled on the host's command line),
> and furthermore it requires the user to have intimate knowledge of how the
> PMU was chosen in order to pin the VM on the correct physical CPUs.
> 
> [...]

Applied to kvmtool (master), thanks!

[01/11] linux/err.h: Add missing stdbool.h include
        https://git.kernel.org/will/kvmtool/c/443cd881b471
[02/11] linux/bitops.h: Include wordsize.h to provide the __WORDSIZE define
        https://git.kernel.org/will/kvmtool/c/d9b64eb6aa05
[03/11] arm/arm64: pmu.h: Add missing header guards
        https://git.kernel.org/will/kvmtool/c/5898515dc727
[04/11] arm: Move arch specific VCPU features to the arch specific function
        https://git.kernel.org/will/kvmtool/c/412ee1375de8
[05/11] arm: Get rid of the ARM_VCPU_FEATURE_FLAGS() macro
        https://git.kernel.org/will/kvmtool/c/b23aed2ae11e
[06/11] arm: Make the PMUv3 emulation code arm64 specific
        https://git.kernel.org/will/kvmtool/c/f57ce4477092
[07/11] arm64: Rework set_pmu_attr()
        https://git.kernel.org/will/kvmtool/c/83713e75cd65
[08/11] Add cpumask functions
        https://git.kernel.org/will/kvmtool/c/0febaae00bb6
[09/11] update_headers.sh: Sync ABI headers with Linux v5.18-rc2
        https://git.kernel.org/will/kvmtool/c/083a976e0f08
[10/11] arm64: Add support for KVM_ARM_VCPU_PMU_V3_SET_PMU
        https://git.kernel.org/will/kvmtool/c/1393bda01407
[11/11] arm64: Add --vcpu-affinity command line argument
        https://git.kernel.org/will/kvmtool/c/4639b72f61a3

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
