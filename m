Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E72536D9FE;
	Fri,  2 Oct 2026 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790967479; cv=none; b=HDmy4IImk0M5aiU4ge+5WXb5XcJwzN/iKEIyNxb9D1oXjNFMJtALTbROBwHFthx7L79RlE76svKnip9WJlnSXZ2ofBqpAXKz8TFQ9FC8r75ntD3TqlkhRbxoZoR+JmuRXTtVie4otc7QiZ8UEWcqF27h4WO03dbathbhAjz0luA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790967479; c=relaxed/simple;
	bh=On/bTv98PknQPyRTNxo32jmNRXmxsiXN5JBsXtUEmYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fvmj+lYpVFEq9gJXMwIVzcN2f95xK5aDf2xjXlQdA1GQ0NZsNnJpw4K1DMTk2N4GCKtfm/GLPO4KFn/djuWF50+oCvKinuBhDrngucrd799mEJtoO6kFuLEtbU+uRwoV3P+7de74LLpPx4QyvD/PfndRQ87ke3ndB7OTxAFslIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=khZZZ961; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="khZZZ961"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E9192F;
	Fri,  2 Oct 2026 11:57:53 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AF3B3F86F;
	Fri,  2 Oct 2026 11:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790967476; bh=On/bTv98PknQPyRTNxo32jmNRXmxsiXN5JBsXtUEmYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khZZZ961FD0uI1yPU2c+u4AoDHIw2wOf7yU8YDwCXFB4EDN83IFyYsKHTJ4SpWLBh
	 3tjm/U3+lwX0US8T5shdJxg13YnfoaxibaPIu1mldpLDaAH84ibgtPyG6RBiUKoMSV
	 AOuyxggxZpwWQk18ndXmp00GXmVEzRs6KA8st754=
From: Catalin Marinas <catalin.marinas@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>,
	maz@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	jonathan.cameron@oss.qualcomm.com,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	rafael@kernel.org
Subject: Re: [PATCH v22 00/10] firmware: arm_rmm: Add RMM v2.0 base RMI support
Date: Fri,  2 Oct 2026 19:49:04 +0100
Message-ID: <179096683487.2356212.5555509708136944708.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261002061507.1600269-1-suzuki.poulose@arm.com>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 02 Oct 2026 07:14:56 +0100, Suzuki K Poulose wrote:
> This series adds the generic firmware layer for talking to the Realm
> Management Monitor (RMM), as specified by the RMM v2.0-bet3
> specification[1]. It is the first part of the Arm CCA host support that
> was previously posted as part of the larger KVM series.
> 
> The split allows this RMM support to be used as a base for other work,
> including Aneesh's PCI IDE support with Arm CCA RMM as the TSM,
>  without depending on the KVM Realm support that will follow as separate
>  series. (See more on that below)
> 
> [...]

Applied to arm64 (for-next/fw-rmi), thanks!

Rafael, I took the liberty of merging patch 7 below adding an arch
hibernation hook needed for arm64 (I changed the subject as well to
PM: ...).

For now the RMI is default off. We should only make it default y when we
have a deferred activation gated by kvm rmm option (or PCIe?).

There are a few typo fixes, some reordering of the Kconfig and Makefile
entries to preserve a somewhat alphabetical order. No functional change
though.

[01/10] firmware: arm_rmm: Add SMC definitions for calling the RMM
        https://git.kernel.org/arm64/c/9e201043cbd2
[02/10] firmware: arm_rmm: Check for RMI support at init
        https://git.kernel.org/arm64/c/24657f2ce536
[03/10] firmware: arm_rmm: Configure the RMM with the host's page size
        https://git.kernel.org/arm64/c/a0382431a0fe
[04/10] firmware: arm_rmm: Add support for SRO
        https://git.kernel.org/arm64/c/bc1360cabe27
[05/10] firmware: arm_rmm: Activate the RMM
        https://git.kernel.org/arm64/c/fa193c502990
[06/10] firmware: arm_rmm: Ensure the RMM has GPT entries for memory
        https://git.kernel.org/arm64/c/c20b65a03eff
[07/10] kernel: hibernate: Add an arch hook for preventing hiberation
        https://git.kernel.org/arm64/c/5487bff69b85
[08/10] arm64: Block hibernate and kexec while RMM is active
        https://git.kernel.org/arm64/c/fe4a24613bc2
[09/10] firmware: arm_rmm: Add wrappers for Realm related RMI commands
        https://git.kernel.org/arm64/c/c4a16839abb1
[10/10] firmware: arm_rmm: hotplug: Skip memory added to ZONE_MOVABLE
        https://git.kernel.org/arm64/c/06898e5320b5
