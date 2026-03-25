Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32B1366067
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 08:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774425720; cv=none; b=Qr1F/0oIzAc8tG/DbMHOZwhxQnwdiWkVVRAEFiMNoLgyJvKgICcTQ+Vvepqay05TsrK4JwmMm9C9Vhq+teS/FLv3AeUibJOYzevwsioZHCxjB9O25kUb1ineJGqmBKUVHrJ5TfzsmSBpzfPSmU8GiIjaT/HSWDgYaF851qSRDDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774425720; c=relaxed/simple;
	bh=VlBxR/SzYAHrqVgrVE6UN8eEpY06CR6hnRPY1BAcTpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yvue6IsG/+bDp9s3C/NZAbDozWOcvg7ZuxUtLLZaKhNLP7YDjTI+/asF2QG6OpZDNUdr+x5D89ZwNMVz7taBCSwbP3q9UZC8CAjzWHQVx1ybLRM2jNnNlb1AihdL1Zgnd+3CsNriO3krHvFvgtv7xs7QUeOJqnljLAV0qCisxSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=Ph+hHuz/; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="Ph+hHuz/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1774425717; x=1805961717;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VlBxR/SzYAHrqVgrVE6UN8eEpY06CR6hnRPY1BAcTpo=;
  b=Ph+hHuz/nZjJ0NqtPBiGutYR9dUWNmCUb2ZhpAMXbhn+7WXVudZz92Mv
   SynZORhKK87mqhkiSzC19kC86+4aWByig7R+cQ113/mTVKosD+hDC1eOb
   1ew7bNYxZdEdNrmhyabRyVO/AL+0OFeocciEEc//gY0mcWH2W3DYUr19A
   Z8jzyzsPAJBzOOsfU6kYOvpU5rwrAp/kJC3gxeJnn3ixBTYjFwknvCV9L
   bnSGtJr9lA6XJS2USyp8NNLoK3pDWJmBOCS+7S1ghbGYBrWu3UNVv9EDu
   KAqrsghWnm4aPnAtsiLAt656/WJl7GdaDZ90rJhQheqlMZhwiL/OVKLoP
   w==;
X-CSE-ConnectionGUID: PCNhnxPhSgKECBgONalvCQ==
X-CSE-MsgGUID: Bq6ha/7DQBqfZSa2X5ikpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="222015061"
X-IronPort-AV: E=Sophos;i="6.23,139,1770562800"; 
   d="scan'208";a="222015061"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 17:00:47 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 705DB1002803
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 08:00:47 +0000 (UTC)
Received: from az2nlsmom3.fujitsu.com (az2nlsmom3.o.css.fujitsu.com [10.150.26.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 2909A1809C30
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 08:00:47 +0000 (UTC)
Received: from sm-arm-grace07 (sm-x86-stp01.soft.fujitsu.com [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom3.fujitsu.com (Postfix) with ESMTPS id 53168101BB54;
	Wed, 25 Mar 2026 08:00:41 +0000 (UTC)
Date: Wed, 25 Mar 2026 17:00:37 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 0/3] KVM: arm64: selftests: Basic nested guest support
Message-ID: <acOWJT39NGrmfSbQ@sm-arm-grace07>
References: <20260325003620.2214766-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325003620.2214766-1-weilin.chang@arm.com>

Hi Wei Lin,

On Wed, Mar 25, 2026 at 12:36:17AM +0000, Wei-Lin Chang wrote:
> Hi,
> 
> This series adds basic support for running nested guests (L2) in
> kselftest. The first patch adds library functions. While designing the
> APIs for userspace, I referenced Joey's approach for kvm-unit-tests [1].
> In summary, four preparatory functions are provided for userspace to
> set up state to run an L2 in EL1:
> 
>  - prepare_l2_stack()            <- sets up stack for L2
>  - prepare_hyp_state()           <- sets up vEL2 registers
>  - prepare_eret_destination()    <- userspace passes a function pointer
>                                     for L2 to run
>  - prepare_nested_sync_handler() <- sets up hvc handler in order to
>                                     regain control after L2's hvc
> 
> After calling those functions, userspace can vcpu_run(), and when
> run_l2() is called within the guest, the supplied function will be run
> in L2, with the control flow managed by the library code in nested.c and
> nested_asm.S. After running the L2 function, run_l2() will automatically
> return. Note that the L2 function supplied by the user does not have to
> call hvc.
> 
> Patch 2 demonstrates usage of the APIs introduced above, with a simple
> L1 -> L2 -> L1 sequence, with an empty L2 function.
> 
> Patch 3 enhances the library functions by setting up L2 -> L1 stage-2
> translation. Currently the translation is simple, with start level 0, 4
> levels, 4KB granules, normal cachable, 48-bit IA, 40-bit OA.
> 
> [1]: https://lore.kernel.org/kvmarm/20260306142656.2775185-1-joey.gouly@arm.com/

Look like this selftest assumes nested guest's MMU is disabled (L2 IPA
to L1 IPA to PA), but I couldn's find the explicit SCTLR.M bit operation in this
series, how do you make sure it is always off?

Thanks,
Itaru.

> 
> Wei-Lin Chang (3):
>   KVM: arm64: selftests: Add library functions for NV
>   KVM: arm64: sefltests: Add basic NV selftest
>   KVM: arm64: selftests: Enable stage-2 in NV preparation functions
> 
>  tools/testing/selftests/kvm/Makefile.kvm      |   3 +
>  .../selftests/kvm/arm64/hello_nested.c        |  65 ++++++++
>  .../selftests/kvm/include/arm64/nested.h      |  25 +++
>  .../selftests/kvm/include/arm64/processor.h   |   9 +
>  .../testing/selftests/kvm/lib/arm64/nested.c  | 154 ++++++++++++++++++
>  .../selftests/kvm/lib/arm64/nested_asm.S      |  35 ++++
>  6 files changed, 291 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/arm64/hello_nested.c
>  create mode 100644 tools/testing/selftests/kvm/include/arm64/nested.h
>  create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested.c
>  create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested_asm.S
> 
> -- 
> 2.43.0
> 
