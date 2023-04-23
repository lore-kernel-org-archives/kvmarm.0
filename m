Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B557F2
	for <kvmarm@lists.linux.dev>; Sun, 23 Apr 2023 19:47:52 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1a9290a6f96so409825ad.1
        for <kvmarm@lists.linux.dev>; Sun, 23 Apr 2023 12:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682279272; x=1684871272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IH0UhTga2Ggf3gBi/LWbIB66Yn9BwYN3FLa4+Rl5znE=;
        b=46oMTjfOUEOW0USYxhExI9nVbbYygkR+I6flk2OKspSTPOE3WBCGf+M9mM/Vswq2qK
         4qsfPyxK7+5xcMEfEcZ8TrHNp1d4v5bpXNKZQBdcbR0IqtIlDxlCYcSuIHzu1Ue498CQ
         6Xqsb+EH4pTlD2yxIWAPp77cIDTurO9sXcLlmWnQOjNHccnFzoWKrCsDCyBzCOtpmpSp
         F2NJ1osEoWFxkiAx8Q66kQ5uzXZHmgimhPyzl9cA2/s3yy0BssVcrbpQBbMEogBbdivS
         3xKWWj0qMwqZaBeS3mGRGL1tcafNbmuhYn8jMdatau7dFZ9uu0vq2i37dUEDkESaEwXR
         hQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682279272; x=1684871272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IH0UhTga2Ggf3gBi/LWbIB66Yn9BwYN3FLa4+Rl5znE=;
        b=W+2LL5YkoHMfHPprnvsyufPhd071m7qwgfYLc47bU6zrqR1vRMWM/Vfkx6kqT549NX
         gAiMU0v2IWzQpDf4qOXkHwf+OClqaDPTXJOq6Aw0RdVVDZ2N45oRijR/8jSONkbucOsT
         06TgpSBXTNpMJLFPEshFwGAM7OGad/nhEw9nQuzjlTXXjcblbBdVkHBnOM4Ujtj8Imij
         ICjY+XrMgzK/YJjbmrqyjIqpjPEpcX6+zRhYtHSa1bKr5FD7DsUbxz7rYWSH55ltCLRZ
         Yy6gvzL0qKN9mv9SvdizDyj8pPYI9Pk+i9KfYBMkmCjHkO/Y90fe4U3CAl28cacovNm5
         R4Ew==
X-Gm-Message-State: AAQBX9eK+s+pNrlPjOeoS2Kbb2fmmv5PIMfwsXxCfblfsbAbEr24uRPb
	cmoteDt6g0hD2X3o9U0nhl52tQ==
X-Google-Smtp-Source: AKy350YCxJSlp2GFMyn7d8p+/8XtIli5TcQQGF247uJqgvBOckKitJhsjprD1GxzxwFMJp4aFF8gsQ==
X-Received: by 2002:a17:902:7c0f:b0:1a6:c161:37d7 with SMTP id x15-20020a1709027c0f00b001a6c16137d7mr298917pll.5.1682279272112;
        Sun, 23 Apr 2023 12:47:52 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id h125-20020a628383000000b0063b87717661sm6057262pfe.85.2023.04.23.12.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 12:47:51 -0700 (PDT)
Date: Sun, 23 Apr 2023 12:47:48 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
	Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v7 05/12] KVM: arm64: Refactor
 kvm_arch_commit_memory_region()
Message-ID: <ZEWLZDK39w737qiI@google.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-7-ricarkol@google.com>
 <2819bd9d-9a8c-938c-9297-86c1b8614550@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2819bd9d-9a8c-938c-9297-86c1b8614550@redhat.com>

On Mon, Apr 17, 2023 at 02:41:39PM +0800, Gavin Shan wrote:
> On 4/9/23 2:29 PM, Ricardo Koller wrote:
> > Refactor kvm_arch_commit_memory_region() as a preparation for a future
> > commit to look cleaner and more understandable. Also, it looks more
> > like its x86 counterpart (in kvm_mmu_slot_apply_flags()).
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >   arch/arm64/kvm/mmu.c | 15 +++++++++++----
> >   1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> 
> With the following nits addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index efdaab3f154de..37d7d2aa472ab 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >   				   const struct kvm_memory_slot *new,
> >   				   enum kvm_mr_change change)
> >   {
> > +	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> > +
> >   	/*
> >   	 * At this point memslot has been committed and there is an
> >   	 * allocated dirty_bitmap[], dirty pages will be tracked while the
> >   	 * memory slot is write protected.
> >   	 */
> > -	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> > +	if (log_dirty_pages) {
> > +
> > +		if (change == KVM_MR_DELETE)
> > +			return;
> > +
> >   		/*
> >   		 * If we're with initial-all-set, we don't need to write
> >   		 * protect any pages because they're all reported as dirty.
> >   		 * Huge pages and normal pages will be write protect gradually.
> >   		 */
> 
> The comments need to be adjusted after this series is applied. The huge pages
> won't be write protected gradually. Instead, the huge pages will be split and
> write protected in one shoot.
>

I see, this comment is a bit confusing. Will update it to this:

                /*
                 * Pages are write-protected on either of these two
                 * cases:
                 *
                 * 1. with initial-all-set: gradually with CLEAR ioctls,
                 */
                if (kvm_dirty_log_manual_protect_and_init_set(kvm))
                        return;
                /*
                 * or
                 * 2. without initial-all-set: all in one shot when
                 *    enabling dirty logging.
                 */
                kvm_mmu_wp_memory_region(kvm, new->id);

Will update the comment to include splitting when introducing eager-splitting
on the CLEAR ioctl (case 1.): "KVM: arm64: Split huge pages during
KVM_CLEAR_DIRTY_LOG".

> > -		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> > -			kvm_mmu_wp_memory_region(kvm, new->id);
> > -		}
> > +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > +			return;
> > +
> > +		kvm_mmu_wp_memory_region(kvm, new->id);
> >   	}
> >   }
> > 
> 
> Thanks,
> Gavin
> 
