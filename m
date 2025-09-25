Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0142BB13
	for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 05:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758777678; cv=none; b=uMXII6xZ4TpHl8SA0zznzxiyuR0zOXKWDPSCUkEl58Y7W6+DucY5907XKbsuzKzRutE+y+B0ksP1eSzT2J0b0vt1FfcYVaoAGost5nr0aCpi4M66mXsOHyTYt+zefhHlFzGCe+pnRhfSay7rsstx85Pdr4IaW1ccyKfb1aF+pw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758777678; c=relaxed/simple;
	bh=QJ5+0wjraIEujbih+olFy9sPJQrexpoWpNOxO5+dO6I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RjgQjPy9wWSCMOPDHXG/riqD3N1SaRz3dh6N76gOlq94gHu3RiOS+RwFCqH+XgKQb5Zu1uN66kMneY6BuAtnJSphQBPOqlPvdCYpWUpKzcTFfBNx1x4tm2YIEEKsrl4K+UVpVXrwZ61b3otE91tYuNvg+sJXbkIpotbSCgYjd3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=gTwl928X; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="gTwl928X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758777676; x=1790313676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1dHu+qfF+j3DIMFKc9HeoPvreOucdAuO+Jk5woaNYdI=;
  b=gTwl928XUs8lLZ8ac8I2Vh6KYfUwDRnfUyM19TYaO/BLz5ACBstJlqpb
   ZQf425oZ2xjha6U64hKluQGIpb/5pNGoctp/O+P+/9LxyVeB42WDKCosd
   Pqvhj158Pra2NqfNlfQV6TxHWYDMmRlacT57iyqfQGHasYOJbIoWaQOit
   Mn35VEyTs4k5DuG2MOfUxZv8fYyQT5ZO+bBu+WI4qSRXaD9MNVpMGm6FR
   TyAYNptvw4FlxAoRD/o1RHayg3BhHiQ6ru16frfU6XjOmMS8FTNB7uQG6
   KFn5z2lbY2c0dlPwfUgcRkmEahhRNs/to9Cs84f6SakVrU30JxcuDudUf
   g==;
X-CSE-ConnectionGUID: 2sgSshe0QCCvvjHAJKOFKA==
X-CSE-MsgGUID: iZZgazSASsCExdr9yR06Mg==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="3510852"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 05:21:16 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:54803]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.48.62:2525] with esmtp (Farcaster)
 id e01fb47c-faf6-4c81-a5a5-f369ea6453b8; Thu, 25 Sep 2025 05:21:16 +0000 (UTC)
X-Farcaster-Flow-ID: e01fb47c-faf6-4c81-a5a5-f369ea6453b8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 25 Sep 2025 05:21:15 +0000
Received: from c889f3b3a561.amazon.com (10.106.101.18) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 25 Sep 2025 05:21:15 +0000
From: Priscilla Lam <prl@amazon.com>
To: <maz@kernel.org>
CC: <christoffer.dall@arm.com>, <dwmw@amazon.co.uk>, <graf@amazon.com>,
	<gurugubs@amazon.com>, <jgrall@amazon.co.uk>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <oliver.upton@linux.dev>, <prl@amazon.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Implement KVM_TRANSLATE ioctl for arm64
Date: Wed, 24 Sep 2025 22:21:08 -0700
Message-ID: <20250925052108.27351-1-prl@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: 86ecrx1px2.wl-maz@kernel.org
References: <86ecrx1px2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWB004.ant.amazon.com (10.13.139.164) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On 9/23/25, 2:26 AM, "Marc Zyngier" <maz@kernel.org> wrote:
> A guest doing this is a sure indication that it is completely broken,
> and will fail on actual HW, because it clearly ignores small
> insignificant details such as *ordering*.
> 
> My other question still remains: why can't you perform this page table
> walk in userspace? It is actually much safer to do so because you can
> stop other vcpus while inspecting the PTs, and avoid a vcpu playing
> tricks behind your back -- something the in-kernel PTW doesn't try to
> avoid.

In our case, this comes from the Windows TPM driver using ldp32 to read
static adjacent CRB fields where ordering doesn't matter, but I agree 
that a guest relying on this kind of translation is problematic. We'll
drop this KVM_TRANSLATE implementation and pursue a different approach
instead.

Thanks,
Priscilla
