Return-Path: <SRS0=6Z91=G2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6753AC433DB
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jan 2021 14:45:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0EA822AAB
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jan 2021 14:45:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0EA822AAB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46C444B147;
	Sat, 23 Jan 2021 09:45:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dsJ+whz3zq5A; Sat, 23 Jan 2021 09:45:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 174A34B129;
	Sat, 23 Jan 2021 09:45:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 269ED4B120
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jan 2021 09:45:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id opZUbFziPGwQ for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Jan 2021 09:45:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34DD04B10F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jan 2021 09:45:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1A06C22A99;
 Sat, 23 Jan 2021 14:45:09 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l3K9z-009cK9-1I; Sat, 23 Jan 2021 14:45:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v2 0/8] arm64: Relocate absolute hyp VAs
Date: Sat, 23 Jan 2021 14:45:03 +0000
Message-Id: <161141308090.170536.9590935118686759485.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210105180541.65031-1-dbrazdil@google.com>
References: <20210105180541.65031-1-dbrazdil@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, dbrazdil@google.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 will@kernel.org, ardb@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ardb@kernel.org>
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

On Tue, 5 Jan 2021 18:05:33 +0000, David Brazdil wrote:
> nVHE hyp code is linked into the same kernel binary but executes under
> different memory mappings. If the compiler of hyp code chooses absolute
> addressing for accessing a symbol, the kernel linker will relocate that
> address to a kernel image virtual address, causing a runtime exception.
> 
> So far the strategy has been to force PC-relative addressing by wrapping
> all symbol references with the hyp_symbol_addr macro. This is error
> prone and developer unfriendly.
> 
> [...]

Applied to kvm-arm64/hyp-reloc, thanks!

[1/8] KVM: arm64: Rename .idmap.text in hyp linker script
      commit: eceaf38f521982bad6dbac1c02becdd80fd6af7c
[2/8] KVM: arm64: Set up .hyp.rodata ELF section
      commit: 16174eea2e4fe8247e04c17da682f2034fec0369
[3/8] KVM: arm64: Add symbol at the beginning of each hyp section
      commit: f7a4825d9569593b9a81f0768313b86175691ef1
[4/8] KVM: arm64: Generate hyp relocation data
      commit: 8c49b5d43d4c45ca0bb0d1faa23feef2e76e89fa
[5/8] KVM: arm64: Apply hyp relocations at runtime
      commit: 6ec6259d7084ed32e164c9f7b69049464dd90fa5
[6/8] KVM: arm64: Fix constant-pool users in hyp
      commit: 97cbd2fc0257c6af7036a9a6415ca8ad43535d6b
[7/8] KVM: arm64: Remove patching of fn pointers in hyp
      commit: 537db4af26e3f2e0f304f2032bc593f7e2a54938
[8/8] KVM: arm64: Remove hyp_symbol_addr
      commit: 247bc166e6b3b1e4068f120f55582a3aa210cc2d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
