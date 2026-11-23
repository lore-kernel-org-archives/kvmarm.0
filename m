Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795462288;
	b=4rNOf+RVjV618WhP9qPFZ2J2LVAG3AbQkL5CaGrdfkiH5VX8IWLW/W3B/0mqTEHab4uv
	 AVQsZ2pknx8lKywqB5TBBPtL9iucoe52gCeg9ZKCjfKh552pRvYkbqJAtBX0GKkVQ9HNs
	 cgWG7DGQQV6nzLGgNhbPVw5breKoPd60UaseX/diowcnaH9w8guEaLIAZOH+svAxEho/k
	 ntbnFzawsGfb4zFKhOwqMPAX32BQecOkz+gFoTxhvuYg2hJHZdYorJ9EpZZg85TvCncQb
	 or1AtqBrziKLiwUCG7c4FSPHdOTsGP4W9R36yVNpJWQj04DNgbIfYjPjkBNEfd5Nbqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795462288;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=hIyBw/Rnf4XDdCcPvUaoHh+oCwvS6/u0QmuD2Ig3thk=;
	b=g1xuXJcFCbnTs7Lv6gaZWVLjPp1S9e7ursl5IC5btr12Dqj8wtHEou3o/yWIuX1P/xCs
	 4f56aQ6pxVWEtdrU4z4PvdShwg5m7OIRXMbp+yTT87hdHmP8VldX0grE3kVIbbs4x1gn3
	 TB0kZbfV46r2hC/UlmStH7zTh3I07h5QhTVIuNCuG97inqGqkXZEkfMCJgPs1ohD0zyMa
	 FO3NevxYBXj0QO7qgSpx9tjPTCg6ABKjhYCjNFQyrFR1rRmrUB/WM7VjZNER8Pjnd+bhl
	 sYzFq4nAmYg66tt8Hpeng0YPfJT60XAaK3GhdMmi0sROs8neiQU3Fxuo5Lk7HXTGoEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mjYZ4LiX;
	arc=none smtp.remote-ip=95.215.58.195
Received: from mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC080606A31A
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 19:31:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC080606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mjYZ4LiX
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kKf0+6VXw5GQNljtgXjHRstGkHmQFT+6ySSk8HNbVuw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795462285; v=1; x=1796067085;
 b=mjYZ4LiXQpoQf1CymdJq8ut/L3GFyRejc8B6Rp5VSXvtx5/NBIF6O4p+fTRl5jSfhREWuEXq
 z08MjJlP/9I/tPC6rYGOFw0TMhPwfB6kFX5T9ptNHp8pP6eZjQdrY5X1k2ncDmcuvCkJ1ba40h1
 ZNPVVk9Z0A7nUalsU2eUpMJI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1655705257098672;
	Mon, 23 Nov 2026 19:31:25 +0000
X-Mizu-Trace-ID: 1655705257098672
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be58ad9600so16134e87.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 11:31:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHweOFfEpc8Lcl/ONixoioinxQBkOc3hmnLNAMeCpii3reOkPlIk9crr1xnC4RuQmqXYCpqc2k=@lists.linux.dev
X-Gm-Message-State: APuU4Z+nsoEo1WHVKBCLxguP5q2HjvrsBVRLK3o8oa0zUE23O6EeFJIa
	gTO6Dnbc3mNcD0mkDkGzX/H73molYBDXZTrbZ/w0nxr+yCEWC+UNBp28HpFkdc+OlHkN4zRI9hg
	7ZpAqd7d7gSJAxKLCjsbAHWv9Pu2MwHdGCtMEYoYH
X-Received: by 2002:a05:6512:6c3:b0:5c1:6063:cd75 with SMTP id
 2adb3069b0e04-5c1c8052873mr300301e87.0.1795462280355; Mon, 23 Nov 2026
 11:31:20 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com> <20261117174403.58762-9-vdonnefort@google.com>
In-Reply-To: <20261117174403.58762-9-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 23 Nov 2026 19:30:44 +0000
X-Gmail-Original-Message-ID: <CA+EHjTy5fjJcFAYfxYeG2aAAuwbSwXrkzK+3tiVNag-wNmiKCw@mail.gmail.com>
X-Gm-Features: Aa3M54omcjaQ9NPsG0-ifI_vW3LHFs3kfGStDJpu6bzStGYmSDLTwYfW8RlpE7Y
Message-ID: <CA+EHjTy5fjJcFAYfxYeG2aAAuwbSwXrkzK+3tiVNag-wNmiKCw@mail.gmail.com>
Subject: Re: [PATCH v4 08/23] KVM: arm64: Add a range to __pkvm_host_donate_guest()
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com, weilin.chang@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Tue, 17 Nov 2026 17:43:47 +0000, Vincent Donnefort
<vdonnefort@google.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index f7d249d35f50..ed82cbe973ad 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1452,22 +1452,30 @@ static int __guest_check_pgtable_memcache(struct pkvm_hyp_vcpu *vcpu)
>          return 0;
>  }
>

Could you update the comment above __guest_check_pgtable_memcache()? It
says only share installs a block, and donate does too now.

Cheers,
/fuad

On Tue, 17 Nov 2026 at 17:44, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> In preparation for supporting stage-2 huge mappings for protected VMs,
> add a nr_pages argument to the __pkvm_host_donate_guest() hypercall.
> This range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is
> 512 on a 4K-pages system).
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> ---
>  arch/arm64/include/asm/kvm_hcall.h            |  2 +-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  4 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 48 +++++++++++--------
>  arch/arm64/kvm/pkvm.c                         |  2 +-
>  5 files changed, 33 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
> index 64d18b7f2392..c47ee2653110 100644
> --- a/arch/arm64/include/asm/kvm_hcall.h
> +++ b/arch/arm64/include/asm/kvm_hcall.h
> @@ -221,7 +221,7 @@ DECLARE_KVM_HOST_HCALL(int, __pkvm_host_share_hyp,
>  DECLARE_KVM_HOST_HCALL(int, __pkvm_host_unshare_hyp,
>         u64, pfn)
>  DECLARE_KVM_HOST_HCALL(int, __pkvm_host_donate_guest,
> -       u64, pfn, u64, gfn)
> +       u64, pfn, u64, gfn, u64, nr_pages)
>  DECLARE_KVM_HOST_HCALL(int, __pkvm_host_share_guest,
>         u64, pfn, u64, gfn, u64, nr_pages, u64, prot)
>  DECLARE_KVM_HOST_HCALL(int, __pkvm_host_unshare_guest,
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index ec0bf9dff899..b04cedaf4ec6 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -39,7 +39,7 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
>  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> -int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
> +int __pkvm_host_donate_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu);
>  int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu);
>  int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys);
>  int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 853dad542597..4f420718ca6a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -965,7 +965,7 @@ static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
>  }
>
>  DEFINE_KVM_HOST_HCALL(int, __pkvm_host_donate_guest,
> -       u64, pfn, u64, gfn)
> +       u64, pfn, u64, gfn, u64, nr_pages)
>  {
>         struct pkvm_hyp_vcpu *hyp_vcpu;
>         int ret;
> @@ -978,7 +978,7 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_host_donate_guest,
>         if (ret)
>                 return ret;
>
> -       return __pkvm_host_donate_guest(pfn, gfn, hyp_vcpu);
> +       return __pkvm_host_donate_guest(pfn, gfn, nr_pages, hyp_vcpu);
>  }
>
>  DEFINE_KVM_HOST_HCALL(int, __pkvm_host_share_guest,
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index f7d249d35f50..ed82cbe973ad 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1452,22 +1452,30 @@ static int __guest_check_pgtable_memcache(struct pkvm_hyp_vcpu *vcpu)
>         return 0;
>  }
>
> -int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
> +int __pkvm_host_donate_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu)
>  {
>         struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
>         u64 phys = hyp_pfn_to_phys(pfn);
>         u64 ipa = hyp_pfn_to_phys(gfn);
> +       u64 size;
>         u64 meta;
>         int ret;
>
> +       if (!pfn_range_is_valid(pfn, nr_pages))
> +               return -EINVAL;
> +
> +       ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
> +       if (ret)
> +               return ret;
> +
>         host_lock_component();
>         guest_lock_component(vm);
>
> -       ret = __host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_OWNED);
> +       ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
>         if (ret)
>                 goto unlock;
>
> -       ret = __guest_check_page_state_range(vm, ipa, PAGE_SIZE, PKVM_NOPAGE);
> +       ret = __guest_check_page_state_range(vm, ipa, size, PKVM_NOPAGE);
>         if (ret)
>                 goto unlock;
>
> @@ -1476,9 +1484,9 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
>                 goto unlock;
>
>         meta = host_stage2_encode_gfn_meta(vm, gfn);
> -       WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
> +       WARN_ON(host_stage2_set_owner_metadata_locked(phys, size,
>                                                       PKVM_ID_GUEST, meta));
> -       WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> +       WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
>                                        pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
>                                        &vcpu->vcpu.arch.stage2_mc, 0));
>
> @@ -1820,7 +1828,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
>         assert_transition_res(-EPERM,   hyp_pin_shared_mem, virt, virt + size);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
>         assert_transition_res(-ENOENT,  __pkvm_host_unshare_guest, gfn, 1, vm);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
>
>         selftest_state.host = PKVM_PAGE_OWNED;
>         selftest_state.hyp = PKVM_NOPAGE;
> @@ -1840,7 +1848,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
>         assert_transition_res(-EPERM,   __pkvm_hyp_donate_host, pfn, 1);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
>         assert_transition_res(-ENOENT,  __pkvm_host_unshare_guest, gfn, 1, vm);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
>
>         assert_transition_res(0,        hyp_pin_shared_mem, virt, virt + size);
>         assert_transition_res(0,        hyp_pin_shared_mem, virt, virt + size);
> @@ -1853,7 +1861,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
>         assert_transition_res(-EPERM,   __pkvm_hyp_donate_host, pfn, 1);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
>         assert_transition_res(-ENOENT,  __pkvm_host_unshare_guest, gfn, 1, vm);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
>
>         hyp_unpin_shared_mem(virt, virt + size);
>         assert_page_state();
> @@ -1873,7 +1881,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
>         assert_transition_res(-EPERM,   __pkvm_hyp_donate_host, pfn, 1);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
>         assert_transition_res(-ENOENT,  __pkvm_host_unshare_guest, gfn, 1, vm);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
>         assert_transition_res(-EPERM,   hyp_pin_shared_mem, virt, virt + size);
>
>         selftest_state.host = PKVM_PAGE_OWNED;
> @@ -1890,7 +1898,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
>         assert_transition_res(-EPERM,   __pkvm_host_share_hyp, pfn, 1);
>         assert_transition_res(-EPERM,   __pkvm_host_unshare_hyp, pfn, 1);
>         assert_transition_res(-EPERM,   __pkvm_hyp_donate_host, pfn, 1);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
>         assert_transition_res(-EPERM,   hyp_pin_shared_mem, virt, virt + size);
>
>         selftest_state.guest[1] = PKVM_PAGE_SHARED_BORROWED;
> @@ -1906,9 +1914,9 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
>
>         selftest_state.host = PKVM_NOPAGE;
>         selftest_state.guest[0] = PKVM_PAGE_OWNED;
> -       assert_transition_res(0,        __pkvm_host_donate_guest, pfn, gfn, vcpu);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
> +       assert_transition_res(0,        __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
>         assert_transition_res(-EPERM,   __pkvm_host_share_ffa, pfn, 1);
> @@ -1921,8 +1929,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
>         selftest_state.guest[0] = PKVM_PAGE_SHARED_OWNED;
>         assert_transition_res(0,        __pkvm_guest_share_host, vcpu, gfn);
>         assert_transition_res(-EPERM,   __pkvm_guest_share_host, vcpu, gfn);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
>         assert_transition_res(-EPERM,   __pkvm_host_share_ffa, pfn, 1);
> @@ -1935,8 +1943,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
>         selftest_state.guest[0] = PKVM_PAGE_OWNED;
>         assert_transition_res(0,        __pkvm_guest_unshare_host, vcpu, gfn);
>         assert_transition_res(-EPERM,   __pkvm_guest_unshare_host, vcpu, gfn);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
>         assert_transition_res(-EPERM,   __pkvm_host_share_ffa, pfn, 1);
> @@ -1948,19 +1956,19 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
>         selftest_state.host = PKVM_PAGE_OWNED;
>         selftest_state.guest[0] = PKVM_POISON;
>         assert_transition_res(0,        __pkvm_host_force_reclaim_page_guest, phys);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
>         assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn);
>         assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn);
>
>         selftest_state.host = PKVM_NOPAGE;
>         selftest_state.guest[1] = PKVM_PAGE_OWNED;
> -       assert_transition_res(0,        __pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
> +       assert_transition_res(0,        __pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
>
>         selftest_state.host = PKVM_PAGE_OWNED;
>         selftest_state.guest[1] = PKVM_NOPAGE;
>         assert_transition_res(0,        __pkvm_host_reclaim_page_guest, gfn + 1, vm);
> -       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
> +       assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
>         assert_transition_res(-EPERM,   __pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
>
>         selftest_state.host = PKVM_NOPAGE;
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 29e7a51a1c03..d1acdca0254f 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -594,7 +594,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>                         return ret ? -EFAULT : -EAGAIN;
>                 }
>
> -               ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn);
> +               ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn, 1);
>         } else {
>                 if (WARN_ON_ONCE(size != PAGE_SIZE && size != PMD_SIZE))
>                         return -EINVAL;
> --
> 2.56.1.708.g77570a6a1d-goog
>
