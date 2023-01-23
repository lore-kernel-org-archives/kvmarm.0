Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B2E7C;
	Mon, 23 Jan 2023 20:25:18 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674505510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=au8ZWtE9bpKXrUx2+rVz6YucHx64Tiv6wraMR9Ps5aI=;
	b=H4xc2VK1l42xb06YdwJ3PNziW3+B/OpaCye3SvNxBARlyaMHg5CpkcBk+GfaflhfEuqz6i
	36ZixVWK8UOQ+mvVr0SRsSPUQ8HQJ+d90QOnzABLF8NY7pNdVDHMQnr7bg1ecdh84hoOKe
	RK6qs+CVXW4/gdorAqT6MrwQrm2Aw0g=
From: Oliver Upton <oliver.upton@linux.dev>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Hector Martin <marcan@marcan.st>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Sven Peter <sven@svenpeter.dev>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v7 0/7] KVM: arm64: Normalize cache configuration
Date: Mon, 23 Jan 2023 20:24:56 +0000
Message-Id: <167450318853.2568505.3166405888000533001.b4-ty@linux.dev>
In-Reply-To: <20230112023852.42012-1-akihiko.odaki@daynix.com>
References: <20230112023852.42012-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 12 Jan 2023 11:38:45 +0900, Akihiko Odaki wrote:
> Before this change, the cache configuration of the physical CPU was
> exposed to vcpus. This is problematic because the cache configuration a
> vcpu sees varies when it migrates between vcpus with different cache
> configurations.
> 
> Fabricate cache configuration from the sanitized value, which holds the
> CTR_EL0 value the userspace sees regardless of which physical CPU it
> resides on.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/7] arm64: Allow the definition of UNKNOWN system register fields
      https://git.kernel.org/kvmarm/kvmarm/c/e2c0b51f1c9d
[2/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic generation
      https://git.kernel.org/kvmarm/kvmarm/c/d1a0eb124c44
[3/7] arm64/sysreg: Add CCSIDR2_EL1
      https://git.kernel.org/kvmarm/kvmarm/c/8f407d6a15f3
[4/7] arm64/cache: Move CLIDR macro definitions
      https://git.kernel.org/kvmarm/kvmarm/c/805e6ec1c5e0
[5/7] KVM: arm64: Always set HCR_TID2
      https://git.kernel.org/kvmarm/kvmarm/c/8cc6dedaff42
[6/7] KVM: arm64: Mask FEAT_CCIDX
      https://git.kernel.org/kvmarm/kvmarm/c/bf48040cd9b0
[7/7] KVM: arm64: Normalize cache configuration
      https://git.kernel.org/kvmarm/kvmarm/c/7af0c2534f4c

--
Best,
Oliver
