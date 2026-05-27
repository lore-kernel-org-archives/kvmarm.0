Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692593EF0D3;
	Wed, 27 May 2026 10:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779878128; cv=none; b=HgA/bJ7zahLNQejBbEemM0P09fT7Tyimj0QpVZKBNe8z9OD876IDoAYoLca370sxrz3yEcEYyu5SYnJzodX9MTNlvIAigLBFs3JrLI9LP9h93UE1mGJi4sqjPCyZgJokdTzL5IJE4GQR2BdoRPApn+WaCN3CRTpYLjZfLIYM6R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779878128; c=relaxed/simple;
	bh=8ctdxqLURgSQEye8h+eKl6nW7zwYHgLZYy4ZdlFLMck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5jTeHxtv92qVJXOA/hIm/nNxRRzZp+Gyweg61hlrE9769T3IbU+xTeAnNxO3r3UIxLQKmPyrjwsj/IfOO4st0uT8coDpc9ZsTofxGcBu1iJR27UpkZkdbpOK0DdnLJIu3+O2DoovsCFeQ3kfmuPxtVW1YNDHYhF5e9TdyqPa0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hd2/OuW9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hd2/OuW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5041F000E9;
	Wed, 27 May 2026 10:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779878127;
	bh=wzP5QfQoOdOy0iLjAEoGKBb41erJPo8UxyCpX8lnfeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hd2/OuW9FWHDNLb0kiG5rFfN+zTD3JwtnJ5VVQbUAy5qSRQVVhxigTPlKav8yDIhw
	 EhbsPjaJYdlTsbJsNQ3/qQiA+rrgabX65cWH8iTmaw5LD7KDylA73X2oSlHHiwIAnt
	 1o4ica+elLzFJkhKIqelgpeSXsbnCK99wZeJGSZ26rKeuEHwRwArWDK/JZ2KIOCeUG
	 dK1801LzPEUDSljDf5CjZyMrUBChI7Lxgsrx6cNG95eNM7sz6s2s0Ft5OvJH1tDDPG
	 Lj80EAy3x57b6RFkIg2k4JnE1Q038obkAMLFol3lRKqZZb4yRU7Sas8w+R+uZ2sGsZ
	 WSdsvH0pKsQmA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wSBbh-00000006diM-16bo;
	Wed, 27 May 2026 10:35:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Qiang Ma <maqianga@uniontech.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: PMU: Preserve AArch32 counter low bits
Date: Wed, 27 May 2026 11:35:22 +0100
Message-ID: <177987810338.1512096.8015208676423389883.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260526074640.791991-1-maqianga@uniontech.com>
References: <20260526074640.791991-1-maqianga@uniontech.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, maqianga@uniontech.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 26 May 2026 15:46:40 +0800, Qiang Ma wrote:
> AArch32 writes to PMU event counters cannot update the top 32 bits,
> even when PMUv3p5 makes the counters 64-bit. KVM therefore needs to
> preserve the existing high half and only update the low half written by
> the guest, unless the caller explicitly forces a full reset through
> PMCR.P.
> 
> The current code masks @val down to the old high half before taking
> lower_32_bits(val), which means the low half is always zero. As a
> result, AArch32 writes to event counters discard the guest-provided low
> 32 bits instead of storing them.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: PMU: Preserve AArch32 counter low bits
      commit: 1750ad1388e03fb27068cd1f22c9c8b4590fe936

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


