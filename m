Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209E0ECAAA1
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 12:44:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A04FB4C5B5;
	Fri,  9 Sep 2022 08:44:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mg6n7gPiIDXW; Fri,  9 Sep 2022 08:44:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69ACC4C639;
	Fri,  9 Sep 2022 08:44:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 230A74C625
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 08:44:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4YEhfcGBRtWq for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 08:44:23 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA35B4C469
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 08:44:22 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D11EA61FD6;
 Fri,  9 Sep 2022 12:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FCDC433D6;
 Fri,  9 Sep 2022 12:44:19 +0000 (UTC)
Date: Fri, 9 Sep 2022 13:44:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Elliot Berman <quic_eberman@quicinc.com>
Subject: Re: [PATCH] KVM: arm64: Report Protected KVM cap only if KVM is
 enabled
Message-ID: <Yxs1H3+iI8Y7+Zbu@arm.com>
References: <20220902040122.346654-1-quic_eberman@quicinc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220902040122.346654-1-quic_eberman@quicinc.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 01, 2022 at 09:01:22PM -0700, Elliot Berman wrote:
> If "kvm-arm.mode=protected" is present on kernel command line, but the
> kernel doesn't actually support KVM because it booted from EL1, the
> ARM64_KVM_PROTECTED_MODE capability is misleadingly reported as present.
> Fix this by adding a check whether we booted from EL2.
> 
> Cc: Will Deacon <will@kernel.org>
> Cc: David Brazdil <dbrazdil@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
>  arch/arm64/kernel/cpufeature.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 8d88433de81d..866667be0651 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1974,7 +1974,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
>  #ifdef CONFIG_KVM
>  static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused)
>  {
> -	return kvm_get_mode() == KVM_MODE_PROTECTED;
> +	return is_hyp_mode_available() && kvm_get_mode() == KVM_MODE_PROTECTED;
>  }
>  #endif /* CONFIG_KVM */

Could we not fix this in early_kvm_mode_cfg()?

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
