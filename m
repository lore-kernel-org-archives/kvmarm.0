Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C22A3563D9
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 09:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769073080; cv=none; b=l8f6JZ3nW61RMBLLH+MiRllVyJ81k+vkPzzlQyzNVsgVHvGefGJJwaIA5DeaBnuHgwp5IMEdu+Y96CMOAinNuJxZuGdY3eHaXCMxARmQKHAjhVO1YGXHUHDwuR09MgaKUgAbMKH5qH3OsWAqIyk37l64heK/uyQzz6Q5S64r5vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769073080; c=relaxed/simple;
	bh=KJHCIOkGx5u/d7mxF8NKEwJkoQXnIm8GQsBg2ZgGEFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LM1p05Q4Br61lYFQD1JhJj806cRlkz4MH83nHKKLBciI019agmYtrlYcFFIzhGLShRl/4G+Njmon//IqYnd35XLTAUT1P0kLs8H67seNX+2UrXwd5+z4zZa0OUdwnh/BJMpZOIT5JqpKrxaKKav7b0GKsCTHDd2TuNMHFskzUgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcPxjQOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcPxjQOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE156C116C6;
	Thu, 22 Jan 2026 09:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769073080;
	bh=KJHCIOkGx5u/d7mxF8NKEwJkoQXnIm8GQsBg2ZgGEFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcPxjQOVfaMrESS2G5htdN7nCV2jKRGRWNLMe3I+4Ghds00qWam4R8QLTrhKjwUlI
	 ycf3k43vcscqRrq4ms9QbE1ADSd87GkCNRbvZHRVjM5ugkIndNrJc4CxKXJXoj59hX
	 z4mU5q8bJtkaAaaq/ZpMH/FRia//d10r66sczcH5gRLZPcMKBCSwjKJWAHLGHJSKSc
	 tuvf+ikA2cVV7ECP+PxV8O5NI860rw589TFGFTRl78dpnqdBpPWiYrAhx0UOivPmkS
	 YVKYIk1PbGyBec2lraeXMKPpvD3rdIV9+m+A4X5If/FJYMddA17GuQl3TeKwOEu2an
	 aLYrT4FdgCUDQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1viqij-00000004cXL-3SbK;
	Thu, 22 Jan 2026 09:11:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	wanghaibin.wang@huawei.com
Subject: Re: [PATCH] KVM: arm64: nv: Return correct RES0 bits for FGT registers
Date: Thu, 22 Jan 2026 09:11:15 +0000
Message-ID: <176907305597.536564.1301692951815712064.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121101631.41037-1-zenghui.yu@linux.dev>
References: <20260121101631.41037-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, zenghui.yu@linux.dev, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 21 Jan 2026 18:16:31 +0800, Zenghui Yu wrote:
> We had extended the sysreg masking infrastructure to more general
> registers, instead of restricting it to VNCR-backed registers, since
> commit a0162020095e ("KVM: arm64: Extend masking facility to arbitrary
> registers"). Fix kvm_get_sysreg_res0() to reflect this fact.
> 
> Note that we're sure that we only deal with FGT registers in
> kvm_get_sysreg_res0(), the
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: nv: Return correct RES0 bits for FGT registers
      commit: 2eb80a2eee18762a33aa770d742d64fe47852c7e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


