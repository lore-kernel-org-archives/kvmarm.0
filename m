Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F65EEA8
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 16:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767715328; cv=pass; b=XQezAEoGO7TSqBKoi43HNQrEQEkjlxFipiwsWG4it1TvrpCI8+LB8X+XwR1v+mgYrso5ldHxcMQsqTmxOZO1/VnGl641jMOioS9xEkHr2Q6s5Hc7EaNRX3d1T9phaNJldspXgoyTFwWmpHqqS83uhRAXepUXEP+q+MmgZlp5xSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767715328; c=relaxed/simple;
	bh=Bbx6kybqDTyLUdOd+QGJdlDjxR+Gxq/E2JorMYNy69M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IIsU+YK0ke6plQFZcoZ9XTB+7qa/AjdQ/Y9B93VxJIq9pXswbXyuLKZ644pjlLOOsgP/XJrYAQj2Rijlfgxfk049ytsAGDeJ7VH8/1yUc+5+bkdRymJgWEQkCELI1QTcsBv0WuEP5le8E4OCdxK96KHPSmPmLhSL0xsFQORkUMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bubQZn9l; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bubQZn9l"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee147baf7bso472471cf.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 08:02:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767715326; cv=none;
        d=google.com; s=arc-20240605;
        b=KW2X2n40JP7eaFkpllxk0dr6an2BFy2LodCBRNWuDmEuDLBO6vpjkFM4EoGLNYVVPq
         pRHOx1l7YX4/4j8ljASAKY2a4pFhXJw2cETXzeevhymQCnZw4vY3icW2tt5SiNeCb5wA
         dUOkjy6dSKermKTmMOWHO6k8reAqFEcZineuIwoJtkawqnCyRGRMiHaB0e3IKd2F9vqH
         8HVFgAZHizrupq0na5eKp4i+f1IMHl61cWq4S3PkdBQLm5IxdioYBLPd1QiEYwQBdWms
         a9aineabRpGoDUdqkRr8w9NOy0C3/0q3NB0Vjwbg5m/pMT69VYKR5+iMJI8DNsUXbh1y
         FpjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4VV8FamiqOwZAM5+PYXtFxVyVObmz3z5a4+8kZS6YUk=;
        fh=OsVEnhpHfDtKQejlv1Bgs/tZPAfr3IJ2Ck5WUUi92Sc=;
        b=ef6tXk9K479wv4aHXEkn9e2KG/5V9VCd+9rvhfhQeEwvZEC15iBSagCoKkQUT0yksm
         JTKk0w8tcAUd7+Y2i47rQey3o5D9QQ3W8eBT2EIcoQGr5kf4u1xucg9jEuO9mD0Mvc3W
         +TThxn4Skn8B2SNPmqhwJIr10uiCoqAKver3h1ticw8QMcjT8dk2HrOnoqTbEl4iMzcp
         OlK8650tTYMrmB9V5ZqWRWa/pgIl4g5NEQYojcg+seEdOPGq1HB1R73k+M/6ZxcRmN/h
         03+FppUu12xYZh9IvvGzFG4jCgE1i+sXEZzjvGK2SCyADkAZqvADlsM3BOYp20+/0cDi
         Lg6A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767715326; x=1768320126; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4VV8FamiqOwZAM5+PYXtFxVyVObmz3z5a4+8kZS6YUk=;
        b=bubQZn9lfvQviVupOkryWbzboK7DJl4XPb72exDf6W21p9Atx/HAU7u1/wmp6x9cVD
         AS73vNF4gnosq+wdMBF1a+d9Z3ZxwNR6QSLRoQ9bJZM8tZw9PjzUNJt9+e0DFTGButtQ
         +asQ/5t269CUnKurxAJC22E6bSc0zeIgClul8ELnN+M/IbZ4VWF/i8YKpt9EtcJbcdDT
         kyjUzEhgAZh39xebZgHmQHEeEt0LML19CDCLwsvPMNfTwQ9kh6fmQcplD3tE99gCJTEF
         m5eUpq4w6RhEjrB5QiGnO5hq4UAM5qAs39Nx7VVsAawKnEaX4tM10ZHDknxZGPdWXaXf
         PHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767715326; x=1768320126;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4VV8FamiqOwZAM5+PYXtFxVyVObmz3z5a4+8kZS6YUk=;
        b=d/7Mr+Y0546p7g9SBE8O9QiJxhCnDOeduvPA5BsVLv4qygLfJb6h7pcHfMcQIKK5fW
         DqofSSNW0G0LiHuaLozhjCZqKvWJHJGrQyNPwn2rMQebRFxLpyS+WWpvRnxLpOnwLrDR
         6O4/SDPj5Gx2IxeYyU3OWlkAD1tKCUrj1V7GTyCisTF/QdxvHJc74Olc9ClP9PNpSFek
         bMuCTjDoNUTmzOuZxoR3CnuwKsMqhbw2hOp4mgH4z5fwpAJET646yMx0ys0PK3n72Hao
         Aqy2dS9HR+UJ+8+Ygn0kv008AGAHi233zuAWuz9QCrVjbNeMXAAmrn839nu5D9l2OwQa
         sGzQ==
X-Gm-Message-State: AOJu0YwO7gMX7A5K7YnwzfIxHbFPfxjzBmkOslKV9pp0eGKTfXhsiJB/
	14gbTiqPrgH8LU8lQPSs43i7yzfKpTeCpPZnq/EAZ5y2VGJIC4Hd5gR0OjgJc1mjNO8/STogXym
	iymUaUynZBeNWcZ0ix58n+QVXmiAuCSzI9yAeGI1x
X-Gm-Gg: AY/fxX6Fxyio87m0Pk3sjbOkalVDzkIXm30523brme98BdsyYGHKWxlxd3W6Pu9FAlG
	g6yGR9YXk5+OrK4vjOmD8kygBldw+L58duCsanGcm9kHcwEu9yrtGB5zTxiWXEbYRYPeFE8Egrt
	mijrA2JVGcjUXj3+F4lfuJdT6KgRKmt8Ls6BdIgibFgAJrCb/6T6dwz+F/K12jOACEqTw+7/aih
	mtL1MurR0Prexlc36ZWeDBSxIUD4HeGgZD1LrbWZAjV63owbNfJ+aS40EdDA6tX0B088Xfo
X-Google-Smtp-Source: AGHT+IHxG68k4H7QxOCqcUestNOdt2ymq6k/B9L/EOR9jHs12J8OklAbo9pVNZdm2PJbf3+p7kEjNGC1B4QDwRgIwpM=
X-Received: by 2002:a05:622a:355:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-4ffa96218abmr6005851cf.9.1767715325130; Tue, 06 Jan 2026
 08:02:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260105154939.11041-1-will@kernel.org> <20260105154939.11041-20-will@kernel.org>
In-Reply-To: <20260105154939.11041-20-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 6 Jan 2026 16:01:28 +0000
X-Gm-Features: AQt7F2p9bIGiuS3iUUJfep_yOAaw5pVkKkYP_KCrIopHGcAfqqtRaJGG_En4JyE
Message-ID: <CA+EHjTzNcTOR5sZpBTUXUP++yqOZEvmfs=S3wqBTG-YT=hxoKQ@mail.gmail.com>
Subject: Re: [PATCH 19/30] KVM: arm64: Annotate guest donations with handle
 and gfn in host stage-2
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Mon, 5 Jan 2026 at 15:50, Will Deacon <will@kernel.org> wrote:
>
> Handling host kernel faults arising from accesses to donated guest
> memory will require an rmap-like mechanism to identify the guest mapping
> of the faulting page.
>
> Extend the page donation logic to encode the guest handle and gfn
> alongside the owner information in the host stage-2 pte.
>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 7d1844e2888d..1a341337b272 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1063,6 +1063,19 @@ static void hyp_poison_page(phys_addr_t phys)
>         hyp_fixmap_unmap();
>  }
>
> +#define KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK GENMASK(15, 0)
> +#define KVM_HOST_INVALID_PTE_GUEST_GFN_MASK    GENMASK(56, 16)
> +static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
> +{
> +       pkvm_handle_t handle = vm->kvm.arch.pkvm.handle;
> +
> +       WARN_ON(!FIELD_FIT(KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK, handle));

Instead of (or in addition to) this check, should we also have a
compile time check to ensure that the handle fits? We have
KVM_MAX_PVMS and HANDLE_OFFSET, albeit HANDLE_OFFSET, so we can
calculate whether it fits.

Cheers,
/fuad

> +       WARN_ON(!FIELD_FIT(KVM_HOST_INVALID_PTE_GUEST_GFN_MASK, gfn));
> +
> +       return FIELD_PREP(KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK, handle) |
> +              FIELD_PREP(KVM_HOST_INVALID_PTE_GUEST_GFN_MASK, gfn);
> +}
> +
>  int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
>  {
>         u64 ipa = hyp_pfn_to_phys(gfn);
> @@ -1105,6 +1118,7 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
>         struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
>         u64 phys = hyp_pfn_to_phys(pfn);
>         u64 ipa = hyp_pfn_to_phys(gfn);
> +       u64 meta;
>         int ret;
>
>         host_lock_component();
> @@ -1118,7 +1132,9 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
>         if (ret)
>                 goto unlock;
>
> -       WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_GUEST));
> +       meta = host_stage2_encode_gfn_meta(vm, gfn);
> +       WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
> +                                                     PKVM_ID_GUEST, meta));
>         WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
>                                        pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
>                                        &vcpu->vcpu.arch.pkvm_memcache, 0));
> --
> 2.52.0.351.gbe84eed79e-goog
>
