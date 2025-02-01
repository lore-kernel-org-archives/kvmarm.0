Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C45433BE
	for <kvmarm@lists.linux.dev>; Sat,  1 Feb 2025 09:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738402412; cv=none; b=taPajylfEzIItDbbmWsL4lfTtgFwDBWJ/Iu8zXCazPj0etNoi87EcmZkM+7wwpnOzt1XbOrpj3VcUEMyEUa2gsvWfjkC8JIfCJc0CeIAnz4VJ8D+APztfIFFD19peL02klEhTBmrDHGrgrMolZOJWgdeTj+3QtloMtczwadbLUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738402412; c=relaxed/simple;
	bh=WG3N2gS1K2wuUo9FxR/FsuVxcrdwsyirnrJrRwkKJmI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jXc3yZObDfWg+dMYiEnyBYd1wvNdN3DRcXYFZOUoSUCrWn3vB8l5poGnyCE0Au/QLt1PN8r+sP/iwJbTU7vss6YDJ0UxG8romRyhUrdN/HkEInYSHNis1MkIsuesm9uoqtIK1vhzOLIsTjYh4BW7FMp0iaLwAHj20xn75lGxLKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ThoCHIGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThoCHIGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FA6C4CED3;
	Sat,  1 Feb 2025 09:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738402410;
	bh=WG3N2gS1K2wuUo9FxR/FsuVxcrdwsyirnrJrRwkKJmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThoCHIGHsy4X+oQ//CuRnu0Krjf2A9JhiUstvLIPcS6xVn6WZywWa4NaiCGl2UTWP
	 iu3NWjGim/xb2/nY/w/Nb7MWWjkDMtcGoJSOl2j2fMh3QF8gkT2BWK48/yI+lK0mne
	 FTzc22FfZyobRqqshrIPVstr/zmHzhxotzDZ5c7RJeAhp0SpYh+5T/QXnVa1jHUkYT
	 XazH0biRxkQAGtwt45uhO+9WIdKs24UC1yt8Ee4THWbB08/rlAxQQpC9r+wMw+kYr1
	 pei5KJZfnHFUL1bxpNd4sm59ujaCtOX9XSLUn+oYvf2B7oH3c5d5bBU2HWceNKxIyK
	 WqdcLwgFPnPIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1te9sW-00H4kw-Eq;
	Sat, 01 Feb 2025 09:33:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Flush/sync debug state in protected mode
Date: Sat,  1 Feb 2025 09:33:19 +0000
Message-Id: <173840238675.100644.4779940459529261131.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250131222922.1548780-3-oliver.upton@linux.dev>
References: <20250131222922.1548780-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 31 Jan 2025 22:29:24 +0000, Oliver Upton wrote:
> The recent changes to debug state management broke self-hosted debug for
> guests when running in protected mode, since both the debug owner and
> the debug state itself aren't shared with the hyp's view of the vcpu.
> 
> Fix it by flushing/syncing the relevant bits with the hyp vcpu.
> 
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Flush/sync debug state in protected mode
      commit: 0f1a6c5c9784eff7e31e4915e17285fb89ad3644

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


