Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9F0459AFC;
	Fri, 11 Sep 2026 09:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118226; cv=none; b=rk3CdJbAEYbjXbKbEFqWjHaFAG/jk1s0yT9l6kdMCBs4iCY+EM1Z9DNI3pppwbwEG2aalQXIAxCSUlomM8rsq4b5f5jChKR3pwiWReAJ94m3aq2XEx84SXr2b+WvbA/lHpPJqBo9315w7R+XfVfykQ05sANJi1iNmNK80RjuNIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118226; c=relaxed/simple;
	bh=y4VNhJAktDNpssOv4fj1+dd7jYwgGkHIusbvYWB/ZOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rFSPKPmEtEUspzHucKGJD+E7Dx7A3ThjHqLk1bs4EMSS00faxE3gLejT+nhWiiM+X280Jy78y5Gm+w3szyy+AqKvSanxkIshocG+rjn9dZgUO2SjfMdamz45gk2qW7HzJO0ziDUAxJrLq9MPakRc1IhlJ2DIIKbnlU8xwdaT+MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbxSeSbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbxSeSbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461631F00893;
	Fri, 11 Sep 2026 09:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789118224;
	bh=9sp1kFZZ0O6uT9i63Hix+4jeTVWCdlo9frW6hVcqvPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RbxSeSbZZUU0Ne8WJuZalWlgBdFvk4xRMp9Ec5R+eTdN31MG6FizPvealsA8XcP1v
	 zNS5ieOGImLE2jalyPZo4vsiTdEfdUkdB7GmVkBOf1vxa4SHkKXsGBTvg0avzvhGGg
	 deKE1DrgNkIX1pL2e9ZZ9QtOCasm9rCQZwiwcuv9+jAyGAYazY/1fZfbAtrB+Zh3ej
	 NWcg19p2iAlvNl7WI95KE38yDNvPQOt8/ixv+HzhfDYf0JZnCUmE7FuSKFKpOvbPZu
	 vwVSPh+NomvlJ4fIvsfBXc71GY1MwJdG0NzylODt5gOCTZANrP/D3O723K3yAQCT+4
	 JhYiRwBiB3F2w==
Date: Fri, 11 Sep 2026 10:16:55 +0100
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
Subject: Re: [PATCH 0/8] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
Message-ID: <aqPGWNxm0rOMRaXw@gremlin>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
 <CA+EHjTw=7M+ac5UCfM5yPmuX8RuqZN08TLfXAmTLbQgmuhNWtw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTw=7M+ac5UCfM5yPmuX8RuqZN08TLfXAmTLbQgmuhNWtw@mail.gmail.com>

On Thu, Sep 10, 2026 at 07:44:25PM +0100, Fuad Tabba wrote:
> Hi Lorenzo,
>
> On Tue, 25 Aug 2026 at 17:01, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > This series implements the KVM stage 2 page table pre-faulting feature for
> > arm64.
>
> I know there's likely going to be a V2, but FWIW, I tested this series
> as follows (finally managed to get protected mode running on my Mac):
>
> QEMU (arm64, -cpu max,pauth=off):
> - Protected-mode host, boots non-protected and protected guests
> - pre_fault_memory_test on a non-protected host, VHE and nVHE, all 13
> guest modes
> - nv_pre_fault_memory_test with kvm-arm.mode=nested
>
> FVP (AEM, FEAT_NV2):
> - nv_pre_fault_memory_test with kvm-arm.mode=nested
>
> Apple M4 hardware, running as a KVM host at EL2 under Apple's nested
> virtualization (nVHE only):
> - pre_fault_memory_test, anonymous and anonymous_thp backing, over the five
>   guest modes available there (the IPA is capped at 40 bits and the 64K
>   granule isn't implemented)
> - with kvm-arm.mode=protected, pre_fault_memory_test skips on
>   KVM_CAP_PRE_FAULT_MEMORY, so the pKVM exclusion holds on a live pKVM host
>
> Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
> (happy to retest again when you respin)

Perfect, much appreciated thanks! :)

I won't carry the tags forward to v2 just in case anything breaks there, so
appreciate you taking another run at the v2 also thanks! :)

>
> Cheers,
> /fuad

--
Cheers, Lorenzo
