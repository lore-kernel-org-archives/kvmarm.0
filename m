Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5621C3F04
	for <kvmarm@lists.linux.dev>; Wed, 19 Feb 2025 22:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740003106; cv=none; b=ALraAlUUsing1o6NfNPjj/P6ohweIGlb3NeCHbB6hnackwwF64qNz47Ybahb+4BvXZLNupVkzBfG1OC7pUyl4CmNOoPYOIlbVJXMAH6m7MFGTj2x2pBT9+uVyQP9y0Q8W86HmwH1Wbz/3YW4+ihX+ZMGifusvTiU7iJizu359Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740003106; c=relaxed/simple;
	bh=dZyIn3+mJ3vnANHwYSZe/NwWp//PvNFWn3w/6m5Atxg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TbHOXyZ+PBoEx56hmz6WS9K4ZXkzxmOQ3YJQoFBjfrhfFNKCE3XaS/oydpVHUnTrJK5l4pV48Bh26NfUpozZUCm5qqPvmGKUJTHEO+CfpkzARngoQQ0/XK/X+sQx4TBm4o/cUWZevpSSe/8pIC8dNgOjSsPQmRx8buyJei0gsWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWdUaRWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWdUaRWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9EFC4CED1;
	Wed, 19 Feb 2025 22:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740003106;
	bh=dZyIn3+mJ3vnANHwYSZe/NwWp//PvNFWn3w/6m5Atxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWdUaRWWkN7u/XVvl76z7LF+/W9dJl32hpLYgoRV03/xud0VwajoKJhKmEAfxue8A
	 8U/i8V82GDdusExHr2lFgiQAH3qZgZyQuL6+tcAEMENBo9xn5gunplxyEF1TtVMGTe
	 g4nTmRBpkwQOfWe1bNhR7uxMdvpa+NEMSsZV8Tyh99wVdInTKnWNIrV3K8dBcyhhG/
	 FrPQK+qEz590c2POkLp1YOFPzFcKnLhNHq1S8eczJEXhYuKgbhlPKUyHO6lpHs8vNo
	 ErLbrZJ859VcxuqEz/sgoRnLSx3SGDI000CsrANPJdFQQORlWE9OnJ9X1dADj/ZBxu
	 Ps0BxWJmXA45w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tksIB-005zA8-Qj;
	Wed, 19 Feb 2025 22:11:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] KVM: arm64: Fix tcr_el2 initialisation in hVHE mode
Date: Wed, 19 Feb 2025 22:11:38 +0000
Message-Id: <174000308842.546972.9338900665339093067.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250214133724.13179-1-will@kernel.org>
References: <20250214133724.13179-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, will@kernel.org, linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 14 Feb 2025 13:37:24 +0000, Will Deacon wrote:
> When not running in VHE mode, cpu_prepare_hyp_mode() computes the value
> of TCR_EL2 using the host's TCR_EL1 settings as a starting point. For
> nVHE, this amounts to masking out everything apart from the TG0, SH0,
> ORGN0, IRGN0 and T0SZ fields before setting the RES1 bits, shifting the
> IPS field down to the PS field and setting DS if LPA2 is enabled.
> 
> Unfortunately, for hVHE, things go slightly wonky: EPD1 is correctly set
> to disable walks via TTBR1_EL2 but then the T1SZ and IPS fields are
> corrupted when we mistakenly attempt to initialise the PS and DS fields
> in their E2H=0 positions. Furthermore, many fields are retained from
> TCR_EL1 which should not be propagated to TCR_EL2. Notably, this means
> we can end up with A1 set despite not initialising TTBR1_EL2 at all.
> This has been shown to cause unexpected translation faults at EL2 with
> pKVM due to TLB invalidation not taking effect when running with a
> non-zero ASID.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix tcr_el2 initialisation in hVHE mode
      commit: 102c51c50db88aedd00a318b7708ad60dbec2e95

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


