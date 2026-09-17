Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB0AD5867EC;
	Thu, 17 Sep 2026 14:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789654628; cv=none; b=vDcPt6c9zuNDxCSApiy+C3f8yAHI087VYOBkfvpu0Cs2eJKKZo9r03uYRRpYepwOtSXf1spQwzp1kYb5+E/r/p0WUfBRaF68G4K5OVBOa01EqQudiwKuye9VG93RX0doHqhYxsZ6O6OhQAjOnbntWEh+EH/KzGLlDXZL3ve9LAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789654628; c=relaxed/simple;
	bh=pb7xR/fKGsnfdWDmXTH00LDpPa2TSX9O10vKxJaowzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QBfTb1XDIoVAF4IJ4UgFPw0q/6Jas/qGhDExISB1fkTadsMdJfVPg9Rv+7KAFZGtwp+MeJlov86i6AnVpHEDq6CC0MxylAiYU4klxlywbkXP0Syaf1kt6cS8fRnPjadPF4bf6+BexW6jq7wNWbt+uzfWeJkNcVWrL/BRxHF6lUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eeRtgkL5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eeRtgkL5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 825C11476;
	Thu, 17 Sep 2026 07:17:01 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C1533F86F;
	Thu, 17 Sep 2026 07:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789654625; bh=pb7xR/fKGsnfdWDmXTH00LDpPa2TSX9O10vKxJaowzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eeRtgkL5bs1S2xyfNJ2gM5/G0dKa7JgqqLs8Mvx1HweJTifaSacbPt06TMTz/FKIZ
	 efYEwPUsLaX0+BrIijEhkPpSWkBCeJbtN4cDGYpCzQSG5Ofv1oskfmsT243axwiu1c
	 Mv1+/flcmG5baHKvw+Q4ApkYTn0Yr98yNZoAfJH8=
Date: Thu, 17 Sep 2026 15:16:57 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
	gshan@redhat.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18 12/23] KVM: arm64: Widen the scope of "protected" VMs
Message-ID: <aqv2WdAxQ70uFbuj@e143914.arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-13-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915160141.3543048-13-suzuki.poulose@arm.com>

On Tue, Sep 15, 2026 at 05:01:30PM +0100, Suzuki K Poulose wrote:
> On arm64 we have "protected" VMs that run on PKVM as a confidential compute
> guest. Given we already have the construct of "kvm_vm_is_protected" in the core
> KVM code, use that for all confidential compute guests including Realms that
> we are about to add.
> 
> Use the VM flavor to detect the "protected" VMs by introducing a marker.
> Add explicit helper to detect if a given VM is a "protected" VM under PKVM.
> Change the existing users that precisely want to check the VM type. These
> include :
>   - kvm_arch_prepare_memory_region - For preventing memslot changes after pVM
>     creation.
> 
> All the others are retained as a wider check for confidential guest VMs.
> These are:
>  - kvm_vm_ioctl_set_counter_offset - For disallowing timer offset configuration
>  - io_mem_abort for dabt handling without valid syndrome information
> 
> Both of which are true for Realms too.
> 
> Realms support is restricted to VHE host and thus "kvm_vm_is_protected()"
> checks in the pkvm hyp specific code doesn't need to change, as the only
> protected guests it deals with is "protected PKVM" guests.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

nit: need to s/PKVM/pKVM/ on the commit message too!

Thanks,
Joey
