Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638405304A1;
	Wed, 23 Sep 2026 13:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790170149; cv=none; b=QvasFz3C3LA3OUQXciizANBRtga6byIOTXZqFtk98iqsMRwRfstrxNjslHSYN6xt1tDYtdTvubi8Rp0RrjKDTj2JF1TqwvhQ6oKgi+aOJ9GEefmgQY+g89FvdB2W+WiiQeiP1Q8y/OeH/cKGsI8TdOVzAVrQ7G/qXJim/7y68SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790170149; c=relaxed/simple;
	bh=WD/PEtydjghwC/tknaP4WOFJKi630o/3LrZrYK2+NhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iUpS4+n5hPPzJr++8V64SBeiupfBDTZ4efIFFgJCF+HB6oUizkcgn1+pIQ/B48vdqr+CpW80SY25xZA0ae7seD851RGISK3KeiuZdtoB7x4qrNIUU652ZOyxTxRs2/tK1kLHwNSclAxQnmo9//QI/JxzXjSMLl4UlLxvZ4jflM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEYHECZL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEYHECZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2832A1F000FF;
	Wed, 23 Sep 2026 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790170148;
	bh=HKxy5ppVh+ZVi5LdabeSqcQhssdmIldVntZe+JHVqHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eEYHECZLL4YnROp24IFvxK5oqs4Thdn064/2WlM7Tose8DQWMJ0ePy8zG/6y6ezX+
	 2Vy00VkkmXSyzsZFfBMRHcSypqZQlPuF1HiP1tQcYdePlFyW2d49Ngvevx2WK+vnFy
	 ogzbX9WKDjakM3jBbTgJYL7l0g6ZO6ITb6ojwnlErR5mCQY6Lt5psTNkrUw+LzxxJl
	 Kv0IadWBvXRpCef9XC0XEbAWuS5jzmfHRjEhTJKc6FDmbH7GXi/LjHEuXQLOXKE6Yq
	 fNYOniMZgeEdw8I3tMDVXQyV0tT6iVDwZVjzNisq9/FeOu+P2svrYqIlHx77LHK+Qs
	 jciqEW9G7sHew==
Date: Wed, 23 Sep 2026 14:28:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Mark Rutland <mark.rutland@arm.com>, Randy Dunlap <rdunlap@infradead.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 10/14] KVM: arm64: Implement KVM_PRE_FAULT_MEMORY
Message-ID: <arPTt4WuVxcdvThs@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-10-787bd3bc7e3f@kernel.org>
 <CA+EHjTyCc=T+HkvWv1g2Fg3OxGaa1i8Hdv296ivPc94jQqZq9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyCc=T+HkvWv1g2Fg3OxGaa1i8Hdv296ivPc94jQqZq9g@mail.gmail.com>

On Wed, Sep 23, 2026 at 12:18:10PM +0100, Fuad Tabba wrote:
> Hi Lorenzo,
>
> On Tue, 22 Sep 2026 15:18:04 +0100, "Lorenzo Stoakes (ARM)"
> <ljs@kernel.org> wrote:
> [...]
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> [...]
> > +static long __pre_fault_s2(struct kvm_s2_mmu *mmu, struct kvm_vcpu *vcpu,
> > +                           gpa_t gpa, struct kvm_memory_slot *memslot, s8 level)
> [...]
> > +        if (is_gmem)
> > +                ret = gmem_abort(&s2fd, &result);
> > +        else
> > +                ret = user_mem_abort(&s2fd, &result);
>
> When kvm_gmem_get_pfn() fails, gmem_abort() calls
> kvm_prepare_memory_fault_exit() before returning, which on this path
> writes vcpu->run's exit_reason and memory_fault fields outside
> KVM_RUN. If that happens on a vCPU between its KVM_EXIT_MMIO and its
> next KVM_RUN, kvm_arch_vcpu_ioctl_run() reads KVM_EXIT_MEMORY_FAULT
> instead, skips kvm_handle_mmio_return(), and the guest repeats the
> access. Could gmem_abort() skip that exit when result is set?
> user_mem_abort() never writes kvm_run.

Ack yeah we shouldn't be updating vcpu->run like that in that case, will
update to avoid doing that in v4.

>
> Cheers,
> /fuad

--
Cheers, Lorenzo
