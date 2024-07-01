Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E948289C
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 08:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719823372; cv=none; b=FVjMYeDeLLDAUrQ6PIEKT2b5v5wlxia2uU9WCu+7KlbfBicxhm6cX7a22tPSP/izHfZUnvUEpjZehKJl/5OxGeXHaOQLPgrUcQn8PzKtKEimtmZYxTVVok3toPL8if5H5n66DpjOd/QzNxuA+ad1Gz5oIJIJ012WNbnvSwTSc9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719823372; c=relaxed/simple;
	bh=cHDjUygFlHEkZ3a+qAPDtVYOmwRuT3EA86PTUwtLgpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OgF62GgNxxpeLUZdnUcq2X3h1JgW8FjDM9C8QotxZm7quzbYQkTXCju+Eh/jnj4HjDVeBcBE02ig+CDJrfphu+1KDExGGt4ICytzyFG/7LGKWm0q5WlHJzcdI/1Illyvqg1A5cYCul8dX2uS7TtV/jP9FElB4E+XBlHx0cZxwIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FGej1oo8; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FGej1oo8"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-424acfff613so24705735e9.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Jul 2024 01:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719823368; x=1720428168; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yEsoWTLxyHIlDQCb/ASp+ooXvx9TSwnTA36CC8StcRU=;
        b=FGej1oo8UAhovwKzpVNKhRzgWx3ceP44/sHCp79vRI/xg6rpGXrXK1BD8n3ysgVYfe
         Am3Pzs6p5vg2tCZb86zG0r/uPILQxuPZ9D8pkodb2K1uJPRN21wnj4sQHqtDcFtrEpDJ
         jZqPGKaxDVI/rZ93nosvPWZUdyV2Mj2gEytTEaj+2IktMkycWQ7g7/m8aDRpW7+O+iLj
         7D1utbChiyanOmQfekn0Rl/iHYOqJaj/dYw5iG0TQRfuUT+GLmtBFizhEgfKqXPxLAl0
         zPfl4BzgrAmMogJw8XUPaebrhIL1ksFfQkgq9Aui3bkg6eN9wiAEPOhLZB1JUGKZ2SW5
         uJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719823368; x=1720428168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEsoWTLxyHIlDQCb/ASp+ooXvx9TSwnTA36CC8StcRU=;
        b=CY9KUN8dg4nQ6Ds0+mr7YC3p4hqlbEyrrx13oYEYdQB3AhgCA4uVS8+zQUje4nCiKA
         HujBT4DWJO6LAzIgra3qiZveV4HfwfrGR2+EDfdFuQp3LRqWVu/iudDwb1PVjwjYylgl
         VWJcj9y35PWN7pauiUc4x1mDAlMyW6L6P/DwLhP0o5haZt5w3g3qAz44lLfNn4dgAv6x
         XIPDZAAWoXi2QJLTcPYc1uGw7G9Hj/fNBiJlcw51Y0rx6ZdLFv9PLhEdKL291WJl7D1k
         HCKcqA9Bf3cOVBOlGC9p6L3pOkxizIglwe7N9BP0XxWFdi+ySW2jAdPp8UjNnYvTkvAd
         y2TA==
X-Forwarded-Encrypted: i=1; AJvYcCWW10ZbTYGq4OqXpE3Is6Ts4AGgYDUNkvKm/p34wECZ6FlKqh2aRLSKmyIRwfesa8b+q9MeUT2ylLZskTo18831i2BP7lV1
X-Gm-Message-State: AOJu0YynoGC0vlvkGhtfcIcotq5J5Anmi+KEsMhoQ7CUzh/HlBSvLByh
	f/50WFpk1DuV0DkIKQYkCFkDrQw4k3Y0sowYIOk9gBuCNg846fT+9VXqxxovlQ==
X-Google-Smtp-Source: AGHT+IGawId0kUmiFiVE/6VBOwuMv0FSUu1ZKqIQ07gLRwDyzzNe0v1kfMUd7cCTWmMSeLhyZCJCRQ==
X-Received: by 2002:a05:6000:18a7:b0:367:4d9d:56a1 with SMTP id ffacd0b85a97d-3677572496bmr3944444f8f.45.1719823367880;
        Mon, 01 Jul 2024 01:42:47 -0700 (PDT)
Received: from google.com (247.165.79.34.bc.googleusercontent.com. [34.79.165.247])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3675a0cd778sm9536657f8f.5.2024.07.01.01.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 01:42:47 -0700 (PDT)
Date: Mon, 1 Jul 2024 09:42:43 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v7 5/6] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <ZoJsAyrmtge4mXJY@google.com>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-6-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621123230.1085265-6-sebastianene@google.com>

O Fri, Jun 21, 2024 at 12:32:29PM +0000, 'Sebastian Ene' via kernel-team wrote:
> Define a set of attributes used by the ptdump parser to display the
> properties of a guest memory region covered by a pagetable descriptor.
> Build a description of the pagetable levels and initialize the parser
> with this configuration.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/ptdump.c | 143 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 137 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index 36dc7662729f..cc1d4fdddc6e 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -14,6 +14,61 @@
>  #include <kvm_ptdump.h>
>  
>  
> +#define MARKERS_LEN		(2)
> +#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> +
> +struct kvm_ptdump_guest_state {
> +	struct kvm		*kvm;
> +	struct pg_state		parser_state;
> +	struct addr_marker	ipa_marker[MARKERS_LEN];
> +	struct pg_level		level[KVM_PGTABLE_MAX_LEVELS];
> +	struct ptdump_range	range[MARKERS_LEN];
> +};
> +
> +static const struct prot_bits stage2_pte_bits[] = {
> +	{
> +		.mask	= PTE_VALID,
> +		.val	= PTE_VALID,
> +		.set	= " ",
> +		.clear	= "F",
> +	}, {
> +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> +		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> +		.set	= "XN",
> +		.clear	= "  ",
> +	}, {
> +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> +		.set	= "R",
> +		.clear	= " ",
> +	}, {
> +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> +		.set	= "W",
> +		.clear	= " ",
> +	}, {
> +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> +		.set	= "AF",
> +		.clear	= "  ",
> +	}, {
> +		.mask	= PTE_NG,
> +		.val	= PTE_NG,
> +		.set	= "FnXS",
> +		.clear	= "  ",
> +	}, {
> +		.mask	= PTE_CONT | PTE_VALID,
> +		.val	= PTE_CONT | PTE_VALID,
> +		.set	= "CON",
> +		.clear	= "   ",
> +	}, {
> +		.mask	= PTE_TABLE_BIT,
>
> +		.val	= PTE_TABLE_BIT,
> +		.set	= "   ",
> +		.clear	= "BLK",
> +	},

When doing a kvm_pgtable_stage2_set_owner(), the walker will init a leaf which
has both the table-bit and the valid-bit unset. I believe this would lead to
spurious BLK annotations here.

The following should fix this problem:

  .mask		= PTE_TABLE_BIT | PTE_VALID,
  .val		= PTE_VALID,
  .set		= "BLK",
  .clear	= "   ",

> +};
> +
>  static int kvm_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
>  			      enum kvm_pgtable_walk_flags visit)
>  {
> @@ -40,15 +95,79 @@ static int kvm_ptdump_show_common(struct seq_file *m,
>  	return kvm_pgtable_walk(pgtable, 0, BIT(pgtable->ia_bits), &walker);
>  }
>

[...]
