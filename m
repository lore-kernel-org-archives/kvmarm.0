Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8855629DB99
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762507305; cv=none; b=gFDjKL5byKwNhXRr4sZbhBOzyxyvPus3dk5z55r+OE/xPLBRtPohN1N26gzcDRYMu1kS68N1tp8hIjoIUR2qqMxbGTOoA6+wUxsF/7YGLRRkOs4t4ZFDLH0ErhC+qicFmWHQpgY0qRR8rId+47ucggiIkhJzNrwKfB12tsCNo6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762507305; c=relaxed/simple;
	bh=16fzktKxUy6Xh35FbsFWwaYt1pE18auc4mAIyTScTFI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=opISWMDXCeZhtPjExahjaW0IcKtEnOsDmEOos9VtB7KXGQtcFRB6sLkTV61lxrrugdn+Gm5guMHEX12uUjf7rMRiuuDQqMzT7m7in27JVC7q6Tal4E8AlkQI/tModFBFxUAlnPfzY+WDes8RvtfMy5Rd26fmd8jDWDsXcN/Yjrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=C3jdLXC/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vpXaUf+/; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="C3jdLXC/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vpXaUf+/"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 2883B1D000F8;
	Fri,  7 Nov 2025 04:21:41 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 07 Nov 2025 04:21:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762507301;
	 x=1762593701; bh=16fzktKxUy6Xh35FbsFWwaYt1pE18auc4mAIyTScTFI=; b=
	C3jdLXC/Tsizyb1vb++Rlc1wLjYnba7mP8NFlmYxL4ww9yjvdkKoNU1tvC3Z3yjF
	DkMA8ifW4ClivToJfFhk+A7zIjuDmm9QMS4Ly6fLYhkvHALq1lGE5VEoEh/xIe5m
	nPs/cTX0VLxNXpnU91spQCR2LAG3sxVZpeIT2aW6mzqa9hFjFBbt79r3ghuzzzPx
	MUC6SkkxcKjj5GqNH2swGPa9ssEXfxuKKxw65AIUzSl2L5pQ897faEvBLh36uRzo
	C8ABhRs3w+u2tmbRf+JE6CA8ycuJwt/eftOdI8paWmZxqHeMvE3iQYX4zXpPhtWN
	YDCYtNbinxOMRkH1OXXuqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762507301; x=
	1762593701; bh=16fzktKxUy6Xh35FbsFWwaYt1pE18auc4mAIyTScTFI=; b=v
	pXaUf+/9D1v0yWUm4t6enuolfwQK37TZSBKfy6CjzEATR76rbRs4gCYdadP7W22I
	N1/rl9mTdWYGXSa5cqFuc2VG0LopYF3FGZp9I5K1nNlxYE3bVkCN+pQHDa+JDIwN
	XoH3Gyv/enItVhxzE3tUIyplkGk3ZZtcMMmHA51xelqSKFMRPmfXQbVtPFkzC7UB
	BJklCgrjZd+Sq904ePaic70Z/rmnxd7nEkMcG9f/hKq9Iqd0cX0yGp5JwxcYIKil
	LCUE4DF1pQcfbOmA2z7QkIMk0++PYbWor3EppworgiT8o7gNr2UGkKV6fPObvgGv
	w27LkOP9UuDvbwFWK+zFw==
X-ME-Sender: <xms:I7oNaRd9Lm1AVOBtRqRzlxUJaWEojcAL233D8R675Wtf1ekk36hOxQ>
    <xme:I7oNaaDA8F9zhOGR1tslq6JIEWLoPnDmNx_Hvr3Qfyhlkmp1Wdn0WU-f0zHZYbred
    w813rm2BSROOCUYIVRkh5qLclz5rJbkYfiak9_woguoMZYJ--UXww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeelvdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtg
    hpthhtohepjhhovgihrdhgohhulhihsegrrhhmrdgtohhmpdhrtghpthhtohepshhuiihu
    khhirdhpohhulhhoshgvsegrrhhmrdgtohhmpdhrtghpthhtohephigrnhhghigttggttg
    gtsehgmhgrihhlrdgtohhmpdhrtghpthhtohepphhrihhmvgdriigvnhhgsehhihhsihhl
    ihgtohhnrdgtohhmpdhrtghpthhtohepfigrnhhgiihhohhuudeshhhishhilhhitghonh
    drtghomhdprhgtphhtthhopeiguhifvghiheeshhhurgifvghirdgtohhmpdhrtghpthht
    ohephihuiigvnhhghhhuiheshhhurgifvghirdgtohhmpdhrtghpthhtohepmhgriieskh
    gvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:I7oNaVTgIXKz7BmbT0aSRAsCx8hbsswWFfQUYcM3259OvbNxTDxWkQ>
    <xmx:I7oNabdHEru5fn9Ue_PlmlaX3x4eW1HM_zpUKxCLbnf1iWGRQsYdjA>
    <xmx:I7oNaevV2Ft3T0MEW76UT40yX4u6Ma3mYD8C_8Cxhh7ts1PLqczJiA>
    <xmx:I7oNaXIq7odSdSjkeeYUUcsFuvwY4hPlEzUnJuK0S7YwwjAquyQPZQ>
    <xmx:JLoNadzGFAutaWLdAzneKsvMe4x0fxomLo89oZ8O8fFh3GaWwCZP7xOy>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 97816700063; Fri,  7 Nov 2025 04:21:39 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: A2_nuZaCxefk
Date: Fri, 07 Nov 2025 10:21:18 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Zhou Wang" <wangzhou1@hisilicon.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 "Yicong Yang" <yangyccccc@gmail.com>, prime.zeng@hisilicon.com,
 xuwei5@huawei.com
Message-Id: <146df4ad-c8a9-4e56-bc1e-7aae53ab8b85@app.fastmail.com>
In-Reply-To: <20251107072127.448953-8-wangzhou1@hisilicon.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-8-wangzhou1@hisilicon.com>
Subject: Re: [PATCH v7 7/7] kselftest/arm64: Add HWCAP test for FEAT_{LS64, LS64_V}
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Nov 7, 2025, at 08:21, Zhou Wang wrote:
> From: Yicong Yang <yangyicong@hisilicon.com>
>
> Add tests for FEAT_{LS64, LS64_V}. Issue related instructions
> if feature presents, no SIGILL should be received. When such
> instructions operate on Device memory or non-cacheable memory,
> we may received a SIGBUS during the test (w/o FEAT_LS64WB).
> Just ignore it since we only tested whether the instruction
> itself can be issued as expected on platforms declaring the
> support of such features.
>
> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>

Thanks for the changes,

Acked-by: Arnd Bergmann <arnd@arndb.de>
