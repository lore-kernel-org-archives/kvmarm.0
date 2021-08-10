Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FFEBC4320A
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:37:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DAB346101D
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:37:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DAB346101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 475C74B099;
	Tue, 10 Aug 2021 00:37:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JnIl-QB6Ylld; Tue, 10 Aug 2021 00:37:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AA084B09B;
	Tue, 10 Aug 2021 00:37:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B23384B090
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:37:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZxEoeQGqRiRl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 00:37:05 -0400 (EDT)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com
 [209.85.210.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 860274A5A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:37:05 -0400 (EDT)
Received: by mail-ot1-f54.google.com with SMTP id
 61-20020a9d0d430000b02903eabfc221a9so20705290oti.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 21:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=iuMMsEGLKerJ5lRGm/ABGvekt+HABMuilZ78dGDMJFI=;
 b=ioEjI7POv1cOzJm+7aGtRJgUkHGN5G04oOdKw4Y5sPhvuQCMRhHIrbibStOLzToRRe
 dsgBt7ZtUDzC32C9wLFzsphd41QuTZOyW5GGh8u9N9U/YlvctKES0KYQNjK+Ifj6bbQL
 aXmwqH522XxzHPUTBLvNZAKG5azpSHKie775cWKhwwvBsIolmsvyvriYf/uJKG5oo6u+
 4V+N8uD5TAsA17K4PlcM0N1UpExhSWcY5XZDxYOyIRGNIfS71srC2VHAAaJp9bx7Yuah
 DHaWUC7tyXgI6EOeuzbOCtdEo50TLaq8/j7Lnn0CCcAstLoLg+qO08WcLw2v1x1apqre
 Obrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=iuMMsEGLKerJ5lRGm/ABGvekt+HABMuilZ78dGDMJFI=;
 b=bL03KhLgHwAi7QFFMKwD1lgoLoxen5X94RXtsMDIEpQkfEEzRZLraYXv2jSo1ZMYY9
 YbZ3h+yKadVeiXGjZay7Oy5n2VNPwqMhdGsQt3g6C1rZ18IRFSz0jr0G6EpiLaxVq8c/
 GAT8SButpwn9jxzeRW8DAndOlDdqckO3AfSBgT1VQ1wP5hHUEG3XDqXbkREsw385ts21
 vaeJ4f8OHso5g2qIaSOiQYgJaTkx+7767ji3PYBSZBFr13wn+SFfAc5bdH/pNMrG4hQ0
 SSTE+bdHOMUGCRXDR3gguZC43AhI3zCHvB2Ky5g3gOunEdUXhg0KaOBnf/yqQtCnNuit
 Bvww==
X-Gm-Message-State: AOAM532rzKftfJJJIbq42xE17mpoXK+GX/kVN09qnuQOHRCksPTw045i
 FIPwvdePNy1DJqB7RAuW8cwQsz3BZ38aweTYtlRtuQ==
X-Google-Smtp-Source: ABdhPJxh1ebQPLukCRAzo162yMxeyI9EjHD2CefBzJPEaYqBoaxTTKzCRsMUssS39EaR+fX2grAPznuKU9j+qgdfN6w=
X-Received: by 2002:a05:6830:1095:: with SMTP id
 y21mr9439797oto.144.1628570224785; 
 Mon, 09 Aug 2021 21:37:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-14-qperret@google.com>
In-Reply-To: <20210809152448.1810400-14-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Aug 2021 06:36:27 +0200
Message-ID: <CA+EHjTyb2Ge1QBXyRaTmXfjB=2uy2y-EDxag-Oyy03paAt4tvg@mail.gmail.com>
Subject: Re: [PATCH v4 13/21] KVM: arm64: Expose host stage-2 manipulation
 helpers
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


On Mon, Aug 9, 2021 at 5:25 PM Quentin Perret <qperret@google.com> wrote:
>
> We will need to manipulate the host stage-2 page-table from outside
> mem_protect.c soon. Introduce two functions allowing this, and make
> them usable to users of mem_protect.h.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 ++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 18 +++++++++++++++++-
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 87b1690c439f..0849ee8fa260 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -49,6 +49,8 @@ extern struct host_kvm host_kvm;
>  int __pkvm_prot_finalize(void);
>  int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
>
> +int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> +int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
>  int kvm_host_prepare_stage2(void *pgt_pool_base);
>  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 6fed6772c673..f95a5a4aa09c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -273,6 +273,22 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
>         return 0;
>  }
>
> +int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
> +                            enum kvm_pgtable_prot prot)
> +{
> +       hyp_assert_lock_held(&host_kvm.lock);
> +
> +       return host_stage2_try(__host_stage2_idmap, addr, addr + size, prot);
> +}
> +
> +int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> +{
> +       hyp_assert_lock_held(&host_kvm.lock);
> +
> +       return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
> +                              addr, size, &host_s2_pool, owner_id);
> +}
> +
>  static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
>  {
>         /*
> @@ -309,7 +325,7 @@ static int host_stage2_idmap(u64 addr)
>         if (ret)
>                 goto unlock;
>
> -       ret = host_stage2_try(__host_stage2_idmap, range.start, range.end, prot);
> +       ret = host_stage2_idmap_locked(range.start, range.end - range.start, prot);
>  unlock:
>         hyp_spin_unlock(&host_kvm.lock);
>
> --
> 2.32.0.605.g8dce9f2422-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
