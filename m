Return-Path: <SRS0=jhc2=NN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC08C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 19:58:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D05261284
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 19:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7D05261284
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA32C4B1F1;
	Sun, 22 Aug 2021 15:58:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gvvcySAdtkkw; Sun, 22 Aug 2021 15:58:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 984924B1F5;
	Sun, 22 Aug 2021 15:58:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 224744B1C7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 15:58:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w+qv1V3FiZEL for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Aug 2021 15:58:26 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9331E4B1F1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 15:58:26 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id r9so33369815lfn.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 12:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=aqYoz1kP1AguveE5o6Fj8i9Fw8RWOGMXWZpf/6/YWE0=;
 b=WM2YsJigvDvG/gtrWkKQWUPEROct1NVXABRrEYnmVdjgycNoyax1vNff+kvZlRJNx8
 bC5SLa/IrTAjw0yAKNRmq/fmFISP3vnOB77sctSEN4us8pBORoEqMoBN3t1BHOj7EdEx
 p8F4ltamZ7dFlaQP1DaHM1EFtrD5/iYPeApao8F3HMyx3Omr50/Zpd6xKw+7NG0sA/PQ
 FeciguxTiY6nZCDINHdj3Z733ZANw47l132Xu1FhkHCoxoFS9qwECZcv8KNkzefpIVnO
 NLXjbJOsDUOznNv610TgyzfmyF3I8k4eCZF2qbGwcfeJ7Vqzvw7W2vOw3juHTrfE2jfN
 Dypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=aqYoz1kP1AguveE5o6Fj8i9Fw8RWOGMXWZpf/6/YWE0=;
 b=IBHf/Bo0xJVLgeGHT92ComwAE038+oeejRvzPsEG5oSWJb8BH9VXnvV0hEUJ7Yb64O
 QKUdpcDmZtXdAtxFa/fI23ng71Krc2Cj92CD282epdm3e1BHveTdd9/9Vt9+MBhcHDM+
 UWo2p+lRjKp5gZNn/lPcJBW2tnJnDDFwzoe0XzN5TPv9IQX1aZt8QmAf3acC7su7k3PP
 99aIRVzuJ9xT9QUAwzeyey0BK0p8VEMk3DwiB87Jwe84+E2HeZ61oRgouG/74EST67+f
 H+j8irs1O9I34JKwGlKJKQg4hUkPu9jUASQTSAqWY5EXVswdxhQ3EOxFlNthm42wgo+h
 d8ZQ==
X-Gm-Message-State: AOAM533ivH0RGXfwlh/qOWrIHtbskiF3hFfr+DXRaooEHBIC0KwhAGtH
 bnBxhJnipPImN9ut3sGtjrr9IFyklfnDl5Dx2BHTgA==
X-Google-Smtp-Source: ABdhPJzuJmZrN0t+YVKxWS5C7MhBEvuLvz26E9gt+OlsVqFHya6P4iiH3RxL6/xzK4tCpXTLamV856hXOBbgzgbuJnA=
X-Received: by 2002:a05:6512:77:: with SMTP id
 i23mr22378276lfo.411.1629662304943; 
 Sun, 22 Aug 2021 12:58:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210822152526.1291918-1-maz@kernel.org>
 <20210822152526.1291918-2-maz@kernel.org>
In-Reply-To: <20210822152526.1291918-2-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Sun, 22 Aug 2021 12:58:13 -0700
Message-ID: <CAOQ_QsjKof16SLbLohYPt5xx_fS2BuWpUY0KCsFBZYs7dP+-tw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] kvmtool: Abstract KVM_VM_TYPE into a weak function
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
> Most architectures pass a fixed value for their VM type. However,
> arm64 uses it as a parameter describing the size of the guest's
> physical address space.
>
> In order to support this, introduce a kvm__get_vm_type() helper
> that only returns KVM_VM_TYPE for now.
>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/kvm/kvm.h | 1 +
>  kvm.c             | 7 ++++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 56e9c8e3..ad732e56 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -114,6 +114,7 @@ int kvm__init(struct kvm *kvm);
>  struct kvm *kvm__new(void);
>  int kvm__recommended_cpus(struct kvm *kvm);
>  int kvm__max_cpus(struct kvm *kvm);
> +int kvm__get_vm_type(struct kvm *kvm);
>  void kvm__init_ram(struct kvm *kvm);
>  int kvm__exit(struct kvm *kvm);
>  bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename);
> diff --git a/kvm.c b/kvm.c
> index e327541d..5bc66c8b 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -428,6 +428,11 @@ int kvm__max_cpus(struct kvm *kvm)
>         return ret;
>  }
>
> +int __attribute__((weak)) kvm__get_vm_type(struct kvm *kvm)
> +{
> +       return KVM_VM_TYPE;
> +}
> +
>  int kvm__init(struct kvm *kvm)
>  {
>         int ret;
> @@ -461,7 +466,7 @@ int kvm__init(struct kvm *kvm)
>                 goto err_sys_fd;
>         }
>
> -       kvm->vm_fd = ioctl(kvm->sys_fd, KVM_CREATE_VM, KVM_VM_TYPE);
> +       kvm->vm_fd = ioctl(kvm->sys_fd, KVM_CREATE_VM, kvm__get_vm_type(kvm));
>         if (kvm->vm_fd < 0) {
>                 pr_err("KVM_CREATE_VM ioctl");
>                 ret = kvm->vm_fd;
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
