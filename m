Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E64199385;
	Fri,  8 Aug 2025 17:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754675516; cv=none; b=ZF4oaWPVj/D2qhDgb6fztAkAapEnsU3VK/q1CSTEknBKx37OZIikTZiS/5RHuNBMrRkzPx3MjD6ZEFTY+Pv5L+s/O9JC6HpBi569AiTT1kf0cLZG5ogAV48TWxa3mp34Sl1fLzytTIb8+soZqIW7FGdOn4VGBc2nSiZG4RDAoYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754675516; c=relaxed/simple;
	bh=WOFVCvGAkEVEUCqKYOpl/dRyeNlS5UqIk3RBdYGqXz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pEhKgri/QGllqHaeesY4foCQkdu4v68QtdjTLsDkqT1gzw8ylWwRjMzIRSKoR1C7quUDT+6iEuRdF88uIW4e0WyACoQ2vvb9l8BrhKdFlxUT6H+FW/7qm3X1IB28U6aOS+A9rLFa4tnyotswUMgjeNiQzgW+CmQb8TcIVfpAg6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mAxBhCKD; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mAxBhCKD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754675511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W5zH1D2kwmr8dCpgiqzWF8oQlWdm8uTmQJ1ar/ni0uw=;
	b=mAxBhCKD4LlUW0eBh/lYzJwUYhgNl3NagukLegOF6BYXBQtSdnjbLzFbp6ITTxiq+WbUtC
	pyCXzfyapFoD8+jgxbvb7FCWav6HpBU5WkpYT61y0s6TaM8KixWl7TxUCpftElM5l0QzIZ
	wfFopWdSOyLpS840FuoMTP+dmyKJ6Fo=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] kvm: arm64: use BUG() instead of BUG_ON(1)
Date: Fri,  8 Aug 2025 10:51:32 -0700
Message-Id: <175467548061.670500.14517325210508247749.b4-ty@linux.dev>
In-Reply-To: <20250807072132.4170088-1-arnd@kernel.org>
References: <20250807072132.4170088-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 07 Aug 2025 09:21:28 +0200, Arnd Bergmann wrote:
> The BUG_ON() macro adds a little bit of complexity over BUG(), and in
> some cases this ends up confusing the compiler's control flow analysis
> in a way that results in a warning. This one now shows up with clang-21:
> 
> arch/arm64/kvm/vgic/vgic-mmio.c:1094:3: error: variable 'len' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>  1094 |                 BUG_ON(1);
> 
> [...]

Applied to fixes, thanks!

[1/1] kvm: arm64: use BUG() instead of BUG_ON(1)
      https://git.kernel.org/kvmarm/kvmarm/c/700d6868fee2

--
Best,
Oliver
