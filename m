Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC98040D588
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270253; cv=none; b=bKTde8g1aqW7XqZ8AOhEVDsOsCg+d+Rd6ptRYD2ILzGdGgdFdjjtjqkwIKONiJNpKvxXLQGF8iBYU3ZMSGlFVNhJIxcnF49xAxO1OIp69UPm2CLIugGjRFEPmOIopQVprwFzIdPjfx6dd2zy413r2Boifk8jkfpsO/4IK/ADL8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270253; c=relaxed/simple;
	bh=N9G2xDWLJkhjpVHjPudlC9eB56JQvy0Q3UFpvQ70GnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H433k9nZ7WItkhGxf23c2Tznwfg8Zs8lW8P0+w0t59YNLvVsr7i/wcOgVywW/NeEzd05ub/25rrplxZYlx7ILrDWiWhrzZIlkgwkDOrevzwyIAHpLqTdeG+ybbko5EhVLVu8y9FXARph8Qg6lnKrBdcGU0OBOqBZULYh9CPSW1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ErZ/HyKx; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ErZ/HyKx"
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb76bcb1fso765481cf.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790270251; x=1790875051; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=feTLx7y3sxZ57LB+c+M8YbdddVhljMzyHzPRAu6TpA4=;
        b=ErZ/HyKxEzPtildauaVvuG9CsrkCE6rm90GrsxhZ/9dR1VJHQ5TU0zqxk8vUTUvjZs
         nJfyJJbwj0WcrVO6bO1gj4yRQ0M9Di5Jisek2cm8rrcYFX0jcc7dN2hVJ0lCOu1QH7AM
         i/0CdBvG8AO1gsINCUVhBbouPdCcqVPUwQWIhojRh+IF2Co7KLlN0Wp8RLgRAZYztdQ7
         IhYYWy4GaPusM+8lZBXZYlihTwBNWhFju5P8C8w632FQVCZrJSSOmPvcZZF50mt6NQAM
         1nLMmPt86xun46DnSski/v1DDns+vtvdzzInnhmh3HeVJYognTzwuDg9bZeAtSgzp2Gh
         Gp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270251; x=1790875051;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=feTLx7y3sxZ57LB+c+M8YbdddVhljMzyHzPRAu6TpA4=;
        b=DTrLXfHFm3MAR3GgdQV1/rmqK7TX1ICA1FfO01dHkP0nOoa3RUftPedZMnNDST1g3d
         O/UB4sJHNikT3YmDp2lsUwP+QEJ73HAKWRbV3Sf7Ir3thO1XZrK+vrTC+uL9r4thqIi7
         oYO4ZV36ZvYSJ43YuAVWE4mU4TEPpP8dOPNLFgW9JB9LBB8eTyePo8oDFhqmL4MCfEn2
         azj/ezeqS0U+ZELdA+u22p2UOSHSeTlvpmK2QgxHX5Fn1Vkm4WF4OFrISEkuJ3DxEF0U
         kn8O4soRv6s4tfrFzSc7MIT3cEpjFr6yzEVkivHt0dHj/wGSp821ARtB/RR2MKTLrvl6
         HFDA==
X-Forwarded-Encrypted: i=1; AKwUvBz+c2E8MvhJ0VONiwmsZLa+UXWhscfzXa1e5SOlIBkhvLHmUQ/D7vsDJE0PE11obkVDaDrP2Ns=@lists.linux.dev
X-Gm-Message-State: AFuF++mlCaO7eju0lcwaAhYv407eNrdZDA/TAZSRo07G2S0bHMyoFKe1
	qegV2WtlSE4JHCrsPgpU/W3WMhxsAZyugeuEZRxD09eS3T/VZS6sqaCzVP5IN3zdgi0=
X-Gm-Gg: AYBFou1NPofWQ/sl19OLKs0UWI7jMuFfBhtYG301N67lF51fCsJAtXC05MGJxMraadI
	6JYrYI0E64fHxFD5xm5IMKSUSpjx6elfqphC11Wt+HukRJw+N9hQEGldBagEjcFGCYAXfl27YKl
	Y1QneB/YUADZiW3DWINj/9kOmRolbnWOn2CNE7G7pJj+y/tkqDd1Sr72UzsaW0F9RHtubtuGnMh
	GgkU2/wfyI4nMLouhedC6MH8fPpdol/cVP6UvXqbqbUqnoCrMIDhEGQ7svfAxK6pFhtOhIa3rH1
	LqeVfKztfcsA7W6EYRqGxiQxbGrg46e9Kflwwrb1UYPSbem2rakAu/U6r8HnM9qMYrJsxs7QiFv
	iHXQloAh+H/22Mzg03ad9+sqxB/ZPaxZmW1DL7J+ZKEaLX54IsdVlxkrbZfQBdV1ieqJ4l9A9o6
	Q5CxauOoHxzMemfbHRS1JWsE2BWxulo3zz+1v7DXRzyqniqt8k4P5ZfOhuvaQOpG4T1lq0KixCi
	gwpR6870jEURP3SqvphiYT+4hm/tV9ae8toXB4Cj6QidawITPD3ypw=
X-Received: by 2002:a05:622a:2b05:b0:530:42e4:f001 with SMTP id d75a77b69052e-532feb3025amr31555731cf.46.1790270250746;
        Thu, 24 Sep 2026 10:17:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532f8b7174asm25743881cf.14.2026.09.24.10.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 10:17:30 -0700 (PDT)
Date: Thu, 24 Sep 2026 13:17:28 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Message-ID: <arVW5i8pvySq6Co2@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>

On Thu, Sep 17, 2026 at 05:22:13PM +0100, Lorenzo Stoakes (ARM) wrote:
>  static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
>  {
...
> +	err = mmap_hook_validate(prev_start, prev_end, &prev_flags, vma);
> +	if (unlikely(err)) {
> +		vma->vm_start = prev_start;
> +		vma->vm_end = prev_end;
> +		vma_close(vma);
>  	}
> +
> +	return err;
>  }
>  

I indepdeantly validated the sashiko report on this chunk.  Seems like
close() should be deferred until after __map_new_file_vma() calls
unmap_region().

suggested fix is to drop vma_close() from mmap_file()  and update the
cleanup in __mmap_new_file_vma() 

if (error) {
	UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
		    map->prev, map->next);
	vma_iter_set(vmi, vma->vm_end);
	unmap_region(&unmap);

	/* Release driver state only after its mappings are gone. */
	vma_close(vma);

	if (map_same_file(map))
		fput(map->vm_file);
	vma->vm_file = NULL;

	return error;
}

Example race:

  Thread A                              Thread B

  mmap(MAP_FIXED, address A)
    driver remap_pfn_range(A, page P)
                                         load/store at known address A
                                         hardware finds the new present PTE
    validation fails
    ->close() frees page P
                                         UAF
    unmap_region()
    TLB shootdown

With that fix

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

~Gregory

