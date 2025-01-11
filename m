Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E03CBE46;
	Sat, 11 Jan 2025 13:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736601605; cv=none; b=LvdTBmsGEhIRhBNseZlhe3n/clK8kHWHqo2bj4j9k/tczWNaCzOQiKhZkTuvag0IBPFIg1KldxZrWumDiAAcGft1CjP4jvxcxf1frZZ1Dj8AW72J8aeDht0bJaFgrgxUnKuqEatVVPc1LC4lJpaY2kEOQ8peYuFLD+eajo7JI+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736601605; c=relaxed/simple;
	bh=fG66nWrGM/6PKKdN96pf+ez5Xk8Ie0mSxd7kZ9d9Bw4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dc80jrgSl9V8BS64M0RkH4ugG1DapVQzE/Fo/jr5S5xY10/g07q6CJsTyUm3VePBNMZ8rxQ2ACqSN955btkoKMxEbAslsGD/eu4thdE21/ATL0HzUAKqSS3vV48BcOhE6uoNrpWhchrOPqskBV8p0h0mUiRLxNDKme7fiYJjpMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXsffBe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXsffBe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF449C4CED2;
	Sat, 11 Jan 2025 13:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736601605;
	bh=fG66nWrGM/6PKKdN96pf+ez5Xk8Ie0mSxd7kZ9d9Bw4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=lXsffBe9KjcI63HpkBhTvXaY/EH8m/VFeZc3qjATDk8+a5FETP8h75tIzzPNL86qT
	 O7cSStyrG7g2RCJEFeMypeC9wMMXGw87m29lds0vmE8cIi1fUXQ1vuU2Yuaf4uvulM
	 5Yb7bfEgJ0ugBSccNuW9P0e7Ow8Z9MRFHkVmxQDtxGLuDISWxOm8rgGEdK175IurTR
	 FMPsLfKenDc8larSgUoxA3U1CDfMEEXOnueJ2vAGMkR40xJpg5mTF3rlomwOU1CPwg
	 dki3CNqsfnlKHAKDtgnT8cWkUDuVA5vnk02/l0FwI1Aa5DgTtuVTI+vWSNuDbx3wKq
	 JxCxvuLDvRYoA==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 5/7] KVM: arm64: MTE: Use stage-2 NoTagAccess memory
 attribute if supported
In-Reply-To: <Z4Fk58k8YptDkVgm@arm.com>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-6-aneesh.kumar@kernel.org>
 <Z4Fk58k8YptDkVgm@arm.com>
Date: Sat, 11 Jan 2025 18:49:55 +0530
Message-ID: <yq5amsfxtrlw.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Fri, Jan 10, 2025 at 04:30:21PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> Currently, the kernel won't start a guest if the MTE feature is enabled

...

>> @@ -2152,7 +2162,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>  		if (!vma)
>>  			break;
>>  
>> -		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
>> +		if (kvm_has_mte(kvm) &&
>> +		    !kvm_has_mte_perm(kvm) && !kvm_vma_mte_allowed(vma)) {
>>  			ret = -EINVAL;
>>  			break;
>>  		}
>
> I don't think we should change this, or at least not how it's done above
> (Suzuki raised a related issue internally relaxing this for VM_PFNMAP).
>
> For standard memory slots, we want to reject them upfront rather than
> deferring to the fault handler. An example here is file mmap() passed as
> standard RAM to the VM. It's an unnecessary change in behaviour IMHO.
> I'd only relax this for VM_PFNMAP mappings further down in this
> function (and move the VM_PFNMAP check above; see Suzuki's internal
> patch, unless he posted it publicly already).
>

But we want to handle memslots backed by pagecache pages for virtio-shm
here (virtiofs dax use case). With MTE_PERM, we can essentially skip the
kvm_vma_mte_allowed(vma) check because we handle all types in the fault
handler.


-aneesh
