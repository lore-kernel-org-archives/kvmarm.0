Return-Path: <SRS0=jhc2=NN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6713C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 20:05:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C93A61220
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 20:05:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0C93A61220
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 897164B21C;
	Sun, 22 Aug 2021 16:05:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vv9W6fKjLsKp; Sun, 22 Aug 2021 16:05:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 973124B228;
	Sun, 22 Aug 2021 16:05:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F26DD4B21F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 16:05:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jyK4Dv7wx28s for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Aug 2021 16:05:29 -0400 (EDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com
 [209.85.167.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D50CB4B21C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 16:05:28 -0400 (EDT)
Received: by mail-lf1-f42.google.com with SMTP id v19so8097788lfo.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 13:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=0PEDvrbZfSicA0oIINmFafS33UuNdvbh5Yog3qCkG+4=;
 b=DidFNGmiUtjXTr1zhVXh5kDQbyb4cPPko6JsXbwUDrSTPugylFLzMyGFxza1sKm/6x
 W+wIW2kglAX+SzN0qu70kfKNHw84M60u9N9YiLoDVj7JjQBIktEi7l3A7gT4CjCOLZTX
 emni0cLuR0U8jDcpZzV4C/oa5pp86Tnknq/wkoJanv52Xswyf76AnEemcYS0ODyCC6Dz
 8R6xcMC3q2C0uMO57QDgVMm+EUT1YSwTPEmZjLdVou7dEVKMKI5TCeD7RwgS1vwqDrI5
 kuvn80tpghRu4oaK/dI1VHz4EDKnIW4cYp9DUfkbV9mMl6KbXP6GBkS3BVEEMoGdSDrq
 nSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0PEDvrbZfSicA0oIINmFafS33UuNdvbh5Yog3qCkG+4=;
 b=ANI0DumPXyhuu4B9c+APbnQQ+hwGfNrNAbmZCmJEMeHImNiuCLTe+erVIRCV6UOdQd
 QzA1692k3YCQqvZN5AOEsmp6ukdQWYvj2qGOjMCujTpdxliitRp2cvDlFHJqpC5a0loq
 GZRWSRNeBA8E90ugVRlXONrQnfUI4JgDsNFWZ4b3Dl9Z2rUuzGLd1KIZ8uLFYcpzuEQp
 y53efjCkzA4bm+B7rs2GbfsDodx1faSWitqEyJirWohvNST07BcVOmK2mBqUy+6Khf4c
 ysfdJrCkBqSGXZnj5AYp71UGLj6B4yI/JpTckbVKi0up9VfakHcDBnj5pNfcNz3FuAnj
 y2tQ==
X-Gm-Message-State: AOAM533YTbnkZ2kopytZOcX9DfdK3m6cLprnsmXZ0IUkWE3MzX66WBZA
 OFf9KBsetFDI3oNHqXddwwLR7Y2jm0h1EA+fMpOfmg==
X-Google-Smtp-Source: ABdhPJxFbnFAR0ELYP42ey3YRetfqvaG3XBGxBvuNqLbVWZhpYHrdP7/lcWuKLIhhk6P+saZLNgZNeGRTrPPcfdiZck=
X-Received: by 2002:a05:6512:3ba4:: with SMTP id
 g36mr22893893lfv.80.1629662727215; 
 Sun, 22 Aug 2021 13:05:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210822152526.1291918-1-maz@kernel.org>
 <20210822152526.1291918-4-maz@kernel.org>
In-Reply-To: <20210822152526.1291918-4-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Sun, 22 Aug 2021 13:05:16 -0700
Message-ID: <CAOQ_QsgpgTfhDAg9Td4rgQmEy6m1j5RDDZZG9Q6UDNR3S58YLw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] kvmtool: arm64: Configure VM with the minimal
 required IPA space
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

Marc,

On Sun, Aug 22, 2021 at 8:25 AM Marc Zyngier <maz@kernel.org> wrote:
>
> There is some value in keeping the IPA space small, as it reduces
> the size of the stage-2 page tables.
>
> Let's compute the required space at VM creation time, and inform
> the kernel of our requirements.
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
> -       return KVM_VM_TYPE_ARM_IPA_SIZE(kvm__arch_get_ipa_limit(kvm));
> +       unsigned int ipa_bits, max_ipa_bits;
> +       unsigned long max_ipa;
> +
> +       /* If we're running on an old kernel, use 0 as the VM type */
> +       max_ipa_bits = kvm__arch_get_ipa_limit(kvm);
> +       if (!max_ipa_bits)
> +               return 0;
> +
> +       /* Otherwise, compute the minimal required IPA size */
> +       max_ipa = ARM_MEMORY_AREA + kvm->cfg.ram_size - 1;
> +       ipa_bits = max(32, fls_long(max_ipa));
> +       pr_debug("max_ipa %lx ipa_bits %d max_ipa_bits %d",
> +                max_ipa, ipa_bits, max_ipa_bits);
> +
> +       if (ipa_bits > max_ipa_bits)
> +               die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);

I imagine it may not be immediately obvious to a kvmtool user what
this log line means, like what 'bits' are being referred to here.
Would it be more helpful to report the maximum allowed memory size for
the system, as derived from the max IPA?

--
Thanks,
Oliver

> +
> +       return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
>  }
> --
> 2.30.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
