Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C7A405DD;
	Thu,  7 Dec 2023 13:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC8AC433C8;
	Thu,  7 Dec 2023 13:37:24 +0000 (UTC)
Date: Thu, 7 Dec 2023 13:37:22 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
	aneesh.kumar@linux.ibm.com, broonie@kernel.org,
	dave.hansen@linux.intel.com, maz@kernel.org, oliver.upton@linux.dev,
	shuah@kernel.org, will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 04/25] arm64: disable trapping of POR_EL0 to EL2
Message-ID: <ZXHKkslcDy930IC7@arm.com>
References: <20231124163510.1835740-1-joey.gouly@arm.com>
 <20231124163510.1835740-5-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231124163510.1835740-5-joey.gouly@arm.com>

On Fri, Nov 24, 2023 at 04:34:49PM +0000, Joey Gouly wrote:
> Allow EL0 or EL1 to access POR_EL0 without being trapped to EL2.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
