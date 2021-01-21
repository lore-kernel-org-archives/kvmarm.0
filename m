Return-Path: <SRS0=IlRN=GY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7A6C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jan 2021 02:48:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD1362388E
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jan 2021 02:48:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD1362388E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F724B16F;
	Wed, 20 Jan 2021 21:48:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rv0P5Voo2PIx; Wed, 20 Jan 2021 21:48:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11A6E4B15E;
	Wed, 20 Jan 2021 21:48:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F92C4B152
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 21:47:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C2fnlB5si9kP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jan 2021 21:47:58 -0500 (EST)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com
 [209.85.166.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 570C44B13F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 21:47:58 -0500 (EST)
Received: by mail-io1-f44.google.com with SMTP id d81so1226806iof.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 18:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ZuZwVwOsZXIOujfnIrxLKTPXUJWWrKVtgOfGA4Pmxcc=;
 b=rAvotTwBl5KLgiR4US39m4jfoz7lvXHt1NdGI+44pOxnkBet0V8jxd9ArSwnceucNr
 Qks1HI2P4AskGsXEhdYai6qGHIJcaTkSCvg9GLRdu1FwQZDQhAyrvbr7uazHMniZVqtt
 sz2EksMDBRt6r1KUJJWCXC4EHKIIjuidKXJhTvziyzWrSkzUWZSTOUthD0gwfyjHIrrR
 wv4o8rF75/1FpTLYmm20vHPDFQJWnimgp0u6yqaZP9OO/M37nzG35egW4kccik8O+oUA
 J4IxHjVw/h7u5sCy0CVAbSo6Q04nj6oud2Y3IoddcOzDd9uq9uI6FyCPJc70ze52W2Yl
 LErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ZuZwVwOsZXIOujfnIrxLKTPXUJWWrKVtgOfGA4Pmxcc=;
 b=l6PkWuE7/yRlUyXUhW76QDHSn8qFmaJdMa5IwyQyb7hYlbfWnwexShGDNhOAbGpZc2
 p1U/tF/Xg7eZKmL4y0YjYw+vG2BH8mE+fGp+e3WSxduUUe2GjRVr7uXqKtQz1cTZ99Ci
 WMzk82mGtKPGq1ahQY8xy/vz/5zh3pvTC7u3dcm3QDLx+NpwOiuAjnfBCkm3Bo3o6n9u
 ZXJiavR60jt+h2mgTlDC/jjwvLI3oW76jucUxIX2ocJD0QZSXcySFbCCKhE7JPaC/WnB
 CJtGJhkAPWVNW0ex7R+Z/bhqRAWs6rL7lqfffHsyqr/shNPolnYIdKUOnoeSH78F3bjF
 Gf9Q==
X-Gm-Message-State: AOAM533Lbkz8t1iYr0hSvpMdE435z2L8HjKPFDI/mQCizElWlMzpj0Ra
 out4Pe+Isp3mvsV6rGaPZPdxFveVK6y/GeB+OBw8
X-Google-Smtp-Source: ABdhPJw6Z9tFUIfjoZ5sNIubIzD9q8AVypNcofze1omMchFdn7eRSu9jaXQcWVZL91Lj16mcXw41odGzzDTSy7u44A4=
X-Received: by 2002:a5d:9a8e:: with SMTP id c14mr9273183iom.178.1611197277522; 
 Wed, 20 Jan 2021 18:47:57 -0800 (PST)
MIME-Version: 1.0
References: <20201210160002.1407373-1-maz@kernel.org>
 <20201210160002.1407373-64-maz@kernel.org>
In-Reply-To: <20201210160002.1407373-64-maz@kernel.org>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Thu, 21 Jan 2021 10:47:45 +0800
Message-ID: <CAJc+Z1G6QEEiUh=KLdS6Xut7q63zZ6zQxfpGCkCtY5tTSXPeZw@mail.gmail.com>
Subject: Re: [PATCH v3 63/66] KVM: arm64: nv: Allocate VNCR page when required
To: Marc Zyngier <maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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

On Fri, 11 Dec 2020 at 00:04, Marc Zyngier <maz@kernel.org> wrote:
>
> If running a NV guest on an ARMv8.4-NV capable system, let's
> allocate an additional page that will be used by the hypervisor
> to fulfill system register accesses.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 3 ++-
>  arch/arm64/kvm/nested.c           | 8 ++++++++
>  arch/arm64/kvm/reset.c            | 1 +
>  3 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 78630bd5124d..dada0678c28e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -523,7 +523,8 @@ struct kvm_vcpu_arch {
>   */
>  static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
>  {
> -       if (unlikely(r >= __VNCR_START__ && ctxt->vncr_array))
> +       if (unlikely(cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT) &&
> +                    r >= __VNCR_START__ && ctxt->vncr_array))
>                 return &ctxt->vncr_array[r - __VNCR_START__];
>
>         return (u64 *)&ctxt->sys_regs[r];
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index eef8f9873814..88147ec99755 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -47,6 +47,12 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>         if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
>                 return -EINVAL;
>
> +       if (cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT)) {
> +               vcpu->arch.ctxt.vncr_array = (u64 *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> +               if (!vcpu->arch.ctxt.vncr_array)
> +                       return -ENOMEM;
> +       }
> +

If KVM_ARM_VCPU_INIT was called multiple times, the above codes would
try to allocate a new page
without free-ing the previous one. Besides that, the following
kvm_free_stage2_pgd() call would fail in the
second call with the error message "kvm_arch already initialized?".
I think a possible fix is to add a new flag to indicate whether the NV
related meta data have been initialized,
and only initialize them for the first call.

>         mutex_lock(&kvm->lock);
>
>         /*
> @@ -64,6 +70,8 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>                     kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
>                         kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
>                         kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
> +                       free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
> +                       vcpu->arch.ctxt.vncr_array = NULL;
>                 } else {
>                         kvm->arch.nested_mmus_size = num_mmus;
>                         ret = 0;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 2d2c780e6c69..d281eb39036f 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -150,6 +150,7 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>  void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
>         kfree(vcpu->arch.sve_state);
> +       free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>  }
>
>  static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> --
> 2.29.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
