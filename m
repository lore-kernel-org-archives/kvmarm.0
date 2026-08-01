Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87B137DAD5;
	Sat,  1 Aug 2026 11:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785583725; cv=none; b=Pw49e5v1WgaEmgYvOtohJEzXWXU6T0ZpqsEz92Rqpx9zdr7PwJ1VDXD94hA7OQY/YekiwIS8+fhLdvY79b7RdVlgm6hn5cazKyETuljXNVhER/TiuPWBmfdde06+T6GUIicd3fsrCuvpsKwEGNNEZ/hIs0ke0uuRzITlSgqPObA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785583725; c=relaxed/simple;
	bh=nCdGLEdZlkBbgtsn9xsKiRtio3TC7qHKN7g9BY3O4BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C0D8lArzYoMvzxRfXz7ISkz9GSZQICLiE/2msdxPO4vU0lw+2MwPqO6xBJ4FPLaAc3AJJw6QzMJ793jRt/L0//f2L1Duk106LqMk9RBgDngN+QFmeM+h4F9IV7yGYAMjGN7m3/+qSJ1FgaimiedvKOfqMufI5rXKEkvDR1UxJ70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCQxbqkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCQxbqkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F0A1F00ACF;
	Sat,  1 Aug 2026 11:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785583724;
	bh=FNiPy1mHNo26ffGS4gdXNh3aAvvP5u1SwLHqtcqiK0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCQxbqkH8QkFF4TPi94kyRMSWlKEQ7COTdUrl88aV1Pl+W1k2OxawPzl0yzG8oa8v
	 i6uX00cdECQ9gDbUmfrVyOGlqx+Xw6o9tY6WgSMYMrMQZG/sePfcTskzeiYqbui+84
	 b83HBcTXWzk+ZM2RWQc5GPgWlfD+jAxEU9BMVEITPklxWQpt+bQLRxZ+i+OLHQYe3U
	 dwWOlO7MHNLT2S8J2c3kgou6PjYgRCwapsPB185hzqzXe/Vy6z4tS1XekqMxtmZfiI
	 6ntfghfg+wfpSlYYvYxCVQpzauT1Q3gISj4Nq0MrTVSNMdl8j/8bSgut5J4xjkDgah
	 PmPg//nEIfxdw==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH kvmtool v3 0/4] Add guest_memfd support for arm64
Date: Sat,  1 Aug 2026 12:28:28 +0100
Message-ID: <178551731037.365411.15650012187546845687.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260712142536.1391557-1-fuad.tabba@linux.dev>
References: <20260712142536.1391557-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 12 Jul 2026 15:25:32 +0100, Fuad Tabba wrote:
> Changes since v2 [1]:
> - Assert guest_memfd >= 0 in kvm__register_ram_guest_memfd() (Alexandru)
> - Don't split line after = sign (Alexandru)
> - Disable MTE when --guest-memfd is used (Alexandru)
> - Carried Reviewed-bys
> 
> Changes since v1 [2]:
> - Use kvm_userspace_memory_region2 only for guest_memfd slots (Suzuki)
> - Check KVM_CAP_GUEST_MEMFD before KVM_CAP_GUEST_MEMFD_FLAGS (Alexandru)
> - Close guest_memfd fd after unmapping at teardown (Alexandru)
> - Carried Reviewed-bys
> 
> [...]

Applied to kvmtool (master), thanks!

[1/4] Initialize the return value in kvm__for_each_mem_bank()
      https://git.kernel.org/will/kvmtool/c/8e77acfac060
[2/4] Remove newline from end of die() aborts
      https://git.kernel.org/will/kvmtool/c/a6d971e56ee2
[3/4] Add support for registering guest_memfd-backed memory regions
      https://git.kernel.org/will/kvmtool/c/3f5bf00c2449
[4/4] arm64: Add --guest-memfd option to back guest RAM with guest_memfd
      https://git.kernel.org/will/kvmtool/c/0717297de3d5

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
