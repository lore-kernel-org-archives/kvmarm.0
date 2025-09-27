Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E394B2E090A
	for <kvmarm@lists.linux.dev>; Sat, 27 Sep 2025 11:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758972617; cv=none; b=Ac1OEeC/xlZ28aZuCp1fA3UHAdCSTH0o7M/sxlF6QXlt7NTtgV8jswEu0/gdbIEDAKkzKynQex4zEx6+llswYFJkHgGKOwVGt6hrRvXR1uMJC8j0jfAQ1HoyGUyp1xZyijDDP3t1jawEOzEJq3mBXA6pu5pL79THaHnEBUnS/24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758972617; c=relaxed/simple;
	bh=ARxMep3TBkaFpGE5ob648v+pw5ad2ETUYz+NMe0DbVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qx0LpciIlJnsDewy8qQ8m2b6+l9Stfbg6calBZkeHS14RlJ9woauVh5a/cL25jgBUwiT4/f8+gRCsEL0fe0SnYhiY1OAMdokmxFAftJT9yRJi3KGFRanqHtWeJEyTZHpVNySZI3TqDHb223pYmMSQQo8VUjjdtR70wVR41erOZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Peeh5U0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Peeh5U0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53722C4CEE7;
	Sat, 27 Sep 2025 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758972614;
	bh=ARxMep3TBkaFpGE5ob648v+pw5ad2ETUYz+NMe0DbVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Peeh5U0TudAzLMTCbDkgHOXNXTkQ64TqtWp11AbH+WuhC/06PTbhBX4HzfDAn4ukJ
	 yE21FVQpVrt6/6e08TYDM2N1RzU5IncdClCNZy37PD5cTOAD3FPSi9hcjgrz7yR7wj
	 MO5FaGY4OIZfWPgRYpkoMww7uKNOUbtUYadq0Jw5kj7eCIXaZcNhOdwO49sf3nO3M+
	 TZ40Zw01zU4Zjo69Fuz4PUnasfkRfiP/WqFcImptkph/rQu2BzM/q9OL+Ft0uz8B33
	 WiT1znvaHVK6J74OW3SDM33hHKI30H/uqyIOU5YMi91M0W0CxQ66hYrxh3UdV11CiX
	 o1kIAsQx1L+0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v2T80-00000009rdc-1YhH;
	Sat, 27 Sep 2025 11:30:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Use the in-context stage-1 in __kvm_find_s1_desc_level()
Date: Sat, 27 Sep 2025 12:30:06 +0100
Message-ID: <175897260592.2798522.13221567752351280408.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250926224246.731748-1-oliver.upton@linux.dev>
References: <20250926224246.731748-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 26 Sep 2025 15:42:46 -0700, Oliver Upton wrote:
> Running the external_aborts selftest at EL2 leads to an ugly splat due
> to the stage-1 MMU being disabled for the walked context, owing to the
> fact that __kvm_find_s1_desc_level() is hardcoded to the EL1&0 regime.
> 
> Select the appropriate translation regime for the stage-1 walk based on
> the current vCPU context.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Use the in-context stage-1 in __kvm_find_s1_desc_level()
      commit: fcaa3f59fda3579ee77127abbc58896c67c36cab

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


