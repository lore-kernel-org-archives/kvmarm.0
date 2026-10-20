Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792485085;
	b=oCHwPSP8V68ubvM8qlGFFeQsByNjA4RBUr84Hg6unnrxRtbBeBOFojxzRMgfFnEnk21y
	 5i1Pcza7crVevJX7CpKPLsSuordhWzsJYXPh3yqu4XoSkC9MP1NpLthvdGINreWPoZtDg
	 17OIIsioS9xN8F+pmf5bDRydbDnIjdERMcuFl3MusICqFLE86kKj0zyYeDZMR/zfKLXlA
	 +piCd1CdMQbXPybHlGGYAP5fbgw+NaL5oRLMPgCfBK9tY2VC9tyyEPUSpU8FFOzrvhApE
	 ihkwv9AWe5TJ/qp6yRWmJo9KTht7G1n4hytHCduwh7kQAKNyJ+bIlKNChYLgCBx9Ygg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792485085;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=aXThUahDPZjGbRfHjcT4v6EeFVqqPmsU8xiktNdbhT4=;
	b=r9fBA8BSDPHHY2er7K3JiCAn1vWeXw/2EBfmEUpT5fZWPUY0aKXPQgGrMdcLIoBn8/eZ
	 qUSfpMGGxDDfTCVo820d3lTqEwEEZgsaYOSIAiG5EyEdezXOqDBXRiKAexuoos2LxUwNE
	 waC4FfVDQx9ZkTMs0KD4TtKkXmR1QYU+tq2tiijQI/iBoyjC0ziZIuZLZpRtfdGT3JlVI
	 6jIa0bMSVVrRoeBrCBq242ZE/RxbBv+qOzQVZlbXvw7OYQz27yM2MOfj3J6I04dXqiO+d
	 4tLl1kLbxkWsaZgNkxAS3sheZ4jkB5JpStmo6hpYytrWTtyxEBp4pEzG5LflgVGTddw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=RC+aZT7a;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF045606A33D
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 08:31:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF045606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=RC+aZT7a
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1ddc7c9beso13700775e9.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 01:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792485083; x=1793089883; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aXThUahDPZjGbRfHjcT4v6EeFVqqPmsU8xiktNdbhT4=;
        b=RC+aZT7as0N8o7z2fO5VAgRAu+eJuQEdkaqJZLn3ABZ1yRszd8xzsbN02mc9U1Yr6c
         Ph+a22FyXd7j2J26eTEECToG1BBBAHYLSSDbLrmTiBOfbplVEGxuf4FZp9Gicevr3cGi
         U/zqQu0qoLNuYnrQeVyeXLO2o8hWCICi0//TFRedS/42UHQVLPjWFtPpGGFqlaU5OR/D
         DZhyvW56yUfQAwj1hrt7BaamnXk63hMC3vToWBDNqbRYnW0Eg2DBG/VWZypaTlNFzsbE
         xTF1NDU7AMOkCHZf8Ngpnah3fdlzw82MAivzNqU0EfcW4b1RIgB7k7cGlXfDhK+d7UiE
         7EVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792485083; x=1793089883;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aXThUahDPZjGbRfHjcT4v6EeFVqqPmsU8xiktNdbhT4=;
        b=G/UBuae/NJLGOOmYIpw/GvUeUrEoW+PL/su3jRWkODpjuwIsUTrElXlDcd5WC+L0yR
         cirekWo0ZX+QiHJ0uhxj3Hdvll/hJ1fHIvv9cAfui6zqyzvmybJAtgRX9ztSvwM13LMB
         3zZeV7AqcREG/K3oXzRMhsZ30EaRuVVNpeIBmvxZvOQbB0koCZlO/ObFuTCQZ6jpnoBT
         XkOq8wmuRxaniATR8nlwUNAF2/uJoOzmbdbHf7UwXEzfA/BLrt5BF4Pwzzml9VZEBvuH
         HfkUXj6prR+OB6Rb8yfof25Ox5xXIPCHqjJo+r8lMe5Qx/iPN3pe8vjmHrqLmy7d/DXh
         0KUA==
X-Forwarded-Encrypted: i=1; AKwUvBxyVDrwiKiN+KEAFDp4xf8mquZqonzUvcYqpG1RszipjnB9rDnxG3Rxf0ooHi2L49q1BH01CvE=@lists.linux.dev
X-Gm-Message-State: AFq9FYLLPocmwH5w3H2E76t1aJcr7AIgw6QL7xGHa445h8yvcIonNf8H
	WGHUfxO0WWTXDEESaTpwCt1OS3NQ8/6clIODTAYTmWkNel7l6xxbeBxUVGenwfdRIg==
X-Gm-Gg: AYBFou3KmW7ncuHsjaVbbvVk26PYhjdXez0W32tlDxu6MU3Mw6eS1A3hBMOtBeSGCns
	lyRa6D6Ns1/D/TtD0t1eL4zUnJt0Aub5X+9aHi9102WbNaIMUztiirCdtfEx/6TqZGyx2wu0Ga6
	CHe66Xk73sIcgDJ0CRPCF+WKoR5b/gXLmTis2HiKuBTJzeIANF/FhHFA+8Uw4/Mzd2FnX4B/q3s
	9BQn0pAXoRX+nG/Mb43/w3dm9vknGg2ZDVCJ2tIDohKpOFe7lg0FRFdNveHmmFsjm6Fv+jiJrh8
	WWs8nVb8JmblWJ7MaS7ci1h0tp58o36c4G1z8O81c3xtHMYgcbxHnG9GzILfD0PJjdnnrxbVJFu
	4pt5hwjELpZ5mfdRCI9tHnIYnDz46bmvNdrfGCC1M6Uuto/JiGiQGd0BHeCNN9eNBpPR2rTwtyN
	9NqswhxGTYuCFn+6Ourjm+/0SonVNk78NwH2xYQDOlIEWTIxaLA8TX2DyBFBWrfKRfj64nrFXbj
	fdRuDKda9vISiz+ZdJnmM9i9FX3mXFHccsZMs19br0=
X-Received: by 2002:a05:600c:8709:b0:49f:ff73:9971 with SMTP id 5b1f17b1804b1-4a1d75f8f28mr203436305e9.18.1792485082200;
        Tue, 20 Oct 2026 01:31:22 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2d324f8sm48973225e9.6.2026.10.20.01.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 01:31:20 -0700 (PDT)
Date: Tue, 20 Oct 2026 09:31:15 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Ensure TLBs and I-cache are private to
 each vCPU in pKVM
Message-ID: <atcmp8kdDdoM4RnR@google.com>
References: <20261020074311.1873316-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020074311.1873316-1-fuad.tabba@linux.dev>

On Tue, Oct 20, 2026 at 08:43:11AM +0100, Fuad Tabba wrote:
> All vCPUs of a VM share its VMID, so KVM flushes a physical CPU's TLBs
> and I-cache for the VM whenever a different vCPU of that VM is loaded
> there. pKVM guests, protected or not, run on the hypervisor's stage-2
> and VMID, and the host doesn't flush for them. Nothing at EL2 flushes
> instead, so a vCPU can hit TLB and I-cache entries that another vCPU of
> the same VM left on that CPU.
> 
> Track at EL2 the last vCPU of each VM loaded on each CPU, and flush
> when it changes. EL2 can't allocate per-CPU memory for each VM, as the
> host does, so use one per-CPU array indexed by the VM's table entry.
> Reset the entry's slot on every CPU when a VM reserves it, so that a new
> VM starts with no last vCPU, whether the entry is unused or was left by
> a VM that was torn down.
> 
> Fixes: fce886a602073 ("KVM: arm64: Plumb the pKVM MMU in KVM")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
> Changes since v1 [1]:
>   - Dropped patch 1, which added a CPU number at EL2. The last vCPU is
>     now tracked in a per-CPU array indexed by VM table entry. (Marc)
>   - Moved the check from __pkvm_vcpu_load() to pkvm_load_hyp_vcpu().
>   - The array is unsigned int, initialised to UINT_MAX. (Vincent)
>   - Dropped Joey's Reviewed-by, since the patch changed.
> 
> Based on kvmarm/next (dd0bc00e3e920).
> 
> [1] https://lore.kernel.org/all/20261014125510.2928306-1-fuad.tabba@linux.dev/
> 
>  arch/arm64/kvm/hyp/nvhe/pkvm.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index ac020d0501d2e..1fc59229c8e86 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -38,6 +38,9 @@ unsigned int kvm_host_sve_max_vl;
>   */
>  static DEFINE_PER_CPU(struct pkvm_hyp_vcpu *, loaded_hyp_vcpu);
>  
> +/* Per VM table entry, the vcpu_idx of the last vCPU of that VM loaded on this CPU. */
> +static DEFINE_PER_CPU(unsigned int, last_vcpu_ran[KVM_MAX_PVMS]);
> +
>  static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
> @@ -261,6 +264,7 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
>  {
>  	struct pkvm_hyp_vcpu *hyp_vcpu = NULL;
>  	struct pkvm_hyp_vm *hyp_vm;
> +	unsigned int *last_ran;
>  
>  	/* Cannot load a new vcpu without putting the old one first. */
>  	if (__this_cpu_read(loaded_hyp_vcpu))
> @@ -290,8 +294,18 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
>  unlock:
>  	hyp_spin_unlock(&vm_table_lock);
>  
> -	if (hyp_vcpu)
> -		__this_cpu_write(loaded_hyp_vcpu, hyp_vcpu);
> +	if (!hyp_vcpu)
> +		return NULL;
> +
> +	__this_cpu_write(loaded_hyp_vcpu, hyp_vcpu);
> +
> +	/* TLBs and I-cache are private to each vCPU, see vcpu_prepare_mmu(). */
> +	last_ran = this_cpu_ptr(&last_vcpu_ran[vm_handle_to_idx(handle)]);
> +	if (*last_ran != vcpu_idx) {
> +		__kvm_flush_cpu_context(hyp_vcpu->vcpu.arch.hw_mmu);
> +		*last_ran = vcpu_idx;
> +	}
> +
>  	return hyp_vcpu;
>  }
>  
> @@ -652,6 +666,7 @@ static int find_free_vm_table_entry(void)
>   */
>  static int allocate_vm_table_entry(void)
>  {
> +	unsigned int cpu;
>  	int idx;
>  
>  	hyp_assert_lock_held(&vm_table_lock);
> @@ -670,6 +685,9 @@ static int allocate_vm_table_entry(void)
>  
>  	vm_table[idx] = RESERVED_ENTRY;
>  
> +	for (cpu = 0; cpu < hyp_nr_cpus; cpu++)
> +		per_cpu(last_vcpu_ran[idx], cpu) = UINT_MAX;
> +
>  	return idx;
>  }
>  
> 
> base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
> -- 
> 2.47.3
> 

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

-- 
Vincent
