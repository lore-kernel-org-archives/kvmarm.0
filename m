Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CFDC43334
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jun 2022 16:20:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BF554B29E;
	Mon, 27 Jun 2022 12:20:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eLNSHltq4z7j; Mon, 27 Jun 2022 12:20:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1383C4B13D;
	Mon, 27 Jun 2022 12:20:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7AF949F3B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:20:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iY4xpXB62CBZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2022 12:20:09 -0400 (EDT)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88AEE49EE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:20:09 -0400 (EDT)
Received: by mail-pf1-f174.google.com with SMTP id x4so9503664pfq.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 09:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=l6X68KuyBDU81KFCllZcPJCpgvdaKM9lp1nYP5LV1kY=;
 b=QYuHqx8JmD3fGZhFw9UuYiMUgaHHG5YjGJZr+BhXEcVvOKmxYAAHNIYT4pML0YKcd9
 UOpJZM3FxgCDYFkMEGVBOlFqLEi8hSMYRQnc+e7vRrYWrYSatKpLhI/fy9hbjAzv1Pnb
 Fzbk/A5QTs7U7PdF27OM5n8DIpWN30JeOZDLCACOEVdlNkDU2Q35PBJKkpYSbiWrD6Tw
 wUqWe7xVXLUA8Y8WFwrTpTXlCat4Ci9KWWfxvDWzzZ/KX8yqgOjmViXM2APbm4qweJdE
 PTl/Ci9fvhKr/8UGP8qNqQ7aXyTDMrVnpzr/DD4SM5yQhjeV+eXwvVZzqlB5dla5a1gv
 MANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=l6X68KuyBDU81KFCllZcPJCpgvdaKM9lp1nYP5LV1kY=;
 b=4L2hmcdiGjt00d6SNSdmU5pBGWodDXfIRzN02W4vVc8lF1tInZ5QNrnl9ChxaH9FHy
 KMpFSzUvGzSJmBUKBZSKo7AAu4O6ZPRzf3jnLsBSBKoz0U9utUguqBxl6/evvdrd5aiS
 VjxtwlH5C6K4ztxeNRywVdyH0gGxS+96xC7Gdc65HF/cOtfqkK4CiVB5RqfyOH343ZW5
 lwzNFCWge0wQ5Pgj4ALnEj3XG/qREob09puZiNzi3TdIhOF1IGKh1nEvrurjAxO+J2cA
 uAiY+GVrdnM2KauvX8x0vZId7/68C0N2LzDVixaX917fwdxVlosDg3vRARBhJDropjzb
 RMtw==
X-Gm-Message-State: AJIora86o3fEpaCTJy180Y17CVCUizURiRGTN0wes2EXBbJlLvAB3Sdn
 f6MIxfUWEuK2d4JxMsxOwR46UQ==
X-Google-Smtp-Source: AGRyM1sm+8Ne4/LREAP1BhpBHmHl7sHKXi5L+eGvKtbQn5emgnCoxtJdYUMElvkncDMjnmXaWe/0bg==
X-Received: by 2002:a63:710c:0:b0:40c:adcf:ce72 with SMTP id
 m12-20020a63710c000000b0040cadcfce72mr13747246pgc.310.1656346808483; 
 Mon, 27 Jun 2022 09:20:08 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 10-20020a17090a174a00b001ec84049064sm7538417pjm.41.2022.06.27.09.20.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Jun 2022 09:20:08 -0700 (PDT)
Date: Mon, 27 Jun 2022 16:20:04 +0000
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v5 2/4] KVM: mmu: add a helper to account memory used by
 KVM MMU.
Message-ID: <YrnYtMGmGDxCrwdv@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-3-yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> Add a helper to account pages used by KVM for page tables in secondary
> pagetable stats. This function will be used by subsequent patches in
> different archs.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  include/linux/kvm_host.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 883e86ec8e8c4..645585f3a4bed 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2246,6 +2246,15 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>  
> +/*
> + * If nr > 1, we assume virt is the address of the first page of a block of

But what if @nr is -2, which is technically less than 1?  :-)

> + * pages that were allocated together (i.e accounted together).

Don't document assumptions, document the rules.  And avoid "we", pronouns are
ambiguous, e.g. is "we" the author, or KVM, or something else entirely?

/*
 * If more than one page is being (un)accounted, @virt must be the address of
 * the first page of a block of pages what were allocated together.
 */


> + */
> +static inline void kvm_account_pgtable_pages(void *virt, int nr)
> +{
> +	mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
> +}
> +
>  /*
>   * This defines how many reserved entries we want to keep before we
>   * kick the vcpu to the userspace to avoid dirty ring full.  This
> -- 
> 2.36.1.255.ge46751e96f-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
