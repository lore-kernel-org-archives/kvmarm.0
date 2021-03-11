Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787AAC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 14:05:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB1A664FAD
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 14:05:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB1A664FAD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 117AE4B5F1;
	Thu, 11 Mar 2021 09:05:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NH7bhRaj6u4h; Thu, 11 Mar 2021 09:05:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D1E4B684;
	Thu, 11 Mar 2021 09:05:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 420814B61B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 09:05:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V0lb4xJrqd8G for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 09:05:20 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DFAB4B5F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 09:05:20 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615471520;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=90Q2n6m6EwL+XSKkC/k2rK0sBsGWuNAH+8zbCxifFnw=;
 b=jIcF286M3eBR/PzaZEmXZX1VaYS+P84c05i4qgtKTlpx08ZFKchOWnbMgPcs5Tv0pMPJLi
 idx0rvtgaRVkJGQngdi7dtynJwiKvD4w9KSi6k+N0qXRr5n5qkf6uKvPiYYhDG1p8MXcii
 9qrryNKjWxLon7OtmADPOqjwWCeXnhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-wnMcU4zAPBad_tREVJY_tA-1; Thu, 11 Mar 2021 09:05:16 -0500
X-MC-Unique: wnMcU4zAPBad_tREVJY_tA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16DA0800D55;
 Thu, 11 Mar 2021 14:05:14 +0000 (UTC)
Received: from [10.36.112.254] (ovpn-112-254.ams2.redhat.com [10.36.112.254])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B3B12C15A;
 Thu, 11 Mar 2021 14:05:11 +0000 (UTC)
Subject: Re: [PATCH v3 1/2] KVM: arm64: Reject VM creation when the default
 IPA size is unsupported
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20210311100016.3830038-1-maz@kernel.org>
 <20210311100016.3830038-2-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <fab68a4a-f96e-9eee-9066-b3f95ff26c35@redhat.com>
Date: Thu, 11 Mar 2021 15:05:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210311100016.3830038-2-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 3/11/21 11:00 AM, Marc Zyngier wrote:
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
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
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
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
