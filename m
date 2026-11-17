Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794955792;
	b=wIVa49YI3OXAkHpVlX+EreAhaECY8zm/27DtX5Ypcw+KFLJIxO5/PSc2spAR8Fe+Orwx
	 +M5604RarD+SbnEVcjzjLseFZCUyOxOmgBPrIhHbSaINOQtGoGXZbFuRxbOGPiZa0y+x7
	 XjrXeHUHmLjOwCV0kPTUEEsftH/9cOt6ybwLFi2K4CaIBbVhddX0efeXdEDz7ZFoVQbGi
	 jarOYOdHyNxr2fazg1JCcDQCmHX9tgCsljrncAXcN0RpJJZMRxeBS572p0wSxK5RcVi3/
	 kZbM8oHcE5qVmJub3M2tBHz2Mro35ij/MrNfQA1QoRVp9NKG8jp7Ku1FaT2uePAOWRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794955792;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xoLIi0+olq1ojYmB+iwbcLFbgFXr/KR/iCCHN1uHop8=;
	b=uhq3DqZJRb/0CPS9b4p0J7q7r3Fxmyf+2xR70dDCXiFZGCJT7+XwprgNKwgRzW0KrZhJ
	 PjhfnqVWaiSJu2HqqVauv583SQoZEbykeNrUkAeKvT8GoGBWl9DykI+uwoKS7Pzl+0xCj
	 JRf3M+wOozvHnyYYPjdScCuFfj+/FsPHkBX5bvUuzcuIXXcCuKUtyho6yMHyfL6AHNkMD
	 ZrLJbpvVHuX2uAUukwqeU8GHk/74GLoyA2IgOtncB1yuZrJm8yrrmMH/bvA3vYnvXzc+/
	 dF7qhO1rFg4M5vPM1IqEvOZQHQNTg9+jlOVv5mR+z6a9hp9Cijwbv0ytbuPcpwx5MaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VwjGYOJh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436BA606A32A;
	Tue, 17 Nov 2026 22:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VwjGYOJh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8911F000C4;
	Tue, 17 Nov 2026 22:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794955791;
	bh=xoLIi0+olq1ojYmB+iwbcLFbgFXr/KR/iCCHN1uHop8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VwjGYOJhlAj8ZpYJeytQG47xN61sbDQutcXuSQlxtF0fWFJ2Zd5V6wzE0g7m6YzZN
	 dHRFlOJKCqYCSL7pnYD63FHOCtfqV6aWC+WxNlOUCMaqFQshLLN2/31d3wdFhcv/ul
	 0ZLTOAxA8YgseK6uBCIqBZTTL2EWys00vbsPoZpjg3w4autIth33cv5mzM+jyeFM17
	 9LJwlgFPNWTIVl6UFi8GTDI83XZ3tp3yZ+jxmBwZYVUNCdR1NE7HmcktvaLkfBcZVU
	 /Z1wOSx8jySqBZSGtegqLhYLeX2LeJ6LE03sGIBA89IoWz+T1OK8LN91pVBYId8I//
	 7dc3Uql7OkHFw==
Date: Tue, 17 Nov 2026 14:49:50 -0800
From: Oliver Upton <oupton@kernel.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Leonardo Bras <leo.bras@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0
 when E2H0 is NI_NV1
Message-ID: <avzaDnFRQ2GTHDiN@kernel.org>
References: <20261117204535.4036191-1-coltonlewis@google.com>
 <20261117204535.4036191-3-coltonlewis@google.com>
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
In-Reply-To: <20261117204535.4036191-3-coltonlewis@google.com>

On Tue, Nov 17, 2026 at 08:45:35PM +0000, Colton Lewis wrote:
> In a VHE-only EL2 guest (KVM_ARM_VCPU_HAS_EL2 without
> KVM_ARM_VCPU_HAS_EL2_E2H0), KVM advertises ID_AA64MMFR4_EL1.E2H0 as
> NI_NV1, making HCR_EL2.E2H RES1 and HCR_EL2.NV1 RES0.
> 
> Extend hello_el2 to attempt clearing HCR_EL2.E2H and setting HCR_EL2.NV1
> from userspace via KVM_SET_ONE_REG, verifying that HCR_EL2.E2H remains
> RES1 and HCR_EL2.NV1 is masked to RES0.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/arm64/hello_el2.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/hello_el2.c b/tools/testing/selftests/kvm/arm64/hello_el2.c
> index bbe6862c6ab16..5910497f8fbe4 100644
> --- a/tools/testing/selftests/kvm/arm64/hello_el2.c
> +++ b/tools/testing/selftests/kvm/arm64/hello_el2.c
> @@ -45,6 +45,7 @@ int main(void)
>  	struct kvm_vcpu *vcpu;
>  	struct kvm_vm *vm;
>  	struct ucall uc;
> +	u64 hcr;
>  
>  	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
>  
> @@ -66,6 +67,13 @@ int main(void)
>  		TEST_FAIL("Unhandled ucall: %ld\n", uc.cmd);
>  	}
>  
> +	hcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2));
> +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
> +		     (hcr & ~HCR_EL2_E2H) | HCR_EL2_NV1);
> +	hcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2));
> +	TEST_ASSERT(hcr & HCR_EL2_E2H, "HCR_EL2.E2H should be RES1");
> +	TEST_ASSERT(!(hcr & HCR_EL2_NV1), "HCR_EL2.NV1 should be RES0");
> +

Again, comment would be helpful for why this is done from userspace,
i.e. the RESx as seen from the guest POV is stateful but the value is
ignored.

Thanks,
Oliver
