Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417ADC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  6 May 2022 10:16:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEA2E4B214;
	Fri,  6 May 2022 06:16:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hnoeCsYsojTL; Fri,  6 May 2022 06:16:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6650D4B1F2;
	Fri,  6 May 2022 06:16:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10E2E4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 06:16:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rGL+lrx9Szgi for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 06:16:21 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA4724B1C3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 06:16:20 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 4328462111;
 Fri,  6 May 2022 10:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4A7C385AA;
 Fri,  6 May 2022 10:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651832179;
 bh=eNp+UUNZui7u6coUNS7PNxrxe2tkL04eKOUXm9fKysc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=aG2fTzMLcidijec70O3RMF7AS8kQV2M3M/Ncl+vS0Of2b+6zzOrHH/lHZshuQPpaw
 yHiHvpJaR15aodDq0leNa4Eb37VQ8zcrg1Em3n5ZeZilprPRTX8x2Uq0z0z2wlmITb
 4gX1lTugGTY0oOdgfmS6JwPfe0fN5cN9pjMZF0YX6czmtLC1DM3MexqYlJmXdxfqRj
 xD5hGbrK2o1IFDk+0Qwsz56xLWLGQ8B+i4YBIBGwv80RcXpDyz1LAEaOPjQONWaz8t
 +CF3qbKaOx9StUbG7amB8MhLytSzvo98I6DdUHp+Ho8LfIuoWBCGxaRmNoSUcNfc34
 pdpZZqMw/KRiA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nmv0T-009Qtg-5m; Fri, 06 May 2022 11:16:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] KVM: arm64: nvhe: eliminate kernel-doc warnings
Date: Fri,  6 May 2022 11:16:14 +0100
Message-Id: <165183215982.192247.17735807567998554164.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220430050123.2844-1-rdunlap@infradead.org>
References: <20220430050123.2844-1-rdunlap@infradead.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, rdunlap@infradead.org,
 kvmarm@lists.cs.columbia.edu, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
 james.morse@arm.com, lkp@intel.com, linux-arm-kernel@lists.infradead.org,
 dbrazdil@google.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel test robot <lkp@intel.com>, kvmarm@lists.cs.columbia.edu,
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

On Fri, 29 Apr 2022 22:01:23 -0700, Randy Dunlap wrote:
> Don't use begin-kernel-doc notation (/**) for comments that are not in
> kernel-doc format.
> 
> This prevents these kernel-doc warnings:
> 
> arch/arm64/kvm/hyp/nvhe/switch.c:126: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Disable host events, enable guest events
> arch/arm64/kvm/hyp/nvhe/switch.c:146: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Disable guest events, enable host events
> arch/arm64/kvm/hyp/nvhe/switch.c:164: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Handler for protected VM restricted exceptions.
> arch/arm64/kvm/hyp/nvhe/switch.c:176: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
> arch/arm64/kvm/hyp/nvhe/switch.c:196: warning: Function parameter or member 'vcpu' not described in 'kvm_handle_pvm_fpsimd'
> arch/arm64/kvm/hyp/nvhe/switch.c:196: warning: Function parameter or member 'exit_code' not described in 'kvm_handle_pvm_fpsimd'
> arch/arm64/kvm/hyp/nvhe/switch.c:196: warning: expecting prototype for Handler for protected floating(). Prototype was for kvm_handle_pvm_fpsimd() instead

Applied to next, thanks!

[1/1] KVM: arm64: nvhe: eliminate kernel-doc warnings
      commit: bd61395ae8393f28f4b084702acd6f5f02b1f7c0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
