Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB95D3168EF
	for <kvmarm@lists.linux.dev>; Fri, 30 Jan 2026 10:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769767211; cv=none; b=q9zyLBiQg5YVOXgE0PdgRYMLrQ3ggKOvYA9/0OCbpdQ+j2X1DN5yAjeEbJwMfUdT4zBnSCUZBPfzGWMXb5bVXCe+xX7B6sRGiHJ1ySnzajEf75h9dw5+ROs8iFmWFG19wAQiDSu+STF7sQFggukUfIPXPrAJ5REAjT4kgDVdFC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769767211; c=relaxed/simple;
	bh=n560YUW918HfytFqlbMcXwZThFp5BeKFVRQ7nLTXFfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=koU+ZM0eIokPyFVCZWbu4rEk3OC1UANX16+kxJeInqZmT/caKmF0FhEVosKZFyPv8TQzbbZOIq2AFm0qXMeu2ulHa0f4J3PyApWVe42xgolGfDGE5r93JBgTBB6141D2E3mRmIUgpr9ceBse4Ldp+0WerweEvMkLuYKyd2+5AKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cna2S/7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cna2S/7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54057C4CEF7;
	Fri, 30 Jan 2026 10:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769767211;
	bh=n560YUW918HfytFqlbMcXwZThFp5BeKFVRQ7nLTXFfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cna2S/7l9k/UfECX1DGp6+UN9yxW/9XqF9nNMp5BEaseIxRGacLYszWqKMJivll23
	 oKlWWpD5xFwkWHTKbxXT19sHSaEHuUjZOpCWRtC3S1kRAG1+6Xo7pUaLdtgQt/j6/m
	 WnBGjGah9affdj1AuPpZ+sVJxGrQKm68DNFk/XaY24sXXk/+iq3AggRKpKECMUP8Cy
	 /grOBaAMuSwEVhXBxuK3Jf/7DJINQXf59zVXPvPrRvTNObZt/QCKn3INyUTkMRLUk7
	 yWgH+Ha9BS3knDJpVKGX6meTbYjhmSA9OoQlaMT0npM7TIgsKvCLUisbdiSCoP4Oij
	 68x2xp68OPHfQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vllIO-000000071Qk-3Cqw;
	Fri, 30 Jan 2026 10:00:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	wanghaibin.wang@huawei.com
Subject: Re: [PATCH] KVM: arm64: nv: Add trap config for DBGWCR<15>_EL1
Date: Fri, 30 Jan 2026 10:00:05 +0000
Message-ID: <176976718623.2311376.10358603736006188355.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130094435.39942-1-zenghui.yu@linux.dev>
References: <20260130094435.39942-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, zenghui.yu@linux.dev, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 30 Jan 2026 17:44:35 +0800, Zenghui Yu wrote:
> Seems that it was missed when MDCR_EL2 was first added to the trap
> forwarding infrastructure. Add it back.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: nv: Add trap config for DBGWCR<15>_EL1
      commit: 9d46e83a72392a644604458448a72d7c45977f0f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


