Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A516CC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2306B6101D
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2306B6101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 919E3406DD;
	Tue, 10 Aug 2021 00:38:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ed8JUnI9eCVS; Tue, 10 Aug 2021 00:38:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95394407EC;
	Tue, 10 Aug 2021 00:38:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 197214075E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:38:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 853CMVKJydKK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 00:38:20 -0400 (EDT)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com
 [209.85.210.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9B9D406DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:38:20 -0400 (EDT)
Received: by mail-ot1-f53.google.com with SMTP id
 v10-20020a9d604a0000b02904fa9613b53dso9676923otj.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 21:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Tnu+lsSrDSRPCYWeAaFux3QzDyGNUIeki6mMXLL1AQ8=;
 b=h1swO8aoNKX/XPUmGYeHzDkQRqO2JXJKQNYLluUM/Qv6reFjk6vzUTe/FWxM/I58Y1
 PUpqbklpKLpyrKBJLLP9tBjovMU948PuN8zDU5HtovPgIhrDgK4U6PsW0ezdxrSFa8BW
 6J7Dnp5TWFylH6JalMrSE497B0ykh2UewEPi6z21mFzV9LFrqA5Ua0LueZRBfNE9AJ32
 VLoTGnYUus/gsWvfVTWd3HISSrOiUyuGms08PvTcFefxv10mbAj66vhn2hsoOm4mEhoy
 H25yhfwHagSnXwYW9Pr6QDPJWOMraIoq5aeL5Wy2vZYcEECfMdb8UqXhW6pUeNtT/Y75
 dYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Tnu+lsSrDSRPCYWeAaFux3QzDyGNUIeki6mMXLL1AQ8=;
 b=lLW5ymOW+0hYCTFZEgVCyTjheVlIcn5YzUQH0tD513TPJaDN3it4q4+76Byw+yLh+w
 kgCaamV8kqy0dRNWJDZODw6YZfnJCw7/t5ps83tYEyfIQ5qkFQG6ECRyhwCXeUj8Arqx
 qPwir4NxEOwgHwAFr/pQkb8F+si6r/HN1COB86EwentBhfq9YPI7j/JSXa/6v8gdaPLh
 Ex3fjYqs++wMpYl2BO6T5dkETfxrH3wgV79H0WKkOhNg/9cyqWt8OIYwqbMhXbJJlyKP
 kW4KAkShrUQAWUOSvL/0nhnOOpBNSaSF3Te2APvHv8HZObjbHH9CDQt+qotf3dFFkRZ7
 FphQ==
X-Gm-Message-State: AOAM531/+SL8n+0VxCj7wqaCYPsHZ6igrJprkjjyxu40z4NXRhGFOHRc
 jeSA4yQSAfDQIGED5XliTxTGPCHzU2ugm9oyieC35g==
X-Google-Smtp-Source: ABdhPJz7Ud6NbsIMc8xc/kkaEDx+aqAP+puu3PhhO67FNRYKCRw2jQ/s7n8Y3m0vAFImBSwUQMFFxWe6T/B3a56P0/0=
X-Received: by 2002:a05:6830:1095:: with SMTP id
 y21mr9442654oto.144.1628570299957; 
 Mon, 09 Aug 2021 21:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-16-qperret@google.com>
In-Reply-To: <20210809152448.1810400-16-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Aug 2021 06:37:43 +0200
Message-ID: <CA+EHjTxTMQ1n2F_6i6Ep9JgJauRs1ez2OyT-3y26dkGS5p58Zw@mail.gmail.com>
Subject: Re: [PATCH v4 15/21] KVM: arm64: Introduce addr_is_memory()
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
> Introduce a helper usable in nVHE protected mode to check whether a
> physical address is in a RAM region or not.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 1 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 7 +++++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 23316a021880..49db0ec5a606 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -51,6 +51,7 @@ extern const u8 pkvm_hyp_id;
>  int __pkvm_prot_finalize(void);
>  int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
>
> +bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
>  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
>  int kvm_host_prepare_stage2(void *pgt_pool_base);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index ee255171945c..cb023d31666e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -197,6 +197,13 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
>         return false;
>  }
>
> +bool addr_is_memory(phys_addr_t phys)
> +{
> +       struct kvm_mem_range range;
> +
> +       return find_mem_range(phys, &range);
> +}
> +
>  static bool range_is_memory(u64 start, u64 end)
>  {
>         struct kvm_mem_range r1, r2;
> --
> 2.32.0.605.g8dce9f2422-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
