Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A468194AF3
	for <kvmarm@lists.linux.dev>; Thu, 19 Sep 2024 10:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726740703; cv=none; b=l6gLlmLsKohANyOiAT2hQiE/cgd4K9tdhS9Sq5VmYydlsiETwxugVLUJQGBK3sdj8Q8E419J61IyrGIqwNjaKRAu3C4uSLcLFoI/ljV/rkYc20WxQMn0AJxf82mUSOOD0+9nHbcY+s1RZcAEew7HkK/dWaezVqMz7vcJl5EkooU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726740703; c=relaxed/simple;
	bh=Ik5dtNOPe6dNsVbYm1h1UxJzTsasXruAxLXvVsNqugg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Abxu0DopZ1IC6IqnNci87RuH2oBFzu0VseVN2TNs2KONrhtwc80xPSkmdRjv1qMEQQUvSG3hPx19JPmEtNMJWNC6q2AeqKQ8dCTh/lS4+uHAdNoMGZ2CXMRaElK2H08QG8zrjUW8sly5+OHlbgUvCgjptCr0LJMWkH32q8GEGIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rS+C0u7f; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rS+C0u7f"
Date: Thu, 19 Sep 2024 03:11:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726740699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a4pK7fNFyKL+S0ZLVb5Rxswm8knV6rJ9TdzPpuNv4is=;
	b=rS+C0u7fwQczXY6G2gjz4AgaV1kb0UC6eaJZKAriBW7gZS0Q+olIGivMCaR+e+NyyUm0iH
	boylKfB/Vu9OGBHy/3X1XhC5Zx6sBoHLV0VIiGs3JTW+am7bbE0CWvNNbdR8yvMn02eAZm
	HaXJLp3ucrzEECXrbt/Ei8BrHiBEzwc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, tabba@google.com, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Fix __pkvm_init_vcpu cptr_el2 error path
Message-ID: <Zuv41W8FOFFnaw4v@linux.dev>
References: <20240918170502.1881517-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240918170502.1881517-1-vdonnefort@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 18, 2024 at 06:05:02PM +0100, Vincent Donnefort wrote:
> On an error, hyp_vcpu will be accessed while this memory has already
> been relinquished to the host and unmapped from the hypervisor. Move
> the CPTR assignment to prevent that access.
> 
> Fixes: b5b9955617bc ("KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM")
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

It's minor, but I'm guessing the original intent was to initialize
cptr_el2 outside of the vm_table_lock. So you could do an early return
instead:

	if (ret) {
		unmap_donated_memory(...);
		return ret;
	}

But again, minor. So:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
