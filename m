Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F31738C2AA
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 08:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784278490; cv=none; b=QS3NPw+HSABIG86fWDCbbzEYikthNMOorakkzhcuq9xhlAQIImGTD40QR+h+I+ZJaoU0+oal0qL5DrGsiomAx44MO4cG2RJKtzFExr278UV07weVrcqCJdeYOYTPH9M4yGG0C5UIaR57pxXiogQLqYzf3kPaOUaNIrFXDb7sN5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784278490; c=relaxed/simple;
	bh=q0EYosB5cWsgSbQ/y3/jV1Jw3T/dPke8VNVgZoZkvtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eq/Og0avI0tWylUKGiKqrE07S3Rhc86zL5JcqusQ46AKm48lHNi3g+CzwF0gcWyn3M90nyEA8uGIdchGoyY/bMX6u0W4LzeUs+3Y46efzY/n806KoWzWcI9QajaX8fjTh3vYwRniyOslYwDsBLB1kC4qUSakOuzlufiPqbgFp9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=r3mMXAaF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="r3mMXAaF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81AF41476;
	Fri, 17 Jul 2026 01:54:43 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 63FE83F7D8;
	Fri, 17 Jul 2026 01:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784278487; bh=q0EYosB5cWsgSbQ/y3/jV1Jw3T/dPke8VNVgZoZkvtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r3mMXAaFQ2xh30JvXGGxvpURuC7rqJUEnR4XOnmoK8wLoj1T40makkKjvcSaQqD5P
	 pJcDyFi6dZBC1ho3lrjQv0v3jrE1OX88GPpiH/Iu17pR5gLW+3ZMOz+3QdvqXnsYhZ
	 wFiBKf8IV2FjjYChOqlezvkzijGzVNYo4OFbAnr0=
Date: Fri, 17 Jul 2026 09:54:43 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH kvmtool v3 0/4] Add guest_memfd support for arm64
Message-ID: <alnt02jMIecD76kt@raptor>
References: <20260712142536.1391557-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712142536.1391557-1-fuad.tabba@linux.dev>

Hi,

On Sun, Jul 12, 2026 at 03:25:32PM +0100, Fuad Tabba wrote:
> Hi folks,
> 
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
> Due to popular demand, i.e., Alexandru asking me about it, I repolished my
> guest_memfd support series. The one I sent years ago was stale and
> over-engineered, so this is a fresh start instead.
> 
> This series adds support for backing guest RAM with guest_memfd on
> arm64, for non-protected VMs under both regular KVM and pKVM.
> 
> The first two patches are standalone fixes in the code this series
> builds on: an uninitialized return value in kvm__for_each_mem_bank(),
> and doubled newlines in die() messages. Patch 3 adds guest_memfd
> plumbing to kvm__register_mem(), using kvm_userspace_memory_region2
> only for guest_memfd-backed slots.
> 
> A new --guest-memfd option creates guest RAM from a guest_memfd with
> mmap support (GUEST_MEMFD_FLAG_MMAP and GUEST_MEMFD_FLAG_INIT_SHARED,
> Linux 6.18+), maps it to provide the userspace mapping, and registers
> it with KVM_SET_USER_MEMORY_REGION2.
> 
> Protected VMs need in-place shared/private conversion of guest_memfd,
> which is still in progress in the kernel [3], so --protected rejects
> the option.
> 
> Based on kvmtool master (ca0ddafa941d).

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Tested it on an Orion O6 board, by booting a VM with guest_memfd. And also
used it as a base for testing the MTE + guest_memfd patch [1]:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

[1] https://lore.kernel.org/kvmarm/20260714110756.116950-1-alexandru.elisei@arm.com/

Thanks,
Alex

> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20260708182239.1489297-1-fuad.tabba@linux.dev/
> [2] https://lore.kernel.org/all/20260706083555.302972-1-fuad.tabba@linux.dev/
> [3] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com/
> 
> Fuad Tabba (4):
>   Initialize the return value in kvm__for_each_mem_bank()
>   Remove newline from end of die() aborts
>   Add support for registering guest_memfd-backed memory regions
>   arm64: Add --guest-memfd option to back guest RAM with guest_memfd
> 
>  arm64/include/kvm/kvm-config-arch.h |  5 ++-
>  arm64/kvm.c                         | 44 +++++++++++++++++++++++----
>  hw/cfi_flash.c                      |  2 +-
>  include/kvm/kvm.h                   | 17 +++++++++--
>  include/kvm/util.h                  |  1 +
>  kvm.c                               | 42 ++++++++++++++++++--------
>  util/util.c                         | 47 ++++++++++++++++++++++++++---
>  7 files changed, 131 insertions(+), 27 deletions(-)
> 
> -- 
> 2.39.5
> 
> 
