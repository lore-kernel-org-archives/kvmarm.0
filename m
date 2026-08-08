Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE67262D0B;
	Sat,  8 Aug 2026 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786214144; cv=none; b=mCAZQdG2TWCRtBpRgkcFa4KwyjZMdbbFeI/Y1g3xBBl8B5+gAGvTQWOox6WUY+m8E3fURcKTpVcwhzl0yDr7SEM/F1uyfigIyFske5IDc5NSVKnkU1823ir+s4d3McU7NriyRIn8UN8aHQ52NMq4mqY7Ci9PXDvBfTeAOmDOAHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786214144; c=relaxed/simple;
	bh=YlwDGxpIpwXEGLMLSrbgYXZuzgwJz6PNF7DcI+4csAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QMDG4YfW9TmwcZ9iKx4Zm/SbIfOMlz0NMnOdOrFWWcB0iecr9w5+brIOYYkV2kr8TDdBtSoIZ3wiBwTVMgdq0fnrn1n1BEIiLtS1I2jHjE3cO4t7p78RXd0zSskrGozcp5+0KlPUpJsJnISGcH6h2NyCAO/BdREzw09wSvyRT6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PL3wae9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PL3wae9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4637D1F000E9;
	Sat,  8 Aug 2026 18:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786214143;
	bh=bJwrgY6xFSMePlSsx9wyS7H3bTpR++X2AOvZVpByx9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PL3wae9qqhBv8Xl37xN/xlKZKxrn61617gO/RBy+LHjrONvkuR1yTfaAi8cfRfXiJ
	 od4RrqoGaYT/MP1kAvpvA/gRrlvk6TvEKX73ayZLvADll7gFFGblI+SqDD6OeUkwq5
	 tqyXyNzaAJ6HOF+u1j8VHHkgWlinDGqKvZYPWM1JRgr7xes4DMk68dQndeqhNBvLd5
	 yKJDXbWGT8/55Fne1keEeYUQjWXMP1hLWRvXc1myMOwcZbO+TUKFr0bhZwdLIOP/Bg
	 lX6QzyrF38/agspDV51o8wFGBCpC3ME/fR5Y+pK3Pg4cZkWRp9HfeS0/PaNGbLT2Dp
	 TC//V+6TR354w==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: arm64: vgic: Fixes for ITS table save and init retry
Date: Sat,  8 Aug 2026 11:35:38 -0700
Message-ID: <178621413198.380376.1272590130654213471.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260807104102.2410744-1-fuad.tabba@linux.dev>
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 07 Aug 2026 11:40:58 +0100, Fuad Tabba wrote:
> Respinning today since I am travelling until the 17th and will be slow to
> reply.
> 
> Changes since v1 [1]:
>   - Patch 3: check the collection ID with vgic_its_check_id() instead of
>     bounding the walk by the table size, so a collection the table cannot
>     address is not saved either. Retitled to match. (sashiko)
>   - New patch 4: skip the ITEs that are saved as invalid when computing an
>     ITE's next-event offset. (Oliver)
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT save
      https://git.kernel.org/kvmarm/kvmarm/c/c6c156d931c3
[2/4] KVM: arm64: vgic: Don't leak the SPI array when init is retried
      https://git.kernel.org/kvmarm/kvmarm/c/52d044d6e76f
[3/4] KVM: arm64: vgic-its: Don't save collections the table cannot hold
      https://git.kernel.org/kvmarm/kvmarm/c/9b10fb74e4b6
[4/4] KVM: arm64: vgic-its: Point saved ITEs at the next valid entry
      https://git.kernel.org/kvmarm/kvmarm/c/ad1e686e2378

--
Best,
Oliver
