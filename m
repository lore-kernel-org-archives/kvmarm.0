Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20F1132493
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 17:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287935; cv=none; b=n0ke01NhI9YwYr471lKaDv1lj66nn1nXrlj+Qt0ew1MC7nYBf1RzLY4T6cJrMO/TdR3dH62X4en5NWeFmdJd2XIx5mM8Zxoiiq/BhJGR+HTOabXZ42h5XPeUAXCp308shucK/4nfCIuCCbT4wiT0FceohVjebBwj4skZcmagGTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287935; c=relaxed/simple;
	bh=KUkV7qqPPIQrEZHCFmClsl4/k90t0q9GLPFe9j9GzPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qceB0FqXpnKP4O9dhWqTysSUQmihFY7Xu8b/xhDZIa8ZVdWCsEcnO8YzhGxAUZnV0XOWJ9vk2Xhnb4I7yRXsJjeFvOzIUgEjViEMG29YGi5ZIgJ1RHfWvEXyH4Bd9g2YXBnYZJogdJJvDgf7tX97YJ2Wx2XPDdUaTxo1mVLhy+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dA0Zt2N+; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dA0Zt2N+"
Date: Tue, 16 Apr 2024 17:18:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713287932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7hAAV/b/FKBG5gcfce8+9om894JRnpuMXOa04wwFFfE=;
	b=dA0Zt2N+sHUz2CZiWle3bfGLBZ6kuoNLz9hhU3hVp+NpZ+OHHd9d0ybeWd3kBEPVa5+y/I
	s9lhWF8iCGQJpM51ueHCbYvhQvRhrgMu21Zi5Mgs/uke333YTMV7oqzL8m7cIPQKDdAF8Z
	oIUve5w4yLrHcVuURCjMy1jM5x5ztbI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v2 13/47] KVM: arm64: Introduce predicates to check for
 protected state
Message-ID: <Zh6y9osWthu-gPtN@linux.dev>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-14-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416095638.3620345-14-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 16, 2024 at 10:56:04AM +0100, Fuad Tabba wrote:
> -static inline bool kvm_vm_is_protected(struct kvm *kvm)
> -{
> -	return false;
> -}
> +#define kvm_vm_is_protected(kvm)	((kvm)->arch.pkvm.enabled)

Shouldn't this predicate check the static key (i.e.
is_protected_kvm_enabled()) first? In fact, you could hoist that check
here and just have vcpu_is_protected() call this. Unless I've missed
something obvious...

-- 
Thanks,
Oliver
