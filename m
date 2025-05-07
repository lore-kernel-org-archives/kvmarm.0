Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DA71DF25C
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 07:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746604631; cv=none; b=a2FE14lW0MzH+byvFAnZvcSjKbvL3+HK8tjLpGXzj1H891I7qmf1yvA7y2gWipUFfB0YtALyDAgTBiO7mQptuAwFOvU3yKe3npAmsC4bJW/P5Izcmu5TZ81UaV4oYFLC1pAu101KyoCAoAMmF3x8Yz/PhPtukQmUnavViA3Q0j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746604631; c=relaxed/simple;
	bh=uuJWPfHJXcnB4dBIwpisrMyjhNK9JSAOkWSSPue3dkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HoJ4YMXvqDHdbsXjnWyg/WWjv+kdR9kFeHy/oO38lTLi6zrhyMOb4N/VbZnFmKaOBVGgXUeDGmnlQptyttHa+xcXIy6n7MXfvyer18S9YJIPM0YmeTA75W7wOwdDXaa41+g0jgqPUsD04htSMI9EOxO94MapsADv/1aCll+Wi48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=krCymqbL; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="krCymqbL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746604626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nHAbVa6E1A/wHvD5/4+iVSocKc6b/G3IZErcqqcFL0s=;
	b=krCymqbLFkpq88vV/Mhy4It39SJqdhzNcJtBDki6dLsYGxo/0LkfTarWJ4hw2m9MsghJ/K
	dUDJZJvsi5y+TSOOUJd78Eap71hGr0jO49hbYlhznHBcDrCkTufg5nfuPxwd6IIuomgo+X
	NfzwyoYrIAvLzcA73mtDg0KTiSdOQAI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Make AArch64 support sticky
Date: Wed,  7 May 2025 00:56:49 -0700
Message-Id: <174660459090.2542293.281555922316726481.b4-ty@linux.dev>
In-Reply-To: <20250429114117.3618800-1-maz@kernel.org>
References: <20250429114117.3618800-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 29 Apr 2025 12:41:15 +0100, Marc Zyngier wrote:
> It's been recently reported[1] that our sorry excuse for a test suite
> is writing a bunch of zeroes to ID_AA64PFR0_EL1.EL{0,1,2,3},
> effectively removing the advertised support for AArch64 to the guest.
> 
> This leads to an interesting interaction with the NV code which reacts
> in a slightly overzealous way and inject an UNDEF at the earliest
> opportunity.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Prevent userspace from disabling AArch64 support at any virtualisable EL
      https://git.kernel.org/kvmarm/kvmarm/c/7af7cfbe78e2
[2/2] KVM: arm64: selftest: Don't try to disable AArch64 support
      https://git.kernel.org/kvmarm/kvmarm/c/b60e285b6acd

--
Best,
Oliver
