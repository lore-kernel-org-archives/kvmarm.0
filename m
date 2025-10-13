Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863DC283CA3
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374583; cv=none; b=Ym7+pz/EJVbJ/Dg2vdkT/LXkuq3lMbL3urfK44wrsfy1eXTKjjplZ4LqkSwxVVxSc2CtSVtgh8Ddf+s3C2+nncWbqlQNWcTKWRm+Q6QdEVvdZRcdqywXbcMRUYeEHGXpigjAWFukdhGA2hpLAmTRmxHoPiXQ9gM1Uc117bnQua8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374583; c=relaxed/simple;
	bh=NCmPsOOiO4a4VbGDcAYCyafylTmfuKIwr1PxKNmChbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mu7XUeOQfyhp19WGNMWUV+QYgt7AC3fgKEXqUZhSANnwA3ZY9wZVqYWcS+kwzDKTx7xJ6/ky6SI9EC8UwAt9nraMoLeABraim589aL/vrYTXlUyo97jGQ2EbI1wP4aqTXq78WNJchmJ5WW94sUdgY/9v3WPHoqovn/ZcI8ri9zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+cB7gA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+cB7gA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E06C4CEE7;
	Mon, 13 Oct 2025 16:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760374583;
	bh=NCmPsOOiO4a4VbGDcAYCyafylTmfuKIwr1PxKNmChbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+cB7gA3KcYsB2Ux+1DHed+dbo6nF/VCFURjCDzsJa3U8yQCINcbIFxuNN64Nrf9+
	 OxV0cy8NG5M4w/ZWEgIMM+yfi+JypzDRnz7sFyRPkwKV4Xie8rKCe1wUlcfdigDPK/
	 XcZXCKP3Bwv+4uqHGsyIopDifz2PivQ7skvSW2V+kYJ3ZiXbU+5ea4aa/sLMini8hP
	 O34TM0BLzLLEBTpYiDHNoU0TYDn80ZJwlm+PAY39SU/31pT3Kxi+KrF1psbHrC37yg
	 wGfiDwbqIWLmiAb2v5MpxEbW1bhhlSW+y030YDg7zFTW80m2SkUkFVOebfs+T+MK7w
	 FWiZarKCpL6vw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8LqP-0000000DaVd-05PC;
	Mon, 13 Oct 2025 16:56:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: selftests: Allocate vcpus with correct size
Date: Mon, 13 Oct 2025 17:56:17 +0100
Message-ID: <176037441177.969330.10756957974370732215.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008154520.54801-1-zenghui.yu@linux.dev>
References: <20251008154520.54801-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, zenghui.yu@linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 08 Oct 2025 23:45:20 +0800, Zenghui Yu wrote:
> vcpus array contains pointers to struct kvm_vcpu {}. It is way overkill
> to allocate the array with (nr_cpus * sizeof(struct kvm_vcpu)). Fix the
> allocation by using the correct size.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: selftests: Allocate vcpus with correct size
      commit: 2192d348c0aa0cc2e7249dc3709f21bfe0a0170c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


