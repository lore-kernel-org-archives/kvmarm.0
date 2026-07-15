Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149CA448CFF
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784115354; cv=none; b=Vb7PwqTZKrDhWvZtyarVD2GPHPcPhtLfjDTV/rS4hrkGxkwUxXE/a048/yxHhSYumnKJvwueZjDJV7Tx0cG7ZytiO7zUaf5Sya7PnPzvOjwS9QsjzB7BuUtc8750ehfovrQ/Fl4HhrL/8LOKuWtVY95hbbxvuEdgGMEDrSEIQd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784115354; c=relaxed/simple;
	bh=uKwk5HI9ERjRW88r3eYL5egW348hIXF3Wul6oiMr0kk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t/mOk6g+NAQQt93du5z7lgUmuxjQRylE1uxHWjyDwFFdTEvQREsTFs9qOyX2UMwX22QJ83NGNjLmwFGKi663u3TKrEIaSRoIZDwq8vwUIQuLUOMHEhcFY+n42lOHZ/GNHJkCME1ojYUb8e+o/mX3Kfv8e/5FW88w4Fg127jN2so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B1wcvrIg; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B1wcvrIg"
X-Forwarded-Encrypted: i=1; AHgh+RqzymlZUWZqdIdpUYMYCsGhMSGSDDRrCFJkwHmoQef/lPhrie+/x7gVTICx/QR1D2EbTv+Qlec=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784115347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5hkQ1X3dNI+y7n8z5kAh8s8mH54WX+OhAWV76vg8las=;
	b=B1wcvrIg3cE/4PBiOvBJz0NwFfIaDfT2t23UIbaGMNgrwrJ9utTQo1ptMfQCgnTQji3gpT
	KY5MC5TZJj8wZ5N5O50yEBSXKPLgp08zgFC9yO/tcQJIwoABw/+SeCSsyETrAoCYFOhs4g
	FUGRyxa+VsrCYTRs5XeyX5GZqWQ0ACY=
X-Gm-Message-State: AOJu0YyRqjP3kAwfN8AxhmpV016K1pC0Nbpehzvd0DBKhmfTFRHKdX6m
	Vjn8GpLow4DqDMZavUb/whrfsm02hFqhnTXrl17oolgd3VA3XAy7eQ1XH7kVwpTTEh6DAGU0kj7
	H40n8erK/4o14jsiyBi8ZDVWUaUzUm9zgUPvyjhkv
X-Received: by 2002:a05:622a:a591:b0:51b:ff0a:2048 with SMTP id
 d75a77b69052e-51d71543adamr26047821cf.3.1784115337213; Wed, 15 Jul 2026
 04:35:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-14-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-14-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 12:35:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTypUuO5mGFvMcM3uxLV9AfT1o+ue97FxPOTETEFd-6gng@mail.gmail.com>
X-Gm-Features: AUfX_myf92oOkH0YbXhV4wPBITqN6TIW4rOsI6YKVHEl4UE5O_W3P54hnk7d2AI
Message-ID: <CA+EHjTypUuO5mGFvMcM3uxLV9AfT1o+ue97FxPOTETEFd-6gng@mail.gmail.com>
Subject: Re: [PATCH v2 13/18] KVM: arm64: Move hyp_vm refcount into the structure
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> In preparation for allocating hyp_vm using the pKVM heap allocator
> (hyp_alloc()), move its reference count out of the page metadata
> (vmemmap) and place it into the structure itself. This transition is
> necessary because hyp_alloc() allows multiple small objects to share the
> same physical page.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index c904647d2f76..624367d0ef5b 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -41,6 +41,7 @@ struct pkvm_hyp_vm {
>         struct kvm_pgtable pgt;
>         struct kvm_pgtable_mm_ops mm_ops;
>         struct hyp_pool pool;
> +       unsigned short refcount;
>         hyp_spinlock_t lock;
>
>         /* Array of the hyp vCPU structures for this VM. */
> @@ -65,6 +66,18 @@ static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
>         return kvm_vm_is_protected(&hyp_vm->kvm);
>  }
>
> +static inline void pkvm_hyp_vm_ref_inc(struct pkvm_hyp_vm *hyp_vm)
> +{
> +       BUG_ON(hyp_vm->refcount == USHRT_MAX);
> +       hyp_vm->refcount++;
> +}
> +
> +static inline void pkvm_hyp_vm_ref_dec(struct pkvm_hyp_vm *hyp_vm)
> +{
> +       BUG_ON(!hyp_vm->refcount);
> +       hyp_vm->refcount--;
> +}
> +
>  void pkvm_hyp_vm_table_init(void *tbl);
>
>  int __pkvm_reserve_vm(void);
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 3b2c4fbc34d8..d9ab58226889 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -278,7 +278,7 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
>         }
>
>         hyp_vcpu->loaded_hyp_vcpu = this_cpu_ptr(&loaded_hyp_vcpu);
> -       hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
> +       pkvm_hyp_vm_ref_inc(hyp_vm);
>  unlock:
>         hyp_spin_unlock(&vm_table_lock);
>
> @@ -294,7 +294,7 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>         hyp_spin_lock(&vm_table_lock);
>         hyp_vcpu->loaded_hyp_vcpu = NULL;
>         __this_cpu_write(loaded_hyp_vcpu, NULL);
> -       hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
> +       pkvm_hyp_vm_ref_dec(hyp_vm);
>         hyp_spin_unlock(&vm_table_lock);
>  }
>
> @@ -311,7 +311,7 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
>         hyp_spin_lock(&vm_table_lock);
>         hyp_vm = get_vm_by_handle(handle);
>         if (hyp_vm)
> -               hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
> +               pkvm_hyp_vm_ref_inc(hyp_vm);
>         hyp_spin_unlock(&vm_table_lock);
>
>         return hyp_vm;
> @@ -320,7 +320,7 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
>  void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm)
>  {
>         hyp_spin_lock(&vm_table_lock);
> -       hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
> +       pkvm_hyp_vm_ref_dec(hyp_vm);
>         hyp_spin_unlock(&vm_table_lock);
>  }
>
> @@ -966,7 +966,7 @@ static struct pkvm_hyp_vm *get_pkvm_unref_hyp_vm_locked(pkvm_handle_t handle)
>         hyp_assert_lock_held(&vm_table_lock);
>
>         hyp_vm = get_vm_by_handle(handle);
> -       if (!hyp_vm || hyp_page_count(hyp_vm))
> +       if (!hyp_vm || hyp_vm->refcount)
>                 return NULL;
>
>         return hyp_vm;
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
