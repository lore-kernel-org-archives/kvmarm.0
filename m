Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28166366FC8;
	Thu, 30 Oct 2025 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761841396; cv=none; b=q0xQxi7ESVBfKngK4nPQR1V9tXY9OlJGrMyy+T+Q4Ur/e7MbTQMmBmu+dXwk0Sk/yrKyl3Ab5WPh6AzcpTCtBC5G4MLaD3UuTuv28dxIvMO/FJzZcWsUwshe4rJ772U1dA7UzamXc0UAcPT8udkBx6ZHrks5kTmF6EbjD5HEBYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761841396; c=relaxed/simple;
	bh=4GBRLaudHRcBoz01Z4IeWd9bqYB0qBWnK2IVkXPjuoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rtZwK1Nob3qgjMIhdh52qFQDC+MWQWSAKd/S4cPqLlTCw8RezlxCRBFMDeCJvNBv5i0s+8406lsosX0vkRHfmOFdOCZe/ueshzCep+y4xqp5sqVl1H+ZqaabE9Xz2T29cuHTOH1wxH8HM0hZYCYvHSyh0upJoT86OgBDdyOzfOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+JX+u1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+JX+u1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00425C4CEF1;
	Thu, 30 Oct 2025 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761841396;
	bh=4GBRLaudHRcBoz01Z4IeWd9bqYB0qBWnK2IVkXPjuoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+JX+u1AHdIdZKw4SyNVX0vtYYqnUKc0r1DZLb6pJ0joB9sWk/f5VrR5I/HS2HOM6
	 ANZuNZEUkf+kqIi0ByD9yjuRgnWYZRjArzFYtRkHWM4L9ax/rBg3qRxJkOgR11X0yN
	 Wpc5V88Gj76jEGU+0RZC1asYaoJOq0rbzpOe8/gx4ikTAuLlnjsT8QAm7z3hQf4p3j
	 eoiw0TuwkHa8FbMbwFDzNMKXvFn2wZQ8ijgZbMnaeIJecVTeAwfYeGZHeuUeQD+tIf
	 QnpUIrYZwDe9Z4a0k25LGe8onC99z5iNxqdv9iG95R+20Jdy7VByJq5twDzySRiI0x
	 lYAJ1Bmjs+4qA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vEVQf-0000000139S-3rhC;
	Thu, 30 Oct 2025 16:23:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: nd <nd@arm.com>,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Trap all if no in-kernel irqchip
Date: Thu, 30 Oct 2025 16:23:07 +0000
Message-ID: <176184138741.2037570.6590517133486615638.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021094358.1963807-1-sascha.bischoff@arm.com>
References: <20251021094358.1963807-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Sascha.Bischoff@arm.com, nd@arm.com, broonie@kernel.org, oliver.upton@linux.dev, Joey.Gouly@arm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 21 Oct 2025 09:44:09 +0000, Sascha Bischoff wrote:
> If there is no in-kernel irqchip for a GICv3 host set all of the trap
> bits to block all accesses. This fixes the no-vgic-v3 selftest again.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic-v3: Trap all if no in-kernel irqchip
      commit: da888524c393b4a14727e1a821bdd51313d0a2d3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


