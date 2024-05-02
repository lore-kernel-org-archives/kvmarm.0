Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4145F16F8F2
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 17:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714669609; cv=none; b=jbALc1AtdmLnavFEFYaakZ+kurzYWQpc0b/qzyuaV77mPVYC2ISrudUVs7haq//QzuGydWehoD0wO/FBlUI9Iiz9a2SVQnNBWEbrZt/MoA1+YY6p/GRkMW7+6Fh7x9NRMNTIMS2LaWJZwC40Jmq/Sul115Rl5U6HwRa4zsZPmUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714669609; c=relaxed/simple;
	bh=5vN09ewHBnnQezmxdvtnqRp5HAhnR9Tpg1Dv9XHIcdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tAw9cKsHfja+GUgLuB3z4YmfTPI11kAyVPMgkYan0DqwUBdLR72phBTFFUTPSyvhRc98F3JItFfaBASoQyGJJ6LrlpelftGpqjdsXUxrS8f7Tlgk6NvPxvllEaoyfiCC7uNJDWDzaMDaUKFawDy4PwCozdegZIP/CPjvjx78IgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iChru80R; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iChru80R"
Date: Thu, 2 May 2024 10:06:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714669604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y95e8QMni8vICIQiNcuSVR4z7bE6sagf3Re/gvjO1NE=;
	b=iChru80R4XNRfPJICLXvzw07Nl7QWN2sbnBEgxMbVddeOsFpyLN40UE62rno5pp3ZtwAPE
	zmWIHkhjLO2P+YlAEd3GgWPcWbmqyf2awAskkEXndZGl6FnPWwGCy7Y/ldAKexfvFnJH79
	t8PY3EtqqYO0Z3rEQN8W8TRYR64xAfI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Convert kvm_mpidr_index() to bitmap_gather()
Message-ID: <ZjPIIMfB_QjUvPX3@linux.dev>
References: <20240502154247.3012042-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502154247.3012042-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 04:42:47PM +0100, Marc Zyngier wrote:
> Linux 6.9 has introduced new bitmap manipulation helpers, with
> bitmap_gather() being of special interest, as it does exactly
> what kvm_mpidr_index() is already doing.

Ooo, that's a handy one!

> Make the latter a wrapper around the former.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
