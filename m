Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A97450AC14
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 11:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954654; cv=none; b=pLsQArrpq1B6/1UU0gPFj9H8qmAXbIDkAmYmpZQ3hvaSw6IOcceNu8oJ086me1LdOht8ST0wl9f+LCdXJjNkB8ossEvrSqRJbwhQigKBV4S6VoTZwofdquNA4+BitgF+FcuvXlxgbgPwJdQGPiWWabFncMTW/fbO7i1cfzcepJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954654; c=relaxed/simple;
	bh=lhd4O74gwsv5JUZ/uKSFuctonDDlwjfg2EWm9I6bTEE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EFhw1VhEhAR55vFIx/ouRA62DnzxBHlAhVfPGnExXaVsDH2rYfW5e4XNxLyovzI9PBcYFcZUjdOpKLyq2P9TidwS0RBFvdGSBOPrB7ceZKU9imhCLdBJo1Z0gtacAySXSNF8KCGD9RUpbezM+KhQEbHL2ivY3DLwG3m48Ue4AUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VCGy49Qk; arc=none smtp.client-ip=91.218.175.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VCGy49Qk"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=lhd4O74gwsv5JUZ/uKSFuctonDDlwjfg2EWm9I6bTEE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788954650; v=1; x=1789559450;
 b=VCGy49QkUlLFMbQ27lEw+u7JD1BkPOxbnCIIV6Q6P7olQomwz2BONOh48tlNiUYSJ0ZOR/oB
 oQIjo6F5kkS7TGpi8AZdI4rL26llAN6BI62cLVZgezvR+g+Uh1CviwvFI6ba+izVTOnTM1Sk0f5
 n2Bt0ayXqb/TykHmBIm/qqOI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 47af0d5d12ceee86;
	Wed, 09 Sep 2026 11:50:50 +0000
X-Mizu-Trace-ID: 47af0d5d12ceee86
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so6000e87.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 04:50:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwL3vvmQK/dNPUeC2QCemNX/kX5p02NIghs3YP/U5CX1Iv4Ls6jV/29luCluPKW+xav+LChkKU=@lists.linux.dev
X-Gm-Message-State: AFuF++m1xZXp55A5XX2WxSVt9O0tnSrNIYy/B2zvgNplvtYpKiQIlIDO
	fHUjEWxoS8RiUPNhFrh+EL9oy9X6hOwBRpuqfmIDoGEe8I41ktOxPDKyAb0NHzK0XwaoujHnfdd
	w+0wpgNij/QlL1JxgYAkDq0L+VyumIy+c1+VK5vFJ
X-Received: by 2002:a05:6512:288:b0:5b7:78bc:ec07 with SMTP id
 2adb3069b0e04-5b778bcee15mr42626e87.14.1788954646115; Wed, 09 Sep 2026
 04:50:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260908162223.1683432-1-suzuki.poulose@arm.com> <20260908162223.1683432-19-suzuki.poulose@arm.com>
In-Reply-To: <20260908162223.1683432-19-suzuki.poulose@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 9 Sep 2026 12:50:09 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzxVTAMVkO5RaSmE72vgNpuZfX-51=46YDok+vHuwrROA@mail.gmail.com>
X-Gm-Features: AcwNN1WWLxfR9jlqCMbRmgHnokAuxADv4gMqiBhtQwGNJdoCg0QCSKPNnqFHjlI
Message-ID: <CA+EHjTzxVTAMVkO5RaSmE72vgNpuZfX-51=46YDok+vHuwrROA@mail.gmail.com>
Subject: Re: [PATCH v17 18/20] KVM: arm64: Reuse kvm_stage2_unmap_range in kvm_unmap_gfn_range
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Sept 2026 at 17:23, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> In preparation for adding VM specific backends for stage2 operation,
> switch to kvm_stage2_unmap_range() instead of __unmap_stage2_range()
> from the kvm_unmap_gfn_range(). Drop the bail out check for protected
> VMs and defer that to the one in kvm_stage2_unmap_range(). Later we
> would replace the logic in kvm_stage2_unmap_range() with VM specific
> backends.
>
> No functional changes intended.
>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/mmu.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4af..67852acf7a6f8 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2436,12 +2436,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> -       if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
> +       if (!kvm->arch.mmu.pgt)
>                 return false;
>
> -       __unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
> -                            (range->end - range->start) << PAGE_SHIFT,
> -                            range->may_block);
> +       kvm_stage2_unmap_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
> +                               (range->end - range->start) << PAGE_SHIFT,
> +                               range->may_block);
>
>         kvm_nested_s2_unmap(kvm, range->may_block);
>         return false;
> --
> 2.43.0
>
