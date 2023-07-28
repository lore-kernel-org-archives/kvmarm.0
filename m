Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE2DD304
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 11:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613E0C433C7;
	Fri, 28 Jul 2023 11:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690542292;
	bh=vVWkci1WwNLwwdMkSRyKEv2sVf5zEl+LCr+XUX42JUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plphevbzTjSV37PCFXvsNQlzC/EvZJRTZScGE9bIM/OQ2xl97bUbgVy6hpMNnnv/4
	 XlnX/pACjixCo6RKsp0M/DgKm0XF6WN0ddA2Hxl8fRIeqsvZSmvXbMyctQLkbTJr3s
	 SCM/YC8jlQ07NiIWlVl5pwBbnnrnmJvPQjgJV6BC75B0iztsF2AvrXCqDWd1rGSomt
	 S1C8bBFSyXAYSNnoqch1jD611+ohDyuvuFPX2h5n+2tubtTpdecjQa6K/j2I613Mij
	 ad+H9p+G6ku4iu/21smstd7ywgZwAeainC+lYpJ28jvFmBiX2qaOselkQlt5tPYXwz
	 8O6+fWKlvGUYg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qPLH8-0003KT-BQ;
	Fri, 28 Jul 2023 12:04:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Shaoqin Huang <shahuang@redhat.com>
Cc: Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] KVM: arm64: Use the known cpu id instead of smp_processor_id()
Date: Fri, 28 Jul 2023 12:04:47 +0100
Message-Id: <169054228043.973403.12196964393493377750.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230727090754.1900310-1-shahuang@redhat.com>
References: <20230727090754.1900310-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, shahuang@redhat.com, will@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, suzuki.poulose@arm.com, james.morse@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 27 Jul 2023 05:07:54 -0400, Shaoqin Huang wrote:
> In kvm_arch_vcpu_load(), it has the parameter cpu which is the value of
> smp_processor_id(), so no need to get it again. Simply replace it.

Applied to next, thanks!

[1/1] KVM: arm64: Use the known cpu id instead of smp_processor_id()
      commit: 1ba11daef0a9b062e40b5393d285c82ab6483730

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


