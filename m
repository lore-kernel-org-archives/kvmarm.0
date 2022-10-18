Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74381102
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 16:33:50 +0000 (UTC)
Received: by mail-ej1-f51.google.com with SMTP id r17so33587627eja.7
        for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 09:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DqDgXXUBKgC05Hv+WG8VLItfXbNXEiS/cMK9T9OzjCs=;
        b=EDVjXNcJBQF3sMy6ywtF+Bbf8LfvpG0Ow0j3NoGv4ZwLzhdNxu0siesmOopfPJNYTi
         Q1TdZV8pOeLQwNRQUl8icKzCsINTo7YVaQnsLEzpwW8cdn8ebQR//CSFnD4fhBQ+Tf1H
         /5cpfU1ilnYG9XecfXoOJT9Rdo/rmcCp+qX1kbiKCAbi4wDgGVgRoX+O+I1b1K+oeyU0
         FGP7wcsVZ+QliZq3POvA6X6UXGMpec7yW+Xf2UG/ZkTUuKhrv53jnj8m6ErVy1fXxDmB
         +Mjl+g8duDlR4HZp7BiVUn1XwXG1kE9jTpWZ5+cx62qyRBaXSt7m1TfF3lm6XM9BoS5M
         1JiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqDgXXUBKgC05Hv+WG8VLItfXbNXEiS/cMK9T9OzjCs=;
        b=JbnejP1f2aBW/S+VJeQyNh4JWymzcGJOyZuj+5Aq2R5ar14G9FvXRmWKgfxwY+iNYQ
         eVgF3AAtCNib+mc4ofjqo0oBmxiDp5t8YEGScMBQ8dwIvUX0RLVZXYf5asM73yxiWtmx
         QxmBTLKIpNvsW9viYruf03uyL7LPaqvwiOkCfpG7tBlLjFTOgIvloUz5cSVRLCPYTzxD
         wwQ/FnsjEtqbGJA93oXYVsp7rOlFmpKo88Y9svl2RqVxeJPOyVfBRywYLBRNT8skVcWA
         alLyqrVOmL1pneItSZLR0F/e+1rNQC44OPkBddcWoYbjMnk/o2HDWudxl1snqTyu4hmf
         MJsg==
X-Gm-Message-State: ACrzQf3JbvdXDemzRY2qSDckmIeK04YDBf1X+WWJ2L7sr1/CQqlwY7Rw
	srJ9EgBHtTcRjuXbGLMKrPYVZLSTqZ+C5w==
X-Google-Smtp-Source: AMsMyM75nkHFBrc8vAbS6QOzzLFaHYxFqm8Mdjtq2X4oVdP8KRhyics/XG4ZyYsOZYHfc53Cnkg3pA==
X-Received: by 2002:a17:906:5dac:b0:791:93de:c61d with SMTP id n12-20020a1709065dac00b0079193dec61dmr3059147ejv.751.1666110828800;
        Tue, 18 Oct 2022 09:33:48 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id l6-20020a1709062a8600b0073d796a1043sm7687814eje.123.2022.10.18.09.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 09:33:48 -0700 (PDT)
Date: Tue, 18 Oct 2022 16:33:45 +0000
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
Message-ID: <Y07VaRwVf3McX27a@google.com>
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
> +void pkvm_hyp_vm_table_init(void *tbl)
> +{
> +	WARN_ON(vm_table);
> +	vm_table = tbl;
> +}

Uh, why does this one need to be exposed outside pkvm.c ?
