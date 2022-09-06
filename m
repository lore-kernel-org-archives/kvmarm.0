Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB98AECAAD5
	for <kvmarm@archiver.kernel.org>; Tue,  6 Sep 2022 14:35:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 540AA4BDDE;
	Tue,  6 Sep 2022 10:35:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7T0Vmz6Hi0IU; Tue,  6 Sep 2022 10:35:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34FC14BD69;
	Tue,  6 Sep 2022 10:35:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10F674BD12
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 10:35:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B-lv7jNoxcGq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2022 10:35:51 -0400 (EDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com
 [209.85.218.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D23E84BBBA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 10:35:51 -0400 (EDT)
Received: by mail-ej1-f46.google.com with SMTP id fg1so1640676ejc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2022 07:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=rMmt2TPlkwTJa1Vj/UqXw4OPfF6SV2ruzHSSjtSG6gI=;
 b=p8gTx3uOF4/ovmXPFVRTuzyCMLlLLhT4cULIky1/IL8+iHMHN/Vt9kisTT0x13y5y6
 1JrMubmWdS3RiAIdUBO3BzsfLe93IIXY2jVDIsDfOzVyq86Dk+K8V2v9nl1aYoEDOqzO
 v4BmSEkFlehCfvhThoWnOBq4wXZLuZG4tGqjgg3iQIBi2WhnLil3QOGlU+jcm0dvTxdb
 FBDNP3wkiukuDA9WlvUR289cSqbCdxmcqmidlmPrHl0GKV9BhrStliKQ0zbklVtzcvVg
 bW9RYHZlO/Ymx1i7ZL2HN7OGRdn6pV+RqJ6HLVkZg4niM2nbzxR7mHgCEEiZeD8UW7ET
 nBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=rMmt2TPlkwTJa1Vj/UqXw4OPfF6SV2ruzHSSjtSG6gI=;
 b=hAspxQ7MclvhT7cyK6xHp2M7q+FRvYx6Y+OSlQLkJqaw4xsCV4JxHO8ssDMrM/a2gF
 UtSszNbeHIzX9ZPCnOS9Jopde5hCyjZrra93owr8QD3HLD/Ii4evxqITBHOB3Bj0SB/U
 cpcrxDzwTgeaWrWEEFo3tn6gI/cJVY/edEUJEeN48lIXv+x+b5xDFFjpLXfH3iqAyxBn
 QscxWw2451tG8HLHHzMYkDsaOGpdGmBrLGs4FolvZX91fNV3pWnM1wVmlnjhVV8RyVQ3
 1eTR0emz7V4giXnucwQpebaVISCX/CpYcKTiew2zIPamO3v5mtNzn+xTwG8mlOzLfXS0
 nYHA==
X-Gm-Message-State: ACgBeo0GrKClGItvTG3qnFqyJvvUiNw4y/NKY6u9NtqdMEhSJTHxlbnb
 XNNF+XNqy0VqOKZ/XxQCe1u5Zg==
X-Google-Smtp-Source: AA6agR5np46sPXKIJ6mj4xhD1w/LSNMP/pZ9ZrZilKDS7z6Q4hPFRehMAa3RPeEVWH2GeFCQf1WWwQ==
X-Received: by 2002:a17:907:2cd4:b0:73c:9fa8:3ddc with SMTP id
 hg20-20020a1709072cd400b0073c9fa83ddcmr30463131ejc.40.1662474950709; 
 Tue, 06 Sep 2022 07:35:50 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com.
 [34.90.227.64]) by smtp.gmail.com with ESMTPSA id
 h41-20020a0564020ea900b0044629b54b00sm8561495eda.46.2022.09.06.07.35.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Sep 2022 07:35:49 -0700 (PDT)
Date: Tue, 6 Sep 2022 14:35:47 +0000
From: Quentin Perret <qperret@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 02/14] KVM: arm64: Tear down unlinked stage-2 subtree
 after break-before-make
Message-ID: <Yxdaw1qng/Or0LLA@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-3-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

Hi Oliver,

On Tuesday 30 Aug 2022 at 19:41:20 (+0000), Oliver Upton wrote:
>  static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  				     kvm_pte_t *ptep,
>  				     struct stage2_map_data *data)
>  {
> -	if (data->anchor)
> -		return 0;
> +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	kvm_pte_t *childp = kvm_pte_follow(*ptep, mm_ops);
> +	struct kvm_pgtable *pgt = data->mmu->pgt;
> +	int ret;
>  
>  	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
>  		return 0;
>  
> -	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
>  	kvm_clear_pte(ptep);
>  
>  	/*
> @@ -782,8 +786,13 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  	 * individually.
>  	 */
>  	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> -	data->anchor = ptep;
> -	return 0;
> +
> +	ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> +
> +	mm_ops->put_page(ptep);
> +	mm_ops->free_removed_table(childp, level + 1, pgt);

By the look of it, __kvm_pgtable_visit() has saved the table PTE on the
stack prior to calling the TABLE_PRE callback, and it then uses the PTE
from its stack and does kvm_pte_follow() to find the childp, and walks
from there. Would that be a UAF now?

> +	return ret;
>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
