Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793145199;
	b=OuNS/bGAKJSoMrzUx3pDvWG796/9TYoY+AVAnp7dVkyzDo8acxms3tin/KTxq9K9003W
	 ZEAR5VvkGr2ulfWNDIy8dJUi2ZqFdjX9gBVz2h4IHViWAuPQv4U5a208OG/utz7YeXcFY
	 ruHPwXiYDAJ1uGodYkR3q6EIDJycEMHuIAs2QypOpBtzc1sMoLfhFwN6k6Z0QgwQAFM4H
	 ToGH7Fptgz2euTSD8bH226uhv6xmZ7i9nzBLTZwphTYox8SiphSHOrmUXT/wq8XCA2pUj
	 MNhOKF+HSrzymbZuVQhBGdrkpCnlCoejsCwaV2rFIuumFfVTwv7yl6IT2LgsQSoFyEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793145199;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=iuQfgeNxA6wGpTGomQMxImyXHDaKIESamcJco6bW6WQ=;
	b=p+Ju7GOKyss4X3gynMx/MHR/ym865S5m6LyD5A4wgcSrVDFuK/8XbLYYrRQasRh/3b4+
	 iSTQWaHFJZ2VfTLGG//bQtqf/LHwoOpxosIvTnD/HBFB1qEvvikYfxyJoRO0bDY4R2BHG
	 EXgzbLSPS38b5UxPTTwpbi7iCRvxxfDBe7TDNJR2ZeqdkMPmERXP3LDU0TZD5mZO9ijSi
	 vRDo41bF5sSpwAT4kZ6xAW+lYJKUIH9YsFFzaUht0SQsHni3l1Jz8dYW2+7khsk9svbTv
	 5wTxHrGvNQ90yJjjh/tZ8RtmoSJwOC1glc9ztPfYGkpYeGhIyTU6BJJOIiTsJtYXGtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ksBxNZON;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6091A606A31A;
	Tue, 27 Oct 2026 23:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ksBxNZON
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F7A1F01825;
	Tue, 27 Oct 2026 23:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793145198;
	bh=iuQfgeNxA6wGpTGomQMxImyXHDaKIESamcJco6bW6WQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ksBxNZONPb8UCXkhTBve3goFXZZQLNXqWYD1psAQqmQ3PV384sVnXrWRRZtDEQirR
	 KoYFh1V1XqfzzHUyFKBpYgXrgq7+gneJRolr49gTjumAnLJ75m9M4q3zSMoDVWWq36
	 6sjR3kzQWhZTBeU8/mx+8BUMTK8Tca1N5+PrlgL4KCKf25Z/Kmmw6BEdZy0A/gCG1Y
	 qk0Rizpie+M/WaCYxcVrjY5to3BMnQCN8GL2VCKQTDq9I0WG8Z82PzWUDjRMLQu09v
	 95QGDJgRDeR9ueS0uM9hU68vTH7tYwA9gmiAQ3aWNE+Pnds1AHMTTL17VP50qDuNdw
	 tDVMS4Sh/NGUA==
Date: Tue, 27 Oct 2026 16:53:17 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Yuchao Zhang <ndaugoing@gmail.com>, Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: vgic: LPI fixes for redistributors with
 LPIs disabled
Message-ID: <auE5bc4NJTZO-C1o@kernel.org>
References: <20261026092802.2636798-1-fuad.tabba@linux.dev>
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
In-Reply-To: <20261026092802.2636798-1-fuad.tabba@linux.dev>

On Mon, Oct 26, 2026 at 09:28:00AM +0000, Fuad Tabba wrote:
> Hi folks,
> 
> Two fixes on top of Marc's cross-CPU vcpu pausing series [1], for LPIs
> whose redistributor has LPIs disabled. Without them, the guest can take
> such an LPI with EnableLPIs clear, or lose one mapped before it enables
> them.
> 
> The first is the vgic_target_oracle() change Oliver suggested on v2 of
> that series [2]. It stops an LPI from being queued to a redistributor
> with EnableLPIs clear once the disable path has retired the vCPU's AP
> list. With that check, the path has to pause the vCPU before clearing
> EnableLPIs, so that the retire still finds its LPIs.
> 
> With the second, an LPI mapped while its redistributor has LPIs
> disabled keeps its pending bit when they're enabled. The second relies
> on the first to keep such an LPI off the AP list until the enable.
> 
> Reproducers for the INVALL case in the first and the map in the second
> fail in every run without the patch and pass with it.
> 
> Based on kvm-arm64/cross-vcpu-sync as merged in kvmarm/fixes, which the
> first builds on (e99ff76f4a02b; also applies to kvmarm/fixes
> 309e1d2215255).
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20261015100539.1011760-1-maz@kernel.org/
> [2] https://lore.kernel.org/all/asf87i2RDh-WksL-@kernel.org/
> 
> Fuad Tabba (2):
>   KVM: arm64: vgic: Don't forward LPIs to a redistributor with LPIs
>     disabled
>   KVM: arm64: vgic-v3: Don't drop a pending LPI mapped with LPIs
>     disabled

Reviewed-by: Oliver Upton <oupton@kernel.org>

>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 31 ++++++++++++++++--------------
>  arch/arm64/kvm/vgic/vgic-v3.c      |  3 ++-
>  arch/arm64/kvm/vgic/vgic.c         | 12 ++++++++----
>  3 files changed, 27 insertions(+), 19 deletions(-)
> 
> 
> base-commit: e99ff76f4a02be8542e2c3ecc8843d7339a0200d
> -- 
> 2.47.3
> 
> 
