Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838E7D2F5;
	Thu,  4 Jul 2024 14:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720102663; cv=none; b=ISNPn+t5Pdq+w09dJidiwQOYxB2oxxDLCiYC1lWaIG1fKwPF9TD7FRS5dC+H+WSbHxpEbU732p6KZGug3VCRbhbmgUBZyCR6iNPsc6Lk6nD/gLGDH37kI7Opmlkn4NpFdzQgPLeQ6BdgANrO9+Zsgwdh0/AE3N3n+yNVTBO+uhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720102663; c=relaxed/simple;
	bh=/FzwEx3tCt36dcbi4qSsUug+QZ2Kkb6h8ii4ExQhMxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HE7Z5OAvoZuBAG1wuwXqak8mjPCaK29vVNyYTLYus6y2ns4uo54+Nlri8faWcrcdu37eA679TBZdXNYZgGTclG8gPCsWFyrqRejvkYNhH/K9qWPQfljM8aNQ7HwHRH181vyvekDAkGCvlKfz8jbz/bOwpvTT0mFS1M6Qr2Tbrjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C1EC4AF07;
	Thu,  4 Jul 2024 14:17:40 +0000 (UTC)
Date: Thu, 4 Jul 2024 15:17:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 1/4] arm64/fpsimd: Introduce __bit_to_vl() helper
Message-ID: <ZoavA2rMK2P4qTDm@arm.com>
References: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
 <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-1-c88f4eb4b14b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-1-c88f4eb4b14b@kernel.org>

On Thu, Jun 06, 2024 at 04:21:43PM +0100, Mark Brown wrote:
> In all cases where we use the existing __bit_to_vq() helper we immediately
> convert the result into a VL. Provide and use __bit_to_vl() doing this
> directly.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
