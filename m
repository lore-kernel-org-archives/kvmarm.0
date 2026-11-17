Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794939169;
	b=lgGjudjoYn2Jg7LTfBTg0bWKdeTd+578WMdiELUePQo0AGB/ZWlnGgRNgOAZzCzfKpUW
	 28ZF0s+QeLY+PeWXfe1tlyZ16QHrUnzKlEUVJtaSSCgUj3cRnQ6DBhE3IMaYYU+5M2AS2
	 3udFO7Pf/64v0R6BrWYqblDvit7aDykubQrzt6fNANPrStouEne+t0RxiH4aOGHDqAr1Z
	 0l5fHZXvWCuyz5UIRTlD6ELndMNrKth5GLJc4Ks8pbv1NPNeAtGkw+nc7TtSe6jdfWUvA
	 Of+bk8TxhkuL7bHKXA86E9fspWB4SZuibIvybA5VgJXlD5IT+JKjrB3T3LEfyDBwBwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794939169;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2XP3FgoploZd9nlTihMff6VvVBJh4qnJoF9vqsKxgPk=;
	b=VcEKJFA2aiEKAk0H/TfQq9XfRRmXdECTkON0EO9nvFdPT0eFaoznzMRbZHqUISQJDZv/
	 GLi6W6VeKyf5WHBGGpwYUknw2qXfYKhE//Xiv1y1eMhp73PTF53165hUsODgat/Jrgzt3
	 gWLz6R4Uc3FYAP9ffAov23JzYfAU3z0wgpl0d7+3XZS2Exnx6gSTbZhSAIfFk5H5mDHoD
	 I12H705uoRiOnjY7nH7X8cN/rsZ6W3FtaIivhG6xDWYJ+udgTY9VaZvOvq1sRPoP7f6F1
	 3bva9u6epTUF8JbqTd+LXR50oMN40+b+Mh86dhTVk2hqS2T+VK7emZ0lF1i0j4AMNRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f+I10RnW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38112606A31C;
	Tue, 17 Nov 2026 18:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f+I10RnW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F3F1F000C6;
	Tue, 17 Nov 2026 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794939169;
	bh=2XP3FgoploZd9nlTihMff6VvVBJh4qnJoF9vqsKxgPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f+I10RnWUJYUU5t/Iy8JJX2St9sZma2QKZPcxfhYHOuyhVlltpHCIR04rqQdUCnhC
	 n3hTzpkXH4lB9Fj0d1j8a3cvqcWt0RdrTDShxQpo6GsCXpKPQpCafcEzTpXwnu9RZe
	 Hpa4d8WUQuhfGmGefy+okvaxKhay+WoKROC3uID49wBaofpBaogbW39/HYHXh0boGv
	 PZBwmfo7G4fAUQ8ErJXaPiFl9yf16EaP0lUy8ULfQedThl+SZMASovx0DmFg9kBGPv
	 3HykHzT7+e88h+3zZ4j/7FDI1kq6hiy3lx7FN5jLxq6wGsrvAdgFlBCoA3AR4peJyW
	 m74tcQvOeytKg==
Date: Tue, 17 Nov 2026 10:12:47 -0800
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/16] KVM: arm64: Compute a protected vCPU's
 fine-grained traps at EL2
Message-ID: <avyZH2g3rrIVm-Fl@kernel.org>
References: <20261109083205.806619-1-fuad.tabba@linux.dev>
 <20261109083205.806619-8-fuad.tabba@linux.dev>
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
In-Reply-To: <20261109083205.806619-8-fuad.tabba@linux.dev>

Hi Fuad,

On Mon, Nov 09, 2026 at 08:31:56AM +0000, Fuad Tabba wrote:
> +#ifndef __KVM_NVHE_HYPERVISOR__
>  static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
>  				  int map_size, u64 resx, const char *str)
>  {
> @@ -1414,11 +1420,6 @@ static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
>  			str, mask ^ ~resx);
>  }
>  
> -static u64 reg_feat_map_bits(const struct reg_bits_to_feat_map *map)
> -{
> -	return map->flags & MASKS_POINTER ? (map->masks->mask | map->masks->nmask) : map->bits;
> -}
> -
>  static void __init check_reg_desc(const struct reg_feat_map_desc *r)
>  {
>  	check_feat_map(r->bit_feat_map, r->bit_feat_map_sz,
> @@ -1451,6 +1452,7 @@ void __init check_feature_map(void)
>  	check_reg_desc(&ich_hfgwtr_desc);
>  	check_reg_desc(&ich_hfgitr_desc);
>  }
> +#endif

We already have too much ifdeffery... It isn't mentioned in the
changelog but I take it you're doing this to avoid the printk() in
check_feat_map()?

If yes then just upgrade that thing to a WARN() and carry on, it only
ever runs at init. 

Thanks,
Oliver
