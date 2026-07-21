Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD5A3DD870;
	Tue, 21 Jul 2026 18:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658391; cv=none; b=M5zQG5zVxvR7Zrnl1Gr/5O2+7T76+os8F4DEfspNFbf2HC7jkLu9eAWY+DM3vr1q9l0XSEtljMQPeGfyR86ofioemqOtGBiKD6kS5Cvt+z9auYhEg7DJT8d1JZon2caYIXYFQAmhltWJGlfmmZlyPk7C6VG8OFak8ztRFc0WJkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658391; c=relaxed/simple;
	bh=FNm5chTJVMPhUGhUi36rUMA8wLOlzFuIbdbaU489IE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GCMzYm+dqwhHCov27nZhd7DXsbYwnODxk1cWavODSzFlMtxkk+E/Ex475Uup+25LsKjOMhGIHqqDbbYEE11CgWQ2qj/sg8k6oH6rrG5+UXkrNUBdDMPhElWRYtokd1oZVM5bRqwNgo2BAm7lnB77qK6HJfsJ913KZfd5e5dlo2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjFng8c+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjFng8c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051AF1F00A3F;
	Tue, 21 Jul 2026 18:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658389;
	bh=k4VW3Zl4tM8OMhekRjLVwl1T8VLsGUrJuwlMfWx5k8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjFng8c+xvne2cPnxtse0Hq0rrqrs24bVcFmakyTk1pzLZYgOeEuvfzKiLrrEOqYD
	 RSJH9GITWED9B6WMRRzFISbdeGGj+tRAt+91cM9dnJ0OuJsItKumTQzE2JlrjHn3+6
	 70gSPA6dKhlKckr7xiGNDyTVYd51+VAW371DA07gGdk6/RAcRUeRCIB+39mIM1wUEi
	 1CmYxvkw+M6W0Z69u/BMg8lDrJyBCbk1O00Os2M3OVnJh18NVZT/9j8c2G/2dcT2IY
	 wmEJUElK+RRAS/kQ+d9YDaTjD0cwUCjVMOyaVUMhjBvrP6NF0OmLIjgrWUOa0Qk1De
	 MIhZQ/ULYij/g==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Sync SCTLR_EL1 when injecting an exception into a pVM
Date: Tue, 21 Jul 2026 11:26:26 -0700
Message-ID: <178465838257.2067495.10864103489169140924.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721161624.3983041-1-fuad.tabba@linux.dev>
References: <20260721161624.3983041-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 21 Jul 2026 17:16:24 +0100, Fuad Tabba wrote:
> When pKVM injects a synchronous exception into a protected guest,
> enter_exception64() reads SCTLR_EL1 to set the new PSTATE's PAN and
> SSBS bits. pKVM refreshes VBAR_EL1 from the live value before injecting
> but not SCTLR_EL1, which is untrapped for protected guests, so a guest
> that updates it and then traps takes the exception with stale PAN/SSBS.
> 
> Sync SCTLR_EL1 alongside VBAR_EL1.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Sync SCTLR_EL1 when injecting an exception into a pVM
      https://git.kernel.org/kvmarm/kvmarm/c/596289fe4836

--
Best,
Oliver
