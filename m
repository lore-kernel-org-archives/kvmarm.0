Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88DB2222D8
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752080404; cv=none; b=YtMtzoP9Ci/s1z4dCi6Q36+SeZDcVWQG1n0c4HTvwHoOdeLsDXjtXwyj5GXO6ibtTK8sEmCvsmMenc26CtLnf1A4jIC3/Fe5sYph7MYhAo4Y6Mvh1TSmKCuQl9SUphzxAyFCo1iSqXdawlA6Pweu3RQXUm6whBfmfjiK1xjaAVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752080404; c=relaxed/simple;
	bh=HOY3HcQ5UzGLIpHrtPD8XDjz/4EnKPYbXfzUxGXP80s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pkJfwPKyqPTfE8RuGYz+SiBPwGennCZLiLLHjoS8DW30UsvM52vGcK4Xjq7cNcKumk1WuwihODpN7WsKKg6rL26XZZZVvFRl/O8g/ZzZA1eW7dBf4jYN6tyedG0J9+xoCn7zoxN9RDehTa0iBNUwjOixAgS2n00Q64iMREHxSjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e+0h5sei; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e+0h5sei"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752080400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8M4dKwDdzBuhtVknYmpv+3WVQecIkQU3ZravJIyzeHQ=;
	b=e+0h5seisTbLbUhE1ZcEn57OjAcoe32AqMwJwp8WZCaHOm2jvgrOOhH24kx6sK90NN9QIb
	pBd9LM9weyiuIIJCGH5hbRZ8zkIKrOoLfjN1ZoRMPD7kv0hQGcaBTiv+xDFudYTAlGYhTc
	JX4e9KmdiZ5snNPEwkQpN2bbtYnBmqg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix + test for SError ESR
Date: Wed,  9 Jul 2025 09:59:51 -0700
Message-Id: <175208038505.2014187.17969325052997297935.b4-ty@linux.dev>
In-Reply-To: <20250708230632.1954240-1-oliver.upton@linux.dev>
References: <20250708230632.1954240-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 08 Jul 2025 16:06:30 -0700, Oliver Upton wrote:
> VSESR_EL2 only provides an ESR_EL1.ISS value for the SError, not a
> complete ESR. Namely, hardware sets the EC field to indicate an SError
> (0x2F), meaning we need to do the same for our software-emulated SError
> injection.
> 
> Note that this behavior already exists for nested SError injection in
> kvm_inject_nested_serror(). I also extended the external_aborts test to
> assert the guest sees an expected ESR value for an SError.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Populate ESR_ELx.EC for emulated SError injection
      https://git.kernel.org/kvmarm/kvmarm/c/f6e2262dfa1a
[2/2] KVM: arm64: selftests: Test ESR propagation for vSError injection
      https://git.kernel.org/kvmarm/kvmarm/c/f9e4e0a663d2

--
Best,
Oliver
