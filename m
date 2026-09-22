Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CB84DDB5C;
	Tue, 22 Sep 2026 09:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071126; cv=none; b=nrg+8YkUiH+6P358TT/VAUwfuR1AKQ7YNep0wgJtdjIS52fCOIvfgXP9EbpxBSsmrv35WKQ7wksxcL4Z1+WcK3/lpY88Km/ZjloKJxq+HzdOv9bc8KM0senB3KdjquLVlx3w5ABnCKxuZYi8MIIwbnvfcSac1fnsECiTsvuZKvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071126; c=relaxed/simple;
	bh=/yyqamP5t8CQh57P/WH0zqIm4kpKRzSqI3+ThY1dMCI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cG52VW+FdICj14HP1TT9Y7KVt+3wYmSeYvkyVwetnHnLKVysbY9hjOVOCcjWAPMyMDxBDn87iBabybRF/qvUIDa+huL/FnQvdurytc5iR+DlIMIIGAdjUvl0h+OTGJb7GhXQVmEUOBJrFvpdJaV4g+w2wrxqepqAAbKepfWqDT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Spa809y2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Spa809y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE5E1F000FF;
	Tue, 22 Sep 2026 09:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790071125;
	bh=aai3CsCP6YioLAW5MeiIsLHvBjwFsN0GGOUwY/D/HGM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Spa809y277oKylDB4yqxACYtY+WeTrUwHt95v/68/LegW4tQecygUu1j87R9Cp5vx
	 mmGPccHLIYeSB+rtabZjd7q9edEql93lGusIRdTX2FSQOUQpO7erZVHvOR9I7/33La
	 hU1Y43i2Uh1Wj+cx3uOewQON5YGra7d4Ry/2qs0PVyfTdOZ07r4yJ8v+q7W22u6KSX
	 DFUt4UP9kqqwkwK7poqxU8RNZ/K8hMGBUaAlc4m5GuMgs+lNi5qpQLCP4P0eiShGzi
	 7sQ6eI5blbL8+fxQMySE4QGl1LZvQHcn736Li52Y7CHADFGihTgBimcgnIH1iQaQF2
	 8/lAiCW2cP1AQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Jack Thomson <jackabt@amazon.com>,
	Jack Thomson <jackabt.amazon@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Leo Soares Passos <Leo.Bras@arm.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v2 00/13] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
In-Reply-To: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
Date: Tue, 22 Sep 2026 15:28:33 +0530
Message-ID: <yq5abj9p38vq.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

"Lorenzo Stoakes (ARM)" <ljs@kernel.org> writes:

> This series implements the KVM stage 2 page table pre-faulting feature for
> arm64.
>

> == Foundations ==
>
> The series begins by establishing the required foundations:
>
> 1. Update kvm_s2_fault_desc to store the exception syndrome register (ESR)
>    value independently, and update all code paths to use this value
>    exclusively.
>
> This is required to generate a synthetic fault for pre-faulting without
> inadvertently obtaining an incorrect ESR from elsewhere.
>
> 2. Update kvm_s2_fault_desc to store the kvm_s2_mmu independently, and
>    update all code paths to use this value exclusively.
>
> This is similarly required to generate a synthetic fault against the
> canonical stage-2 MMU. It would make no sense for pre-faulting to modify
> nested shadow page tables, so the code must not obtain an incorrect MMU
> from elsewhere.
>
> 3. Update the abort paths that consume kvm_s2_fault_desc to also return a
>    kvm_s2_fault_result.
>
> Pre-faulting needs to know the granule size handled by the fault, so the
> abort paths must return that information.
>
> 4. Pass walk flags to kvm_pgtable_get_leaf() to allow page-table walks
>    under the MMU read lock.
>
> This is Jack's patch verbatim. It allows KVM_PGTABLE_WALK_SHARED to be used
> when walking page tables under the MMU read lock.
>
> The API permits pre-faulting to run in parallel, and the read lock prevents
> the page tables from being torn down during the walk.
>
> == Implementation ==
>
> Pre-faulting is implemented in kvm_arch_vcpu_pre_fault_memory(), which
> pre-faults the stage-2 page tables for a specific GPA (the guest IPA on
> arm64).
>
> kvm_vcpu_pre_fault_memory() calls this function for each GPA in the range
> requested by userspace through the KVM_PRE_FAULT_MEMORY ioctl.
>
> The implementation is straightforward: walk the stage-2 page tables for
> the GPA and, if it is unmapped, populate the mapping by handling a
> synthetic page fault.

 [ ... 47 lines skipped ... ] 

>
> pKVM is not supported regardless of whether the VM is protected or
> not.
>
> This is because pKVM instantiates vCPUs upon run,
>

Can pKVM instantiate the hyp vCPU during pre-faulting ?


> but pre-faulting is  typically performed before a vCPU is run.  It would be confusing and
> inconsistent to error out on non-running vCPUs but to pre-fault running
> ones.


I use KVM pre-faulting when transitioning pages from shared to private
with CoCo guest. This ensures that a trusted device can DMA to private
memory before the guest accesses it.

-aneesh
