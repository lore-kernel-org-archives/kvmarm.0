Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C891628
	for <kvmarm@lists.linux.dev>; Fri, 13 Jan 2023 03:44:47 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso23159399pjf.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 19:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4oRV9JDfOgkyA//zYsWLGmWXmqofSnQQ80rC6HMhzw=;
        b=qC7eHjKK0+1rkgrY4flbpuQ2Gn3x8fT9r2804GDecvxWkSjplomS1Amjqvhi0j+XyS
         VfLZxQmWc9rVqLALMFTeeczwxFjywNYRToV7d53Q7MtMtaHg7Y/9LdmRdV4BCWweDxXE
         idqsH31ct5JJF9PVDxA9G7ybandl+Jif01yGsC9DlBcYx0vcnv9Obqv1NOLsMK4UylL9
         WMRuqTLQNMN2anFK/bg+wBKxIbWC27TXq/KrtQctdJTZWFjp+Na3Wc02TUyjcVqykFxl
         rsVTMYraMTbpXb6kb/o+Eu0URzr7LJ5fhBeApCcluVzxN6cwHiIx8YxD+sj/bK7ntsZT
         TnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4oRV9JDfOgkyA//zYsWLGmWXmqofSnQQ80rC6HMhzw=;
        b=vt3v0NJtdDvIJ7YCyxhygNnG3BPY+MRO3X6K1fdZhniRqg/GRuG1IFgJUT9qIU7IAy
         kHBrEh72M22opgyPUPfzZwRxQak8XIE7oYSj3OksUNGVRuFt5f6R19JmFFYRaWC2yR4X
         /nmV7gOUBbMbSRQMHl0ezVC44KGagGQ4Jp8rx408rFs1yxxl2CSdPwLaZc/bBJxCiunW
         EXCIpxeKRW3TexS7sdN906+iu/9ExKPIx1Ua+PALu/8Bz+lksjIQVW1XvQOUVpEddfdo
         rHV0dSbTzpgCpV2bJr2jrYiyMy7c2b3eqmgE4FFQRkaMMQGWynQCmtRf2JrHXAGWv0Sa
         92Gg==
X-Gm-Message-State: AFqh2kr3XfcbON8hJECI/GLb+VRXceJ61cbupqQllPXlC+HYKcAXYfb/
	5YFy68504nTxPgHeNjUkeeumfA==
X-Google-Smtp-Source: AMrXdXuAnFXhZM0FTFiqIljYeLNe5lkdqTnd84rfecdRSjYAQv64CfFah2yZZMqjqdoBRgxybGH9Iw==
X-Received: by 2002:a17:902:c189:b0:191:1543:6b2f with SMTP id d9-20020a170902c18900b0019115436b2fmr1315193pld.3.1673581486910;
        Thu, 12 Jan 2023 19:44:46 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090311c600b00186985198a4sm12961654plh.169.2023.01.12.19.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 19:44:46 -0800 (PST)
Date: Thu, 12 Jan 2023 19:44:43 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
	qperret@google.com, catalin.marinas@arm.com, andrew.jones@linux.dev,
	seanjc@google.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	ricarkol@gmail.com
Subject: Re: [RFC PATCH 02/12] KVM: arm64: Allow visiting block PTEs in
 post-order
Message-ID: <Y8DTqxdY/h4f0q4a@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-3-ricarkol@google.com>
 <Y3KNZCLVqnFeg7hi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3KNZCLVqnFeg7hi@google.com>

On Mon, Nov 14, 2022 at 06:48:04PM +0000, Oliver Upton wrote:
> On Sat, Nov 12, 2022 at 08:17:04AM +0000, Ricardo Koller wrote:
> > The page table walker does not visit block PTEs in post-order. But there
> > are some cases where doing so would be beneficial, for example: breaking a
> > 1G block PTE into a full tree in post-order avoids visiting the new tree.
> > 
> > Allow post order visits of block PTEs. This will be used in a subsequent
> > commit for eagerly breaking huge pages.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  4 ++--
> >  arch/arm64/kvm/hyp/nvhe/setup.c      |  2 +-
> >  arch/arm64/kvm/hyp/pgtable.c         | 25 ++++++++++++-------------
> >  3 files changed, 15 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index e2edeed462e8..d2e4a5032146 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -255,7 +255,7 @@ struct kvm_pgtable {
> >   *					entries.
> >   * @KVM_PGTABLE_WALK_TABLE_PRE:		Visit table entries before their
> >   *					children.
> > - * @KVM_PGTABLE_WALK_TABLE_POST:	Visit table entries after their
> > + * @KVM_PGTABLE_WALK_POST:		Visit leaf or table entries after their
> >   *					children.
> 
> It is not immediately obvious from this change alone that promoting the
> post-order traversal of every walker to cover leaf + table PTEs is safe.
> 
> Have you considered using a flag for just leaf post-order visits?
> 

Not using this commit in v1. There's no (noticeable) perf benefit from
avoiding visiting the new split tree.

Thanks,
Ricardo

> --
> Thanks,
> Oliver
