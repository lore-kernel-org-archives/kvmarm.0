Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57D6302CC0
	for <kvmarm@lists.linux.dev>; Sat, 10 Jan 2026 10:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768040591; cv=none; b=YxqAqw9gIJkHUabC0PYVmKztbP0G2c+kt1KYtBsF5zbGXwpBs5BgfNj5/RjZ0UBvtbxl3TGkhvSAvukCcbpBy0WyPif0tqVi/73cGfn55KdiURkz7nsUl/WjJtrJkxoTBpkjHvWNgTH1skYEnOsUSGCPbutdWayzTTLrtUA3Il0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768040591; c=relaxed/simple;
	bh=fZt8O+OYRGN20Tn3o7gdiEssNFrpRa2DAMV5fJ3SzTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPrYy6ifvWD+sxWbe5VFnvd4HP19iQKEa8V93KKGCwAVUEFtUiC81Mrcg9h3J88FrAWX80GZnZ2NT8khYgcF9mc61bEqR3d3+wHYRjby36a181/mgPE2q1cxvnSW5JFp8cNmpD/xaYAg+fZWWGoPX6b1T5vRG2LoJLn2xcFTzoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LItSn8FL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LItSn8FL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B255DC19423;
	Sat, 10 Jan 2026 10:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768040590;
	bh=fZt8O+OYRGN20Tn3o7gdiEssNFrpRa2DAMV5fJ3SzTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LItSn8FLVjEa4flevQzVzSq1jFZP1NCoxUjV8CNj3UBBllRABH48vDoeYsHd+RkTG
	 u1wEgAl6MYE3E/0ayrqmncuT+x88oQtaDrva007wdBX5EZ2hYt9bBEtVdjHhfhFdxM
	 bpnNzuaKI4v3dFge1mh2T+jWGnROefYbtYYzw0QMXH2mMY6RFj3btt4Mg2DQv0tWRr
	 XMOBZeScoQWSVBYpnCXXGDU5fDIMGX6z8W8of+bL1THCDvI9kpTHQ86wW/wILtsrPn
	 wAHAW4qi+5+VpRC9ehptmVgGqKeUEeSZt39MGteReRk5vaOY8ByKTTc496UUu9LvYw
	 kqlVuFQ7AaYVw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Respect stage-2 write permssion when setting stage-1 AF
Date: Sat, 10 Jan 2026 02:22:45 -0800
Message-ID: <176804045759.916140.5638850958704539904.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108204230.677172-1-oupton@kernel.org>
References: <20260108204230.677172-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 08 Jan 2026 12:42:30 -0800, Oliver Upton wrote:
> Naturally, updating the Access Flag in a stage-1 descriptor requires
> write permission at stage-2, although this isn't actually enforced in
> KVM's software PTW.
> 
> Generate a stage-2 permission fault if the stage-1 walk attempts to
> update the descriptor and its corresponding stage-2 translation lacks
> write permission.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nv: Respect stage-2 write permssion when setting stage-1 AF
      https://git.kernel.org/kvmarm/kvmarm/c/9e27085c33cc

--
Best,
Oliver
