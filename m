Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7734C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 11:08:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11E6164FE7
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 11:08:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11E6164FE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D54C4B188;
	Thu, 11 Mar 2021 06:08:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FzhP4QDaqWnd; Thu, 11 Mar 2021 06:08:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18B624A1AF;
	Thu, 11 Mar 2021 06:08:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ADF34B55E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 06:08:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 008KSxE6YGWk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 06:08:16 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E90ED4B556
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 06:08:16 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615460896;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=DwM1zrj6y+SPq/Wn5uH5zHFoKtylvkdUobCwon2GWsw=;
 b=NfoXz1EkRD6j3ZAHEOkePDqs3pX3bjhAqyM8X1X6C70QjgnKsCPqj1kaeqbsXEpfnkY0D4
 spesZ5gheGhUw/r6MwqKij7GQZewrTVv3KqyBT0x4QBa8sSkMfQRXdxl5Y/rtjP6UKr3ss
 c+N7c0dJJgXHO8ih3I6JUoWbTSxlMlQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-PwlpRNx-MOeUMqH7hXhblg-1; Thu, 11 Mar 2021 06:08:12 -0500
X-MC-Unique: PwlpRNx-MOeUMqH7hXhblg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4DE318460E0;
 Thu, 11 Mar 2021 11:08:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.217])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1413F60BF3;
 Thu, 11 Mar 2021 11:08:03 +0000 (UTC)
Date: Thu, 11 Mar 2021 12:08:01 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 1/2] KVM: arm64: Reject VM creation when the default
 IPA size is unsupported
Message-ID: <20210311110801.mcjhenee3e3dizoo@kamzik.brq.redhat.com>
References: <20210311100016.3830038-1-maz@kernel.org>
 <20210311100016.3830038-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210311100016.3830038-2-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: kernel-team@android.com, kvm@vger.kernel.org, stable@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

On Thu, Mar 11, 2021 at 10:00:15AM +0000, Marc Zyngier wrote:
> KVM/arm64 has forever used a 40bit default IPA space, partially
> due to its 32bit heritage (where the only choice is 40bit).
> 
> However, there are implementations in the wild that have a *cough*
> much smaller *cough* IPA space, which leads to a misprogramming of
> VTCR_EL2, and a guest that is stuck on its first memory access
> if userspace dares to ask for the default IPA setting (which most
> VMMs do).
> 
> Instead, blundly reject the creation of such VM, as we can't
> satisfy the requirements from userspace (with a one-off warning).
> Also clarify the boot warning, and document that the VM creation
> will fail when an unsupported IPA size is probided.

provided

> 
> Although this is an ABI change, it doesn't really change much
> for userspace:
> 
> - the guest couldn't run before this change, but no error was
>   returned. At least userspace knows what is happening.
> 
> - a memory slot that was accepted because it did fit the default
>   IPA space now doesn't even get a chance to be registered.
> 
> The other thing that is left doing is to convince userspace to
> actually use the IPA space setting instead of relying on the
> antiquated default.
> 
> Fixes: 233a7cb23531 ("kvm: arm64: Allow tuning the physical address size for VM")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  Documentation/virt/kvm/api.rst |  3 +++
>  arch/arm64/kvm/reset.c         | 12 ++++++++----
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1a2b5210cdbf..38e327d4b479 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -182,6 +182,9 @@ is dependent on the CPU capability and the kernel configuration. The limit can
>  be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the KVM_CHECK_EXTENSION
>  ioctl() at run-time.
>  
> +Creation of the VM will fail if the requested IPA size (whether it is
> +implicit or explicit) is unsupported on the host.
> +
>  Please note that configuring the IPA size does not affect the capability
>  exposed by the guest CPUs in ID_AA64MMFR0_EL1[PARange]. It only affects
>  size of the address translated by the stage2 level (guest physical to
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 47f3f035f3ea..9d3d09a89894 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -324,10 +324,9 @@ int kvm_set_ipa_limit(void)
>  	}
>  
>  	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
> -	WARN(kvm_ipa_limit < KVM_PHYS_SHIFT,
> -	     "KVM IPA Size Limit (%d bits) is smaller than default size\n",
> -	     kvm_ipa_limit);
> -	kvm_info("IPA Size Limit: %d bits\n", kvm_ipa_limit);
> +	kvm_info("IPA Size Limit: %d bits%s\n", kvm_ipa_limit,
> +		 ((kvm_ipa_limit < KVM_PHYS_SHIFT) ?
> +		  " (Reduced IPA size, limited VM/VMM compatibility)" : ""));

nit: there's a couple pair of unnecessary ()

>  
>  	return 0;
>  }
> @@ -356,6 +355,11 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
>  			return -EINVAL;
>  	} else {
>  		phys_shift = KVM_PHYS_SHIFT;
> +		if (phys_shift > kvm_ipa_limit) {
> +			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
> +				     current->comm);
> +			return -EINVAL;
> +		}
>  	}
>  
>  	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> -- 
> 2.29.2
> 

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
