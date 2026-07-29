Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDE84052DD
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 15:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339324; cv=none; b=VculBFklk/SVjPU4LbLPzYXb1alulMvmsjKDZA8CXgdbLcVTdN5ywlPibGIOYJo50HjANl46xbmekzjzTYeIfeLwTg68PjJ9AmXZwYk1MYUMMPpLisOne/fry35qmzyflwKxN7Bb/4te3WUpPBFq/X7vVnQZ5EtPZtwsfpqB808=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339324; c=relaxed/simple;
	bh=xfjli1napBMPwKWq4yM2fZAwqMAS1hPPlrawC0jCoTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fk5cX90k8RZBddKiAGZ1BQHng2OKX1IBKC/bBbg8D3EBYqwiRmA1w1ATdDLnFg8jIYWd64+Hew7POo5sZmobUs1tX8cZrwlIwQFWC5xMgTXDc3i1JXP8a9a+uTjHtcwkcI+4VUYbfGy5jz/7Nf2zcwsbH9XKWLgUUAxTkkEGHpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jp4QRmef; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jp4QRmef"
X-Forwarded-Encrypted: i=1; AHgh+RqlS1rW/FdfKFFJszRrt2ZhfOpZwxF7rtKe9C8bGQbwDhWFsBRaumRT2wzcaRIl2J0uwFT6AcA=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785339320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f1pEajGXSVhfxT8yUIcDvk7DK4wsMWfpWBc33/y8RKk=;
	b=jp4QRmefE2wmXSDfciFq8VojwunvnUpd11Rn9UTEDK3O8RJwNpyQ9dV7gpcdWSSYPXwUWQ
	cLWY4Zd7v8y5+ny7NA+TlutXp1xT9YmrsDIDD9zeIV86GNBOwPbYufWWRgAwCHYnq1Xg9r
	rP8xNlb3GDb/HjpKR8MRRZ2Q9JcrWxo=
X-Gm-Message-State: AOJu0YyspFGos/lpulSU1l0SfofF2WpUSOqqV0Gtas9eSrrCyuu7TeIg
	+xi0VJZGSe/O8H3JZnZdwRky7O22kNZaelqEdVO6/4REB0NZjIB2i354J7qWN7TLWP5QeqADhMj
	dh1Ks/x9Ni2bvr5m8OuM+umKoym9kqV5m6hQEkBDn
X-Received: by 2002:ac8:7dc4:0:b0:528:3186:5799 with SMTP id
 d75a77b69052e-52b35089d24mr744871cf.10.1785339304844; Wed, 29 Jul 2026
 08:35:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp> <20260720-hybrid-v9-5-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-5-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 16:35:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwMt8WWi_UcjET9a50v-U6oFpQm7dRbm75W1fDQOzxS1Q@mail.gmail.com>
X-Gm-Features: AUfX_mxu8rOr8bOtktjWjxfsoHK7AgqNHWBimIK3hru5I0gqCv99uMo4IFXvW2M
Message-ID: <CA+EHjTwMt8WWi_UcjET9a50v-U6oFpQm7dRbm75W1fDQOzxS1Q@mail.gmail.com>
Subject: Re: [PATCH v9 05/16] KVM: arm64: PMU: Keep implemented counter mask EL-independent
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Steffen Eiden <seiden@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 06:39, Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> kvm_pmu_implemented_counter_mask() derives the counter count from
> kvm_vcpu_read_pmcr(). For a nested vCPU outside EL2, PMCR_EL0.N reflects
> MDCR_EL2.HPMN instead of the VM-wide counter count.
>
> Consequently, processing a PMU reload while the saved context is L2 can
> clear and fail to recreate state for counters reserved for EL2.
>
> Build the implemented counter mask from nr_pmu_counters instead. Keep
> the EL-dependent HPMN restriction in
> kvm_pmu_accessible_counter_mask(), where it controls guest access.
>
> Fixes: 600f6fa5c90c ("KVM: arm64: Let kvm_vcpu_read_pmcr() return an EL-dependent value for PMCR_EL0.N")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/pmu-emul.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index b4b877f31097..5281d37634a0 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -317,12 +317,12 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
>
>  u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
>  {
> -       u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
> +       u64 n = vcpu->kvm->arch.nr_pmu_counters;
>
> -       if (val == 0)
> +       if (n == 0)
>                 return BIT(ARMV8_PMU_CYCLE_IDX);
>         else
> -               return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
> +               return GENMASK(n - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
>  }
>
>  static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)
>
> --
> 2.55.0
>
>
