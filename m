Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990E21848
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 09:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E674C433D2;
	Mon, 12 Dec 2022 09:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670836097;
	bh=z5HqcNfQJi1MaenD9RiDHiFMXvNXPXoJXEhKMYHhZY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InVOrkT1F1aLJT+4NIgtTnatQBkkM198K5TAlHCJ8DXZyGYDgCMCcXDT0eXeJz3c2
	 OhCJHYPme4sbb5dZ565a7cKK1qaCiXEYnJXWXdWME12pIlCCH/ACPMXWctIjtXW60f
	 IuquRiVR6GDD+fIAHNt6VCVJTZdv9i9JOkl/eqcqPqxoBMDPgSI2SrFb2+v/4ERFVd
	 FwO3vmlhycWZHL/qgN6p9nBfu58Pq619zffjzAZeRkpY32bmPFV9B/0vIzup6X1FPT
	 8XEuC6uh+1O9G054kGOYlyrFGYScTrFqJ6xZb4ApBVv5sbXNDxSuv7Ammblp9CCKKA
	 nqMt4EAnyZwyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1p4enG-00C3aO-WF;
	Mon, 12 Dec 2022 09:08:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	James Clark <james.clark@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 0/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Date: Mon, 12 Dec 2022 09:08:11 +0000
Message-ID: <167083608669.635334.13408416430959494147.b4-ty@kernel.org>
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
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, james.clark@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221212090811.NII819sHQlmQlSPmNkebFsmeiJcmKpnzm4M16NgoveE@z>

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
      commit: aff234839f8b80ac101e6c2f14d0e44b236efa48

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


