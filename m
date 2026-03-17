Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFDF3630B6
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 10:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773744581; cv=pass; b=RFzweEiJ7o2r3IAEKrB2DH7Tbvsp2ZXpGL1WMNqln1sUEkjDlDT5rOpSwpg0dMOVSnqo3K+8vhDrwFl1p+Jz5E8xo6ffpZ045WTKSb++yZDbjJ34OHo8RtcHmTOiUQMl+pRuD4AKX/F82nnH9+QYyuauBxHicHVcRuUz6Xjp8Ls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773744581; c=relaxed/simple;
	bh=4vsdXI7+c/kziZX9ALmAyrI0TmtqK8VC9nknrC27Qgs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RPqV5h0zooih9fNm30NlU+Vr/K1lZEEvKwMa501jjXHIevLmpBtLcpZqN4pT+XEwAhKlop+ljSB8ksW2Dl1w8YDv0UkwkrusnA73yJCSnnrzHKntwXmma45kThaBsVVSS7yncg6VhW1q1562ArtXrVpI5LjWhZcPXBgdHhZjKsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EgLqVAiW; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EgLqVAiW"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-509062d829dso417621cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 03:49:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773744579; cv=none;
        d=google.com; s=arc-20240605;
        b=VqYjzdDD8K3GjlumjPIimfvmTzknM5ZYi58qkAjDhOUj6sS0z9dkdxfeEn6E8TxKvn
         wNs7prwuy61OwlTSWGIC2Y7E5SpG56vbtkfPSvUS1aw2zqyPHv/sBDlXINK/BONBZ3sR
         J+x42H3odI/6uzDDXGV3oXhGSgXM2pVTZgJA/J7UzaEt6Vns1NZlqDIq+HjFpJelzkkL
         pma18KgEuoqAu+byxQYdmJA6d8gCQUsWx2egGMqAD94rqBnPeU94JXoiPz1htacXFDUv
         NeBQ5jXc4UtJSufr0rU211jjPtIALiRU/b+3zLSD83P1IalfVgI97jnU+4rFz3NGlKpE
         zoXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=J6mzT64VXH3MivX26oiQhB9+QkzJ07GHrjUFovA82Wg=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=AOmPpUoxIgrcag60dBjq0d4L7a5kpf/JYQK1uA66hfjUpjhOV6epw1lUw+ghhKl2Hs
         CdPX9b325W/+ySS4vzP8hG66MYTN3LjXLgSWV0yXBc9twIovRihjRZwAtNe2lVKg4iD1
         ru8/+v6thfykFMbY2fn3E26PTKFiajACIo5KmSqHcD+fe5mYzAJ4g3iqCaIbGm9ugon6
         ox8wvRQc1EVeISebKfnF1qzeG6/kkdR7cac/nLM/yirEaNmwWrbj9cd/pa/Xe9hdM1ba
         eNruXiToa1GOCjSCw05jNPkpGXpXT2jTP7KCZHlcQm/+U6Iltqjhd/Ew7iD4PhP8GfFm
         H+wA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773744579; x=1774349379; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J6mzT64VXH3MivX26oiQhB9+QkzJ07GHrjUFovA82Wg=;
        b=EgLqVAiW2MZvXMwOUuCnhHsc7DQPTxPicC4IN57Z9Rkvfo+lv9CaNGrlkVbTmMBHIT
         M9boAuPxroWGAmJL7/8dz8qVnoFB/du/w4ngWOtdgE3zhXvZpA3YbLcrhhEp0J2R+oea
         wxha1imLhgiAR275oirAHIwcT814MUYNyyuQZpSapOdeJ4a/R6eQpO+xvVBhDJOhUF4n
         YpYuXnoKFRbIAf1aJvp6ymNSut0Kzn/N8ODW3pT9YjELoTVKiv/VFm2ToJzry1e3C3/X
         YJkzIKXGmJCg1Y9TDBxTl6OO/UfPTGetf7w1aYK3Yn9M1owfL3TL0lr4UWjAzOlKO8Xz
         +olQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773744579; x=1774349379;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6mzT64VXH3MivX26oiQhB9+QkzJ07GHrjUFovA82Wg=;
        b=IQpQIu1P70ROjAUiXITreN47IsXsEcq4mtP0DuaxiMlUA3jtU5ZQ3jcQS38XWboaaU
         T0fo98ToGPAb/dhCijvxfxWCi6cvpcL1xM4fjc2W5naiTOq5AjBWfbihcmvk1JR/hWDx
         zSYgxpfZyyFTuilOa68P6HvGaZi3KAv4gPi7tQGsC3odzaO4hQ7DpywGlDms3I+7cS+G
         TFE5fAH7JXjrmfUdsbqFM8o5lKb+C64YmBiD7+kZI8bJY5WTIgw0fN6NHI1guXgFmEZs
         CyH/7pIIxecf+u3pZEeMH77eVzIsa421N1iCpT2up12SlnekMCGXHM5Yc2jHghV5TmUE
         zqdg==
X-Gm-Message-State: AOJu0YyRukxesMaUQEYV8JlQbLRzKr0Z/mUZQnU8pC0asqK5RunvXKXd
	O/StzWqGdLhj/HANxNRwN3les1xtPs7VyqG62pkeiwvTDg0CndDL6TMGEZnyq+YpmOIFxncO658
	ESdZ7oT/vD73Rb9daljvqFHHSujTp3Wkp0n6pk2Tb
X-Gm-Gg: ATEYQzzclR9JlQc5aaflccB6q4vq13fYyUmHoUddZqM+e9U51PceH1iRnp4ti5FNC5u
	fWBz+urZtRX95QciPh3MS/3BNHmG3VSLH6YZkRPlJ4aEgtJFpqds1sU9B/VV3lNznl8axRayXma
	6XCXnE18MN4dEnkcmLR00DnU7IX+8uby21N+zq0RU7zhqWTNB+j1ayiCm20f7ba8COJu4bTWujH
	3gCc/znXixaXg5Fu9MKRFDEVWsoQwo8A7ZOSpzJ/64dcR3DfRAgc0o8ayzAJ4wM8dJPWYGMf9OK
	4Frj4TzHVSVLNvEE5+KZ9CzPGmQNS7WwkoVT
X-Received: by 2002:ac8:5844:0:b0:509:cd7:aa18 with SMTP id
 d75a77b69052e-50998d3b42cmr13986731cf.10.1773744577336; Tue, 17 Mar 2026
 03:49:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-5-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-5-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 10:49:00 +0000
X-Gm-Features: AaiRm52Mi80HGCc33K1nXVaGHpnEbr4dSt3naQacwu46MVSDK_PLdEJAbKhdcEY
Message-ID: <CA+EHjTyip-rjLK=XT4OVaOyGfv4E0-BSw5MJTb94_f3Q=7tPOQ@mail.gmail.com>
Subject: Re: [PATCH 04/17] KVM: arm64: Replace fault_is_perm with a helper
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Carrying a boolean to indicate that a given fault is slightly odd,
> as this is a property of the fault itself, and we'd better avoid
> duplicating state.
>
> For this purpose, introduce a kvm_s2_fault_is_perm() predicate that
> can take a fault descriptor as a parameter. fault_is_perm is therefore
> dropped from kvm_s2_fault.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 2a7128b8dd14f..1b32f2e6c3e61 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1711,8 +1711,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>  }
>
>  struct kvm_s2_fault {
> -       bool fault_is_perm;
> -
>         bool write_fault;
>         bool exec_fault;
>         bool writable;
> @@ -1732,6 +1730,11 @@ struct kvm_s2_fault {
>         vm_flags_t vm_flags;
>  };
>
> +static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
> +{
> +       return kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
> +}
> +
>  static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
>                                      struct kvm_s2_fault *fault)
>  {
> @@ -1888,7 +1891,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>         if (s2fd->nested)
>                 adjust_nested_exec_perms(kvm, s2fd->nested, &fault->prot);
>
> -       if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
> +       if (!kvm_s2_fault_is_perm(s2fd) && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
>                 /* Check the VMM hasn't introduced a new disallowed VMA */
>                 if (!fault->mte_allowed)
>                         return -EFAULT;
> @@ -1905,6 +1908,7 @@ static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
>  static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                             struct kvm_s2_fault *fault, void *memcache)
>  {
> +       bool fault_is_perm = kvm_s2_fault_is_perm(s2fd);
>         struct kvm *kvm = s2fd->vcpu->kvm;
>         struct kvm_pgtable *pgt;
>         int ret;
> @@ -1922,7 +1926,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>          */
>         if (fault->vma_pagesize == PAGE_SIZE &&
>             !(fault->force_pte || fault->s2_force_noncacheable)) {
> -               if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE) {
> +               if (fault_is_perm && fault->fault_granule > PAGE_SIZE) {
>                         fault->vma_pagesize = fault->fault_granule;
>                 } else {
>                         fault->vma_pagesize = transparent_hugepage_adjust(kvm, s2fd->memslot,
> @@ -1936,7 +1940,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>                 }
>         }
>
> -       if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
> +       if (!fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
>                 sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
>
>         /*
> @@ -1944,7 +1948,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>          * permissions only if fault->vma_pagesize equals fault->fault_granule. Otherwise,
>          * kvm_pgtable_stage2_map() should be called to change block size.
>          */
> -       if (fault->fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
> +       if (fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
>                 /*
>                  * Drop the SW bits in favour of those stored in the
>                  * PTE, which will be preserved.
> @@ -1977,7 +1981,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>         bool write_fault = kvm_is_write_fault(s2fd->vcpu);
>         bool logging_active = memslot_is_logging(s2fd->memslot);
>         struct kvm_s2_fault fault = {
> -               .fault_is_perm = perm_fault,
>                 .logging_active = logging_active,
>                 .force_pte = logging_active,
>                 .prot = KVM_PGTABLE_PROT_R,
> --
> 2.47.3
>
