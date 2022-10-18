Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD1F3200
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 16:40:16 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id q19so21338099edd.10
        for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 09:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iOPA6fmSUQtvOcvu63Z4VIuGCcRSbgkai17AnO42Xg8=;
        b=RwOSzwSlFSbCd7ZBY+OuXxbAjYHeUdWktNJRobH9SE1tBqo+ITG+S/2lqQ99WtmZGg
         2aklvAWwCrZAx0WH3PgMsnj83COBQ8EHzUnN/XJ7xG6IsbY5W8R5VFOWceL//p/6rYJV
         uIPytEw9UgH8/6EUaPS0RF+l5QZ1XgcJsIVQdyGngbNT6vPQuI/xdHCUv3ucc95MOCFB
         /4X/44neCUuawCWgVLmlYyyt+MG8/pNfDjmANn88qH8rDWp0Ve4Y8GCi9bLi51hWzpdz
         iDkB1tzuk46gjKvZYbU/sTHqsHpFLI3l87eHYe5xINvdWGxUBpfjq52o1EBlMeIiWQsq
         tWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOPA6fmSUQtvOcvu63Z4VIuGCcRSbgkai17AnO42Xg8=;
        b=4LovynNwzfIh1Uz+RQBInphIeAd4DhtcEuL35S6vewNJs3/mHnqZTqYG7+XNxZCBPw
         pYHqmnZyGMAxnLyuh6/XFNKgGGSMccmAzFhOkv3eMhS1MLCAb0kxLSZVPH5k0w9mjsSl
         tUFxOvSLDKn18EVMbpaWoqJTzSgm+giRZ4gw0QVZOpd1eoOfHqpWpFuqystrbAYv0sln
         7E7bYVr5OFnaaONaQSvwP5j2sju3mMEE+7duA1kfwFI4Ev7RLYmvC368mmk1iYka1ZLr
         b22FPvpwwFCgXGEDH8Nz5FXEyIgGviHjywXVbBf+cU3ikbYMLD5pjLAAAU1JJaQwtIeY
         Pl1g==
X-Gm-Message-State: ACrzQf1L0rSabzityou7g47+XFbUgDH3N11oorTFPKBRMIU4O7LWf0Ga
	RsgJ78nlYlqSMgviwfqt9dQN9w==
X-Google-Smtp-Source: AMsMyM6jfwRi0igcgtP8NlX5XCTCI9iXBrg469ezzZODlwCSp+LE/lDHgH145M2jwzJFZG2F8RM4ZA==
X-Received: by 2002:aa7:d348:0:b0:45b:8ae3:ee3d with SMTP id m8-20020aa7d348000000b0045b8ae3ee3dmr3440508edr.428.1666111214784;
        Tue, 18 Oct 2022 09:40:14 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id i18-20020a0564020f1200b00458a03203b1sm9244566eda.31.2022.10.18.09.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 09:40:14 -0700 (PDT)
Date: Tue, 18 Oct 2022 16:40:11 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <Y07W63YlwZ6yClOi@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-13-will@kernel.org>

On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> +static void *map_donated_memory_noclear(unsigned long host_va, size_t size)
> +{
> +	void *va = (void *)kern_hyp_va(host_va);
> +
> +	if (!PAGE_ALIGNED(va))
> +		return NULL;
> +
> +	if (__pkvm_host_donate_hyp(hyp_virt_to_pfn(va),
> +				   PAGE_ALIGN(size) >> PAGE_SHIFT))
> +		return NULL;
> +
> +	return va;
> +}
> +
> +static void *map_donated_memory(unsigned long host_va, size_t size)
> +{
> +	void *va = map_donated_memory_noclear(host_va, size);
> +
> +	if (va)
> +		memset(va, 0, size);
> +
> +	return va;
> +}
> +
> +static void __unmap_donated_memory(void *va, size_t size)
> +{
> +	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
> +				       PAGE_ALIGN(size) >> PAGE_SHIFT));
> +}
> +
> +static void unmap_donated_memory(void *va, size_t size)
> +{
> +	if (!va)
> +		return;
> +
> +	memset(va, 0, size);
> +	__unmap_donated_memory(va, size);
> +}
> +
> +static void unmap_donated_memory_noclear(void *va, size_t size)
> +{
> +	if (!va)
> +		return;
> +
> +	__unmap_donated_memory(va, size);
> +}

Nit: I'm not a huge fan of the naming here, these do more than just
map/unmap random pages. This only works for host pages, the donation
path has permission checks, etc. Maybe {admit,return}_host_memory()?
