Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC4980045
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707319826; cv=none; b=X/g3x3r2wIT2oyt24RRZ36Kp2h0yLFJsRHYBTVefC5uobZTaG2iXaJmxY0ILKvpZaJZf1Ry9O1/jv+4pKNP2v18SkU4/JeKoLsrvkZQxlJ8CN0hDjE8EhQR/Ir7EoN7IXoADhkfpzD+GF54WccCgs20Tz3nFdSn241jl9lR9Ki0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707319826; c=relaxed/simple;
	bh=29vGtu7yU0AAORwx8Q0xZo25ggpOKaABrK7glygmnuI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DO4cJKrGPH2v4hRTF/z2d7nK/A844ybONg6jgcG9NCsx7l+igmP3gTCBzQXIYCbxvU/vB5D+CnurCXlat1+m7d6cTGTpl47SoEksoTKmQFgsArdFqLqHcTUFygPnoB9xX3VzKllT+Hn8nlpVx4K5QI6kBVJSsqFWcrwSx7/Lnjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iDM6A/mb; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iDM6A/mb"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6bad01539so1006970276.3
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 07:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707319823; x=1707924623; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4HtoAHVB9z2HW85BOTsqebXKmcVqdZooPls6AoWI2E=;
        b=iDM6A/mbLRGODD++sknKEBz9ySgtgzlQN4lC+On8a+hInNLPE/wzHh2o+lwUd1mJuZ
         y9hLmZxTCKZHtPTROEp1U6zvUeEBRgpRTbmUHbaaY0KkKxLS4T6SnQC/uv22rkiYINOJ
         Ig1kyQjEivD2GHGDJjIW57hbjqbCEy3BqQ6balraBlJIrWJkb/JkvJE7xVg/K9Ys8vk9
         z1XLvKZGTDaWzookWvYJFS8bedcCKdpwa6cf0Mi41l8MHHsVG+RIBf8doFfId3eq7npW
         QL1CTerzOgArBcr85tbz3Q/NYm8rAQ1am/2vj7TY3ZOwW5cDNkvJ9ZLudmLrbvHYVnVS
         VBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707319823; x=1707924623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4HtoAHVB9z2HW85BOTsqebXKmcVqdZooPls6AoWI2E=;
        b=Y2KxHvgP2VNNyFOIEZyPbyl4dxOyj4XFfPEiRN5qeelRgw8qh85sVm/Md3h0LQPhBw
         n+SbmEAVpbc+TyzN8X8+85q/izl02MSnsvPJV/m0CVZ6EAubkMTkGZQt14f4I+wf+JYk
         La20xdcoVT+LIsYGo/cVH2Fb8xEjhZ6u0veocPRDGZXPKJZ5xXxwMGl4hkDVoc7S3BVw
         J0+UU1jOc3xjOER+bNmC/LYnGDq6BIiSGzj4hA3c+9oyk46xEO3pIactzZhIPsxjDr+G
         jgfHo2h9j5uGmSZ3DjtDVG7tfIdSaiW99P6CfLjl08h3Rrf6qGSFK2cjnxzaTR9x8TZI
         z6GQ==
X-Gm-Message-State: AOJu0Yx+VTg01LVHjANfdyYuNfbcKDwV1Z7lXytFHXPFaZzCG9cpg8FQ
	Nrl1Ga5Rn7d09rMKs+mEoca+/chE3Ap92SxCZlXanUdHzeEP1kQzdhablj/DsLGUXftgqHqALM8
	jvA==
X-Google-Smtp-Source: AGHT+IHm0UAeTY0jrRYDjxsi6/W2lf2idjMOZ/39omY/MC1KZboNEYOdi+7r5MhNrDC85iynVdmlrecExE4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2302:b0:dc6:ebd4:cca2 with SMTP id
 do2-20020a056902230200b00dc6ebd4cca2mr168524ybb.11.1707319823546; Wed, 07 Feb
 2024 07:30:23 -0800 (PST)
Date: Wed, 7 Feb 2024 07:30:22 -0800
In-Reply-To: <20231109210325.3806151-3-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-3-amoorthy@google.com>
Message-ID: <ZcOiDopfqnPc69rF@google.com>
Subject: Re: [PATCH v6 02/14] KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

Same "Documentation" issue.  And the purpose of the change isn't to add docstrings,
the purpose is to clarify the goofy/strange parameters:

  KVM: Add comment to clarify param usage for __kvm{read,_write}_guest_page()

On Thu, Nov 09, 2023, Anish Moorthy wrote:
> The (gfn, data, offset, len) order of parameters is a little strange
> since "offset" applies to "gfn" rather than to "data". Add docstrings to

s/docstrings/function comments/.  This change has value and impact even if the
kernel suddenly stops generating documentation from code.

> make things perfectly clear.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 687374138cfd..f521b6fd808f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3328,6 +3328,7 @@ static int next_segment(unsigned long len, int offset)
>  		return len;
>  }
>  
> +/* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
>  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>  				 void *data, int offset, int len)
>  {
> @@ -3429,6 +3430,7 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>  
> +/* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
>  static int __kvm_write_guest_page(struct kvm *kvm,
>  				  struct kvm_memory_slot *memslot, gfn_t gfn,
>  			          const void *data, int offset, int len)
> -- 
> 2.42.0.869.gea05f2083d-goog
> 
