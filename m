Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33405400DE2;
	Mon, 14 Sep 2026 11:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789384670; cv=none; b=MiywaZiOtkw4tEYWs9mfEjb7KPO3ehXjK2OdB2qMr3u+URbm1egxERwR6y0xA1qnDmF/C6uc0d7D6NPVBdqx/6w6ERRwpacieUXVNGc5ENwG4CrDNdg2A8wM7KY/kHYHjGQqUAM+uGugKjOC7Rend7vCRBykeeKMd8Wk3jAMGYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789384670; c=relaxed/simple;
	bh=77boNCe4QcHNaZznY3tNscoqXOV4aM836eZT2R5ie9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpqVe7QcNhtNu3u5DnWlXbMf+bNei4vd2Itj2OERgv0Ez5eyP02GCNEKDJJLRUa+PBRoh77dN66g55UfRnyIc2xRS/DqHFH8NQr9kAGNGVEtZOCQB3vCXA4VPNLKs8RN6IEcLgRyXuRyaFGhvUOZRb99BbF+/fUzhWjtt9VTyPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=okQVDAHi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="okQVDAHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A06B1F00893;
	Mon, 14 Sep 2026 11:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789384668;
	bh=HKZPATLBOD75vX0HIDgrKuKrxajG+GHW7KZeSn5i2h8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=okQVDAHioY+gpCl/7iWCM7P65IIELg0y29z3PuOQsO2Gy9Z/cTVpKqTF7/jx5ebKq
	 rP7NWUdwq163cf+CE4eIosXADJRUm8QTifKfGOh14xCI6JbGdX1AGoXYaT1n+YMyRv
	 xQ39eLBQ/yJ9SoNHKCIeMHpC7FuqfCEijjdJQo57s2+/Lkh44vG71JRNYCYn+oaVuX
	 v0O8gGIWPvKzf9od0L+4/oi7/uInah4rT1EDn5NwI3A94vubxhKr8CNOQHCxsNxlPF
	 s83DDvN5g858flKSeTgrC2j3yejMHQdGKy++vMkYPn6C0EfNvh7z6rCRQLngB19w9A
	 mYZa73BnQoQhg==
Date: Mon, 14 Sep 2026 12:17:41 +0100
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
Subject: Re: [PATCH 6/8] KVM: selftests: Enable pre_fault_memory_test for
 arm64
Message-ID: <aqfXUTCCefQPKJ4a@gremlin>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
 <20260825-kvm-arm-prefault-v1-6-befe8947702e@kernel.org>
 <CA+EHjTzOKHNrf=0n2c_E+vbt=pGquz6qzBpJ+eLJ5hjK_nyJMA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzOKHNrf=0n2c_E+vbt=pGquz6qzBpJ+eLJ5hjK_nyJMA@mail.gmail.com>

On Thu, Sep 10, 2026 at 07:52:35PM +0100, Fuad Tabba wrote:
> On Tue, 25 Aug 2026 at 17:01, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > From: Jack Thomson <jackabt@amazon.com>
> >
> > Enable the pre_fault_memory_test to run on arm64 by making it work with
> > different guest page sizes and testing multiple guest configurations.
> >
> > Update the test_assert to compare against the UCALL_EXIT_REASON, for
> > portability, as arm64 exits with KVM_EXIT_MMIO while x86 uses
> > KVM_EXIT_IO.
>
> The message says this updates the test_assert for portability, but the
> parent has no exit-reason assert and no struct kvm_run; this patch
> adds both, so there was no hardcoded KVM_EXIT_IO to make portable.

Ack will fix up for v2 thanks!

>
> ...
>
> >  int main(int argc, char *argv[])
> >  {
> ...
> > +
> >         TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
> >
> >         test_pre_fault_memory(0, false);
>
> Would it be worth adding an arm64 case for gmem_abort()'s pre-fault path?

I think doing this would be quite a bit of work, I think perhaps one for a
follow-up?

>
> Cheers,
> /fuad
>
> >
> > --
> > 2.55.0
> >

--
Cheers, Lorenzo
