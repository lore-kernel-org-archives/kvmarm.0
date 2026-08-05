Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2D7481AAE
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785945563; cv=pass; b=TBYGYnfWCbGsEA7cGkzH7TWh2DraRdPBh18inrz7ZMlG15ranVGv5iAZNFDOEoP5bfhPdSk+Xk0bRvZMEz3XuFcXIfIVM+D9wUjtssRZvwYUijKHWSzlOW4L2JU3hdE3HUkAhFb2+CVOgoZ0+Yy8cqRpTD53yeAFnQBoo1mdm/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785945563; c=relaxed/simple;
	bh=vBtrTO+xzdjdKu06LW7AV+Jy0mqjzAYX4zJzogz18Ig=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ATSJWZfCZRQt35W2Grda6wCiWv78701uUP2facaXfdcnfjrajqLLwYxb+q3vE8BDbKgSD1mLBE0jiws6Ez2306Dq7ugBDDo+ll5/N1s1FZOcDnnQmSVAK6/f46oipMON1CkqJEAy/g7BCDsDgZQWS5wZPDmBswZoGpBwdUY68pA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sO0ISilC; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sO0ISilC"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-ca12086c06eso989401a12.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 08:59:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785945555; cv=none;
        d=google.com; s=arc-20260327;
        b=UombRl9JgEBfZN1zl7QdVdUSBo9wT7S2GGds6qIZScm2oLNRJbdMSdATX821RVzeSa
         UbGf3X3DT5SxqDlVCiGkQtoxF2Sg73WIRgZ4F4mUHqPberm1LRtlCK50NTUaH492ztt/
         KHxD95aQvUkXu8s74c2R9emjnWkbokiA6GvPUo+enYiWq2KZ9BFmFwzBhkt8rfzKvMK/
         sHuOKUEwp5YiZ3tnI3ClSz5mFpJzqKXydLNH4uphBIZJTS/yB4OBMMopsZFakWas5Cwh
         nayDGEAcFm4qj6ePiIQ8lcI5gSXR5Tw7aodwFtVtR4VGDYVaPxBwMwJY1+CUHFQtYKyr
         XmCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=6P2+ujme6g+HTSW6n7ztSC163pEV3pR8Oo8zV1D+dnQ=;
        fh=cE4eNH+e2vbZfdLkyRj4AjZUx4u0DfDVudHZAj6KaaE=;
        b=bZE3HPpNLlcikiMHQzSTtIh0jScUM0kLgRdJpZgeR65CEz8yj23UoCrs0nbozxZHAd
         wzHmRuL3CGGpdqDPVxQHCeh1fMRRa7wIWTyLWhYkXaG4sUJ/sc5ePJM/cVQxCElmCneD
         MWyVdv+8+JTsgoFibuOw/f6tX+x3xEPOwlb2gqp9C1+r/VWtr/ugRw2houq0uLn8rpOu
         ceNZGNbtF8pe286GDNM7iqOtI2npWErC4ITo7W2XeYzCPSfQfVgeIuGxVoEXCHanzgwO
         OdSqd3S/F6rehZ7NjLU6eC1XPgk7JfBC9EFTyhx55IqtJuUHIDLth316j9wNprjkS+je
         2loQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785945555; x=1786550355; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6P2+ujme6g+HTSW6n7ztSC163pEV3pR8Oo8zV1D+dnQ=;
        b=sO0ISilCvpByAx+VMNJph9/ZVOcWdBzmDKEuBi+4q3dfBaLorG6B1JUgcsxmJPOCWX
         aFFHTOz9+wHsHbPOg1hyEZc2gjzpAvCNCktqlikpzF7nmE0cKWc7evR43SxcKzQWP6G5
         vq5LPUSFTP1la3ge2fdyS7kVk/25Y8KBtgrU5X4HC5ZmrIl0Q800Ep7oChKu0/7m+mpM
         RC5B3VLMCAez5HNLoEXxZ8wRjAoT4altI+NDswHe1LWplTAz3zpIKzpOT0FynFKGtPSi
         q8w2VzJNk3Bd8nGjZYg8vuOeGV9uqVduOIKH1/tjM0msgi/gf3tSyO+l+flvpnZqwfnd
         spnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785945555; x=1786550355;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6P2+ujme6g+HTSW6n7ztSC163pEV3pR8Oo8zV1D+dnQ=;
        b=jd6bJi18geaf64X2WSHKIHq771xEF1Q1S6Wfy2ab1FKdEVHMeFie9tCchTsNerSW8T
         JnOGWwG1s36hI0xXdPUu0k5FIHEFhYAtGQwRWOYFaaVqr496kyMYRVxL6YuD25eCz1pf
         avlFvYcyvYeoM37l1n4JEeFBi+/zeBwfO6vDvU0BHGMhe1dfanHGXKl9vwVUZj5rzyHI
         CUDdCuIVI3wEQmHfBSKu+a6ZFuD6H1aQMY4BAb1q9RNCrrknRZHIJQTxxhx+YGaLzLgJ
         jcLp2XOxopJpvwYTscCIT+SJDuA21grD4tEo7iWLMvGWJ9GoIAhQzkopsA/ybwmX/YTE
         /S3g==
X-Forwarded-Encrypted: i=1; AHgh+RrvRy1JJ4bj1VlcAsTiIykbZVYUy+p0it0Gq3xRGQtQHA0uJg8CZFDyfj6+7f944j14TYCV2CI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRLl9HpgTJevNKckQ32UeIK1T2a92myl6/mceWep0tZPuQSMwp
	OvG75T0HIXlC0XjpfrYDO1TZ+s9QrA85YuNzSmU/3gdix8ZcDq7kbbHLz8q5ZNftBnif/E3PqP1
	EfGkd/hieqTvQUIZlcr726YMe9e/HSVWNtgBOCtyd
X-Gm-Gg: AR+sD10LyxMObqnGTVstGm33X3Fnj0thI0VSHI9EHJpaGI9Sbw1GhsWbIQFM69KDmf9
	u1xGr+5cGtpIJAemLWZ1B7ceUB1Ud/+WGtUOSUBHq6VlPWD5EN1jk5YvGsM0VZdb/0U5dd6ED4s
	40f1Cy6A4OmGo8A6EdHF5oKy/3nyjppMzdMv4RPrC8yDRd0do+6/NZgumJV7vGJeiKk4NwHD2II
	/z74YAw/q14iSeXStAVDBmXzmx5JWkOdTQ/s5cF2XMl627RfMRpLi+68FlG1g/G7LqG7x1J59HA
	4bMtOlwjZ2qUbcmDApgJnYkjIAtWeMUVdICgM3mz7cMrLTFcxVKhAPJuL7Ch+Zoq2q3G2FNtMts
	whONj9hEgJmQ3Bp8Bmghgka0gCtpSpnq4I/0=
X-Received: by 2002:a05:6a20:9392:b0:3c3:a140:9380 with SMTP id
 adf61e73a8af0-3cb85e469d1mr8503935637.16.1785945554052; Wed, 05 Aug 2026
 08:59:14 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 5 Aug 2026 08:59:13 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 5 Aug 2026 08:59:13 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260803134403.80630-23-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com> <20260803134403.80630-23-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 5 Aug 2026 08:59:13 -0700
X-Gm-Features: AUfX_mw87HguPfWFRxAUKpdtMQ3QriucOf-WRaZA41ldEtA-bI259FcP0zXpgjI
Message-ID: <CAEvNRgH+HWHgf26XDHN6aMLYjRh4M8okntBfjDFCBreXRXL=TA@mail.gmail.com>
Subject: Re: [PATCH v16 22/45] KVM: arm64: CCA: Handle RMI_EXIT_RIPAS_CHANGE
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Steven Price <steven.price@arm.com> writes:

> The guest can request that a region of its protected address space is
> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
> RSI_IPA_STATE_SET. This causes a guest exit with the
> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
> protected region to unprotected (or back), exiting to the VMM to make
> the necessary changes to the guest_memfd and memslot mappings. On the
> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
> calls.
>
> The VMM may wish to reject the RIPAS change requested by the guest. For
> now it can only do this by no longer scheduling the VCPU as we don't
> currently have a usecase for returning that rejection to the guest, but
> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
> open for adding a new ioctl in the future for this purpose.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v15:
>  * Propagate negative error returns.
> Changes since v14:
>  * Use addition rather than bitwise OR for adding the shared_bit in
>    realm_unmap_shared_range(), this handles the case where the region
>    includes the last address (which means 'end' already has the bit
>    set).
> Changes since v13:
>  * Switch to the new RMI_RTT_UNPROT_UNMAP range-based API.
>  * Drop ugly hack for RMM bug which errored when the RIPAS was already
>    set to the desired value.
> Changes since v12:
>  * Switch to the new RMM v2.0 RMI_RTT_DATA_UNMAP which can unmap an
>    address range.
> Changes since v11:
>  * Combine the "Allow VMM to set RIPAS" patch into this one to avoid
>    adding functions before they are used.
>  * Drop the CAP for setting RIPAS and adapt to changes from previous
>    patches.
> Changes since v10:
>  * Add comment explaining the assignment of rec->run->exit.ripas_base in
>    kvm_complete_ripas_change().
> Changes since v8:
>  * Make use of ripas_change() from a previous patch to implement
>    realm_set_ipa_state().
>  * Update exit.ripas_base after a RIPAS change so that, if instead of
>    entering the guest we exit to user space, we don't attempt to repeat
>    the RIPAS change (triggering an error from the RMM).
> Changes since v7:
>  * Rework the loop in realm_set_ipa_state() to make it clear when the
>    'next' output value of rmi_rtt_set_ripas() is used.
> New patch for v7: The code was previously split awkwardly between two
> other patches.
> ---
>  arch/arm64/include/asm/kvm_rmi.h |   6 +
>  arch/arm64/kvm/mmu.c             |   8 +-
>  arch/arm64/kvm/rmi.c             | 473 +++++++++++++++++++++++++++++++
>  3 files changed, 484 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 1e5026039458..751659a48be3 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -107,6 +107,12 @@ int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>  int kvm_rec_handle_request(struct kvm_vcpu *vcpu);
>  bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret);
>
> +void kvm_realm_unmap_range(struct kvm *kvm,
> +			   unsigned long ipa,
> +			   unsigned long size,
> +			   bool unmap_private,
> +			   bool may_block);
> +
>  static inline bool kvm_realm_is_private_address(struct realm *realm,
>  						unsigned long addr)
>  {

Coming here from guest_memfd, would like to look more closely at the
conversions-related stuff, and learn more about ARM CCA in the process :)

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index cd06881c1497..dcc2ab08d0e4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -319,6 +319,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>   * @start: The intermediate physical base address of the range to unmap
>   * @size:  The size of the area to unmap
>   * @may_block: Whether or not we are permitted to block
> + * @only_shared: If true then protected mappings should not be unmapped
>   *
>   * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>   * be called while holding mmu_lock (unless for freeing the stage2 pgd before
> @@ -326,7 +327,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>   * with things behind our backs.
>   */
>  static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
> -				 bool may_block)
> +				 bool may_block, bool only_shared)
>  {

Why convert attr_filter to a boolean, why not pass the filter through? I
think that might allow all the 3 states - unmapping private, unmapping
shared, and unmapping both. (Assuming unmapping none == not even calling
this function).

Also, perhaps it's better to add this parameter to
__unmap_stage2_range() together with the patch that uses the only_shared
information :)

I see that in [1] not changing __unmap_stage2_range() was going to be
explored, did that work out?

[1] https://lore.kernel.org/all/3b8d49be-f031-4134-bd20-a8c51632f4ad@arm.com/

>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>  	phys_addr_t end = start + size;
> @@ -343,7 +344,7 @@ void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>  	if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
>  		return;
>
> -	__unmap_stage2_range(mmu, start, size, may_block);
> +	__unmap_stage2_range(mmu, start, size, may_block, false);
>  }
>
>
> [...snip...]
>
