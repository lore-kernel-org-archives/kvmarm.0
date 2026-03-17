Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE163D5247
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 13:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773755749; cv=pass; b=uY/kcYccpETZYvpglix/gnZUmLalqwfUPJ2QffDS/4D8RnBeueZVzCuylyOmeozY15fVjc7yMga9RcMydMIFWBfBLV7v8iQNnGerutqTsakn8PJbmoq7tMZvZDSalcSed7+CKDcfh79pWRvls1oVG/UXNaousH7/ZFQ98WW5l0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773755749; c=relaxed/simple;
	bh=tIm9dAB/BHgjshrtsynn9rZvl/deSAmh0r+EUEiKlTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IxtFwn1VYJNxO3OpYy7JvIf00QLXSk4EY4H6tkU6LVWndkQaTGkqAqdK6e7bbM6UgJ6+Allzv3yd7Ck2bpBuRSDxIsCKrSyGBphUTdn7xEuehzKgEUZlW4f7M9W7OdCICzIgYgZdhz89nw8XoqKHbsq9lpbfKxYfHz+JDLM+bkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NHh30A1v; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NHh30A1v"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-509062d829dso514431cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 06:55:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773755747; cv=none;
        d=google.com; s=arc-20240605;
        b=RBByZdNGQX1rX9fytLUDq24wQMSgnxpRqm46OYv+o4mr2l2CCZO3ufcf7aApDlmmLj
         QCK23lQV0k4dWDBPnfVlHE42ew8qRzSNXWFonV7fogAbXwI5V1t00ZXNPUB0cSKUGd9z
         GvCw6Aog0G4lbQy78yNzI47Oj368KmkfM3oMqnE7SAHSNgUZWVcxjX+M3sjG6Se2U4pb
         FbwHac9wcjgGPLsm0SjfTyFv8rtce8mW9AXhuvcycmTr5vYntS9DSXK9j1mbSXJ4zdTf
         8XP5XWqz3/vbgYqBeT1ZDOat5lXamdws8fyQ9pzbq+zw/7YEOoTMN8jIPKc+foW72Dbw
         x+oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QQnRDSt6fhx6qZCPagnHsoKy2Gq1xtg11v45i8dRbO8=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=UXUwP8tSJSvIGJv9cCZXbqnBe+9Bbtq2hbDvRCmnJmuDT0ZZcxOGtG5DOm+2ngnIXq
         KtW7rOlzzsaYKWW6F8vSKQcpEkYSPoqmYDyI44ct83nbX2A7WtALVvkX7MMikGrR0/1F
         zj4Nc1jgcCmDH1nBj8g4Qikusppbf0qIRvtxXiFXBQTNE7E8YH0YRyv0Tag4I2F3s+4N
         6pP5f6JSwAnq0Gx5QeN3TpKKb3SrO5RiDtuuuqeMEY7t5/oA8727J5uA7gN2JVeQ4h6A
         NqC5omXjO3VCWBGCnWt++VTGeytJHJU0Cwz9sK7rw2kD0hHvUEB15QSIhHWvsvrpI70x
         16bg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773755747; x=1774360547; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QQnRDSt6fhx6qZCPagnHsoKy2Gq1xtg11v45i8dRbO8=;
        b=NHh30A1v+4k90tKuyF1H7dFaIM01OBqdhCtuvXwBLIKEJmv4I6DZK0a88w+TMZKkMM
         4oM8d8NXzBEfJf/urAU0kLklDssWWAlODE6KuYNGJNQm3OPjpO35NpAtvUo/4dnsdy4q
         Q8NTsi4/t8AiQYV5gCDwoZwfWq51Tl4CIvNV6gmXxHe/tRypc1ADbljb9zkCO+5GRRtC
         o43M0FICWwy43TYclbIsKF3HFqM7VUyzpbfS43koZW19o3+R0MUI9fjI3ktMD6AOsFLT
         mbNc/WHfeXftIxe4Ez/tk2jpzj96U3YEBfgAlBwB5P4KH+/A0zdJvrD741dxGSE1lkAL
         M3vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773755747; x=1774360547;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQnRDSt6fhx6qZCPagnHsoKy2Gq1xtg11v45i8dRbO8=;
        b=YdnGht1hsjBYZOo94k/b5ZXbsTOFZbcBJWYSlWimTdIp53bxv/om1UBVjQHZObYhPs
         92eDdXYCc58HLzNCkxqowbYgrUUTKiGF1CeyvUPAik4vAWSMjn7buk0UEibT58175ipN
         5f9MT9m96g4HBmhYkDW2R2mN5ED52ggkKPBvVyIZDNUUi5ubQ8AMv6I1w+yckRwueFyI
         NUmLoVd8/mtrLI6VVdv5V1Qb2llETJgL6BxprK1EGZEXkN9IGJ7Kpz3kNHNksiTGQTnu
         RcrFBRWPdBXR0X2u/4EgURbQ6vZ87Vq7t/ldcUHX91cYkoLWe6AjiTmWe5YLT0RftSjt
         UkjQ==
X-Gm-Message-State: AOJu0Yxnh0o+VTbMDIOLbu+7XgK+Q8bJJeBNSevUnMDFBpp6sE2XDBnd
	wZh8ergJyZ+/IDFRbYuh59zAsJh8quo4HjpXBk4gLVfElKdrCTcUUWZeBl5XVxTdJfh/agHWuhN
	TDmekVij+64j5ohETVR1lOK7YcxRO2oNf9ufdLlaH
X-Gm-Gg: ATEYQzxYbMHEYismmGJyxrj+J5ntw+Um/zb/THbRHDUjLE+6PD48NgNeXqwhOS7XFNn
	G+YwPesTlHGLBEHUwLQYpHIS6Vqzhe0q7Knm0RH3zg55WnLBvIQYNyZ8FFLlzp93J2uYlNyAV2S
	7xURo9bRns55DzAFaj6vCgtw4UvnyyoqLR7nurFrg0qTlB+jexW9G/l3G5KrIfe2+ckCGmeCdvd
	FfR/ZZWVicgSuXr05ItsOPye/ZwutLzlAd/6wv/UN6XjqZk/TBywM/vwlbaLVkjygLYhVMDkd1E
	FOCVqMZzXlyV4MgerEWQj2s2yCH/2wvqUmrwah24JGuXFBc=
X-Received: by 2002:a05:622a:3cb:b0:509:2cd4:b705 with SMTP id
 d75a77b69052e-50998c18cb5mr16297621cf.4.1773755746442; Tue, 17 Mar 2026
 06:55:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-12-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-12-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 13:55:09 +0000
X-Gm-Features: AaiRm52vhO-0_fyw-KU_tGB1ZZCMQknIbuzbybziiN4mR8MVeeBdjDQp9RpfHh8
Message-ID: <CA+EHjTzH9RHEDS6XcGQ4A0zt2HcCaFzvBg6xww82hpDSF_rAmg@mail.gmail.com>
Subject: Re: [PATCH 11/17] KVM: arm64: Restrict the scope of the 'writable' attribute
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> The 'writable' field is ambiguous, and indicates multiple things:
>
> - whether the underlying memslot is writable
>
> - whether we are resolving the fault with writable attributes
>
> Add a new field to kvm_s2_fault_vma_info (map_writable) to indicate
> the former condition, and have local writable variables to track
> the latter.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

user_mem_abort() was overloading a lot of variables!

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index caa5bedc79e19..3cfb8f2a6d186 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1717,10 +1717,10 @@ struct kvm_s2_fault_vma_info {
>         gfn_t           gfn;
>         bool            mte_allowed;
>         bool            is_vma_cacheable;
> +       bool            map_writable;
>  };
>
>  struct kvm_s2_fault {
> -       bool writable;
>         bool s2_force_noncacheable;
>         kvm_pfn_t pfn;
>         bool force_pte;
> @@ -1801,7 +1801,7 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
>
>         fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, s2vi),
>                                        kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
> -                                      &fault->writable, &fault->page);
> +                                      &s2vi->map_writable, &fault->page);
>         if (unlikely(is_error_noslot_pfn(fault->pfn))) {
>                 if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
>                         kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
> @@ -1818,6 +1818,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                                      const struct kvm_s2_fault_vma_info *s2vi)
>  {
>         struct kvm *kvm = s2fd->vcpu->kvm;
> +       bool writable = s2vi->map_writable;
>
>         /*
>          * Check if this is non-struct page memory PFN, and cannot support
> @@ -1857,7 +1858,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                  * Only actually map the page as writable if this was a write
>                  * fault.
>                  */
> -               fault->writable = false;
> +               writable = false;
>         }
>
>         if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && fault->s2_force_noncacheable)
> @@ -1875,9 +1876,9 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>         }
>
>         if (s2fd->nested)
> -               adjust_nested_fault_perms(s2fd->nested, &fault->prot, &fault->writable);
> +               adjust_nested_fault_perms(s2fd->nested, &fault->prot, &writable);
>
> -       if (fault->writable)
> +       if (writable)
>                 fault->prot |= KVM_PGTABLE_PROT_W;
>
>         if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
> @@ -1906,6 +1907,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                             const struct kvm_s2_fault_vma_info *s2vi, void *memcache)
>  {
>         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
> +       bool writable = fault->prot & KVM_PGTABLE_PROT_W;
>         struct kvm *kvm = s2fd->vcpu->kvm;
>         struct kvm_pgtable *pgt;
>         long perm_fault_granule;
> @@ -1966,11 +1968,11 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>         }
>
>  out_unlock:
> -       kvm_release_faultin_page(kvm, fault->page, !!ret, fault->writable);
> +       kvm_release_faultin_page(kvm, fault->page, !!ret, writable);
>         kvm_fault_unlock(kvm);
>
>         /* Mark the page dirty only if the fault is handled successfully */
> -       if (fault->writable && !ret) {
> +       if (writable && !ret) {
>                 phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
>                 ipa &= ~(mapping_size - 1);
>                 mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
> --
> 2.47.3
>
