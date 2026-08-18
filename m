Received: from mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41938388E62
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787064376; cv=none; b=rDkFzDzS9kD39cKMBCaB8L3CAmrQ/CamEydcf6ItpZSxqvJW+phq906AhqpDzWdq4Wg3vij7p1lRJ2gIU6AlvR2DoXBsEeoO7o1qGn1rfVxB5ow177AZ1KDEO1A66lYuN2eYZs1En730tmNMDgFblwOLqWen5jB4vvcufSxFcdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787064376; c=relaxed/simple;
	bh=CieHboMpuXfbRWDkCH9YDuDG33RKKvNl4sdtiHansdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pVYuCgu89kjFzE+cB7yAVq8P3dIGu6ubc2tzDZZ1wbBferSGitO+23/kODBbqmSDIDCbqPJNIIwmJXuBhWGP1f7v+cmg0771nlp7GvaBsWWDPgRgbAv+85yo/enOWaq7SEk+tHXnFl3CsR0CYv5bfxlFeSTH0ENI8iJ2OyudDHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ogDTc4bO; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ogDTc4bO"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CieHboMpuXfbRWDkCH9YDuDG33RKKvNl4sdtiHansdU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787064371; v=1; x=1787669171;
 b=ogDTc4bOFWBRB0YVuEHGYb3VpRXenVr+4AydDsmS67wVv+gEUfMj6Dx4fmKKc3MQ/OoybMeK
 MZTDBQFF7PuBhEYS497MyFqNACX1Hl3n4YZFygGujiLgwVy+ZUPtGCdx7HdzBP2JDw+chlfGNsv
 l7WNi4Lx4a5YT7HqpSyv+RWU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f48.google.com (209.85.167.48)
	by smtp.migadu.com with ESMTPS id 77082c66cd5ab45e;
	Tue, 18 Aug 2026 14:46:00 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b2a8173142so7376e87.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 07:46:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro+fIdTiVJBIHi8y+bUPavWhGb7SJ2vo7BUU4PvTwyvBy3GATKbazMGvNtyk3F1RdrbPQK1Bvs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCS90gLyOQ3EJwPxXOykiaDRthAq0IY+OZeF/R99Rm6cWhXwGB
	XxEwW9GVf65AH3i7Z0/qB3Y5mOQuuJ7+A/XSTRL96/oh3hMaJJBbQghEn6McJVn3yzoelc/BsY5
	5m9rRwqkGnbxOmNJICs9nqLJiSd9teg3NQ2GM2oYK
X-Received: by 2002:a05:6512:1292:b0:5b1:ca0b:25d2 with SMTP id
 2adb3069b0e04-5b471ecc7bcmr238410e87.4.1787064359769; Tue, 18 Aug 2026
 07:45:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com> <20260731143541.956291-12-vdonnefort@google.com>
In-Reply-To: <20260731143541.956291-12-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 18 Aug 2026 15:45:23 +0100
X-Gmail-Original-Message-ID: <CA+EHjTycM7b4d1foNQr33e7dN7WHyeg-Ww8nPkSKu78DGDs9_w@mail.gmail.com>
X-Gm-Features: AcwNN1WxghC3g5qogm93X3-BDXmvBeGlnHJjBQyn_ThrrYLqy3XthGmODUrBhcE
Message-ID: <CA+EHjTycM7b4d1foNQr33e7dN7WHyeg-Ww8nPkSKu78DGDs9_w@mail.gmail.com>
Subject: Re: [PATCH v4 11/17] KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,


On Fri, 31 Jul 2026 at 15:36, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> kern_hyp_va() is idempotent for the hypervisor linear space. This is
> handy for nVHE hypervisor callers handling kvm_vcpu or kvm_arch
> pointers. Those pointers can originate from the hypervisor space (when
> protected mode is enabled, we don't trust the kernel and the hypervisor
> uses its own copy) or from the kernel space (we do trust the kernel in
> "non-protected" nVHE).
>
> This idempotence does not hold for addresses within the hypervisor
> private range, like the ones you get from the pKVM heap allocator
> (hyp_alloc()). To resolve this, filter out non-kernel addresses based on
> PAGE_OFFSET.
>
> Leave the assembly version untouched as it has no current users.
>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 6eae7e7e2a68..d60e5f2de10c 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -126,6 +126,9 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
>   * replace the instructions with `nop`s.
>   */
>  #ifndef __KVM_VHE_HYPERVISOR__
> +       if (!is_ttbr1_addr(v))
> +               return v;
> +

I gave this a tag earlier and only came back to the cost side now, sorry.

The check is unconditional, so plain nVHE pays it on every
kern_hyp_va(), including the one in __kvm_vcpu_run(), and it has no
private range to protect.

Could it be gated on is_protected_kvm_enabled(), the same way patch 17
gates hyp_trace_buffer_alloc_bpages()?

Cheers,
/fuad


>         asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"         /* mask with va_mask */
>                                     "ror %0, %0, #1\n"         /* rotate to the first tag bit */
>                                     "add %0, %0, #0\n"         /* insert the low 12 bits of the tag */
> --
> 2.55.0.508.g3f0d502094-goog
>
