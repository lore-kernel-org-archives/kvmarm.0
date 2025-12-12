Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9BE1C84B8
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 16:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765556141; cv=none; b=MNlPkf5Lw4b9TDuAjjAoGpgTdfX6QVtyNT7BrGm96X4P2R8LUR8tG53XyyZnCTiHY5hS2UgQwNQw3Gg+w6TFxm3ogpiXm2oUKWOp3rQJceejkBJqyyIeJOPksf+9YnNobo0hBv/FqQDqxarLjC2+xJRJkDRu9EjV8ZDCSrmsUB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765556141; c=relaxed/simple;
	bh=QpUarcAdLSnbqTnWNlECIfVH11gk7hWE6QE7JXi1JQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/zTN9y1N2nRTkk4JFF8spApvew9qCkeGsvhBjIxY2uFnguyJgCG5JHox6+cjumIe7zKT0e5TfLfYyBXciJiaTwWRiYB1o6zP9sRcNTpf9qftomvTJgSmwK7K1aRBm+5d0TPN3vXNiwDZ+JlWERS+0lV/XIuf3Bil4rFPwzCB6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PlvjOTHt; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PlvjOTHt"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47a815c43baso134875e9.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 08:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765556138; x=1766160938; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=frjawGCw0cne3ietsxce3al/KlU0ywLGbRoWqjDTmUo=;
        b=PlvjOTHtaMBXArJLqTmJHiI+ujgGBKYEwkWDroji64H6/14a9eLxkGSBpbfV8knvIY
         mvw9FDhjEwKJs2R7+iRH/SI8mk7JYTEH4IFRVqzLQ4gpspX87RYPrM03ji/mKjWfrxe6
         g7wU819PLvTC46qMWiCOLT6P+275Mojgz1KEu4bLCXL5jNoHzylp2cNC+HYqLRKSpyby
         GS+pKbOfNyGMpkA9EegAbkn2f7QB4MfE8z4MHGDCblO2jqnsNPgcePLhZoyk0kga9DNe
         4cGWzkLksUpMlyKMnVzgrNIhmKVfq1q+9jSf+kba2kFhVDsA4V/wCleVp//genRfo8B7
         Dl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765556138; x=1766160938;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=frjawGCw0cne3ietsxce3al/KlU0ywLGbRoWqjDTmUo=;
        b=JROUhkqVbVc1DY89pskr1+GBYMag9KZECJfoak7tEhhN2WxvXPrB9RdxqZHXB2RkRA
         3BzYsTJ6ZtQbL857pAQa8F85zij9h0aj3W9Bt5uCOLqLWSqpX+Wt/Tk48TiqTSWk6Lxc
         kfd7+xuGktmcoPSv5dIX7NEDTi7myTWkhWyxVaV1/BBvS+LzoHB6K9a3rPofkGEnYO5V
         ikh40+Z+u3HQr+yr1NawFmh6YZHWVlmse/k7s18UnQDMBvUByQV8J9OkxbiDoWrh68jm
         hPXF2lVULEHY9BwiJ0AuFilFs5tDJoEh/zlkYcwIwcAkvBePb5jRFtXqf87+OnR/Frzj
         7taw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ4m/XZ+QiheFuj3DGqBEzMbWLcs/BgCcLSVwUDde5gTBqjjq400IvV1uY6T/SStHzflEd9Ts=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNTN0Qa9JcZLd076AOdd36eIIO7Xjv4GjWP3r/wWoOlSC2TNEo
	IIMfFNNmTWtdAp6/rFCtGB7WLxKLH+H3P0mezFS79p5/1IFZfS1bMqvzFapgFPFxmA==
X-Gm-Gg: AY/fxX5+I8GuUWurYDCV+Adf8NXlmuMbkKOWGl0J2MjjzelT1wlxvCpI6cafRWiNXyS
	5o0qRYKMjO7xfU+e/ALfSDRBSLCc7mt26KLEzltGn78vxtuSht/kbEK/n6h/JZQOT/mv39FLU9l
	JUUZAOyJh/aaVFZl7GYdMnvLpN/PUbU3pd3I6nxO3jlNMNjuykaN1vc6U5JVFN/LSKjPH8WTooI
	vCzPpU7Z3aJO5Gl0M5ZW4OooWUtJMy0C3aZ2cdxP9TgV0VRwaq9RdKREXZtWuke2/FCGQo3CkiT
	fk27IlCb+KvJmggAWxWAkx7w2wQfBoflQUcofkvpnUKJkgYJqwoJRjiq/Jkd17XCJ4oQXqr4nhY
	LV4kImHnjWgeGDNbErnzsWdxu8c14Xqr0L9SMyMtfWAbo1y5KxSbFZA5nZeWobhe/GIKO7nZo3R
	XQrvwF04PeoBrLhxm8wpIHZnMQK7YsRjiPZbvj0cj+3GTlMZubgg==
X-Google-Smtp-Source: AGHT+IFLv4OTi7EK70u2qvgXNHw6cjKhs3ugO63ipp+5tWwT+3KODquOARuyX6zUO1as6i35ut2QZg==
X-Received: by 2002:a05:600c:4a2a:b0:477:95a8:3805 with SMTP id 5b1f17b1804b1-47a8982139emr984895e9.15.1765556137476;
        Fri, 12 Dec 2025 08:15:37 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f3352a0sm14417635e9.0.2025.12.12.08.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 08:15:36 -0800 (PST)
Date: Fri, 12 Dec 2025 16:15:33 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com
Subject: Re: [PATCH v5 27/27] iommu/arm-smmu-v3-kvm: Enable nesting
Message-ID: <aTw_pZ7ZyhwFW7-3@google.com>
References: <20251117184815.1027271-1-smostafa@google.com>
 <20251117184815.1027271-28-smostafa@google.com>
 <20251128171252.GF812105@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128171252.GF812105@ziepe.ca>

On Fri, Nov 28, 2025 at 01:12:52PM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 17, 2025 at 06:48:14PM +0000, Mostafa Saleh wrote:
> > @@ -441,8 +490,32 @@ static void smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool
> >  		hyp_ste_ptr = smmu_get_ste_ptr(smmu, sid, hyp_ste_base);
> >  	}
> >  
> > -	smmu_copy_from_host(smmu, hyp_ste_ptr->data, host_ste_ptr->data,
> > +	smmu_copy_from_host(smmu, target.data, host_ste_ptr->data,
> >  			    STRTAB_STE_DWORDS << 3);
> > +	/*
> > +	 * Typically, STE update is done as the following
> > +	 * 1- Write last 7 dwords, while STE is invalid
> > +	 * 2- CFGI
> > +	 * 3- Write first dword, making STE valid
> > +	 * 4- CFGI
> > +	 * As the SMMU MUST at least load 64 bits atomically
> > +	 * that gurantees that there is no race between writing
> > +	 * the STE and the CFGI where the SMMU observes parts
> > +	 * of the STE.
> > +	 * In the shadow we update the STE to enable nested translation,
> > +	 * which requires updating first 4 dwords.
> > +	 * That is only done if the STE is valid and not in abort.
> > +	 * Which means it happens at step 4)
> > +	 * So we need to also write the last 7 dwords and send CFGI
> > +	 * before writing the first dword.
> > +	 * There is no need for last CFGI as it's done next.
> > +	 */
> 
> This really should share the main driver logic to do STE writes in the
> right order and try to avoid making it non-valid if not necessary.
> 
> This will not properly support all the real-world kernel flows around
> PASID with such a simplistic implementation.
> 
>

I see, would it be OK to keep it as this simple now and add this later,
as this is still early support? as I want to keep this series minimal.

I plan to have another seires with some improvements and optimizations,
mostly about page tables (using block mappings) and I can include such
optimization, specially that the new hitless STE stuff is relatively
recent in the main driver.

Thanks,
Mostafa

> Json
