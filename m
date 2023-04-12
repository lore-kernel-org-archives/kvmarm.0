Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D05F20EE
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 16:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CE8C433D2;
	Wed, 12 Apr 2023 16:36:51 +0000 (UTC)
Date: Wed, 12 Apr 2023 17:36:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 04/12] KVM: arm64: Add new (V)TCR_EL2 field
 definitions for FEAT_LPA2
Message-ID: <ZDbeIBqT2CVrs4A+@arm.com>
References: <20230306195438.1557851-1-ryan.roberts@arm.com>
 <20230306195438.1557851-5-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306195438.1557851-5-ryan.roberts@arm.com>

On Mon, Mar 06, 2023 at 07:54:30PM +0000, Ryan Roberts wrote:
> As per Arm ARM (0487I.a), (V)TCR_EL2.DS fields control whether 52 bit
> input and output addresses are supported on 4K and 16K page size
> configurations when FEAT_LPA2 is known to have been implemented.
> 
> This adds these field definitions which will be used by KVM when
> FEAT_LPA2 is enabled.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
