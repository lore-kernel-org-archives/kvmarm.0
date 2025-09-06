Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9B429E10F
	for <kvmarm@lists.linux.dev>; Sat,  6 Sep 2025 06:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757139105; cv=none; b=jnfYXMGZSmWCoPBPxpeqIBXZgRfzL/QLikUXe3dMfMTwssFZSL6gjfOmf3UnUxls0PuT0S144caGt39jHo3TIwKnq9HG0wC3ZUhI/fYVvxB82UPm4Bnd7zpKDaRLqYNtohW3GkUa/FvvJtaZo/4UGxxaGMKTIJ3rc0nDLcDxTTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757139105; c=relaxed/simple;
	bh=bPnYnR2mcyFn78cD8GtWdn8LHwcbeellYdgg3z0bdhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G3VTSF4nZ9EkVS4s/uFNAqN6wG+e8MpM754QdV8CEx8+KeG2hIVc+7JaeJTteaplAKYlLpyEctdWhK5yOfNoUlzVv7dzTrjS9pvOfrvUaZPQV3vLG1JuaFv2yMdniLCFGcu0hMHFMtL+yHKWNm7waKco/G7bLyIAUcOyRMgm/+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=riMGnvmx; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="riMGnvmx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757139100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G9KeGt4w9YWUgTmon2i67IUPUH8MfBLuR20DSwHGumU=;
	b=riMGnvmxL80w2CQHLS6rMiC8Zb4omF5eH3wPz4XmTmVCKkchbPjq2nrXEG+heXgr2PGGZV
	X4aVRc24EJJDg3tR6Wk2dphxvPnLShkSu88phJ7nHS/oSSH8qbxwKvxDHq02MzdR78Y9IA
	eDwF0RE+RZNDyWHx1MqIj5oAGB5F6A8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v2 0/6] KVM: arm64: vgic-v3: Fix yet another lock ordering turd
Date: Fri,  5 Sep 2025 23:11:28 -0700
Message-Id: <175713908287.1682559.5636169286146031124.b4-ty@linux.dev>
In-Reply-To: <20250905100531.282980-1-oliver.upton@linux.dev>
References: <20250905100531.282980-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 05 Sep 2025 03:05:25 -0700, Oliver Upton wrote:
> v1: https://lore.kernel.org/kvmarm/20250904062348.223976-1-oliver.upton@linux.dev/
> 
> v1 -> v2:
>  - Drop union misbehavior + misleading comment (Marc)
>  - Fix LPI check to include the first one (Ben)
>  - Clarify changelog to make lock relaxation slightly more obvious
> 
> [...]

Applied to fixes, thanks!

[1/6] KVM: arm64: vgic: Drop stale comment on IRQ active state
      https://git.kernel.org/kvmarm/kvmarm/c/982c6cee4c28
[2/6] KVM: arm64: vgic-v3: Use bare refcount for VGIC LPIs
      https://git.kernel.org/kvmarm/kvmarm/c/5cce5e814fa2
[3/6] KVM: arm64: Spin off release helper from vgic_put_irq()
      https://git.kernel.org/kvmarm/kvmarm/c/135f15386207
[4/6] KVM: arm64: vgic-v3: Erase LPIs from xarray outside of raw spinlocks
      https://git.kernel.org/kvmarm/kvmarm/c/0388323fb7cb
[5/6] KVM: arm64: vgic-v3: Don't require IRQs be disabled for LPI xarray lock
      https://git.kernel.org/kvmarm/kvmarm/c/032ea3e45463
[6/6] KVM: arm64: vgic-v3: Indicate vgic_put_irq() may take LPI xarray lock
      https://git.kernel.org/kvmarm/kvmarm/c/78921bec9d58

--
Best,
Oliver
