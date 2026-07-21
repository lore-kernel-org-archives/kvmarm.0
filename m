Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27DD83C37A9
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 09:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625051; cv=none; b=Rlq/vmhZ7g6w4XO2MLz4PSmxNA3rgHXoSJCmIpnNI5d+SzbfcKfL0DrMrUnJqW1zhgiFEzdkl03A5ykRm7F+VVc86uyFT1mYmvDkler++SzsO1lNXoiMU3q6ZJKPnYosPsyAVBR3h1oh5IqkBGNje96EONh1InhATBOlSBfv3ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625051; c=relaxed/simple;
	bh=J/TTouf1smFaZ0wJ/GLwH9QNxA9AZu7fNFGLM19UhfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b5W1WR1M4LoPRJ9D6hhWxroBxiOdiH8RJl/VJiPfaCEh452kwngSEG3OemWB7dL2feDasPTYrJi26A7boE4/EZtnf191dsJm97OjinSxemE7qvun4PE2Elx8KDLUdtSwvDYs7GXWKqCYadvNQwyg3sKGmKY3YOICc+pb6OHjzws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Kj0yFMLP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Kj0yFMLP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE4971595;
	Tue, 21 Jul 2026 02:10:43 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E9643F66F;
	Tue, 21 Jul 2026 02:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784625048; bh=J/TTouf1smFaZ0wJ/GLwH9QNxA9AZu7fNFGLM19UhfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kj0yFMLPYPXndUtCQvXAlYvq4RU/cOZHL44M5H8vsTft5co+1shTfNX7W37kujWnD
	 NyBEr1jK/y901NxBVRHG7yRnwSfYyztbJGAJ26h5CoAhpJCSFGIc1ve4awJ8gHy2VZ
	 lGS+l8zHYVzQ89zmHJR5LharzDNb6spmSclGNa0Y=
Date: Tue, 21 Jul 2026 10:10:43 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, steven.price@arm.com,
	fuad.tabba@linux.dev
Subject: Re: [PATCH v2] KVM: arm64: Reject guest_memfd memslots when the VM
 has MTE
Message-ID: <al83k-ijRGy10Qmp@raptor>
References: <20260720130942.135033-1-alexandru.elisei@arm.com>
 <864ihtfyue.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864ihtfyue.wl-maz@kernel.org>

Hi Marc,

On Mon, Jul 20, 2026 at 04:46:33PM +0100, Marc Zyngier wrote:
> On Mon, 20 Jul 2026 14:09:42 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > The user cannot use MTE on VMAs created by mapping a guest_memfd file,
> > as arch_calc_vm_flag_bits() does not set VM_MTE_ALLOWED.
> > 
> > When creating a guest_memfd backed memslot,
> > kvm_arch_prepare_memory_region() rejects the memslot if MTE is enabled for
> > the VM and if guest_memfd has been mapped in a VMA that intersects the
> > memslot.
> > 
> > However, the documentation for KVM_SET_USER_MEMORY_REGION2 explicitly
> > states that the only condition for userspace_addr is for it to be a legal
> > userspace address, but the mapping is not required to be valid nor
> > populated at memslot creation.
> > 
> > If userspace sets userspace_addr to an address that hasn't been mapped, or
> > if userspace_addr belongs to a VMA that isn't backed by the guest_memfd
> > file, or if the VMA doesn't intersect the memslot, memslot creation is
> > successful and KVM ends up with a VM with MTE and guest_memfd-backed
> > memslots.
> > 
> > The same happens if the order is reversed: when userspace enables MTE, KVM
> > does not check if memslots backed by guest_memfd are already present.
> > 
> > Fix both issues by rejecting guest_memfd-backed memslots when MTE is
> > enabled, and by reject MTE when guest_memfd-backed memslots are already
> > present.
> > 
> > Fixes: 32e200bd6e44 ("KVM: arm64: Enable support for guest_memfd backed memory")
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> This looks reasonable to me, but you probably want to capture some of
> that in the documentation one way or another, because this will leave
> the amateur VMM author puzzled for a bit...

Of course, will do that in v3.

Thanks,
Alex
