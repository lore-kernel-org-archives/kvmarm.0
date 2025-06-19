Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B66223D2A0
	for <kvmarm@lists.linux.dev>; Thu, 19 Jun 2025 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750336597; cv=none; b=KLKl56lm3ft8M1PB+U80UVvs5ikZsg9ALp/tV7iCEGU/sOJeHnFvd3wuGkdvkYROJEfzmvtYd5Pt6IIVnpIdJnX2iqjiRvAyEDBN6u7fbtT0/ly7W668Q58fvGhZMLdN4bN22ZtD0tlLGZ9DTVWjDXA2jr+xZoeoUWWNizUBOTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750336597; c=relaxed/simple;
	bh=+P5g+5CJj1UdYWKc1Wje0xjLDaJqzX/jUZTSky6aLjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQa9p1MLSx23KqbmVZ4tR6QPqg3V4BbLqhO9WXg15fpi2+iy7w5P5CKBNo5btKrEKZmj1X4UCsfraR7kaVStPHZaxtJB5O8682oQCo9Rq36l7oadHOtrcH2A/PtL2+aFofF+neIovjc/y5O7FQ5R8SwIFVAjSjToxInHLpfyliY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rkQNS+WR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkQNS+WR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C2FC4CEEA;
	Thu, 19 Jun 2025 12:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750336595;
	bh=+P5g+5CJj1UdYWKc1Wje0xjLDaJqzX/jUZTSky6aLjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkQNS+WRrR5CjzTSUZC0ctjimPVyr9bwAvZAWedYzd1dNL9JCxRmzGVaMpA5tGfeS
	 Lx7P1eVk0KDuf8hXiIw96t3zbmxcrQN0tWwbmX/mjYB9cKnzrGptTV9pDONMe7Vu5U
	 dDAQ5PXqKQEGJddOtnR0h62aZOV+cI8D2eJqhUSZzDMRbrxBUf+wQpaiPwEFuqtPV8
	 Nw/Wf4YynIJ+ul2spXKUZYNTEDSZTKfZKzoWdwvIDh4PSjaGqSbuvyXYyRBI+3BpMY
	 e7XEXIt03L3zNAYlomvnq4x3IXENLpfPmFyvcuobtJkcWQObQKg2JyCAnsJA2d+bS7
	 5x/ErqPxT3wFg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uSEVN-008FeH-Eb;
	Thu, 19 Jun 2025 13:36:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	wanghaibin.wang@huawei.com
Subject: Re: [PATCH] KVM: arm64: selftests: Close the GIC FD in arch_timer_edge_cases
Date: Thu, 19 Jun 2025 13:36:30 +0100
Message-Id: <175033657717.3069674.5241246284273591125.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250608095402.1131-1-yuzenghui@huawei.com>
References: <20250608095402.1131-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 08 Jun 2025 17:54:02 +0800, Zenghui Yu wrote:
> Close the GIC FD to free the reference it holds to the VM so that we can
> correctly clean up the VM. This also gets rid of the
> 
> 	"KVM: debugfs: duplicate directory 395722-4"
> 
> warning when running arch_timer_edge_cases.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: selftests: Close the GIC FD in arch_timer_edge_cases
      commit: 56a14984505b11674df5e01407748236bc4bc8f8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


