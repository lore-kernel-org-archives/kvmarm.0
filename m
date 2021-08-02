Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B272C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 11:14:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F09FC60FC2
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 11:14:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F09FC60FC2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E3B64A531;
	Mon,  2 Aug 2021 07:14:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bq5dmny6JcJQ; Mon,  2 Aug 2021 07:14:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54D354A7FD;
	Mon,  2 Aug 2021 07:14:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC41A4A531
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 07:13:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KSqtVYSFBPBm for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 07:13:57 -0400 (EDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com
 [209.85.210.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB9C24A19E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 07:13:57 -0400 (EDT)
Received: by mail-ot1-f50.google.com with SMTP id
 x15-20020a05683000cfb02904d1f8b9db81so5570802oto.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 04:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=0CfDLtrkCkMzvLd35FEs6eMwBrh1e58lQcLyXALKvq0=;
 b=AybFJOtKRe0q6jJhqwD86EFrT14YFKKUCn0/lX25FdoRhTsyaZ6uPTsCg/y0ubJqCO
 z/Ap1RHVChJarWRV1k+rH/fX/V4fmA4obJqont8F6g1d3ckqT7Vwpdll97eRr8n54TVe
 no5UyzPnO+eGTcIgU4Py4/s+xQKjE1Y4DsVo7wfz3fKgAXXo9aGFCsDxRxOd8pCms28s
 eYg6g1qgj6fIIXsNYwhK+FKg/U0izdC0WLdlaY0+aFI2rEx+U7B4xOIQpkJjyXQjIEfl
 fEK3BsXeSe3kbUyaTWSsnt8Y94PtzisV7qFyHIjbUX4l7SGMM3rbjKz7LifoSAUA0FrV
 EKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0CfDLtrkCkMzvLd35FEs6eMwBrh1e58lQcLyXALKvq0=;
 b=EctoOth1wCrgA33vg6ZJNcJZhjO3mbrOgy/4jHMy+PcJOauSccxK8ztrUrgGoWXgeQ
 AU7F1ndrRIT2BB4JoWU6krWIOwhq71+d/ouWnv8vwyYdb4N9QShKeN6a5wrRrJ4GhUfj
 66gyye+TTcLtFW3YCwbbiQ7d02FQr5DYZHhW+JXVsgVSr8UWmYxnGO/ZrUnk4lgUBgT1
 zGp/X2wqFciOg2HlP8ylGOor0uKdFyL/jurRjqQDIuyHJkdQ3aZkh0juNhFlfcXthpd8
 57isPNsk4fd1MOBKLJL9LqoDcFb/0iCGVPc09a2gF/0xnqBc2GrndBNbK+tNMcdyH35w
 NtZQ==
X-Gm-Message-State: AOAM532umiROFHqaFA9SC4BLa+41vcRzbunxSZdvrb/hGe9Gf13JdKVk
 eVRWtwRcNDzB0SqJ+pNaOeJlVE6I049ADPdmywl90Q==
X-Google-Smtp-Source: ABdhPJxRpcv8YUt/d5raKHTBgJ8s47A7Jkisqse/dDL12s34vizVFXgZbUpeOvNeTac/Ai7ulOfMTQki8uGGCwIVlzk=
X-Received: by 2002:a9d:4b02:: with SMTP id q2mr11320334otf.52.1627902836962; 
 Mon, 02 Aug 2021 04:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-14-qperret@google.com>
In-Reply-To: <20210729132818.4091769-14-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Aug 2021 13:13:20 +0200
Message-ID: <CA+EHjTxTaPc=bt_kyXf0TE85v5eyHnq0o3KQ3Pd6+kOwmm5oMw@mail.gmail.com>
Subject: Re: [PATCH v3 13/21] KVM: arm64: Expose host stage-2 manipulation
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

On Thu, Jul 29, 2021 at 3:28 PM Quentin Perret <qperret@google.com> wrote:
>
> We will need to manipulate the host stage-2 page-table from outside
> mem_protect.c soon. Introduce two functions allowing this, and make
> them usable to users of mem_protect.h.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 ++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 17 ++++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index ae355bfd8c01..47c2a0c51612 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -49,6 +49,8 @@ extern struct host_kvm host_kvm;
>  int __pkvm_prot_finalize(void);
>  int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
>
> +int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot);
> +int host_stage2_set_owner_locked(u64 start, u64 end, u8 owner_id);
>  int kvm_host_prepare_stage2(void *pgt_pool_base);
>  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 70c57d2c3024..a7f6134789e0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -272,6 +272,21 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
>         return 0;
>  }
>
> +int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot)
> +{
> +       hyp_assert_lock_held(&host_kvm.lock);
> +
> +       return host_stage2_try(__host_stage2_idmap, start, end, prot);
> +}
> +
> +int host_stage2_set_owner_locked(u64 start, u64 end, u8 owner_id)
> +{
> +       hyp_assert_lock_held(&host_kvm.lock);
> +
> +       return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
> +                              start, end - start, &host_s2_pool, owner_id);
> +}

This is a potential issue elsewhere as well, but all functions in
kvm_pgtable.h, including kvm_pgtable_stage2_set_owner, specify an
address range via address and size. The two you have introduced here
take a start and an end. I'm not sure if making these two consistent
with the ones in kvm_pgtable.h would be good, or would just complicate
things in other places.

Thanks,
/fuad

>  static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
>  {
>         /*
> @@ -309,7 +324,7 @@ static int host_stage2_idmap(u64 addr)
>         if (ret)
>                 goto unlock;
>
> -       ret = host_stage2_try(__host_stage2_idmap, range.start, range.end, prot);
> +       ret = host_stage2_idmap_locked(range.start, range.end, prot);
>  unlock:
>         hyp_spin_unlock(&host_kvm.lock);
>
> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
