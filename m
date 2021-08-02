Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03726C4320A
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:39:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72798610CC
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:39:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 72798610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 030934B087;
	Mon,  2 Aug 2021 05:39:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T06vAY3MiT2U; Mon,  2 Aug 2021 05:39:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 031E74A19B;
	Mon,  2 Aug 2021 05:39:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 498DD4048B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:39:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tSRwJk2qhLOS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 05:39:08 -0400 (EDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D4C04020A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:39:08 -0400 (EDT)
Received: by mail-ot1-f47.google.com with SMTP id
 68-20020a9d0f4a0000b02904b1f1d7c5f4so16947130ott.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 02:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=KIhuVO31AIHAnVi6gacSlctqNjiS0tDQNaPPnMjyEgs=;
 b=CkxP3OMXRT7rLbi/FFZl51CGbyjS+cUeycZ1yrPwAdMjmCFHeISe0JpzKij21Jchjq
 MvAe1d0WxwSfKYnIb1jc0xFIzN8HqVswmLgEE3YJRp38bPU8r/2UKvCmwqGGp0HiSgjX
 IGDqOxgIr3kU9YwrqodFq+cXJ+QSVM6kjGUWItG6KvmqMw3xDG+AzrRYcGkrkRjFK7rJ
 otiDrGnvky+wnLfJedyWkXTwUz48sxy111gyhJJe4Pd6c969o8ZixHKRWDLZi44yMv4L
 jF3jgEs07drqy5cd1Kb6azRN5jr3AN1qGAj3cq6dNxekSFxzjwTohMfMfJNtVNp8V+uU
 n/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=KIhuVO31AIHAnVi6gacSlctqNjiS0tDQNaPPnMjyEgs=;
 b=ej0RE+/i9Go/aZqclp5OIfsRT4DWnCjbGGQhvzUmeoznnFNumMZL4c9xEjmKIiVk4L
 Bkc3SrijORn9hEW0KFDszmsJkaDzqmmc1ILln0phLoGNXsncZj5PpUNyJerPjiL6GmET
 KGJV932phh2l8le6SNfRmkO7L1ScrMI8Z9zo0m+tib7sbkRTvwU6CYQjRpXoUyTwgrXK
 0uQCbmtVk/6j+zpXwpQqV4YdOCq4/1SMa+Gtp67YQWbroW+r2ybS0Dsk8zhS6BvFvoxu
 4NcsQ4m4yrPLCsjKc4bZ2UyXTRWKDLX097/tFJhDGIV5p5quxixcHgxy/SeCG+Q8XyaF
 zyCw==
X-Gm-Message-State: AOAM533/R/EyW8JBP+b+0S0b7YZfWPAlcC8eReyJ9M/FoxZhHQpc2gRJ
 W82uHod7BYpv/VNqaQ2Yhdip0V4I0RK3GVXhtBwqLQ==
X-Google-Smtp-Source: ABdhPJzScvX5nNNMmBy1r7KuE//uE0B0IqSD3Z0D7k2I3N1Napre9QlekC99+TW4f+xqAoRYkCZnLm//v97AQVtdrbE=
X-Received: by 2002:a05:6830:1455:: with SMTP id
 w21mr11200078otp.365.1627897147542; 
 Mon, 02 Aug 2021 02:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-9-qperret@google.com>
In-Reply-To: <20210729132818.4091769-9-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Aug 2021 11:38:31 +0200
Message-ID: <CA+EHjTwSg8gZCoxkRu1HEiqhKQuAoascU208c19=-MYBuvf1nw@mail.gmail.com>
Subject: Re: [PATCH v3 08/21] KVM: arm64: Don't overwrite software bits with
 owner id
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
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

Hi Quentin,

On Thu, Jul 29, 2021 at 3:28 PM Quentin Perret <qperret@google.com> wrote:
>
> We will soon start annotating page-tables with new flags to track shared
> pages and such, and we will do so in valid mappings using software bits
> in the PTEs, as provided by the architecture. However, it is possible
> that we will need to use those flags to annotate invalid mappings as
> well in the future, similar to what we do to track page ownership in the
> host stage-2.
>
> In order to facilitate the annotation of invalid mappings with such
> flags, it would be preferable to re-use the same bits as for valid
> mappings (bits [58-55]), but these are currently used for ownership
> encoding. Since we have plenty of bits left to use in invalid
> mappings, move the ownership bits further down the PTE to avoid the
> conflict.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 59a394d82de3..1ee1168ac32d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -46,7 +46,7 @@
>                                          KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
>                                          KVM_PTE_LEAF_ATTR_HI_S2_XN)
>
> -#define KVM_INVALID_PTE_OWNER_MASK     GENMASK(63, 56)
> +#define KVM_INVALID_PTE_OWNER_MASK     GENMASK(9, 2)
>  #define KVM_MAX_OWNER_ID               1

This change makes sense so that the same bits can be used to track sharing.

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

>
>  struct kvm_pgtable_walk_data {

> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
