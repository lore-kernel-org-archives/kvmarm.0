Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9588C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:57:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 59BA06101E
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:57:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 59BA06101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8C19406E0;
	Tue, 10 Aug 2021 00:57:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q+qmATb3k17o; Tue, 10 Aug 2021 00:57:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D60AC4A173;
	Tue, 10 Aug 2021 00:57:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 049614056A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:57:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xf9qNr8eGOJU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 00:57:50 -0400 (EDT)
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com
 [209.85.161.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2327D401A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:57:50 -0400 (EDT)
Received: by mail-oo1-f46.google.com with SMTP id
 y23-20020a4a62570000b029028727ffa408so3039662oog.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 21:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ZzIb/ALC5uOWJQxpcPBbJjvGksioyH36daLuKghiHvM=;
 b=c0FITYn9LmtYp+Fa/PwYe1ydEJp02qgTJpSn/ArFf4psnFIQSeDxgGESgqIMKZLiVA
 KbqzDsuBk5Lk5hZ6D42YbUGBACnkoRC0fGQN4WN3UIbKx55/7Wbata/iDz6KgHxThZ9L
 ZoMhypSwa+pPwMKe2XmVnwTAJMkahr20XIavtGV1bJ4nyz7RVEpW7SgUwQ3aZGdwl+Rc
 iTKWtyKpXFJ3FdIElreai6cs2X0ZPNbiztQJ758+JBNvddgqUCBC8xTutHChnGiD+/Oy
 jdsJyX+abDiPYFRzvDcc/XIWuumQTCc0amugFHMQBwjU3sThHWVPOBLAGsT2Sjs5FG7q
 jweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ZzIb/ALC5uOWJQxpcPBbJjvGksioyH36daLuKghiHvM=;
 b=JA6ki4aMEgCgYu0U2iQ1rk2b+KC61s5Pus6zoqXf/7aluHBF5pdelpf7BFTSalBTSZ
 ARMngEWe+m2Xz8vzOhrlHG4w7y+Aat21ywZHdUeKl8rS9+NHtCXEZ9aXCLDSdfwIxitU
 LznSeYX9x+tD/hWnw2gUpv2RDy9VahINuXhRwLMRljNAN4sogUV6YFy0M5qSjbV9YZ0q
 NnO12cKF4HBTXqc29ftw7zFxAc0sCNd9h4BfxSgN2zX0Yu/Y0Xng7EKJzFdw1G0fG8wp
 YIum8HWMxj8p28noO2f1DnfzndzhNHJuLIwGu/CXIPJzmyMTfidWIj6yjtJ+ITzE79oQ
 8AYw==
X-Gm-Message-State: AOAM533f4aL1o6KYwFtgJOMgnkQUNTbSVb0JMrjbCEGztTgIP+XZF7ct
 nEX7PKAFyXC9DhsEa7U1dKMwbYGlX7Lvz7uQzhN+rQ==
X-Google-Smtp-Source: ABdhPJwB2hq8/JcoLsWH5ScDehx0CJBEyn2OBkWhzQB2UgK0UtrlGIYvud3gzCmKUmah6AUNeEJfaFCoQh5ryEa9cdw=
X-Received: by 2002:a4a:4c55:: with SMTP id a82mr17509260oob.66.1628571469459; 
 Mon, 09 Aug 2021 21:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-15-qperret@google.com>
In-Reply-To: <20210809152448.1810400-15-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Aug 2021 06:57:13 +0200
Message-ID: <CA+EHjTyxW_X-xjn7opfrLFWXupfjMzCZFVBYZjgpaqLbxbjDVQ@mail.gmail.com>
Subject: Re: [PATCH v4 14/21] KVM: arm64: Expose pkvm_hyp_id
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
> Allow references to the hypervisor's owner id from outside
> mem_protect.c.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 2 ++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 0849ee8fa260..23316a021880 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -46,6 +46,8 @@ struct host_kvm {
>  };
>  extern struct host_kvm host_kvm;
>
> +extern const u8 pkvm_hyp_id;
> +
>  int __pkvm_prot_finalize(void);
>  int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index f95a5a4aa09c..ee255171945c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -31,7 +31,7 @@ static struct hyp_pool host_s2_pool;
>  u64 id_aa64mmfr0_el1_sys_val;
>  u64 id_aa64mmfr1_el1_sys_val;
>
> -static const u8 pkvm_hyp_id = 1;
> +const u8 pkvm_hyp_id = 1;
>
>  static void *host_s2_zalloc_pages_exact(size_t size)
>  {
> --
> 2.32.0.605.g8dce9f2422-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
