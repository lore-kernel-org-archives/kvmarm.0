Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C44F4E325E;
	Tue, 22 Sep 2026 20:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790109789; cv=none; b=tFtwJ/QdQI251d3gYy320SZpRyUAlemFF46asRRRGTFAYT/fHQlc/nZs+F0lb3CmsoPX72jFdCJYk4NpkZQHo3JzPE7wZrRFWusptpn79UgdDW0wNx+fJIS4EnH59bD8a6wcM+ajbZbXDfFkvFlUee3kbsl6RIfo8HyKlz3pwQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790109789; c=relaxed/simple;
	bh=j0nkk7X3qJSlJJYZKr1Wym+f63EIr4ap5LhKqaGzxVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lsSd7wOPHGlxrUkPHzms6V2Ov3F4eqAKB/UMvep8Z5cq55/XfGobkQTPO2UWiRIE6xkF5hNTBSb/edL/d5i+9AfNIw3z42QHa3SdOZ2bK0npv374H8EmKfVkehWrQdVbmHcuoXycR4zjLTPn6rtinsjpawyfSxZQhw6ou47K1FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ot50nqYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ot50nqYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB881F0089A;
	Tue, 22 Sep 2026 20:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790109772;
	bh=b9SqF1U4AYAmpuF1a0G96/WAnPd35ZdOW84UAYiJBR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ot50nqYa/vsD+HB2q0FRrRNgPARDAPRd+XUlcKbw2C2Nd8GheCjRiCk83nxmTP249
	 ufuLNrMiPHtEd5o9ypLesJK1Y0+m84SUTp6pnv9gdW5siMF9JpTqBCw97jQTn3wPVg
	 RYrHcnLnIGwkXgGFhs1tqUY3p1yqpHzemp0QTbhPGQGD9fBVk2Fc0xFeZGjkWfEc7X
	 zKzOLUsuVaoKiVJRlg0xCX8kLlgnwBNs9tw4J0YUG4rMQiRX1gQ+/NofpzI5iValLl
	 zPXAL9mERHl+HrEEKrN9FWJBjbLKfQTpjepOrkh0nyr4CPof6O3a+lJIKoKC1qBOeZ
	 /uukaxJgnIjBA==
Date: Tue, 22 Sep 2026 13:42:50 -0700
From: Oliver Upton <oupton@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Jack Thomson <jackabt@amazon.com>,
	Jack Thomson <jackabt.amazon@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Leo Soares Passos <Leo.Bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 00/14] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
Message-ID: <arLoSiMeCkzPkl9T@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>

On Tue, Sep 22, 2026 at 03:17:54PM +0100, Lorenzo Stoakes (ARM) wrote:
> ---
> Jack Thomson (3):
>       KVM: arm64: Pass walk flags to kvm_pgtable_get_leaf()
>       KVM: selftests: Enable pre_fault_memory_test for arm64
>       KVM: selftests: Add option for different backing in pre-fault tests
> 
> Lorenzo Stoakes (ARM) (11):
>       KVM: Allow architectures to disallow pre-fault
>       arm64: Add ESR fault helpers
>       KVM: arm64: Use ESR helpers in guest abort handling
>       KVM: arm64: Propagate and use esr in s2fd when handling guest aborts
>       KVM: arm64: Propagate and use mmu in s2fd when handling guest aborts
>       KVM: arm64: Propagate and use kvm_s2_fault_result on S2 fault
>       KVM: arm64: Size the stage-2 memcache from the fault MMU
>       KVM: arm64: Propagate EHWPOISON in kvm_s2_fault_pin_pfn()
>       KVM: arm64: Implement KVM_PRE_FAULT_MEMORY
>       Documentation: KVM: document arm64 KVM_PRE_FAULT_MEMORY
>       KVM: selftests: Add nested pre-fault test for arm64

Besides the usual nitpicking, this series is looking good to me. Thank
you for picking this up Lorenzo!

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver
