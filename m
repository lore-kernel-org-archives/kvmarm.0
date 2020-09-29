Return-Path: <SRS0=H5U9=DG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB75DC4727C
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 17:31:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ECDCC2075F
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 17:31:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BqjJ64HL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECDCC2075F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 287C54B209;
	Tue, 29 Sep 2020 13:31:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r7M8CoNT09eQ; Tue, 29 Sep 2020 13:31:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2152A4B1D4;
	Tue, 29 Sep 2020 13:31:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2898F4B1B1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 13:31:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fq4LLKpYnyrC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2020 13:31:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 271BC4B1AE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 13:31:01 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1AB3B2076B;
 Tue, 29 Sep 2020 17:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601400659;
 bh=ZXt7Xlne8O4MeeCwfkNnfkAu3Jkzhnlfgn/f/Lyi+XQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=BqjJ64HL0rL6kTbXLKtkhMwe+607jWI3ODEOSusQB4LnnZOZoy1o0wUnALLXNfigf
 XdKaidx2BNKgnijeVFxsXwptbciO2gzQKNkhSPtD13DrtbfxLd3QEQNSMXI6bH+lOR
 5o/Y7OEfIlhv/C8yQRQobAcD3UkCvAmF/QeJGU2w=
Date: Tue, 29 Sep 2020 18:30:53 +0100
From: Will Deacon <will@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v4 04/10] kvm: arm64: Remove __hyp_this_cpu_read
Message-ID: <20200929173053.GB14317@willie-the-truck>
References: <20200922204910.7265-1-dbrazdil@google.com>
 <20200922204910.7265-5-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200922204910.7265-5-dbrazdil@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 22, 2020 at 09:49:04PM +0100, David Brazdil wrote:
> this_cpu_ptr is meant for use in kernel proper because it selects between
> TPIDR_EL1/2 based on nVHE/VHE. __hyp_this_cpu_ptr was used in hyp to always
> select TPIDR_EL2. Unify all users behind this_cpu_ptr and friends by
> selecting _EL2 register under __KVM_NVHE_HYPERVISOR__. VHE continues
> selecting the register using alternatives.
> 
> Under CONFIG_DEBUG_PREEMPT, the kernel helpers perform a preemption check
> which is omitted by the hyp helpers. Preserve the behavior for nVHE by
> overriding the corresponding macros under __KVM_NVHE_HYPERVISOR__. Extend
> the checks into VHE hyp code.
> 
> Acked-by: Andrew Scull <ascull@google.com>
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h          | 20 ----------------
>  arch/arm64/include/asm/percpu.h           | 28 +++++++++++++++++++++--
>  arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  4 ++--
>  arch/arm64/kvm/hyp/include/hyp/switch.h   |  8 +++----
>  arch/arm64/kvm/hyp/nvhe/switch.c          |  2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c           |  2 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |  4 ++--
>  7 files changed, 36 insertions(+), 32 deletions(-)

Looks good, thanks for the respin!

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
