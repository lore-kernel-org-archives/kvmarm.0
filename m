Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB54C28466C
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 22:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760048139; cv=none; b=RQL6i5c0EJUSYM5wtz+6IkSTj6XdfHl5KSgksuXbb9guTmIqv+MY65O6ITDQqrJstzqFOEbRr/kK+TqYvkziWmVqWtULJVSruP7aMdgzDltsuSmWtV0gvjLJXdJPBwFrkcGfT5IXPU+BOSFVtWvrsdwzheckYMtKbpv5YvhnzN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760048139; c=relaxed/simple;
	bh=rPMGm0dfGPMDOOmz7uP8n/Y9PsjG4xAePxsVEMFZ5Fs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GOL+emSdirkEV0XGHYLfWZzkpzp10pMiF8v7vOB/6mJmIOSrvlJFzTqYXhhg0eOY+xeJ/WN/OlR6RFiZVCXk/Dk5SKc5blF+md8YhalzcDccVDtUAh+wXiZX2Kmb+TRUP7jdTLxcMJFI9fMmorTqiVNTGsq1tKKYtyjVsJM7hOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pV1Ch4Eu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pV1Ch4Eu"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-336b9f3b5b0so3608436a91.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Oct 2025 15:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760048136; x=1760652936; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oll1MPE7hkNDT7M/Q1/FAEUqkNVEA+iYvJPlZMv+EKE=;
        b=pV1Ch4EutZcig03t9hkUlpqsHjBsPeUV6Hf7yhQvNpKwZyCBuHt5bRyZ29OquO9MlP
         HOTp507SHGmkUXRQvNunq1/bDGc7hYmBOOiSSqT6Vwbsg57cVge7suLd8psHqD6WPsce
         DOjNgyIQ4tmtGU6a8GVX2WBUl5dyPIkPVbLT5fHgvF0+7J7NyUj8Q6VYsGBREtTvQq3W
         r1K7zu8AYKdMttqXoLjoAmpQ45CjKU/1fmB6l9rktiW3Ekh1bTXavpFyriHS8oFPRnFM
         tBoe0MttJ+3gXGIqeeUSF7ElZnDC7SP+XYxVzsi4z0Ljlh8A+IC+KaamIWrGGdwirymT
         3XHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760048136; x=1760652936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oll1MPE7hkNDT7M/Q1/FAEUqkNVEA+iYvJPlZMv+EKE=;
        b=L8oCQhNAgJnB6itzHddKXAQhPFb8bQXZGZRncWFiocv3ATp4V/XKrUjeMtlJQiMMDv
         jcSu56PGBr3aVMieq0PrSXnzxvh6D5BHscQWPEHLFewRKx609WxWowUiEW8j7LtMsi4D
         jYmANNrZrpuSUS+YmfJnhWAZYcq/s75AoOvK4shilwX9VJp7T+LU3lLERBw1orgiUY5R
         D0tKamApVNLysxvAMGuz9xCE4USXCyqDYPvOc76aP9UInZzXCOimgOjpR0aNt3HqiEbE
         /HsIhksMmW4f5Hap69+94D8f35LpJcQ477Sg2gf6nFejxi9f2rrp3r9zkoxBRkviFHsW
         hAJA==
X-Forwarded-Encrypted: i=1; AJvYcCWuf+JhLZUNXA2J5PI7Z+3R6nJkaoKcc0i6oVT40cfHeVmBpnODIgSfas2opr+rB2KnYx9dMm0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIM2h3bij9jeqjlC9l2pIjQb5uLTbJ+jXFqyImNFqvPbIifrQh
	JKpAMGrBoLzrbXT4sVsIT4JWoLoQbnmgjyuf54I2iv87DhbJF/XoUnlWdrZi8HAPKnqDbSVkLN3
	/032rmRIW6IdmHnH81O7bLffzpg==
X-Google-Smtp-Source: AGHT+IHgB0xcVfauc1u1HW+fOsPb84FTf4YqLuG37YUk27FkO9AUKT3em4wnlAFSqHZKd0l5szDhiTWCqndJLqsXJA==
X-Received: from pjad22.prod.google.com ([2002:a17:90a:1116:b0:33b:51fe:1a77])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:38ce:b0:32e:5646:d448 with SMTP id 98e67ed59e1d1-33b513b2ab9mr11170579a91.21.1760048135969;
 Thu, 09 Oct 2025 15:15:35 -0700 (PDT)
Date: Thu, 09 Oct 2025 15:15:34 -0700
In-Reply-To: <20251007221420.344669-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-6-seanjc@google.com>
Message-ID: <diqzo6qfhgc9.fsf@google.com>
Subject: Re: [PATCH v12 05/12] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> From: Shivank Garg <shivankg@amd.com>
>
> Previously, guest-memfd allocations followed local NUMA node id in absence
> of process mempolicy, resulting in arbitrary memory allocation.
> Moreover, mbind() couldn't be used  by the VMM as guest memory wasn't
> mapped into userspace when allocation occurred.
>
> Enable NUMA policy support by implementing vm_ops for guest-memfd mmap
> operation. This allows the VMM to map the memory and use mbind() to set the
> desired NUMA policy. The policy is stored in the inode structure via
> kvm_gmem_inode_info, as memory policy is a property of the memory (struct
> inode) itself. The policy is then retrieved via mpol_shared_policy_lookup()
> and passed to filemap_grab_folio_mpol() to ensure that allocations follow
> the specified memory policy.
>
> This enables the VMM to control guest memory NUMA placement by calling
> mbind() on the mapped memory regions, providing fine-grained control over
> guest memory allocation across NUMA nodes.
>
> The policy change only affect future allocations and does not migrate
> existing memory. This matches mbind(2)'s default behavior which affects
> only new allocations unless overridden with MPOL_MF_MOVE/MPOL_MF_MOVE_ALL
> flags, which are not supported for guest_memfd as it is unmovable.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Tested-by: Ashish Kalra <ashish.kalra@amd.com>
> [sean: document the ABI impact of the ->get_policy() hook]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_memfd.c | 69 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 67 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index cc3b25155726..95267c92983b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,7 @@
>  #include <linux/falloc.h>
>  #include <linux/fs.h>
>  #include <linux/kvm_host.h>
> +#include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
>  
> @@ -27,6 +28,7 @@ struct gmem_file {
>  };
>  
>  struct gmem_inode {
> +	struct shared_policy policy;
>  	struct inode vfs_inode;
>  };
>  
> @@ -112,6 +114,19 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	return r;
>  }
>  
> +static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
> +						   pgoff_t index)

How about kvm_gmem_get_index_policy() instead, since the policy is keyed
by index?

> +{
> +#ifdef CONFIG_NUMA
> +	struct mempolicy *mpol;
> +
> +	mpol = mpol_shared_policy_lookup(&gi->policy, index);
> +	return mpol ? mpol : get_task_policy(current);

Should we be returning NULL if no shared policy was defined?

By returning NULL, __filemap_get_folio_mpol() can handle the case where
cpuset_do_page_mem_spread().

If we always return current's task policy, what if the user wants to use
cpuset_do_page_mem_spread()?

> +#else
> +	return NULL;

Returning current's task policy in the CONFIG_NUMA case seems to
conflict with returning NULL here.

> +#endif
> +}
> +
>  /*
>   * Returns a locked folio on success.  The caller is responsible for
>   * setting the up-to-date flag before the memory is mapped into the guest.
> @@ -124,7 +139,25 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  {
>  	/* TODO: Support huge pages. */
> -	return filemap_grab_folio(inode->i_mapping, index);
> +	struct mempolicy *policy;
> +	struct folio *folio;
> +
> +	/*
> +	 * Fast-path: See if folio is already present in mapping to avoid
> +	 * policy_lookup.
> +	 */
> +	folio = __filemap_get_folio(inode->i_mapping, index,
> +				    FGP_LOCK | FGP_ACCESSED, 0);
> +	if (!IS_ERR(folio))
> +		return folio;
> +
> +	policy = kvm_gmem_get_folio_policy(GMEM_I(inode), index);

If we're going to return NULL if no shared policy is defined, then I
believe we can directly call mpol_shared_policy_lookup() here.

> +	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
> +					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
> +					 mapping_gfp_mask(inode->i_mapping), policy);
> +	mpol_cond_put(policy);
> +
> +	return folio;
>  }
>  
>  static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
> @@ -413,8 +446,38 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_NUMA
> +static int kvm_gmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpol)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +
> +	return mpol_set_shared_policy(&GMEM_I(inode)->policy, vma, mpol);
> +}
> +
> +static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
> +					     unsigned long addr, pgoff_t *pgoff)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +
> +	*pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> +
> +	/*
> +	 * Note!  Directly return whatever the lookup returns, do NOT return
> +	 * the current task's policy as is done when looking up the policy for
> +	 * a specific folio.  Kernel ABI for get_mempolicy() is to return
> +	 * MPOL_DEFAULT when there is no defined policy, not whatever the
> +	 * default policy resolves to.

To be more accurate, I think this sentence should be:

Kernel ABI for .get_policy is to return NULL if no policy is specified
at this index. The caller can then replace NULL with the default memory
policy instead of current's memory policy.

> +	 */
> +	return mpol_shared_policy_lookup(&GMEM_I(inode)->policy, *pgoff);
> +}
> +#endif /* CONFIG_NUMA */
> +
>  static const struct vm_operations_struct kvm_gmem_vm_ops = {
> -	.fault = kvm_gmem_fault_user_mapping,
> +	.fault		= kvm_gmem_fault_user_mapping,
> +#ifdef CONFIG_NUMA
> +	.get_policy	= kvm_gmem_get_policy,
> +	.set_policy	= kvm_gmem_set_policy,
> +#endif
>  };
>  
>  static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> @@ -867,11 +930,13 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
>  	if (!gi)
>  		return NULL;
>  
> +	mpol_shared_policy_init(&gi->policy, NULL);
>  	return &gi->vfs_inode;
>  }
>  
>  static void kvm_gmem_destroy_inode(struct inode *inode)
>  {
> +	mpol_free_shared_policy(&GMEM_I(inode)->policy);
>  }
>  
>  static void kvm_gmem_free_inode(struct inode *inode)
> -- 
> 2.51.0.710.ga91ca5db03-goog
