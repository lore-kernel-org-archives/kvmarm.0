Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57981352020
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 09:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787650482; cv=none; b=Yj9w3GwZ23HL4EjdVOryvkH8n571ToaDH8ajoYeBFTIgKg0UosoLoqNCZgASRdGKZ3mrE6S/Mw0MENCzDUfWmgm3IwAuJRnlGOHqcNaF0ICZM3X6o/K1/EuF+WaaofOhyBYNPAEFwGB0fG5iUEswRYBUn1ti5I3Rxh6f6VzEOvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787650482; c=relaxed/simple;
	bh=FH0frXmFwsMqFRMHSRLwB7W3NYpNGAKhsuMEZQNsz+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bscSTePyEm1Ad3O93+CtmzRIO+ZkiE7Ufa7PPsDfgOs08pJ1OLdWeMYuwA3fOvGOc33HZ/XvZwWeroFUJ/3CgQxgynsILGJo1TtgvEL8ogwoIoNiFM/RpTwHi2IwJoydojGlIMNkWpe2C919EDzYpqZzSiDv1ZCjamUqG+LbNq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FNKbhbE6; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FNKbhbE6"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4798bea72f9so2042490f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 02:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787650479; x=1788255279; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aeU8AkJ8MGIav9tcLVv0+ySWv2dXd+zHgL0Diag8WfA=;
        b=FNKbhbE6LrkMJ6Uoees2lRo5bZusdm7j/XdYvjuzr+qQLqXgK9vrKa4TtYhmgFnU+f
         lJ/n2uxMmnr9Zv2KG/wG38vgjJKJK6SK9FNOCgxpzNuIg5zI5xTnWceC3VpHUw/BnObd
         dBemcIk6Mqb085rwTH2DJ5j5aZ1FBcMJ9wKPigXp+dbsLmViTkcLk2+3jNZ8j+RGCcNE
         +0hqbZztRVCqydCbBLZnbkD69hZp+vCFDb1JYgppxRUB4vhCVThBdZEOPQ5+Tb1JMxCd
         EEhAtf1vOD81ZaDgs2760ByCo7J+ykjd7fogYmRivYy2BkNPQQacu1GW4xoQ76YJbWVR
         xHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787650479; x=1788255279;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aeU8AkJ8MGIav9tcLVv0+ySWv2dXd+zHgL0Diag8WfA=;
        b=mFfIozABDEXPb//DL81ctKSNw28fWkl0NQjHSrzYAKB3ueX2MOMjAAiJdGsprzbQse
         BYwfK6m3y0ZxdCROXOpvUzPeQdXfTeGLMdPEvZu6db8o4pK2vt6+USp20mOml0B8gPWj
         DKo68CTFSDQahOUNP34N/w3+dICZaNUv0D2yoPWbBNYHeGa8eFPHz6YxbIM6E2T6yH5l
         c43y2Uk0ro8Cth+I+bwnmJhNsBinV75URt7qotJRlRi7eZbMiX11VLIOaOFcjE+wXF2r
         uU1kqnpT8OBd2AbkGIHoUFIMmvtVgQ9AWlBhVHI3jYz/eoeyjc5T8Vs27qogr+//xfgQ
         /q6g==
X-Forwarded-Encrypted: i=1; AHgh+RpJXNdPra3KslBEgRww8xm8npRt5S9kMd4K1qUepxc8IEJ+3yrjwhKksd+M+31PPNRqtV5XIZQ=@lists.linux.dev
X-Gm-Message-State: AFuF++kWDQK6+28CaNzq2wuoZVup6cOOv6jwjhl6wdt+iq8i1kuNsCFv
	IA424yOj7uNJmLSI2mEQyidDumr0VysDyJ9uIPmRweTDRiuF3TAyEWcnCDtWcD2DRg==
X-Gm-Gg: AR+sD10lAdhxoN/VUkqB957AUCgRBOZFb92XHiWyt3dwoL7sznualz+G7Jij7ATt2TA
	Pn/9RroCAcC3ld8KN/lVtNJn0gXuMMrmUabnfrKDHArucAg8/CTonLiInaUCCkZDtxR64WnFXy8
	dYXSE25aOVFiYXo/F/mdtZXt/lNvdyGT2jFlbi3RFokVPeIvJwHTgDO8Z3Md1MD/6YGL/Abo6NB
	u5fKLJJJJouq3PY1bEYYGrUhCS2GGKvXDSOiPAr6Vnak0eElQmURuv8gx+OaiLUwntWhycUCzDQ
	EgUHZhUjAI/0P0m+3d6U7A3lkbVm2WExdsBTB89iwZTBN0e5JdTZCe+OGm04EeNmYXreeq+TXCi
	u5Cd6U968udeNU0G7hTURSbZ3uC4zGT3mzM4KPR+AhCtYXKZO7eRy0fMDBW9VOXHda6CIGdewbK
	lUgeIj4EQ8vj4AgcMFWLEdIG2Jx4mCSd5ZHrPaqsxS+xT3sPqwTVgEngZC+wXT55DePB2l0JSV8
	Hgflw0y2PC6gXEQPuLzIcmkqWR1q133
X-Received: by 2002:a05:600c:1387:b0:499:7a4f:d13d with SMTP id 5b1f17b1804b1-499b8313ad3mr338541545e9.4.1787650478642;
        Tue, 25 Aug 2026 02:34:38 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482c9b69cf5sm10736399f8f.6.2026.08.25.02.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 02:34:37 -0700 (PDT)
Date: Tue, 25 Aug 2026 10:34:34 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v4 11/17] KVM: arm64: Filter out non-kernel addresses in
 kern_hyp_va
Message-ID: <ao1hqq-BCmKWmQE7@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-12-vdonnefort@google.com>
 <CA+EHjTycM7b4d1foNQr33e7dN7WHyeg-Ww8nPkSKu78DGDs9_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTycM7b4d1foNQr33e7dN7WHyeg-Ww8nPkSKu78DGDs9_w@mail.gmail.com>

On Tue, Aug 18, 2026 at 03:45:23PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> 
> On Fri, 31 Jul 2026 at 15:36, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > kern_hyp_va() is idempotent for the hypervisor linear space. This is
> > handy for nVHE hypervisor callers handling kvm_vcpu or kvm_arch
> > pointers. Those pointers can originate from the hypervisor space (when
> > protected mode is enabled, we don't trust the kernel and the hypervisor
> > uses its own copy) or from the kernel space (we do trust the kernel in
> > "non-protected" nVHE).
> >
> > This idempotence does not hold for addresses within the hypervisor
> > private range, like the ones you get from the pKVM heap allocator
> > (hyp_alloc()). To resolve this, filter out non-kernel addresses based on
> > PAGE_OFFSET.
> >
> > Leave the assembly version untouched as it has no current users.
> >
> > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index 6eae7e7e2a68..d60e5f2de10c 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -126,6 +126,9 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
> >   * replace the instructions with `nop`s.
> >   */
> >  #ifndef __KVM_VHE_HYPERVISOR__
> > +       if (!is_ttbr1_addr(v))
> > +               return v;
> > +
> 
> I gave this a tag earlier and only came back to the cost side now, sorry.
> 
> The check is unconditional, so plain nVHE pays it on every
> kern_hyp_va(), including the one in __kvm_vcpu_run(), and it has no
> private range to protect.
> 
> Could it be gated on is_protected_kvm_enabled(), the same way patch 17
> gates hyp_trace_buffer_alloc_bpages()?
> 
> Cheers,
> /fuad

Sure, that's really a micro optimisation though, I don't think that
is_ttbr1_addr() is expensive.

-- 
Vincent
> 
> 
> >         asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"         /* mask with va_mask */
> >                                     "ror %0, %0, #1\n"         /* rotate to the first tag bit */
> >                                     "add %0, %0, #0\n"         /* insert the low 12 bits of the tag */
> > --
> > 2.55.0.508.g3f0d502094-goog
> >
