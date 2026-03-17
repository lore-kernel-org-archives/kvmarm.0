Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECDF3C3BF0
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 13:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773753853; cv=pass; b=E+yoA6RT+Swt+H4FI6o5OsfJmHyLw51yHZal/BnnS0O0MJ5FQlnWInB7yo8IhWIZJVMzbk8CPkiEGf3FioDpLvWsM2BenANl8E+eUAfe28xmfb4ekm+oxh/epZaSbKMpzi8D4SjQr/Ad7Prfqg3wQVZUjqVOsFv3sFCAapB82IE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773753853; c=relaxed/simple;
	bh=brmkxukjELQ39QmpOAJrmSRpWsSOTggY5AT6Vr9no9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UmzLQ+m3pf1Q4qNx49m2mr+zOLdhnx1cZDKBc1AfjtauvFV7rwz8DuC1x5uL2YELNJZUmYPl/7STTiz44rVR1dTxkw9vRzBF8d9uO/6p444MbTgZgmI5lgtF8B6APwqIvfjf0deUQ9FSH4wX/WP+pTjORJRuoVD3joxAuXBvKEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E56P9hCL; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E56P9hCL"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-509062d829dso493761cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 06:24:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773753851; cv=none;
        d=google.com; s=arc-20240605;
        b=VF7jdlKlLP4+M85tQDbewizQXWXmp34cYOYzzDLO3l4UaaKlrj0lKUM5wrqIxhBPdh
         uFORyfvFbeDA7PtOArjZYSyJuLAuP8f2R5Nq7fkJh8N6X35o70bMV+QBqAKwsINgwkkA
         wMAvGXTA51RVCffzWsIto7HITqvbblTOGkQbnoY4ZaZXLXwN1Ompf1/Wa+djWJJOTVw8
         0jxNMXmXI25tiaBPV8UjUyorsQas6CHD2vi4NDiNo9nezkWDmoe/oqQKvQay8ZiK2PM/
         3+RHu2fzugnNMq6v6qCHSMRYXpX69AaxAjVJz+Ej2HYS43oYy3f3n2GI360f0GPYp0f2
         uEfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pX31OwUIyuVCce6a2uEpCU7DTCt/xoQQWL99r13ot9g=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=daFP0YHEd+7GP2HAP5tV9FLdPj8wXNFLLj4fU3oWXFklhJWCPWX4nAyA7pz6jz53FU
         rVRlUU2D/hezoP6UfY2+OBBoSId+aQWRTzefMXv/t+7wZriru048hIPawH3fe2lO1KAl
         Rm0XNEyy+D3en5DHqShumgcQ6s7SOL9gNYZ/L2F3TjMixzyEKG040UfMEIRQL1668q3K
         QoQYxeTpNH6iLs/w2pa7iZ6eooVGxydv0ED1sNjXdE3p6CpJRPVlhD7S3nQ2+tKKUabB
         SWqxUWjdJEU4zs/FXXjuSwyZY6rb2O1tbYYypwfRYDBGYbk0Rt6xgYcVNA0dq+2j9asC
         VZ0A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773753851; x=1774358651; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pX31OwUIyuVCce6a2uEpCU7DTCt/xoQQWL99r13ot9g=;
        b=E56P9hCLxhXj80Wxx8CTl1p1vcbab+/dAgd8Fc4yEiiIXFr9NxNsmLMANm5VcJ6hhw
         sPAAADs92kFTohc9vA/5CuXvs8OEykd+TwYJrFlrPFO3q0NoG5xIAsTX5XjdXIWGgCfK
         2BkorDuiJVdWqBQ9pNfoGfWCPf/tFy1UaLqIVOlAO27oxSXA8j+HxHCzc0f0v75plENu
         FfBBGb0vsuDVI/S14Iya8s4nMZvqn+73ADTXE4VS353m6ZKthSv9QLn55hNNUkX3INFP
         NZd+9iOibua4K7C2bx8FLBujbnyBHtEtTVHPtzQmIRJJmNDyIlFqrV0gJrZfLUaaChem
         pzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773753851; x=1774358651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pX31OwUIyuVCce6a2uEpCU7DTCt/xoQQWL99r13ot9g=;
        b=hMZn5Le9AgbYg43O9aZpeEs96rOwGuihU2eag1oDpf3+X4FGLTrqqW9gcjIYl+jE70
         qGz9N4iuUNoDJzH3nAImIxluoDrCxOL66KmnWVFNpLFY0B7Lj9OUuuCAYuVItntzRF1/
         LYZIJ7yURG7sP9md2sHn5gvTrz4YSKJBs+gAQpmkTaRe6S4w7LCjiBipx2BZWMjrhYkg
         gauJ/tyefULu7HX7GUE1yoSmwCHPM/oWf5b3MznLQQy3rQBfvIRYoHSK71kkMaowix3x
         WybjDhcIdss1XKU3NTOe0aY+S0J6chIhX7l1kn8D7W8Ltgn4lzB5KZZViMUX2aVKlJaV
         DlTg==
X-Gm-Message-State: AOJu0YybM2VM0lxzgK7op2tJQO9wVlrQra0iy4kGHZzwWN8TqXd9TCSG
	GbEEmluy64dUh3Mq2nz1g+OlpSAzaf2K/AjJ8bvVd5nSvJ+3HtokDsQU0/Om30FyJdYnLJTEmnP
	y5iwBN+5LGHXgD2p9sbIfZK5j7anuxqpVUnr3ywpq
X-Gm-Gg: ATEYQzx1tVTRq8XyYXne8cs0S1+u/b8DICMqE4qtzRYyjnJDr8nj+yEMkIXjSD5OeP/
	jbW+PlyqZsQnZMAd0x2S8YIpaRZnK5obPkCczqrd8nfvasLr7MuFmaYasXnxLx0ra1uVBxCiTv3
	Yd3M90Jq5+4dA9ytDiOcZ8nfH/dBmROtTXqk0Bo6kO0Bf5Bd5bopYc5ZOna1nUYrm3U2bBPSuy0
	Ix1L3yIBJcp6E1snJo0z9VH3Dg7FpJHXZyHA/N0WgoiX+4hHl70pyu+TY/klg3zrQmv+BVI6bvz
	0jP83CkaeSohw1iGXXvlBTTPqT+yTtPb2ob6
X-Received: by 2002:a05:622a:24c:b0:506:9852:75ec with SMTP id
 d75a77b69052e-5099ae29b28mr12044891cf.9.1773753850487; Tue, 17 Mar 2026
 06:24:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-11-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-11-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 13:23:33 +0000
X-Gm-Features: AaiRm50svmLd2fOL3HEMdNHFWE1EGdezYZCVO4BVpI417FT7gO8t2CTdtHg6I-k
Message-ID: <CA+EHjTzO4GNzoHM-t9PhpX+4TgFqis4gqnDXrKyu_q=DUiL8Pw@mail.gmail.com>
Subject: Re: [PATCH 10/17] KVM: arm64: Kill logging_active from kvm_s2_fault
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> There are only two spots where we evaluate whether logging is
> active. Replace the boolean with calls to the relevant helper.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  arch/arm64/kvm/mmu.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a5b0dd41560f6..caa5bedc79e19 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1723,7 +1723,6 @@ struct kvm_s2_fault {
>         bool writable;
>         bool s2_force_noncacheable;
>         kvm_pfn_t pfn;
> -       bool logging_active;
>         bool force_pte;
>         enum kvm_pgtable_prot prot;
>         struct page *page;
> @@ -1853,7 +1852,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                          */
>                         fault->s2_force_noncacheable = true;
>                 }
> -       } else if (fault->logging_active && !kvm_is_write_fault(s2fd->vcpu)) {
> +       } else if (memslot_is_logging(s2fd->memslot) && !kvm_is_write_fault(s2fd->vcpu)) {
>                 /*
>                  * Only actually map the page as writable if this was a write
>                  * fault.
> @@ -1985,11 +1984,9 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  {
>         bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
> -       bool logging_active = memslot_is_logging(s2fd->memslot);
>         struct kvm_s2_fault_vma_info s2vi = {};
>         struct kvm_s2_fault fault = {
> -               .logging_active = logging_active,
> -               .force_pte = logging_active,
> +               .force_pte = memslot_is_logging(s2fd->memslot),
>                 .prot = KVM_PGTABLE_PROT_R,
>         };
>         void *memcache;
> @@ -2001,7 +1998,8 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>          * only exception to this is when dirty logging is enabled at runtime
>          * and a write fault needs to collapse a block entry into a table.
>          */
> -       if (!perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu))) {
> +       if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
> +                           kvm_is_write_fault(s2fd->vcpu))) {
>                 ret = prepare_mmu_memcache(s2fd->vcpu, true, &memcache);
>                 if (ret)
>                         return ret;
> --
> 2.47.3
>
