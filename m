Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51536400E17
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 18:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658249; cv=none; b=nELhgoVqsTXVMzKgr8+cQpRZkNRXDNRlTBKhdEs4tiwgkNu9r4ohJKiLcrZlctzYqcXeV3oT/dzx3Ko+T7RyxeyEkOkypfOXteRO0anHMwVioIFz3oHoU+eoSr/8b0LfDfgkLglkBeBoOVm36G2OGRZ+j7+eTK1sjSYDKwTD/Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658249; c=relaxed/simple;
	bh=xfTf0zGJKCI2+mijWRFjcWMSM51/OkEeZfadp5uGfNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YyAAQcxAtek7KOGObnSfLgK08DXWfQthYxd1iGNg/eQecStgZ2vpculMOPTZh/ISHwylzjEBBu94fduykeq3EMtgq5hr+EY91XdbSN1McIC4a72Tt/KDRVlskLJxCDaMF7+7zfXZZO4xYOvw9N+zwjMGJUxr1kLEaxHimfMPVg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TIxaR6Gj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TIxaR6Gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5AC1F000E9;
	Tue, 21 Jul 2026 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658248;
	bh=JYK1SVsB1MqYcJihkmBUZ/fXnWOSDpdPDihlH2cnXBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIxaR6GjtuMIXe+XSoWBc0o0bHsDMvHLj60PdpNjRrsphstpKb74XyvPmXW9pZUhd
	 gUn2X+V3o41322doBxgr8Iw3HXktD9pm1voBo16Jw2VDi8uXSD8cp4qwnmBWp6xvtn
	 Poxq+P/tQxTW+i9O5ekrvt2xx8IOosK4XCnqGEOyqn8aFkw8+bWdwbi4ZQvpUDY5U3
	 pFg6ekqQcD9WJlTGCriVG3FPHFYvMB7OODA+56UVxZ+r7JllCA8En2ycjMbCTCZlR6
	 4Pl14M1wxKU0SWU0nqJcTvGSbTQcYGu8JSeiiH9kv9iu/uub/EB5YwNl9f8+M3v/Oc
	 I2XYaJkbHUuOw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/6] KVM: arm64: Make ICH_VTR_EL2 accesses an inlined literal
Date: Tue, 21 Jul 2026 11:24:04 -0700
Message-ID: <178465820769.2066547.9255034363625874099.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721170754.3150521-1-maz@kernel.org>
References: <20260721170754.3150521-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 21 Jul 2026 18:07:48 +0100, Marc Zyngier wrote:
> I'm reposting this early as there were so many issues to the original
> posting that I decided to deviate from my own rules... Bite me.
> 
> This is the second version of this series I initially sent as [1],
> which aims at removing the large number of traps that ICH_VTR_EL2
> generates in NV environments, leading to pointless overheads.
> 
> [...]

Sashiko seems to have a done a good job reviewing v1. This looks to be in
decent shape now.

Applied to next, thanks!

[1/6] KVM: arm64: vgic-v3: Make vtr_to_* helpers use architectural field symbols
      https://git.kernel.org/kvmarm/kvmarm/c/719e67103c5e
[2/6] KVM: arm64: Move GICv3 broken SEIS implementation detection to a CPU errrata
      https://git.kernel.org/kvmarm/kvmarm/c/27a263e1a0fa
[3/6] KVM: arm64: Add a helper providing an inlined literal value for ICH_VTR_EL2
      https://git.kernel.org/kvmarm/kvmarm/c/4edfdc8ddebd
[4/6] KVM: arm64: Convert most ICH_VTR_EL2 accesses to inlined literal value
      https://git.kernel.org/kvmarm/kvmarm/c/2bba3d2c6092
[5/6] KVM: arm64: vgic-v3: Simplify initial GICv3 configuration sampling
      https://git.kernel.org/kvmarm/kvmarm/c/bea608299d28
[6/6] KVM: arm64: vgic-v3: Kill kvm_vgic_global_state.ich_vtr_el2
      https://git.kernel.org/kvmarm/kvmarm/c/36d32222fcab

--
Best,
Oliver
