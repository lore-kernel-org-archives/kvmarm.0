Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE4014D6EB
	for <kvmarm@lists.linux.dev>; Thu, 25 Apr 2024 16:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714062151; cv=none; b=k5t4GHrRB+hx5U2gQvTCZwGGxbKeKR7Ek5o0fA51YJbGmFuwFp9cnbLQBTmzP7udd+Q4gLU+zzSpYvt/P9AbuL6IXNVByFvrbxzoH5X40/YQTBr2M1rOZYiI4RkJH1Ai9RP1qpyzpOjSZYvb4lYKOvqRwakbdRIax5fLxmSn7hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714062151; c=relaxed/simple;
	bh=MDAUkdPnGzKG6chVud66+86ptfSgJ9KB44HVfsQFna8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KaCbqEpv9fV95wCHvyqu3dxiR3sV6B/Ci+3BfNM28xIYz2KqZDfcJgMN22733n6mta2T0Z/WcgPAamix7EfyvNYRg0yuHGnqeo5YYxLwYEgf/KS1cWltOIarVK1mCqz/eiR2WsXLiS57CDdUyONfuVXSN6ZXCwR4IehSHoTmSo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0xR++xR; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0xR++xR"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7d9c78d7f97so9337739f.3
        for <kvmarm@lists.linux.dev>; Thu, 25 Apr 2024 09:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1714062148; x=1714666948; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tZwpXS/k0DYed9wD5OBUEJ5ypdpSnZbheBH2rdFMtPA=;
        b=I0xR++xR2uWjNQgxVckMt72ceI8j7yxbIY3feFu4eyAV5tFZfCsPbtdOCz8dx9h1LO
         dXdxCqL2m6JM9xAAJKWvOAIIWHDkWA3ad4CJi/peWh1mENwfdPp8qEuxS0OM89JvyPMv
         ssV6tuQ4ZcNv7VjXs8amjQvtn46SljbOhMCdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714062148; x=1714666948;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZwpXS/k0DYed9wD5OBUEJ5ypdpSnZbheBH2rdFMtPA=;
        b=ROE2f/h5ZOFvkn+DWshw8s9S3a+ubvuOsplIeMB5jsNr6K2VsFbDG+uUGVXfaU5bZu
         u9uw92MifDg/iNCV8FA7XX/81Dh/XxP1TMTp6jfyTir5fzp90X6FKX1vIhNhobVUllLh
         KBdakD4FXLVZjo4+zo2e6MVv0NmWsuEB+2kWJmxwrlYdeRyTbv9/x512pxHuPQddbhCh
         GGB83bF3HmW43fJSaKvtqq5Gv7P5Gi+iBYrCUbocxYZKafkWgxjnYCroDOnhKKWgP27x
         eE6GRqmUZiKcQixKEVisPtGn4E3UHa1QnVgZ3MThruDEaPd9Oor6HjlF1bG8sC+P8DR/
         O25g==
X-Forwarded-Encrypted: i=1; AJvYcCWNGFS7hRgE8Sa1p6UHxyiv3fjB4zSfjYT71j6XwIGeB+JqWHDhPkbJnjpb6exyBBdHWY9zVgwhpUoRKNC3zVq7lo0C6fCJ
X-Gm-Message-State: AOJu0Yz28EWhJIBNc1X/QgEOzVxLrS8qT/PWEqv3JIy+HXzxZKmKa0CU
	tu0yBZ1TOHD6XIM4ugyh9dIZpOFLfe2X6RvNOuQeMVx3+pS/FIO+AMotHi60g7o=
X-Google-Smtp-Source: AGHT+IFwsbdYoXOctiJAidygEpyjdbBI6reVPMMOFHtDCREzxeaCqAED6LqVik99m0cV8ef76M2rcQ==
X-Received: by 2002:a6b:ea07:0:b0:7da:cdf3:7bec with SMTP id m7-20020a6bea07000000b007dacdf37becmr160971ioc.1.1714062147803;
        Thu, 25 Apr 2024 09:22:27 -0700 (PDT)
Received: from [192.168.43.82] ([223.185.79.208])
        by smtp.gmail.com with ESMTPSA id m2-20020a638c02000000b005e857e39b10sm13196097pgd.56.2024.04.25.09.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Apr 2024 09:22:27 -0700 (PDT)
Message-ID: <763ee03a-817d-4833-b42f-e5b4bd25dc7f@linuxfoundation.org>
Date: Thu, 25 Apr 2024 10:22:11 -0600
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 25/35] KVM: selftests: Convert lib's mem regions to
 KVM_SET_USER_MEMORY_REGION2
To: Sean Christopherson <seanjc@google.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, Shuah Khan <shuah@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>,
 Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8?=
 =?UTF-8?Q?n?= <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerley Tng <ackerleytng@google.com>,
 Maciej Szmigiero <mail@maciej.szmigiero.name>,
 David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>,
 Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>,
 Liam Merwick <liam.merwick@oracle.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Naresh Kamboju <naresh.kamboju@linaro.org>,
 Anders Roxell <anders.roxell@linaro.org>,
 Benjamin Copeland <ben.copeland@linaro.org>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231027182217.3615211-1-seanjc@google.com>
 <20231027182217.3615211-26-seanjc@google.com>
 <69ae0694-8ca3-402c-b864-99b500b24f5d@moroto.mountain>
 <3848a9ad-07aa-48da-a2b7-264c4a990b5b@linuxfoundation.org>
 <ZipyPYR8Nv_usoU4@google.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <ZipyPYR8Nv_usoU4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/25/24 09:09, Sean Christopherson wrote:
> On Thu, Apr 25, 2024, Shuah Khan wrote:
>> On 4/25/24 08:12, Dan Carpenter wrote:
>>> On Fri, Oct 27, 2023 at 11:22:07AM -0700, Sean Christopherson wrote:
>>>> Use KVM_SET_USER_MEMORY_REGION2 throughout KVM's selftests library so that
>>>> support for guest private memory can be added without needing an entirely
>>>> separate set of helpers.
>>>>
>>>> Note, this obviously makes selftests backwards-incompatible with older KVM
>>>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>> versions from this point forward.
>>>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>
>>> Is there a way we could disable the tests on older kernels instead of
>>> making them fail?  Check uname or something?  There is probably a
>>> standard way to do this...  It's these tests which fail.
>>
>> They shouldn't fail - the tests should be skipped on older kernels.
> 
> Ah, that makes sense.  Except for a few outliers that aren't all that interesting,
> all KVM selftests create memslots, so I'm tempted to just make it a hard requirement
> to spare us headache, e.g.
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index b2262b5fad9e..4b2038b1f11f 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2306,6 +2306,9 @@ void __attribute((constructor)) kvm_selftest_init(void)
>          /* Tell stdout not to buffer its content. */
>          setbuf(stdout, NULL);
>   
> +       __TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),
> +                      "KVM selftests from v6.8+ require KVM_SET_USER_MEMORY_REGION2");
> +
>          kvm_selftest_arch_init();
>   }
> 
> --
> 
> but it's also easy enough to be more precise and skip only those that actually
> create memslots.

This is approach is what is recommended in kselfest document. Rubn as many tests
as possible and skip the ones that can't be run due to unmet dependencies.

> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index b2262b5fad9e..b21152adf448 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -944,6 +944,9 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flag
>                  .guest_memfd_offset = guest_memfd_offset,
>          };
>   
> +       __TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),
> +                      "KVM selftests from v6.8+ require KVM_SET_USER_MEMORY_REGION2");
> +
>          return ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION2, &region);
>   }
>   
> @@ -970,6 +973,9 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>          size_t mem_size = npages * vm->page_size;
>          size_t alignment;
>   
> +       __TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),
> +                      "KVM selftests from v6.8+ require KVM_SET_USER_MEMORY_REGION2");
> +
>          TEST_ASSERT(vm_adjust_num_guest_pages(vm->mode, npages) == npages,
>                  "Number of guest pages is not compatible with the host. "
>                  "Try npages=%d", vm_adjust_num_guest_pages(vm->mode, npages));
> --

thanks,
-- Shuah
