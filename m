Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12E74B1E7B
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 00:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746576230; cv=none; b=CIKsNIjye8PvqL0P3bNv2BGggGGqT41ztx/QRW8p7YQzUHp4+KAFi8jKgk41tC3cQZaidsvzs8dord6bm1/eZNOafVSKRqYcIaJnPXLBH+vF4FqChwMEIcK5ZOi12/iroyNB2vcYR1dlbxq/MfUTzIMPSmq10YnQMlf69gcSPHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746576230; c=relaxed/simple;
	bh=VrNSbBLOCr7NEwSbl8xm2RoaraSzVHKq/zWcp73SSJo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HcR7Av/F8HxXZZ+0M/iV+Wtbpvlu7e76whkS53f9nzuh51Zf6DetSc0XRSo/BfyXO+z8tB36teWl7qh3O7at/0FU2IOslTUkkinQRmnlru+92T4If+GKd3XN1heP0zlKF3WyrOZNg0EC/F9HRik0E0mgqBQfklotnVWg3wPUHKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IZapz6gV; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IZapz6gV"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3d90a7e86f7so148337765ab.2
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 17:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746576228; x=1747181028; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5+m6HPDtb0R18pUg/qJCD2U+j03ktvX2ktaHxXO8cS8=;
        b=IZapz6gV15Jm8vVyOQzCJsDJhasM1gIcHps0iMtWUl5KYUjBlJBdJ4Rf3XS74CYF+P
         9oGKIzGFaDm+RlyPLvY5mBLYI5VsiEmb3X78HmD1337BDz0fGglbrNFN4qz/eW/ucCHa
         sABZhrdHsghzwJLqGOTRiVWxeZCagv68bmDNH7FcM9oQGUE2/pjA1UEkTJit65dmQ2nu
         yAmCRbEF8/x+T8G061H9sAiMphmDm/CcduE8x+Uk1ArcxGE0DB6hItxZKPpVDtA2MSWB
         tJ6xv12ceSJUxX45ZwAGTJNh6gl3N8kMBrPn1CNh1raXKS8S7oKva7i2jOl4kC/XYfF1
         9cmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746576228; x=1747181028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5+m6HPDtb0R18pUg/qJCD2U+j03ktvX2ktaHxXO8cS8=;
        b=oyLb1KeaeJG8377cauH+Ij57mWTTv0/b01PQnAto6IbDUSz4ycWT8WnBi/NO3fgAzf
         W1YzYHpIUcl0uZVPBWNVUki9u/A8WBd1ta9jVWXlEEY151kYS4cmpBU+IOY97qfcNYpU
         FtloofZwyTAbUQMAGZNcTJok5jL1Q8gEHLpaTL3dfyr4k6wwWlxt2WPEtjnkebo1DKDm
         XeNAPflVSe7SkYpYNESdEY0p6WxuBlemcNqviRRpaFeb+xsmyYAT/scTfvDRjR3J0gSb
         u6EC0Nb9zzVthrRWQw9VsT9uqNIia+3onF/lyYJxLUJktKUi4CXO+X9yI8xFyg2oEpHx
         /qbg==
X-Forwarded-Encrypted: i=1; AJvYcCURrAMaOaHZ6zvpnpziFyenNAMGz/jBqr4fvLjB0emUblKWWQODP7bW6WGz8nRbAWRgvQtfRkk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy50NzoNmVIivlKkz4UqCl4wYF+O42MWgyEau5mDVsA2aORokmn
	5vOqX9iBftEuf18F/kdBNnvf31EAmzwxxbYA0iDL4ElCdOWFNV0rxQL3cH5LGTwDIGQGFXVfekr
	ntg==
X-Google-Smtp-Source: AGHT+IG6Fxa93Bz0YoXvtTYguCqgLiKUWD1kixt49zVH2HtfKhQptZBHYIAFUFv7wo+hSUraRC2rqINWD4c=
X-Received: from pjbnb1.prod.google.com ([2002:a17:90b:35c1:b0:30a:7c16:a1aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d8c:b0:2f2:a664:df1a
 with SMTP id 98e67ed59e1d1-30aac156361mr2370837a91.2.1746576217154; Tue, 06
 May 2025 17:03:37 -0700 (PDT)
Date: Tue, 6 May 2025 17:03:35 -0700
In-Reply-To: <20250109204929.1106563-4-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com> <20250109204929.1106563-4-jthoughton@google.com>
Message-ID: <aBqjV40pb-s9gvsz@google.com>
Subject: Re: [PATCH v2 03/13] KVM: Allow late setting of KVM_MEM_USERFAULT on
 guest_memfd memslot
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, James Houghton wrote:
> Currently guest_memfd memslots can only be deleted. Slightly change the
> logic to allow KVM_MR_FLAGS_ONLY changes when the only flag being
> changed is KVM_MEM_USERFAULT.
> 
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  virt/kvm/kvm_main.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4bceae6a6401..882c1f7b4aa8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2015,9 +2015,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
>  			return -EINVAL;
>  	} else { /* Modify an existing slot. */
> -		/* Private memslots are immutable, they can only be deleted. */
> -		if (mem->flags & KVM_MEM_GUEST_MEMFD)
> -			return -EINVAL;
>  		if ((mem->userspace_addr != old->userspace_addr) ||
>  		    (npages != old->npages) ||
>  		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
> @@ -2031,6 +2028,16 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  			return 0;
>  	}
>  
> +	/*
> +	 * Except for being able to set KVM_MEM_USERFAULT, private memslots are
> +	 * immutable, they can only be deleted.
> +	 */
> +	if (mem->flags & KVM_MEM_GUEST_MEMFD &&
> +	    !(change == KVM_MR_CREATE ||
> +	      (change == KVM_MR_FLAGS_ONLY &&
> +	       (mem->flags ^ old->flags) == KVM_MEM_USERFAULT)))
> +		return -EINVAL;

Oof.  I don't even want to decipher this.  Let's just drop the blankent immutable
restriction, and simply say guest_memfd slots can't be MOVED.  guest_memfd doesn't
support RO memslots (and never will), and doesn't support dirty logging, so this
is effectively dead code anyways.  Then the diff is much nicer:

@@ -2012,14 +2027,15 @@ static int kvm_set_memory_region(struct kvm *kvm,
                if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
                        return -EINVAL;
        } else { /* Modify an existing slot. */
-               /* Private memslots are immutable, they can only be deleted. */
-               if (mem->flags & KVM_MEM_GUEST_MEMFD)
-                       return -EINVAL;
                if ((mem->userspace_addr != old->userspace_addr) ||
                    (npages != old->npages) ||
                    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
                        return -EINVAL;
 
+               /* Moving a guest_memfd memslot isn't supported. */
+               if (base_gfn != old->base_gfn && mem->flags & KVM_MEM_GUEST_MEMFD)
+                       return -EINVAL;
+
                if (base_gfn != old->base_gfn)
                        change = KVM_MR_MOVE;
                else if (mem->flags != old->flags)

> +
>  	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
>  	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
>  		return -EEXIST;
> @@ -2046,7 +2053,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	new->npages = npages;
>  	new->flags = mem->flags;
>  	new->userspace_addr = mem->userspace_addr;
> -	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
> +	if (mem->flags & KVM_MEM_GUEST_MEMFD && change == KVM_MR_CREATE) {
>  		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
>  		if (r)
>  			goto out;
> -- 
> 2.47.1.613.gc27f4b7a9f-goog
> 
