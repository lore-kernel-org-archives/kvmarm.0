Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE723C3F5D
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 07:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643680; cv=none; b=Y7qjltuFsEYAf6rtkC8OOeZpL0JgOsJFULr2PxLzGVC+Uds7SGz2tx574c1WjIh9/dx14cUtphH115wkKGCHBi6KZEBe+vu3Lr59ReIJcsTQXXJkLWT0hyjBPQdrhTe9o7sGSo3FI9hdMbvvuIoEhWlec3AP1WAPoC607Y5E/fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643680; c=relaxed/simple;
	bh=GCAEqQGQNPvqSxXDrYO7c33GdAgGfF200n96Z4X80nk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FOffGhgAWa2y9F3xYN3KMjEu92S2UoWnl5y96u7rfiETf0P9vjUWsEWW/WxmSPJWEihVwZfT9g49HRz5uaU7JmGAH9+r26rEY9lqyFSLikXkpLCq2XRiRg3aHOAXIMoIZ+iK0lFTEnnJT/q2voDqSabojkVfHU2bkuw06gRwoBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfCxzQa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfCxzQa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC661F000E9;
	Tue, 25 Aug 2026 07:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787643679;
	bh=haTQ7CV1qHGSjY13Rrvt3+jWVz+8xy92nwC33Cx3vgg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kfCxzQa7w97/BvZ6Qu5miYBJTDp3MM0rdNJbMmLljpWsfsWJdMPMrELTaz0kkLlym
	 7vDkWHEKfP2cPeoh3EnkvfloRRkN45fvEoRon0iJcQOiMLcKxdR2DygpjWgyt6/mbR
	 BS4J+zNpn1z8nAdqf+GVouigJD/98Jdetug7wxP8oZ31xQOhyC2qablF0YcWiqltqG
	 xUzhdoBcngObzzGpVKQxSM4cDYoRg35aBIL8r3ZlNLOsU70i1d7xdQq/eq3WODJ80f
	 8EkY2A2OIrCao++dkPf+j9QfmY6mfhC7T8W4rxxTL6hgt6abN/KjAerFYz3gln1+yM
	 0NoMKBE5PnQ2A==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
	oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	kernel-team@android.com, fuad.tabba@linux.dev,
	qperret@google.com, Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 06/17] KVM: arm64: Add pkvm_hyp_req infrastructure
In-Reply-To: <20260731143541.956291-7-vdonnefort@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-7-vdonnefort@google.com>
Date: Tue, 25 Aug 2026 13:11:10 +0530
Message-ID: <yq5afr02wstl.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Vincent Donnefort <vdonnefort@google.com> writes:

> Introduce a struct pkvm_hyp_req to enable the pKVM hypervisor to request
> resources from the host.
>
> Provide serialisation helpers to transport these requests via SMCCC
> registers (starting from a2):
>
>   pkvm_hyp_req_to_smccc() to encode into the SMCCC args.
>   smccc_to_pkvm_hyp_req() to decode them.
>
> When the hypervisor raises a request, the host must handle it and retry
> the HVC. To automate this sequence, introduce the pkvm_call_hyp_req()
> macro. This intercepts pending requests, invokes the handler and retries
> the HVC.
>
> Additionally, introduce a trace event to track the handling of these
> requests.
>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>


This is very similar to the memory-transferring SRO operations described
in section B4.3, RMI operations, of https://support.arm.com/documentation/den0137/2-0bet3/

The SRO model covers more details than the pkvm_hyp_req infrastructure.
Should we look at making the two more similar?

-aneesh
