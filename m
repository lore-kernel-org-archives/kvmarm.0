Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0F320B80B;
	Mon,  5 Oct 2026 08:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791187712; cv=none; b=CADeh9gxTKCE3MfbN8oNaYos6ilAajcmn9MtJYMD4CFT8Mh7IH1UGBuuYKBvrnxc+OIfqKEkiZzWuXD5De51pk/nQvKWltOaqQZW78Su0G1jdTTtTFie9pqVV0NGCCVB6OdUfX+incp8lbSkiByNWKHWxUkc9MwzuiNV8RUCbLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791187712; c=relaxed/simple;
	bh=nwOcxLH3Q6mUbHlJpRBPnf70GLs/nZjTxnotzVVRqWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUu3dCpch/dJAnORxqo6XCsecLJ2fn1hTGEr8b7PLfni/T8Wo/ElSFFGFZkgHgjP8a0B7b952J6bezgpZR3pNqCOFwMZzV06ehKpfWWtjks1+ZYLhpFZ63Uz5Yy7Yn1cfJBo4yCDimVGHc63eHuv9uiRQN5aCfV2AfBUB9CbE3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=pc46WDqn; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="pc46WDqn"
Received: from francesco-nb (93-33-55-11.ip43.fastwebnet.it [93.33.55.11])
	by mail11.truemail.it (Postfix) with ESMTPA id 384511FCC5;
	Mon,  5 Oct 2026 10:08:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1791187709;
	bh=D+Y6d8UnrGoNFXVY4j5x4i4B2RwDWSIwdnLaT7QqWYA=; h=From:To:Subject;
	b=pc46WDqn850L7lcIP9Fhgqz50KA3iyT13iys3P83fFFH2WP1JTTiUdlzjxtjMHvVV
	 HCtW83/A9eD1cpccAu9bCoFi7j0aSvw1PCz7wjrMaLb92gfV/RsN5zPJtscGFMubg9
	 /ZOsBaI0zujfilGLjnXmUYIQgnSpMRoEd8ewqvtkR2KzSYgmVqFDG/CjdDsBJ2Doeq
	 O2WWifHY6ZjZMBtZ+WMQLB8d9W7V6g+UOJ/VGVty3Ri5/ppfw9BGBiLUwBJK92vu0a
	 dRA0n3+jy7CbCP75Dk8d+Cuea+2T9TgZEVE/IxwCusznJrIDAZnnQrCsLH7SrmB55M
	 S/AfgUIpKsrjg==
Date: Mon, 5 Oct 2026 10:08:22 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Peng Fan <peng.fan@oss.nxp.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Frank Li <frank.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH v4] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Message-ID: <20261005080822.GA13120@francesco-nb>
References: <20260824-imx8qm-cache-coherency-v4-v4-1-b2e528c7d05e@nxp.com>
 <aqleHm4stDi3Pt//@shlinux89>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqleHm4stDi3Pt//@shlinux89>

Hello,

On Tue, Sep 15, 2026 at 11:02:54PM +0800, Peng Fan wrote:
> On Mon, Aug 24, 2026 at 12:02:04PM +0800, Peng Fan (OSS) wrote:
> >From: Peng Fan <peng.fan@nxp.com>
> >
> >According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
> >suffers from a cache coherency issue (ERR050104). The upper bits, above
> >bit 35, of the ARADDR and ACADDR buses within the Arm A53 subsystem
> >have been incorrectly connected. This causes some TLBI and IC
> >maintenance operations exchanged between the A53 and A72 core clusters
> >to be corrupted.
> >
> 
> Any comments?

Any plan to have this merged?

Francesco

