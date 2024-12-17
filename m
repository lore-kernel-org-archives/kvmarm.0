Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E69D1CF2A2
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425337; cv=none; b=tFNZIM/C1Flv8pIXK7udGsI9q3gRcRtYx+AtdDnL+515+qsoUZyynAWmzro6bEUOdUUh8FU30uMowSTA8BdNVJKRkQ2M9CbcVAsp96T4+o4CPh3/+Ef7641KnhiP5efmj5+pi5Ba76K/N/7fWVm5i+d/bIZKip4KXutFUtULEQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425337; c=relaxed/simple;
	bh=TuEAdqDFvdHW9gP3adsRjRi3jQJtzsHZgPQ8FqpyKMQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iLZohyHXs4CveI8Xd2vj7jq4P3B1z/ny+CuR95NqCrIs4fLfbX1KG51dhJ1UtHcnNy7EtDlLy5NuR9mVH0TSIs4ByW04MCV7AC5bRY/QNvPf+FAFPXRQ2rTgEzgvXHdAoqglzeKUC7jzUut+hV2OFeCmSrW7zPRj97uHSGZlv38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vc3dXZSz; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vc3dXZSz"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43622893c3cso26715e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425334; x=1735030134; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A7YTWU7uGdtLnWP4r+MAELOvdX8ajEJVx12lX99dfLw=;
        b=Vc3dXZSznAMmf+Y3O4Wrh6F0YZb2LVBdMjOBohuVH6wFNdf4UrC9uqLCpoCKH9OWav
         g1NuLW3V5IAqJjXfIQ+8e5cYrgagt6V53tOIpbhOE343cDWqhbQXpcFbvjTmk2+xyWDW
         VZbFgW8O8qgyZ23Ra8sCXPlb4fyNseGLbpnXl6B8DDzC0s3Gcw+y58TfBpWdfU8n4IOP
         Fps647YfocvDVpPoylyGYzC567cncaYaBx7qmzQJ6yjsZERGK8pRBpaPO3Ry3I+cb2YM
         mqtkHNIswfOprpsQ/cj+mnTspM0hdywqq2pA2M3zUfcFisqfOp3mPKkdlT+80Aap3hAF
         NVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425334; x=1735030134;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A7YTWU7uGdtLnWP4r+MAELOvdX8ajEJVx12lX99dfLw=;
        b=v2Ztqu696v+lwRtk48d9cgd1nDmbPVwx6Nti9kozUfhDv6RwAiqn3yzN3rwB5pE2Vh
         k0kf+Iq3Vj9UUugrcRheMmR5S4wvjzAzEcBLjkJc8s4PpWD1AoMlQst99bMcfdSMmkT1
         SclwAsIftXyKfKFOSQvA8KLr7P7jUAIVGEXmJl+BQecjwDAlB7S5pOiyuj5gIwLmq126
         YVxQWg6RsY5qWQnImNr2tb0Ipi+qVkwRrdJToV5jsW57ZUkQ0bOjQrlp0ehiBeLJRSiA
         i5aAilj/lsi+G3Dpi3e/mSOdX62renXL+OXZH8MlqSgCG911kOhiSTYox/RFEuQtKFXD
         VdmA==
X-Forwarded-Encrypted: i=1; AJvYcCUKXTC9roZJwXWUW63c/5FeIqHmre2VfAxLAOp3gtko0xvlLiwzGVe8Nu7PJ/Ck8I5pYNbzlKk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnS44Bmfp+tGUHckvPfypea5CT/sDp+aV9XXhgeEir5QEdMHoy
	Cv9csVNfNCmnx2G0ssXRyjBjFJrrC9UvB+l58o9dCIipHPBMpQaNZJVOyDY3dwViQkYGN0nd5nh
	4bBQmJyiIqxGfLmFDkZQHSsWKOhZWRdWykzmL
X-Gm-Gg: ASbGncun8rqA7Q/aF3jcaNdfAB4tQpezgDk/f/i1UMMVAePZ/SvSFi4EtCmDrfZz413
	77qf5jlVff2j0OOdQpR8PaXwHWtI+9GbHlncxfsSLUycKEbRjZILfRSq9bja2j9UAd8A=
X-Google-Smtp-Source: AGHT+IFQVMhJyuBvpWnirFZOzp1TjeSx17Y5DE8/Tuu+aAN9FtjNwt0anC94607YgOtJmmmQzWkBb3MnulFBgA2MdLk=
X-Received: by 2002:a05:600c:5741:b0:436:1811:a79c with SMTP id
 5b1f17b1804b1-4364ad4db33mr735615e9.5.1734425333713; Tue, 17 Dec 2024
 00:48:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-9-qperret@google.com>
In-Reply-To: <20241216175803.2716565-9-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:48:17 +0000
Message-ID: <CA+EHjTxd5euMqYrq510kgqvON1JdGmjhE4ROFuMwTR1pgwLD9w@mail.gmail.com>
Subject: Re: [PATCH v3 08/18] KVM: arm64: Add {get,put}_pkvm_hyp_vm() helpers
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 17:58, Quentin Perret <qperret@google.com> wrote:
>
> In preparation for accessing pkvm_hyp_vm structures at EL2 in a context
> where we can't always expect a vCPU to be loaded (e.g. MMU notifiers),
> introduce get/put helpers to get temporary references to hyp VMs from
> any context.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 +++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 20 ++++++++++++++++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index 24a9a8330d19..f361d8b91930 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -70,4 +70,7 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
>                                          unsigned int vcpu_idx);
>  void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
>
> +struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle);
> +void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm);
> +
>  #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 071993c16de8..d46a02e24e4a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -327,6 +327,26 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>         hyp_spin_unlock(&vm_table_lock);
>  }
>
> +struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
> +{
> +       struct pkvm_hyp_vm *hyp_vm;
> +
> +       hyp_spin_lock(&vm_table_lock);
> +       hyp_vm = get_vm_by_handle(handle);
> +       if (hyp_vm)
> +               hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
> +       hyp_spin_unlock(&vm_table_lock);
> +
> +       return hyp_vm;
> +}
> +
> +void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm)
> +{
> +       hyp_spin_lock(&vm_table_lock);
> +       hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
> +       hyp_spin_unlock(&vm_table_lock);
> +}
> +
>  static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struct kvm *host_kvm)
>  {
>         struct kvm *kvm = &hyp_vm->kvm;
> --
> 2.47.1.613.gc27f4b7a9f-goog
>
