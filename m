Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC124AF699
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 22:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789511149; cv=none; b=umuVqGc69nADAZt7nlAALh6pcZMH7yKMp8Z/Tpa0fWmKBvv50Uwcw6odedrr292p4YgQUJL6w792DHUi3SdWrxhLeJKRZ34asvxKL+ksd87UVkT3ztW1t8HcE5Gi7pKOK06XG6nvtmfr0U72qu6xGL77wXukhIiTx1LQdUMgV4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789511149; c=relaxed/simple;
	bh=uWTqTPDCAXM5IWq3Fj2yesrE3gBlQeLGkGIlFlyq2a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sJi9OoWna9uLEs+d+aIbATS4HnbgigPxtEChsL9hNWvTDdPnV2rDT6wZTEweHx0G9oIV/FynDMcqLAKjsP5Ja+Fn9S7gveMF/gtotUZyZA92ZrKqNa1GtWFXXGg6mglKvYtiDVHmN/CRDUtEdcIPjhXAZ1FMZa1vwoCfy2HqF14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmOrM34X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmOrM34X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8D91F000FF;
	Tue, 15 Sep 2026 22:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789511148;
	bh=bYnUPdhAHL+R5VtXzqTnTSjG/gjtRhgRQcO4zt1laKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmOrM34X8kSXcJ3Pk4wsrMaEHXW4Xf2x/ujTuvKqFWAX1Hsi8QafoM3nvwJgCboTY
	 K5XauLr1F6se4Gb9JkJQbzvx/mHQuSaT9IYaKuauVzTWafaLelvbwheotu7psm+ACd
	 xWnEjrj0ZCt5vbBB1AkJ1x5hs90K+WGUFjQ+8dyekMJjxPGrZTXB6NF6S5QVyADmvC
	 bCeq9ozVk4RxV+IUoFYzKbXAfwDv4Sf2tkACqTHz+0zhTWX5c/UodqBd2xYzcX+AjU
	 9b4dpteRi/aAL0paGT+XCnqi8v/iIBiRles2MKpO02pa1pnCrquI5CcUz24UosX14i
	 GwrjecUpbXN5w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	ljs@kernel.org,
	Shen Yongchao <grayhat@foxmail.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v4 0/2] KVM: arm64: nv: Shadow S2 life-cycle fixes
Date: Tue, 15 Sep 2026 15:25:39 -0700
Message-ID: <178951103695.10790.16480585864546668236.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911162203.1919330-1-maz@kernel.org>
References: <20260911162203.1919330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 11 Sep 2026 17:22:01 +0100, Marc Zyngier wrote:
> 7.3-rc2 has introduced annoying conflicts with this, so in the spirit
> of making things a bit easier for Oliver, here's the version rebased
> on -rc2!
> 
> * From v3 [1]
> 
>   - Fixed spacing (Wei-Lin)
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: nv: Fix life cycle of the nested_mmus array
      https://git.kernel.org/kvmarm/kvmarm/c/33346f8960c7
[2/2] KVM: arm64: nv: Delay freeing of shadow S2 structures until VM destruction
      https://git.kernel.org/kvmarm/kvmarm/c/e5843f4effaa

--
Best,
Oliver
