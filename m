Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0658F47
	for <kvmarm@lists.linux.dev>; Tue,  3 Jan 2023 17:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C139C433D2;
	Tue,  3 Jan 2023 17:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672768658;
	bh=hUZ2XDvLrwJ9FannznPjhaf3MRrc6OlAN+J+YQi66mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWe/pJ0Rk3yxk2m19wCaALmQUCxhnbQi+NVxW6/7FRhaZSCBvm1Lzy0Wa8KPVvU0E
	 4k/5NRa4jazSSKLEAl7WZl9WcA817NLvXoL8Qg6P/lV+JZhTAHwPxBRSBrdZVkm5h0
	 lrLE/k2emox8Kdejgrli77+/I+4QeUbxD06407yQIh36wEl2YZofrqKmuzEOVXeM1K
	 2vDqXCPDJEHPBhWDnBTwrXCsLKDID6l3lpS073aUw5VchrKqEAUpFfC1T9yjgdo1B1
	 7HpgObpOkDxbMW166fbPambmCw9PhWFighD1qCqobaJhhwvY/aeiJj81Dd0zfW8wzr
	 bHzVaa0m5tAOA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pClXb-00Ga8q-9m;
	Tue, 03 Jan 2023 17:57:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: James Clark <james.clark@arm.com>,
	kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Date: Tue,  3 Jan 2023 17:57:32 +0000
Message-ID: <167276864513.3239355.2653412840294598299.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221209164446.1972014-1-james.clark@arm.com>
References: <20221209164446.1972014-1-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.clark@arm.com, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20230103175732.hrHAFT0YvGq3Hn4y9wgnUfoxzESHike7L6IvPAuyrlQ@z>

On Fri, 9 Dec 2022 16:44:45 +0000, James Clark wrote:
> We noticed qemu failing to run because of an assert on our CI. I don't see the issue anymore with
> this fix.
> 
> Applies to kvmarm/next (753d734f3f34)
> 
> Thanks
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
      commit: edb4929ea9ba48cd91e3867041f49e4c34d729ed

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


