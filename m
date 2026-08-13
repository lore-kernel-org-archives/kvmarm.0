Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92144432E66
	for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 06:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786603792; cv=none; b=Ymvrv8HYpf1uG5cOk+NNfugw/6H8vinuktuwd+qXw9GpZvnzspycnOaF91FTNDGzW8ESycHTjALEd2Yh4mNSyrqZOv1VctGdRxBjhddaj79jDbgGMtYu3E7hezTeIizD/yIYuw9FYjCH/1T3Cw7QjmX+bB9/BszyBjdIzMxc8ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786603792; c=relaxed/simple;
	bh=+KYc6pZCaSe7/tLhJlWgpAqgNscG9iexxajCB+RPouE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuxba9PiX0f/S8Lt0i59hXtle2y+wzC399ofJJaeULDv/yaHUQf8Trvfwd7/rGF0g1Bbsnklu62HG6dCewSN5o3fEPqoAdPQbi6XJ4ARpkrRMY5DUE/lXgtqyvZoIvMpBo99foFRW8lnhjf6KSBBvV9tRcvaNx2SVAYMjpAamVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fh+xHKiJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fh+xHKiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463CE1F00A3D;
	Thu, 13 Aug 2026 06:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786603790;
	bh=esRaKPAk94c43Je7PkJfvEjqoEjhDmofNT29Loe5z14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fh+xHKiJ+qhl6KNCpr9Fxozjyvb/TsRlLgJ42ijX0PPy4dmnqy7DGhz3NvGNzJg19
	 3shrRKC49w1YaFq/fwN7JMrgfHE2cUILaaFgaQLdfgJH8Szlf2lKwjA1vvcnZfvPKU
	 qTUK4ey9Y/0kf8hk0ocyQtyMJksxtvkY5z2ofyG8Vu0U42XqnzthhJUKJ4aQqUYDfv
	 fbWtTNLJzWk2NVmHw2LrO/JPvXTDA+9fBMrJCHwIMSfLkPKFHig4WtfFAHMiD3QsQc
	 H3yJ97gYNLp1uUI3i0fur2VGEtGiXGAQHyMVorrJuA6nuI8l1CSiG6KSgbmu3FJcol
	 SzNeBG6NWrL6w==
From: Oliver Upton <oupton@kernel.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: Oliver Upton <oupton@kernel.org>,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	fuad.tabba@linux.dev,
	qperret@google.com
Subject: Re: [PATCH v2] KVM: arm64: Drop %pB on nVHE panic when stage-2 is active
Date: Wed, 12 Aug 2026 23:49:46 -0700
Message-ID: <178660378182.666424.15304247402418505023.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260803093906.3531699-1-vdonnefort@google.com>
References: <20260803093906.3531699-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 03 Aug 2026 10:39:06 +0100, Vincent Donnefort wrote:
> With pKVM, the host stage-2 is lazily mapped. kallsyms, accessed via
> the modifier %pB is therefore potentially unmapped. If the hyp panic
> occurred while the host stage-2 lock was held, handling this fault
> deadlocks.
> 
> Skip %pB formatting unless the host stage-2 is disabled.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Drop %pB on nVHE panic when stage-2 is active
      https://git.kernel.org/kvmarm/kvmarm/c/2ad524c5e257

--
Best,
Oliver
