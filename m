Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88C211CBA
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 19:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061883; cv=none; b=MWPpLHNojLgpMOmWP3qOVmEmD49f+/EcEICqmLjRl5mnHOAEnSBdIQ+8Hpb4H1p1TfSNPrj/6O3QgnRc41PrR83AIV8xEDVJZWIR7vYN2xFgW5bCJUpj3TYU9o6ZYhtItH8u74QBsv8YJ66BZjJMTmyJj1C7VDR+QXglN2a/Qhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061883; c=relaxed/simple;
	bh=DEW+2KdMUB7Qrifs4UalrZgysaQc94gGsc8mTz5NqZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XjTVSys/fj39ryhymqWFd+WwPM3xMTfC/YivQDnU49DBNN7zVkIATbOluIqEGgFpFnCxT8Z16onFa8lz4IDBt56Vv6yW5rWal1aHiEYlNzpEHcjL6kpLDYqyP57ONDbfO5U2Wfj/g1MbSpDGvBHawtJ0jiKpowEqckfhsJaazaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VBknmzrQ; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VBknmzrQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cT+RhmWi5VqSZEe2EJWtP4W9z4pas3abFCArV0RzhxY=;
	b=VBknmzrQbtpKSg24OKWsOYxo3rQzMZKRcPn3R3iVRpYlox6uu/M4KrHt0tEEiGG+Xqo02+
	Diqr1Swy3OR3RmEQk85VI6yXLSL7x1gtFRlHwdlBE98kOhisEWEeTCavvAgAo0vmdPvL/T
	vh6OZoK0o0MSN+f7ewqvM3QZWbkjzDw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix splat relating to idregs debugfs
Date: Tue, 27 Feb 2024 19:24:29 +0000
Message-ID: <170906186076.1982210.3099940638782793665.b4-ty@linux.dev>
In-Reply-To: <20240227094115.1723330-1-oliver.upton@linux.dev>
References: <20240227094115.1723330-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 27 Feb 2024 09:41:13 +0000, Oliver Upton wrote:
> Looks like we're calling in to debugfs w/ preemption disabled, which
> explodes when trying to take the parent inode's rwsem.
> 
> This is easy enough to work around, and we can just initialize at the
> time of VM creation. No idreg values yet? Too bad, just kick an error
> back at the user. All two of them.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] KVM: arm64: Fail the idreg iterator if idregs aren't initialized
      https://git.kernel.org/kvmarm/kvmarm/c/29ef55cec33d
[2/2] KVM: arm64: Don't initialize idreg debugfs w/ preemption disabled
      https://git.kernel.org/kvmarm/kvmarm/c/5c1ebe9ada19

--
Best,
Oliver
