Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E8E10941
	for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 10:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u1aAhIVq"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-507c91582fdso6193699e87.2
        for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 03:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698662855; x=1699267655; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0jFvZ6/5AIaJJURA6NKcXW3eA3V6KUe/I3Cr+Qqfk1M=;
        b=u1aAhIVqlKDqeNgzVWlBiLEDBz6breY0Q87c+ZBxHTgOLJmwmfclcTtMGYN2tzFEGU
         uYLTC3X2aBhj3+JQB3OLAbtmZTqtHUho0GHDrmttbRoV4BTGu7nER73fP8/n9ROwaa7P
         DrvDqCNkIvWq3VQNsOGQ5fOECvcMqru96wv9vUo7pfrn94jQZuUte1uaMDr/YoSqAO7g
         5gsyRKngEJT0xPdc7d7/jAf63KoxuiR95aR/6cPStXTL9myHI3nz5OvXqYkmQHNEurd0
         1QGqyIw8tIc54+CsJ4UrrCaozfkh3JIJift+wquNB7NUtoRCg6X/WDeVH4JQVuMCshPM
         6MmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698662855; x=1699267655;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jFvZ6/5AIaJJURA6NKcXW3eA3V6KUe/I3Cr+Qqfk1M=;
        b=pRgi2ym5k/9dfOUIcm+STlnwdXdmghH+7Q0JkSfuxt6jKkw6EkiCRqQz+5E2wzZPuG
         8e8ADnBALu80Y0j3u3l1puXfhcxQx8MAK7lP8wxnM48Rk4zhz7PH46DcQi05ieIj6SvA
         HNTXkqmyWtbhTf/lGHqun9PHPD97OuKijxaQaWWYbZDS3v1PddQFPocWue5/WB4jmgf6
         RdFkPB2WJyRORyNPk7QxqbieJ/cfdsFwiaJQ45ZwbfT02Aa9keSckJreHOKuRobenMQi
         Q7IB05jGJbPpfGAQQrXIuSmDrY3+cDPBbmvWiYyVLViNi4q5RUuWbGtfC/yOFH4k0OCU
         bOWA==
X-Gm-Message-State: AOJu0YyJ0mQfhpEgXK+NKHvoRE0TqiPPzUNJ24ov13EvEujQY1GO1SRL
	eDDt4y+MMFayh4Sl/s6Gr9j6Tg==
X-Google-Smtp-Source: AGHT+IG4PwoQ4g30QKx2f/phGUdXG3+a48bnZhR5V4c2L5H4rLoYMERK+oqqlKTGJFNxNRTfoquHMw==
X-Received: by 2002:a19:e057:0:b0:4ff:7f7f:22e7 with SMTP id g23-20020a19e057000000b004ff7f7f22e7mr6542787lfj.17.1698662855339;
        Mon, 30 Oct 2023 03:47:35 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id j12-20020adfe50c000000b0032de6f95fb3sm7946156wrm.40.2023.10.30.03.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 03:47:35 -0700 (PDT)
Date: Mon, 30 Oct 2023 10:47:31 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
	will@kernel.org, willy@infradead.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: Use folio for THP adjustment
Message-ID: <ZT-Jw4SVJ6C1E6sc@google.com>
References: <20230928173205.2826598-1-vdonnefort@google.com>
 <20230928173205.2826598-3-vdonnefort@google.com>
 <418313c5-2094-4aaf-ae43-a1f3bf8e936f@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <418313c5-2094-4aaf-ae43-a1f3bf8e936f@arm.com>

[...]

> >  static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
> >  	.zalloc_page		= stage2_memcache_zalloc_page,
> >  	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
> > @@ -1274,7 +1229,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
> >   *
> >   * Returns the size of the mapping.
> >   */
> > -static long
> > +static unsigned long
> >  transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
> >  			    unsigned long hva, kvm_pfn_t *pfnp,
> >  			    phys_addr_t *ipap)
> > @@ -1287,10 +1242,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
> >  	 * block map is contained within the memslot.
> >  	 */
> >  	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> > -		int sz = get_user_mapping_size(kvm, hva);
> > -
> > -		if (sz < 0)
> > -			return sz;
> > +		size_t sz = folio_size(pfn_folio(pfn));
> 
> Hi,
> 
> Sorry this is an extremely late reply - I just noticed this because Marc
> mentioned it in another thread.
> 
> This doesn't look quite right to me; just because you have a folio of a given
> size, that doesn't mean the whole thing is mapped into this particular address
> space. For example, you could have a (PMD-sized) THP that gets partially
> munmapped - the folio is still PMD-sized but only some of it is mapped and
> should be accessible to the process. Or you could have a large file-backed folio
> (from a filesystem that supports large folios - e.g. XFS) but the application
> only mapped part of the file.

I thought originally this would break the block and the folio with it, but a
quick expriment showed it's not the case.

> 
> Perhaps I've misunderstood and those edge cases can't happen here for some reason?

And fault_supports_stage2_huge_mapping() would probably not be enough. we might
end-up with a portion unmapped at stage-1 but mapped at stage-2. :-( 

> 
> Thanks,
> Ryan
> 
> 
