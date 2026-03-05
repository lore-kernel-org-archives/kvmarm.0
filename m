Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5A53ACA51;
	Thu,  5 Mar 2026 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772724008; cv=none; b=X8FXAsACXhAaoKhTdghMFHMm0O+DXpikv0Z3J6P2OxRxLZ/Y6fa9zCWiZhq2nr1yluhn7cfSusHeExxyB41ZeuaUBrPiBdwzrcroLg/7h32tdr1N/u3e+aoRC1OTXtNOvZaRnAfI7LmEhLHbDRyB/xpqQQgWJt3axDu7nR4FszQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772724008; c=relaxed/simple;
	bh=2Q8/O9auZdr51ye5A181/o/Z6f3MOFDJFJzm8s1nY7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r78tFunWJAODwmoPWr9Pc5b8B6RbZF9MZeeNKMRH3BGtFr66KC2ur4jeS0ZKKcvA7OvXlxAwb+dIbYBPeTJn9eef97Kc6XADuQe0//C7h7Ez87nITyZNT/TuSk9Ys7X7JgMW2Xho/O0Phj3xR2kkMkJXte3izVvA89CRj97L4Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPnX4yzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPnX4yzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB17C116C6;
	Thu,  5 Mar 2026 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772724007;
	bh=2Q8/O9auZdr51ye5A181/o/Z6f3MOFDJFJzm8s1nY7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPnX4yzYKs5I7WCgazm2fb5Z2czxv+OpSi1+2UsJa2lil40dbj3p7+cBa0wXpUc3p
	 Y3GWzz7GbO47wsAi32N24wwhxVIiiquyNL2a+Y0XYznsuS+JyJOzzz+4oAReQopKox
	 WgX5RofM8zN4/WB3WFql2VVz1ptJeNPCpOaNCqC69X55LcNYHgFFUWNW5jlMT1KpLv
	 dFt0XOxjtj4z6Wcet1rdIhG3x18zIYO/LvbHpYiOGzR9/c3O9xjIEyJy7aaLLX6WX9
	 AhUHWCWYbzCFgjyF0jkEtITlApC5AMHbdYMd/3b4XVPPCpni18B0Kj+u1EPJwF+kM3
	 /z4rZp1jwipJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vyAUf-0000000GVIq-0Fim;
	Thu, 05 Mar 2026 15:20:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Quentin Perret <qperret@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: pkvm: Fallback to level-3 mapping on host stage-2 fault
Date: Thu,  5 Mar 2026 15:20:02 +0000
Message-ID: <177272398043.2929264.16877917398365629675.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305132751.2928138-1-maz@kernel.org>
References: <20260305132751.2928138-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, tabba@google.com, qperret@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 05 Mar 2026 13:27:51 +0000, Marc Zyngier wrote:
> If, for any odd reason, we cannot converge to mapping size that is
> completely contained in a memblock region, we fail to install a S2
> mapping and go back to the faulting instruction. Rince, repeat.
> 
> This happens when faulting in regions that are smaller than a page
> or that do not have PAGE_SIZE-aligned boundaries (as witnessed on
> an O6 board that refuses to boot in protected mode).
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: pkvm: Fallback to level-3 mapping on host stage-2 fault
      commit: 8531d5a83d8eb8affb5c0249b466c28d94192603

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


