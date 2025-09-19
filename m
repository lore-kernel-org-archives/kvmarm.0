Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687E61E3769
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 12:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758285589; cv=none; b=cS9dRon+IMyvL1mLsWdsp5cdkrB2S2X5akleYnNOtSntASvtLjELpHoGq3ZyL5K2OP/SO1wyJzUHPQA1pmSKSJeN9ZrCL5Ge0PjALZZhV9brE67F1GM1hnA/u4lMSwgiSBbYEjA/UGIr1tpFyehT+YJHxDozKwtdjA9PwACNt/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758285589; c=relaxed/simple;
	bh=H+zwb1kyE4s45E03YhJnx3hyXl9pzjZGXghKaGe+Ils=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DJwaRKvau5FbWO3btg9608NqIMvM02xeCo9CK5p2SVqMReYNM2mD1B1mzAVONpBuPV7+hAHRcVV/HbWXLzSN270MQycClAkYWd3yfuYCJi7U/q+MgjRpy2f3HRFXpATPpyTo9i6ytnPnpquj7i5J3KeoLhx93FsIWzHywRXz/Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q3CUf5r7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q3CUf5r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1A0C4CEF0;
	Fri, 19 Sep 2025 12:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758285589;
	bh=H+zwb1kyE4s45E03YhJnx3hyXl9pzjZGXghKaGe+Ils=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3CUf5r7a3+ignstwmAcFhpB5v26XDnCsuRF1DgBzXiWqbXH6Fs2MWxWAwe1KjVcg
	 5J/CFeEMZmAoL8zX95uYpOzXdb13T2Ab957jBHM6W4aDaxMgtEzbXotmxJU/WF7+Eo
	 AoIhqSZW8Ro94GxgFi5ZszjNBUaFqHw19OvweH/3NfEfocU6qRVNVJhmZbh8XY+Xfw
	 jmnWQL2aw8/WSm8K99Gmi7ERqObCUnKLVH/EmBsiUUSjhkW60ErkTotzPlrcIRFRHw
	 knrWjzTOvK82H3dVjQOZBxRzkPfFbQuStVh+cPiVWG+5fgWI17puGzbal3lbgx/qJa
	 GTRL8Eky67W7w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzaOw-00000007m9k-3XRX;
	Fri, 19 Sep 2025 12:39:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Itaru Kitayama <itaru.kitayama@linux.dev>
Subject: Re: [PATCH] KVM: arm64: nv: Allow userspace to de-feature stage-2 TGRANs
Date: Fri, 19 Sep 2025 13:39:44 +0100
Message-ID: <175828557034.1679316.13575543787867256361.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250918165505.415017-1-oliver.upton@linux.dev>
References: <20250918165505.415017-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, itaru.kitayama@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 18 Sep 2025 09:55:05 -0700, Oliver Upton wrote:
> KVM advertises the stage-2 TGRAN fields as writable to userspace but
> prevents any modification for NV-enabled VMs. Update the special-cased
> sanitization to permit de-featuring a particular TGRAN without allowing
> the legacy value which refers to the stage-1 field for support.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: nv: Allow userspace to de-feature stage-2 TGRANs
      commit: 5aea4096380f5b14e3c0345bdafc291e9ae6d8d1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


