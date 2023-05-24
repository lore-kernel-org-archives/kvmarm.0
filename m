Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8926084D
	for <kvmarm@lists.linux.dev>; Wed, 24 May 2023 12:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669D9C433EF;
	Wed, 24 May 2023 12:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684932598;
	bh=zvm9Rbq4njzC/HtlN1HHDTCp/dEy0DH/n9w8fl5l8C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icXrC301g3wOHYtEKtJC0twQqLeNEcre5GxiNIap3qQrKTbiMM6bVvtZiva1MOgal
	 aVHhHo0BC1vpBV+o1inPi/6iHG0Rw3legX9M04FaCVdtQmAvboqaAx3ih7dPYVI4zp
	 9F6uKWaToVCXWs2yjApowWSW5SBh7I9aiGf9MhI27aHVy4pxBzacDGlvHX0BDtBvIC
	 OE4RawCv4zbNPJISmHY2gKjIiMLPRsoDfTmWAyzOGDQmhihGLMG1MFzNNmtduSLwE7
	 VrbX1avvImAswA1+kj5FQpD0Tio+Na7jXZeOIdIocV9rDYOdVn4oH5lZRbodEeRed7
	 XrqSAtvaSpw8A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q1nwB-0002Lr-Fr;
	Wed, 24 May 2023 13:49:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev,
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH] KVM: arm64: Prevent unconditional donation of unmapped regions from the host
Date: Wed, 24 May 2023 13:49:52 +0100
Message-Id: <168493254802.3630329.10635204688198493214.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230518095844.1178-1-will@kernel.org>
References: <20230518095844.1178-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 18 May 2023 10:58:44 +0100, Will Deacon wrote:
> Since host stage-2 mappings are created lazily, we cannot rely solely on
> the pte in order to recover the target physical address when checking a
> host-initiated memory transition as this permits donation of unmapped
> regions corresponding to MMIO or "no-map" memory.
> 
> Instead of inspecting the pte, move the addr_is_allowed_memory() check
> into the host callback function where it is passed the physical address
> directly from the walker.

Applied to fixes, thanks!

[1/1] KVM: arm64: Prevent unconditional donation of unmapped regions from the host
      commit: 09cce60bddd6461a93a5bf434265a47827d1bc6f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


