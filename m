Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E816C28399
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738681949; cv=none; b=Mgbl48WMpMhowcMZElaxJwZql32FdELOhLFhe9DOv0eajIGQiJgiWXY6jtxC/KiPoywysq7MjomA5f/9bayc7WWnlFcMgArWCjrhD0ggTOpUdQyt/pFmEZuIH2TX6+S30TFAD6sJ7QTStPAod5Yk0gjK+xzeOYDRbal/0Fl10JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738681949; c=relaxed/simple;
	bh=orB1CWrzjCAT+8Sk6a1qTdMMrSItL1nmWGKlxMd1Ssk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UNUG9Fi55+WUyZBFav+KEa/WQ1+QJ2AEOKHZskHL5bnB/qA6CA0g6bXHohHlQz4mo9oQR6PHTkfsO0neXHH/W5MvAH3NVG3/MAO4/LTojs16V/E3T1qynrgXyE6KigpFBiXgNaNxsh3qO80qPXRKAv1elZ0jDkk0tTNw+lpGVzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ViygaYFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ViygaYFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41502C4CEE2;
	Tue,  4 Feb 2025 15:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738681948;
	bh=orB1CWrzjCAT+8Sk6a1qTdMMrSItL1nmWGKlxMd1Ssk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViygaYFI38gnIA/jkFpMlSaIv7PdpY3d90jaOQIFt4OZP0GVnMPKYDfwIBtBJj7GQ
	 1srWI2H+lJSrNXwD7nhFGdlHbsMlEMQq6xFX7nYCCvOPkIuBDTt+MzkBUyeaestahJ
	 459EJbOOMylMnf3Wx2UJl3VzpiRPvga14IRDW78vgMhKjT9f34UmJuheO9bx6raXub
	 gabzSJ54b13esREX5uyUurv0K58bvgHmd9DXbxOsx7Vx0SK5LDcOAvWANZdS3mY2Y6
	 I9AcWM+yYjZEX8BKd/ZpWRDDd+1pM2G1kujRAMtb6NJGTmpttBxmJIxnU3knG+XCcW
	 JD2K2ys2LLu4g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tfKbB-000SzI-SF;
	Tue, 04 Feb 2025 15:12:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/3] KVM/arm64: timer fixes for 6.14
Date: Tue,  4 Feb 2025 15:12:21 +0000
Message-Id: <173868192612.774962.17867679674962882346.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250204110050.150560-1-maz@kernel.org>
References: <20250204110050.150560-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, r09922117@csie.ntu.edu.tw, Volodymyr_Babchuk@epam.com, Dmytro_Terletskyi@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 04 Feb 2025 11:00:47 +0000, Marc Zyngier wrote:
> It's been recently pointed out that the NV timer code that is
> (hopefully) on its way upstream is marginally sub-optimal (read:
> terminally broken). This short series attempts to fix things:
> 
> - Correctly arm a background timer in all situations
> 
> - Avoid corrupting the EL2 state by shoving the EL1 state into it, and
>   simplify the handling of emulated timers
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: timer: Always evaluate the need for a soft timer
      commit: b450dcce93bc2cf6d2bfaf5a0de88a94ebad8f89
[2/3] KVM: arm64: timer: Correctly handle EL1 timer emulation when !FEAT_ECV
      commit: 1b8705ad5365b5333240b46d5cd24e88ef2ddb14
[3/3] KVM: arm64: timer: Don't adjust the EL2 virtual timer offset
      commit: 0e459810285503fb354537e84049e212c5917c33

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


