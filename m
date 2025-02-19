Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3062123E259
	for <kvmarm@lists.linux.dev>; Wed, 19 Feb 2025 23:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740007183; cv=none; b=nLNMLFkc5M5vm3KThGh0fSrkmb9JRY03xHvlkt2gws3XObK8cPb9E7woqRz7wT0+Zjjm6oE49MNDsMKjXUzuR//7wlKSSb9THzHElTwcwfZ0s2b5+YhzmJuYtqJEha0RCf2TbkTmnx6wNPvlChrxlyuvjJPJWxKyGlY9uDaluHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740007183; c=relaxed/simple;
	bh=O07bv4al2lH3D6yFE3t26uKbSZTZGVw79c0MQqtfdWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJcZSyj2MnjXa83w6JJwE+sz+PwV6Xdv0k+aNrGL69pEthwzNj+GB9YHTxg7VISxZikbtJ8n9EgMUvYVdPApxb8g+cuWTv/YYdfIspSw1eFOi9Bmc1LoaxK5OC5gBw7vC1SEOmIhGDdr2SaoGwycZL0ezq5ZtRcbSP1CXorbGZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gk7kc1I1; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gk7kc1I1"
Date: Wed, 19 Feb 2025 15:19:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740007179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KagvglZHupqGniUWXLUyr/N9cxv5t/e8DpCYVteqRYo=;
	b=gk7kc1I1O6oTn0eCT9zJmnuPN7tg+wSNX0oO/dv6TRU7OKCSIhapie8D7sPw0A922JNEr5
	xzEFD36nCDkGbUQYa7kQc4wh6VcJWlXWtpKP8DuRDFy63FxfU1kuVz3+BUqTA2R+SYh+8k
	rCDYlcapj2cry4xUSAlqmazWSQwRk0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 14/14] KVM: arm64: Document NV caps and vcpu flags
Message-ID: <Z7ZnB2z6psLcbfRZ@linux.dev>
References: <20250215173816.3767330-1-maz@kernel.org>
 <20250215173816.3767330-15-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250215173816.3767330-15-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 15, 2025 at 05:38:16PM +0000, Marc Zyngier wrote:
> Describe the two new vcpu flags that control NV, together with
> the capabilities that advertise them.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
