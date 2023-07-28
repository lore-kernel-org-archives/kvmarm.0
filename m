Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF8B13AF4
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 14:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA60DC433C8;
	Fri, 28 Jul 2023 14:15:02 +0000 (UTC)
Date: Fri, 28 Jul 2023 15:15:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 08/26] arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
Message-ID: <ZMPNZKXHgbgAWj1v@arm.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-9-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728082952.959212-9-maz@kernel.org>

On Fri, Jul 28, 2023 at 09:29:34AM +0100, Marc Zyngier wrote:
> As we're about to implement full support for FEAT_FGT, add the
> full HDFGRTR_EL2 and HDFGWTR_EL2 layouts.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
