Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA5E79D2
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753722978; cv=none; b=vCjSrEL7qQRQ6PlU3+LLRc+d9XVBi8rgeMY/GhJvRaLQbEOqU4MFoDFtsrX5xcW2FBPoAVHHaL+ubQtOdrAe7n3dSGf8Xo9R4Dh8/0qzhj6qRCW6vnqd87w+9n8vhr0LTPiEq2Yld3KJxye5PdCfEUICAnBFDwfkNriZKygQJ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753722978; c=relaxed/simple;
	bh=hq9G439HBT2woUN2wx2peNjXcsT598Lz4KLjZkqLCYo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pFVLLgUQwavXQQviaKJ2Qk+pdfP9H+2j+ChmXfIicWgdubwjk0pzVwJzDTE1O/J7j4pj4lzH2jQ9MkbUBArGJU6mVt8zPiczG8dbosZxWUfShk+J3Z8EY+4/LZwD/ge+QNzp2j7zFwlxfoVLU8Alr9WkQa1AgEuauvEfLZvAZ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h5llobWT; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h5llobWT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753722974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bNIyxQnq4qOIP+xnPLHAwxkA0IPHV/f4fUHTAmQLjuw=;
	b=h5llobWTLuMaFo5A3Cq7Tjd1EiNa2zYRY3PDfKichyGAgZVwEpoCgvQi0UdUKJdqaHnoNr
	cG92D+zy7qSmlPnRg2yG6tXu/EFQPKsonVfzgTo8A4vpM6YH991dsU/ADVz40wE5DtTVfP
	I4QIBRBgnd4wXaQbhhOh+gYkzOPKOCs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 0/4] KVM: arm64: Userspace GICv3 sysreg access fixes and testing
Date: Mon, 28 Jul 2025 10:15:49 -0700
Message-Id: <175372292706.2891555.8608447828922447726.b4-ty@linux.dev>
In-Reply-To: <20250718111154.104029-1-maz@kernel.org>
References: <20250718111154.104029-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 18 Jul 2025 12:11:50 +0100, Marc Zyngier wrote:
> As a follow-up to my earlier series at [1], here's a small set of
> fixes to address an annoying bug that made ICH_HCR_EL2 unreachable
> from userspace -- not something you'd expect.
> 
> So the first patch fixes the ordering the the sysreg table, which had
> ICH_HCR_EL2 at the wrong spot. The next two ensure that we now check
> for the table to be sorted (just like all the other tables). Finally,
> the last patch augments the vgic_init selftest to actually check that
> we can access these registers
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: vgic-v3: Fix ordering of ICH_HCR_EL2
      https://git.kernel.org/kvmarm/kvmarm/c/0f3046c8f68c
[2/4] KVM: arm64: Clarify the check for reset callback in check_sysreg_table()
      https://git.kernel.org/kvmarm/kvmarm/c/f5e6ebf285e1
[3/4] KVM: arm64: Enforce the sorting of the GICv3 system register table
      https://git.kernel.org/kvmarm/kvmarm/c/8af3e8ab09d0
[4/4] KVM: arm64: selftest: vgic-v3: Add basic GICv3 sysreg userspace access test
      https://git.kernel.org/kvmarm/kvmarm/c/3435bd79ec13

--
Best,
Oliver
