Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012D73A8EF
	for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 07:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713424209; cv=none; b=FvbtzrU6IfPCaMffR85IZIItF7qLU8MtxKpRguYFk54Wr/axgEXuvxSGzUerSq3fORm9P+lGd/c9uqHLCZx3qE7gRjj8Zb417nJOmxCkzkXTDtbEtgCwlSvITGYMwApvsOenwx9/7ZgHT5UuH9W95htRGxGIpmyugkmW8pjbejU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713424209; c=relaxed/simple;
	bh=rEeZyMyRdetZw0digCbVNJOeb3XjA7vXXUxfllL4rMw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=msiRWqzu/+4pkqY5d0MKNnu+o+4Z/0CumZuT/og/oRRPgyTfxTIb9o6/fF/bMDW7PHNnXvWo/PwYcIBb8Wx8Y9wYnY60Z9cNiKZnzbD61LfoiANmNs32foHnqvt5/PogQTQ8r0Ku2j0dgY8knZVGTIsOY9nRj8r/Q0CzF/Y8U7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Marc Zyngier <maz@kernel.org>
CC: "oliver.upton@linux.dev" <oliver.upton@linux.dev>, "james.morse@arm.com"
	<james.morse@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
Subject: RE: [PATCH] KVM: arm64: Consider NUMA affinity when allocating
 per-CPU stack_page
Thread-Topic: [PATCH] KVM: arm64: Consider NUMA affinity when allocating
 per-CPU stack_page
Thread-Index: AQHajuYSEQnMbfiDFkC1SUvVaEYWGLFoa0cAgAUw1aA=
Date: Thu, 18 Apr 2024 06:53:58 +0000
Message-ID: <f5228e62a05c45a7a61698caa0543485@baidu.com>
References: <20240415033614.43518-1-lirongqing@baidu.com>
 <86bk6brsb5.wl-maz@kernel.org>
In-Reply-To: <86bk6brsb5.wl-maz@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex15_2024-04-18 14:53:58:552
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-FEAS-Client-IP: 10.127.64.38
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM



> Li RongQing <lirongqing@baidu.com> wrote:
> >
> > per-CPU stack_page are dominantly accessed from their own local CPUs,
> > so allocate them node-local to improve performance.
>=20
> Do you have any performance data to back this up?
>=20
> Given that this is only used in the non-VHE case, and that by doing so yo=
u have
> left quite a lot of performance on the floor already, I'm even more surpr=
ised to
> see the performance argument.
>=20

Sorry, I have not setup to test it.

> Furthermore, you don't address the allocation of per-CPU data, which has =
a
> much larger potential impact, given how the HYP code is structured.
>=20

I will add it in V2

Thanks

-LiRongQing

