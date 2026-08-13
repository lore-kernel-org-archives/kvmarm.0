Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19FD4252C9;
	Thu, 13 Aug 2026 06:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786603791; cv=none; b=Jp4To2/Ai0Z86HZjToUgKWWFgtWGYR4eQ17Tl9u3KIbqlJLfsF63Mw64RcaRwtaq0fUVEGNyEFARbBTDHJvNhlOu1Xom9fA3caXLaPdlKzVtNihBWuRTY7NxaA+PQKkVOmjaZFyvsf/6MszcIBf5vpVHqPMUKYTQkvLkkAAZslo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786603791; c=relaxed/simple;
	bh=Zd6SWQAH/MOWyrdcb+ari2RpCA0qefITmlsdkjtn5zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8+w1vJjkLo5jvziov14d494DgTbFhhGU2iQheXGxtpo9ex3DThNaSEEvMny6/lPujiOMhlgg0YI+BJWMS6dRt711Q+WKmm54YOZo33ktNo+63qpxejDPebShNyYxJq9w4a6s5GZl9g5pMn3l3v0PYRtkcsLw/oKm8NgYsaZmlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/vtw0oW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/vtw0oW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B399D1F00AC4;
	Thu, 13 Aug 2026 06:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786603789;
	bh=JBypZx28DGH1xHAdRgF/GPZt1kfDgjeZrLUDThEoBnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/vtw0oWy9/2x0AvPu5sBingZREkmoMrDXIxHyckkdhGlKIbCN0vtGsLCbO4jEiRO
	 GQfoMDm0UTAgTqN9HoG3Rd1vgY3jT6i0qQd7D3pwxrNqvAfxz2E2+dZx5tgqMAlJdp
	 Sek42X/EGho9OGfqL+r3g2CguGibQIA5ZCrBGHyxo4BFyKAidIFcm0uKDR/VxA3XDZ
	 QTtiFz0Jsq94+4oWA+oFVNHleQvoNOllqjTpyRlO7R2Mm2gmixF7CeK8ssytkrJxer
	 kZ3ed0+G6pwvLo2CPBPA8bt9q+ZDZWlOhZ4i0bvKEHqstvXt1EQ8X/jY59j6Wqf+bp
	 pt1eB/BjWnRtg==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Preserve GPRs for AArch32 CP64 reads generating an UNDEF
Date: Wed, 12 Aug 2026 23:49:44 -0700
Message-ID: <178660378174.666424.3801842450908120016.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802182222.2239-1-kmehltretter@gmail.com>
References: <20260802182222.2239-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 02 Aug 2026 20:22:22 +0200, Karl Mehltretter wrote:
> kvm_handle_cp_64() only seeds params.regval for writes. If a CP64 read is
> decoded but UNDEFs, emulate_cp() still returns handled and the caller
> writes params.regval back to Rt/Rt2.
> 
> This can happen for PMU counter read accesses generating an UNDEF. KVM
> injects the exception into the guest, so the MRRC GPRs must remain
> unchanged.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Preserve GPRs for AArch32 CP64 reads generating an UNDEF
      https://git.kernel.org/kvmarm/kvmarm/c/47746d4b7436

--
Best,
Oliver
