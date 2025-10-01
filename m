Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6FD283686
	for <kvmarm@lists.linux.dev>; Wed,  1 Oct 2025 08:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759307396; cv=none; b=McrmxOaqPFo9iaJ8RS5KoheCnGFlxBUCpmZAbR3eV1vJHgB/IL8xzpIGAJc5y/Tksuel0Jolu+BsYTSf3yCovSOsSz+//b5YFfZNphixrSNKGKEYIGCU8pytyqNDuh8YNF+EOZC8+Wd6QUQsovdz9163MgVTonwLHHjL/Jr0rP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759307396; c=relaxed/simple;
	bh=8d2FeShPt3OFSicjzFUqkohSkj/9t9rRZEI7uyAAgto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rBYixaY32ojdkKZBpSPb5k60zpHwz4UpRBB1syO8omHbccFQGa9Rleq9HHVN87dQKWtaoZM9MtbBM2IOeTgpfEOJF8dNzCVejpnaH//xr/+6GtQpoHOBYkgo012AXoPjokLC91BblUzLFHE9uuifZ7mifGlCacdI6bNOeXW2w4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSoBuz0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSoBuz0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B72C4CEF4;
	Wed,  1 Oct 2025 08:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759307396;
	bh=8d2FeShPt3OFSicjzFUqkohSkj/9t9rRZEI7uyAAgto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSoBuz0I87X08s4l5Vhpo8x3bEz9psISHEiuJlNuE7XNOhan6Jri/EbunnO965RgF
	 N0IGEnISwiN6pKXLc2q3tSSIP75DyMaj7CulGD8+2+TxXa/wiQvvI6UuItn0/3jrwt
	 +3nUsCnpJHU19xM8YLOZq/jpHQDReLTz8xnX+T24aNlgWGHIca7oGKfzqKMZHCaOKV
	 /ktvBcrd+gDW7IV865lQCdXzCYH63KjLg3RUu9gCwr/Hx9d8FM37hdfgjI+lRvhpRl
	 vaitzsgvD31xPNXGBC7JJGCP7x9ZPV9aTblaxscIefYyCPy0AgDbUR//gAzTRpaFIG
	 WwzAlyZBt2nJg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3sDh-0000000Ak9o-2kUY;
	Wed, 01 Oct 2025 08:29:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2] KVM: arm64: Document vCPU event ioctls as requiring init'ed vCPU
Date: Wed,  1 Oct 2025 09:29:43 +0100
Message-ID: <175930738368.3589838.15442036213916250539.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250930233620.124607-1-oliver.upton@linux.dev>
References: <20250930233620.124607-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 30 Sep 2025 16:36:20 -0700, Oliver Upton wrote:
> KVM rejects calls to KVM_{GET,SET}_VCPU_EVENTS for an uninitialized vCPU
> as of commit cc96679f3c03 ("KVM: arm64: Prevent access to vCPU events
> before init"). Update the corresponding API documentation.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: Document vCPU event ioctls as requiring init'ed vCPU
      commit: 7775af6d1cc6f398ceb16abe13d1469065abb1d8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


