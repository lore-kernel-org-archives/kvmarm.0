Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526301DF27C
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 09:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734427165; cv=none; b=ZffB16f7SvzneFNl0guhk1emb2daGEHXE1H/GEy4ocb9RUCvJyT0zaNoY/JzukN2E6kgjnkqy/5a5jFehBrCly/cLStStKmBqesZp3FzOOIZbonFeS0fEVSzSb9MbmpW3WC96JVVuNqhwyYnA2KSSi2SemFhj4Nu6HrpZKxbfUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734427165; c=relaxed/simple;
	bh=DC965Tfa4EF7QPuS6rd27SkC6ALTk0aHBhziZdPRNNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LNZpH0vnvdjw9nl4GHi9kwxCcp1Nln47caZXcgdYj54l0fHL9QV2NOuDQ5N1L2Yde/IJF0jLMW42GP8PoIR2EQiwnHYi2344Vp8wq0yNCtG4q2nb9Xbg3134w3LpVQaw7MBAzgu70tDkazmhu6x1nlUXxDK9RhiqU3lyFrLtOlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WHpy04qa; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WHpy04qa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734427161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jZKUG8/7+vJ4CurxMusMNyHDShZvXwj62eE8NC9Ca7Q=;
	b=WHpy04qaYGREjmB9I2/bNT8q0m7Itc52aKyA9xJajoh+1emO/0eQkVG6ByQGwbulu5cX95
	DT4W/0kqJw0uaQLyYojOEXXIluGm1OcG12N90rW77922WcYJ2cwf+/t67g4GhM0+N+BsBl
	1zlMqLY42kC+0W/KVjLCPuXFNif6dKA=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix set_id_regs selftest for ASIDBITS becoming unwritable
Date: Tue, 17 Dec 2024 01:19:08 -0800
Message-Id: <173442713502.3654654.5293442477717772457.b4-ty@linux.dev>
In-Reply-To: <20241216-kvm-arm64-fix-set-id-asidbits-v1-1-8b105b888fc3@kernel.org>
References: <20241216-kvm-arm64-fix-set-id-asidbits-v1-1-8b105b888fc3@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 16 Dec 2024 19:28:24 +0000, Mark Brown wrote:
> In commit 03c7527e97f7 ("KVM: arm64: Do not allow ID_AA64MMFR0_EL1.ASIDbits
> to be overridden") we made that bitfield in the ID registers unwritable
> however the change neglected to make the corresponding update to set_id_regs
> resulting in it failing:
> 
> # ok 56 ID_AA64MMFR0_EL1_BIGEND
> # ==== Test Assertion Failure ====
> #   aarch64/set_id_regs.c:434: masks[idx] & ftr_bits[j].mask == ftr_bits[j].mask
> #   pid=5566 tid=5566 errno=22 - Invalid argument
> #      1	0x00000000004034a7: test_vm_ftr_id_regs at set_id_regs.c:434
> #      2	0x0000000000401b53: main at set_id_regs.c:684
> #      3	0x0000ffff8e6b7543: ?? ??:0
> #      4	0x0000ffff8e6b7617: ?? ??:0
> #      5	0x0000000000401e6f: _start at ??:?
> #   0 != 0xf0 (masks[idx] & ftr_bits[j].mask != ftr_bits[j].mask)
> not ok 8 selftests: kvm: set_id_regs # exit=254
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix set_id_regs selftest for ASIDBITS becoming unwritable
      https://git.kernel.org/kvmarm/kvmarm/c/212fbabe1dfe

--
Best,
Oliver
