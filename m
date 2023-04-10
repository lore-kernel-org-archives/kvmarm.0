Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC063217
	for <kvmarm@lists.linux.dev>; Mon, 10 Apr 2023 18:26:15 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1a273b3b466so341545ad.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Apr 2023 11:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681151175; x=1683743175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gegmea1yrJx+NuHvsp1BE4+R/pRBiovxk6jSZUU52wo=;
        b=Fi03O5Y12ZKv3ORI8mzzQllH1PsEnuPu9BuSGZlFcK3tghBvHgkBnF1LtR8NG/BA6h
         yFRui9LdClYMSMdb74JzNhM6H8ZARhVz/GEsAiYsVRrB1bl1Hsp8gorgSXZ/7M8VUVs4
         mvFNHD5x2esh/25z/QkpC7faY7V2/XZRBRzL1HwaYADQk9nfywbtFPNj6N2SDp10OS5T
         tAkz9GVw5pX/DIQL3QeffCycmZgFKScPI7pKZ7H0VDDEkE/AB6I9BYqE/oP+HVrXc2PV
         /845qNJnz0HbEO9T+4LJkkrqZJ4AZLK4pLOS4jsvSZj0PWmsIZacS7Klse3IhdMnTjDF
         VJQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681151175; x=1683743175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gegmea1yrJx+NuHvsp1BE4+R/pRBiovxk6jSZUU52wo=;
        b=21auc+yEnps+H2yuAse63mX1InulzY1rT5KZPpwMdTWQeg19WzRsBnjUi3NzCqJazA
         9f9v8StgSKStnJRBccwcR91G7HcN5catH2n3amq8EbtyGhIpWBZ6+Buc7XglkUy5SEWK
         x++S6p7xltyhARnaI01L3ZMK6TePcmuL9gifc6v8mYxcxQUgb8aas13FC0RT8oXJ06TE
         YMo2FWYQ3/6PPKJADwqjTtJhWen/9/M1F/Rj189PyOh4jJRFn67Ad/bQM1MjeiLTyW4A
         vS6z7kGYr4AVdPj33Ebweqbtp/USJHUmkeCJD0ITPxg0fjXQ8u58yXQscwxQxn57+tZ1
         kt5w==
X-Gm-Message-State: AAQBX9fZ6f72Kdi/N8F23eOE2ItAIXl2m3m2i1lKjEDfImr/C5EWcCVc
	tQo6k3OmPzAA4dx+lDFtfc5zDw==
X-Google-Smtp-Source: AKy350azQu4IRw/f3W906MZt4XqO9rUMLCEkks9KR0PfoYMuoGtpQC+aTPRRJ+FJdFhyjTKMJr8uHQ==
X-Received: by 2002:a17:902:c1d3:b0:1a6:3785:dd6f with SMTP id c19-20020a170902c1d300b001a63785dd6fmr12344plc.13.1681151175111;
        Mon, 10 Apr 2023 11:26:15 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id e9-20020a62ee09000000b006259e883ee9sm8145849pfi.189.2023.04.10.11.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 11:26:14 -0700 (PDT)
Date: Mon, 10 Apr 2023 11:26:11 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: pbonzini@redhat.com, oupton@google.com, yuzenghui@huawei.com,
	dmatlack@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	qperret@google.com, catalin.marinas@arm.com, andrew.jones@linux.dev,
	seanjc@google.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH v6 11/12] KVM: arm64: Split huge pages during
 KVM_CLEAR_DIRTY_LOG
Message-ID: <ZDRUw+PF3CZ6hP2w@google.com>
References: <20230307034555.39733-1-ricarkol@google.com>
 <20230307034555.39733-12-ricarkol@google.com>
 <874jqq5djt.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jqq5djt.wl-maz@kernel.org>

On Sun, Mar 12, 2023 at 01:01:26PM +0000, Marc Zyngier wrote:
> On Tue, 07 Mar 2023 03:45:54 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > This is the arm64 counterpart of commit cb00a70bd4b7 ("KVM: x86/mmu:
> > Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG"),
> > which has the benefit of splitting the cost of splitting a memslot
> > across multiple ioctls.
> > 
> > Split huge pages on the range specified using KVM_CLEAR_DIRTY_LOG.
> > And do not split when enabling dirty logging if
> > KVM_DIRTY_LOG_INITIALLY_SET is set.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 910aea6bbd1e..d54223b5db97 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1089,8 +1089,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
> >   * @mask:	The mask of pages at offset 'gfn_offset' in this memory
> >   *		slot to enable dirty logging on
> >   *
> > - * Writes protect selected pages to enable dirty logging for them. Caller must
> > - * acquire kvm->mmu_lock.
> > + * Splits selected pages to PAGE_SIZE and then writes protect them to enable
> > + * dirty logging for them. Caller must acquire kvm->mmu_lock.
> 
> The code does things in the opposite order...

Fixed the comment.

> 
> >   */
> >  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >  		struct kvm_memory_slot *slot,
> > @@ -1103,6 +1103,13 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >  	lockdep_assert_held_write(&kvm->mmu_lock);
> >  
> >  	stage2_wp_range(&kvm->arch.mmu, start, end);
> > +
> > +	/*
> > +	 * If initially-all-set mode is not set, then huge-pages were already
> > +	 * split when enabling dirty logging: no need to do it again.
> > +	 */
> > +	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> 
> This contradicts the comment. Which one is correct?a

Changed the comment.

> 
> > +		kvm_mmu_split_huge_pages(kvm, start, end);
> >  }
> >  
> >  static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
> > @@ -1889,7 +1896,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >  		 * this when deleting, moving, disabling dirty logging, or
> >  		 * creating the memslot (a nop). Doing it for deletes makes
> >  		 * sure we don't leak memory, and there's no need to keep the
> > -		 * cache around for any of the other cases.
> > +		 * cache around for any of the other cases. Keeping the cache
> > +		 * is useful for successive KVM_CLEAR_DIRTY_LOG calls, which is
> > +		 * not handled in this function.
> 
> Where is it handled then?

This last sentence doesn't make much sense, so I removed it. CLEAR calls
don't even go through this function.

> 
> >  		 */
> >  		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
> >  	}
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
