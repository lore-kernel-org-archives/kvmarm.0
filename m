Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2271A371D0D
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 10:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772794093; cv=none; b=D4A3CmYkEA5dyyYS8NPqf8dVUOivOb4G6laY0cWupg2g65LUQK7b+OUORyMFMVkPLTu9mzMVpIxdPaDzxRPaHI/apAsraUAy1G5GoqDw/2FM7tE0eiehE6BHSypj0l1jYkwKHX2ovOt3vuzUEAISJKrWld3tJ8K5v+Y7wes3iK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772794093; c=relaxed/simple;
	bh=ERAZRUQR3DiAvO4NrHYp9EIuWfTi8S/tNjbzNXo7NQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCXN+DwKhyamloNtBLlDwcGs7DT3VTDry2kY0y2x9n37a/fe7XBT78dDAwy8UZxRYoOa5unkaBspUu9i3uzt0cJxgZb0kvdRKnPYYP+Um1aIu5a4l40EwtvSKkl0epN7ocK2plD+1t4u0Q9x/mMF6Za66qRg7YWwLkoVpKcRJ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KorhbY71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KorhbY71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9380C4CEF7;
	Fri,  6 Mar 2026 10:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772794093;
	bh=ERAZRUQR3DiAvO4NrHYp9EIuWfTi8S/tNjbzNXo7NQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KorhbY71VkWRYlWHJ0bqBTP3k1Nc3XBr2JQMNk++RnNl9Wb/l80DJPngzMhEN0pW9
	 fvrlk4bnL36N/al5kz/ThRR8RZDfEApesCGHFutoVFUBsOAnkDI/hPN18ZLTf3fJ56
	 clxAcO6QXhVL/XB6rjQgV/Xn+FHubKcAqCyaQa0kbHN/RG4s7Xv68Uye3NyqOaQJCL
	 UPD/EwHRfnUOoLo1HOk6Lnq+BClF5BsBKx/G48TbAMRlwiihmKBomemGKSjYwKWHHW
	 joM1uAZBiOYy1eQJKp5ZAV38bAl/VSPE5MFJIqLTm+I3wzcSFESrgLNrhugZLAweCG
	 iDh/wdumyu/xw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vySj4-0000000Gnnf-2Nzq;
	Fri, 06 Mar 2026 10:48:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH 0/3] KVM: arm64: minor fixes about S2 page table walker
Date: Fri,  6 Mar 2026 10:48:07 +0000
Message-ID: <177279406008.3200749.11694453799460270287.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225173515.20490-1-zenghui.yu@linux.dev>
References: <20260225173515.20490-1-zenghui.yu@linux.dev>
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

On Thu, 26 Feb 2026 01:35:12 +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> A small step towards fixing the issues discussed in
> https://lore.kernel.org/all/3f88cd49-68f1-4276-a067-b7c6beadb27c@linux.dev .
> 
> Zenghui Yu (Huawei) (3):
>   KVM: arm64: nv: Check S2 limits based on implemented PA size
>   KVM: arm64: nv: Report addrsz fault at level 0 with a bad VTTBR.BADDR
>   KVM: arm64: nv: Inject a SEA if failed to read the descriptor
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: nv: Check S2 limits based on implemented PA size
      commit: 4c2264ecdf39ddbdb62e37b156015aacf05d0dcb
[2/3] KVM: arm64: nv: Report addrsz fault at level 0 with a bad VTTBR.BADDR
      commit: 99a339377f3c1bdf6edd5614d36893ab1806f9e6
[3/3] KVM: arm64: nv: Inject a SEA if failed to read the descriptor
      commit: eb54fa1025f8b520f0e83a807d76e35e4587c5ff

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


