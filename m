Return-Path: <SRS0=IXmk=NP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9819AC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 24 Aug 2021 00:47:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 262E761265
	for <kvmarm@archiver.kernel.org>; Tue, 24 Aug 2021 00:47:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 262E761265
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD38D4B1CB;
	Mon, 23 Aug 2021 20:47:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DxETbv7x7EpY; Mon, 23 Aug 2021 20:47:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4714B1DF;
	Mon, 23 Aug 2021 20:47:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51AA84B1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 20:47:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5hK6OkkkYn36 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 20:47:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A2C14B1CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 20:47:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69697101E;
 Mon, 23 Aug 2021 17:47:43 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AAFEB3F66F;
 Mon, 23 Aug 2021 17:47:42 -0700 (PDT)
Date: Tue, 24 Aug 2021 01:47:34 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 3/3] kvmtool: arm64: Configure VM with the minimal
 required IPA space
Message-ID: <20210824014734.610f2cb2@slackpad.fritz.box>
In-Reply-To: <20210822152526.1291918-4-maz@kernel.org>
References: <20210822152526.1291918-1-maz@kernel.org>
 <20210822152526.1291918-4-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
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

On Sun, 22 Aug 2021 16:25:26 +0100
Marc Zyngier <maz@kernel.org> wrote:

Hi Marc,

> There is some value in keeping the IPA space small, as it reduces
> the size of the stage-2 page tables.
> 
> Let's compute the required space at VM creation time, and inform
> the kernel of our requirements.

You mentioned some kernel bug in the first version of this patch, I
guess the fix for this is 262b003d059c?
It seems to me that this is somewhat of a regression on older host
kernels, when trying to run a guest with "-m 2048", for instance?
Should we teach kvmtool about this bug, and do a check for the bug
condition, when kvm__register_ram() returns with -EFAULT? And give users
a hint to try with one MB more or less guest RAM? Or maybe try
this automatically?

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arm/aarch64/kvm.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
> index d03a27f2..4e66a22e 100644
> --- a/arm/aarch64/kvm.c
> +++ b/arm/aarch64/kvm.c
> @@ -3,6 +3,7 @@
>  #include <asm/image.h>
>  
>  #include <linux/byteorder.h>
> +#include <kvm/util.h>
>  
>  /*
>   * Return the TEXT_OFFSET value that the guest kernel expects. Note
> @@ -59,5 +60,22 @@ int kvm__arch_get_ipa_limit(struct kvm *kvm)
>  
>  int kvm__get_vm_type(struct kvm *kvm)
>  {
> -	return KVM_VM_TYPE_ARM_IPA_SIZE(kvm__arch_get_ipa_limit(kvm));
> +	unsigned int ipa_bits, max_ipa_bits;
> +	unsigned long max_ipa;
> +
> +	/* If we're running on an old kernel, use 0 as the VM type */
> +	max_ipa_bits = kvm__arch_get_ipa_limit(kvm);
> +	if (!max_ipa_bits)
> +		return 0;

Should this return KVM_VM_TYPE, as it does at the moment? Or is this
more confusing than helpful?

Just a nit anyway, the patch looks correct otherwise:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> +
> +	/* Otherwise, compute the minimal required IPA size */
> +	max_ipa = ARM_MEMORY_AREA + kvm->cfg.ram_size - 1;
> +	ipa_bits = max(32, fls_long(max_ipa));
> +	pr_debug("max_ipa %lx ipa_bits %d max_ipa_bits %d",
> +		 max_ipa, ipa_bits, max_ipa_bits);
> +
> +	if (ipa_bits > max_ipa_bits)
> +		die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);
> +
> +	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
>  }

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
