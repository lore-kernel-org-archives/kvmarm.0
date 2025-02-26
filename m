Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05CB224259
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 09:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740563409; cv=none; b=nNuEfppYgQMhSVTgqmxwrgfNDzYLgR0N6Ma9J3uWh7XiQHzrCP4xQHF/KGsxGmRGZVNqhWdi9n8d+nnKkscP1I8I4JxYzP7xaVvhpo5kkQW92RP3LbAzPjtlkq/umFoL32wcckPlAZTK/WyAjpDEsYJmjS0sd7VJ7nYVocaX/Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740563409; c=relaxed/simple;
	bh=HOlBzzgAC8SCOj9iZmj8DVZhEU7yOYPhqbzQ57wfzSM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SEO0C7VREWHkIulIvPPZAlel7SsdwClJh8ocWrSco3FYB/fbYJqxYEjLiDupVgc0mdlECpY/iQtEEw9JUwtrfGMQSktwEcfF2oY7rUsD9eSDn9JkdG0n/5/435MKsW/02LSTN1pFcVGiAVldAPiRvEe50bcAzx1+VFsDMx5xA24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NeZX6SQv; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NeZX6SQv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740563403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYcKG88NH3co17JZcGZZCwOa9Qc1Jm4azuToR+aerrM=;
	b=NeZX6SQv3mV71gKbtjrREpTwWiJJdoeFtWaVGLVhpgmACp89aLQXzspAYVWY5MQ19Wgcyc
	OlXLCBQ+eMQ1AZyzYVRONY5i2Oif1uX/b62FTVXcpezmN97hidk5QvyrwAWuMMgTL66c5T
	qjzsLA+oapFkupSmrHLB/7nVof59GCo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>
Subject: Re: [PATCH v4 0/5] KVM: arm64: Writable MIDR/REVIDR (and associated baggage)
Date: Wed, 26 Feb 2025 01:49:48 -0800
Message-Id: <174056338052.42775.14004307865705327310.b4-ty@linux.dev>
In-Reply-To: <20250225005401.679536-1-oliver.upton@linux.dev>
References: <20250225005401.679536-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 24 Feb 2025 16:53:56 -0800, Oliver Upton wrote:
> This is hopefully the last take on the writable MIDR/REVIDR/AIDR series.
> 
> I've restructured things in order to work around the existing
> shortcomings, have a stable-worthy backport for SMIDR_EL1, and avoid
> breaking ABI.
> 
> I personally hate using a capability for this, but given the subtlety of
> the issue (and our habit of breaking save/restore) it is probably best
> to put userspace in the driver's seat.
> 
> [...]

Applied to next, thanks!

[1/5] KVM: arm64: Set HCR_EL2.TID1 unconditionally
      https://git.kernel.org/kvmarm/kvmarm/c/4cd48565b0e5
[2/5] KVM: arm64: Maintain per-VM copy of implementation ID regs
      https://git.kernel.org/kvmarm/kvmarm/c/b4043e7cb78b
[3/5] KVM: arm64: Load VPIDR_EL2 with the VM's MIDR_EL1 value
      https://git.kernel.org/kvmarm/kvmarm/c/d0d81e03e629
[4/5] KVM: arm64: Allow userspace to change the implementation ID registers
      https://git.kernel.org/kvmarm/kvmarm/c/3adaee783061
[5/5] KVM: selftests: arm64: Test writes to MIDR,REVIDR,AIDR
      https://git.kernel.org/kvmarm/kvmarm/c/a88c7c224479

--
Best,
Oliver
