Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037612137B
	for <kvmarm@lists.linux.dev>; Mon, 25 Sep 2023 15:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C89C433C8;
	Mon, 25 Sep 2023 15:59:15 +0000 (UTC)
Date: Mon, 25 Sep 2023 16:59:13 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Clark <james.clark@arm.com>
Cc: coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, broonie@kernel.org, maz@kernel.org,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@linaro.org>, Leo Yan <leo.yan@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	James Morse <james.morse@arm.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Rob Herring <robh@kernel.org>, Jintack Lim <jintack.lim@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] arm64/sysreg: Move TRFCR definitions to sysreg
Message-ID: <ZRGuUSkwKqeZ3+ot@arm.com>
References: <20230905102117.2011094-1-james.clark@arm.com>
 <20230905102117.2011094-2-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230905102117.2011094-2-james.clark@arm.com>

On Tue, Sep 05, 2023 at 11:21:14AM +0100, James Clark wrote:
> Add separate definitions for ELx and EL2 as TRFCR_EL1 doesn't have CX.
> This also mirrors the previous definition so no code change is required.
> 
> Signed-off-by: James Clark <james.clark@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I assume these patches would go in via the coresight tree.
