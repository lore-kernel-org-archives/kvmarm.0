Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881064;
	b=08P/NU4e+QedNUjx5Hi17oLHpmRcIfKUZucJCft3sIAGqKAInc/rTI3xHaVpqHjKLKkA
	 uVMvqMutDOgr9R2VZkhzrXQIt+05UHAJQAYpleMYKbTob+Nh1dyfdbuTrsL5AxQ43bpae
	 26C/NaVXjvqP0Rv7hbckdJI6bNbh4S3k3yVbsqw55qNHSVRT1o84B+BDGfRCgqDOv0Dem
	 PvF+NT8o581S6h94rRHWeswI1C++Ja8dclfGl3Udd1viIfQ3KhUXpyhBLAjRwqoXLhpU1
	 Vqedzp4NdMHBrSysP5prIL12c36SQ8nZC9KsWWkAzqxu8YJG1axhxS6nHC6JBzh8Syg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881064;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ShM/LzYh15H1VmyFk0yd5n30U2OKlMZRrk7dfYFeEYg=;
	b=U5t5mIslshhJ/KaWtWz6ksCIGwt3GXwHrBaTLU6eR+YvsJn9STzvhoVPHaZL5oBGR5D2
	 OuXYR6rK+0L05eah5LUdqioMVFFCStq1O+nEQiHpakqBC2J9Cm7//BrA/7LPWzj/srZhy
	 +8TnsZulBeLvADtQB2ybjGwTNynv6ifEUq7w1K2JsBnTjPx+NxxequjwxsGuY3N3sDVOk
	 QYLym60k45llhtW7SyJL7nch8nt4wI+W9ND+HMoTdFj15hEaLxuWF1qfta5XZ/wmvoZuh
	 zZ1Nk8d3WSqqr96uDB7BdvIyNi0GcptrBfWRdF41eDHBUpof8APaKEHpdlUWc3FogiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=C49j3ekR;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388E0606EE9E
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 12:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 388E0606EE9E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=C49j3ekR
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FE3B1E8D;
	Thu,  5 Nov 2026 04:17:33 -0800 (PST)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA9E03F673;
	Thu,  5 Nov 2026 04:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793881056; bh=j+lMJnSylQrD0+1OcivdSJ9GghFhWY5EWMq7YDes8RE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C49j3ekRRJi4RIZjd+tLIQL0aAmav4TKv+fDqpVmVSA7o8pP12o3qsbmQl66Eb4FY
	 tQI06CfIEa3l1jEqjC3YJhdwOtLwH3CynzRnTXSLrkf7RMRpk6qz0ijy7jhJ4s4dKt
	 jGgdNxarCNp7z1j7cgVPoLV+lKnkKnPIz2rEzrhI=
Date: Thu, 5 Nov 2026 12:16:09 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/16] KVM: selftests: Allow arm64 tests to create
 protected VMs
Message-ID: <auxziQ6yLOW5dhKv@e143914.arm.com>
References: <20261104084842.132944-1-fuad.tabba@linux.dev>
 <20261104084842.132944-3-fuad.tabba@linux.dev>
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
In-Reply-To: <20261104084842.132944-3-fuad.tabba@linux.dev>

On Wed, Nov 04, 2026 at 08:48:28AM +0000, Fuad Tabba wrote:
> On arm64, the VM type passed to KVM_CREATE_VM carries the IPA size,
> which the selftest library fills in. The library rejects any type a test
> provides in vm_shape.type. A protected VM is created by setting
> KVM_VM_TYPE_ARM_PROTECTED in that type, so a test can't create one.
> 
> Accept KVM_VM_TYPE_ARM_PROTECTED from the test, and add the IPA size to
> it as for any other VM.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Similar to what I did for realms locally, and will have to expand to
support KVM_VM_TYPE_ARM_REALM.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index d42e201eba763..96c1e70dba3d3 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -400,9 +400,10 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
>  	}
>  
>  #ifdef __aarch64__
> -	TEST_ASSERT(!vm->type, "ARM doesn't support test-provided types");
> +	TEST_ASSERT(!(vm->type & ~KVM_VM_TYPE_ARM_PROTECTED),
> +		    "ARM supports only KVM_VM_TYPE_ARM_PROTECTED as a test-provided type");
>  	if (vm->pa_bits != 40)
> -		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
> +		vm->type |= KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
>  #endif
>  
>  	vm_open(vm);
> -- 
> 2.47.3
> 
