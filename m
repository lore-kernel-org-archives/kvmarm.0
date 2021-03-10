Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCB7C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 11:00:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADFF164FE2
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 11:00:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADFF164FE2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 246374B2BC;
	Wed, 10 Mar 2021 06:00:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ouj4F1q8TytV; Wed, 10 Mar 2021 06:00:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEB424B386;
	Wed, 10 Mar 2021 06:00:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F243C4B2BC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 06:00:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ve+A6pmnJg0C for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 06:00:05 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 313124B36D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 06:00:05 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615374005;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oDhDNM4u1PR30JCjMA3wEf47lK6+aG30vmKc8RSnFzg=;
 b=bw+AbVt00qs9Cgr7BrPPMS4dbbY7FDV1fPplvLrUAnnOog5wvJ/Yq5Z5nLl7MThRprcsSq
 opeI8C1G8KFCu+Dv00mrHjmeSiFtGt7weEx6btO/WDOUjMw7XVVxErQr1QHXfH66dnzorE
 5PMI5M2KPUvWfp70Tb4A3qFoCN2f2No=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-d9TORm7LMCGpaGtkFNkyJg-1; Wed, 10 Mar 2021 06:00:01 -0500
X-MC-Unique: d9TORm7LMCGpaGtkFNkyJg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C07D1074644;
 Wed, 10 Mar 2021 10:59:59 +0000 (UTC)
Received: from [10.36.112.254] (ovpn-112-254.ams2.redhat.com [10.36.112.254])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 968585C261;
 Wed, 10 Mar 2021 10:59:56 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] KVM: arm64: Reject VM creation when the default
 IPA size is unsupported
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20210310104208.3819061-1-maz@kernel.org>
 <20210310104208.3819061-2-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <c8de95cb-57dc-14df-f133-6c12b921de2b@redhat.com>
Date: Wed, 10 Mar 2021 11:59:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310104208.3819061-2-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

On 3/10/21 11:42 AM, Marc Zyngier wrote:
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
> Signed-off-by: Marc Zyngier <maz@kernel.org>
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
> index 47f3f035f3ea..f1a38405934e 100644
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
> +				     current->comm, kvm_ipa_limit);
don't you have a trouble with the args here?

Otherwise looks sensible to me.

Thanks

Eric
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
