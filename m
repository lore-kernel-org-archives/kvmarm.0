Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364177E
	for <kvmarm@lists.linux.dev>; Sun,  9 Oct 2022 02:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD998C433C1;
	Sun,  9 Oct 2022 02:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1665281810;
	bh=wZfzFS/Mb1HdsTZIEGZfIp0b8+xizJLNyb8A1y8MKcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Px5TafGJM14lP39z7o8RkhepTF2Gw3FQX7+48pmEO0tmon3HwVAHbeUwI9oBlYVKp
	 lzgbwCxErEqU9+S+UWXLs1eTadSCV/cpXwFkVlK9RTj2y3DaXYNGNMJ1kolTAaHyMs
	 x8ZzyhNQCboV5ITvAzyGj8NVTSGGYPQ4LUlKtyBMMT5LwMVc9ccsadicq+1OeSDLKE
	 VPSiVcbKbwRoX972cERyyMpD7FCOwto3h9u5eak0v0YGc+lWg32V4gp9oqH8mReeTq
	 X89AIugiCMiNKrtR38yJ+YYhsWgSeOxjMQOmMyxVCkKYSYNInzkx+ihi2TaC+RfmS5
	 eAJkB3spSlcaQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ohLs0-00FL8W-NI;
	Sun, 09 Oct 2022 03:16:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	Vincent Donnefort <vdonnefort@google.com>
Cc: alexandru.elisei@arm.com,
	james.morse@arm.com,
	linux-arm-kernel@lists.infradead.org,
	qperret@google.com,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	catalin.marinas@arm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: Enable stack protection and branch profiling for VHE
Date: Sun,  9 Oct 2022 03:16:46 +0100
Message-Id: <166528178074.254503.4066192090296585543.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221004154216.2833636-1-vdonnefort@google.com>
References: <20221004154216.2833636-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, vdonnefort@google.com, alexandru.elisei@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, qperret@google.com, kvmarm@lists.linux.dev, will@kernel.org, catalin.marinas@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 4 Oct 2022 16:42:16 +0100, Vincent Donnefort wrote:
> For historical reasons, the VHE code inherited the build configuration from
> nVHE. Now those two parts have their own folder and makefile, we can
> enable stack protection and branch profiling for VHE.

Applied to fixes, thanks!

[1/1] KVM: arm64: Enable stack protection and branch profiling for VHE
      commit: 837d632a383f13df7a67207a196d6eb4aeb4adca

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


