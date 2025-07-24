Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074B672628
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 06:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753339776; cv=none; b=gpLFzCc+iTY4Pm35DQ3Wh+ApICoj5WHFiekLve6kebTY0STJ6zg76fly7WnodB9MZGiIW21rABZtblhYvIVbXA1VbLUD4D23FsvzKhWTGjvT9r2T5T3baMVRoiXiHovQ4X3wZXT6M0vVfWLV+7Pq+JT5MFY7NxSburZAec3Yjhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753339776; c=relaxed/simple;
	bh=y6gvWOKqn1VkBsT3jlz9WYen8QQOAewMeSoE2c1oUoo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XFoVpYHeoZ1hr99oBV4tHP9oDm6yvEXvnN/lS9VjOVJ7F2/HyTycRtLSSyMWNF3c0NMM3N+1n6Wpjo+sYl88GCyKWgqYXPUkLXXaGhVd69l45aMJdT85AQuHClFvieD1Bnd7WELCdnN0eJj8mtU8VYFcdNOgScxNYMEruyf2yXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w4JNZ6Yx; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w4JNZ6Yx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753339770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdPhV1djSORdygNBzM+zW90AvMnoqU9gTbw9K3O79nM=;
	b=w4JNZ6Yx5KIHPGvmSHnA9mjNs8BfRS+cx1o547/EFBYQ901cksc9I8GmD65dEvy3Cgfb2f
	5OjCZrBdZJuj37MB1wjtzP+UBFNGYjKMUHbNqefIzapCKxhweYzWW12k07hrUJ+K6v15oH
	CxXGvrrl1Di3Jqs0NcXBy0ePL3PJ5Dk=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: KVM: arm64: vgic-its: Return -ENXIO to invalid KVM_DEV_ARM_VGIC_GRP_CTRL attrs
Date: Wed, 23 Jul 2025 23:49:13 -0700
Message-Id: <175333974800.2689259.1785304263460558976.b4-ty@linux.dev>
In-Reply-To: <bbbddd56135399baf699bc46ffb6e7f08d9f8c9f.camel@infradead.org>
References: <bbbddd56135399baf699bc46ffb6e7f08d9f8c9f.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 23 Jun 2025 15:22:52 +0200, David Woodhouse wrote:
> A preliminary version of a hack to invoke unmap_all_vpes() from an ioctl
> didn't work very well. We eventually determined this was because we were
> invoking it on the wrong file descriptor, but not getting an error.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: vgic-its: Return -ENXIO to invalid KVM_DEV_ARM_VGIC_GRP_CTRL attrs
      https://git.kernel.org/kvmarm/kvmarm/c/4530256f3699

--
Best,
Oliver
