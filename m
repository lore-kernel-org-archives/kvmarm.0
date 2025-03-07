Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70226183CB0
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 07:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741332018; cv=none; b=Bwbk0/wmWT1lZuPMAPwksGi+ZuGiAu6jaGQAsAdy9bAumjPAC9kfxZK6mjab9NZ+enQbVFuLnr2WrINBOjLI7G5M0EcP323yAXQ77KK+8gJQTCduoMKq52psHAOnymO5UeYT5KdB8h/RmRreaxT1Unm+qN1xgXm/CQbF7DNQTwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741332018; c=relaxed/simple;
	bh=xq1grJ8mXwPn9Roe9X9TUKYEHJu7PmdsQ5T/TFipztg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Smp+cKNibAAElkH0RMBWu6zlhuOnYakjBbvEZ/XA+4wFKGiWUjL+kW+sbhT6p5vnKnRlBdT0moBx4MW2+wtVpXayj+jUdxi/GPvGyNB0uzNUWF/JaVSYN8VNa6mOqJKy8fV9/E35FxoDu25Yn3tOyd28ONR1IuV96/Du7dCwuoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PqsVloQn; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PqsVloQn"
Date: Thu, 6 Mar 2025 23:20:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741332013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xq1grJ8mXwPn9Roe9X9TUKYEHJu7PmdsQ5T/TFipztg=;
	b=PqsVloQnU+lGdYTBf0LnqVHZTJIOiLuAW7o6xlwPBe3yUu0v9oww45hkB/d+WCXqHKZ1pw
	zw4mNWr7rGkVwFX5yJCqOHU6N++SFbeC+ygzVf/MPm0lW6BBTLuiwa53jbJBbO7dAmpSPF
	qYz1+kBvQIl7RvNtS53h2klsA6y6cP8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 1/3] KVM: arm64: Add flags to kvm_hyp_memcache
Message-ID: <Z8qeIPfTOJU6w_8l@linux.dev>
References: <20250304134347.369854-1-vdonnefort@google.com>
 <20250304134347.369854-2-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304134347.369854-2-vdonnefort@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Vincent,

On Tue, Mar 04, 2025 at 01:43:44PM +0000, Vincent Donnefort wrote:
> Add flags to kvm_hyp_memcache and propagate them up to the allocation
> and free callbacks. This will later allow to account for memory, based
> on the memcache configuration.

It seems slightly more obvious to me if we pass a pointer to the
memcache instead, but that's just a minor nit.

Unless you have a preference on this, I can change it when I apply the
patch.

Thanks,
Oliver
