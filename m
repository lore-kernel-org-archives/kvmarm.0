Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793836961;
	b=T/4n1q/Jt9xroQ3xv3TVqx/z6zcevLcib0eyAQITSFam9kFqpqLYPhN1vN32DI75n8rf
	 uAXDYztPgTNJyy2aZ/c7wkO6ub4c50r1uwfOg231sYM9/Yw61CYBg29hd8BcIJ7kRvlOZ
	 zj1XvNqrgoaUKsmivtYxZaFPVbjB94Gu8X2wHDyGHclrAXdK5z+jJAbhdCbguoG7379Gj
	 JmvaN2aNLkx5B/0k6HdaZXNM2IBs3cfJ79XbbX9d1HOI27zpAxRxKaVvyeNg/9fvYuxNL
	 CsefYvFhiGrPyHWyYKmZ5/+kzhapy7t25WhLUFiGv/g/nMb1AjgQoHRCDFPzwPanAfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793836961;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=I0dLEy0/RWH1lm8d6zJOmiHKcDSiY13O6lAZIBvefJE=;
	b=Ia39ZCiT2bLhuFJwxtDzcHOZFDxfyZUVW3mzTQmYwO5N56joDsH5wNQu6yiWqquenele
	 +p6y7QqWwzT2IYdvF1z6xIkRc995gvN621zxN5JpNdhdiBVQkXY3GfsNuzPhl93EOveXJ
	 0T1ezqNE9lxx+vHg7M436dDbIWnQj3q4Czo7KDfv91+XCkRN1h93Pk1Jyr1DqaEnArIiC
	 ON6JgdhCcms8rn8o73HluWILBFLaLSf5H7gu5QpKWceGKQXmDSTmaKmCBb0xFhy2g93uR
	 NnpaxdUlEtTU/Qs+uzdRpuM+EUCupfFsOxmFmOMXUEDiwAPiiGIWUtm78bDM6ejDm5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iPEYS9Wa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DDD606A329;
	Thu,  5 Nov 2026 00:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iPEYS9Wa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2471F000C1;
	Thu,  5 Nov 2026 00:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793836960;
	bh=I0dLEy0/RWH1lm8d6zJOmiHKcDSiY13O6lAZIBvefJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iPEYS9Wae8NoW+oX6Hkt3rDqmoP7Q+RYJgafe8t9g1bg7bX/lH9LlbruhkAVMD6EU
	 he03MHr98J3B96Z1F/5ezqmQDqLFg0JAl7n4F601WZaTiIYaxTydBaaegdUUQ1e2vK
	 Fhctx1r+c3QgGppAgn2Dyw8NpD9YoL9OsbEmQWttu63phMklwnnbXCr5Ddmo8DJ9yQ
	 pXpbBhg+OHJrTE7UyhGHrPp1mrAfwZ6z8X/ooOoJQY8FcqIjmUuO5Y05EuPw29x2Tf
	 fszcxTccXjCrdEr9g09MkKT9eBqxn2P+OD3DCmPaOv5HfeJbgDGz1DKp75EsaEeWx7
	 z38y5eSlK4Aug==
Date: Wed, 4 Nov 2026 16:02:38 -0800
From: Oliver Upton <oupton@kernel.org>
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	peter.maydell@linaro.org, lpieralisi@kernel.org,
	timothy.hayes@arm.com, fuad.tabba@linux.dev
Subject: Re: [PATCH v2 07/16] KVM: arm64: gic-v5: Add ITS guest table
 translation emulation
Message-ID: <auvHnnymzccd9OaF@kernel.org>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-8-sascha.bischoff@arm.com>
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
In-Reply-To: <20261102194454.4086911-8-sascha.bischoff@arm.com>

On Mon, Nov 02, 2026 at 07:44:45PM +0000, Sascha Bischoff wrote:
> +static int parse_linear_dt(struct kvm *kvm, gpa_t dt_base, u32 device_id,
> +			   gpa_t *itt_base, bool *two_level_itt,
> +			   unsigned int *event_id_bits, unsigned int *itt_l2sz)
> +{
> +	__le64 dt_l2_entry;
> +	gpa_t entry_addr;
> +	u64 val;
> +	int ret;
> +

<snip>

> +	entry_addr = dt_base + device_id * sizeof(__le64);
> +	ret = kvm_read_guest_lock(kvm, entry_addr, &dt_l2_entry,
> +				  sizeof(dt_l2_entry));
> +	if (ret) {
> +		kvm_debug("Failed to read guest memory for L2 DT\n");

99% chance of this being either the guest or userspace's fault. I don't
see any reason why we need to carry a pr_debug() here.

What would be nice is some preparatory return codes or helpers for
recording the SWERR that caused an ITS operation to fail so we can add
support for ITS_IDR0.SWE later on.

The GICv3 ITS made a half-attempt at doing this. Even though it never
conveyed that information to the guest, I think it was a net-win in
terms of readability.

> +		return ret;
> +	}
> +
> +	val = le64_to_cpu(dt_l2_entry);

</snip>

Feels like "read the Nth entry from this table out of guest memory"
should be done in a helper shared with the other callsites. On top of
that, arm64 is little-endian only as of 7.4.

While I'm not saying we should go tear out every instance of byteorder
twiddling, I think that shared helper would be an excellent spot to
either do the le_to_cpu() or document the fact that both the kernel and
the ITS are LE-only.

> +	if (!FIELD_GET(GICV5_DTL2E_VALID, val)) {
> +		kvm_debug("Guest DT entry is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	*itt_base = FIELD_GET(GICV5_DTL2E_ITT_ADDR_MASK, val) << 3;
> +	*two_level_itt = FIELD_GET(GICV5_DTL2E_ITT_STRUCTURE, val);
> +	*event_id_bits = FIELD_GET(GICV5_DTL2E_EVENT_ID_BITS, val);
> +	*itt_l2sz = FIELD_GET(GICV5_DTL2E_ITT_L2SZ, val);

Same sense brewing here about the parsing, with the added gripe that
multiple out pointers can be a bit annoying to cope with. I'd rather see
the literal DTE get passed around or we use a struct containing all the
extracted fields we care about.

> +static int parse_two_level_dt(struct kvm *kvm, gpa_t dt_base,
> +			      unsigned int dt_l2sz, u32 device_id,
> +			      gpa_t *itt_base, bool *two_level_itt,
> +			      unsigned int *event_id_bits,
> +			      unsigned int *itt_l2sz)

Any reason why this can't be anchored on a pointer to the ITS? Because
you're passing down a lot of state that's just per-ITS context.

> +	if (device_id >= 1UL << device_id_bits) {

BIT_ULL()?

> +static int parse_two_level_itt(struct kvm *kvm, u32 event_id, gpa_t itt_base,
> +			       unsigned int itt_l2sz, __le64 *itt_l2_entry)
> +{
> +	unsigned int itt_split_bits, l2_event_id_bits;
> +	gpa_t itt_l2_base, entry_addr;
> +	u32 l1_event_id, l2_event_id;
> +	__le64 itt_l1_entry;
> +	u64 val;
> +	int ret;
> +
> +	switch (itt_l2sz) {
> +	case 0:
> +		itt_split_bits = 9;
> +		break;
> +	case 1:
> +		itt_split_bits = 11;
> +		break;
> +	case 2:
> +		itt_split_bits = 13;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

this should be a shared helper

Thanks,
Oliver
