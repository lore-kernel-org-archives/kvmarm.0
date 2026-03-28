Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51C41CD1E4
	for <kvmarm@lists.linux.dev>; Sat, 28 Mar 2026 11:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774696412; cv=none; b=mD6PXE1mRRYxjTN3ak/nPFQCljm/VseN09EZ0Nu32UFPDRoIYS5L4MBbJ+OqhryBW3JjjRzs3N8OpTth8rUQhaK0tEkS9okMoqpgchbOM6ydS0xI9yzpBsBB0Nb3EIskd8iaA3Bjq3d4I4B0XPiO/soFb6mikf0L5l5Hd1ZWTnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774696412; c=relaxed/simple;
	bh=LZvpywDsRxTdCKgR0wUedtBmll3ecpmF+HbZFuxFE7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H/0pC91sIYcXLO7vmhYVP/o+6TMt6VVJmcPz6jj5oeP3FrXtTOTp4Fw06MxBi8TA+ilaclfjVTzQ+VKcxlKOL3tjL9VFciPgKwF7fT4phoeh1dbnA2CJ7OOcvcv4SKTcl9lj9DfTDEj6PEkqSSyTw/DVXsBC6CqBiBSTe+kvq8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVaiUMtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVaiUMtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC116C4CEF7;
	Sat, 28 Mar 2026 11:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774696410;
	bh=LZvpywDsRxTdCKgR0wUedtBmll3ecpmF+HbZFuxFE7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVaiUMtu/96JeY66SHNIG+6s9+Qpy6TiSR63+I9bReWvctOglnedTvYfMuh5vA4bP
	 MyhL0us1aSIarmX4pq2SHbjqd6cU8k3UvRphUOhMvuLXEyOf8IptBi5s/iSkFT4um1
	 dTNUTgFSNptdcQuKuxrddm2ZlPylqMnFiDFlwA6We/p50SmxYrdwk+8DnHTeh4KdK8
	 QwIn27VxLaHN5XTFbCnguw+bE7PgLR40J6vDV5VUOyljta4cgZJ4J3k3VGYS3qh/Dt
	 r4nSA7PhuYUFYZpnoP2HTr0Ho1yhwpf4SFyuiPjBn8nP/KjKWYR8C4jjOhtUIt2PL+
	 kidHOiAxbjJRg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w6Rbc-00000006cyA-1ofc;
	Sat, 28 Mar 2026 11:13:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: ptdump: Initialize parser_state before pgtable walk
Date: Sat, 28 Mar 2026 11:13:25 +0000
Message-ID: <177469640014.4072287.7784370743375832384.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328053155.12219-1-zenghui.yu@linux.dev>
References: <20260328053155.12219-1-zenghui.yu@linux.dev>
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

On Sat, 28 Mar 2026 13:31:55 +0800, Zenghui Yu wrote:
> If we go through the "need a bigger buffer" path in seq_read_iter(), which
> is likely to happen as we're dumping page tables, we will pass the
> populated-by-last-run st::parser_state to
> kvm_pgtable_walk()/kvm_ptdump_visitor(). As a result, the output of
> stage2_page_tables on my box looks like
> 
> 0x0000000240000000-0x0000000000000000   17179869175G 1
> 0x0000000000000000-0x0000000000200000           2M 2   R   px ux  AF BLK
> 0x0000000000200000-0x0000000040000000        1022M 2
> 0x0000000040000000-0x0000000040200000           2M 2   R W PXNUXN AF BLK
> [...]
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: ptdump: Initialize parser_state before pgtable walk
      commit: 570428601ba506e76c265a65626524ef3c5cbc04

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


