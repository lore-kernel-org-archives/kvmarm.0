Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BF58835
	for <kvmarm@lists.linux.dev>; Wed,  1 Mar 2023 20:10:46 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id u5so11852505plq.7
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 12:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rN8abvDcV5GsYYafJC+S1EERF45eL84JoIpdxecRuYs=;
        b=s0d1TdpOcrkpwZTXxew9tjgl6JiFa2y9h9rkcNyoBHubX7KNY7tCQFQCKZ3qzbuQxY
         OZBzg8RdOllTC1vZ3otW3JxQNaQmXE2vX7uaKk2yVJYMrzc2gj7eL/NDTFLrvz8ZYLb5
         G62bDd7dI7WSN3BFicBfAjXQ4sj2BKugVVYZsu6yXriUIm51qgjDSIBY7Cn+L5vHM4IL
         mF+Q8JlusgA5gRSVbVRH+mt6cWiwisQHk2bJUeI5rM+FpQN4xo2rCP3TzTja3uFjU8M4
         M8bLIxbCf5Bq5u5XIqJCk/Os5TUrhIMMP2ngzLTCqec0D67uxHgbG9exIYR3vTV71C6L
         hyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rN8abvDcV5GsYYafJC+S1EERF45eL84JoIpdxecRuYs=;
        b=lHoLQyqWIOH596Z+fTvMSZ79tITPnDSa0wBX5Dj6DHCWzBQnsUnpI3vknGN1Uzo6/x
         1hkvBK4tMio5uP12ZzuX6JaZDehlKtzGBovH+76EL7NVi4m47poCHjO9TFBLACI4JVDn
         HdfFO3JeG/bah3WFyJjEOzE54vJDxVrGUjWe7+FHEClfI1WL3zHD8vTFFIMd8GP/E2Y6
         06xwkDSmsRfiYCZtlKiytcPAMnGDA+Qv8XFbSOi4JeXg35XNujbilH7NfJNky7IFiPVt
         28HU02DTqvGdR+QRyLD91in8x/ZFZQbzwYrXc9UpwuEw4keejZ8NRCaBii7FXrxCw3NR
         St7Q==
X-Gm-Message-State: AO0yUKVi5J555zq+6CcL5M3sav8XHOfV+T7T3VTihdQSI+jzokJ6Vt11
	MpqGsa0Z1dwmC5u1e5W9c4cJ4Q==
X-Google-Smtp-Source: AK7set9hHt/VgPzr7hloURb8t3YPAtUhN3+d2AS57/RrcK0tqXPu0gnqnzpkibcTuTsonMXKW/xchA==
X-Received: by 2002:a17:903:746:b0:19c:d96b:b904 with SMTP id kl6-20020a170903074600b0019cd96bb904mr26367plb.3.1677701446263;
        Wed, 01 Mar 2023 12:10:46 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id jh20-20020a170903329400b0019ccded6a46sm8824224plb.228.2023.03.01.12.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 12:10:45 -0800 (PST)
Date: Wed, 1 Mar 2023 12:10:42 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
	reijiw@google.com, rananta@google.com, bgardon@google.com,
	ricarkol@gmail.com
Subject: Re: [PATCH v4 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
Message-ID: <Y/+xQjqzXStIiBmO@google.com>
References: <20230218032314.635829-1-ricarkol@google.com>
 <20230218032314.635829-4-ricarkol@google.com>
 <e62b4495-3e99-d3da-8fc3-e40246ccb498@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e62b4495-3e99-d3da-8fc3-e40246ccb498@redhat.com>

On Mon, Feb 20, 2023 at 02:35:46PM +0800, Shaoqin Huang wrote:
> Hi Ricardo,
> 
> On 2/18/23 11:23, Ricardo Koller wrote:
> > Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
> > creating unlinked tables (which is the opposite of
> > kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
> > useful for splitting PMD and PUD blocks into subtrees of PAGE_SIZE
> > PTEs.  For example, a PUD can be split into PAGE_SIZE PTEs by first
> > creating a fully populated tree, and then use it to replace the PUD in
> > a single step.  This will be used in a subsequent commit for eager
> > huge-page splitting (a dirty-logging optimization).
> > 
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h | 28 +++++++++++++++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 46 ++++++++++++++++++++++++++++
> >   2 files changed, 74 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index dcd3aafd3e6c..b8cde914cca9 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -460,6 +460,34 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >    */
> >   void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> > +/**
> > + * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @phys:	Physical address of the memory to map.
> > + * @level:	Starting level of the stage-2 paging structure to be created.
> > + * @prot:	Permissions and attributes for the mapping.
> > + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> > + *		page-table pages.
> > + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> > + *
> > + * Create an unlinked page-table tree under @new. If @force_pte is
> The @new parameter has been deleted, you should update the comments too.
> 
> Thanks,
> Shaoqin
>

Right. Sending a v5 in a bit.

Thanks,
Ricardo
