Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABF148BD41
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823087; cv=none; b=tvNyvyLPcPbItfAxhNjS1snQcZGkLXoN+P8CZ8U+c1Iyhs9/1Ie1oi6sgKo3E/p+X5X7SSN0eINBO+T+X1/aWOTZLYQ0HhD42AK5nVgk0X0ZgrYD9McrKpU0bXu1Na7Kth97+VkiqWgglAsPgM4cGLNeoq1px5B/6Dlo2h0yywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823087; c=relaxed/simple;
	bh=5GJ6gd89YE2JtaPlCwJROaT6MvdzIexEMAvb/rAjE1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=djXzNhNG+AHFF1W5VKQN1Vj/3RY6CjsAuN2CgZ7RxqrxrKW9GnfzN0m15MmfdI+lT1JsZJvAmWiBLqF0XiHFNyQUzbm12bhky8KD8Jcguaw9RGOtSYRI5wFqCT5792pFCP4mfDJOxJOfgotKTq+p1BzyKC36nanPENL5aeEbLW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Va66P9Rp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Va66P9Rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A371F000E9;
	Thu, 23 Jul 2026 16:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784823085;
	bh=9iRhNi+yUXKfpfAd3BQD5gtcqdXgAesz130Ref+69T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Va66P9RpFS7zFNo8rf/NAGDRn9gBhUncM5Fxaotxl0jrI7ssKffoQEfkuNj9GSaa3
	 5Ihhb47C5QGVojU9c6GH/spIbM4E4kAs8tdw1TI2jZV7fgA7+3jyu8pft41z3yUge2
	 6hlulT0Av560w0gFbbyH/dCSKN6AqFS8N7FIuwrCdlzSQ1E2ruY/ramCC/hcrdc/zr
	 YU+Qhq5Nyi8q8uddK8xamr3dOgIXefnFZetJJpgSGS4tWI60Bx/BKeAA+jL/FSi0Vi
	 qO4eCrOm1k1nh1CykBB8/YLmTC5iZV16P6ZJx66xlBSLiRJUZN49+0/y7k1m/vHzmu
	 P9Bf2c0M9nJKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmw0v-0000000872h-2eaX;
	Thu, 23 Jul 2026 16:11:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kernel-team@android.com,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH] KVM: arm64: Add missing hyp_enter when trapping sysreg
Date: Thu, 23 Jul 2026 17:11:11 +0100
Message-ID: <178482303777.3351010.5347305905050874552.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617095238.1530121-1-vdonnefort@google.com>
References: <20260617095238.1530121-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, oupton@kernel.org, vdonnefort@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kernel-team@android.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 17 Jun 2026 10:52:38 +0100, Vincent Donnefort wrote:
> Add a missing hypervisor event call for hyp_enter on sysreg trapping,
> causing an unbalanced hyp_enter/hyp_exit.
> 
> The enum hyp_enter_exit_reason is not ABI, so we can keep the ERET
> reasons at the end for clarity.
> 
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Add missing hyp_enter when trapping sysreg
      commit: e7821048e8d72a94b1fb7422f8b45aa374ff076f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


