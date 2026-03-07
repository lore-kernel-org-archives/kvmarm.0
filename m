Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BBE287507
	for <kvmarm@lists.linux.dev>; Sat,  7 Mar 2026 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772908157; cv=pass; b=gmxGNYwAIoKDt6tGepibShfizMKXEKoISrur0ZgqRt5WaGov9Dt+xq7r28Xkgynt541vtR0zv2E/AulIGrp6QHh34s4cLj+3NKf1Jtzuzk4mYdI4yysluuW7Ve+QldseP1r+s49HSLVPQWfNKygFHMZ2Hu+Tvg3LF1lujv6nq2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772908157; c=relaxed/simple;
	bh=XLeYu5sp8xAqiIpYP1ao+++AXATt6m9XQqufu06SvEA=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=cQ9OTWmrI/sVIMPaPRTR6qWXL5zZNqnz18r1kvy3/378U6WbgiLhrrFk42EQPUOi/Lo5J80x8wIR7xe/xmJmoJEfzbhLHeQgmXIiM8mDYfk2cDgGLm4uD92qInFcoWkK04fCm+wCSRFDWn1b/zLxACZZN3CyiXyej7/oo0L+Ahg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=valentine.burley@collabora.com header.b=d/qfmH4G; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=valentine.burley@collabora.com header.b="d/qfmH4G"
ARC-Seal: i=1; a=rsa-sha256; t=1772908147; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=GsdMfGCfoLoSf6FDErk0QF9+yrbJ4gjm2iXg9rKJxwKsxZsIfwyKes6Z8HVi93mWTCtzw1HI5zmbCj85Me4AViOL2e7blEDnfxYnov/HcFvnWPIfj7Vj5kwawDsVdgQNgBegNl3ljPqglaR+T8YLYYthJxov/W5qTX4Nh0SLDug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772908147; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=otNb12BkuMueEPdITPyW6N2Bsr+BtWR55FBBzFloQOw=; 
	b=KcPvHuWovV2BH7dgtj7hy3SSTGvIllj9yDm46s3ohzY4NSnv3ABfUtNjdcuA6RNegUvriuPCk1ZUkJUftS9STfKQzh0CC+N+YiEideMV3bNCerS8wnMLcdo1bigzN/YUkXXvBMxX+rAFXL2HkONV4hWl/WH33BvghiF1vvakvdA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=valentine.burley@collabora.com;
	dmarc=pass header.from=<valentine.burley@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772908147;
	s=zohomail; d=collabora.com; i=valentine.burley@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=otNb12BkuMueEPdITPyW6N2Bsr+BtWR55FBBzFloQOw=;
	b=d/qfmH4GoZ+5Bgd+uq1JU/lSAY8AYqx2XMxE6jZLgdHg6Fsin9gG7o4O11WXCbR8
	Y0JyPrQ3ytC1DCyBevcHFCxbUXQTr5vSxPcwG/iVJPo4ClDjCtOhp93dCUDP5wseIBs
	BN4Ozs7WQj+5kLftUvd+p90Y+FfUZBCZB30ZQKek=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1772908145625135.82383304834843; Sat, 7 Mar 2026 10:29:05 -0800 (PST)
Date: Sat, 07 Mar 2026 19:29:05 +0100
From: Valentine Burley <valentine.burley@collabora.com>
To: "Marc Zyngier" <maz@kernel.org>
Cc: "tabba" <tabba@google.com>, "broonie" <broonie@kernel.org>,
	"stable" <stable@vger.kernel.org>, "oupton" <oupton@kernel.org>,
	"joey.gouly" <joey.gouly@arm.com>,
	"suzuki.poulose" <suzuki.poulose@arm.com>,
	"yuzenghui" <yuzenghui@huawei.com>,
	"catalin.marinas" <catalin.marinas@arm.com>,
	"will" <will@kernel.org>,
	"Sascha.Bischoff" <Sascha.Bischoff@arm.com>,
	"sebott" <sebott@redhat.com>,
	"linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm" <kvmarm@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19cc98f6bc6.30a0020a4990004.9101239855762576863@collabora.com>
In-Reply-To: <871phveh17.wl-maz@kernel.org>
References: <20260307115955.369455-1-valentine.burley@collabora.com> <871phveh17.wl-maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Skip interrupts in LRs during EOIcount
 replay
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Marc,

Thanks a lot for your reply.

On Sat, 07 Mar 2026 17:33:08 +0100  Marc Zyngier <maz@kernel.org> wrote
 > I can't reproduce it locally, but in a crap integration, where the GIC
 > is clocked at a few dozen MHz, this is far more likely to happen. I
 > should dig that Lazor out of the bin and put it back in the test rig.
 > 
 > In retrospect, it is obvious. I just couldn't see it until then. Many
 > thanks for going the extra mile and pointing out the core issue.

Appreciate the clarification!

We also have a few Lazor boards in our CI, and the Trogdors are indeed
legendary for hitting all kinds of edge cases.

<snip>

 > Could you please give the hack below a go on your setup? It seems to
 > work for me, but given that I never observed the issue the first
 > place...

I've tested this on my sc7180 Trogdor setup, and it completely 
resolves the issue. The Cuttlefish VM now boots reliably.

Tested-by: Valentine Burley <valentine.burley@collabora.com>

Many thanks for the quick solution!

Best regards,
Valentine
