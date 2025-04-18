Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7651DB148
	for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 21:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745010206; cv=none; b=PHBOlU0pJS5YiRe2pAYwPJFonHnhpU/kw4chK7Qcm7tnXlNHa04VuO3KoIWCXq9HEKk8nsyUnXhsV3VCkzm9QmqiHvM/C+xyFr0ZJkD45+jxjUtwiBJsBIh8AVw4d6h8WI1dcfMfs8grp29MLBQdGgwShjnqmHqPXxjwqqyZfYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745010206; c=relaxed/simple;
	bh=RbnqJpgMnh7ig2io0XBvKfN5sneFRrfKJ2eOns7y6Jo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uzSIZCCWNv/vFtuBba5HMswFcUB/7NI3ApPJUmWLf6Tpmlg/z1djz2XmNhVArXr2xWXTSanNsKvwBSQnfBKTFJEVmlbwwi5Y5ThzqLbZTbQAOQaw3HzOhFL1H4CNvWXJh8fe0JmZjPjjEvcKvQrF/mx1XJ4gGUAtGWiQthFx+2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EWsIZ38y; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EWsIZ38y"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745010202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBbnOR+pK/NQQPxjQOqaAi68Gr0DiKxfb3ev6ayzfjM=;
	b=EWsIZ38yznbEniiZGQE7EMP7r8kUsFq30pSXcHiq+/+9+BbmgbDvgIUWjbYsCRjf+EHhwU
	7exYEzXLHinW56S1YpT8o46coK+njzyfX5KF0QvAjcxyg5Vmi2IoLNJvsT261P/5SoP6nD
	xTNCip6Q88YaTmyczOiZXnm7qDmGi38=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2] arm64: Rework checks for broken Cavium HW in the PI code
Date: Fri, 18 Apr 2025 14:02:55 -0700
Message-Id: <174501016555.1215576.8158550633479811313.b4-ty@linux.dev>
In-Reply-To: <20250418093129.1755739-1-maz@kernel.org>
References: <20250418093129.1755739-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 18 Apr 2025 10:31:29 +0100, Marc Zyngier wrote:
> Calling into the MIDR checking framework from the PI code has recently
> become much harder, due to the new fancy "multi-MIDR" support that
> relies on tables being populated at boot time, but not that early that
> they are available to the PI code. There are additional issues with
> this framework, as the code really isn't position independend *at all*.
> 
> This leads to some ugly breakages, as reported by Ada.
> 
> [...]

Applied to fixes (and off to Paolo), thanks!

[1/1] arm64: Rework checks for broken Cavium HW in the PI code
      https://git.kernel.org/kvmarm/kvmarm/c/117c3b21d3c7

--
Best,
Oliver
