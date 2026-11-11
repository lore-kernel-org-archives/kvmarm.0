Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794430785;
	b=zDHloLZ0F23WgMVK+Ed26QzLzalrv/FGAkE8f2pAHoKTsHlA03DL3MHb0sOJYDnwesTq
	 TJqiPrMtge3pxHvoa1BR7/HW3Cjrs/mONSiNaU2fh5ppjIC6OjFSNxVlAcCZK3YqvDWyi
	 sbC+D97ZuhBffB9Ffs7zB/iUVI4t0hxnw5Qla0QhyGbAjYSyj3v1b63rgkCKtQvptbr+c
	 EtLA9pqlTZd4OyKvQYHTS9Mnp8SpacklI8p1THmDYgvDK0aVEuSXPzBRC+ZZ7bndnw+4F
	 g3oqV7rKaa5oEoS2GDLy244VijghQYdvGeSJKPvmWwH3WVuytuTB3dqKe7viMMO3MAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794430785;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=rJtMZ+oQ2ftbIpYEVBAu9rDREp/nXzUYJLHQXQsg0HU=;
	b=rhvMAnuYRkenbHP72ARXtbPI6SaqPAxfkAe0T5xbvM3JWgG4q33AqatHrYov2s1GbqAp
	 wcg8fTSVvnGTvpoGH8WW6M/8XOK0TiDpGlQAZAUdz1ISU2VQnVkqbJVcmJquTJcoBhILt
	 BsEkDQbdr82PGeQ1i23ds7W8aWcR51dGME+QP7bbtksu60grSAG08DU+xZ7G35dDkxSrQ
	 psV1wi7fYHA/SnMAncxk0jVontq67rEYwCaqk1sIsS7lRBEyiH+e9mxG5ECWE1r3Sc5DE
	 w4kADunVNxswYHgRhA0D3boDOh5kOxopo8B3iVrQKb1usQjuEVjZboaVDQr+hLm3HAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EcNEcgLx;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E73606A32E
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 20:59:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88E73606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EcNEcgLx
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68503153B;
	Wed, 11 Nov 2026 12:59:39 -0800 (PST)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E9FE3F85F;
	Wed, 11 Nov 2026 12:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794430782; bh=GvTWPjgOeMhK10lBp/x80dBPCkX7FkHbNjd4m6Rj3Io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EcNEcgLxh8R4qgoGx5zt/BAiEPlEPgPQ5bJyg31SxFdqKQtTwJ6iyFz9dR8Pa45eo
	 5bjD6JCeoE+Z6XkT6uG1bDWU/8OkCGqilXZCHG+WVhKDKQL1oYbZ4gyatCCuN2U6IT
	 0gN8y26J/JidPb860oE6jToCtYBB/N74sVWdrtgU=
Date: Wed, 11 Nov 2026 20:59:27 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Haseeb Ashraf <haseebashraf091@gmail.com>, maz@kernel.org, 
	Oliver Upton <oupton@kernel.org>
Cc: Haseeb Ashraf <haseeb.ashraf@siemens.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, fahad.arslan@siemens.com, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Resume stage-2 unmap where the walk
 stopped
Message-ID: <lnqoq6pirbxwdl3ki3khiju6kkh3itw2meh67emmd6ck4lu6sl@ai5ctyvuhpuy>
References: <20261110164706.582879-1-haseebashraf091@gmail.com>
 <20261110164706.582879-2-haseebashraf091@gmail.com>
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
In-Reply-To: <20261110164706.582879-2-haseebashraf091@gmail.com>

Hi,

On Tue, Nov 10, 2026 at 09:47:06PM +0500, Haseeb Ashraf wrote:
> From: Haseeb Ashraf <haseeb.ashraf@siemens.com>
> 
> kvm_vm_stage2_unmap_range() unmaps a range one block-sized chunk at a
> time. The walker steps over an invalid entry in one go, but the next
> walk starts at the following chunk, so an invalid entry larger than a
> chunk is visited once for every chunk it covers. Unmapping the whole
> IPA space of a shadow stage-2, as emulating TLBI VMALLS12E1IS and TLBI
> ALLE1IS does, takes 2^18 walks with 4K pages and a 48-bit IPA space,
> however little it maps. Each walk also ends with a range TLBI when
> FEAT_TLBIRANGE and FWB are available.
> 
> On an AmpereOne A192-32X (192 CPUs, Xen on KVM, 4K pages, 48-bit IPA),
> a full-range unmap of one shadow stage-2 took 0.82-0.94 s (mean 0.91 s
> over 192 unmaps) on 6.18.29. With this change and the mainline commits
> it builds on backported, it took 2.1-27.8 ms (mean 3.8 ms over 128
> unmaps), with 512 to 1024 walks instead of 262144. A TLBI VMALLS12E1IS
> trap that unmapped two shadow stage-2s took up to 1.85 s before.
> 
> Add kvm_pgtable_stage2_unmap_range(), which returns the address its
> walk reached, and have the unmap loop resume from there.
> kvm_pgtable_stage2_unmap() still returns 0 or an error, for its
> callers at EL2. The walk handles every entry it steps over, including
> invalid entries that carry state, so nothing has to be looked up
> beforehand.
> 
> The unmap of a shadow stage-2 also drops the guest stage-2 records of
> the whole span the walk covered: nothing is mapped in the part it
> stepped over, so any record there is stale. Each walk that remains
> ends with the same deferred TLB invalidation as before. The spans that
> were skipped have no valid entry, so there is nothing to invalidate.
> 
> Suggested-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Haseeb Ashraf <haseeb.ashraf@siemens.com>
> ---

[...]

> +/*
> + * Unmap [start, end) one chunk at a time, resuming from the address that each
> + * walk reached. An invalid entry that is larger than a chunk is then stepped
> + * over once, rather than once for every chunk that it covers.
> + */
> +static int stage2_apply_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
> +				    phys_addr_t end,
> +				    s64 (*fn)(struct kvm_pgtable *, u64, u64),
> +				    bool resched)
> +{
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> +	bool lock_dropped = false;
> +	phys_addr_t addr = start;
> +	u64 next;
> +	s64 ret;
> +
> +	do {
> +		struct kvm_pgtable *pgt = mmu->pgt;
> +
> +		/*
> +		 * We may be raced on PGT teardown when we release the
> +		 * kvm->mmu_lock. That's fine as the PGT is legitimately no
> +		 * longer present.
> +		 */
> +		if (!pgt)
> +			return lock_dropped ? 0 : -EINVAL;
> +
> +		next = stage2_range_addr_end(addr, end);
> +		ret = fn(pgt, addr, next - addr);
> +		if (ret < 0)
> +			return ret;
> +
> +		next = min_t(u64, ret, end);
> +		if (resched && next != end) {
> +			cond_resched_rwlock_write(&kvm->mmu_lock);
> +			lock_dropped = true;
> +		}
> +	} while (addr = next, addr != end);
> +
> +	return 0;
> +}

In my opinion it is worth giving the same treatment to all users of
stage2_apply_range(), instead of having this new
stage2_apply_unmap_range() that is almost identical.

Thanks,
Wei-Lin Chang

> +
>  static void kvm_vm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
>  				      phys_addr_t start,
>  				      u64 size, bool may_block)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> -	int (*fn)(struct kvm_pgtable *, u64, u64);
> +	s64 (*fn)(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  
>  	if (kvm_is_nested_s2_mmu(kvm, mmu))
>  		fn = kvm_pgtable_stage2_unmap_tracked;
>  	else
> -		fn = kvm_pgtable_stage2_unmap;
> +		fn = kvm_pgtable_stage2_unmap_range;
>  
> -	WARN_ON(stage2_apply_range(mmu, start, start + size, fn, may_block));
> +	WARN_ON(stage2_apply_unmap_range(mmu, start, start + size, fn, may_block));
>  }
>  

[...]
