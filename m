Return-Path: <SRS0=bMLL=C6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97245C4346B
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 12:54:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 04BD62193E
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 12:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bd4CEumb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04BD62193E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C84B4B5AA;
	Mon, 21 Sep 2020 08:54:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
X-Amavis-Alert: BAD HEADER SECTION, Header field occurs more than once: "To"
	occurs 3 times
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hDFmKHA5VQ-6; Mon, 21 Sep 2020 08:54:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14F464B5B3;
	Mon, 21 Sep 2020 08:54:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 315F44B5AA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 08:54:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
X-Amavis-Alert: BAD HEADER SECTION, Header field occurs more than once: "To"
 occurs 3 times
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0SFWwFQ7YJCG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Sep 2020 08:54:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99D3B4B5AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 08:54:52 -0400 (EDT)
Received: from localhost (unknown [70.37.104.77])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 408A521789;
 Mon, 21 Sep 2020 12:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600692891;
 bh=6BpQfGWNq5AeSmB8Rcsu/mpwu6St8WiO7qawdNRIpwI=;
 h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
 b=bd4CEumbLMYlcCESTe6qemij0oropUhVI8oqyCDTtmaevDJT+2YQI2azPF5tgaJnr
 Cqz+W8GXioR3y8xnncYH5jKpdznKTRZTtmNTvhpAYmkZC8qLKabULo8uPxgHG5YqZg
 ArXLdU2UDmqCltboQ6AUnYEeWbwJYKSPOd5gDzyQ=
Date: Mon, 21 Sep 2020 12:54:50 +0000
From: Sasha Levin <sashal@kernel.org>
To: Sasha Levin <sashal@kernel.org>
To: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 1/2] KVM: arm64: Assume write fault on S1PTW permission
 fault on instruction fetch
In-Reply-To: <20200915104218.1284701-2-maz@kernel.org>
References: <20200915104218.1284701-2-maz@kernel.org>
Message-Id: <20200921125451.408A521789@mail.kernel.org>
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 stable@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Failed to apply! Possible dependencies:
    09cf57eba304 ("KVM: arm64: Split hyp/switch.c to VHE/nVHE")
    208243c752a7 ("KVM: arm64: Move hyp-init.S to nVHE")
    3a949f4c9354 ("KVM: arm64: Rename HSR to ESR")
    7621712918ad ("KVM: arm64: Add build rules for separate VHE/nVHE object files")
    7b2399ea5640 ("KVM: arm64: Move __smccc_workaround_1_smc to .rodata")
    b877e9849d41 ("KVM: arm64: Build hyp-entry.S separately for VHE/nVHE")
    f50b6f6ae131 ("KVM: arm64: Handle calls to prefixed hyp functions")

v5.4.66: Failed to apply! Possible dependencies:
    0492747c72a3 ("arm64: KVM: Invoke compute_layout() before alternatives are applied")
    0e20f5e25556 ("KVM: arm/arm64: Cleanup MMIO handling")
    29eb5a3c57f7 ("KVM: arm64: Handle PtrAuth traps early")
    3a949f4c9354 ("KVM: arm64: Rename HSR to ESR")
    5c37f1ae1c33 ("KVM: arm64: Ask the compiler to __always_inline functions used at HYP")
    8e01d9a396e6 ("KVM: arm64: vgic-v4: Move the GICv4 residency flow to be driven by vcpu_load/put")
    c726200dd106 ("KVM: arm/arm64: Allow reporting non-ISV data aborts to userspace")

v4.19.146: Failed to apply! Possible dependencies:
    0e20f5e25556 ("KVM: arm/arm64: Cleanup MMIO handling")
    3a949f4c9354 ("KVM: arm64: Rename HSR to ESR")
    5c37f1ae1c33 ("KVM: arm64: Ask the compiler to __always_inline functions used at HYP")
    5ffdfaedfa0a ("arm64: mm: Support Common Not Private translations")
    86d0dd34eaff ("arm64: cpufeature: add feature for CRC32 instructions")
    caab277b1de0 ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 234")
    d94d71cb45fd ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 266")

v4.14.198: Failed to apply! Possible dependencies:
    1fc5dce78ad1 ("arm64/sve: Low-level SVE architectural state manipulation functions")
    2e0f2478ea37 ("arm64/sve: Probe SVE capabilities and usable vector lengths")
    3a949f4c9354 ("KVM: arm64: Rename HSR to ESR")
    43994d824e84 ("arm64/sve: Detect SVE and activate runtime support")
    5c37f1ae1c33 ("KVM: arm64: Ask the compiler to __always_inline functions used at HYP")
    611a7bc74ed2 ("arm64: docs: describe ELF hwcaps")
    746647c75afb ("arm64: entry.S convert el0_sync")
    7582e22038a2 ("arm64/sve: Backend logic for setting the vector length")
    79ab047c75d6 ("arm64/sve: Support vector length resetting for new processes")
    94ef7ecbdf6f ("arm64: fpsimd: Correctly annotate exception helpers called from asm")
    bc0ee4760364 ("arm64/sve: Core task context handling")
    ddd25ad1fde8 ("arm64/sve: Kconfig update and conditional compilation support")

v4.9.236: Failed to apply! Possible dependencies:
    016f98afd050 ("irqchip/gic-v3: Use nops macro for Cavium ThunderX erratum 23154")
    0e9884fe63c6 ("arm64: sysreg: subsume GICv3 sysreg definitions")
    328191c05ed7 ("irqchip/gic-v3-its: Specialise flush_dcache operation")
    38fd94b0275c ("arm64: Work around Falkor erratum 1003")
    3a949f4c9354 ("KVM: arm64: Rename HSR to ESR")
    43994d824e84 ("arm64/sve: Detect SVE and activate runtime support")
    47863d41ecf8 ("arm64: sysreg: sort by encoding")
    4aa8a472c33f ("arm64: Documentation - Expose CPU feature registers")
    5c37f1ae1c33 ("KVM: arm64: Ask the compiler to __always_inline functions used at HYP")
    611a7bc74ed2 ("arm64: docs: describe ELF hwcaps")
    6e01398fe450 ("arm64: arch_timer: document Hisilicon erratum 161010101")
    b20d1ba3cf4b ("arm64: cpufeature: allow for version discrepancy in PMU implementations")
    b389d7997acb ("arm64: cpufeature: treat unknown fields as RES0")
    bca8f17f57bd ("arm64: Get rid of asm/opcodes.h")
    c7a3c61fc606 ("arm64: sysreg: add performance monitor registers")
    cd9e1927a525 ("arm64: Work around broken .inst when defective gas is detected")
    d9ff80f83ecb ("arm64: Work around Falkor erratum 1009")
    eab43e88734f ("arm64: cpufeature: Cleanup feature bit tables")
    eeb1efbcb83c ("arm64: cpu_errata: Add capability to advertise Cortex-A73 erratum 858921")
    f31deaadff0d ("arm64: cpufeature: Don't enforce system-wide SPE capability")
    fe4fbdbcddea ("arm64: cpufeature: Track user visible fields")

v4.4.236: Failed to apply! Possible dependencies:
    06282fd2c2bf ("arm64: KVM: Implement vgic-v2 save/restore")
    0e9884fe63c6 ("arm64: sysreg: subsume GICv3 sysreg definitions")
    1b8e83c04ee2 ("arm64: KVM: vgic-v3: Avoid accessing ICH registers")
    2d81d425b6d5 ("irqchip/gicv3-its: Introduce two helper functions for accessing BASERn")
    328191c05ed7 ("irqchip/gic-v3-its: Specialise flush_dcache operation")
    3a949f4c9354 ("KVM: arm64: Rename HSR to ESR")
    3c13b8f435ac ("KVM: arm/arm64: vgic-v3: Make the LR indexing macro public")
    3faf24ea894a ("irqchip/gicv3-its: Implement two-level(indirect) device table support")
    466b7d168881 ("irqchip/gicv3-its: Don't allow devices whose ID is outside range")
    4b75c4598b5b ("irqchip/gicv3-its: Add a new function for parsing device table BASERn")
    5c37f1ae1c33 ("KVM: arm64: Ask the compiler to __always_inline functions used at HYP")
    91ef84428a86 ("irqchip/gic-v3: Reset BPR during initialization")
    9347359ad0ae ("irqchip/gicv3-its: Split its_alloc_tables() into two functions")
    b5525ce898eb ("arm64: KVM: Move GIC accessors to arch_gicv3.h")
    c76a0a6695c6 ("arm64: KVM: Add a HYP-specific header file")
    d44ffa5ae70a ("irqchip/gic-v3: Convert arm64 GIC accessors to {read,write}_sysreg_s")
    f68d2b1b73cc ("arm64: KVM: Implement vgic-v3 save/restore")
    fd451b90e78c ("arm64: KVM: vgic-v3: Restore ICH_APR0Rn_EL2 before ICH_APR1Rn_EL2")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
