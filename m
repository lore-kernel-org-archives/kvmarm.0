Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293BA424D64
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787067839; cv=none; b=Cf5sN8rtrAzmpH1jJyL27780D8Zt5BNeX4MKLeM0RLOJ73dRnUDw/l1ALuWkrAje0PVmnjsw5zp3mdfZ8c+4jA41jnQzyy07Cu3rSyTgxP84GoRSVi6wqEpagxjvm6OUQtArkLAt7q6xBk02iK+4HqO6tHKXL13O/AWMlfLf+dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787067839; c=relaxed/simple;
	bh=xqCmZn8IMffi1+IzepnqMRv/vTN47LqYxZG5/JsvG8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VSL6JDN6Lg/56fY+Va1c3PcX41yzR/f57PHvL3ROC6XIP+TdE75Znp3AZXpQcK7R0gpdYsuajJVWzpDnIJpohDGlTXay9kxQn0KywFDwTaQS+Lx50Isebz3C/+GAPb5n5CWj573x+3NY+arHxyKmjIsimxQhOQ6zCYQGAYXM6z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wZove01n; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wZove01n"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xqCmZn8IMffi1+IzepnqMRv/vTN47LqYxZG5/JsvG8w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787067833; v=1; x=1787672633;
 b=wZove01nSpj8RmqfO4OgzcZBc0P5VrDe3cpcSJDJfbhPV3yaQqlTElsLPhZ0/eSDMQGV1IDQ
 ZOfJTroADzAji6+CQabqJrX0cqK1F3R357IsL8+gB1T9l9B32V3z//m9LfMbDE2jVYy4WquKbCt
 +MzA2Y/ClFdzq2T2GMc+rQ20=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f44.google.com (209.85.167.44)
	by smtp.migadu.com with ESMTPS id 4906c013c7a5361f;
	Tue, 18 Aug 2026 15:43:53 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so8765e87.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 08:43:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq+2xxduanMW4Nbw2+pYJLXImsHz30URItLlAn38dGfdLdB703ZmhUO91+KuVNXLdJFRSvs1Qo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6wC1waKFf5nxhyftGZy9pSVVWa7B9wRk1ZTM2rU6f27kmhI8L
	MZqr78aLPQf9YbC0TpEegrCbI9hksKOe3x3YNH4saa62Ev9FoPiHwkgDOU8H2rh0CJXKOdiHidy
	b9j2aerNc4IBbvpx6oCZjeSjGxxNJ+2lTTRQ+WvNe
X-Received: by 2002:a05:6512:39d2:b0:5aa:79d6:b559 with SMTP id
 2adb3069b0e04-5b471d7c3afmr252829e87.0.1787067832468; Tue, 18 Aug 2026
 08:43:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com> <20260731143541.956291-10-vdonnefort@google.com>
In-Reply-To: <20260731143541.956291-10-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 18 Aug 2026 16:43:16 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy7SUFsE3N5ERV_FQw-3GyEo17mqe2=RbV1wz8bVT+JXw@mail.gmail.com>
X-Gm-Features: AcwNN1U_P4-IFma-j9U4XnVKaABI9s42IM8oaP9t3k1XNqFyc34ZYFaR_aP_vmU
Message-ID: <CA+EHjTy7SUFsE3N5ERV_FQw-3GyEo17mqe2=RbV1wz8bVT+JXw@mail.gmail.com>
Subject: Re: [PATCH v4 09/17] KVM: arm64: Add selftests for the pKVM heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 31 Jul 2026 at 15:36, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Introduce a comprehensive runtime selftest for the pKVM hypervisor heap
> allocator, executed during init when CONFIG_NVHE_EL2_DEBUG is enabled.
>
> The selftest runs entirely at EL2 and exercises allocator's core
> mechanisms:
>
>   * over-sized allocations
>   * basic allocation and alignment
>   * chunk recycling, splitting, merging
>   * memory reclaiming
>   * memory topup
>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 0c3126179704..08466f608d1f 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -92,6 +92,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
>         __KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaim,
>         __KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaimable,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_hyp_alloc_selftest,
>
>         MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
>
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 99daa985856f..73c8881e14ec 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -19,8 +19,10 @@
>
>  enum pkvm_topup_id {
>         PKVM_TOPUP_HYP_ALLOC,
> +       PKVM_TOPUP_HYP_ALLOC_SELFTEST,
>  };
>
> +void pkvm_selftests(void);
>  int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
>  int pkvm_create_hyp_vm(struct kvm *kvm);
>  bool pkvm_hyp_vm_is_created(struct kvm *kvm);
> @@ -206,6 +208,7 @@ struct pkvm_mapping {
>  enum pkvm_hyp_req_type {
>         PKVM_HYP_NO_REQ = 0,
>         PKVM_HYP_REQ_HYP_ALLOC,
> +       PKVM_HYP_REQ_HYP_ALLOC_SELFTEST,
>         __PKVM_HYP_REQ_TYPE_MAX,
>  };
>
> @@ -233,6 +236,7 @@ static inline size_t pkvm_hyp_req_arg_size(u8 type)
>         case PKVM_HYP_NO_REQ:
>                 return 0;
>         case PKVM_HYP_REQ_HYP_ALLOC:
> +       case PKVM_HYP_REQ_HYP_ALLOC_SELFTEST:
>                 return sizeof(req->mem);
>         default:
>                 WARN_ON(1);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 50adfff75be8..750862705a70 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2883,6 +2883,8 @@ static int __init init_hyp_mode(void)
>                         kvm_err("Failed to init hyp memory protection\n");
>                         goto out_err;
>                 }
> +
> +               pkvm_selftests();
>         }
>
>         return 0;
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/alloc.h b/arch/arm64/kvm/hyp/include/nvhe/alloc.h
> index 8f87a63f8946..329250dad6f6 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/alloc.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/alloc.h
> @@ -14,4 +14,11 @@ int hyp_alloc_init(size_t size);
>  int hyp_alloc_topup(struct kvm_hyp_memcache *host_mc);
>  unsigned long hyp_alloc_reclaimable(void);
>  void hyp_alloc_reclaim(struct kvm_hyp_memcache *host_mc, unsigned long target);
> +
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +int hyp_allocator_selftest(void);
> +u32 hyp_alloc_selftest_topup_needed(void);
> +int hyp_alloc_selftest_topup(struct kvm_hyp_memcache *host_mc);
> +void hyp_alloc_selftest_reclaim(struct kvm_hyp_memcache *host_mc, unsigned long target);
> +#endif
>  #endif
> diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/alloc.c
> index af4ab53784f7..de636fdf976b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/alloc.c
> @@ -1015,9 +1015,17 @@ int hyp_alloc_errno(void)
>         return hyp_allocator_errno(&hyp_allocator);
>  }
>
> +static int selftest_init(void);
> +
>  int hyp_alloc_init(size_t size)
>  {
> -       return hyp_allocator_init(&hyp_allocator, size);
> +       int ret;
> +
> +       ret = hyp_allocator_init(&hyp_allocator, size);
> +       if (ret)
> +               return ret;
> +
> +       return selftest_init();
>  }
>
>  void hyp_alloc_reclaim(struct kvm_hyp_memcache *mc, unsigned long target)
> @@ -1039,3 +1047,179 @@ u32 hyp_alloc_topup_needed(void)
>  {
>         return hyp_allocator_topup_needed(&hyp_allocator);
>  }
> +
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +#define SELFTEST_MAX_PAGES 6
> +#define SELFTEST_MAX_SIZE (PAGE_SIZE * SELFTEST_MAX_PAGES)
> +
> +static DEFINE_PER_CPU(int, __selftest_errno);
> +static DEFINE_PER_CPU(u32, __selftest_topup_needed);
> +
> +static struct hyp_allocator selftest_allocator = {
> +       .errno = &__selftest_errno,
> +       .topup_needed = &__selftest_topup_needed,
> +       .lock = __HYP_SPIN_LOCK_UNLOCKED,
> +};
> +
> +int hyp_alloc_selftest_topup(struct kvm_hyp_memcache *host_mc)
> +{
> +       return hyp_allocator_topup(&selftest_allocator, host_mc);
> +}
> +
> +void hyp_alloc_selftest_reclaim(struct kvm_hyp_memcache *host_mc, unsigned long target)
> +{
> +       hyp_allocator_reclaim(&selftest_allocator, host_mc, target);
> +}
> +
> +u32 hyp_alloc_selftest_topup_needed(void)
> +{
> +       return hyp_allocator_topup_needed(&selftest_allocator);
> +}
> +
> +static int selftest_init(void)
> +{
> +       return hyp_allocator_init(&selftest_allocator, SELFTEST_MAX_SIZE);
> +}
> +
> +static void *selftest_alloc(size_t size)
> +{
> +       return hyp_allocator_alloc(&selftest_allocator, size);
> +}
> +
> +static void selftest_free(void *addr)
> +{
> +       hyp_allocator_free(&selftest_allocator, addr);
> +}
> +
> +static int selftest_errno(void)
> +{
> +       return hyp_allocator_errno(&selftest_allocator);
> +}
> +
> +int hyp_allocator_selftest(void)
> +{
> +       struct hyp_allocator *allocator = &selftest_allocator;
> +       static DEFINE_HYP_SPINLOCK(selftest_lock);
> +       struct kvm_hyp_memcache host_mc = { };
> +       void *addr1, *addr2, *addr3, *addr4;
> +       int ret;
> +
> +       guard(hyp_spinlock)(&selftest_lock);
> +
> +       if (allocator->mc.nr_pages < SELFTEST_MAX_PAGES) {
> +               *this_cpu_ptr(allocator->topup_needed) = SELFTEST_MAX_PAGES -
> +                                                        allocator->mc.nr_pages;
> +               return -ENOMEM;
> +       }
> +
> +       selftest_alloc(SELFTEST_MAX_SIZE);
> +       if (selftest_errno() != -E2BIG)
> +               return -EINVAL;
> +
> +       selftest_alloc(SIZE_MAX);
> +       if (selftest_errno() != -E2BIG)
> +               return -EINVAL;
> +
> +       /* Test first chunk */
> +       addr1 = selftest_alloc(0);
> +       if (!addr1 || addr1 != (void *)allocator->start + chunk_hdr_size())
> +               return -EINVAL;
> +
> +       /* Test second contiguous chunk with unaligned size */
> +       addr2 = selftest_alloc(MIN_ALLOC_SIZE + 1);
> +       if (!addr2)
> +               return -EINVAL;
> +       addr3 = selftest_alloc(0);
> +       if (!addr3 ||
> +           addr3 != addr2 + (2 * MIN_ALLOC_SIZE) + chunk_hdr_size())
> +               return -EINVAL;
> +
> +       selftest_free(addr3);
> +
> +       /* Test chunk recycling */
> +       selftest_free(addr1);
> +       if (addr1 != selftest_alloc(0))
> +               return -EINVAL;
> +
> +       /* Test chunk forward merging */
> +       addr3 = selftest_alloc(0);
> +       selftest_free(addr2);
> +       selftest_free(addr1);
> +       if (addr1 != selftest_alloc(MIN_ALLOC_SIZE * 2))
> +               return -EINVAL;
> +
> +       selftest_free(addr1);
> +
> +       /* Test chunk splitting */
> +       if (addr1 != selftest_alloc(0))
> +               return -EINVAL;
> +       if (addr2 != selftest_alloc(0))
> +               return -EINVAL;
> +
> +       /* Test chunk backward merging */
> +       selftest_free(addr1);
> +       selftest_free(addr2);
> +       if (addr1 != selftest_alloc(MIN_ALLOC_SIZE * 2))
> +               return -EINVAL;
> +
> +       selftest_free(addr1);
> +
> +       /* Test chunk 3-way merging */
> +       addr1 = selftest_alloc(0);
> +       addr2 = selftest_alloc(0);
> +       addr4 = selftest_alloc(0);
> +       selftest_free(addr1);
> +       selftest_free(addr3);
> +       selftest_free(addr2);
> +       if (addr1 != selftest_alloc(MIN_ALLOC_SIZE * 3))
> +               return -EINVAL;
> +
> +       selftest_free(addr4);
> +       selftest_free(addr1);
> +
> +       /* Test reclaiming */
> +       if (addr1 != selftest_alloc(0))
> +               return -EINVAL;
> +       if (addr2 != selftest_alloc(PAGE_SIZE * 2))
> +               return -EINVAL;
> +       addr3 = selftest_alloc(0);
> +       addr4 = selftest_alloc(PAGE_SIZE);
> +
> +       /* Test reclaiming the last chunk of the list */
> +       selftest_free(addr4);
> +       hyp_allocator_reclaim(allocator, &host_mc, SELFTEST_MAX_PAGES);
> +       if (host_mc.nr_pages != SELFTEST_MAX_PAGES - 3)
> +               return -EINVAL;
> +
> +       /* Test punching a hole in the middle of a free chunk ... */
> +       selftest_free(addr2);
> +       hyp_allocator_reclaim(allocator, &host_mc, SELFTEST_MAX_PAGES);
> +       if (host_mc.nr_pages != SELFTEST_MAX_PAGES - 2)
> +               return -EINVAL;
> +
> +       if (selftest_alloc(PAGE_SIZE))
> +               return -EINVAL;
> +       if (selftest_errno() != -ENOMEM)
> +               return -EINVAL;
> +
> +       /* ... and to refill this hole */
> +       ret = hyp_allocator_topup(allocator, &host_mc);
> +       if (ret)
> +               return ret;
> +       /* Chunk at addr2 was made smaller by the reclaim */
> +       if (addr2 != selftest_alloc(PAGE_SIZE))
> +               return -EINVAL;
> +
> +       /* Test reclaiming the entire allocator from the host */
> +       selftest_free(addr3);
> +       selftest_free(addr2);
> +       selftest_free(addr1);
> +       if (addr1 != selftest_alloc(SELFTEST_MAX_PAGES * PAGE_SIZE - chunk_hdr_size()))
> +               return -EINVAL;
> +       selftest_free(addr1);
> +
> +       return 0;
> +}
> +#else
> +static int selftest_init(void) { return 0; }
> +#endif
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 346365e76ef2..d99c9b1b0c82 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -633,6 +633,28 @@ static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt
>         cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
>  }
>
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +static void handle___pkvm_hyp_alloc_selftest(struct kvm_cpu_context *host_ctxt)
> +{
> +       struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
> +       int ret;
> +
> +       ret = hyp_allocator_selftest();
> +       if (ret == -ENOMEM) {
> +               req.type = PKVM_HYP_REQ_HYP_ALLOC_SELFTEST;
> +               req.mem.nr_pages = hyp_alloc_selftest_topup_needed();
> +       }
> +
> +       cpu_reg(host_ctxt, 1) = ret;
> +       pkvm_hyp_req_to_smccc(host_ctxt, &req);
> +}
> +#else
> +static void handle___pkvm_hyp_alloc_selftest(struct kvm_cpu_context *host_ctxt)
> +{
> +       cpu_reg(host_ctxt, 1) = -EPERM;
> +}
> +#endif

My tag stands, but thought about this while going through Sashiko's reviews.

The other arm writes x2 through pkvm_hyp_req_to_smccc(), this one does
not, and -EPERM is an error so pkvm_call_hyp_req() goes and decodes
x2. Nothing initialises it on a call with no arguments.

It is inert because pkvm_selftests() sits behind the same #ifdef, but
the handler is registered either way and nothing states the rule.
errno_to_smccc(-EPERM, host_ctxt) here would write the zero, and it
may be worth saying on pkvm_call_hyp_req() that any handler reached
through it has to set x2.

Cheers,
/fuad

> +
>  static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
> @@ -648,6 +670,11 @@ static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
>         case PKVM_TOPUP_HYP_ALLOC:
>                 ret = hyp_alloc_topup(&host_mc);
>                 break;
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +       case PKVM_TOPUP_HYP_ALLOC_SELFTEST:
> +               ret = hyp_alloc_selftest_topup(&host_mc);
> +               break;
> +#endif
>         default:
>                 ret = -EINVAL;
>         }
> @@ -668,6 +695,11 @@ static void handle___pkvm_hyp_reclaim(struct kvm_cpu_context *host_ctxt)
>         case PKVM_TOPUP_HYP_ALLOC:
>                 hyp_alloc_reclaim(&host_mc, target);
>                 break;
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +       case PKVM_TOPUP_HYP_ALLOC_SELFTEST:
> +               hyp_alloc_selftest_reclaim(&host_mc, target);
> +               break;
> +#endif
>         default:
>                 ret = -EINVAL;
>         }
> @@ -804,6 +836,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_hyp_topup),
>         HANDLE_FUNC(__pkvm_hyp_reclaim),
>         HANDLE_FUNC(__pkvm_hyp_reclaimable),
> +       HANDLE_FUNC(__pkvm_hyp_alloc_selftest),
>
>         HANDLE_FUNC(__pkvm_host_share_hyp),
>         HANDLE_FUNC(__pkvm_host_unshare_hyp),
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index a82e773a1c2d..d28422f5c3d6 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -326,6 +326,22 @@ static int __init pkvm_drop_host_privileges(void)
>         return ret;
>  }
>
> +void __init pkvm_selftests(void)
> +{
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +       int ret = pkvm_call_hyp_req(__pkvm_hyp_alloc_selftest);
> +       unsigned long reclaimed;
> +
> +       reclaimed = pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC_SELFTEST, ULONG_MAX);
> +
> +       /* On failure, not all the pages may be reclaimable */
> +       if (!ret)
> +               WARN_ON(reclaimed != 6 /* SELFTEST_MAX_PAGES */);
> +       else
> +               kvm_err("pKVM hyp allocator selftest failed (%d)\n", ret);
> +#endif
> +}
> +
>  static int __init finalize_pkvm(void)
>  {
>         int ret;
> @@ -652,6 +668,9 @@ static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
>         case PKVM_HYP_REQ_HYP_ALLOC:
>                 ret = pkvm_hyp_topup(PKVM_TOPUP_HYP_ALLOC, req->mem.nr_pages);
>                 break;
> +       case PKVM_HYP_REQ_HYP_ALLOC_SELFTEST:
> +               ret = pkvm_hyp_topup(PKVM_TOPUP_HYP_ALLOC_SELFTEST, req->mem.nr_pages);
> +               break;
>         }
>
>         trace_kvm_handle_pkvm_hyp_req(req, ret);
> --
> 2.55.0.508.g3f0d502094-goog
>
