Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711180;
	b=HzehEQQMh2tqVMKneRKHR47YcvGgE2a7ix7o/CfVmMFX/nFkuJzyoHnm7tUFPfp3osfX
	 1bebGy/NLHJEHce4Af2Rvk2YrYcC9OfYUPChGG5fknw3R7leObb8doXrF45BBddAAsOeR
	 ZPfc65NiQ7sUDCSM0W82cNyojwwG0lwuBOM0BzPIo8VB70zx8Hd0yyEpRdEz6kU/PzoTP
	 uwA6rrD+uXGjTGcr73YzisFH6vFm1rfPm/n9KuK7hUc1SzCF/2dru7+XghTEKLaf2Ucpp
	 4ehzOxKaaZBLXuEH12/uXFQso9d9OriHFuM6JVcUII1hZp+HnMr0omIMEETXxa5x9PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711180;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=hKXq0WGbyVJ4/tDG4Vk1teTQwOi0V+tMcOilLKOGtJQ=;
	b=Wxtr1mZQoRHfZRut+VtN0xiX7w03FuIadCLlCfVzNR94DUS6d0oD3cg+xOIusAMrvo9B
	 B0c8nMcrvyp58umtr0bxgg4FA7IkPLKUo75q1stLLIM2GtOiTaSSK9KQEwYqeyC3nqhLl
	 AWMP1nYGOkPlDrr29tjjRrJqrxpI2i202vE4O+Ti8bZ9sZ92F8b4WzGichSozM126fXgv
	 pUct/VcQKoUDG810mpy7cJWQahuhaJMuQhAFEeLd0H8IV3ULducCvpAz4e9Aq4l4TbgN4
	 6JZVs7/rTYX3fFm5nnON3+IC1lzdgeE9ZbjGdjur9p0cBgsg1qCVTOOzgII4sJrwZWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m7HD2XKi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BF3606D811;
	Tue,  3 Nov 2026 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m7HD2XKi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE561F00A1C;
	Tue,  3 Nov 2026 13:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711180;
	bh=hKXq0WGbyVJ4/tDG4Vk1teTQwOi0V+tMcOilLKOGtJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7HD2XKidnRAsWZ6QsB9Qe5Pzdj2ZaJ6LQDj0sXIOyufw+tRPxGkLo575tesGXNbn
	 EtTHZpd9E9zJvxm5HsKRJi18hN/taHyBHFete6Qv5a5vSPSknE1mM3ND5aelaYLk8k
	 g6XCQTwmBM0Bji2+PmZd5cpHZ8eLZL2TtPt5TN4ctnG4Uee2e8rGws4sqmF93vVtT1
	 H11kF8HDe3f/5ujuTxJK6tjIwW9+tc76/HWTdiysakmwUOyYqtbyP/yirGItlRQKan
	 IM5NFYapPKOrUc9uOKSkiYSp/xA1EadjEt55JxsuginwdP88tbPv865YsIbKryaD04
	 w3DGguffkvEAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDS-0000000ATWs-3C5P;
	Tue, 03 Nov 2026 13:06:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Ensure TLBs and I-cache are private to each vCPU in pKVM
Date: Tue,  3 Nov 2026 13:05:35 +0000
Message-ID: <179371111277.2844725.10385477365574044594.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261020074311.1873316-1-fuad.tabba@linux.dev>
References: <20261020074311.1873316-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, vdonnefort@google.com, qperret@google.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 20 Oct 2026 08:43:11 +0100, Fuad Tabba wrote:
> All vCPUs of a VM share its VMID, so KVM flushes a physical CPU's TLBs
> and I-cache for the VM whenever a different vCPU of that VM is loaded
> there. pKVM guests, protected or not, run on the hypervisor's stage-2
> and VMID, and the host doesn't flush for them. Nothing at EL2 flushes
> instead, so a vCPU can hit TLB and I-cache entries that another vCPU of
> the same VM left on that CPU.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Ensure TLBs and I-cache are private to each vCPU in pKVM
      commit: cadcd8d70f331044d12aa6a9644f8253cd2bf29a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


