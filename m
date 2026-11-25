Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628450;
	b=DUJ8ZQYh3dKh6fVfLGpk+JfXYX1lsMLmcsUsFwuJDR5MWmq6Mi3U2xtaAbs42iFwk9+T
	 SdO9rzTZwCDaAttffORfGxFXpDpC685iRwPYmfcy9lxOSTD017rya/WnxPvQyoEAm+Ktg
	 IKunFhVnW/2GeuWHfsZ4X0CVXrZsZo+p2m6PAvDWQtZWILUIpZUyOcF8Zp4OE1y1slrdO
	 b7xF7gqIyoeq0q0cbJqqja6VB9KcIgL9V9isCfNlA8EEtd/vJxFlDBuTZ9+9jL0PvXzIv
	 X0KCcUekefwZCJ+tNdlG2TIegzoUpYilf3DnNUhEGUrQ6lvcfMffi//h4yCDXV0WXiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628450;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=nYycouvr6zOSJsdG8B1rvzwHCG0khxitcfoXgjaouMs=;
	b=XVT+ctC2yG1NA1Tp+Dxyq/9v5ftzmpbCfcit5hTU7wPl+7WX8xENrcnRR6VgjKtP0Ky7
	 gmCrhPNHCmIxmNh9/ghqE7HyV+k0FtpiKaj0BNq4YlQMZUl1Pjpi5yRHU2h6jHp0z2Tjo
	 Nj7FmVkSZWEvMH1EjtmsPNAfKmnWE7b7EDZOjuHhEEB+glYLnhrFbxpnP8pI9AWpn/KAX
	 LJ1O5yHDt0dhbzG39NFwWYnCGO/gU33wFojly5eB0SQuk97/PAVGalTY+n6XFLTL+AiVa
	 iPCqWNgQp/Hy8GNdvqeYndv6UXRyQuQinytbqFwXjUk9ws8pvSkLDbm5NiHE0BSTuEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Oxmr2/iN";
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E79606A32C
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 17:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46E79606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Oxmr2/iN
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b41188c8b9so4282118a91.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 09:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795628450; x=1796233250; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nYycouvr6zOSJsdG8B1rvzwHCG0khxitcfoXgjaouMs=;
        b=Oxmr2/iNXHIYGO97eStW5GFs/7nSwJvY060y9XktMXf45GGOIPddX2tvelqwgjRGqS
         qx7FcuiNtxRV4Gnm42uQT8W0CVzxPVrBHYSTwQs0M8ZV3MBRHt5jRBcLC0VGHCMuXj7+
         ZqKwMWge8sctBL4MhdArAuKHJhSFWZuKxBLI5KqAoQJVAkb8lDSD3ZJufCfePDB/lbAb
         hMx70nET13ew7mgloCsmTIGydgXAcTR8Ma0hmfj/V5K2sVfLL/I340PXIO04CjHyqG9V
         +2/l3AXo8TFmoOwET8oKCAjQ+xtEQSPQyrRCS4SkxjT5be5E+aE+GaGU0v/osNgAMoei
         XUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795628450; x=1796233250;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nYycouvr6zOSJsdG8B1rvzwHCG0khxitcfoXgjaouMs=;
        b=xOslNUdVznuug0Cpq/si4ncPt9YPWwFXHVhcGmJjKTY8y7ftnvA9iMQd1vkccKjWEe
         HKgSCG9Ps9QWmssO3iBxoQAcotRn0HxFwDGqfDlzi+D7cFYo7ot154gbyMp75KvQTBQn
         SWMy+vUvbl/Za+gTz0LZvUpoG6lIXvSziPWXVTW8EX56pcgJkfh1nUFzZ0rX1Z71Hy6p
         O3RjCu0FQvDc6nQ93aiwGwaFt9XcADhseud58BryEROn6kdNQuv2iRTYuqaRhrfc450E
         Jdp8OJV1rZFYD4wtJw9xm/PlLzk+jYu2c2hpD3XAsEOzkzkGLIbi64Hqh/Lhw2eq6PNQ
         xkjQ==
X-Forwarded-Encrypted: i=1; AL+hErGUfxy+1tEjMajDP3cbNqKpDHSje9QAhVa+mkrnKDBzaxHMpxPxZktaoEM9h4WBZelpZG+KuXs=@lists.linux.dev
X-Gm-Message-State: APuU4Z846Jk9wjieGBJGn4tkB7P+POyH+DAv1hmgRpsZBi+5poEuc3q+
	2vCMzY4UdZ6yy3zknuQmvjYKpteuEXETcchaPwEe3YEvcGZMTYiGEhaDADcW7ob0UQ==
X-Gm-Gg: AZFdTZcVONtTwNyHgiPU7ZU3MTEzSVh24XfDy24X7A6CNsBvMiPTCCCl05a8EQxq+Br
	Cu+VB/pNnThGtMPgr3AB0o7bzJehexo/YdX08w1PUm1H56mAX/e5tKkBJJBApl0sxAgjcHQFNo8
	r42jluUw83t9E2SY8GyHckVD+P+bFlIdPxiwHEr8JCx8N5tnrn2rFcKxM2I+AFWvRr3FRLYQkyR
	PoUL7E9CsPeMdgUHtG7k8yg+1DSsRO3nX1pxLblkKepAiudLQY9DlzWiVQ2RM+KcyhdTQtf4KYm
	ufZ2HSW/yOE17HpDYjZgknqGv32A6mRGbRIU6XnBu+KNCTpGCQBTuk8JTwxsaqo7Q4lfZGmqiFr
	AdewWTv7Qaywa1GFRtgdmo/h8F6o0sXrKhnjvxYBdo6s1eysoR+6g6sC+RD84W2OgI9hBqLWIy6
	yEwuIYTBN3XJcF+cTxxD8Uk6BaWD8JuIWDu+EaroF9u7QBKXx/UVj3mtLCOsbytUSor7bFU88IW
	M9sGKOA8AFWAX8szfadyoQorfQkhuUbnRlAlytrDrev2JND18NQSXoKsPOYEL2J/JtU8gKy1LUM
	4K2Dgyp2NnKkHWrQPbP8vCa1dNmgUbQG8Hd6aW1j3Z4Y+oclNea2S93+o0/52N8i
X-Received: by 2002:a17:90b:390b:b0:3b3:fe22:2745 with SMTP id 98e67ed59e1d1-3b41c933edamr18216503a91.45.1795628448898;
        Wed, 25 Nov 2026 09:40:48 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecbd0bsm31676002a91.15.2026.11.25.09.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 09:40:47 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Nov 2026 09:40:47 -0800
Message-Id: <DN4H5ST3X9L1.3IUEC1CA5QI8H@google.com>
Cc: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, <seanjc@google.com>, <jgg@nvidia.com>,
 <loganodell@google.com>, <arnd@arndb.de>, <dwmw2@infradead.org>,
 <baolu.lu@linux.intel.com>, "Bjorn Helgaas" <bhelgaas@google.com>,
 <oupton@kernel.org>, <alex@shazbot.org>, <gle.com@google.com>,
 <pbonzini@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 <kevin.tian@intel.com>, <joro@8bytes.org>, <kvmarm@lists.linux.dev>,
 <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
 <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
 <linux-arm-kernel@lists.infradead.org>, <skhawaja@google.com>,
 <sagis@google.com>, <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc
 via serialized pointer
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-4-tarunsahu@google.com>
 <2vxz4idb1i2w.fsf@kernel.org> <DN3VG4JCILOO.YN40XHHSWRPH@google.com>
 <2vxzld6hx97g.fsf@kernel.org>
In-Reply-To: <2vxzld6hx97g.fsf@kernel.org>

On Wed Nov 25, 2026 at 6:43 AM PST, Pratyush Yadav wrote:
[...]

> So I wouldn't want to support slab until we have file handlers that
> churn through a lot of preserved objects.

Makes sense. If KHO slab isn't coming, then I'm fine with the arena.

One thing I realized is that the choice between the two is visible to
the incoming kernel. With separate allocations, the incoming kernel has
to free struct kho_vmalloc and struct memfd_luo_ser separately. With
the arena, it must only free the top-level allocation. So we should
pick one now (while memfd is bumping its compatible string anyway)
rather than switching later.

Separate allocations leaves the door open to KHO slab but wastes memory
in the short term. It's not obvious to me which direction to go :)
