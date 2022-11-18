Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D678FC43217
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 14:56:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B3C4B981;
	Fri, 18 Nov 2022 09:56:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id USyoM4dPgEsT; Fri, 18 Nov 2022 09:56:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 315214B977;
	Fri, 18 Nov 2022 09:56:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DABF4B96E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 09:56:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dr59NSHm82n8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 09:56:47 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 562B94B880
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 09:56:47 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 0785AB8243B;
 Fri, 18 Nov 2022 14:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A0CC433C1;
 Fri, 18 Nov 2022 14:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668783404;
 bh=kQqNwIRTX/hMdAUkbPpnbCbz6J1Qz8mIuBGg79EWriQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=YAcGcNO717vxcqR6gw7hPCPkskQj2wFxDzeuW9mROwlkdTfHvsj313IATnooRiuH7
 tggG//xkOzUdbhHJi9RH5nUHr7JyjuEL8To04GZkGxQ+NqDdJYuK0xU8yvqQm2SnY5
 Gv9xoQAQQwMXscRow5tS3mEG0waNLDXKKDfLUaCfkyCYxD/MDglLWUCFLE8+3Dp8iv
 0mSr5zAFkl6F8Wv3JRf0R4kjtOsD7JHBNfgBGcKygeKngjWkZ4TPuc+YarzIdVBPqn
 55sMg9/gLjLP2+8k17o7zmujzTy38yupQVAQHhdgtLRalXIq0dYP63UmSdSl8lUPu9
 OZ4b8PrPzo3Mg==
Date: Fri, 18 Nov 2022 14:56:38 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH 2/3] KVM: arm64: Allow userspace to trap SMCCC
 sub-ranges
Message-ID: <20221118145637.GC4624@willie-the-truck>
References: <20221110015327.3389351-1-oliver.upton@linux.dev>
 <20221110015327.3389351-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221110015327.3389351-3-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hey Oliver,

On Thu, Nov 10, 2022 at 01:53:26AM +0000, Oliver Upton wrote:
> As the SMCCC (and related specifications) march towards an
> 'everything and the kitchen sink' interface for interacting with a
> system, it is less likely that KVM will implement every supported
> feature.
> 
> Add a capability that allows userspace to trap hypercall ranges,
> allowing the VMM to mix-and-match between calls handled in userspace vs.
> KVM.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_host.h |  5 ++++
>  arch/arm64/include/uapi/asm/kvm.h | 15 ++++++++++
>  arch/arm64/kvm/arm.c              | 10 +++++++
>  arch/arm64/kvm/hypercalls.c       | 48 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |  1 +
>  5 files changed, 79 insertions(+)

[...]

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 6f0b56e7f8c7..6e8a222fc295 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -100,6 +100,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = 0;
>  		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
>  		break;
> +	case KVM_CAP_ARM_USER_HYPERCALLS:
> +		if (cap->args[0] & ~KVM_ARM_USER_HYPERCALL_FLAGS)
> +			return -EINVAL;

Why not use KVM_CAP_EXIT_HYPERCALL for this? At some point during pKVM
development, we used that to notify the VMM about memory being shared
back from the guest but we eventually dropped it as the notification to
userspace ended up not being needed:

https://android-kvm.googlesource.com/linux/+/dbd2861832dfc4c8a3103214b3c212ee7ace1c44%5E%21/
https://android-kvm.googlesource.com/linux/+/2a3afc6da99c0e0cb62be1687153ee572903aa80%5E%21/

I'm not saying that what we did was necessarily better, but it seems a bit
simpler and I figured it might be useful to point you to it.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
