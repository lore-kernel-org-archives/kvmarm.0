Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A443F58D9
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 11:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790161551; cv=none; b=PfFaYyyRrfRGxuOb/lWYEsc1YLKMU38QVP/yDcHv5BsnbMiP1pvx57/keCUk8LaDL9p3zq7tPgy9tl4vtfiUznQXq1uHh+/yxbXg5kni8SIGNKJ3wD2JHC0Q0SHMID44aqLR6IEkdQ+98bfZnCxXc7N8p5KLuq/xhfB8OQ8Z3Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790161551; c=relaxed/simple;
	bh=kHep/UoJdFlSFtMOk5eTsBvsgTZFrj+duqNAdJba03Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sSR18lbMSpFUgU5W0arE96voo2pY5T0/LgvZkCiYY+zpyMQhYDY7eXk4K10AYltV3sIRIufPx2/yntV/2AKPQ9KSHk9A1BaLNCyiVtP/1uLb82vauHrBRs/JUzYE56U87+x1nfjj35XBNpY5gxo2+/D04d/pDnMjxpjkw6HBYsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RTGNwolr; arc=none smtp.client-ip=95.215.58.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RTGNwolr"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kHep/UoJdFlSFtMOk5eTsBvsgTZFrj+duqNAdJba03Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790161541; v=1; x=1790766341;
 b=RTGNwolrSTn3AaT1z/UmkVn1a/oJwl/XgsAKc6Fj4TELbcq1BMybqPHlYE1oS13fFoWge9cG
 lTxYPdwyegZs3CN5my9gY4Yk6dUs3oMaPWlCTDW9uBesPL2MBydgo0gY+j0CPixKamwlBnS7oOC
 lKBPNOhtLe1svCR1JNpg0268=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 90a998802a2108a9;
	Wed, 23 Sep 2026 11:05:41 +0000
X-Mizu-Trace-ID: 90a998802a2108a9
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b83c1421ecso4521e87.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 04:05:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwfNfFQM/CqzNZXMcOItrs382wACEt6cRAUeRiW/nCbqPHRB8vzhDil5CWf6wioFa6nvkF/dGM=@lists.linux.dev
X-Gm-Message-State: AFuF++lPJi+g4/rNvXMQN5kDfrgT3UOotYiKlF4PI7Xs/T7voulrpxbg
	48O6571dZdnjXHNCQJwv0eBrBWeJ10YE36da1mswg7uuMMz3DIYhcxipfNUDwWBNKlwj7ZXNYb/
	7P3ryaKJ3uViLL5YdzR5VAEj8yng0JR9A+jyuUMPn
X-Received: by 2002:ac2:4c54:0:b0:5b8:cc2e:2fe6 with SMTP id
 2adb3069b0e04-5b8d915cbe7mr97644e87.5.1790161539952; Wed, 23 Sep 2026
 04:05:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org> <20260922-kvm-arm-prefault-v3-8-787bd3bc7e3f@kernel.org>
In-Reply-To: <20260922-kvm-arm-prefault-v3-8-787bd3bc7e3f@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 23 Sep 2026 12:05:03 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwSRAGe4iP2E2V=b+baQ_GRYpYoNzJSft385m9E5RvEMg@mail.gmail.com>
X-Gm-Features: AcwNN1Xp8lA6R1poRNOfE-88mv5Px32o87Y3m3XsUHw9H9Pq7uMPdjPzqDpKw3o
Message-ID: <CA+EHjTwSRAGe4iP2E2V=b+baQ_GRYpYoNzJSft385m9E5RvEMg@mail.gmail.com>
Subject: Re: [PATCH v3 08/14] KVM: arm64: Propagate EHWPOISON in kvm_s2_fault_pin_pfn()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Sept 2026 at 15:19, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> Currently kvm_s2_fault_pin_pfn() handles a poisoned page directly by
> sending a SIGBUS signal itself.
>
> This is an odd place to do it, the caller should decide what to do with
> errors, so move the handling to the sole caller, user_mem_abort().
>
> This lays the foundation for stage 2 pre-faulting which, arising from a
> synthetic fault, should not send a signal.
>
> In order to do so, check to see if user_mem_abort()'s caller has set result
> - i.e. whether it wants to be informed about the outcome of the fault
> handling.
>
> If it does, then it is implied that it should handle the -EHWPOISON error
> itself. This is the case for pre-faulting.
>
> Otherwise this is real hardware, so send the signal.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 221ea069f9bb..2576b967d20e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2016,10 +2016,8 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
>                                       kvm_s2_fault_is_write(s2fd) ? FOLL_WRITE : 0,
>                                       &s2vi->map_writable, &s2vi->page);
>         if (unlikely(is_error_noslot_pfn(s2vi->pfn))) {
> -               if (s2vi->pfn == KVM_PFN_ERR_HWPOISON) {
> -                       kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
> -                       return 0;
> -               }
> +               if (s2vi->pfn == KVM_PFN_ERR_HWPOISON)
> +                       return -EHWPOISON;
>                 return -EFAULT;
>         }
>
> @@ -2261,6 +2259,13 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
>          * get block mapping for device MMIO region.
>          */
>         ret = kvm_s2_fault_pin_pfn(s2fd, &s2vi);
> +       if (ret == -EHWPOISON) {
> +               /* If result is specified, let the caller handle this. */
> +               if (result)
> +                       return -EHWPOISON;
> +               kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi.vma_pagesize));
> +               return 0;
> +       }
>         if (ret != 1)
>                 return ret;
>
>
> --
> 2.55.0
>
