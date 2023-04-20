Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38BD8F44
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 17:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F0BC4339C;
	Thu, 20 Apr 2023 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1682010305;
	bh=ZJMRN4jMrJSOuZlgUiXN8kDBVb8+rWXg8hdPXZwgunA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+vf86gpk906GhdJlDczq4Pyu6J0TWh+mttRREnltWytlOtT9ESxlh3RS2+3j76hy
	 3XeA4Kid0qkax7ePB4DdoGHk9pA6gMzDnPjvYvqYQlDeEbFM4u25fLll3locP86V/g
	 DDFcSCUz7EnfjeQb/qWzfyooUTtNQz0pXPpk2fHU6+55b5re6TH+D4shE9M7pEf8Tn
	 N2qw82XOqRItSbrHswAiPBOMrBB+49rVSTSeghRRSi+BD87/jmhxXykvQprC91illt
	 7U2KqlRH22I/RGZqOXG8Rc1r9CR53UhlvDNYRsDGeaUHgq8YlY/tZn39rwbzJUtOzP
	 YWtMn9eriWfAg==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] KVM: arm64: Ensure CPU PMU probes before pKVM host de-privilege
Date: Thu, 20 Apr 2023 18:04:54 +0100
Message-Id: <168200627488.452886.12055020728009617397.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230420123356.2708-1-will@kernel.org>
References: <20230420123356.2708-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 20 Apr 2023 13:33:56 +0100, Will Deacon wrote:
> Although pKVM supports CPU PMU emulation for non-protected guests since
> 722625c6f4c5 ("KVM: arm64: Reenable pmu in Protected Mode"), this relies
> on the PMU driver probing before the host has de-privileged so that the
> 'kvm_arm_pmu_available' static key can still be enabled by patching the
> hypervisor text.
> 
> As it happens, both of these events hang off device_initcall() but the
> PMU consistently won the race until 7755cec63ade ("arm64: perf: Move
> PMUv3 driver to drivers/perf"). Since then, the host will fail to boot
> when pKVM is enabled:
> 
> [...]

Applied to will (for-next/perf), thanks!

[1/1] KVM: arm64: Ensure CPU PMU probes before pKVM host de-privilege
      https://git.kernel.org/will/c/87727ba2bb05

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
