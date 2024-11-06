Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB131201115
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 16:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730912345; cv=none; b=PWK+p9lQuYXdEoHUnt3KNsmqgtq1zlJN0ZYMy6FfuvS8TWbELMAH1bOtwv9krBAJ+D1TDqw4RNXJ2eX4KhSRrveHDjAfFmYvDJFaz7nPu1g7ZQKwDKoSSdlV1SAMeaFngXuclqxaRk76I+B7+vLfk/NyWvapRk48M8VwSHKAhXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730912345; c=relaxed/simple;
	bh=zz24KO1Xy7Ea1dfAlSGXrFBY4HRdXzwVaZck1Xoj2hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ayMSs9ypa80xZFuiPVutOG3M4IeYA61RFV4UD+rIqq8iesCxjBqyftNw8yqKxVhwjjlMXvDnfpMt5VmrSX1hOG8Pdi+7OTyxY/+WXrKBgC7yhemumbI6M3Bjm/lNujsWdn6IYa1jeXFBCcRJn8XmN7gwDQYZ7dYoBwb5DlY1cTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Nx+xBqD; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Nx+xBqD"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5cec7cde922so7110716a12.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Nov 2024 08:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730912342; x=1731517142; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T2Kg6GaH7gYTnb++jbY4MBBC4c65ettqYa6wLql3FJE=;
        b=1Nx+xBqDAmTmwH6/9Zjya+q+SSctjIqE21t4Ae/3HamEtpCROmSL5DKYvOw0gnMPfH
         Nyq6dNG0Gw9Ymj3eep9Vt/pybEznR+z8lHvv1Y5uhet0itttFz4rfseno4LKgP+Ubdc6
         GgrOn4ejPu74NjoI0kcDXrRC3c4tSXwq1suK6FY++OZ+MiVqy98RQYvh1TRSlmUW2Piu
         H5RM9fKCFJE5/DLFj7+tdH0o4IB8tMRMdBRGaGXtVKSvKVcIiyspzVWyPrVPsctU4AHz
         lae9L3DAB0+gMMtYXpU8493CecBBYUgwyP2g+cw6f6Xr4sQw20cH9UEqGIEIWW5SR+xq
         s/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730912342; x=1731517142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2Kg6GaH7gYTnb++jbY4MBBC4c65ettqYa6wLql3FJE=;
        b=iejcKT1YpnKVOK+zo69ollD9ujmNtm2GPegMvySUP3ujMaj6gNLXKG72yUN4TUGtKc
         uCN30hSWC2oUYPCMk5NOY39GvhA0H5ObKex2YMiBYybdPINabamLBkjm7fEEHVF61E0c
         H36kyLfzmmJ07TdH+0QtC0IDPbFIsZRSDMw8xPagQrX7gLB4flKJtgv2Jvr/nTLNJtAp
         AlDIFv62BAQxcNEo4veLGX5/VHfnheNzSLDp3zBQFtRtDKkmDMjFnkWI9lIUUjcIoknL
         jUj6fUM74KUjMpNt1uD8L9sLIW2s39L0KQ+enCDOA+8uLc2YpSwsIZSJkxlJ2/owaW5y
         gfgg==
X-Forwarded-Encrypted: i=1; AJvYcCWtITqhR68g0p4JmEjDBWcuYtVRXWaJI1lrckW8c7TdIQnwV+WHmzLvwmp+sDvKYj/jRqwdROE=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywi5Lr0V1SMpAeQDQydNFZw7EVkVHLWnuzBbvezl0y+cexONUQN
	5A+6XWIPm6g1mFGIBz9Z4QM6spdojbUFqN01nQu8R7p4UdgznsbStLenMYmhkw==
X-Google-Smtp-Source: AGHT+IGvdZ2IaD+BzOBp7O9t8aJG3Fn8CPmHBQZKasjV9H+9x/GBg968m+XOOjPPD2/pEN1skbtRkA==
X-Received: by 2002:a17:907:7f14:b0:a9a:6855:1820 with SMTP id a640c23a62f3a-a9e3a5a0357mr2809681466b.15.1730912342073;
        Wed, 06 Nov 2024 08:59:02 -0800 (PST)
Received: from google.com (40.162.204.35.bc.googleusercontent.com. [35.204.162.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb16a1440sm304413166b.31.2024.11.06.08.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 08:59:01 -0800 (PST)
Date: Wed, 6 Nov 2024 16:58:58 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] KVM: arm64: Introduce the EL1 pKVM MMU
Message-ID: <ZyugUvS5dMwXU5nW@google.com>
References: <20241104133204.85208-1-qperret@google.com>
 <20241104133204.85208-18-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104133204.85208-18-qperret@google.com>

On Monday 04 Nov 2024 at 13:32:03 (+0000), Quentin Perret wrote:
> +bool pkvm_pgtable_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold)
> +{
> +	pkvm_handle_t handle = pkvm_pgt_to_handle(pgt);
> +	struct pkvm_mapping *mapping;
> +	struct rb_node *tmp;
> +	bool young = false;
> +
> +	read_lock(&pgt->pkvm.mappings_lock);
> +	for_each_mapping_in_range(pgt, addr, addr + size, mapping, tmp)
> +		young |= kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn, mkold);
> +	read_unlock(&pgt->pkvm.mappings_lock);
> +
> +	return young;
> +}

I just observed a funny behaviour in one of my tests, the above explains
it ... Can you find the bug? Ahem. I'll fix in v2 obviously.
