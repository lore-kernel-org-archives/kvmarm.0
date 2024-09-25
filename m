Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C021459FD
	for <kvmarm@lists.linux.dev>; Wed, 25 Sep 2024 15:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727277930; cv=none; b=dB7+v6LoNsYZ995pVkJjQP7PJrtoSvtHx8XlCz0byHLx3v5UPjI2whnyW4dF0vsW0lTbjEZZWbpqwBQvO18R8WTUJ4VakXnSrwegn1p9kY2F5OQY/eRpUanrI9yuIFZeZ83GtaGz3gx4+w5VRc5iYJ44HxsczD7mQw1xnDwvtb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727277930; c=relaxed/simple;
	bh=X9nuUw3jVOO4MXPUAlef0b2lkZeeYOB1+7M8HOVTIak=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MtOjeRvfrC1uo+jJF42rPmtpTxoCI1BHZIiDowy8PBswrxXQn7Joq03VJVOijZIjaxdamjsaRQLFL7TQhXUSwERt6986bYKlhcrlm3e/Dx7h1i+uGSLqqqgBqoLcEZNafTl/cjk8K0MUxVCUXYQg06+M8q72sUkcM9fdkGIbYkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=O/wrq9JK; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="O/wrq9JK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1727277929; x=1758813929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=As6Tj8wcJOBT4bSyBpmyxkEQ1WVmrxVnT+g27ZYlr1k=;
  b=O/wrq9JKRIOKIgLPJTFbaJNbY7fANOqpSiINE2D98XPGZVT63q9lDeRb
   x/vy2sCVUItDFBqDKT4hf8cn4VljxlIY+3i+Ff/z9CRU7BMTx/Ft/hGQ1
   AKkzAW7rNz2BMt62eQTGMhO48WTLPbeaBtWE6ZWailXTBBW6w/kCxq0dw
   E=;
X-IronPort-AV: E=Sophos;i="6.10,257,1719878400"; 
   d="scan'208";a="335003636"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2024 15:25:24 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:31774]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.12:2525] with esmtp (Farcaster)
 id de8fdb25-e828-423b-86df-630a32d02633; Wed, 25 Sep 2024 15:25:24 +0000 (UTC)
X-Farcaster-Flow-ID: de8fdb25-e828-423b-86df-630a32d02633
Received: from EX19D007EUA002.ant.amazon.com (10.252.50.68) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 25 Sep 2024 15:25:23 +0000
Received: from EX19MTAUWC002.ant.amazon.com (10.250.64.143) by
 EX19D007EUA002.ant.amazon.com (10.252.50.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 25 Sep 2024 15:25:22 +0000
Received: from email-imr-corp-prod-pdx-1box-2b-8c2c6aed.us-west-2.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 25 Sep 2024 15:25:22 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com [10.253.79.181])
	by email-imr-corp-prod-pdx-1box-2b-8c2c6aed.us-west-2.amazon.com (Postfix) with ESMTPS id 662B9A06E7;
	Wed, 25 Sep 2024 15:25:18 +0000 (UTC)
From: Fares Mehanna <faresx@amazon.de>
To: <liam.howlett@oracle.com>
CC: <akpm@linux-foundation.org>, <ardb@kernel.org>, <arnd@arndb.de>,
	<bhelgaas@google.com>, <broonie@kernel.org>, <catalin.marinas@arm.com>,
	<david@redhat.com>, <faresx@amazon.de>, <james.morse@arm.com>,
	<javierm@redhat.com>, <jean-philippe@linaro.org>, <joey.gouly@arm.com>,
	<kristina.martsenko@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <mark.rutland@arm.com>, <maz@kernel.org>,
	<nh-open-source@amazon.com>, <oliver.upton@linux.dev>, <ptosi@google.com>,
	<rdunlap@infradead.org>, <rkagan@amazon.de>, <rppt@kernel.org>,
	<shikemeng@huaweicloud.com>, <suzuki.poulose@arm.com>, <tabba@google.com>,
	<will@kernel.org>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH 1/7] mseal: expose interface to seal / unseal user memory ranges
Date: Wed, 25 Sep 2024 15:25:09 +0000
Message-ID: <20240925152509.87152-1-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <zghnfw2vvrvlxenzx3oi55hzznxbx2nhcuwfk5zpe42bm4dxzv@zknjtfa2fu7n>
References: <zghnfw2vvrvlxenzx3oi55hzznxbx2nhcuwfk5zpe42bm4dxzv@zknjtfa2fu7n>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Thanks for taking a look and apologies for my delayed response.

> It is not clear from the change log above or the cover letter as to why
> you need to go this route instead of using the mmap lock.

In the current form of the patches I use memfd_secret() to allocate the pages
and remove them from kernel linear address. [1]

This allocate pages, map them in user virtual addresses and track them in a VMA.

Before flipping the permissions on those pages to be used by the kernel, I need
to make sure that those virtual addresses and this VMA is off-limits to the
owning process.

memfd_secret() pages are locked by default, so they won't swap out. I need to
seal the VMA to make sure the owner process can't unmap/remap/... or change the
protection of this VMA.

So before changing the permissions on the secret pages, I make sure the pages
are faulted in, locked and sealed. So userspace can't influence this mapping.

> We can't use the mseal feature for this; it is supposed to be a one way
> transition.

For this approach, I need the unseal operation when releasing the memory range.

The kernel can be done with the secret pages in one of two scenarios:
1. During lifecycle of the process.
2. When the process terminates.

For the first case, I need to unmap the VMA so it can be reused by the owning
process later, so I need the unseal operation. For the second case however we
don't need that since the process mm is already destructed or just about to be
destructed anyway, regardless of sealed/unsealed VMAs. [1]

I didn't expose	the unseal operation to userspace.

[1] https://lore.kernel.org/linux-arm-kernel/20240911143421.85612-3-faresx@amazon.de/

Thanks!
Fares.



Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

