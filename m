Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EB71E25F2
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754675520; cv=none; b=qvdDjP77A0Vr9WMGtmlwdS5nYXMKJnEsmFyrl+nfGTsM9TwBMGbn431yChlnzt8GcELYFOV9ZYLUWq2rtzFdvYejZ7+asnX2eD926MbtU9bXQHFjTndMY3Jjncpbzm73B8dzgNHWKajmAF4K7DiKuC9TKhg3RfYUB7KTZ8MnVOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754675520; c=relaxed/simple;
	bh=QDGko5nYhKnn2xNkODAF9cE4T4WEgyN5T4vQMUmUSHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKdyftYcp/VeZKJbkBKZVxbx0pmc9jgs0ol3SDZro5Y4Ooqq1+6qyaliNzY7jJH/P7KWZEF1f+VROq7+87CiVe/6ZeAsl1dgZTdd6vwYKln8j/v17mYkHeKkJL0yolpu40ZPKdR36V/aDv6pzNPZOMsmURedVRRG9qaOGQ/ylto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bUSLKcic; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bUSLKcic"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754675517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5NeXhnCQ5k2v1rTlA/z371RaWXWMj3pxQmPy5iyvxcA=;
	b=bUSLKciceLWZmmbsf3vbMpMqCJVmiioDduUdtcUbf6fTOChyPK5a9Xi2wGWqB2UAHHZSYh
	dpmKK1u9qBVN6KW+an/T5XbeSiRwD5WyK3F4XK7vY6oWBnk+XK8B9OkyMX89sC5TchYdds
	Vyj6hj35kOSDnoAgngjlOI8SEM09+7Y=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH] KVM: arm64: nv: Handle SEAs due to VNCR redirection
Date: Fri,  8 Aug 2025 10:51:35 -0700
Message-Id: <175467548053.670500.9982824307871252254.b4-ty@linux.dev>
In-Reply-To: <20250729182342.3281742-1-oliver.upton@linux.dev>
References: <20250729182342.3281742-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 29 Jul 2025 11:23:42 -0700, Oliver Upton wrote:
> System register accesses redirected to the VNCR page can also generate
> external aborts just like any other form of memory access. Route to
> kvm_handle_guest_sea() for potential APEI handling, falling back to a
> vSError if the kernel didn't handle the abort.
> 
> Take the opportunity to throw out the useless kvm_ras.h which provided a
> helper with a single callsite...
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nv: Handle SEAs due to VNCR redirection
      https://git.kernel.org/kvmarm/kvmarm/c/69f8fe955d0b

--
Best,
Oliver
