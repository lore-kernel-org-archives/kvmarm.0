Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717563;
	b=1z2inSjxFQz50S/1Zr57KyMEf4KjdlHA0JVyYxOlG/fyMZwHSIv0Fk1YYDmvJF6P/aY9
	 d1aeJ5EU41lrB01UbX3hJvsSNTlkTyB9XvIkpmLGGDS6Wm03lPx7qA3uQp2HjO9+/na0I
	 Jjy/hQ9rLxosx3p6oOIXDS3Ls8LvIUzOUDPu4cllaoqZV2fgg45wh5tWwQ57n7mYzoUox
	 +CwqaVHwNvuj4yUTrCs500PmpwdSAdQ5FQWp8vBVc4qSICqPtvbFdbbOiaUPuNPrji0x5
	 K2bdbqj54rK6iNytqOzF5dZluCPGojy12LXNprC8vHJMh0wIfvxveV3sMWyouOILvrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717563;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=WaOsrEmAYoqVhViGwTJTcykgEVpjZAmCdFfMPnWGgSQ=;
	b=4RYevQOrvKW0Tl7z9LgdYzxp9EumK1OazSlHBC4CJS1Ii40DOUbH+nVSDVvKnor+ycvD
	 +7fowu5YhwkbeO2hesjvlL0DV77PVWOHd8uEbV/8xS82Q4cfegRzW/km2DSw3lP0KI67Z
	 IkMXFhT1xFRh0sQCq+7opiz8i9/jM4kAjX/JmOqx3cXvRTeYC9JSCFl4lEhMuMd98LGuH
	 MxpaWHJxYuY9o4TJGmlyllfOv1a7DbN75LUJa7HsYqllYAyC+nPUpVwyRGjsRfzkx+o+u
	 4+qMaRPOAkipeyyLFR2RPGxFCZwhnwSlA/tKRsCgmw1U/h7URhuE/A3KLzz/CseYrrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JUSpL3Fp;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECFD606BA2A
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 14:52:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ECFD606BA2A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JUSpL3Fp
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48df54150dfso2170745f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 06:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793717561; x=1794322361; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WaOsrEmAYoqVhViGwTJTcykgEVpjZAmCdFfMPnWGgSQ=;
        b=JUSpL3Fpr8p+kU3EFqfTXU4iy4/zjavpOuxvIB6rXj6HHyKo1QK0b+acpLMQWLJL+S
         V4lIWV4m9xnS7CE2dfBtWzOdCzNiiKuGxpBN90EcHb9plK/BlsVPitt3AI8KiwwAbmF9
         4rxcikFjkz0RXTDLXj59E03mP3l7twIVEZNCNtAByGUUMm7SKKV1XWxU8Y1B1xqFzXfl
         NtenRYhQEmmHYoTHFf8+zZGAMm2EhYW7wyezuTC7rPOMl5x+zt+S989/FBzGz2w1CxTw
         UqpluDkqC75govuCC46h8hC6Q4Ot7FiBHvp2+jRqiuykw9ETW7SR2XAf01DgYRtKtlwe
         U+2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793717561; x=1794322361;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WaOsrEmAYoqVhViGwTJTcykgEVpjZAmCdFfMPnWGgSQ=;
        b=TQE4K0MLHOZhzoucbJ3KWTpf3LKSJL3yMpLH6DJbZNzF2lN3JIsM92TwW2gFGYnq6O
         lUTCrOp921cs9kjQHVM7zjrFx3hrCW4JfVpAHULwVeme3nwGPTxgp83CN+H/YG3U/Tjr
         u2xgj6M1sTGZh7zRNUdBGHDrpc8bUyUYm669V8v5XfICGmuOqHDkC0NRfNTriu+YkNJ3
         iAZicGjnfWCNoMDBzIw8MJxCL8NLFCBrE8YzrW/RYRmuzyfDmwK1fMxXmw11O+TGAFII
         7JCnCNqHpocZmORwVxggngBv8PgNfJSh6KanpRdTELxOni9iJRFRPL4dzqQHgotiTgTN
         5Shg==
X-Forwarded-Encrypted: i=1; AKwUvByzZRlC4kyHcq57kScIjt1zuL1rwUFDKunMgMoBc4plBl7szBb0g+aWLYtfDNrvDtvfT+nEnZA=@lists.linux.dev
X-Gm-Message-State: APuU4Z9YrJyOkQ2cKhAcdBREhjvatem/FEdAC2lg76YLtNTEOKEu6UvJ
	HGKiAMDFgzW0JCgYx/gYXrJTY7+WmxAaZDq6R84+7aKMfQRgVvTnDREXMXN/fObveQ==
X-Gm-Gg: AYBFou2/h5+2EpwQdBQWqpdxxi3L14kkTk2buFT2Sh7NwyIK9TsUNAs359nKvb8lakm
	UjMIjFobM5Kh0bi8tDIWGvsMuqY0dbkEqrtz4SeL2bZxq2n2qDyi4SrXDYcd1N7LteGAbpEmsNr
	jEGvXfxr1hyIAJar0v8vPEh3RjyPfLr96Y876wufUqVqrMOOzCKa1spL433KkIMdJKB55tPWHFZ
	FgBqb32kjC5VBkxB3UF8JzFmFqQLuqVE1zraCmUyyG23clntw8x3su4ftpc/2T3GzBtTdD+SBXi
	NTkd4xu3Gv8jXzUM3XgjB++ddSm1y7RbTU9qxWRN4tbMMlRUfbOUBScdX5ZeWYTGr0/D9AJLTCG
	WNV3nC8VoJ6DBYEt6qDO2Y0pB87hPTs1RXoE5SH/Pl8DEbUZpjE+GE1pfCZdA8ZxhzT0EPN0/Wj
	7HJrw4OQLwMt5MCOkkDA8kwfNS9Zpi8ev/8qQKasSJBG6mMgJzcb13KKkWjHWFjBvYIbfpDsZYX
	AzMTokg6uUDbDYZCKyYRJHn/+zUQpjHmmLI2HiLPsd/fz7kIEMBlWa5E+YtmQEkpyu0J1v763Sn
	s2ZPf/grGJ2yjjSwxm+UhU/OJoGDCsYFpw9Osr+jFd3NyOUBMq9qgbyI04zJbeQS
X-Received: by 2002:a05:600c:8b04:b0:4a1:fb01:13 with SMTP id 5b1f17b1804b1-4ac17a3683bmr312931635e9.18.1793717560966;
        Tue, 03 Nov 2026 06:52:40 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a555e59dsm69647405e9.0.2026.11.03.06.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:52:40 -0800 (PST)
Date: Tue, 3 Nov 2026 14:52:36 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't walk the whole IPA space when
 destroying a pKVM stage-2
Message-ID: <aun1NJNtnOeSL4oc@google.com>
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
 <20261103084742.1302597-2-fuad.tabba@linux.dev>
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
In-Reply-To: <20261103084742.1302597-2-fuad.tabba@linux.dev>

On Tue, Nov 03, 2026 at 08:47:40AM +0000, Fuad Tabba wrote:
> Since commit 4ddfab5436b6 ("KVM: arm64: Reschedule as needed when
> destroying the stage-2 page-tables"), kvm_stage2_destroy() steps through
> the IPA space in block-sized chunks, and with pKVM each chunk is a
> lookup in the VM's mapping tree. However, pKVM gives every VM the host's
> IPA limit, so with LPA2 a teardown makes 2^27 lookups with 16K pages
> (2^22 with 4K), nearly all of them for empty space.
> 
> Walk the mapping tree once instead, and reschedule after passing each
> mapping to the reclaim or unshare helper. The unshare helper can't
> reschedule itself, as the map and unmap paths call it under the
> mmu_lock. A failed unshare now leaves only its own mapping behind, not
> the rest of its chunk.

Not a problem now, but don't we make the device assignment story harder?

> 
> Fixes: 4ddfab5436b69 ("KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables")

Isn't it an optimisation?

> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/mmu.c  |  7 ++++++-
>  arch/arm64/kvm/pkvm.c | 17 +++++++++++++----
>  2 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1db10d8d6db73..42977cf8a7f5d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1022,7 +1022,12 @@ static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
>  {
>  	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
>  
> -	stage2_destroy_range(pgt, 0, BIT(ia_bits));
> +	/* pKVM walks its mapping tree, not the IPA space, and reschedules per mapping */
> +	if (is_protected_kvm_enabled())
> +		pkvm_pgtable_stage2_destroy_range(pgt, 0, BIT(ia_bits));
> +	else
> +		stage2_destroy_range(pgt, 0, BIT(ia_bits));
> +
>  	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
>  }
>  
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 016997288fd23..992ed3ca6bdd9 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -504,6 +504,7 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
>  	pkvm_handle_t handle = kvm->arch.pkvm.handle;
> +	struct pkvm_mapping *mapping;
>  
>  	if (!handle)
>  		return;
> @@ -513,10 +514,18 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>  		kvm->arch.pkvm.is_dying = true;
>  	}
>  
> -	if (kvm_vm_is_protected(kvm))
> -		__pkvm_pgtable_stage2_reclaim(pgt, addr, addr + size);
> -	else
> -		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
> +	/* Called once for the whole IPA space, so reschedule between mappings */
> +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> +		u64 start = __pkvm_mapping_start(mapping);
> +		u64 end = __pkvm_mapping_end(mapping) + 1;

__pkvm_mapping_* are rb-tree internals. I think it is better to use explicitly:

  start = gfn_to_gpa(mapping->gfn);
  end = start + (mapping->nr_pages * PAGE_SIZE)

Also, I wonder if we'd better WARN if the mapping isn't aligned with the
destroyed range?

-- 
Vincent

> +
> +		if (kvm_vm_is_protected(kvm))
> +			__pkvm_pgtable_stage2_reclaim(pgt, start, end);
> +		else
> +			__pkvm_pgtable_stage2_unshare(pgt, start, end);
> +
> +		cond_resched();
> +	}
>  }
>  
>  void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
> -- 
> 2.47.3
> 
> 
