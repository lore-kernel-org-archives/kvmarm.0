Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAB25CB8
	for <kvmarm@lists.linux.dev>; Sat, 28 Dec 2024 07:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735369754; cv=none; b=DfO6zt2W4to9uQSTbTuljRtwn43mr8QelnVlbCbgKDLvKLj0KcRlmGSf5Ui6mKYkryCwn2bsP37zJBwjb8IRGdq1JtHjHTnKx2ZT/xH8PxrhAXmLFY9kVTxhPScxU8Id8GI7nXKvmReIZEY5F80CVnOFlYWMxDC0pxg7YZVAzdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735369754; c=relaxed/simple;
	bh=rxXz1MmNHuN54yT8M/7T0NgZD/x6d7uTf6RlG0v7rQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txOgF2G1+M6t336h/3rIWfR9RYzxyAFAi4Zeq+ndS+QpdKAin1jmjIJbZIaARpAQA4jGOSsUtNnNKKaFEe998lIjfh8EbwSgnIkbYckONzdcEnXO2uU+9MjyLhmBuuXrrhaFD+I2/9kmJu3eS7wnkdgLFokHg8jYGp7XaFAzFZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OY26m7mD; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OY26m7mD"
Date: Fri, 27 Dec 2024 23:09:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735369750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V/bl5wEDeaiNds7u1yM+UwWhWCIetJXMbtJpgY90QJg=;
	b=OY26m7mDXk5361LiqXd/LFshVSsSJMyikA2h6xS5dDlHIH//2l0ZJs/TSDc+DdqoYDuPOs
	ZAQbgcBPMPcKJNdS4MIrWpp8vKS+IK1st2s5Tf+/QRfxt7QSj8GX8olxBt0VXTdjx2CA6X
	CClxqlO0kz9UX7UdU8mBCxOOqKhYPu4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Steven Davis <goldside000@outlook.com>
Cc: "maz@kernel.org" <maz@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: kvm: Fix potential overflow in len
Message-ID: <Z2-j6ZCQbvfNP4z5@linux.dev>
References: <20241228020119.12379-1-goldside000@outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241228020119.12379-1-goldside000@outlook.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Dec 28, 2024 at 02:01:27AM +0000, Steven Davis wrote:
> The MMIO sign-extension logic in kvm_handle_mmio_return can
> trigger an integer overflow or undefined behavior when len
> is invalid (e.g., len == 0 or len exceeds the size of unsigned
> long). Specifically, the expression (len * 8) - 1 may result
> in an out-of-bounds shift in the computation of the mask.

I don't believe we need this. len is known to be nonzero and at most 8,
which is already being tested for in the existing condition. See the
definition of kvm_vcpu_dabt_get_as() if you're curious why that is.

-- 
Thanks,
Oliver
