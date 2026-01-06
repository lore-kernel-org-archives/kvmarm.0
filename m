Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67493242AC
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767712823; cv=none; b=BmIuPF6mjBdO3RtvwHtdfPnPgE49CwdtpWs4/vSos2/090CjOVanxKuZ+/ZVKrwsMPBfhDP+ulXJBc8FOT3KJ0HMBUP6EKJxJjN5mUuGwAl91dR0QT0cbY9x5crQ9gWaFTCdp02T3CeQaruu1wbMW7mQdv3zdhQvaE1Zu29Q5A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767712823; c=relaxed/simple;
	bh=zwNsM+4baDu5It2rYpq8PSWl605ZzF7pur8iLkFoYFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjLer4UlubMtq8MstcDOQVLFEqK6eVAmnmEUuxBbOlNGczdeoJ3W6UgB+CFDqe34vYBzNmyyIxfMpqq8Y19aYxv/nu78hUaAGkoEuTVe+im0Bx99yWT1UXxAkk1QIzLM93VvvqanjXSYhY40rIINb/gwWKCITbYTAAvoFoORwWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bSvf6JtY; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bSvf6JtY"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-37d056f5703so8983151fa.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 07:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767712820; x=1768317620; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Id7mMU47XER2g8M01+ksD3/e3xj34gH+ioyx6b+UIXs=;
        b=bSvf6JtYOZczbsSN7kxxQcNtlrfng4zqZrfcMkQ6z1XTelDhPDzVzCbf21qpuDN8ia
         +STisN23UnnLeIDqrJ0NEzEGg5znb4TUcf5Bpg4s1Q7E8qBP5Za1BMkN3swuzDg+wmUu
         vXsdSGA8TUeWEgo/BXk9ruNy/MazMmKSJDa+vdIrXI20+uc+fE73RVZ0xWtjLmUebxCb
         WMa4OFnkbSSAY7KuJxsxLE0QaLD87hflYoTgJlBSHpw51B0nVCCXFJa4YisII03bRdY6
         ZQ6eOZyY0qinxYeNv3gbRhSUzYWGkgFlFHObUN4FyabrjnEj0Uk0QyOOoDUenxPwwRXI
         JtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767712820; x=1768317620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Id7mMU47XER2g8M01+ksD3/e3xj34gH+ioyx6b+UIXs=;
        b=hmCOxb1Zr2eVGuebdxm9KCbeSl7yU6++hJyj1+lJDRrKmt0E9G6xRSPBuwIC6n5NOn
         ESYTFfGuKckO6kW0Hzjc12IZrNUKzI54YjbQHFi2hfrzGrjGA3FHggCFxLl1GNe9fctE
         HyGIegZYti3axhu6htWGBLy8dRpVCet6YAsbm1mkA4ZiN/7Sqip3mtdI4lMiUAE/YQy3
         6YnpNqNcIKYH5vY43JRtWYD/bUGpuyGhhGEpWHta6nStQAQQMiu+sYsLUszuvtEED0bk
         UpJVmISz3OsympGmAZ/K2NqsmQJu07pCw3hhhN1XHdoJYFkGalhnBBZnv13kyw02EgT5
         QNeQ==
X-Gm-Message-State: AOJu0Yytmv77gsB7pRt1x/9oXAj0J0PIBJ/I7mlmg9zeJhDFANdpZxMO
	NBPh+lactlGOKq+RnU95HuwS7r5bXrCcslz+baCQwfyxioAWIfDEIjDfk5p3hDkywt5L2GBONOu
	D9/5djw==
X-Gm-Gg: AY/fxX6p6qXY8OgTFixrhO33UkYnSIUG1SfaSS0GZNJd9avYYYG8Ay1xCo59CDJ76lb
	EYC3cUtdjlGBw9TeY4JIUxiKWvSLXXGpbidQ2wLSjvm3rVEbKji5Zo+8Y/nD8f+JYcw0yOor5zd
	YKXN3ByAZ7d3ScWh6ipa58DN/CTi7dcGg/UPbOb1yialZ/k593Z1MBdVRv9HPHL+iHnSooFITUn
	nnzh7t3FEtYYU4wOBPYi+QnicvtwVXT5kngSMMqrIcwugovjCQ1Kt++s4DRZuZk0qEZHcw7X8d7
	9o0T17LKuogsu15t/UnldfgAzjqgNabus63DF6zQQLuOoAxbVzSTG1SB07xg5rEHqJPSeePkhNm
	q9ezZelLXouZ/74QPNmchKheMOq1dxBNRMHUUzYk76sKtwc3zA7fb5fr7eFaexkNn0IDwJBBEvJ
	5CNyvrVs3o862am/WSuMZplIercpWiEDBnF0GS3B9bOL/hlzUB
X-Google-Smtp-Source: AGHT+IFU9XgMuYZOygAp7IsVsq2f35QvR9jvRwZzMLfy3bby4dhwHBGD9DFQoSjkX9BMOAy+TSw0oA==
X-Received: by 2002:a2e:a10d:0:b0:36b:b0eb:9d64 with SMTP id 38308e7fff4ca-382eaac9251mr8967191fa.30.1767712819609;
        Tue, 06 Jan 2026 07:20:19 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-382fc17b990sm716001fa.40.2026.01.06.07.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:20:19 -0800 (PST)
Date: Tue, 6 Jan 2026 15:20:15 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 17/30] KVM: arm64: Generalise
 kvm_pgtable_stage2_set_owner()
Message-ID: <rm55zbvakwmh5ny25bosf3jjiehfubcm2st5q4porsmnffuod5@edygmhqq2ckn>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-18-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-18-will@kernel.org>

On Monday 05 Jan 2026 at 15:49:25 (+0000), Will Deacon wrote:
>  /**
> - * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
> - *				    track ownership.
> + * kvm_pgtable_stage2_annotate() - Unmap and annotate pages in the IPA space
> + *				   to track ownership (and more).
>   * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
>   * @addr:	Base intermediate physical address to annotate.
>   * @size:	Size of the annotated range.
>   * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
>   *		page-table pages.
> - * @owner_id:	Unique identifier for the owner of the page.
> + * @annotation:	A 62-bit value that will be stored in the page tables.
> + *		@annotation[0] and @annotation[63] must be 0.
> + * 		@annotation[62:1] is stored in the page tables.
>   *
>   * By default, all page-tables are owned by identifier 0. This function can be
>   * used to mark portions of the IPA space as owned by other entities. When a
> @@ -673,8 +678,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   *
>   * Return: 0 on success, negative error code on failure.
>   */
> -int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> -				 void *mc, u8 owner_id);
> +int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +				void *mc, kvm_pte_t annotation);

While we're on this topic, perhaps we could go one step further and 'type'
the annotation itself? For instance have a 'type' and 'meta' parameter
directly at the kvm_pgatble_stage2_annotate() level instead of leaving
that up to the callers. This would allow to have one place to allocate
annotation 'types' (donated pages, locked PTE, MMIO guard, ...) and one
way to serialize/deserialize them. That 'type' would be stored in top 2
or 3 bits of the PTE for instance, and decoding of the 'meta' field would
be dependant on the type value. Thoughts?

Thanks,
Quentin
