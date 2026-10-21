Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578936;
	b=X1HZoghxb1gSeVd8Yl785DDaoJJrbP/xjVwmSQ2Fclgv2urTF+rYiQ6qppcFMcwjvc7M
	 hZlK9LVWOAREOPR4tbFC7Ac2kR5c5q/AkpfiT6xS++QDiz7Pw7yAmB64WrICvE5iBo8qL
	 0O8MaXX1UCOWE7BzvFpcpxf5ih6tlEmoZjuRFTJeHG394rF1BAwbAnRp1gbDI6zWS0Sh2
	 bV2O+1Mp9Wsx10hO2X2YzPsECGVadwGsOp81p8PaqzjAb2bcFuUfKvxNk81m04IZiErHh
	 FNmGCkfnBqOq1yOhG79609pweTlfNQauh5B2YsVts2em1O+SziVTDwnMgLiFnQ1g32w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578936;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=hPLzdvCJGykwL2y3rICFM79srKCNKSx/p5qwSLEhJPE=;
	b=byF6YvMS7MYpvUIbhUB0jfonPhSkt6xqm7tjlZAlGZX4LVf1xdTYXTygtHTeGjBZE6Ou
	 tGZdPwnGup8xJF8yG2n0raIU7EhzHDkF7P5kvc7hfrxL74yHJbpo0pFhF6Eh51FTILi2K
	 hWwSNROtLMi4qqzFmJG68RVuj5fPakW7Iq0RnU/Fz1OD+AlN93YR7IngJ0CNfkQuR7QfG
	 tq/VduDO69lT9qEr6PXcGQFnEE2KWuodLeb/JXW3TsTDAuAbP2gOVWoTDmP3TPAWqYNQF
	 z1f+Jk78uuQeifDzUnO/i5nzW5qCCkfJ4IHU70sYj8zvLYbAk9/56EHQoJGBQEKMd7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bmO+naBc;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D79606A319
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 10:35:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79D79606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bmO+naBc
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 932852720;
	Wed, 21 Oct 2026 03:35:31 -0700 (PDT)
Received: from [10.0.152.204] (e121487-lin.cambridge.arm.com [10.0.152.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2BC9D3F7D8;
	Wed, 21 Oct 2026 03:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792578934; bh=vyNBvJ+nnDRHCk/KoMeZ8Wpl4kv4Vz/nK8psg4EsgBg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bmO+naBcBKw3zU725Z1Gucdtz2ZDwDtYZQU5hakq6JAP6iEPFM11mfHNrZIjlqnQ1
	 NxUwX1/D1+Mzr6Bf9TFAofwHnXGmZsyiG8kXXiHmowl7PxNv/6XkxXprtu8BwktIrD
	 qfOcDw24Z3L1R2Orye15l6EZUsied80vCKXM4OY4=
Message-ID: <8658049d-fdd3-49a5-9b8e-acf3c3467c1d@arm.com>
Date: Wed, 21 Oct 2026 11:35:31 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v3 00/21] arm64: Support GICv5-based guests
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sascha,

On 10/16/26 16:39, Sascha Bischoff wrote:
> This series adds support for GICv5-based VMs to kvmtool. These are
> exposed as --irqchip=gicv5 and --irqchip=gicv5-its, where the former
> only creates a vGICv5 device and the latter adds in a GICv5 ITS. The
> GICv5 specification can be found at [1].
> 
> The GICv5 support in KVM needed by --irqchip=gicv5 is expected to
> land in Linux v7.4. KVM support for GICv5 ITS has yet to be posted,
> but should follow shortly. Thus, --irqchip=gicv5 works with the
> corresponding KVM changes, while --irqchip=gicv5-its cannot yet be
> used with upstream KVM.
> 

I successfully booted a Linux guest on GICv5 FVP (with FEAT_GCIE_LEGACY)
using both --irqchip=gicv5 and --irqchip=gicv3. I also used this series
to boot a Linux guest on GICv3 FVP with kvmtool's automatic irqchip selection.
Everything worked fine.

FWIW, feel free to add

Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>

for non-ITS parts.

Since --irqchip=gicv5 already provides a usable Linux guest and is
aligned with upstream vGICv5 support, it would be nice to get these
parts merged sooner (which would also reduce the series to just ITS
support). So I'll do my best to review non-ITS bits.

Cheers
Vladimir

