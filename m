Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624D246D2B4;
	Fri, 11 Sep 2026 09:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118487; cv=none; b=ZxVDnhLQdZ642MxfZZuEAF3A2r+fIV4flbzg5FhC8PHG0EmDFKY4KsrQkc6otqEGDwOmnQ/Q4ML3zthSfaw4eqyhHnY2rZHEg9BLGm3xaOXpYO4c3SSC9qOKhgUSUHUrg/DUXj2RA43G3iBcy4JpQ1JJClBta7zxf0joMfTqRHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118487; c=relaxed/simple;
	bh=sSPYvXAS+pe2UihmOVkjAmU6fCndo2uXYrc7/3ZTM9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HEJjl14wx4aXe1u4Yo3JAIH/RWuZ5U3OZdRuRiZLWJE3A8o/51gz8aLZlyIuCR1sjWodglQUvT+50u6AFBMm/wPz0TD5G8Z0Um/B/1H/2u1BGRZH4il6zwBQZV4G221Jw9jEBI9/ZtywXemgos5eqSgvFN5k7YWOTS3fDjWbpOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a33dLmzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a33dLmzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FD41F000FF;
	Fri, 11 Sep 2026 09:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789118486;
	bh=oxmQxrsMeqRHqVktx/UJ3IdFFga7UWvSUavLJ9XkLmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a33dLmzYgclcf+h0y1zqNlrGUlx91lz83YB4ZqpgXrK6Ah+8Nfvau6tKK5KdEeuXd
	 Dfux531lNaQrUZMYOx9mE3Xt+SJyYT3Pwf9INrmJCjVcmS7PtuCuEgssXaoy11URi7
	 c+LKdnXUxnNCN5p/xbRkldiKd+FCoUjVVSduevBHRfHWphQ8t8yFEh4xouPXLw8FpX
	 2qWA0Te2CVaU90nRBs5wkVVdMm9L249BMMjiauBEXlRIY4oo8tsN/QABKSQLOHUcAh
	 GqOfOlHIhfM6MquRJ5kSTkCwA4s/52KTfnhDM1/pqee+JhU+Vr4vdo4VVRuVcauEpS
	 S9SKCJgqbS/mg==
Date: Fri, 11 Sep 2026 10:21:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>
Subject: Re: [PATCH 8/8] KVM: selftests: Add nested pre-fault test for arm64
Message-ID: <aqPH7yjXOIfCOpmE@gremlin>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
 <20260825-kvm-arm-prefault-v1-8-befe8947702e@kernel.org>
 <CA+EHjTy8m=b8D6sLOTv3AW05vXqFPRrTYvG7-t3D64Vt1+jAWQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTy8m=b8D6sLOTv3AW05vXqFPRrTYvG7-t3D64Vt1+jAWQ@mail.gmail.com>

On Thu, Sep 10, 2026 at 07:57:03PM +0100, Fuad Tabba wrote:
> Hi,
>
> On Tue, 25 Aug 2026 at 17:02, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> ..
> > +int main(void)
> > +{
> > +       struct nested_s2_state s2;
> > +       struct kvm_vcpu_init init;
> > +       struct kvm_vcpu *vcpu;
> > +       struct kvm_vm *vm;
> > +       struct ucall uc;
> > +       u64 npages;
> > +
> > +       TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
>
> Would test_supports_el2() work better here? It honours the NV=0
> opt-out, and since HAS_EL2 is set unconditionally below, NV=0 doesn't
> disable this test as things stand.

That sounds sensible :) Will fix on respin.

>
> Cheers,
> /fuad
>
> > +       TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
> > +
> > +       vm = vm_create(1);
> > +
> > +       kvm_get_default_vcpu_target(vm, &init);
> > +       init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
> > +       vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
> > +       kvm_arch_vm_finalize_vcpus(vm);
> > +
> > +       npages = TEST_MEM_SIZE / vm->page_size;
> > +       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, TEST_MEM_GPA,
> > +                                   TEST_MEM_SLOT, npages, 0);
> > +       virt_map(vm, TEST_MEM_GPA, TEST_MEM_GPA, npages);
> > +
> > +       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> > +                                   NESTED_S2_ROOT_GPA, NESTED_S2_ROOT_SLOT,
> > +                                   vm_adjust_num_guest_pages(vm->mode, 1), 0);
> > +
> > +       /* Run the guest until it has ERET'd from vEL2 to vEL1. */
> > +       vcpu_run(vcpu);
> > +       switch (get_ucall(vcpu, &uc)) {
> > +       case UCALL_SYNC:
> > +               TEST_ASSERT_EQ(uc.args[1], 1);
> > +               break;
> > +       case UCALL_ABORT:
> > +               REPORT_GUEST_ASSERT(uc);
> > +               break;
> > +       default:
> > +               TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
> > +       }
> > +
> > +       /*
> > +        * The vCPU's last-run context is vEL1, backed by a shadow stage-2
> > +        * MMU. Enable nested stage-2 with an empty root so that the ioctl
> > +        * fails if it tries to interpret the userspace GPA as an L2 IPA.
> > +        *
> > +        * Prefault in two halves so that the second ioctl exercises a
> > +        * repeated shadow-MMU attach and canonical stage-2 swap.
> > +        *
> > +        * (Note that an implementation that wrongly populates shadow
> > +        * stage-2 page tables would not be caught as userland can't
> > +        * inspect these.)
> > +        */
> > +       s2 = enable_empty_nested_s2(vcpu);
> > +       pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE / 2);
> > +       pre_fault(vcpu, TEST_MEM_GPA + TEST_MEM_SIZE / 2, TEST_MEM_SIZE / 2);
> > +       restore_nested_s2(vcpu, &s2);
> > +
> > +       /* Resume at vEL1 and touch the prefaulted range. */
> > +       vcpu_run(vcpu);
> > +       switch (get_ucall(vcpu, &uc)) {
> > +       case UCALL_DONE:
> > +               break;
> > +       case UCALL_ABORT:
> > +               REPORT_GUEST_ASSERT(uc);
> > +               break;
> > +       default:
> > +               TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
> > +       }
> > +
> > +       kvm_vm_free(vm);
> > +       return 0;
> > +}
> >
> > --
> > 2.55.0
> >

--
Cheers, Lorenzo
