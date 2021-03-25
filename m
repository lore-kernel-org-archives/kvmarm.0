Return-Path: <SRS0=O4n2=IX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,TRACKER_ID,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A82C433C1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 11:14:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3BB3D61A12
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 11:14:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BB3D61A12
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4EE4B09B;
	Thu, 25 Mar 2021 07:14:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iUG9YWh-o+UY; Thu, 25 Mar 2021 07:14:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59CCC4B196;
	Thu, 25 Mar 2021 07:14:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B154B156
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 07:14:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q2QHjFWpPxZS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 07:13:59 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 554864B09B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 07:13:59 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 88287619E8;
 Thu, 25 Mar 2021 11:13:56 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lPNw2-003iXB-8y; Thu, 25 Mar 2021 11:13:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com,
 catalin.marinas@arm.com, james.morse@arm.com,
 Quentin Perret <qperret@google.com>, will@kernel.org
Subject: Re: [PATCH v6 00/38] KVM: arm64: Stage-2 for the host
Date: Thu, 25 Mar 2021 11:13:40 +0000
Message-Id: <161667080109.939459.4905727760554980398.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
References: <20210319100146.1149909-1-qperret@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com,
 catalin.marinas@arm.com, james.morse@arm.com, qperret@google.com,
 will@kernel.org, android-kvm@google.com, robh+dt@kernel.org, seanjc@google.com,
 tabba@google.com, linux-kernel@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 mate.toth-pal@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

On Fri, 19 Mar 2021 10:01:08 +0000, Quentin Perret wrote:
> This is the v6 of the series previously posted here:
> 
>   https://lore.kernel.org/r/20210315143536.214621-1-qperret@google.com/
> 
> This basically allows us to wrap the host with a stage 2 when running in
> nVHE, hence paving the way for protecting guest memory from the host in
> the future (among other use-cases). For more details about the
> motivation and the design angle taken here, I would recommend to have a
> look at the cover letter of v1, and/or to watch these presentations at
> LPC [1] and KVM forum 2020 [2].
> 
> [...]

Applied to next, thanks!

[01/38] arm64: lib: Annotate {clear, copy}_page() as position-independent
        commit: 8d9902055c57548bb342dc3ca78caa21e9643024
[02/38] KVM: arm64: Link position-independent string routines into .hyp.text
        commit: 7b4a7b5e6fefd15f708f959dd43e188444e252ec
[03/38] arm64: kvm: Add standalone ticket spinlock implementation for use at hyp
        commit: 67c2d326332ee28079348e43cf4f17bbfe63b260
[04/38] KVM: arm64: Initialize kvm_nvhe_init_params early
        commit: 9cc7758145fd24b17cff0734b7cfd80de30be052
[05/38] KVM: arm64: Avoid free_page() in page-table allocator
        commit: cc706a63894fdcc25d226378898921e1ab7dd64e
[06/38] KVM: arm64: Factor memory allocation out of pgtable.c
        commit: 7aef0cbcdcd0995efde9957b3eda9f31a219613d
[07/38] KVM: arm64: Introduce a BSS section for use at Hyp
        commit: 380e18ade4a51334e8806160e6f0fdfaca0b4428
[08/38] KVM: arm64: Make kvm_call_hyp() a function call at Hyp
        commit: 40a50853d37af3fd2e98b769e1a79839ad16b107
[09/38] KVM: arm64: Allow using kvm_nvhe_sym() in hyp code
        commit: fa21472a316af8ad7af3114049db89678444c7ed
[10/38] KVM: arm64: Introduce an early Hyp page allocator
        commit: e759604087231c672f91564cc805336e70d333a0
[11/38] KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
        commit: 40d9e41e525c13d07bc72d49968926f4502e5b33
[12/38] KVM: arm64: Introduce a Hyp buddy page allocator
        commit: 8e17c66249e9ea08b44879c7af0315e70a83316c
[13/38] KVM: arm64: Enable access to sanitized CPU features at EL2
        commit: 7a440cc78392c3caf805ef0afc7ead031e4d0830
[14/38] KVM: arm64: Provide __flush_dcache_area at EL2
        commit: d460df12926825a3926da91f054f9f11f88bb33e
[15/38] KVM: arm64: Factor out vector address calculation
        commit: bc1d2892e9aa6dcf6cd83adbd3616051cbd4c429
[16/38] arm64: asm: Provide set_sctlr_el2 macro
        commit: 8f4de66e247b805e1b3d1c15367ee0ef4cbb6003
[17/38] KVM: arm64: Prepare the creation of s1 mappings at EL2
        commit: f320bc742bc23c1d43567712fe2814bf04b19ebc
[18/38] KVM: arm64: Elevate hypervisor mappings creation at EL2
        commit: bfa79a805454f768b8d76ab683659d9e219a037a
[19/38] KVM: arm64: Use kvm_arch for stage 2 pgtable
        commit: 834cd93deb75f3a43420e479f133dd02fba95aa6
[20/38] KVM: arm64: Use kvm_arch in kvm_s2_mmu
        commit: cfb1a98de7a9aa51931ff5b336fc5c3c201d01cc
[21/38] KVM: arm64: Set host stage 2 using kvm_nvhe_init_params
        commit: 734864c177bca5148adfe7a96744993d61513430
[22/38] KVM: arm64: Refactor kvm_arm_setup_stage2()
        commit: bcb25a2b86b4b96385ffbcc54d51c400793b7393
[23/38] KVM: arm64: Refactor __load_guest_stage2()
        commit: 6ec7e56d3265f6e7673d0788bfa3a76820c9bdfe
[24/38] KVM: arm64: Refactor __populate_fault_info()
        commit: 159b859beed76836a2c7cfa6303c312a40bb9dc7
[25/38] KVM: arm64: Make memcache anonymous in pgtable allocator
        commit: e37f37a0e780f23210b2a5cb314dab39fea7086a
[26/38] KVM: arm64: Reserve memory for host stage 2
        commit: 04e5de03093f669ccc233e56b7838bfa7a7af6e1
[27/38] KVM: arm64: Sort the hypervisor memblocks
        commit: a14307f5310c737744641ff8da7a8d491c3c85cd
[28/38] KVM: arm64: Always zero invalid PTEs
        commit: f60ca2f9321a71ee3d2a7bd620c1827b82ce05f2
[29/38] KVM: arm64: Use page-table to track page ownership
        commit: 807923e04a0f5c6c34dc2eb52ae544cb0e4e4e66
[30/38] KVM: arm64: Refactor the *_map_set_prot_attr() helpers
        commit: 3fab82347ffb36c8b7b38dabc8e79276eeb1a81c
[31/38] KVM: arm64: Add kvm_pgtable_stage2_find_range()
        commit: 2fcb3a59401d2d12b5337b62c799eeb22cf40a2c
[32/38] KVM: arm64: Introduce KVM_PGTABLE_S2_NOFWB stage 2 flag
        commit: bc224df155c466178128a2950af16cba37b6f218
[33/38] KVM: arm64: Introduce KVM_PGTABLE_S2_IDMAP stage 2 flag
        commit: 8942a237c771b65f8bc1232536e4b4b829c7701f
[34/38] KVM: arm64: Provide sanitized mmfr* registers at EL2
        commit: def1aaf9e0bc6987bb4b417aac37226e994a1a74
[35/38] KVM: arm64: Wrap the host with a stage 2
        commit: 1025c8c0c6accfcbdc8f52ca1940160f65cd87d6
[36/38] KVM: arm64: Page-align the .hyp sections
        commit: b83042f0f143a5e9e899924987b542b2ac766e53
[37/38] KVM: arm64: Disable PMU support in protected mode
        commit: 9589a38cdfeba0889590e6ef4627b439034d456c
[38/38] KVM: arm64: Protect the .hyp sections from the host
        commit: 90134ac9cabb69972d0a509bf08e108a73442184

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
