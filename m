Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092C71607B4
	for <kvmarm@lists.linux.dev>; Mon, 19 Aug 2024 10:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724063308; cv=none; b=h+JDj1NIPImku/DdV/4w/SnsjA28f5F8wrRRoptY7hORF4dOtBZWcdNQPyHtUxtIm+pHtLOcXsuvG/N6cCT5qlXDVlq4LrSIuKPBJHh0exT+fJgsA1thopaeCOTyEsKPFxbyI+YXfdgek6BlmmNifGVE0Hxb7DDQvzWbccQNkP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724063308; c=relaxed/simple;
	bh=+h8HIi/gend96fRCd9l2WJq86aZzGE94/3TDyV88XYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQzOv9YAVocXkueld/G0v1AGuhGsNJPzcVl50O62r+W9B6OLU3KB68Ysf3lr8wKOFZxhPDLqG2o0eTr6i5txC/UW0U8qBjHEMB2EnRZONkMokSaCgZjMMJC5nj9b+eb3pElKrdQnj6XK/jMr17SKrhr9+neC/kQVYVfCMRz/2fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4gr7OPrZ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4gr7OPrZ"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-371aa511609so1144529f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 19 Aug 2024 03:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724063305; x=1724668105; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HCnYXKbPejxZx0vHdL+PDYgS0GrW5E1HoGp5p5wjmA8=;
        b=4gr7OPrZC0gUoLtwnrh1eGulU9NC1/qtDHJiS6zpzSFWkDeJ0Ni76NAddMT8aKocUQ
         ouUyjFYBQ7nbIuSM0thzPBLuHGc3xPVIaEpEfiSxC8GYwARVigNdz6nbiXFND9z/7hsI
         WU/jn7sHvfLsinz9Ywl+VdKNS/E/fL8lhK7FrZHigeZB2vq60CR0ZkMMCAxBNbL2Ivlt
         D2t+eOnh80gvQ/7vBhiFFyAvuOVpVWoNvXKD0v2BtHxwDsZIX6lMiYxP8S3jSUXx2inh
         hTlBig3flnTfgJykB1PvNJU5zXLrjsqpSqDbY3vpFdC9w2rZJV6AAR3PaWVJH4Ai8OxP
         qa0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724063305; x=1724668105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HCnYXKbPejxZx0vHdL+PDYgS0GrW5E1HoGp5p5wjmA8=;
        b=wYCIAMnAJzLPazVTCYneNfpUVMinuohH+wrHO+6p5GkI4SjhYpeRc/bN4z25AV2nGJ
         ab9zDtsAN+jlGhz/xoaxoLKz4Ti//5X3YOVbSV9gu/6J+pq03AW6qe+NZz4lgtX6gO85
         kF8J1LnfdRc1bHgU2ncOvKSwee7BmuyPrYsgLqYPjHnXg5F8KXhFeOz4tv1qV4u7N7ct
         qqPb+0D6TrI7HtjNtVe/0XXVsSVcmcdb7yXe6S+aa0MZpT03Z1KAC2VdwYAuGI4hNcg2
         3305eM8t7gEiQtYNP6j0NBTqXgKlJxYptV+dcx1e4O1MAgKrnSv+Pes01UOgCVzATTle
         0Xjg==
X-Forwarded-Encrypted: i=1; AJvYcCXpQPD67yExDk0KrFm6Le3MFhntZv5afsBJFvKm1Ba4aiLUHyxr68Dabg34hzWTQhJAqzrnBuTYIHod+GPwPwrzWwr69fC3
X-Gm-Message-State: AOJu0Yz7Kv15q/QHOMlqbalhhn39tpemMyhePrck3mvaPpVzv9T228NC
	oZ+umXTktD6tjxzy49yjJLpx1m/X5xNS3OEFAdnvRBN/29TUvkkQIPAYTl6fvg==
X-Google-Smtp-Source: AGHT+IH29AZnz1h0T1T38pt3izR9PAR4PDYKW5YJTXZhxJwmI5d0SQZeuuiLw0/+rgopZIybK6w00Q==
X-Received: by 2002:adf:a35d:0:b0:368:319c:9a77 with SMTP id ffacd0b85a97d-371946535f5mr5589469f8f.29.1724063305033;
        Mon, 19 Aug 2024 03:28:25 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-371898498e1sm10186667f8f.41.2024.08.19.03.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 03:28:24 -0700 (PDT)
Date: Mon, 19 Aug 2024 11:28:19 +0100
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
Subject: Re: [PATCH v8 5/6] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <ZsMeQ8nAZLDhsBmA@google.com>
References: <20240816123906.3683425-1-sebastianene@google.com>
 <20240816123906.3683425-6-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816123906.3683425-6-sebastianene@google.com>


[...]

> +static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
> +{
> +	static const char * const level_names[] = {"PGD", "PUD", "PMD", "PTE"};
> +	u32 i = 0;
> +	u64 mask = 0;
> +
> +	if (start_lvl > 2) {
> +		pr_err("invalid start_lvl %u\n", start_lvl);
> +		return -EINVAL;
> +	}

It looks like a duplicate of the if below.

> +
> +	if (WARN_ON_ONCE(start_lvl >= KVM_PGTABLE_LAST_LEVEL))
> +		return -EINVAL;
> +
> +	for (i = 0; i < ARRAY_SIZE(stage2_pte_bits); i++)
> +		mask |= stage2_pte_bits[i].mask;
> +
> +	for (i = start_lvl; i < KVM_PGTABLE_MAX_LEVELS; i++) {
> +		strscpy(level[i].name, level_names[i], sizeof(level[i].name));
> +
> +		level[i].num	= ARRAY_SIZE(stage2_pte_bits);
> +		level[i].bits	= stage2_pte_bits;
> +		level[i].mask	= mask;
> +	}
> +
> +	if (start_lvl > 0)
> +		strscpy(level[start_lvl].name, "PGD", sizeof(level[start_lvl].name));
> +
> +	return 0;
> +}
> +
> +static struct kvm_ptdump_guest_state
> +*kvm_ptdump_parser_init(struct kvm *kvm)

nit: I guess it's more a "create" than an "init" as we allocate the memory.

> +{
> +	struct kvm_ptdump_guest_state *st;
> +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> +	struct kvm_pgtable *pgtable = mmu->pgt;
> +	int ret;
> +
> +	st = kzalloc(sizeof(struct kvm_ptdump_guest_state), GFP_KERNEL_ACCOUNT);
> +	if (!st)
> +		return NULL;

return ERR_PTR(-ENOMEM); ?

> +
> +	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
> +	if (ret) {
> +		kfree(st);
> +		return ERR_PTR(ret);
> +	}
> +
> +	st->ipa_marker[0].name		= "Guest IPA";
> +	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
> +	st->range[0].end		= BIT(pgtable->ia_bits);
> +
> +	st->kvm				= kvm;
> +	st->parser_state = (struct ptdump_pg_state) {
> +		.marker		= &st->ipa_marker[0],
> +		.level		= -1,
> +		.pg_level	= &st->level[0],
> +		.ptdump.range	= &st->range[0],
> +	};
> +
> +	return st;
> +}
> +

[...]
