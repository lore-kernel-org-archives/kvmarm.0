Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5B9C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 29 Apr 2022 19:19:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD4C40DE6;
	Fri, 29 Apr 2022 15:19:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l+GeXJDNbmH5; Fri, 29 Apr 2022 15:19:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A65749DFF;
	Fri, 29 Apr 2022 15:19:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE61540FB6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 15:19:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Q5MldVUWoH7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2022 15:19:50 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6555840DE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 15:19:50 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 3BADACE34A4;
 Fri, 29 Apr 2022 19:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA944C385A4;
 Fri, 29 Apr 2022 19:19:43 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>, suzuki.poulose@arm.com,
 mark.rutland@arm.com, james.morse@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v3 0/5] arm64: Treat ESR_ELx as a 64-bit register
Date: Fri, 29 Apr 2022 20:19:41 +0100
Message-Id: <165125997389.375315.3646642430784518275.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425114444.368693-1-alexandru.elisei@arm.com>
References: <20220425114444.368693-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

On Mon, 25 Apr 2022 12:44:39 +0100, Alexandru Elisei wrote:
> The ESR_EL{1,2} registers were originally 32-bit, then were extended to
> 64-bit with the upper 32 bits RES0, and in ARM DDI 0487H.a the FEAT_LS64
> feature was added which now makes use of the upper bits. This series aims
> to teach Linux to treat it consistently as a 64-bit register with the goal
> of making it easier to add support in the future for features that use the
> upper 32 bits.
> 
> [...]

Applied to arm64 (for-next/esr-elx-64-bit), thanks!

[1/5] arm64: Make ESR_ELx_xVC_IMM_MASK compatible with assembly
      https://git.kernel.org/arm64/c/a99ef9cb4b79
[2/5] arm64: compat: Do not treat syscall number as ESR_ELx for a bad syscall
      https://git.kernel.org/arm64/c/3fed9e551417
[3/5] arm64: Treat ESR_ELx as a 64-bit register
      https://git.kernel.org/arm64/c/8d56e5c5a99c
[4/5] KVM: arm64: Treat ESR_EL2 as a 64-bit register
      https://git.kernel.org/arm64/c/0b12620fddb8
[5/5] KVM: arm64: uapi: Add kvm_debug_exit_arch.hsr_high
      https://git.kernel.org/arm64/c/18f3976fdb5d

-- 
Catalin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
