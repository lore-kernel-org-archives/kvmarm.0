Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728D230C614;
	Sat, 10 Jan 2026 10:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768040591; cv=none; b=c4t7LuLT8jE4oPHcVQPXmPHQzXPzNvEHQrrGUNGmwmDHpb9LRUrix6o9c4JYiDR85HHcggfnzO2iI/iMUbQ2j2lTOQDxlttOg6XPPVdPNkfXr+D1KUeXgZrL6kW2AzXGxBVTP4t7/Br/z6hEmQGl9AgM3Ho1i5et0YmEbp2eyqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768040591; c=relaxed/simple;
	bh=x1R2CiJTofSGb1wbzQo0MhyOntomIAOg6p8X4Rkq9nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nmoStGZpL8CnyxyDW8WYseVKHAsi34gvRiv9VhyDkVWkcNwJXC32xEzvPKJCx5YeMnadV3HgoJ5G/U+odfE8sXYHjTXkh1Xx5cUf5lq6VS60rB1UrwWbZsLBtVHxh4qTOwRO2F1z2VWqGEU9DM333SzeBG8Cqktbh4vZRZOm4xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EGM0X+L2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGM0X+L2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A371C4CEF1;
	Sat, 10 Jan 2026 10:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768040591;
	bh=x1R2CiJTofSGb1wbzQo0MhyOntomIAOg6p8X4Rkq9nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGM0X+L2lyQXal7rgHv5aZjdWukK/d3VbSx1D7lO+CfwKF10GOgUAFD+fv7xyQI9O
	 zCTQVjCSQYitpSwSW/xMX8vOl3YSImaV9L0Vv2HeIYvwsqV0e0s84Q1vHK556zvwks
	 Y3s49PWTyGnbT1bqP5f0G7pCbZSd/tBa903Mag6rxLi8jH5NTf6viNuFbVNGMP6zPC
	 avL4/q+UqIhntPjhuYn1ZFvhvoEeV5oA4n+PJbykKrVkdBG6IAKb4tDS+UOMgGGE/V
	 m/M3M7ggKh45wUhWEwQ/KP/FlT4Vlp40K5V2zP5Sr3OaUDWSTRU9VnV0Lc7ZOH/2+F
	 n88AmbgZssUkg==
From: Oliver Upton <oupton@kernel.org>
To: maz@kernel.org,
	yuzenghui@huawei.com,
	Dongxu Sun <sundongxu1024@163.com>
Cc: Oliver Upton <oupton@kernel.org>,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Remove unused vcpu_{clear,set}_wfx_traps()
Date: Sat, 10 Jan 2026 02:22:47 -0800
Message-ID: <176804045758.916140.10135951232843494446.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109080226.761107-1-sundongxu1024@163.com>
References: <20260109080226.761107-1-sundongxu1024@163.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 09 Jan 2026 16:02:26 +0800, Dongxu Sun wrote:
> Function vcpu_{clear,set}_wfx_traps() are unused since
> commit 0b5afe05377d7 ("KVM: arm64: Add early_param to
> control WFx trapping").
> Remove it.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: Remove unused vcpu_{clear,set}_wfx_traps()
      https://git.kernel.org/kvmarm/kvmarm/c/9cb2c20f06c3

--
Best,
Oliver
