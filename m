Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC461DC9B3
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224179; cv=pass; b=iD8/MJKpF2Zj9/w8IxUm90LJRAgtU1H1h+74Bcyxw2Z69d7wOmKPBeA0TTjY18UeuHMy0JYJ8VTFsHAqaJbwtRGc0ounHIipmhEeTgfo93ty4TidqGc+IjgLLaoRo6sCIn0VKB+WL7kFo8HG7HjGzo1r9LKiwGMFPf31+fVaXZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224179; c=relaxed/simple;
	bh=9g2SmQiGEfNTClEi280mbk6rYgekPcWB1kNKSCZa1cc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hBodKPXz4S5hk/Jty8NFDcTGKNcuXcrILvRE3QNwf2/S5sNQi5x9F/uUE89oEOvwZwZja2j2Kd6tvXifm0K6QGsyN7wgGFfD891Y3SFVV3zgsuqMXNIzRpbo+OHUYeQX219BT1KmdxbAdStgFur/kQioniQSAUkArtcSUd8LWnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T5QVGb/j; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T5QVGb/j"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-509069a7a7fso507461cf.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:16:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224177; cv=none;
        d=google.com; s=arc-20240605;
        b=dsmNqmSxpRQ1UY5uhk9KowxJmRmEU0hFups4ycmbyuldirx7oZh1YCMvQhW5YW1pZb
         48A6Yq4rQTDiCQMeOvMn1wwZxHLZO9ssnP5d5m33cBGD+w81194J5F1nq6lIei8YhMqE
         6O1ZUKrQ/ewDoDbBCYfTh0u/Rb4tcHm4eIWoLsFrcVF1gvwfj0noxVHggCrqvoFCSs2+
         raw2sowTktu7rH+68Nsea29DK6rn22XcO0ITq3NEY4ZaG3tTYuKSF3SFQG9DtIskQXyp
         al2enMG65J+t/OGbcc9n3DikBv9BfgVCcvFpe4E3qk/smj40WUo4tcU9SWdcioYDXPWA
         JA+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=oX0osco4zt+YO7jQlRuz/PukjnHOmVE7FLgSU6O4vqQ=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=kYk7kql4bSWdwarbeldmy/5rR5VW6Ml/OZAspsTCnCeuIO0u+sqlNwfpZMpScYzFsd
         XaPm5brjmzE6Q4UlHRkUonS5Cd6o5RPeQ+c5rGJMA8RM8IQg5nx7vHrblGVTkm/HrEcY
         nrgFjvH1iNodaNnZhUJlVsUFGEicF+kTusKAMH1X5Bb8Bx4DR3NllhvKvQRHnLL2E6rP
         Ch4rX0Q3uRucctZBU0OCaMfakF31puokJ23xePUngmfb2fxqzHhqpR/G8/8aSF7iLII7
         c7dl/dQMOhZD1+ELfkXua56b9KlnURZZbzN7GqcicXsaImg8Klq1qBoHFk9ExMDOdu2+
         kVeQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224177; x=1773828977; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oX0osco4zt+YO7jQlRuz/PukjnHOmVE7FLgSU6O4vqQ=;
        b=T5QVGb/jCxxtv/fxqChok4x6lbdACvFaZwYTVVO88fwefIGTpEhrHO3zaIGJq4o9Sa
         fpNSS+kjq8d2G4sEcjs4X906231BUAoMCIZ4myHpGYlYXOHtnIHJzr/TpPmxGMomhSQO
         Hq3MAo//WVYDYHaWoTDmS6QJV0ey43yGUDqdCjqQzVS9Pz44YgfRLF4y/i/ZwSGwXzgS
         maLeabTHy4MU4msf9gpfWiGgkqUG1s97Sv64jevZbeQA+RHyg+yvJVBfrcPgcRUGS3e/
         iCq0C06vCsXa9maTY1roS7rTpZaFTrsg5oVjAIH4DJ3t1TxTVjHjcEd5HzJx9zZF5gh/
         8SIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224177; x=1773828977;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oX0osco4zt+YO7jQlRuz/PukjnHOmVE7FLgSU6O4vqQ=;
        b=OiAMlk219+NYl6+JlGb3xlphjQ0SFt/XUbe5/wg1JRbMDYefwqSLbV/QrhweKklXV7
         kEWn+jdgQz/roWIoc4tNhEnXl3oUx3BybcB2sO7GImcHcpwTlbDDWTAlpHQ0VW0mbpp5
         4MoutYfELwattcXWf0HEk7MGCTo6CkbUG8b2IvLzQGfiQetAdpyz2+rYHtzaPijuVRKe
         X38JDVr+Jbzax7fwV8B4AgUqmbMqUytsWxrKDeQ0PbGRBsFAwkZB7RmMPZSVvegw/1dY
         uqzDqjIw0Q5e93Y84FLkOZgTlHUaoOunJfogSueb0iZ2vrvflIHMgVg/ZAxpPJsZoRQH
         +8/w==
X-Gm-Message-State: AOJu0YxOS9nil41EHRdxRQ3QAI25y5NAyI7ogodGqy6sbHK78y/pnaPO
	NsZZGXHL5k9WN7xp7kZPXMTSCbPZ5Bg2TamFA0oIVxfAB4K/EiknAixtYJDXNx8mrrp+A1+h441
	7wdxnRhtZCYa3Qh2vTTILqer2+KNGx3AXHKE5LZA9
X-Gm-Gg: ATEYQzzACsvcNMvOKqXjxRQ3LLKV66St80V5U06KfaOZXCt0nDeMyrjbkqGrRk/Qisn
	DpIDJEdb/PoPmsCEHGwvuDjN3BS7s351cMIXiNl+NH22USSLde22WqaXc5vYSD6ezyuxBVdscgb
	g4bvVqsG1mO2+zzepLI1TtiFbMvEPQstdaIWfMUnssjUtz2j++hfAqNx/p66Isdilr+gf+C9hig
	iU8H1N47MB54AKcXFKwyoSbH+bf8vX67f4UoOT8SY54JOZ/9fOFNFyMZGzMO6sYvGWeeSZhZDyQ
	7tXzvo1au9U3KsWPXbvbhecdmVNJhNmg29GbQw==
X-Received: by 2002:a05:622a:190d:b0:509:2cd4:b705 with SMTP id
 d75a77b69052e-50938183523mr11750721cf.4.1773224176634; Wed, 11 Mar 2026
 03:16:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-3-will@kernel.org>
In-Reply-To: <20260305144351.17071-3-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:15:39 +0000
X-Gm-Features: AaiRm522OYTO4Z5oXSIsWNgqKROWgEipfiQnlhS80N_B-LAEswBJVDHD3G64CEI
Message-ID: <CA+EHjTx4T9AZkvBkJbdsqkw=joNuj1vGQ+d4xqGLsMNpKzXuLw@mail.gmail.com>
Subject: Re: [PATCH v3 02/36] KVM: arm64: Move handle check into pkvm_pgtable_stage2_destroy_range()
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:44, Will Deacon <will@kernel.org> wrote:
>
> When pKVM is enabled, a VM has a 'handle' allocated by the hypervisor
> in kvm_arch_init_vm() and released later by kvm_arch_destroy_vm().
>
> Consequently, the only time __pkvm_pgtable_stage2_unmap() can run into
> an uninitialised 'handle' is on the kvm_arch_init_vm() failure path,
> where we destroy the empty stage-2 page-table if we fail to allocate a
> handle.
>
> Move the handle check into pkvm_pgtable_stage2_destroy_range(), which
> will additionally handle protected VMs in subsequent patches.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/pkvm.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index d7a0f69a9982..7797813f4dbe 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -329,9 +329,6 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
>         struct pkvm_mapping *mapping;
>         int ret;
>
> -       if (!handle)
> -               return 0;
> -
>         for_each_mapping_in_range_safe(pgt, start, end, mapping) {
>                 ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
>                                         mapping->nr_pages);
> @@ -347,6 +344,12 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
>  void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>                                         u64 addr, u64 size)
>  {
> +       struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> +       pkvm_handle_t handle = kvm->arch.pkvm.handle;
> +
> +       if (!handle)
> +               return;
> +
>         __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
>  }
>
> --
> 2.53.0.473.g4a7958ca14-goog
>
