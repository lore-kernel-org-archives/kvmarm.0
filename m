Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822B9C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jul 2022 21:08:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDB624BA5E;
	Thu,  7 Jul 2022 17:08:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N71ocR776bxt; Thu,  7 Jul 2022 17:08:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 930C94B83D;
	Thu,  7 Jul 2022 17:08:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 635794B83D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 17:08:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kcNlMF35PFHP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jul 2022 17:08:42 -0400 (EDT)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DD844B81A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 17:08:42 -0400 (EDT)
Received: by mail-pg1-f172.google.com with SMTP id q82so13525304pgq.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Jul 2022 14:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Z0i/FsEtEYZWQoqmAH7Voc71S2cgw06FoAKusiT8OZ4=;
 b=WoU0PSQ0Wj5Vhi5VAdOixoxhmqcmoNDkx6vHqBySeC9zqf2nqsQfssDemp0HQ+Ov1B
 x/J5MxoGXzLdJH5GEyRAbOhWT68fOGc+6rHAXDByBx1OVQfP46gGjK+Mi+BzW6aTzy1J
 zCmFPJ2SlEc+diWQW3EPCjFu0t4IWIGEdVT9pGCnFTtf0M7aL/JzkavojLQOy4s/UgNF
 NGApv5Q7B2F5jgchJKAeNIaqUXEoBZLJR5OdL0c5HU9ZNIBlR45kMkufdSbiFomJXlCl
 /ZAg/DkWLMF98iVndrnP9vxLYNAXMsIgTDVMZU2Ziwpk1aIQXpLAs3/2s4PDhY8kMxbt
 LAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Z0i/FsEtEYZWQoqmAH7Voc71S2cgw06FoAKusiT8OZ4=;
 b=s8UbbC2oJBICrKtjGyf6x8JXHImw8HuxSj+QdWwkq6UzFg7FrTaa1w/IVHnPE7jLUi
 0UwfmmzTWtW4sK7+MPM9aUR0z586QARUI6WhG+lzqPmdLIYJ/Annz+cncj6VcsVNpzo6
 SlmW6tWD8klBde2ooPgOk73k+u6oi1j8g7cWPWpZmoaxvL3MiNF/iYQ5czXE/m3AvGtv
 qq/ljh+4N8CYnnjHj90uaXBh/fUGaaV4OJhR4u4q4/xI7qRCrSyabGYWyQTrpiGvswtj
 WnvxyIc5HqaR9X+zbjfnE5ImCxaZKOHp3IKyiEFaR+y5VQIsS0lDoQd+M3FbzPCzap26
 0zYQ==
X-Gm-Message-State: AJIora+pChlZVplIF8GHl6b7Dm6wN0auW+jm262rrxO+rXnAOmbuIekj
 pzpORQk6wkYQtO8he+GuFYCxjg==
X-Google-Smtp-Source: AGRyM1vgBjc1RVmgOpFR/T4l7q4gAYOsF/Sy+FYulOKydzkkokjqIlGLn0bz30DcFIQoLNe6uAKcaA==
X-Received: by 2002:a05:6a00:13a5:b0:525:1da8:4af4 with SMTP id
 t37-20020a056a0013a500b005251da84af4mr55191739pfg.43.1657228121170; 
 Thu, 07 Jul 2022 14:08:41 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 m17-20020a170902db1100b0016a275623c1sm20721984plx.219.2022.07.07.14.08.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Jul 2022 14:08:40 -0700 (PDT)
Date: Thu, 7 Jul 2022 21:08:36 +0000
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v6 2/4] KVM: mmu: add a helper to account memory used by
 KVM MMU.
Message-ID: <YsdLVBtl16mx3+Ot@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220628220938.3657876-3-yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, Huang@google.com,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> Add a helper to account pages used by KVM for page tables in memory
> secondary pagetable stats. This function will be used by subsequent
> patches in different archs.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  include/linux/kvm_host.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3b40f8d68fbb1..032821d77e920 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2241,6 +2241,16 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>  
> +/*
> + * If more than one page is being (un)accounted, @virt must be the address of
> + * the first page of a block of pages what were allocated together (i.e
> + * accounted together).

Sorry for the belated thoughts...

If you spin a v7, can you add a note to call out that mod_lruvec_page_state() is
itself thread-safe?  Caught my eye because the TDP MMU usage happens while holding
mmu_lock for read.

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
> 2.37.0.rc0.161.g10f37bed90-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
