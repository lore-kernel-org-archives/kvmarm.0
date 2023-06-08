Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEC810973
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 17:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3B9C433EF;
	Thu,  8 Jun 2023 17:39:56 +0000 (UTC)
Date: Thu, 8 Jun 2023 18:39:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, broonie@kernel.org,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
	coresight@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 00/14] arm64/sysreg: Convert TRBE registers to
 automatic generation
Message-ID: <ZIISaXnrhDtauY2G@arm.com>
References: <20230602062552.565992-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602062552.565992-1-anshuman.khandual@arm.com>

Hi Anshuman,

On Fri, Jun 02, 2023 at 11:55:38AM +0530, Anshuman Khandual wrote:
> Changes in V2:
> 
> - Renamed each individual TRBE register fields as per auto-gen tools
> - Converted each individual TRBE registers as per auto-gen tools
> - Added new register fields as per DDI0601 2023-03

Mark had some comments about using Enum for some bitfields. While not
essential, it would be nice to have those fixed. It's probably easier to
do an incremental patch fixing those, so please post one (or repost the
whole series, whatever is easier for you).

Thanks.

-- 
Catalin
