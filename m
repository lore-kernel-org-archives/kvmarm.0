Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E057B
	for <kvmarm@lists.linux.dev>; Fri,  2 Dec 2022 11:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0C2C43470;
	Fri,  2 Dec 2022 11:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669979876;
	bh=+Z1MWlojIRA1QnTq1ioenobi9ADsvAqAO/dbKIkbqjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HubRNWXyGURblb7IaT99ORDq0RAytki48Py2iNBMKtLeEmIUw5kIR4/XIgr4IAHnb
	 4T5KMpEae2eaNa7TyLUEd6Jf5aJxTwdPg3i049crdrYVGshKHGxlyW8UtpX2tYvM3N
	 iUaVu3gx+8/Wg+/HfEeH6INCWGDqyTf/dl3s6olUARfaU0Octbd45SN+lSvEgHdF/x
	 hSF/nIr0hi/kFUbfmn6f6jmSDB146ZbSOK6oIw0gs0G93El+mNtgNAG1RLHrs9/YE5
	 +FsQzyQI9l1Tjaw810VXs/t3Dr/GHcC7x9Cew+fzI95CBaRFe+edZLpDXN6ISfoc2r
	 UvUHlrSFy6Vpw==
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Quentin Perret <qperret@google.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Andrew Walbran <qwandor@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] KVM: arm64: FF-A proxy for pKVM
Date: Fri,  2 Dec 2022 11:17:43 +0000
Message-ID: <166990989276.390165.11951641189203574187.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
References: <20221116170335.2341003-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20221202111743.tXMu0BPJUgas6VKTY8iULp4p-_2Tq2-UUkZDPYL0rWQ@z>

On Wed, 16 Nov 2022 17:03:23 +0000, Quentin Perret wrote:
> pKVM's primary goal is to protect guest pages from a compromised host by
> enforcing access control restrictions using stage-2 page-tables. Sadly,
> this cannot prevent TrustZone from accessing non-secure memory, and a
> compromised host could, for example, perform a 'confused deputy' attack
> by asking TrustZone to use pages that have been donated to protected
> guests. This would effectively allow the host to have TrustZone
> exfiltrate guest secrets on its behalf, hence breaking the isolation
> that pKVM intends to provide.
> 
> [...]

Applied first two cleanups to arm64 (for-next/ffa), thanks!

[01/12] firmware: arm_ffa: Move constants to header file
        https://git.kernel.org/arm64/c/229d58e31678
[02/12] firmware: arm_ffa: Move comment before the field it is documenting
        https://git.kernel.org/arm64/c/c8e320b00a2a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
