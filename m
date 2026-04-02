Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC1D277C88
	for <kvmarm@lists.linux.dev>; Thu,  2 Apr 2026 13:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775137036; cv=none; b=OEDH2e6qRlEZQseAefANRh/xHfIYyTxKtErNCm+fgN/TI/swQTKz5lFaYTB/0p3Xcb1Q7KxLsoD1jgWnR6uUl83W5G4IzhH66kZc8hQAfAfhQD4dKlcsDwjczzwv5YkwE2k9z582+erjEP4TyKBy1m4TaPn+5I5iYn9ongTSuqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775137036; c=relaxed/simple;
	bh=MyNeVdgyiXEJqvB3NK6VP2qV2/pOvYxFXY/49r6TRK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=azu4EcWh1Uoh7kQ98rHjUbL/Ebx6oMBPCll48bvyWSa1AphEaKjH0p2MUKR0nfbb6URsJGS5RA4vE5t0C2ayE832hnNjjlHNqk69bhvNGIL4pyMOOGQou2U98vXiI39GUAuP0qtA0mcb05qhIgZLOdWPehIm5z43jisD3A/IO7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qqzyr6BT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qqzyr6BT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92ABC19423;
	Thu,  2 Apr 2026 13:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775137035;
	bh=MyNeVdgyiXEJqvB3NK6VP2qV2/pOvYxFXY/49r6TRK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qqzyr6BTIGFvgYtHP5DyD71QAxT5GHKtDXUOjPbWn04lCkHcwHP49YvA/6wxfCaPU
	 AqFaoQqH/B8kckrM4sED5ueV8HHjZJpe2oR2YRfYrPwMqT91sGUX47vVFysoViKDaq
	 0YsBkEsi5+HiW31kUMVTm5G9PHUwlFPErmcT4Gi03Vwu+9B4ViSW2rIJ3U1U8XJwYM
	 0bNTAQ1gI3vE0mb0sPi8d5V9oHVL8IfHtgtuuf6LiAfOMz+WEF57Cs1oHK1e3dZZav
	 fqD9WCyo3UAS5z+HxKJeKRKsNB7uIPJmjGZfSlPTrFfXB3sERrgEZI7WwLZSnHjkgb
	 BID7wNb23uvGg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w8IET-00000008H1L-32Ho;
	Thu, 02 Apr 2026 13:37:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: selftests: Avoid testing the IMPDEF behavior
Date: Thu,  2 Apr 2026 14:37:10 +0100
Message-ID: <177513702840.453314.18229449819566784185.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317131558.52751-1-zenghui.yu@linux.dev>
References: <20260317131558.52751-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, zenghui.yu@linux.dev, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 17 Mar 2026 21:15:58 +0800, Zenghui Yu wrote:
> It turned out that we can't really force KVM to use the "slow" path when
> emulating AT instructions [1]. We should therefore avoid testing the IMPDEF
> behavior (i.e., TEST_ACCESS_FLAG - address translation instructions are
> permitted to update AF but not required).
> 
> Remove it and improve the comment a bit.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: selftests: Avoid testing the IMPDEF behavior
      commit: 03db5f05d4c76d76b32a9d26001e2ec6252f74f8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


