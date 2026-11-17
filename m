Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794952649;
	b=d5uw2YfadsYmQe66mdhAEcMaUZKfW+AIc2sVWDlIlK7bhMinIvQnJIjGc+VDGB+SZfVI
	 3MsOexKTM5ejthRjeqHGGWDt4vTWeLQxzQArMWxfkQSOiHaCj6tqC3iQrkauR+nt8QjzH
	 cRVEwO2LqWLDP1MrQd3PTdd9bzKXNFR0YCUk3Hcr7KH3Ey5fy4EHdHeKjf3I0Mj7rh4cg
	 LVedr42tv8N7py4pGL0898z4RmjwKBuERi2RIOf4CAIQO4PZA12chS3Q0lmcJYgZk3jKP
	 38FZSSihJRNmkyi8LvbBz1Hj+MwN2F9i5N0pthMYi7KShO6zabnu9ofTMnr49q4ypIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794952649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=9eUiTKQ0nxnwd/hB/hSh3Zzj2FjaTsifeHHHck1wgfE=;
	b=oF41KJe4Z+EGjr17jVS8T9OI9AFEfJyKn+9bZT9C50MDzWjWLq1cTDbkoYNUsWDF53R6
	 Kf0ln0IYZl+OXhmQtwfWIhUrDdElrds+Y6JDmOQm+b3G7wzoy4uvkI4vMRATCwd3HFx+H
	 88ON2r/2/+EbxiWYZtgva2E0ZpxK1zZ67g6l5wjmKY7cCpgbOAgkIGEexDI5Lw6VKtP+b
	 xrCe4Vrl/s84y/uBayLm3UTk0ttDWcbQMkCFLupOpfbNeZSt1P0k2B9fJu/e7HriSjSvK
	 wSVUu2K5QXiRTrzfyhfHoYJwLTPGqoYjJhtRRjajrveTuVXPBR0BWxDRziISj3J9lsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nqkMprSp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F21606A31C;
	Tue, 17 Nov 2026 21:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nqkMprSp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45A61F000C4;
	Tue, 17 Nov 2026 21:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794952649;
	bh=9eUiTKQ0nxnwd/hB/hSh3Zzj2FjaTsifeHHHck1wgfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqkMprSp2bn3gUIYtVrexrmOH+LRBuDfiP+xNOhum3seJBkAi6J39qXyHNBVLAJ14
	 49IX3wnh/UQESA8lMe3WJigCG7qVrKJmQBhQXBvcTAham64iih1Ny3wGHDA3bPXdjA
	 OOaGdXKYzpStgWleIH+oN6dfa1LCGyLfUMhZDVr6B/FlKY5fJ4xxLQ/REP3NEPT+SL
	 SBPo1ZTIMl20TtNT1HbrQP3TjJefSk/j++wwBgz6L/FJSRdDtKZINrYaR8W0Tgg8Rl
	 1NTNfdb86I0f2dPXgjiaG1VbN2gEZfIA6yjEhvCx56iWOuReNQDA59K7j/A7zMVQsT
	 pMCSbf8ZlGKaw==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 0/2] KVM: arm64: Stop stage-2 teardown scaling with the IPA size
Date: Tue, 17 Nov 2026 13:57:23 -0800
Message-ID: <179495264130.1456871.12453105511491068179.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106133000.453240-1-fuad.tabba@linux.dev>
References: <20261106133000.453240-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 06 Nov 2026 13:29:58 +0000, Fuad Tabba wrote:
> Changes since v2 [1]:
>   - Return a failed walk's error to the callers and warn there, instead
>     of inside the walk. (Oliver)
>   - Dropped the comment on the next-mapping lookup. (Vincent)
>   - Collected Reviewed-by from Vincent on patch 2. (thanks!)
> 
> Two patches that make stage-2 teardown take time proportional to what
> is mapped, rather than to the size of the IPA space as it has since
> 4ddfab5436b6.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Resume stage-2 teardown where the walk stopped
      https://git.kernel.org/kvmarm/kvmarm/c/6607becfb034
[2/2] KVM: arm64: Resume a pKVM stage-2 teardown at the next mapping
      https://git.kernel.org/kvmarm/kvmarm/c/737a5ff38ccd

--
Best,
Oliver
