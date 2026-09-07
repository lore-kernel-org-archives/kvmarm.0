Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478DF30675F
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 10:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788776094; cv=none; b=kdxQv2HJu6cf762u7nChEBHCAf1vgnmCe+58IE6qG+71NNvmlgV5Wq3InXaxJmEXy7jy6NF99uw0nk5hDxqBjPc911Y+8Y64daK3HzPWX8T9hq0kr2un7xHKCC1g37NLPZAvbtXp5JLmJmmIi8q082li0W6jaLySa3D5uaq8zac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788776094; c=relaxed/simple;
	bh=cXdqsLo120TY3TCRdOozGdXnOYE9gF95a8GwBjQ+9W0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tYlHAbx9etn0knHxkxq99jSI0W1o8NR5oXM1ItlHpClInP64H3qEKMBRQdsOWncuk8Hr/HEdsaCVs5JFergLU2tdSZgVGbZhw7t0q1Zo0FopQfYIjED8sJpV594oRcTrD3cqfFQyggrlCmqmD0mBMoVet/admgMfNUG/jj6QJrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aI0m1HtL; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aI0m1HtL"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1670dad7a8so507896266b.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 03:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788776090; x=1789380890; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kgGLBV2hAy5Dzl/eCzlxyTb+6ng/OBGxSoDpE5wbGLg=;
        b=aI0m1HtLdGkFbSSSCfGfa+mgd6J9c9wx52tUPLw8qxt1hwdNIQjiQReLHZNFlMm+HS
         XbfFq/xb47/sB2n0Qym2g6392fR2HRg7H1s/ioV+EnH4U0dFOUjGyjDtilmjulP3GlM3
         Qy4VEAGt14cxM++7xuPslzWOpGEEGDuNElDe1ljxnj94qJZlYB2ggeC4EuID8mEdZ4hb
         Dhs7SXOUb3erAByQD3P8KIRf2xz8BzIPRW/9pc2CpNamTKYyfVWmPVV2+sDF79X8nwVh
         j+OE5TXC83lShcuYGKAKWVctA+fS6J/ecUPkNCzXAAHNUogDOZOYjMRE4szUZFNNpo3p
         vbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788776090; x=1789380890;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kgGLBV2hAy5Dzl/eCzlxyTb+6ng/OBGxSoDpE5wbGLg=;
        b=PRHs6PQhM8nRPY2kY5gxC2WnmEKI2Uu7/lgzf9CKFOHSftvVDUSbea70Hxo0u75eFi
         4nPFYheATX6RqXIOq+RQcf5HhXgzhYmXVyW8KgTnJqf0Mi0l2tXuqaxMv7BySBPZk5J8
         37dQqKVlfur8JBq4/szD1deqVZLAvQ/Zocg+HUqrv1VhEhOS0Q9gnpVuZRtsUNdPhLmX
         TNDvWYZDh2iS6DGJQVV2EQ+20AIgO89dQ8GeDHvjTfMR21Qvfmjh1PAd/J4/fF+tpSI2
         0uSTy68jiq+5DzGXTH8PIb5rddRX1jk7q4JBwDV8YBgWnUSU5WH/jaTSr2ZqYPozRgD0
         mo3Q==
X-Forwarded-Encrypted: i=1; AKwUvBxPVlSAHF3Wg/BT9J3yni0e2+WFqEl3nvwTUvd2K3IFzwb+KqfNOWZ8ReypeZHy4tF3Okp4RnY=@lists.linux.dev
X-Gm-Message-State: AFuF++nUcY1oNiwndyr49TDRJWvh9lF6ZAQsIAaZb9LhC74TxK+GxO7+
	MNHhiPMaCdtRDEcKJ51aIMXminai0grUURNL2XuQno6Ed7CeVgYhpO47tHJhbZdO+aLpX/ydAKf
	5/rQAKw==
X-Gm-Gg: AYBFou3qPid0JI72CK+izN37vwehbo4DUCPYPUzhNWYYKPofvaHDz5cmeph+wm9E2ki
	apmveoiOZAgwAfCV0P6BoYUekVJGgY9M0bO4HWhLACSrIfN2YGqC3Iw/HsphcaH2A2IU3tacC1r
	PFZcxpWk+y/tJp+qX/CELHjDYv5yGV3YdiBzieZgDSQ5XrBRlXy+VIT/szobrsz7jXNDosw89HP
	PGg1qjNlFTmX2ojMYo/wQdmGmM0n1VMEE8wW7hx4EV628jQseFaiqyXnW32D0VtQBLuj5mkRYXE
	RNfIPZFMDGyq/8ADktZfHQ5/ZaDOQ0j3TxDqr6/UWVCp4uzwhNPp2Eg2Kdb/aApsFHltVMx6M7x
	HLh9ku0ve3ZtYiYWaMLE8AkS92e4J6ItWySwJctoLBleHKkJdUz+NYf/OKuHpOIuK2JkFKtNJKl
	gYhW6K6tKHY9ICdt5F8/CrbwFE6mkc6w5j7f1vg4D5jWVAHh5cz7UmD3Uov5SJ5rFtYJaV9rjj0
	3F6KfKprsCQ7bJMxF0vyrCmUxQqctPg
X-Received: by 2002:a17:907:72c7:b0:c26:30fa:7cf2 with SMTP id a640c23a62f3a-c2630fa7fb2mr416258166b.13.1788776089665;
        Mon, 07 Sep 2026 03:14:49 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d03644bsm449759366b.6.2026.09.07.03.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 03:14:49 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:14:45 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 16/20] KVM: arm64: Add __pkvm_host_split_guest HVC
Message-ID: <ap6OlRx_Z4BJsXjZ@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-17-vdonnefort@google.com>
 <20260803105428.76EEF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260803105428.76EEF1F000E9@smtp.kernel.org>

On Mon, Aug 03, 2026 at 10:54:27AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Failed guest stage-2 page table splits leave the host stage-2 ownership metadata permanently split, causing subsequent split attempts to fail with -EINVAL.
> - [High] Incorrect WARN_ON() semantics in host_stage2_split_gfn_meta() turns a recoverable memory allocation failure into a fatal EL2 panic.
> --
> 
> --- Patch [16]: [PATCH 16/20] KVM: arm64: Add __pkvm_host_split_guest HVC ---
> commit 76334f00eacfa593f4125057892101e13067d2e0
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Add __pkvm_host_split_guest HVC
> 
> This HVC allows the host to break an existing block in a protected VM. This
> will later allow the guest to share a sub-region of an existing
> huge-mapping with the host.
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index e16dde4c5f4b9..71ebd1856cb0c 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> [ ... ]
> > @@ -660,14 +658,49 @@ static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
> [ ... ]
> > +	end = phys + size;
> > +	while (phys < end) {
> > +		u64 meta = host_stage2_encode_gfn_meta(vm, gfn);
> > +		kvm_pte_t annotation = FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_GUEST) |
> > +				       FIELD_PREP(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta);
> > +
> > +		ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> > +				      phys, PAGE_SIZE, &host_s2_pool,
> > +				      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
> > +		if (WARN_ON(ret))
> 
> [Severity: High]
> Can a memory allocation failure here trigger a fatal EL2 panic?
> 
> Since WARN_ON() at EL2 expands to a fatal BRK instruction with no "warn and
> continue" semantics, an -ENOMEM from host_stage2_try() will cause a hypervisor
> panic rather than taking the error path.
> 
> > +			return ret;
> > +
> > +		phys += PAGE_SIZE;
> > +		gfn++;
> >  	}
> >  
> > -	*gfn = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
> >  	return 0;
> >  }
> [ ... ]
> > @@ -1748,6 +1788,39 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
> [ ... ]
> > +	ret = host_stage2_split_gfn_meta(phys, ipa, size, vm);
> > +	if (ret)
> > +		goto unlock;
> > +
> > +	ret = kvm_pgtable_stage2_split(&vm->pgt, ipa, size, mc);
> 
> [Severity: High]
> Does this leave the host stage-2 ownership metadata permanently split if
> kvm_pgtable_stage2_split() fails?
> 
> If the guest split fails (e.g., due to memory exhaustion returning -ENOMEM
> or -EAGAIN), the error is returned immediately without reverting the host
> stage-2 modifications made by host_stage2_split_gfn_meta(). This could cause
> subsequent split attempts for this block to fail with -EINVAL due to the
> desynchronized state.

Not sure here if I should just WARN_ON(kvm_pgtable_stage2_split()) as we can't
rollback host_stage2_split_gfn_meta()...

-- 
Vincent
> 
> > +
> > +unlock:
> > +	guest_unlock_component(vm);
> > +	host_unlock_component();
> > +
> > +	return ret;
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260803100904.3563942-1-vdonnefort@google.com?part=16
