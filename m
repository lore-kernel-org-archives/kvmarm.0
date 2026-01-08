Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5355D2AD0C;
	Thu,  8 Jan 2026 15:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767887239; cv=none; b=jgdRohV7z0Jx+TLiE8Q3GtUomtWzwVC0aYtVrhcaQYpx0lNs1wF2r52DxLMsKPbnwWSZSNbcBeCTfNdxuFRYoDhXAN6Uak7b12nhvD6BW5njzQKDrMWdhOohTYbJ2h2KOV1skgbdx3vW6iytONlh30FXlsuHlodb1oiHwjvtc3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767887239; c=relaxed/simple;
	bh=7caujGyve2zR5xMPQjCuO+DCSyoqQe6HI+AnfqPwGVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXj0dRLG5YdSumAb/LvHWb3U+nSIy6iPq8sI77OOUGJGPgyQYvre77yiRpyA5iZXyU8o3QfZEmCrVeVxWHrl+2ZrH3BCMRF/qVMn3b77yJx5rL52csvO5lZp/qlQy7T85DIj5FkdvODpYgMzEWJ+1hKIJpMbtDLk6s+UnUp6d9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdfJwL+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdfJwL+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6B5C16AAE;
	Thu,  8 Jan 2026 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767887239;
	bh=7caujGyve2zR5xMPQjCuO+DCSyoqQe6HI+AnfqPwGVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdfJwL+TNvvs65hgRiW/n5xACT4Jb+FqaJ4sgDVjEqDd335UTt5deqZmXM0L3Z/Mi
	 5bD3Q7jJwKiPZKvqGUhmuk+do30eJ5ADMNbHSrwgigIz/+Ngzv2cn/0ceLeF0VwkfI
	 WAJs3I4QVEuWNZhzaI32ioKy18YgW0uUo8m3vHYl02iBJxtx5vJG9MyE7Llc1gYbIp
	 vZ72vcniEkgz+iLVVgheRlNs55bjvw4ubsabsBgbztzNioNDc/Kzd4XAHGRvXJVwsJ
	 eX80EwgUIOCggdXZdL+jNsj/R9n2AQtuiVCL947B7hxAAN4wkaclK0PgRfK52I0Gp/
	 4CcVcfNRmI9vw==
Date: Thu, 8 Jan 2026 15:47:13 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Kornel =?utf-8?Q?Dul=C4=99ba?= <korneld@google.com>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bartlomiej Grzesik <bgrzesik@google.com>,
	Tomasz Nowicki <tnowicki@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix error checking for FFA_VERSION
Message-ID: <aV_RgSUCERAqZCgY@willie-the-truck>
References: <20251114-pkvm_init_noffa-v1-1-87a82e87c345@google.com>
 <86y0nyqoy9.wl-maz@kernel.org>
 <CACF_fqmWwtuF_7+OJ2rUPvDJzs4ubJO6XCf6N9cW2-AABSx_NQ@mail.gmail.com>
 <86ms4br2dz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86ms4br2dz.wl-maz@kernel.org>

On Mon, Nov 24, 2025 at 01:22:48PM +0000, Marc Zyngier wrote:
> On Mon, 24 Nov 2025 11:49:08 +0000,
> Kornel Dulęba <korneld@google.com> wrote:
> > 
> > On Sat, Nov 22, 2025 at 12:36 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Fri, 14 Nov 2025 11:11:53 +0000,
> > > "=?utf-8?q?Kornel_Dul=C4=99ba?=" <korneld@google.com> wrote:
> > > >
> > > > According to section 13.2 of the DEN0077 FF-A specification, when
> > > > firmware does not support the requested version, it should reply with
> > > > FFA_RET_NOT_SUPPORTED(-1). Table 13.6 specifies the type of the error
> > > > code as int32.
> > > > Currently, the error checking logic compares the unsigned long return
> > > > value it got from the SMC layer, against a "-1" literal. This fails due
> > > > to a type mismatch: the literal is extended to 64 bits, whereas the
> > > > register contains only 32 bits of ones(0x00000000ffffffff).
> > > > Consequently, hyp_ffa_init misinterprets the "-1" return value as an
> > > > invalid FF-A version. This prevents pKVM initialization on devices where
> > > > FF-A is not supported in firmware.
> > >
> > > Is this statement accurate? I regularly boot KVM in protected mode in
> > > environments that really cannot be suspected of implementing FF-A
> > > (there is no EL3 to start with). And yet I don't see any failure of
> > > the sort.
> > >
> > > Please clarify the circumstances this is triggered.
> > 
> > I do have EL3 enabled, but the FF-A itself is not implemented.
> > 
> > Without this change kvm initialization fails with the following:
> > 
> > [    0.946776][    T1] kvm [1]: nv: 554 coarse grained trap handlers
> > [    0.952880][    T1] kvm [1]: nv: 669 fine grained trap handlers
> > [    0.958813][    T1] kvm [1]: IPA Size Limit: 44 bits
> > (...)
> > [    1.034089][    T1] kvm [1]: Failed to init hyp memory protection
> > [    1.041213][    T1] kvm [1]: error initializing Hyp mode: -95
> 
> [    0.045492] kvm [1]: nv: 568 coarse grained trap handlers
> [    0.045860] kvm [1]: nv: 664 fine grained trap handlers
> [    0.046194] kvm [1]: IPA Size Limit: 42 bits
> [    0.220184] kvm [1]: GICv3: no GICV resource entry
> [    0.220525] kvm [1]: disabling GICv2 emulation
> [    0.220852] kvm [1]: GIC system register CPU interface enabled
> [    0.221264] kvm [1]: vgic interrupt IRQ9
> [    0.221565] kvm [1]: Protected hVHE mode initialized successfully
> 
> Ergo, it works here without FFA (this is in a nested guest that is not
> exposed anything but PSCI in the FW emulation).

I looked briefly at this today and I think the !FFA path for nested
probably ends up in kvm_smccc_call_handler(), which will get
KVM_SMCCC_FILTER_DENY for the FFA_VERSION call and end up returning
SMCCC_RET_NOT_SUPPORTED as a u64, so 0xffffffffffffffff and effectively
hiding the bug in the proxy code.

So that might explain the different behaviours we're seeing.

On the plus side, the fix should continue to work in that case because
we'll just ignore the upper 32 bits.

Will
