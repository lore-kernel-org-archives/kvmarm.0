Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FA83E49D9
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245173; cv=none; b=mknRDV2tMmQN5gf2iQ7HtsYVcH/SfcaJ4oXVJDE/BmXUnLNzi5piR5hrM8JkfwQ/HvuzsuWhEunLrSeBWm3Twlufi5W2GnLw67ZWWf+C0RBfjGJI35xn9BXnMRdl1UbmqXy5wXHWCHr3U+EDN3cma7KFzDdpzzbS1mu5WtuE5f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245173; c=relaxed/simple;
	bh=Wy2zSkCav37E28fvYomRF6kzOFW5oJTQtIbuBfXFPlA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OLbMPdDIWNBsUCpZV1lFRisEa79qFWdaQA1lUWnI2EECaAutuzB8nMEWbv3aVMK1zAKyjJA2dkgQSn9l5bLsDIXXhEp8bk1S6ggRdSeIzONV/j21ino7hSatXj/adzK/ubFKB8m4ThySL4u6Fed1WnP64r7kF5bzFXQZ0JX3lA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=op929JW8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="op929JW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815D81F00893;
	Thu, 24 Sep 2026 10:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790245169;
	bh=TZslcpdo8LVVv3KbnajTDG7QpxpY21058xGr23nNR2c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=op929JW8pk9V5xSSCBj3gfmqtlijbYSWaxW513KiSTtRacPj1L8UEhBSLMveUf7gL
	 LG0aBPKNX7J4qsM32U7/3KgP3cIocClNcODYZIIGKCCVPLAir5lh/mYjaAVOOBmPnf
	 CP06/w5i8JG0KTLfjrDj8Rkj3/AIC0iH3SWHc7rxN+fGxNpnegr9lnfZXcmW0GK1M6
	 u7bH/jj0bD7wz25vY9GS41ErHT1Y+BR3IOdP1qV+E915X0QwP40G6SNxJEOKeD8GL1
	 x8el1RPq1DrXU95xP6tEZJj9k/xv9I4hHnIwwBaQVEeFooSCHRsLX8xEf2QLRYKlYr
	 TsZbAfI51bzbQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v8 03/14] irqchip/gic-v3-its: Resolve the default
 NUMA node explicitly
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5lZXNoIEt1bWFyIEsuViAoQXJtKQ==?= <aneesh.kumar@kernel.org>
Cc: media-ci@linuxtv.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, dri-devel@lists.freedesktop.org
In-Reply-To: <20260924100529.1398790-4-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
 <20260924100529.1398790-4-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:19:28 +0000
Message-Id: <20260924101929.815D81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] irqchip/gic-v3-its: incomplete NUMA_NO_NODE resolution exposes a=
llocations to task mempolicy
--

commit 6d762ab83972132164ae57c1422f1916decb2fe3
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

    irqchip/gic-v3-its: Resolve the default NUMA node explicitly
   =20
    alloc_pages_node() resolves NUMA_NO_NODE to numa_mem_id() internally. In
    preparation for switching ITS allocations to the CoCo shared memory
    allocator, resolve the default node explicitly in its_alloc_pages().
   =20
    The CoCo shared memory allocator interprets NUMA_NO_NODE as a request to
    apply the current task's memory policy. Passing numa_mem_id() instead
    preserves the existing nearest-memory-node placement across the
    allocator switch. This patch does not change the current allocation
    behavior.

> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v=
3-its.c
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -236,7 +237,7 @@ static struct page *its_alloc_pages_node(int node, gf=
p_t gfp,
> =20
>  static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
>  {
> -	return its_alloc_pages_node(NUMA_NO_NODE, gfp, order);
> +	return its_alloc_pages_node(numa_mem_id(), gfp, order);
>  }

[Severity: Medium]
Will this leave other callers of its_alloc_pages_node() exposed to the
task memory policy change?

When a device probe or ITT allocation occurs with its->numa_node =3D=3D
NUMA_NO_NODE (which is common when firmware lacks NUMA info), callers pass
NUMA_NO_NODE directly to its_alloc_pages_node():

drivers/irqchip/irq-gic-v3-its.c:its_alloc_pages_node() {
	...
	page =3D alloc_pages_node(node, gfp | gfp_flags_quirk, order);
	...
}

If node is NUMA_NO_NODE, it passes it directly to the underlying allocator.
When the underlying allocator interprets NUMA_NO_NODE as a request to apply
task mempolicy, these direct callers will be subjected to the current task's
memory policy instead of bypassing it and using the local node.=20

If a user binds the driver via sysfs under a restrictive task mempolicy,
the allocations could land on suboptimal distant nodes or fail entirely.

Should the NUMA_NO_NODE resolution logic be moved inside its_alloc_pages_no=
de()
to ensure all callers are protected?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924100529.1398=
790-1-aneesh.kumar@kernel.org?part=3D3
