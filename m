Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793905204;
	b=Ttq6dY1cEWYNedA5ZaNexkJ6cJvWKQ5KrRKCwSn0z6PptMMnrWUEbgBg2Su4bDIwCIpe
	 f2+KdABu8PUxGREtT8Lppr1LlJz2JXTBFC6RvPwY7W00i4cRcWnxIjyk01z9HuDUGI8yM
	 ExT5Le6majQcR/UKjJkoWStwNl+GOVk4YbV4dh7kPTlKO7HghjGDqnDPvTo7YDFV60pkg
	 WoMdH1PyLOO1f8oEelvn09ACoxJ8Wl3N1zI7HXyt37Bv2CFsjzQoX6ti8MyDKRnC4tM8O
	 IFLlp93B4tuFZMa4Ya6AXIO4JcFn8seBcG9PiKNNP+FahVxaL6wx0ZS/SkiaPf6nNVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793905204;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=j+I6b8Lw3jEZszd3OEeMvDJs6j/SiiNSbTh5u70J3nY=;
	b=wb0nVfK71bZ/pVDXitWrExFNIuVPljfu4ChSlE3M5W+izKEmhV5p0nA098ETXILuh2WW
	 xqsjheLYm/oUd45XZhIlT1pg+J3Tzow/3Xsi/4DRbce5pMq/9hdc6UUDTani+/0QzPUhe
	 EmzLURCn47P+vutakFZwq901Nk0Ook8fQquus1DifUHZoIJpL4BkYbqjJk2J+pRsG7e+Z
	 u4cuDXJfGi6+iqHhl9/ESOg70aNpH+XII5XBuaUosMbcy60Erro8gKRR56Gp3uLMrvRnA
	 /wTpwoHdJt7IA08psBJzFY04TKAODbDnlv4sRT3gUjfZNesO+ndGGP3xzscx7EL3NTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nxCRwjkv;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213836083618
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 19:00:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 213836083618
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nxCRwjkv
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A550168F;
	Thu,  5 Nov 2026 10:59:59 -0800 (PST)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90AD83F632;
	Thu,  5 Nov 2026 11:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793905202; bh=JjjUn7pagxMjzSjZizKzJ1kdJvVKVB8LhvENS0UPqF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nxCRwjkvMKt7vu7ToFKtKqBljmnoS1rxTk1fIl31Xsk8fvm1QIy4jGuHFjT3q/EoC
	 QrLKZso0mep7/QH33QH2dDhVzdI1DGZmv4CTCt68forDpaeraXnhuFr6LmdUM+CdKj
	 mrSdCICWb7cdM4qoRhmcyKmomUCNET3sE2HYdOek=
Date: Thu, 5 Nov 2026 18:59:55 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Stop stage-2 teardown scaling with
 the IPA size
Message-ID: <56rrmewwluy2iw52zmusrys3qfqcdhtsgzpqtskr6zt4xhmhfo@hzlwy5ol47kd>
References: <20261104124451.2148724-1-fuad.tabba@linux.dev>
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
In-Reply-To: <20261104124451.2148724-1-fuad.tabba@linux.dev>

On Wed, Nov 04, 2026 at 12:44:49PM +0000, Fuad Tabba wrote:
> Hi folks,
> 
> Changes since v1 [1]:
>   - Run all teardown from stage2_destroy_range() (Oliver, Suzuki)
>   - Dropped the Fixes tags (Marc)
>   - Dropped the patch moving the teardown into kvm_vm_s2_ops
>   - Use gfn_to_gpa() for a mapping's address. (Vincent)
> 
> Two patches that make stage-2 teardown take time proportional to what
> is mapped, rather than to the size of the IPA space as it has since
> 4ddfab5436b6.
> 
> Under QEMU TCG ('-cpu max', 16K pages with LPA2), destroying even an
> empty VM takes about 7 seconds in pKVM. Without pKVM it takes about 19
> seconds if the VM requests a 52-bit IPA (crosvm requests the host's
> limit). With the series, both take well under a second. I tested only
> under QEMU, since I don't have hardware with LPA2.
> 
> The first has the page-table walk return where it stopped, so that the
> teardown steps over an invalid entry larger than a block-sized chunk in
> one go. The second has pKVM return where its next mapping starts.
> 
> pKVM gives every VM the host's IPA limit. My series honoring
> KVM_VM_TYPE_ARM_IPA_SIZE in pKVM [2] doesn't change that for crosvm,
> which requests the limit.
> 
> Based on Linux 7.4-rc1 (6628e7d4c6b25).
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20261103084742.1302597-1-fuad.tabba@linux.dev/
> [2] https://lore.kernel.org/all/20260917091826.2639205-1-fuad.tabba@linux.dev/
> 

I haven't looked very closely, but do functions that use
stage2_apply_range() suffer a similar problem?

If I'm not mistaken we previously realized unmapping a full IPA with
kvm_vm_stage2_unmap_range() is slow partly for the same reason.

I'm not sure whether optimizing stage2_destroy_range() and
stage2_apply_range() together in a single series is preferrable though.

Thanks,
Wei-Lin Chang

> Fuad Tabba (2):
>   KVM: arm64: Resume stage-2 teardown where the walk stopped
>   KVM: arm64: Resume a pKVM stage-2 teardown at the next mapping
> 
>  arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++--
>  arch/arm64/include/asm/kvm_pkvm.h    |  4 ++--
>  arch/arm64/kvm/hyp/pgtable.c         | 15 ++++++++++++---
>  arch/arm64/kvm/mmu.c                 |  4 ++--
>  arch/arm64/kvm/pkvm.c                | 12 +++++++++---
>  5 files changed, 31 insertions(+), 12 deletions(-)
> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> -- 
> 2.47.3
> 
