Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792690508;
	b=ph1ANwTy/XjYBm+V38eXxCGnFeVrghQ1UlvYMeup6KH3pDvET/4Zg7+x07The+H5Vd5Z
	 d4RgV2zEYBib/yFhO0HUilwcrrrnnZBBx6XPJLDoZukkeS2OrMYkOIbLLxJ7bIEpefqin
	 g7lTmnz0zLbkfajpgqHTMsIktMEfMYSEYNiKu60EBuOkKXuQo3WXbWRqjgICO7vo4gdas
	 8vItnNnlF9weeAHew05pWocJaKj0tiGLtsgnYcm1+Y1OvvF9kC0e+QXvKUtXsORna+Efm
	 Dxh1dzHK8w5aGlXlCRw/i9CkuUsrsVI7d+qJwyAEGnfP9NX6hz7mCHYB1MOgOlpeVcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792690508;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=UhyAbw4qoriwhozaXu+XfZddUYSkASyU0+JOd2C+mS0=;
	b=FUcoI3CBMVfsCA2MzcjNpYAXad98rwooTEnaqR9DUpnuLnffMXrHLU4rL12Jhwt5ZI/k
	 y2erwupSuweVbXCf+cL1OxWWNu0lfzOSkhTrOHWtinYSINwMe5Y2uX5iv7rvkKFvL/BkQ
	 d+MH47nfh822HGpG10s+L1bPhHosxN4Z7xPwC6X+dYDoOG9mNQas341I6rOCf7MfHhcIC
	 G1CtGKaGR5B9ijYGqDrd/T7iaN6NA3A0eR9WieztfYUBC2/CibATppzvTgHJzSQYhUgg/
	 WXQxNb/GEl8UrIv4a37ZWKggb1MtgorgxQmESwNw1Og0edUp8PIPkJnsKq8DTv28+tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="lebqlN/r";
	arc=none smtp.remote-ip=95.215.58.151
Received: from mta1.migadu.com (out-151.mta1.migadu.com [95.215.58.151])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6443D606B78A
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 17:35:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6443D606B78A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lebqlN/r
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=UhyAbw4qoriwhozaXu+XfZddUYSkASyU0+JOd2C+mS0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792690504; v=1; x=1793295304;
 b=lebqlN/rZSsxlA9jgeH5wG+Q4iXisCDTIskkPc699DogTycxxjFuIW4eB1IprKxqe1mzVFaw
 4vuY4gCnQkLD1W7tCzdujt8PVzEe9sArx+9qTa2PAOtNO0KFgcDN1oRaya6pHqRb4hxCzpmE+uF
 YQUyy4ForQ57xq9RUe0MO/P8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3b6a465357a79fe8;
	Thu, 22 Oct 2026 17:35:03 +0000
X-Mizu-Trace-ID: 3b6a465357a79fe8
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	tabba@google.com
Subject: Re: [PATCH v2 1/4] KVM: arm64: Make __vgic_v3_init_lrs HVC always available
Date: Thu, 22 Oct 2026 18:34:59 +0100
Message-ID: <20261022173459.3692613-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022140048.2522787-2-vdonnefort@google.com>
References: <20261022140048.2522787-1-vdonnefort@google.com> <20261022140048.2522787-2-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Vincent,

On Thu, 22 Oct 2026 15:00:45 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> The __vgic_v3_init_lrs hypercall only resets the vGIC LRs. Those
> registers are expected to be 0 when the host is running. As a
> consequence, it is completely safe to make it available at all times,
> even when pKVM is enabled and the host was deprivileged.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
