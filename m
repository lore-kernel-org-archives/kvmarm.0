Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793729389;
	b=VnoRSxLpo/uzdYxTo1UACM5eELKSPbfnIFhpzx58/+ckb3ZsEqWd0uMzYZ9H60gGK6H0
	 hr/t+rBf0C9uLdDisbGJtNmCgbfrDyE5PrqTVy7nmz/URbrQBo4OvZ2MIUpmvv5bmkSvt
	 jBTeaqPZ6wrofwkM8S6JVmmZgwBICI4ZTWjhR+Ud+J5QxQXqGuPfN5FPQKi3cC5cAkxrY
	 ITn7rexW/x2vNz50heiPY59+GIBP2BMPit71Q97dlzE5g8w48I53QgvjUtxWSnXH45qCH
	 31YEGj+XsyFDopJ4C+nynZg+YB1WlYwXfPFoCX6pOl1YLFg4DM1nttXEj/s20sdyW0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729389;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=MISLTQa8OWOUG9RJQQt3MzfXtpQ7bBuUscbvdvl9yj4=;
	b=wBtAzFJQwSKtuecPnUTtQFSCNhtFD5dN2R6ZKiZolOUD9sbQX3hO+jRrqt02y8+Ps2W4
	 recduY5ugzEweIGYLVeBY1KqHSYRSrW6ZfoTLOQZa2m7Onh9QoXddCVtV5RM8Wi+BrtHu
	 9NHFgmR/ietGz2qj7gtltrcAM17es1dhiovpGSHkNCxLZTMkdCWCiJ+W19VLnb0b6kPOx
	 AxtsoHW59HGM8bjEKixgyH6t+n4eOCkdC7VYi9cQWC/zokbeDjs+eDUVBK1Ps181tblcc
	 CoV4yjoGjjXwimocufSaDBWeJxN0ZDFme+Zg59vBEBQkORFY9COeIxJdhoTvDmzJbAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUDcxczV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916D8606A31B;
	Tue,  3 Nov 2026 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUDcxczV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0641F00A15;
	Tue,  3 Nov 2026 18:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793729389;
	bh=MISLTQa8OWOUG9RJQQt3MzfXtpQ7bBuUscbvdvl9yj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XUDcxczV5JfNeUUOR6hKJpM2vf0azQwrF1ionIRTxowLV4gbhMkwp0YZFJz8N6+dQ
	 UJnIMlKRcVB0JChbT1H9aTQ4H9Ii7lskyCfpSjY/TTqUOYlmCoftMv3a22lqHZtEUG
	 Bedl/sja+GP88qUTs5h329bOt2azpYlVcFraLNPV5rysNFk/XOSZQolYNtqTv4lAo0
	 Fscdh8jSUi5umuC3YMm12FGEgD1ewH5GesNVqqwhnI1fc53Ske2cyM9dIqdFcJ6xlH
	 2Fc1mE3O39N4+h3Z1JWBcsXuNR7wsLem5X0WQMGe/JcJ4BB0ImS0P2PNmkwTvtSgAl
	 YnklFu497MpUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOIx9-0000000AdWH-1ATx;
	Tue, 03 Nov 2026 18:09:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Use S1E1A when Stage-1 PIE is supported
Date: Tue,  3 Nov 2026 18:09:42 +0000
Message-ID: <179372937874.3124605.9961964127754462935.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103133540.29566-1-will@kernel.org>
References: <20261103133540.29566-1-will@kernel.org>
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
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, will@kernel.org, linux-kernel@vger.kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, ardb@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 03 Nov 2026 13:35:39 +0000, Will Deacon wrote:
> On a system with stage-1 PIE, a guest can try to execute from an
> execute-only mapping at stage-1 but trigger a permission fault at
> stage-2 if the stage-2 mapping is execute-never.
> 
> In this case, the EL2 permission fault handler will attempt to translate
> the faulting VA using an AT S1E1R operation, which will fail due to the
> lack of read permission at stage-1. We will then return to the guest and
> take the exact same fault the next time around.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Use S1E1A when Stage-1 PIE is supported
      commit: 9d447709895d3977e207dd1bc01a30f5c0f76156

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


