Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E1E347BDB
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 18:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774635223; cv=none; b=tQaqKReWK2bL3MH6V0CHEI4stXvliEi35qn0Ns63yNFhvmHkqu5Tf4DJw25NoKEZM1Njij/0T1B9NCZyzrsMPVEAaSGbUvVag6Vg0o+w7DFe+PgXp1NDlphHiqzLMzg11Nm3xX/ee0LKVl2KNle1XjLwaaeifKKPjuublHBjSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774635223; c=relaxed/simple;
	bh=368mPLXc9JyM0HjsQfm0Fgy565wxp0dKv4mk+E8MWN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BRUATvdiEyW/pCTzTRrZ2yrq0ad2ji73o5KBiW2QOBmOL+GK9CIicS+XpuyKTUQIULCB5fJuF2Qi09PFMKL/TMia+rS7XFZzkr5QhmPzH2kiKVHNsUvkc6JjyibRFMJ561hzTaWU2PLcu2Z83euwzBMDdS8YP7yAaPqMzNikHVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaOY2uaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaOY2uaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01347C19423;
	Fri, 27 Mar 2026 18:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774635222;
	bh=368mPLXc9JyM0HjsQfm0Fgy565wxp0dKv4mk+E8MWN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GaOY2uaQ0Uyjv+zfwm7wl7Al5M46tHMtJ/uzYECADjqpSw/x0y4rYlx6Xu3l1y8Uh
	 UsOtzpSg75YFz+yCjaaXlpVge7C7hc2Z7EcamBgcD8QyWCoVHoOHwo5+axfiLEAIpD
	 ENL5lA24cgY4bYHA5AciicMtv58Dc26G/DzcgyXto33OrV/MNudgxMgXA+S/72+sRE
	 DAKniMdUe/SN6Q73+S+Kgoc0xE+SCvLBnhrK1qO9hbqQSdcxDHM82jbUv45La4OhcU
	 LsN/iFRTS2nlJjJ/3OTssSfwR7oyk274buFNbKrC/vQKL6q/wx76yabCPzuFZ5yfIN
	 yGj1apjzgqsxA==
Date: Fri, 27 Mar 2026 18:13:36 +0000
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v4 00/38] KVM: arm64: Add support for protected guest
 memory with pKVM
Message-ID: <acbI0KbctmKQR17F@willie-the-truck>
References: <20260327140039.21228-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327140039.21228-1-will@kernel.org>

On Fri, Mar 27, 2026 at 01:59:59PM +0000, Will Deacon wrote:
> I fully expect to send a v5, as this is the first time Sashiko has had
> a chance to chew on this and I'm expecting a roasting.

After going through it, the report isn't as bad as it looks and some of
the comments are actively wrong, which I suppose is inevitable.

That being said, I've got a handful of fixes to fold in now and it's
pointed out some unrelated life-cycle issues that we want want to fix
separately.

Will
