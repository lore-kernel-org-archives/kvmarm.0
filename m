Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949D0286427
	for <kvmarm@lists.linux.dev>; Wed,  3 Sep 2025 12:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756901278; cv=none; b=EzPmtulZ20mKgFfjrZvhSi/vMfe59qEe9kYfgGBkMneIQFpuZcN1BbQAVTA3KMpWxtq+KSTYvecb2RD+GeQT6bkLDvJr38uTHOgWZ2iH4H8Q2TGs+OnFUBdRgJm0JD3WbjCV4+DI1dGPDT43Q+mG17EzugbVULKh/ZwjkRgkTrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756901278; c=relaxed/simple;
	bh=IedR9gLTqIst+0+I6/rCBWY1cT0eeORo9UueU/viVUs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=knqxE29rmxrtJgutGg3EuqK1MELNSELmVZQjJNwS2KQTUCaAx+qLXugpt1drtWlcY5TnP328rAigogkubKHESl4jYb1i0hQZoWfwwIXhVMarHrr96sl/yTqIy2357e0pe4WYOHUtWznzhl5XE7bzcgeUAIbf4S0GVfMcHjmpaMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=xw/Zxpln; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=jPYvEOdC; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xw/Zxpln";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jPYvEOdC"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756901272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IedR9gLTqIst+0+I6/rCBWY1cT0eeORo9UueU/viVUs=;
	b=xw/ZxplnLljYchtWLlcn8/J04+jjSWmOTBlUk/gySEikZE1mr57Wbp1d7/9uobUQVXr1Re
	PC9yMoasYgYWcYxeqatqpDgKLJmb40+9epAxAishKhajLizLCIN9729JQvO7m/3rmiu/NV
	c1bV6U/02I5tY7qN/w7XgBt89Kxh8LGPRpfwRKpL97zHuWBXP37P1ZxEGB0m1Mk3lizpPw
	ElIIjQbOpvCqDh65s6WA1OPxwtBnkcofkLE4U9Ke3iJyyxI25x0bc/0CMoV/l8QFoo7phX
	SKcImogCcFIxEKkB14R83VYNQa+wb47PrXeePbZm74VoH2n9SMxVYLYSwg4NKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756901272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IedR9gLTqIst+0+I6/rCBWY1cT0eeORo9UueU/viVUs=;
	b=jPYvEOdCiB5SxSTGT9FwgczyLLPEoJxm5A6QgwYbgaVy+O/K2p/7OfoPcRKZ0HSfnwhFHD
	iXWyk916Zaz6ZXCA==
To: Sascha Bischoff <Sascha.Bischoff@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
 <kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Cc: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
 <Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
 <will@kernel.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
 Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 5/5] irqchip/gic-v5: Drop has_gcie_v3_compat from
 gic_kvm_info
In-Reply-To: <20250828105925.3865158-6-sascha.bischoff@arm.com>
References: <20250828105925.3865158-1-sascha.bischoff@arm.com>
 <20250828105925.3865158-6-sascha.bischoff@arm.com>
Date: Wed, 03 Sep 2025 14:07:51 +0200
Message-ID: <874itjzqlk.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Aug 28 2025 at 10:59, Sascha Bischoff wrote:
> The presence of FEAT_GCIE_LEGACY is now handled as a CPU
> feature. Therefore, drop the check and flag from the GIC driver and
> gic_kvm_info as it is no longer required or used by KVM.
>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Assuming this goes through the arm/kvm tree:

Acked-by: Thomas Gleixner <tglx@linutronix.de>

