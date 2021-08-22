Return-Path: <SRS0=jhc2=NN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0F3C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 20:03:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D8D6461220
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 20:03:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D8D6461220
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 679894B234;
	Sun, 22 Aug 2021 16:03:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DqpmRfpjajvs; Sun, 22 Aug 2021 16:03:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59F124B228;
	Sun, 22 Aug 2021 16:03:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBBEB4B217
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 16:03:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id udgHCGkORGPa for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Aug 2021 16:03:40 -0400 (EDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
 [209.85.208.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 982E34B20F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 16:03:40 -0400 (EDT)
Received: by mail-lj1-f171.google.com with SMTP id c12so27520826ljr.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 13:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=17IV80B7z8HCWsbIlNH7bRWHKU5PA3+vYIZxJpSPFvY=;
 b=XSauUzSovBMDwfx9sMUXCIeP329mMIvTrWRI0Ji2dZtdkZZLuDNmL0ZE2vti0D4ckK
 GqCtNukz/A6WggKWRbnRfE52OuwfZfz304OHesJp1qTi2KjjhiiRVxBoaZACn4IYouaQ
 fS45d1HdisXILrefVMV3XW8+3d08FJTFDJApUDGNuW5ZJql+Oa48vHZFaRr/zxeIZhM5
 q5v5dU0oqEoGYL57CTfQbTdnIRSqh1sRqHWVp5Q8ARD/7lDzQQBy6M1IWO+yPvxiCSuC
 PNK6YT/wKqdnrN8Zo5fOfihp0npN2QuDnNMtOZo30lHdezfUaCsq6872g7+915UuBcNw
 b8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=17IV80B7z8HCWsbIlNH7bRWHKU5PA3+vYIZxJpSPFvY=;
 b=DqxHHG7ZiZO3HCduoQHzev0OiFtrjuVQLEijC9qJXXR9mf0f9OpWYH87IAbYralRsV
 ZLArnvws1m9FWsIepuG2zVX3ujT3gvMd0enXHYRSQks6873fVty21dXch2CeTi06fmCS
 4WeAQSjAx/yx+GK55IqYske95R8qeG2thI4ObQlpOlXStvtYtnw552Tayf3CSm7qWE6I
 1JiY3ob/UVX44DpdRNNyaqJkwuB1cd/ViZ5tgfPktKxp0x5ekFqc9tUwqFmcZGkUaQ1V
 5BMLKcXT29ej0fPjGabE+b8gD8CXqQ8jCMYOUA9yVN5gFCZ3OLOftKv2Xs4jM0AMqf7D
 iEPw==
X-Gm-Message-State: AOAM532TASKJeRNOxzhZX6XC3tXGMfMOE0KXh8Q4zfiSgjnKZrKggee1
 QaJ6Ag71WeyOYddY5NgX8LmWnH7CSz45EatA/w7b2g==
X-Google-Smtp-Source: ABdhPJz1IlluDy0BzegbYGbTMt9jseXkKmiul++uvmiUY/aESxvMjkEoYWigV/QZpWkmvfZfRN5+b5YyRDdI7M0saBQ=
X-Received: by 2002:a2e:a5c1:: with SMTP id n1mr24325561ljp.65.1629662619158; 
 Sun, 22 Aug 2021 13:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210822152526.1291918-1-maz@kernel.org>
 <20210822152526.1291918-3-maz@kernel.org>
In-Reply-To: <20210822152526.1291918-3-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Sun, 22 Aug 2021 13:03:28 -0700
Message-ID: <CAOQ_QsicyCZj6Lsy9M66zp6NpMdSjVeoAPj-5K4NxWMHguO-7w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] kvmtool: arm64: Use the maximum supported IPA size
 when creating the VM
To: Marc Zyngier <maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>
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

On Sun, Aug 22, 2021 at 8:25 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Instead of just asking the the default VM size, request the maximum
> IPA size to the kernel, and use this at VM creation time.
>
> The IPA space is parametrized accordingly.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arm/aarch64/include/kvm/kvm-arch.h | 19 ++++++++++++++++---
>  arm/aarch64/kvm.c                  | 15 +++++++++++++++
>  2 files changed, 31 insertions(+), 3 deletions(-)
>
> diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
> index 55ef8ed1..159567b9 100644
> --- a/arm/aarch64/include/kvm/kvm-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-arch.h
> @@ -3,10 +3,23 @@
>
>  struct kvm;
>  unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
> +int kvm__arch_get_ipa_limit(struct kvm *kvm);
>
> -#define ARM_MAX_MEMORY(kvm)    ((kvm)->cfg.arch.aarch32_guest  ?       \
> -                               ARM_LOMAP_MAX_MEMORY            :       \
> -                               ARM_HIMAP_MAX_MEMORY)
> +#define ARM_MAX_MEMORY(kvm)    ({                                      \
> +       u64 max_ram;                                                    \
> +                                                                       \
> +       if ((kvm)->cfg.arch.aarch32_guest) {                            \
> +               max_ram = ARM_LOMAP_MAX_MEMORY;                         \
> +       } else {                                                        \
> +               int ipabits = kvm__arch_get_ipa_limit(kvm);             \
> +               if (ipabits <= 0)                                       \
> +                       max_ram = ARM_HIMAP_MAX_MEMORY;                 \
> +               else                                                    \
> +                       max_ram = (1ULL << ipabits) - ARM_MEMORY_AREA;  \
> +       }                                                               \
> +                                                                       \
> +       max_ram;                                                        \
> +})
>
>  #include "arm-common/kvm-arch.h"
>
> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
> index 49e1dd31..d03a27f2 100644
> --- a/arm/aarch64/kvm.c
> +++ b/arm/aarch64/kvm.c
> @@ -46,3 +46,18 @@ fail:
>         return 0x80000;
>  }
>
> +int kvm__arch_get_ipa_limit(struct kvm *kvm)
> +{
> +       int ret;
> +
> +       ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE);
> +       if (ret <= 0)
> +               ret = 0;
> +
> +       return ret;
> +}
> +
> +int kvm__get_vm_type(struct kvm *kvm)
> +{
> +       return KVM_VM_TYPE_ARM_IPA_SIZE(kvm__arch_get_ipa_limit(kvm));
> +}
> --
> 2.30.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
