Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAE127453
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 01:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741222958; cv=none; b=WN+rHHBqZM03mpcF/oVzTth18YZVaV8E9Mlt3cKlYJ8NTr49K2FVjjkuixBlbAFVI5oB+ayWKwtgazXH9krtN2KtsP0/9RwcdZcGQddhJs/wcm1sgObwW6zyEKC0rY9IuFDBM/e31OaepCFwcGwVqdXf1wogoeWS5d5VXEjM2wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741222958; c=relaxed/simple;
	bh=Y3LnAXHwhZf9iOzeMs9JBoAHp30Z648Y/vhMDYLhRN8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xrt/WV9+TTiBla6BZnBEquG31lpEJbr8HtYb1EJSgKG9gTrNjJ+k9onea2udaXdpGXLEoqQB+KxbgdBgmK3g3zAi2F7sSWHawHs6UfeEOtrCQguEAQ7L719th22pE1f1Q+ucQIw0ySuAzHpDxKeRH735BbzvFxaDxL5wPDNMDgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XOr3KYXK; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XOr3KYXK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741222953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWvyRPogRVV4AYx0hiQKyZCaPwulhtcJyu3VIouGbjk=;
	b=XOr3KYXK7KoKrtMYmtgXN5nZV5/kP4o+bbxNg4svTiTvIR74hYBzlkT+toAw+ZelSxZ9Am
	+I2Bowydededz0LaJ7WGSzvhH+Wn/rY9FG2t59vYpDbIB4/6dMCxYgrlJYvMm2CqXa8vSX
	/TaC8k1BXwQHL6KaRMc5f5hC0mpk9kE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Fixes for 'writable' ID registers in protected mode
Date: Wed,  5 Mar 2025 17:01:17 -0800
Message-Id: <174122286930.541349.11080398949044246352.b4-ty@linux.dev>
In-Reply-To: <20250305230825.484091-1-oliver.upton@linux.dev>
References: <20250305230825.484091-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 05 Mar 2025 15:08:22 -0800, Oliver Upton wrote:
> Address a few issues with ID register handling in protected mode:
> 
>  - CTR_EL0 isn't trapped on FEAT_EVT systems if userspace changed the
>    guest value
> 
>  - VPIDR_EL2 is set to 0 if userspace enabled writable 'implementation
>    ID' registers
> 
> [...]

Marc, I fixed it in post :)

Applied to next, thanks!

[1/3] KVM: arm64: Copy guest CTR_EL0 into hyp VM
      https://git.kernel.org/kvmarm/kvmarm/c/9d9122736433
[2/3] KVM: arm64: Copy MIDR_EL1 into hyp VM when it is writable
      https://git.kernel.org/kvmarm/kvmarm/c/03e1b89d051f
[3/3] KVM: arm64: Fix documentation for KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
      https://git.kernel.org/kvmarm/kvmarm/c/5980a6937012

--
Best,
Oliver
