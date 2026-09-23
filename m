Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761BB405C48
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790187950; cv=none; b=ERD9izH2z4ttr32OcBfNMuOGEpuHnRPBLWaeXY8o5mnI/Js6wQAgDX7f4NfFEsQJ/KVPx0sDt4I/NobFQVA1ZCdD7jlZqfiuLmAQnhCdXLaNVT/U+095A3NlWpPCP5/0PB2gLtp0hPZHWK2Sm6fO99MEfnr1g2ahiLtm47Rmd+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790187950; c=relaxed/simple;
	bh=mMdmK/9FycFUxVc3A/OffoN2VrdlqvuqAa1VcwPdc94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GtHMXWBFKOeKTAdjZwR2euZN4aAnIXbArya4Dmf5cw03e+WbMhuHWjWiB4aqN+aai7Dyf3XpQZfbJLLhY4cL7liFm08hjiXQVJgH/lMQ83jZjVrYmWm5ym/SlvUOaIykjgx5237KOi77czSEAl6xtCoDuUhD7+ALWdAFD2NuUB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eJ1XfGk3; arc=none smtp.client-ip=91.218.175.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eJ1XfGk3"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=mMdmK/9FycFUxVc3A/OffoN2VrdlqvuqAa1VcwPdc94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790187942; v=1; x=1790792742;
 b=eJ1XfGk3ANgszo41ajHMCLCVS28b2gw7Ht9qGMnWrcjVdnC4OylhneUk7FtWNnuv/7ybvkYw
 41kpJFl7bzevcqONiVQ5XAAnVjxiBRJG+T3uV3wafGXmOzShR7Unu9ytYfGRwqmQGCqAJT2x/Sh
 4FUwsTSW9ny3y/iQ3NO4dZwA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6e96863456ac1166;
	Wed, 23 Sep 2026 18:25:42 +0000
X-Mizu-Trace-ID: 6e96863456ac1166
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b83c1421ecso1027e87.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 11:25:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxlNaq9t/8DJR0mok3IFbGfkUtE+x4VOO4GCQGBn9GLuwdfYiAjaTbxMraGFVw3CvmLx7VnUJI=@lists.linux.dev
X-Gm-Message-State: AFuF++mT5iBS+u332inDPf6a+it78Q7BhFsdKq2zMXX0RFp8OeVs5Iq+
	vd6JHu0CpwfUF5O5GEWo62x+154cRuSOV/ZekRufY9w3O/vI4LQydVocUclws3S5Ukjg9zjaVL1
	A6xjnOb6wq/wvQ+w+tAItr02lAiz6Hs8B1Ske9rA0
X-Received: by 2002:a05:6512:3dac:b0:5b8:9d6d:21b3 with SMTP id
 2adb3069b0e04-5b8dda16235mr43733e87.6.1790187937034; Wed, 23 Sep 2026
 11:25:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260923-kvm-arm-prefault-v4-0-d4b0b4dfa8c3@kernel.org> <20260923-kvm-arm-prefault-v4-6-d4b0b4dfa8c3@kernel.org>
In-Reply-To: <20260923-kvm-arm-prefault-v4-6-d4b0b4dfa8c3@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 23 Sep 2026 19:25:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy0TtqA=7d_H8MJPrjSC8LorA8eAoQV2iNq92vyhc4MDA@mail.gmail.com>
X-Gm-Features: AclHuK-RIUiERhmleh7yaYY2uX18OLxNzJklGSRzD4NKIMEsTg5kd5iC90vfRLg
Message-ID: <CA+EHjTy0TtqA=7d_H8MJPrjSC8LorA8eAoQV2iNq92vyhc4MDA@mail.gmail.com>
Subject: Re: [PATCH v4 06/14] KVM: arm64: Propagate and use
 kvm_s2_fault_result on S2 fault
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
	Jack Thomson <jackabt.amazon@gmail.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Sept 2026 at 16:17, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> When stage 2 page tables fault the net result may either be that a page is
> mapped, an error occurred or the fault should be retried (-EAGAIN).
>
> When a fault succeeds it may be upgraded to a PMD size via
> transparent_hugepage_adjust().
>
> In order to support KVM pre-faulting the outcome of the fault and the
> mapping size must be recorded.
>
> Track the mapping size via new kvm_s2_fault_result struct, which is
> threaded through gmem_abort(), user_mem_abort() and kvm_s2_fault_map().
>
> PKVM and SEA aren't relevant to synthetic pre-faulting so neither
> kvm_inject_sea() nor pkvm_mem_abort() are altered.
>
> Actual hardware faulting doesn't require this information, so
> kvm_handle_guest_abort() simply passes NULL kvm_s2_fault_result to
> gmem_abort() and user_mem_abort().
>
> A non-NULL result also tells the abort handlers that the caller is
> pre-faulting rather than a vcpu, in which case -EAGAIN is propagated to the
> caller to allow the pre-fault to be retried.
>
> Likewise, only prepare a KVM_EXIT_MEMORY_FAULT in gmem_abort() when a real
> fault is being handled, as this updates vcpu state.
>
> No functional change intended.
>
> Suggested-by: Vincent Donnefort <vdonnefort@google.com>
> Reviewed-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c | 43 +++++++++++++++++++++++++++++++------------
>  1 file changed, 31 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9d799f7c1e62..ee2a4f0faa14 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1659,6 +1659,10 @@ struct kvm_s2_fault_desc {
>         struct kvm_s2_mmu       *mmu;
>  };
>
> +struct kvm_s2_fault_result {
> +       unsigned long mapping_size;
> +};
> +
>  static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
>  {
>         return esr_fsc_is_permission_fault(s2fd->esr);
> @@ -1684,7 +1688,8 @@ static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
>         return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
>  }
>
> -static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> +static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
> +                     struct kvm_s2_fault_result *result)
>  {
>         bool write_fault, exec_fault;
>         bool perm_fault = kvm_s2_fault_is_perm(s2fd);
> @@ -1728,8 +1733,10 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>
>         ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
>         if (ret) {
> -               kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
> -                                             write_fault, exec_fault, false);
> +               /* If result is non-NULL this is a synthetic fault. */
> +               if (!result)
> +                       kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
> +                                                     write_fault, exec_fault, false);
>                 kfree(mapping);
>                 return ret;
>         }
> @@ -1784,7 +1791,13 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>         if ((prot & KVM_PGTABLE_PROT_W) && !ret)
>                 mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
>
> -       return ret != -EAGAIN ? ret : 0;
> +       if (ret == -EAGAIN)
> +               return result ? ret : 0;
> +
> +       if (result && !ret)
> +               result->mapping_size = PAGE_SIZE;
> +
> +       return ret;
>  }
>
>  struct kvm_s2_fault_vma_info {
> @@ -2108,7 +2121,8 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>  static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                             const struct kvm_s2_fault_vma_info *s2vi,
>                             enum kvm_pgtable_prot prot,
> -                           void *memcache)
> +                           void *memcache,
> +                           struct kvm_s2_fault_result *result)
>  {
>         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>         struct kvm_guest_s2_mapping *mapping = NULL;
> @@ -2209,12 +2223,17 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                 mark_page_dirty_in_slot(kvm, s2fd->memslot,
>                                         gpa_to_gfn(canonical_ipa));
>
> -       if (ret != -EAGAIN)
> -               return ret;
> -       return 0;
> +       if (ret == -EAGAIN)
> +               return result ? ret : 0;
> +
> +       if (result && !ret)
> +               result->mapping_size = mapping_size;
> +
> +       return ret;
>  }
>
> -static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> +static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
> +                         struct kvm_s2_fault_result *result)
>  {
>         bool perm_fault = kvm_s2_fault_is_perm(s2fd);
>         struct kvm_s2_fault_vma_info s2vi = {};
> @@ -2253,7 +2272,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>                 return ret;
>         }
>
> -       return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache);
> +       return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
>  }
>
>  /* Resolve the access fault by making the page young again. */
> @@ -2532,9 +2551,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>                                 !kvm_s2_fault_is_exec(&s2fd));
>
>                 if (kvm_slot_has_gmem(memslot))
> -                       ret = gmem_abort(&s2fd);
> +                       ret = gmem_abort(&s2fd, NULL);
>                 else
> -                       ret = user_mem_abort(&s2fd);
> +                       ret = user_mem_abort(&s2fd, NULL);
>         }
>
>         if (ret == 0)
>
> --
> 2.55.0
>
