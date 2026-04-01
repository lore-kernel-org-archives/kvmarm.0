Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641BD3624CC;
	Wed,  1 Apr 2026 15:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775057705; cv=none; b=DX4J71WL+36V0qZ+hIi3jOz0yA6rcB3xns0+9fz0OoUB0eHSmrOfZHzuejy1l0qOidThAEAK5Zg8CQJMNFngtyGys3S5xTAACrnuy0JL3pED9+dsn0LeYzQURAx776lkVCB0euef0wnuS4teh0EcIX4UV+IFmPLQm0s+JPAop9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775057705; c=relaxed/simple;
	bh=QgTT44z0NxNCrsnzVjVQsYysuC3wHT4k/C7Gkmdg7OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IC3i0UxPDc6k+OBvblv6vV8v7iOCgUq06cCPPZjfNjIPZxauKdkn0GXw2oHcLkKx7UYBLHA6tDifDRYZScQRTAnFA0YRn/7Ihsp/tSLq7NwOKjHab32zQDSlBarcXHrLbazRDfSaRq6I2XcKNyY/xZq+geLNucU83wMywHA1KIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKaR5u3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKaR5u3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B7BC4CEF7;
	Wed,  1 Apr 2026 15:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775057705;
	bh=QgTT44z0NxNCrsnzVjVQsYysuC3wHT4k/C7Gkmdg7OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKaR5u3X7DgnIy5ki+PaykDZ3pqyRkcKAT0154uuKjx/U0gWQadZQvKqzqt7XcXlk
	 EmrsUHIlngNc6fv1MkgkIQHVEbMW3e/BehXcXuaJIeO4e/oD0BY/9Z4J/FTvh5c/Wd
	 tAlIgZHZBHyv3DUaABZITLlbAwlpQ72pe0YTXA8kbwC+9KqD1/HjBbCRM3ZbtO14gF
	 iwCmQoNHXC0r6UnFn9nUF0DYBbiojHNMHrhu4niqKy2ajTY2MOedZW8pY5gLJffHlF
	 6tnoKYJ6119Vm0dUOLLCBkgBhPM4OS9PuBZvenYi77yluFMh5gnS+84B4+CW36lixI
	 A5ysy9GFD9FtQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7xax-00000007vQP-0EBN;
	Wed, 01 Apr 2026 15:35:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v2 00/30] KVM: arm64: Combined user_mem_abort() rework
Date: Wed,  1 Apr 2026 16:34:53 +0100
Message-ID: <177505767869.364380.5690355355277236875.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 27 Mar 2026 11:35:48 +0000, Marc Zyngier wrote:
> Fuad and I have been working on this "put a stick of dynamite in
> user_mem_abort() and watch the resulting firework" project, and it
> looks surprisingly OK so far. Disappointingly so, I'd even say.
> 
> This v2 is has very few changes from the original posting (cleaning up
> the comments in Fuad's series [1], and some minor restructuring in
> mine [2]), but I wanted to post the combined series for people's
> awareness and for the sake of running it through sashiko.
> 
> [...]

Applied to next, thanks!

[01/30] KVM: arm64: Extract VMA size resolution in user_mem_abort()
        commit: 66fcf492008db407e8d600ceaefd2c8a8070c5ae
[02/30] KVM: arm64: Introduce struct kvm_s2_fault to user_mem_abort()
        commit: 0b236c72c02df36992b7d6ff29cbe5abef973250
[03/30] KVM: arm64: Extract PFN resolution in user_mem_abort()
        commit: bae99813c6a9ce474cbb7b6553dc6e379b2f4375
[04/30] KVM: arm64: Isolate mmap_read_lock inside new kvm_s2_fault_get_vma_info() helper
        commit: f5a5bb8de11863bd92f4188b7e823e3fca4d68e6
[05/30] KVM: arm64: Extract stage-2 permission logic in user_mem_abort()
        commit: a6e11bd6e1bd9ea9a42738c5a6ac12881b5fcb36
[06/30] KVM: arm64: Extract page table mapping in user_mem_abort()
        commit: 5557a3f843bcef3de9a1237020348b2859812170
[07/30] KVM: arm64: Simplify nested VMA shift calculation
        commit: 2175ca5384ba9f3d1f45745522cdeb5865488400
[08/30] KVM: arm64: Remove redundant state variables from struct kvm_s2_fault
        commit: 9a57bc1b3c6b1f583f43acf7719d66e6b30ef2a9
[09/30] KVM: arm64: Simplify return logic in user_mem_abort()
        commit: 3825373b91b0fbedc65205a59f95379aaf596aad
[10/30] KVM: arm64: Initialize struct kvm_s2_fault completely at declaration
        commit: 975bad4bb21e4eea7ecc0f32f4cbbb91a9c8d48f
[11/30] KVM: arm64: Optimize early exit checks in kvm_s2_fault_pin_pfn()
        commit: 3456943e8786d56aa2bd3f99e9ad2d735a9879c8
[12/30] KVM: arm64: Hoist MTE validation check out of MMU lock path
        commit: 84699747aa554197f6d5b4f4c9d1bcb6cb28e21f
[13/30] KVM: arm64: Clean up control flow in kvm_s2_fault_map()
        commit: 11f8f1b8a97b63b180f7aa021ec9abdead283025
[14/30] KVM: arm64: Kill fault->ipa
        commit: 5729560e2c3cb67a22a1d72688e0bb8e96798313
[15/30] KVM: arm64: Make fault_ipa immutable
        commit: f583a53c2b8a4bd77f090bb76512eb87bc80f2c4
[16/30] KVM: arm64: Move fault context to const structure
        commit: c6f4d84643498bc855e2f6719a3233ded0e2dc63
[17/30] KVM: arm64: Replace fault_is_perm with a helper
        commit: fe4b6f824f267739ef2c5f2f047c317eceb587c3
[18/30] KVM: arm64: Constrain fault_granule to kvm_s2_fault_map()
        commit: 31571929e8a894d06291a9501b2be22cffe14443
[19/30] KVM: arm64: Kill write_fault from kvm_s2_fault
        commit: 49902d7e010614888253a90252f4704edb2fe3e3
[20/30] KVM: arm64: Kill exec_fault from kvm_s2_fault
        commit: c0d699915a835364b1c8d1eca11e11e7b82f0705
[21/30] KVM: arm64: Kill topup_memcache from kvm_s2_fault
        commit: 1a3cd7cb5547979f96ec2a0920b8e39939c58db3
[22/30] KVM: arm64: Move VMA-related information to kvm_s2_fault_vma_info
        commit: 4ff2ce512063ae79976c23b6fe2130611bcbae62
[23/30] KVM: arm64: Kill logging_active from kvm_s2_fault
        commit: 18e1312879db0af5bfd1b1a8b6771d314ccd3ca9
[24/30] KVM: arm64: Restrict the scope of the 'writable' attribute
        commit: 08abf09f4d763565ee9ed084401b7ac92f8b4952
[25/30] KVM: arm64: Move kvm_s2_fault.{pfn,page} to kvm_s2_vma_info
        commit: f8dad9602ff305b879fa23688becd578102ba547
[26/30] KVM: arm64: Replace force_pte with a max_map_size attribute
        commit: 29a5681843a52570ca9597bf355be33fe8753eb0
[27/30] KVM: arm64: Move device mapping management into kvm_s2_fault_pin_pfn()
        commit: e314a4dbdb8b29b7e9a69afb8831a15a6d15c1ed
[28/30] KVM: arm64: Directly expose mapping prot and kill kvm_s2_fault
        commit: adb70b3a8b31e9eb05f2ec3c76d85f9a7a8c8cbc
[29/30] KVM: arm64: Simplify integration of adjust_nested_*_perms()
        commit: fb9888fdfada0b5ad977f08f7550432a08aacbb1
[30/30] KVM: arm64: Convert gmem_abort() to struct kvm_s2_fault_desc
        commit: e9550374d13a4bfd0b8a711733f5d423c2e56b96

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


