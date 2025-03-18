Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2331E175D47
	for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 07:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742284071; cv=none; b=np2DNAo4lv1QG5IU/5oairBsFRp4xwuSvpD2fnfi4d9fMLBf+gq4FDkKAv5kKSe3JAKzJ0bjx719XhUMemPOIbgb9vrAYiMgrh+zt29RwOKQpojV8MswI4TyAFvVfR0p0UmnsbfOQDW+mtQfn4ivU1tJh97j+cTfCu68zWNQ0vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742284071; c=relaxed/simple;
	bh=FyEpTVMAXHyHzYL5etlFHLqgUR6Jy8YUVW9FGFZ1aLU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQI5ih8UcgsdmhPatvQ55HtGuX+r3NlEdKavmDL2taCY+MsPwso/W/8uVaEuY1vWXeMxPFe8XhmDyDGl7ZQvwK7MP2z5NKeARu8GysqE/wjjezVo7a78O8n/79iCptQWC/eCh/aDExppRzhMhdcVqFE1ONfpMCgSOpIJK7LAME8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=idJSt6aL; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="idJSt6aL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742284066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rf5qZHxtK3mCKSr6NpOLubF8ArBJB08AFgLuR4bU4a4=;
	b=idJSt6aL5RAJe0a7zDM+Ky/FAFqk8PDtJOrD9qwYXfp2wHIiLaoRkaFaAJBUQbyBuxF1jl
	t3nKzAOtAxb6dM2QJ5pnAw3RxGjfI9EPjFUlLdMPAvvOHa6cOgTjV09Nvmyqnva57ch8RN
	tA85gUndW9J8a4bZz7CcO60t4iV8Txg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	stable@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH] KVM: arm64: Tear down vGIC on failed vCPU creation
Date: Tue, 18 Mar 2025 00:47:36 -0700
Message-Id: <174228404857.1652170.4192050516109561246.b4-ty@linux.dev>
In-Reply-To: <20250314133409.9123-1-will@kernel.org>
References: <20250314133409.9123-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 14 Mar 2025 13:34:09 +0000, Will Deacon wrote:
> If kvm_arch_vcpu_create() fails to share the vCPU page with the
> hypervisor, we propagate the error back to the ioctl but leave the
> vGIC vCPU data initialised. Note only does this leak the corresponding
> memory when the vCPU is destroyed but it can also lead to use-after-free
> if the redistributor device handling tries to walk into the vCPU.
> 
> Add the missing cleanup to kvm_arch_vcpu_create(), ensuring that the
> vGIC vCPU structures are destroyed on error.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Tear down vGIC on failed vCPU creation
      https://git.kernel.org/kvmarm/kvmarm/c/250f25367b58

--
Best,
Oliver
