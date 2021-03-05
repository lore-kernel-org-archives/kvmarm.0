Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E21EC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 19:13:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7310D64E87
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 19:13:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7310D64E87
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D32B74B5DA;
	Fri,  5 Mar 2021 14:13:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7fcSax2WlQ+H; Fri,  5 Mar 2021 14:13:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24C4F4B660;
	Fri,  5 Mar 2021 14:13:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B33BF4B5E2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 14:13:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SNVDecsdzVTT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 14:13:34 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF21D4B5DA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 14:13:34 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE2F4650A0;
 Fri,  5 Mar 2021 19:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614971613;
 bh=cmU1v4HxoU7I1TscIKOCjbmB6ohA+V07l9MWa8IiQYw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hQ7xvZ8m48Y3m8nLo8R4/145zV++RcmVEQTpO5sNUIxRg2MwSaq0Jr0khLnSMW9nv
 U2nVsTOqrA+myTkN4udZxTTKPQCgSil1cwOEPGK1Lm92QJMSvZP2Tm5fqS/ixLKMM6
 cLBn1Xw4NTDlc+iJYfsOY4qP+ZPd3Niu4vDddQdL0j3qA5hTeOUpkq2XNGf1KewlXv
 InlVKSEKrUFn6KBdQq3JRjRaOzty7YM8GHux/ewmDd8Q55kQIyGUMPlX50L6DVW2FW
 f5FI8ZAnA1jBr/sNKI2Njp+pJtx4nApDezuqwMQhkO6jdStUWZfoOvWr+ACcRF1J7G
 kM56jq46kIHRQ==
Date: Fri, 5 Mar 2021 19:13:27 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 32/32] KVM: arm64: Protect the .hyp sections from the
 host
Message-ID: <20210305191327.GD23633@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-33-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-33-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 02, 2021 at 03:00:02PM +0000, Quentin Perret wrote:
> When KVM runs in nVHE protected mode, use the host stage 2 to unmap the
> hypervisor sections. The long-term goal is to ensure the EL2 code can
> remain robust regardless of the host's state, so this starts by making
> sure the host cannot e.g. write to the .hyp sections directly.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/kvm/arm.c                          | 46 +++++++++++++++++++
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 22 +++++++++
>  5 files changed, 80 insertions(+)

[...]

>  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 2252ad1a8945..ed480facdc88 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -196,6 +196,28 @@ static int host_stage2_idmap(u64 addr)
>  	return ret;
>  }
>  
> +int __pkvm_host_unmap(phys_addr_t start, phys_addr_t end)
> +{
> +	struct kvm_mem_range r1, r2;
> +	int ret;
> +
> +	/*
> +	 * host_stage2_unmap_dev_all() currently relies on MMIO mappings being
> +	 * non-persistent, so don't allow PROT_NONE in MMIO range.
> +	 */
> +	if (!find_mem_range(start, &r1) || !find_mem_range(end, &r2))
> +		return -EINVAL;
> +	if (r1.start != r2.start)
> +		return -EINVAL;


Feels like this should be in a helper to determine whether or not a range is
solely covered by memory.

Either way:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
