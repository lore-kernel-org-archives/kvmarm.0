Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63175C87
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 23:32:40 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id h2so11350102plb.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 16:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GOdTdD623/YusJfsR/UmEt7HXnKEb0mP+WLNynhu5/Y=;
        b=RWtmUC50GX+0ZQ32g5qbwMLI9xk+r3RrIN8WIX6WSDXgNKi/IH1rFAOE4BaRmDOCQk
         q7NcLh/IYp1ium4abQncAyZUxt/D3M5+XQl9CoRXilqBPO8N7h8Jf1CsFhYVmbXfCDdJ
         GbBFo1r2OXRzCG1d6k4VKyRHomEcqSQLuRT1GyZuynIX/BDcf2/PoFz/pjQyhWdxhJ7R
         sVD0VYdKcDhEum9a00zy7yQZGSf1l+tyC0pHYAEN1ldQKbAxqHQ5v3UZrDNPbgf8ayEb
         tsZrpuY+i/Gwr3TBh/bb8CgBxKZoVz2rjfEqDWpfKxbbZxwNuW3dc3dvsTFn1MN1mOlW
         kiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOdTdD623/YusJfsR/UmEt7HXnKEb0mP+WLNynhu5/Y=;
        b=puKQndIxQyXLLfz3S/gT7tmKyUy/3dtbVGsBGMLwYCtwxbq3X6JHsTR/QENA+vnOKe
         eghSCfq02JaF+kvhRPU96FOsUKl5mcLaGnJ99AOJhrQq2w7FVbvzvcTxk7ePe9PdTfuY
         wueb0MjxUfj5GcwtMOs/btaXHS+7C0BLDRq4MpsihCsMyT+UHhZaT8A5wQKkZ12125YQ
         X2R29Sv/CrkGmzThaI/MZEa10ggRJJ9kdvjGEmVWSa2WfNq1E01ID0r9MG2B8ypeQL5/
         LsCgkSaC6+mP4aylcK0zsZDkSfHV+qSJ6U2d18cjdrDNYBYyK2Rmkid4quIlrNhXwjPf
         OifQ==
X-Gm-Message-State: ACrzQf3T5YsjC1ihUgIlSYXrkv1uz51hJkwRo+Do/K9Isy/3PHkTkoFu
	f5OuQtZfbXHNii4OhUucUH7l/g==
X-Google-Smtp-Source: AMsMyM7CQOx8R08XpaqcxD826bEvd+nBp7WOm8CizWjgaSQhvlO4ECeDzJxBWgIKiZPBPtpO/OIQMw==
X-Received: by 2002:a17:902:e3cd:b0:17f:9c94:b22f with SMTP id r13-20020a170902e3cd00b0017f9c94b22fmr10927856ple.80.1666222360234;
        Wed, 19 Oct 2022 16:32:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f14-20020a170902ab8e00b001783f964fe3sm11270350plr.113.2022.10.19.16.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:32:39 -0700 (PDT)
Date: Wed, 19 Oct 2022 23:32:36 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 15/15] KVM: arm64: Handle stage-2 faults in parallel
Message-ID: <Y1CJFLVnnbX4Ck85@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007233253.460257-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007233253.460257-1-oliver.upton@linux.dev>
Message-ID: <20221019233236.ojpmSPkXFCxsYzQm5U_1sfjhtk7xps7Jy1WZKOoh2r0@z>

On Fri, Oct 07, 2022, Oliver Upton wrote:
> @@ -1534,7 +1517,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	 */
>  	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
>  			       PAGE_SIZE, __pfn_to_phys(pfn),
> -			       KVM_PGTABLE_PROT_R, NULL);
> +			       KVM_PGTABLE_PROT_R, NULL, KVM_PGTABLE_WALK_SHARED);

All MMU notifier events acquire mmu_lock for write when invoking arch code, i.e.
this isn't a shared walk.
