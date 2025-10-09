Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFEC253F12
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 21:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760045951; cv=none; b=lVK19GRJMH/QDGmlmjhKT0e4acq8QP7cHxh3PSCL/TEt/UO1kbKI36xo06iliXzqkhiBKfBHeZrbpQsymDufEqZNkFQzaBNs3WxdtCy0ThN/3b3tMBf1Xg+gr3rB01rxslLZ9rQR+HslpWUyUZfIe61Izczmesizx0KpzVALvzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760045951; c=relaxed/simple;
	bh=BEzPWEG2tTMKJDi1Ui0rZYJQnidu+uUR6toMxPc1JGI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hPLVOjsWVNiA45Vt/LCiFQWMItao0ag+9jaDIUpSQFEzRyoEnaOvucITGWB/mG9iYGbKEU9tjDCNHVcuXLx7pJReSFd38hjgllYhyvg2HxP5YkNbHB5mORfN2ZWEJvmuDdLEEUFGCam9ZpehIdwHwHaamXho84dg9sS8RaY6b2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1pavlea2; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1pavlea2"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28d1747f23bso24658385ad.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Oct 2025 14:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760045949; x=1760650749; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GAMGpTBb5JIMylmtnuNcSJ5s50b2UQUcn7vzXw649qs=;
        b=1pavlea2dCUN4nVbvh6g7YvqnPjtLrf1UwSeA3HT1bgLRIA0bB5GYi3+6uFMELBFjr
         IEejHle+ckr9qzJgCq3qfIP/5/a74ISQyWh+WBTpB88JhRhYM+mQ3Jzi77/5aR8HqNsB
         GoKEWtnQhu/uhNN9fxyKyL092lrhyIkVITTBxwRdIW16U+qHEOAvWQ0hU4E2zQ68icsK
         QlstNZFoBfCdZBPLyDe7o1+FdVZEbMB86I78lQXxwM92ET4mSL7VOqGPUz8gGChRsNzi
         +1DK3d4qCuT5HTkn1RmzBHi9TIvavkZiKRARMBQg9ACMjNBVPVLIYdkHcKeRRCdtDM3s
         zW9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760045949; x=1760650749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GAMGpTBb5JIMylmtnuNcSJ5s50b2UQUcn7vzXw649qs=;
        b=YRk/qSSjrb+GU5oV2liQZn+yI1YG52zKlgKL3r3BPlTekm9HjSohe7BwlebfdokacE
         ClYVZet/d0BhsXW5EqSyuZGSQKf5+JL3uJUlHiwclq7j90wInRshxJhO9zTl0knzKKqZ
         XRzHTlTzOl8sYTyPaVc+5+6NVeQ8Pr94k2g1oYHq4K76OYKngBEFN99gFy5j6bhXdMIh
         A3n/yQ1w3Ch2OoyoDBAA8Kauwz++xkYQgigzOi/ac1uxJlP0rmuem1bAWw4Gp3JmLD8c
         aGi8XMhii5ce2Ap5p8F3T+Gy6LtP1AudQZzhh0DJCNAq2Waawdu05RWeSNUkGZCYcPFx
         /c8g==
X-Forwarded-Encrypted: i=1; AJvYcCUSNF/aWEPEvhGFKZ0jBc4xk4ukcRL7sL8FVejl0zUCgA26ORa0VSRVTKJ2ratjIdqgUszUtoE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0Bfr/9hfOxdEElzYB7iHDv9g567rwJTpdG8Xwrv3BC98KQPT/
	6XPSlAvc0kw5OINGhPYzXIOpU6EgItm+R3+t/QbnxVFAh3APZgjSiaf3sJMchLCHtN08qG8GXf/
	zNISY/oPL0EebDlqfY2VT3S+VzA==
X-Google-Smtp-Source: AGHT+IHiLO0Tc7T4efMeJ7arhzRn2QVrxkkt3xAe4o5ah0mgwx2R8IQxbSx0reBo3eWBl5LTjIgto1JJK2FqbDLCmg==
X-Received: from pjbne5.prod.google.com ([2002:a17:90b:3745:b0:330:8b1f:c4e7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1b50:b0:332:250e:eec8 with SMTP id 98e67ed59e1d1-33b51168e20mr13156235a91.15.1760045949059;
 Thu, 09 Oct 2025 14:39:09 -0700 (PDT)
Date: Thu, 09 Oct 2025 14:39:07 -0700
In-Reply-To: <20251007221420.344669-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-5-seanjc@google.com>
Message-ID: <diqztt07hi10.fsf@google.com>
Subject: Re: [PATCH v12 04/12] KVM: guest_memfd: Add slab-allocated inode cache
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
> Add a dedicated gmem_inode structure and a slab-allocateda inode cache for
> guest memory backing, similar to how shmem handles inodes.
>
> This adds the necessary allocation/destruction functions and prepares
> for upcoming guest_memfd NUMA policy support changes.  Using a dedicated
> structure will also allow for additional cleanups, e.g. to track flags in
> gmem_inode instead of i_private.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Tested-by: Ashish Kalra <ashish.kalra@amd.com>
> [sean: s/kvm_gmem_inode_info/gmem_inode, name init_once()]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> ---
>  virt/kvm/guest_memfd.c | 77 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 76 insertions(+), 1 deletion(-)
>
> 
> [...snip...]
> 
