Received: from mta1.migadu.com (out-127.mta1.migadu.com [95.215.58.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD57F44238F
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 14:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976180; cv=none; b=MKvtq7fqp895TjToSRXnra8gcps5uxgYyCu2ZeuvWgqRj7uykd3ts0gdwacsrY0tF7mU4M9HdiKpQasrCshAA2wWODb+V+dajuEec4au/Z6veHCtJQgS1jCxbX/ZcuZpnvvYQ6t4JjDP9VA/39ST6Ju9+OJFv1wgvLlBgPq3OFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976180; c=relaxed/simple;
	bh=T8iyjbuVYAvqUViUhRvKQj8eKQSB1E/dq1wYQtEhFKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a8nV0xjtNvbnMa69i9SqJ4DEIJSAs4FeBvBHavnzHAD022TlV4TLH6dhgrFt6/RWzRGIKGz7ChL4kkzq5Xz4D/Mf0btFRF9DjV01saFlK7v2LUS5zmjMe7Hs5KhrzhJRqCpLZE92r77Y6NMU3UHY0k4/jc5eABeScKVKG71mgmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tBg1UZWb; arc=none smtp.client-ip=95.215.58.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tBg1UZWb"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=T8iyjbuVYAvqUViUhRvKQj8eKQSB1E/dq1wYQtEhFKo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786976176; v=1; x=1787580976;
 b=tBg1UZWbMW9xTUpb5nexXdwcVhPUyVgg3P0IFZ+te4EoYf3H7JUgIDZhgY+J5fvUQqURbHg9
 dLir+NoqRMs8RgGk6VqfElIxpy3HiBhiXmMvst3d3Qv2AK5UN6P5+nFZWAqOMlW7v7n/pTzjxDA
 wj0aZ/rtaAPPTgybDEKJNRyM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f45.google.com (209.85.167.45)
	by smtp.migadu.com with ESMTPS id 84afcdbc8ba9924d;
	Mon, 17 Aug 2026 14:16:16 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so3564e87.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 07:16:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr5U4nm7i9cS4d3hDNb89+ZMySvGhOIBH+xbhf8oRGD7FdIpO1M/5rUquU9J2PSuLaPDXCFVYQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQ87ZKPp9j8j8Egf0OHRHcTuCQQha6zZgr4hoxPIO2rK87MS2D
	64+eG2j3ZIQhXK1tg1y2oS3lo1nTQUJqFWHTjhM/P4AEA6bCEkCDAM8K0Burc5fDrkRGEWhj+Al
	ulNnf/Iy5ESepFnfuzOt297/f1Bfj8r2SZBwWCUi7
X-Received: by 2002:a05:6512:3d1c:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5b47084ad85mr12150e87.9.1786976170444; Mon, 17 Aug 2026
 07:16:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com> <20260731143541.956291-18-vdonnefort@google.com>
In-Reply-To: <20260731143541.956291-18-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 17 Aug 2026 15:16:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzGbZnz_SdcMvVwwDTTyHbyjAwukK-A90z2oVJtaBGz3g@mail.gmail.com>
X-Gm-Features: AcwNN1XTayorjSSf4W1Pr0n-dJNWHXveErqutMBS45AHvtcEguOem3CyW-EXrec
Message-ID: <CA+EHjTzGbZnz_SdcMvVwwDTTyHbyjAwukK-A90z2oVJtaBGz3g@mail.gmail.com>
Subject: Re: [PATCH v4 17/17] KVM: arm64: Alloc simple_buffer_page using pKVM
 hyp allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Jul 2026 at 15:36, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> In protected mode, transition the allocation of the simple_ring_buffer
> structures from the host to the hypervisor using the new pKVM heap
> allocator.
>
> Previously, the host allocated and donated a contiguous backing memory
> for these structures. In pKVM the hypervisor can now allocate them
> dynamically.
>
> Use the pkvm_call_hyp_req() wrapper in the host to invoke
> __tracing_load, which automatically handles any top-up requests if the
> hypervisor runs out of heap memory during allocation.
>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>


Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 9bab1e802281..ec5bb8541ceb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -750,7 +750,7 @@ static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
>         DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
>         DECLARE_REG(size_t, desc_size, host_ctxt, 2);
>
> -       cpu_reg(host_ctxt, 1) = __tracing_load(desc_hva, desc_size);
> +       errno_to_smccc(__tracing_load(desc_hva, desc_size), host_ctxt);
>  }
>
>  static void handle___tracing_unload(struct kvm_cpu_context *host_ctxt)
> diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
> index 96afa3d6de2f..5ff19d210508 100644
> --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/trace.c
> @@ -4,6 +4,7 @@
>   * Author: Vincent Donnefort <vdonnefort@google.com>
>   */
>
> +#include <nvhe/alloc.h>
>  #include <nvhe/clock.h>
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/mm.h>
> @@ -62,18 +63,34 @@ static void __release_host_mem(void *start, u64 size)
>         WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(start), size >> PAGE_SHIFT));
>  }
>
> -static int hyp_trace_buffer_load_bpage_backing(struct hyp_trace_buffer *trace_buffer,
> -                                              struct hyp_trace_desc *desc)
> +static int hyp_trace_buffer_alloc_bpages(struct hyp_trace_buffer *trace_buffer,
> +                                        struct hyp_trace_desc *desc)
>  {
> -       void *start = (void *)kern_hyp_va(desc->bpages_backing_start);
> -       size_t size = desc->bpages_backing_size;
> +       void *start;
> +       size_t size;
>         int ret;
>
> -       ret = __admit_host_mem(start, size);
> -       if (ret)
> -               return ret;
> +       if (is_protected_kvm_enabled()) {
> +               struct ring_buffer_desc *rb_desc;
> +               int cpu;
>
> -       memset(start, 0, size);
> +               size = 0;
> +               for_each_ring_buffer_desc(rb_desc, cpu, &desc->trace_buffer_desc)
> +                       size += rb_desc->nr_page_va * sizeof(struct simple_buffer_page);
> +
> +               start = hyp_alloc(size);
> +               if (!start)
> +                       return hyp_alloc_errno();
> +       } else {
> +               start = (void *)kern_hyp_va(desc->bpages_backing_start);
> +               size = desc->bpages_backing_size;
> +
> +               ret = __admit_host_mem(start, size);
> +               if (ret)
> +                       return ret;
> +
> +               memset(start, 0, size);
> +       }
>
>         trace_buffer->bpages_backing_start = start;
>         trace_buffer->bpages_backing_size = size;
> @@ -81,7 +98,7 @@ static int hyp_trace_buffer_load_bpage_backing(struct hyp_trace_buffer *trace_bu
>         return 0;
>  }
>
> -static void hyp_trace_buffer_unload_bpage_backing(struct hyp_trace_buffer *trace_buffer)
> +static void hyp_trace_buffer_free_bpages(struct hyp_trace_buffer *trace_buffer)
>  {
>         void *start = trace_buffer->bpages_backing_start;
>         size_t size = trace_buffer->bpages_backing_size;
> @@ -89,9 +106,12 @@ static void hyp_trace_buffer_unload_bpage_backing(struct hyp_trace_buffer *trace
>         if (!size)
>                 return;
>
> -       memset(start, 0, size);
> -
> -       __release_host_mem(start, size);
> +       if (is_protected_kvm_enabled()) {
> +               hyp_free(start);
> +       } else {
> +               memset(start, 0, size);
> +               __release_host_mem(start, size);
> +       }
>
>         trace_buffer->bpages_backing_start = 0;
>         trace_buffer->bpages_backing_size = 0;
> @@ -128,7 +148,7 @@ static void hyp_trace_buffer_unload(struct hyp_trace_buffer *trace_buffer)
>                 simple_ring_buffer_unload_mm(per_cpu_ptr(trace_buffer->simple_rbs, cpu),
>                                              __unpin_shared_page);
>
> -       hyp_trace_buffer_unload_bpage_backing(trace_buffer);
> +       hyp_trace_buffer_free_bpages(trace_buffer);
>  }
>
>  static int hyp_trace_buffer_load(struct hyp_trace_buffer *trace_buffer,
> @@ -143,7 +163,7 @@ static int hyp_trace_buffer_load(struct hyp_trace_buffer *trace_buffer,
>         if (hyp_trace_buffer_loaded(trace_buffer))
>                 return -EINVAL;
>
> -       ret = hyp_trace_buffer_load_bpage_backing(trace_buffer, desc);
> +       ret = hyp_trace_buffer_alloc_bpages(trace_buffer, desc);
>         if (ret)
>                 return ret;
>
> @@ -168,18 +188,16 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
>  {
>         struct ring_buffer_desc *rb_desc;
>         unsigned int cpu;
> -       size_t nr_bpages;
>         void *desc_end;
>
>         if (!is_protected_kvm_enabled())
>                 return true;
>
>         /*
> -        * Both desc_size and bpages_backing_size are untrusted host-provided
> -        * values. We rely on __pkvm_host_donate_hyp() to enforce their validity.
> +        * desc_size is an untrusted host-provided value. We rely on
> +        * __pkvm_host_donate_hyp() to enforce its validity.
>          */
>         desc_end = (void *)desc + desc_size;
> -       nr_bpages = desc->bpages_backing_size / sizeof(struct simple_buffer_page);
>
>         if (desc->trace_buffer_desc.nr_cpus != hyp_nr_cpus)
>                 return false;
> @@ -197,17 +215,8 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
>                 if ((void *)rb_desc + struct_size(rb_desc, page_va, rb_desc->nr_page_va) > desc_end)
>                         return false;
>
> -               /* Overflow bpages backing memory? */
> -               if (nr_bpages < rb_desc->nr_page_va)
> -                       return false;
> -
> -               if (cpu >= hyp_nr_cpus)
> -                       return false;
> -
>                 if (cpu != rb_desc->cpu)
>                         return false;
> -
> -               nr_bpages -= rb_desc->nr_page_va;
>         }
>
>         return true;
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 2411b4c32932..859a926c815f 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -13,6 +13,7 @@
>  #include <asm/kvm_host.h>
>  #include <asm/kvm_hyptrace.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_pkvm.h>
>
>  #include "hyp_trace.h"
>
> @@ -157,10 +158,17 @@ static void __unshare_page(unsigned long va)
>
>  static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_buffer, size_t size)
>  {
> -       int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
>         size_t backing_size;
> +       int nr_bpages;
>         void *start;
>
> +       if (is_protected_kvm_enabled()) {
> +               trace_buffer->desc->bpages_backing_start = 0;
> +               trace_buffer->desc->bpages_backing_size = 0;
> +               return 0;
> +       }
> +
> +       nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
>         backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
>                                   num_possible_cpus());
>
> @@ -176,6 +184,9 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
>
>  static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)
>  {
> +       if (!trace_buffer->desc->bpages_backing_start)
> +               return;
> +
>         free_pages_exact((void *)trace_buffer->desc->bpages_backing_start,
>                          trace_buffer->desc->bpages_backing_size);
>  }
> @@ -264,7 +275,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
>         if (ret)
>                 goto err_free_buffer;
>
> -       ret = kvm_call_hyp_nvhe(__tracing_load, (unsigned long)desc, desc_size);
> +       ret = pkvm_call_hyp_req(__tracing_load, (unsigned long)desc, desc_size);
>         if (ret)
>                 goto err_unload_pages;
>
> --
> 2.55.0.508.g3f0d502094-goog
>
