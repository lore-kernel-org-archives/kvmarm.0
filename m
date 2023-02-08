Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154E32560
	for <kvmarm@lists.linux.dev>; Wed,  8 Feb 2023 12:31:26 +0000 (UTC)
Received: by mail-qv1-f52.google.com with SMTP id c5so5641062qvk.13
        for <kvmarm@lists.linux.dev>; Wed, 08 Feb 2023 04:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x2ONYko8lOL1nBDH25lfplxwHP04VK/kwi3k1cUKn+E=;
        b=PQp5h1oc5pSIiwKvZCj1sK3/ln1MutbovvxQ1C1NyhFKNPdXeEGr/ow18JKKL2wTxf
         LMVIxK7H6AegLdykrYg1HvVo2xybmpw5Ncz2bsWFn/5zNWdyybHVBAV/60Er7aryqrrr
         3+RFCLyxAvTR3BBwSdF7ZEvofTaJBwsjAoqdvjBiq/cdfuyOadKlSS+N82JHyvOFXafd
         uugZi8vftI95yQQNcjPOHJtNoFqnfH8zoQ1kz5DUcQ5Vb5N+p2GCnxB1n2c9fSYTIYTd
         u6aZ3acNo9etlUEqbWUPJRWothblIdDcGVP7+nSEOn2fBYWU1X9iv+2NQ7Uv0iGkdlFW
         br6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x2ONYko8lOL1nBDH25lfplxwHP04VK/kwi3k1cUKn+E=;
        b=O6R9cxx0eyzSPEINgHn5dh+3WdWEt7+gq3V45E9tWrNmA0PNrTQsISWhqx8zjWfH/s
         7AkJVhUr4axHmWNR2LANz7RZuSrsj6EHy/s4zlm3oSlqtI5KtxXURV7BaJ2Jk41u50Za
         4ROycX+Ev+EP6qsqNW+RUjQRPp7WcO4c2ymfGZgeUNVqVSZllNaMaPAklmv1FzMgi5vY
         RXR0DBjYnrKrssEpltrjvB8aupR+xWap+/yFW9B0h5T5LXQZeBFni2HFuKEsRqpj9Sao
         5hCxpPJ1U6F6DE8drEi+cxz9SnlYWyhd0hxarggqHUeTSJNx44e+vEviMeowkPwFbtFs
         n5TA==
X-Gm-Message-State: AO0yUKUZ2MH611pUYa+Yj8DxtzUi5hokSOiKUMsM/4icQixPSBnM24aH
	l+9YeVH3vylkGe2NgnR4XFqvc1ISsRCiJDNtettVBA==
X-Google-Smtp-Source: AK7set9fcPkR3BEe44mOMFljqcE5dePAc8nQVXRrv9prnVcoAyBUeN5S8E8QrSNgSMq8cxcr62jPqo+N+5d3nJF6Frc=
X-Received: by 2002:a0c:8c81:0:b0:56c:11df:b0f0 with SMTP id
 p1-20020a0c8c81000000b0056c11dfb0f0mr545525qvb.81.1675859485960; Wed, 08 Feb
 2023 04:31:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-20-jean-philippe@linaro.org> <Y+JOhEfi8mu1RuOt@google.com>
In-Reply-To: <Y+JOhEfi8mu1RuOt@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Wed, 8 Feb 2023 12:31:15 +0000
Message-ID: <CAFgf54q+R6nQBUAz9Quj8pQiTgKe7R_7BdQ=PWWay0WqDVzL1Q@mail.gmail.com>
Subject: Re: [RFC PATCH 19/45] KVM: arm64: iommu: Add domains
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org, joro@8bytes.org, 
	robin.murphy@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, yuzenghui@huawei.com, dbrazdil@google.com, 
	ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 7, 2023 at 1:13 PM Mostafa Saleh <smostafa@google.com> wrote:

> I was wondering about the need for pre-allocation of the domain array.
>
> An alternative way I see:
> - We don=E2=80=99t pre-allocate any domain.
>
> - When the EL1 driver has a request to domain_alloc, it will allocate
> both kernel(iommu_domain) and hypervisor domains(kvm_hyp_iommu_domain).
>
> - In __pkvm_host_iommu_alloc_domain, it will take over the hyp struct
> from the kernel (via donation).
>
> - In all other hypercalls, the kernel address of kvm_hyp_iommu_domain wil=
l
> be used as domain ID, which guarantees uniqueness and O(1) access.
>
> - The hypervisor would just need to transform the address(kern_hyp_va)
> to get the domain pointer.


This actually will not work with the current sequence, as we can't
guarantee that the domain_id sent later from the host is trusted, and as
the domain points to the page table this can be dangerous, I will have a
closer look to see if we can make this work somehow.
