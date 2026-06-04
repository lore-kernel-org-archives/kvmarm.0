Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57310326D4A;
	Thu,  4 Jun 2026 09:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780566599; cv=none; b=t7yNAqFuWRStIl03Su+oMyJ+tByBSqeOr+BOSzaGJVn0ewZUmzaTUYLqTXb4KuXB1GQ2p8LgVo261MzNzwdgu1bWMbJyDmhyjyMYXyUFeJzZagQx9+3HVA5C7I/9LKbK7Lbkt4Gcn0kYweKwm9TmWMcCSxC9Mh383Nk98e3oSBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780566599; c=relaxed/simple;
	bh=69DclAwuUnHWVkyy/U5ahKJbr5IsT7bTPMrznQrv5tA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PzMqJJTdunVtCR7v9UnWa/Yuye9rGrJkgCi7PgrEDr5xCAPeE4PQpDTLCb1mUOT3HKKf+B8sIo8kvpvXsRDdeE4jzXocRa4crEHHwTu18ZMeY3J6Jq7/ThhUFlcG+8Vas47U32g2c5y1oy1dNV1IuI2MkymJVR/BxPR2M5ughio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fY6EN1Yr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fY6EN1Yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ADD1F00893;
	Thu,  4 Jun 2026 09:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780566598;
	bh=69DclAwuUnHWVkyy/U5ahKJbr5IsT7bTPMrznQrv5tA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=fY6EN1Yrc0kbAdsyCX33DJn06AAVMu2OXaCG7SjcHDa7P+TA8G4glswpcNII2gYiD
	 6b3APQ3PPkm55+Lyq5NxuInWAWRY+G1dKOrUtU+QxhVEaKvSbAW3ZChJi4adOFRktQ
	 lz70Y43KrC0vh5NGMWiwh8M88IdqHW1EbGsCse3I7Q3sfOV43sqI25WUHzwHVGCR6j
	 cZdaATeoTEsjU5IWZzTa2DbV+TU/AkzFdx/Rsiy98fsCfyGid9OJGjUtD8b6DmTgt/
	 ASYX6cf8axzgrzGwra/K+U6gRYhPPF7xNMzSCeMXno6aO+oid8lxM56Z9uxfeVID+E
	 GLfSFdcjuCF5g==
From: Thomas Gleixner <tglx@kernel.org>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>, Marc Zyngier
 <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Jacob Keller <jacob.e.keller@intel.com>, David
 Woodhouse <dwmw@amazon.co.uk>, Vincent Donnefort <vdonnefort@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix order of arguments to
 ktime_get_snapshot_id()
In-Reply-To: <20260604092714.1537457-2-ukleinek@kernel.org>
References: <20260604092714.1537457-2-ukleinek@kernel.org>
Date: Thu, 04 Jun 2026 11:49:54 +0200
Message-ID: <87cxy663el.ffs@fw13>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 04 2026 at 11:27, Uwe Kleine-K=C3=B6nig wrote:
> The first argument to ktime_get_snapshot_id() is the clock ID and the
> second output parameter. Fix the caller that reversed the order and thus
> fix a compiler error.

I've already squashed a fix earlier today
