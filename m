Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364C63BFE52
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224250; cv=pass; b=OyCaCAEP2gQ9ia+tZFhP1OW+VaZgYwtMWhTNoPdjkf+YsGDvbqEI6BqutouGYehPQ06vDkw2NYPTOfyz+E0F/7SYZUHQUtIIjYtooP1pfGCvFC4+qrck4ECe67TNzVip52Vf5NEkciSBccZsvyp5qZf3Tk2gks/JuIuiqdkvq2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224250; c=relaxed/simple;
	bh=6eHDWKLBvKuDK4uV4e/n1yZp4Ls1E40VkzvRjYK1W38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TQ1FQNfEB3B33fvHixX+hnoavaDWG6SS+H5zBV/Y7hZd60AmO0oZd8dsz0BLcpmiqdeVR0APwkV6HKkPVpMU6UbkGuNH/JxB6jEe2YIedboYE6BKgnRpMSlkZw05XFI9lnowRETNzo/nH12YlNpwQmTUSzXt8+bpUmAYY7GH35E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0vNPlJCC; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0vNPlJCC"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5091ed02c54so401141cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:17:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224248; cv=none;
        d=google.com; s=arc-20240605;
        b=IN7kkC6ZHd1bBTkmP6IPbLzK5Ofi8DQ6/xtsQgcDuPGJVWcE152gkPZQJyN3S5vMV6
         j2+hxk2zZd2ScjSWUtw1+CNTzAJOr4SkY0dufbDsJCdXLvSfKBAm/fAlVYp3oR3Cj6R/
         Exmwh08WJA0InhAUrHSZtjbhGKdeMmupE1Fqe7UGIB3A7u/M7AmoHIrQW4chZO9symnG
         ps52UZcZCqP4M2qAlVdI7I2ggzs1z41tV6x9Rp8b8Ijd/mnwbbSSk/QAo0AUKrK/KjN3
         dyIlPGmsZKh6oAkOKdjMeRBQ2bw5V7e4UxhyMayvJNX+4tMYOb8sPyNRla1uB5HAwshp
         1Mmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2p5KSxTIRfOC6O2ujvV2QHurJepZe9V2nPJahGajPeQ=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=NzLE3m92nXxvgNy67nYj0c6ASMJu7deq/nPEYq5UaJUnwXzDDc8sWR1BOsZ2YKDuon
         R7xM3GyaJmXAQ+yJLS5T+Fg+B7A62gxn1vyyNqvIx4golnL9eNxBoJFM6MJDW3iViBQJ
         kqwkIMWmklbNW8beQ5n92yDiDUqdt/ViNYYmLSgmQxcLui+n+NSBWP3GVHrQQHVMkEzY
         j1dPzjUqENEmFFaHy4kNlZ7xEWoGgOzmLU/QncCE8i1nsfDD3Q3EawX4IhCp+4KEFtte
         4Zza1c2HhvtCo+EGB1RmgCuybNq4mPoVqd0uADOLI+JOzYzU9INcyF984+QTNb9T2KxM
         33Iw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224248; x=1773829048; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2p5KSxTIRfOC6O2ujvV2QHurJepZe9V2nPJahGajPeQ=;
        b=0vNPlJCCEg8mgoYo+uZVm7zFTYjkp2dhHAFp+vVZS+Xdm+lllFilv9OmTv4vN4gf4K
         HzLdVjxLnkbpEoXWkYBeSgOO6EtXKcn9s3Grrh54rPSEy/OUX07/37bUImuUtU5WZSaR
         pRdgMjW3mbeAShGd060OEKIHNspXY3a89vIq+rCw35vJY2iYoPKW18Jt5Mv9S23caOPc
         3NE1ANf2aD1gXde5VK1869CGPnvKSJD1AwNyg1VA7ID+lDRONtUIOWHFsfDnPR+/JOWQ
         Sj/p0VlG8rhSw4+WAt6tLuA5ABPOFHonEx58QyNcD/NHMjngc4Vm+tg9UieTAFQAJQ6S
         mCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224248; x=1773829048;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2p5KSxTIRfOC6O2ujvV2QHurJepZe9V2nPJahGajPeQ=;
        b=lexUrWQSavwhZ6fMjOAjujTLMD37gXgZ70rkhDeoilYUnh7Xwv4D0E+BCb0ElsqT2N
         5tvcWk1/g1A3GTV+d3sanitxEo7wOLCoyHETRiGBJgW7v38A7lPC7ytrec7XotDweweY
         vfiGcHo2yUmdvtsd7cvqQS0rOnuVV1pVYq1b4e6WaCKVXpNghul7zTJKjsyrAc2GjFiI
         KyY4OtU63y6MeF1xcQXg7VNd05juZc4t70yCblDUYrzLsbC0EGIHdeSF4s0dTqd9mTsG
         h+dtG1yOLCiXRv9tuVEujT4wSS6XZZui5HA8w7L5Ml0sozcv85pZk7I7RXuoVx4OQfSj
         DJnw==
X-Gm-Message-State: AOJu0Yz1XT6oo5Io/ukDP1fEHpHWNURGwLdcob3wIYxsCxn6ShR6K4ea
	J5Y30s4ljlfEcJJJJxfuokyuvp4AVVJjSLnkssxDE/diTN6pv+qcKG5US7fUafXKRLwIhYgDu7K
	dqk/q/qs70WtaUVE0g2LlyVCTi9Jmxvw4HT40CPiU
X-Gm-Gg: ATEYQzy36/Iteve9+ecBGh1WV5VQeDoDM6Gab2gVAdH8Ux1c2SHgfYtbKrc3gJc3HGb
	uPjBE72pJgsO0VBK19Qq0X+GaJ+nvGL/8AKvBejJ/u7dwLqNR6fnti50MI1QIMB0Hw7AdR2Uz1I
	XEf2lEeQnS0QVqTEO/ptr6nXbMR6VFnWSJzfTsFRfb5hGmllWuZfz/0pKxxFInGYG4mUT1hjZRP
	Z8L5dhgJ9/oHHbG2+pyWJu70PnAb9YnvvXk0VNeA5gA24CCIIbTXgwOJvhCxbadIa7BKDIKzm6W
	eYXhVvnY9BDGR6Am6KEjcfqzXsD8urdb4PdkVw==
X-Received: by 2002:ac8:5ad4:0:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-50939a0fdb6mr8651281cf.5.1773224247734; Wed, 11 Mar 2026
 03:17:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-9-will@kernel.org>
In-Reply-To: <20260305144351.17071-9-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:16:51 +0000
X-Gm-Features: AaiRm50pq-gU1BFu0dPs0mu11fXQQe_BYCcsIQ1e_bsJwGqZuSAvXZICi-mcJAo
Message-ID: <CA+EHjTz7XW7uPxAmE-EqCjQHCf_eYajwT+kedZ2gPOLMuNGqJA@mail.gmail.com>
Subject: Re: [PATCH v3 08/36] KVM: arm64: Prevent unsupported memslot
 operations on protected VMs
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
> Protected VMs do not support deleting or moving memslots after first
> run nor do they support read-only or dirty logging.
>
> Return -EPERM to userspace if such an operation is attempted.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 43632c69adaf..9d183df0b0ac 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2410,6 +2410,19 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>         hva_t hva, reg_end;
>         int ret = 0;
>
> +       if (kvm_vm_is_protected(kvm)) {
> +               /* Cannot modify memslots once a pVM has run. */
> +               if (pkvm_hyp_vm_is_created(kvm) &&
> +                   (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
> +                       return -EPERM;
> +               }
> +
> +               if (new &&
> +                   new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
> +                       return -EPERM;
> +               }
> +       }
> +
>         if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
>                         change != KVM_MR_FLAGS_ONLY)
>                 return 0;
> --
> 2.53.0.473.g4a7958ca14-goog
>
