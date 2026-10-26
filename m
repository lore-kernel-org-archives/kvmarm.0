Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016078;
	b=fNU/tX6cr56KkolP1S6Q8b4X2ozBr2w/M8DbgiSkX+4wPQQSdFXg11dkmJoOcixeVbKx
	 dor2Yy6ed9c74X2mOj7r2hd9pJBwf/ZYmysSoThN+u4cttBjD18mQVF8WZILKUS6zngGu
	 +tdxEhuuGkd0maCCO5BonTjRVh8T8zsTH7PVtTuMclDlsT6wvPM/sOpkXRB+4mQ/moF6i
	 0QmFn5Tk3poeXq8Ecuk0DqEBdfpsYG+1DaKhTg47GeNvofNMtkxAHTyFaqVAVONbplv4A
	 VzYicti92+9ltnqX8ytmc27oBNIRJ7LfQVHI+XUh5k9CuznToYgRzhXKicCfUd4/DkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016078;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=i9d2w8902Adn/vvLwClFjjVwTKsY1rEJtVs3bWX/Hiw=;
	b=KnLBQByMiW9USopPP5AJSVqiGsIM70GxCBiXgDmEYRooMnjNKVGSGQgFPN/J9/f/rEYA
	 q2wV6BGxFRT78wqPA4xFncjK25sG/vMUsKEfufhJ1BNzq2L2tlK+D2hMI3NapWtYXOcUW
	 wMF40poZ0BHrgjoQWmCrhBrV1vNhRYk0TLz+MYK2EuXCr1YHGNXyAu1D/UQgzYa3f3of2
	 YdZQfQodIYoAxSf7fcM0evRRw0CeHOkOFw/Bu+P/HcyhxsvtQiUU5vuiSp6EeoziJCAp/
	 GbMy+6PqZAcxxQafcYLgu37fwhrgh7lItm7iO4NbxOFBcmcQl+Gt6sAH+Qegj9WIbfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jl9ePWmY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2A6606A320;
	Mon, 26 Oct 2026 12:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jl9ePWmY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3170A1F031E5;
	Mon, 26 Oct 2026 12:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016078;
	bh=i9d2w8902Adn/vvLwClFjjVwTKsY1rEJtVs3bWX/Hiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jl9ePWmYB8PdRHvLvKgd4dwm/KtEUzpsFDWj9At/nEduJiOEfS9TCVSVLOMRIZuoQ
	 7wBcZLG9gD/b9Ycs31YSXaVjX7lynT3wqF6omOe0WpHii7Yyh9TUEx1HXxF015kNBf
	 0CUja3UO2itUPKbYcA1QNfrdwT9vNOSoBgrrRGoBxIHhLtx20ShxewhWKO2aEXyRPI
	 kxLwdxU7+Vzd7LSxYv4BD3uvqLf4ZJF9POdIr8FvKmmT2pL6q3W2Q5YIoRaFyaB+9p
	 9dojjsjdctI1Y+2QY1La9FVpcFnfamWltmYs3MqiaKE/7Gqn76/GWpaYTRVsW0lN2s
	 lN8wMcfaaGD1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJO8-00000007Fr6-1r7B;
	Mon, 26 Oct 2026 12:01:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Don't WARN on SMCCC filter reserved range allocation failure
Date: Mon, 26 Oct 2026 12:01:00 +0000
Message-ID: <179301587183.2527370.13372892962068764857.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261013164334.1492070-1-fuad.tabba@linux.dev>
References: <20261013164334.1492070-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, fuad.tabba@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 13 Oct 2026 17:43:34 +0100, Fuad Tabba wrote:
> The first time userspace sets an SMCCC filter, kvm_smccc_set_filter()
> inserts the reserved architecture ranges into the maple tree and WARNs
> if that fails. The insertion allocates with GFP_KERNEL_ACCOUNT, so a
> tight memory cgroup limit is enough for userspace to hit the WARN, even
> though the -ENOMEM is also returned to it. The WARN dates back to when
> the ranges were inserted at VM creation.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Don't WARN on SMCCC filter reserved range allocation failure
      commit: 09d5e940500c2e51b697a0522c54132c1ef078ef

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


