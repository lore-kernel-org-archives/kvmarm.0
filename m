Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B35422E3F;
	Wed,  7 Oct 2026 10:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791370460; cv=none; b=VZFXpxYjXSiKoMi8KegcoL9ao+3VFXZrVMTlBrZIyC/udSeVR6xIx5XbrAXjYgyKgmzp5y6sxw+0cRSAkuwb9q8DxzYisB4qwdDpaNbeO9596ig5nj53ZREGdmkhcL/eHZ8qjRB81wfV47QB1r/7RzCpt9xlu7Q6lAOlkx5senE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791370460; c=relaxed/simple;
	bh=00v227q9t89fagNZ3tVtT+t9gL52AQ9XUBQNxCLtrPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CsJTNeiEeOuDsVqpW5AsPihG5Fo9VM6nRKOw8z614Yt2MH7fOTFJBzAVZojQoT6aUtr+zmyVw4gNevV7HPdQt2g3ltiz1Z5b1R/wNRiiGIU5Ddsn4byTj+AdfxSsMQ6XrsXYXrc8ZD1Rd/vPuI2Ca4qxD/mctb+ucqXKRSTWL9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuJJKRLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuJJKRLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60BD1F0089D;
	Wed,  7 Oct 2026 10:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791370432;
	bh=VzPwMVRHnsua+MMPFAPSMptThMMCWGE2wdCA+XcJT2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuJJKRLM7po6vyyXkFG7qLIRflQp3azbcSUtERQiwtLbFsRj6KYzl35/iV8F7CrHg
	 S4T0tQyoWiYLlZkeRUMyNC8eUoKxyXFzXs67f77Ahpg9ByYyY79rT/7xEdNXZvgdnc
	 I7kJmEv0uUW4NetvZ9h1PJG2rDZvjwKkw8W7VcwQMb8aIaOzHX76h1Z/Uu6JQjjI8g
	 8gqmiG5i5MRVm75Ct6YlAlOe56TagG7QAGX2m2mIF2bR8eglwATAR/O0tZfLdUhqKJ
	 oF6wSCGhQJz4K0+YpLvu5Ii8yGtMR/aUUdYwS9mgywgBULkFl0I88rP7zATDcIZye6
	 tKRI2+unduEMQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xEPHS-00000000Edx-3Cur;
	Wed, 07 Oct 2026 10:53:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: arm64: timers: Program CVAL from the current count when the hardware won't apply the offset
Date: Wed,  7 Oct 2026 11:53:47 +0100
Message-ID: <179137042025.697424.15256970902221447316.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007074343.324269-1-fuad.tabba@linux.dev>
References: <20261007074343.324269-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, zenghui.yu@linux.dev, gankulkarni@os.amperecomputing.com, will@kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 07 Oct 2026 08:43:40 +0100, Fuad Tabba wrote:
> Changes since v1 [1]:
>   - Patch 3 programs the new case's CVAL as an absolute value near the
>     wrap instead of a negative TVAL, so a host stall between the
>     counter and timer writes can't make it fire. (Sashiko)
> 
> A guest timer can fail to fire, or fire early, once the guest's counter
> is far enough from the host's. Where the hardware won't apply the
> offset itself (the physical timer without CNTPOFF_EL2, a CNTPOFF_EL2
> host while TGE is set, the virtual timer on x1e), KVM adds it to CVAL
> and lets the hardware compare the sum against the raw counter. The
> timer condition is an unsigned compare, and adding the offset to both
> sides of it preserves it only while both sums wrap or neither does: a
> guest whose counter is ahead of the host's by more than CVAL has an
> expired timer that never fires, and one behind it can have a far-future
> timer fire at once.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: timers: Compute an offset-applied CVAL from the current count
      commit: 49930b1b557ceb698e0ab7f985ea41c99dc8bf22
[2/3] KVM: arm64: nv: Read a guest hypervisor's CNTV_CVAL_EL0 from memory on x1e
      commit: 1dbb5a2b5a21a62a223a2a2a0d775d417dca4242
[3/3] KVM: arm64: selftests: Test a timer set past the counter's wrap
      commit: 46e0f2c9d7d6f99a8f16290d4d4e2f3129edfa54

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


