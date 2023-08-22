Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951B81D2E6
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692717675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K+4dLM+qjKpedR3SxcMNZWwteZnGWMqZ2x4IrF9xwmE=;
	b=XhksWGvOujynlzvS4ImTi8AXCHbF/+RC2HFdzjfdePZw4G+w5BHMtkFUwC2tLgFIqeYnT/
	raiaJsyAhEk3yuzXHlvDIMAQM7rZLKhzvyK+VaQ7zym6ealaHlpmGSX0kxVrYW5tJp7w90
	Gb8MlHHpW9UMP8VW5d2D/KVOBmvQmPM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-03YhPMKVPTiMBqrD_7JJPA-1; Tue, 22 Aug 2023 11:21:13 -0400
X-MC-Unique: 03YhPMKVPTiMBqrD_7JJPA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-31aca0c0d63so2748231f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 08:21:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692717672; x=1693322472;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K+4dLM+qjKpedR3SxcMNZWwteZnGWMqZ2x4IrF9xwmE=;
        b=fGbedYYCqMQpxyAFVajHMi3jHj6EuzOHaAoLDSstALI3iUHb7JnQZTpoMAonzWb9sB
         AD1PfX7tdQNd2EFT7MrGZLsiwe2CRfLkNgawFZqn4KMydb8Moiw8uFpLEmLOUWH83ct7
         JcJ/59PsnnG5s8oc2oTp8qamr0oBmjvoH7M7sj7Pq9g5r6q4xu0P0ujNe9kAs/UpPh+O
         8SctmPd540hdthpDBaiN6O6jqqeRZRjwTaKOGyg4RgvfG2D3B0ugUgJKN2zRQWlqxCJ/
         vI0r8QMAdGZOxh1zrnj1j2NGgbZacDJSnrDbVEjJ+xdefGHqs1UnGoEcW7X586aWZbWG
         chhQ==
X-Gm-Message-State: AOJu0YzfsFdmzU8UBesacib/HUueJzGXGIFtFOP3W0W0rHiVDOXnVkUt
	0/Kv+QkRHqZUzKljnZQZGCOPSdPnAGMWgaOP/Df50ZMFm9Oxbvls1rimyKqonIsLmDYjNKWSN9k
	Exl06ruNKOCuRCaxd
X-Received: by 2002:a5d:4ccc:0:b0:314:1230:29b0 with SMTP id c12-20020a5d4ccc000000b00314123029b0mr6891010wrt.52.1692717672412;
        Tue, 22 Aug 2023 08:21:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvvahb1vrGoYIb2vzRiaZnzgGGGa/+gqBYlj1b7B5EZtm9phlubqZT0TsAOsELNEsT5eF4fQ==
X-Received: by 2002:a5d:4ccc:0:b0:314:1230:29b0 with SMTP id c12-20020a5d4ccc000000b00314123029b0mr6890972wrt.52.1692717671988;
        Tue, 22 Aug 2023 08:21:11 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:7400:83da:ebad:ba7f:c97c? (p200300cbc706740083daebadba7fc97c.dip0.t-ipconnect.de. [2003:cb:c706:7400:83da:ebad:ba7f:c97c])
        by smtp.gmail.com with ESMTPSA id n4-20020a5d4204000000b0031c5dda3aedsm3811087wrq.95.2023.08.22.08.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 08:21:11 -0700 (PDT)
Message-ID: <8f2cf5af-cad7-a69c-e8ec-39f48deae1cb@redhat.com>
Date: Tue, 22 Aug 2023 17:21:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 11/37] mm: Define VM_SHADOW_STACK for arm64 when we
 support GCS
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>,
 Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>,
 Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>,
 "Rick P. Edgecombe" <rick.p.edgecombe@intel.com>,
 Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>,
 Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20230822-arm64-gcs-v5-0-9ef181dd6324@kernel.org>
 <20230822-arm64-gcs-v5-11-9ef181dd6324@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230822-arm64-gcs-v5-11-9ef181dd6324@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22.08.23 15:56, Mark Brown wrote:
> Use VM_HIGH_ARCH_5 for guarded control stack pages.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   Documentation/filesystems/proc.rst |  2 +-
>   fs/proc/task_mmu.c                 |  3 +++
>   include/linux/mm.h                 | 12 +++++++++++-
>   3 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 6ccb57089a06..086a0408a4d7 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -566,7 +566,7 @@ encoded manner. The codes are the following:
>       mt    arm64 MTE allocation tags are enabled
>       um    userfaultfd missing tracking
>       uw    userfaultfd wr-protect tracking
> -    ss    shadow stack page
> +    ss    shadow/guarded control stack page
>       ==    =======================================
>   
>   Note that there is no guarantee that every flag and associated mnemonic will
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index cfab855fe7e9..e8c50848bb16 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -711,6 +711,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>   #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
>   #ifdef CONFIG_X86_USER_SHADOW_STACK
>   		[ilog2(VM_SHADOW_STACK)] = "ss",
> +#endif
> +#ifdef CONFIG_ARM64_GCS
> +		[ilog2(VM_SHADOW_STACK)] = "ss",
>   #endif

See my comment below.

>   	};
>   	size_t i;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 43fe625b85aa..3f939ae212e5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -372,7 +372,17 @@ extern unsigned int kobjsize(const void *objp);
>    * having a PAGE_SIZE guard gap.
>    */
>   # define VM_SHADOW_STACK	VM_HIGH_ARCH_5
> -#else
> +#endif
> +
> +#if defined(CONFIG_ARM64_GCS)
> +/*
> + * arm64's Guarded Control Stack implements similar functionality and
> + * has similar constraints to shadow stacks.
> + */
> +# define VM_SHADOW_STACK	VM_HIGH_ARCH_5
> +#endif


Shouldn't that all just merged with the previous define(s)?

Also, I wonder if we now want to have CONFIG_HAVE_ARCH_SHADOW_STACK or 
similar.

-- 
Cheers,

David / dhildenb

