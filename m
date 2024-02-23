Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CF1149388
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 21:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708725145; cv=none; b=EL5/hJWqmQ7n7Tn51bGJzVcpOvOLsDQVkq9eTiOVLI8akw8iR7u4wDoODSUHQuIfbDB9Rv8Ni2n64gmQTbcy+LJQ9aFTSj2l/RL7mKcgl8m3U01b8j7URC/6i+u1UuGME4ike5AU1sNvkDfvgQp1TPG9GiJXMmn+Zhy9v6XUc6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708725145; c=relaxed/simple;
	bh=WghNiSEcslFUkasOpQxww+LCo1yWX13E/n+PrcQm1Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NruTnlob7f7nTO1tZr1n4iMoAmoXJQ0ch06jAwsE1HwoU/1rcjryyqXkDjsWZCDtfSFnawZepWt+2CdGKpoTu9jp/Z+Ak4f7gFXDS0EpUQdVf7/7FOdvioPqgSROt61llqAbnkjHBlC6hmUaDefGvzDbV9gukwc6Nr8v65sA/9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gTIP7f6q; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gTIP7f6q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708725141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4hHqqqhFF3Gydbv6RBgXfAetBdxsg+N/xk7e231yih0=;
	b=gTIP7f6qjnayXOiMlXoD5jndqDv+4vM5rGrfvTzaU+1V9n9NzxjM+y5y1jn14ayzr0Alup
	gihCIRbnJOZmif+3rwG+dZ7aLlx/+jEluaXwtVcIJ26VjUfv/8+DzrCiF8dAC/Ei9CfmRb
	z+ouNR/5CcNUqGmcFIFNhsQB6qkfET8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 00/10] KVM: arm64: Avoid serializing LPI get() / put()
Date: Fri, 23 Feb 2024 21:52:09 +0000
Message-ID: <170872506306.206263.12047189993769691373.b4-ty@linux.dev>
In-Reply-To: <20240221054253.3848076-1-oliver.upton@linux.dev>
References: <20240221054253.3848076-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 21 Feb 2024 05:42:43 +0000, Oliver Upton wrote:
> Addressing a few more goofs that Zenghui was kind enough to point out.
> Clearly all of the bugs have been found and addressed at this point.
> 
> v2: https://lore.kernel.org/kvmarm/20240213093250.3960069-1-oliver.upton@linux.dev/
> v3: https://lore.kernel.org/kvmarm/20240216184153.2714504-1-oliver.upton@linux.dev/
> 
> v3 -> v4:
>  - Actually walk the LPI INTID range in vgic_copy_lpi_list() (Zenghui)
>  - Ensure xa_lock is taken w/ IRQs disabled, even after purging usage of
>    the lpi_list_lock (Zenghui)
>  - Document the lock ordering (Marc)
> 
> [...]

Applied to kvmarm/next, thanks!

[01/10] KVM: arm64: vgic: Store LPIs in an xarray
        https://git.kernel.org/kvmarm/kvmarm/c/1d6f83f60f79
[02/10] KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
        https://git.kernel.org/kvmarm/kvmarm/c/5a021df71916
[03/10] KVM: arm64: vgic-v3: Iterate the xarray to find pending LPIs
        https://git.kernel.org/kvmarm/kvmarm/c/49f0a468a158
[04/10] KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
        https://git.kernel.org/kvmarm/kvmarm/c/2798683b8c80
[05/10] KVM: arm64: vgic: Get rid of the LPI linked-list
        https://git.kernel.org/kvmarm/kvmarm/c/9880835af78e
[06/10] KVM: arm64: vgic: Use atomics to count LPIs
        https://git.kernel.org/kvmarm/kvmarm/c/05f4d4f5d462
[07/10] KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
        https://git.kernel.org/kvmarm/kvmarm/c/a5c7f011cb58
[08/10] KVM: arm64: vgic: Rely on RCU protection in vgic_get_lpi()
        https://git.kernel.org/kvmarm/kvmarm/c/864d4304ec1e
[09/10] KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
        https://git.kernel.org/kvmarm/kvmarm/c/50ac89bb7092
[10/10] KVM: arm64: vgic: Don't acquire the lpi_list_lock in vgic_put_irq()
        https://git.kernel.org/kvmarm/kvmarm/c/e27f2d561fee

--
Best,
Oliver
