Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C214EC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 27 Nov 2021 13:16:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213614B228;
	Sat, 27 Nov 2021 08:16:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XJd1MC2jDYjL; Sat, 27 Nov 2021 08:16:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FBBD4B20C;
	Sat, 27 Nov 2021 08:16:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B41A74B173
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Nov 2021 08:16:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u0HGfQFKiZEK for <kvmarm@lists.cs.columbia.edu>;
 Sat, 27 Nov 2021 08:16:34 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 863E94B130
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Nov 2021 08:16:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638018994;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=v0plHLVJ7YGhDTdr46oZg0IbiyPN69in2dl5FlOrseU=;
 b=BbQqYOnjuVyYoU0OZJz0S8HyetePrh1X0uqvdvRJFPlB0EiMhv3OCDzDV9SW3usi702D43
 OdCWUNJHo+64vpqnYp3DBKEH54wNtP9aNQoU/iing01MaQh605llXkkQAayMlT17VqKPNp
 lM9dvBdYJvvRQXel8U40WXGJAMdtCJQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-lH3kVApoOTiOepi9IeW_Fg-1; Sat, 27 Nov 2021 08:16:33 -0500
X-MC-Unique: lH3kVApoOTiOepi9IeW_Fg-1
Received: by mail-ed1-f72.google.com with SMTP id
 eg20-20020a056402289400b003eb56fcf6easo9936742edb.20
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Nov 2021 05:16:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=v0plHLVJ7YGhDTdr46oZg0IbiyPN69in2dl5FlOrseU=;
 b=LVej7ZmvL45znyAQrlCI91mip3Dnjkbm9pORA/KJcnAB16PBhqu1FblE7IcCaElrlC
 kmTKVWw63+QuwUi0jiVZh+qYKrBBVibVIFwEe2OlXjZcxs2NSotuu41Bm3ZWDulRhMhv
 bYGiTAZkUQ2kSklpa3drouxXinQLWIgErM6gsDFtiAZI2ExAFM8FtRNDdV93GPusnrSa
 qEKhFQLoG9d27pCjSlqzLZJfFGo2dtHS+I6OdzqjKfVHL/bXiDAQIshyEleFWqq0qJ2l
 Bic+AqrYPlmine9FWFWGlDb7IbDAPPteJmo1uqNjFNBwAdDUqFs5jeK1Vpt/9hBTDRbu
 izCA==
X-Gm-Message-State: AOAM531c+x+pK4qkiYJWH6/tkMog1BbKOJEBoeQ5ct97yVIT87iaAGd7
 TOLbKrTkDM3/Vae/aNWV2fpNkIc+31B40iQwbF2rMTpaZCd+a0dB2fNbgTAiCf9xdm0vN+aY+Es
 Cw4c0ELCfspQ3dZk/Y7T6JgZx
X-Received: by 2002:a05:6402:7d8:: with SMTP id
 u24mr56590385edy.215.1638018991872; 
 Sat, 27 Nov 2021 05:16:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6vEbb+Kp1fF0UmX5GI6yeuYFqQIsquieDGtN50C1q4QYp2pxFO361DnTZ1l1WoWXZzKUvSg==
X-Received: by 2002:a05:6402:7d8:: with SMTP id
 u24mr56590351edy.215.1638018991687; 
 Sat, 27 Nov 2021 05:16:31 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id qa7sm4536940ejc.64.2021.11.27.05.16.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 27 Nov 2021 05:16:31 -0800 (PST)
Date: Sat, 27 Nov 2021 14:16:28 +0100
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH v2 01/11] KVM: arm64: Factor out firmware register
 handling from psci.c
Message-ID: <20211127131628.iihianybqbeyjdbg@gator.home>
References: <20211113012234.1443009-1-rananta@google.com>
 <20211113012234.1443009-2-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20211113012234.1443009-2-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Sat, Nov 13, 2021 at 01:22:24AM +0000, Raghavendra Rao Ananta wrote:
> Common hypercall firmware register handing is currently employed
> by psci.c. Since the upcoming patches add more of these registers,
> it's better to move the generic handling to hypercall.c for a
> cleaner presentation.
> 
> While we are at it, collect all the firmware registers under
> fw_reg_ids[] to help implement kvm_arm_get_fw_num_regs() and
> kvm_arm_copy_fw_reg_indices() in a generic way.
> 
> No functional change intended.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/guest.c       |   2 +-
>  arch/arm64/kvm/hypercalls.c  | 170 +++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/psci.c        | 166 ----------------------------------
>  include/kvm/arm_hypercalls.h |   7 ++
>  include/kvm/arm_psci.h       |   7 --
>  5 files changed, 178 insertions(+), 174 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5ce26bedf23c..625f97f7b304 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -18,7 +18,7 @@
>  #include <linux/string.h>
>  #include <linux/vmalloc.h>
>  #include <linux/fs.h>
> -#include <kvm/arm_psci.h>
> +#include <kvm/arm_hypercalls.h>
>  #include <asm/cputype.h>
>  #include <linux/uaccess.h>
>  #include <asm/fpsimd.h>
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 30da78f72b3b..9e136d91b470 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -146,3 +146,173 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
>  	return 1;
>  }
> +
> +static const u64 fw_reg_ids[] = {
> +	KVM_REG_ARM_PSCI_VERSION,
> +	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> +	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> +};
> +
> +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> +{
> +	return ARRAY_SIZE(fw_reg_ids);
> +}
> +
> +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
> +		if (put_user(fw_reg_ids[i], uindices))

This is missing the ++ on uindices, so it just writes the same offset
three times.

> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}

I assume the rest of the patch is just a cut+paste move of code.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
