Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5218E1E260C
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 21:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739394083; cv=none; b=XFVqLcly4DFJECWH2XEnp2ipNk4RF95+sgrI969vraXyLzEc0w82VR5C388cEr++tzf+uK95PAbM3xjHe7IhDWXPrzEyxPvFWvBzUzQDW5Dz3rm82j+YC5NB54FeO0iEIUc3jegji6UGnTNoNdZgxEfKC7RQrsqhplcns6oRpjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739394083; c=relaxed/simple;
	bh=nOCpzrb+HrnU/dDq9GGPVrCrUEH8ZmGM8zfSjKkq9tI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDccMD9Jwn0W9VJu3TseziqvlQRN5J4Sv5ylU3U897oXbWni2umMh9/yWdhaRL80vWMFclnBaiAgY3VeCC40a7wcmELYOIKDKyC42GJXgRW8Jt6G05UF47JYzSXidc4JEWN2kg3QOucmmDgOrkCMILsDlUJn2XNCaDRdXLNwKOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LdyeZg0L; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LdyeZg0L"
Date: Wed, 12 Feb 2025 13:01:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739394077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e1ZMUuqxcnvd+DUeR/RMfMUUTtsKUO/qlLecFMsIoTQ=;
	b=LdyeZg0LYJkM16jmF+N4f9uccObhtqQZwI6qWB3hW5h0sfJe9tTF6cr+UB0Pe9Gy8Ywgjs
	cpGfAlreNGGy8/goRh7K5vCWc4HYOIj4U37rfSVCLGyRLOyfvOYgpYZqVT3RXndW2urXbv
	IgGI8CEmZsk7LReXCIi+NulNe8CrwcE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Convert timer offset VA when accessed in HYP
 code
Message-ID: <Z60MF6KLM44-Gnu1@linux.dev>
References: <20250212173454.2864462-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212173454.2864462-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 12, 2025 at 05:34:54PM +0000, Marc Zyngier wrote:
> Now that EL2 has gained some early timer emulation, it accesses
> the offsets pointed to by the timer structure, both of which
> live in the KVM structure.
> 
> Of course, these are *kernel* pointers, so the dereferencing
> of these pointers in non-kernel code must be itself be offset.
> 
> Given switch.h its own version of timer_get_offset() and use that
> instead.
> 
> Fixes: b86fc215dc26d ("KVM: arm64: Handle counter access early in non-HYP context")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
