Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B51349CC3;
	Mon,  5 Oct 2026 08:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791188235; cv=none; b=YWSuoGftr4D8MVOmfaZ4ftckCY9JTib7dMXYGPOo3Zso8MLTYKmpXgkkJ1lFXztgFYWmr/bxfXZ2quclEbX6B3suRIriTrr7lRQ1Al0B97TKyJbsZqvQwA/B797fj9FRDg4ISatGe/DXZAteMhRbL5OBATvtJuVLc1JGGkIrm0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791188235; c=relaxed/simple;
	bh=Ll4d/W7+VpfeFiQCo86C1RRPw4tjVGdF3eCnkhyfIlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YjMvNA9qYwa7GxXt2HuOYsPoCKp0y+OdGhLbseLc0r80RiHzE209aMjna8g11CVNyDiVFpqqqz2qyL9Hi1yfpT8b6A5MH9iawEhdBaTWhKFYsE60peudT0NsJe6e3SYD4z7u2ahzFEB7sM5KbJ7/WlmIqYjr9uK+eb43crVu1nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gvOMKerV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gvOMKerV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A371F000FF;
	Mon,  5 Oct 2026 08:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791188234;
	bh=LOUDEDfbIuhsdU9SMlqRtqsOKmFkLusGahJcyhTqJsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gvOMKerVLu6ANJO/Dzr1bSj3L6JSMCZ9duOUYPtB4ZW58O+tUaPSe4KMitx4ROu7n
	 r/orIXgLCdvlt/jk/DGlVcB/6xbezs6hrr0tGmVFn72NEPkKlfX/41U85N51HNE2Cj
	 80jrS3NP88l4TdQTKj1G7UmIo1rzrbJY13FIBKr1U7e+fUWi9GPhAVpeOZEnT7dRCL
	 TS5+2M2ZFvbv7G+nRTS8INQjg4ucv8HvlMXK811bc6v4jWh/ebKF6zbKOSMWqM9qO+
	 EavxJFIIk/Bw1ceQJG2n7P7QqYhvJl9tTHrkAqS1e8Q2ItaFUSpD5RmlzI8k7pRxAa
	 i+PN9tuh9XW7g==
Date: Mon, 5 Oct 2026 01:17:05 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	vdonnefort@google.com, qperret@google.com, tabba@google.com
Subject: Re: [PATCH v3] KVM: arm64: selftests: Check SError is not pending
 after delivery
Message-ID: <asNdAXGkxagm88Su@kernel.org>
References: <20261005050349.836795-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005050349.836795-1-fuad.tabba@linux.dev>

Hi Fuad,

On Mon, Oct 05, 2026 at 06:03:49AM +0100, Fuad Tabba wrote:
> test_serror() never looks at the vCPU after the SError is delivered, so
> a stale pending SError goes unnoticed. Read the vCPU events back and
> check the SError is no longer pending.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
> The fix from v2 was applied [1], but not this test.
> 
> Changes since v2 [2]:
> - Dropped the fix, now in kvmarm/next.
> - Rebased on kvmarm/next.
> 
> [1] https://lore.kernel.org/all/20261001135711.1640520-2-fuad.tabba@linux.dev/
> [2] https://lore.kernel.org/all/20260921101030.1231605-1-fuad.tabba@linux.dev/
> 
>  tools/testing/selftests/kvm/arm64/external_aborts.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
> index 7836756a38a6c..c35b0c87250a1 100644
> --- a/tools/testing/selftests/kvm/arm64/external_aborts.c
> +++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
> @@ -239,6 +239,7 @@ static void test_serror_guest(void)
>  
>  static void test_serror(void)
>  {
> +	struct kvm_vcpu_events events;
>  	struct kvm_vcpu *vcpu;
>  	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_serror_guest,
>  							unexpected_dabt_handler);
> @@ -247,6 +248,11 @@ static void test_serror(void)
>  
>  	vcpu_inject_serror(vcpu);
>  	vcpu_run_expect_done(vcpu);
> +
> +	vcpu_events_get(vcpu, &events);
> +	TEST_ASSERT(!events.exception.serror_pending,
> +		    "SError still pending after the guest took it");
> +
>  	kvm_vm_free(vm);
>  }

Can you add coverage for the vCPU events state to all the test cases? In
addition to the case where the SError is taken, it'd be good to assert
that the SError remains pending if the guest masked it.

Thanks,
Oliver
