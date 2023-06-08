Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F3C1993D
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 17:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223B3C433EF;
	Thu,  8 Jun 2023 17:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686245286;
	bh=+jADdraIP3C/C0LYaRgPnoAOfBc8euNvMql+VKzbZjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMopMTpEw1MY88sHfDg3LxPYvEn44+YKq/fu/iWxLNZfhzd0od1p51uRfTNb9jGQ8
	 yGBE189AjrsPlXKuGUSWDxbDnunegO8HOqxxEkP8uYMnnyDRgk4jDP91Q/Pp5Zre6l
	 XPuULczQ3qn+GsZei9z3d5f7Tc3lZqkZ9zaarMasJ1bDc5A6VmxMkHaPYfNXaa6QJ3
	 guJMbvHbxR58xtNTOAJ2e7qT+7FDVW6RTEbJT2Vx/bEwCf6IE/ywDpEZeQ23gxip/v
	 w6RK/uyxjsJrO58x8s8X+m4coUA44FqlmiwYEaQ1FH6tRnjeRSVPeczUUBqoVpmVbZ
	 Mt4ebQeMtAecg==
Date: Thu, 8 Jun 2023 18:28:00 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sudeep Holla <sudeep.holla@arm.com>, kernel-team@android.com,
	kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 00/10] KVM: arm64: FF-A proxy for pKVM
Message-ID: <20230608172759.GC1606@willie-the-truck>
References: <20230523101828.7328-1-will@kernel.org>
 <168611608139.777371.2190834678777367651.b4-ty@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168611608139.777371.2190834678777367651.b4-ty@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Jun 07, 2023 at 05:35:12AM +0000, Oliver Upton wrote:
> On Tue, 23 May 2023 11:18:17 +0100, Will Deacon wrote:
> > This is version three of the pKVM FF-A proxy series previously posted
> > here:
> > 
> > v1: https://lore.kernel.org/r/20221116170335.2341003-1-qperret@google.com
> > v2: https://lore.kernel.org/r/20230419122051.1341-1-will@kernel.org
> > 
> > Changes since v2 include:
> > 
> > [...]
> 
> Applied to kvmarm/next, thanks!

Thank you!

Will
