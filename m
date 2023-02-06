Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB30F53AF
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 16:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA53CC433EF;
	Mon,  6 Feb 2023 16:44:08 +0000 (UTC)
Date: Mon, 6 Feb 2023 16:44:05 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Shuah Khan <shuah@kernel.org>, Alan Hayward <alan.hayward@arm.com>,
	Luis Machado <luis.machado@arm.com>,
	Szabolcs Nagy <szabolcs.nagy@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 07/21] arm64/sme: Enable host kernel to access ZT0
Message-ID: <Y+EuVbkpQJk6z+Zu@arm.com>
References: <20221208-arm64-sme2-v4-0-f2fa0aef982f@kernel.org>
 <20221208-arm64-sme2-v4-7-f2fa0aef982f@kernel.org>
 <86y1pbywbb.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y1pbywbb.wl-maz@kernel.org>

On Mon, Feb 06, 2023 at 09:31:20AM +0000, Marc Zyngier wrote:
> From a6c4aaccd33e453ffc8d8ea23a4dd4d9a263cc89 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Mon, 6 Feb 2023 09:24:40 +0000
> Subject: [PATCH] arm64/sme: Fix __finalise_el2 SMEver check
> 
> When checking for ID_AA64SMFR0_EL1.SMEver, __check_override assumes
> that the ID_AA64SMFR0_EL1 value is in x1, and the intent of the code
> is to reuse value read a few lines above.
> 
> However, as the comment says at the beginning of the macro, x1 will
> be clobbered, and the checks always fails.
> 
> The easiest fix is just to reload the id register before checking it.
> 
> Fixes: f122576f3533 ("arm64/sme: Enable host kernel to access ZT0")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Thanks Marc. I queued it on top of the for-next/sme2 branch.

-- 
Catalin
