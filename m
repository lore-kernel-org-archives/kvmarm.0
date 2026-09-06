Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB221EB1AA;
	Sun,  6 Sep 2026 19:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788724290; cv=none; b=k2clwn1lSMaEWm1OfJroSvf69HYLRBsjQ36UNvAm+h9yXM1B8V0jyNtVYVDOANeX4hD8lV3sYjd/7GNTnhCv9RBHFrvxBzyMyZIMefmQqVFVMdlVANeZG+cPX3vjFp9vfulKdAla/gQTs1BmQ5OaoW+wqhqnTIErGlZ0QOh2/Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788724290; c=relaxed/simple;
	bh=X+rGxt486PLHg2o1bcCL81UCjA6d00/UwRhCqPSg3sA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m+h86v2u/ZwOWlogjblh8A56Pk87/g35XegFVMHoAugQb7gdZ8qpkCvTL6Qd9jAqLSi3mDB0GOFDBdXiCxwHaBRQ71NFhUukmM7HqhVW2qjtnejn4rKg6/EZhnEa9XxwBKzFg+ADNNsrsxwditMHv1Jk1PQmpSNFtvgG/znNIko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hlAfbfmn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hlAfbfmn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=qiOkN2AzUF8zp0EcSyLf5jxMJ8zF+ZH7G/GUNV10mX4=; b=hlAfbfmnl5ty0HVYC0h97CVVXh
	6UzMupThYwU0eCWCBBZzY0SXtml1Dav0Dgxat6QnNmUIFqhZEtp1ro9OTzgLVcrL8UJUKo5e/LfDb
	TZ4pu/FiFJXwPhL6UInUt1iz2tIq1UdpA0oFGry4UUArueawhheRd8AJHM4wyHQ8ovSTO2h80db0a
	9YKaZpArOo6rOTIOGUNBG7c1r2Ff+KhzlYYrY26tOdD/I/IDiQDI+RNgi13eBamnWHlDPaLrrcVvo
	ANXs1XzuUuWUso+cU2YjR46R+vImWHFzf+aUebdHRA9+hJbcRQKC3ixNE9eUyPso/ZlViqluP4phd
	lXNaG3Ig==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3Itf-00000005Wp4-29en;
	Sun, 06 Sep 2026 19:51:23 +0000
Message-ID: <379e8d47-8c1b-4548-8974-bff0c0a3c69b@infradead.org>
Date: Sun, 6 Sep 2026 12:51:21 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: KVM: Fix the event_source sysfs path in
 the PMU attribute description
To: Karl Mehltretter <kmehltretter@gmail.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>
References: <20260905085849.40479-1-kmehltretter@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260905085849.40479-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/5/26 1:58 AM, Karl Mehltretter wrote:
> The PMU device directories live under /sys/bus/event_source/devices,
> the document spells the bus even_source.
> 
> Fix the spelling.
> 
> Fixes: 6ee7fca2a4a0 ("KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index deb5c51bc00c..a3f20a4ee4b1 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -135,7 +135,7 @@ after selecting a hardware PMU.
>  Request that the VCPU uses the specified hardware PMU when creating guest events
>  for the purpose of PMU emulation. The PMU identifier can be read from the "type"
>  file for the desired PMU instance under /sys/devices (or, equivalent,
> -/sys/bus/even_source). This attribute is particularly useful on heterogeneous
> +/sys/bus/event_source). This attribute is particularly useful on heterogeneous
>  systems where there are at least two CPU PMUs on the system. The PMU that is set
>  for one VCPU will be used by all the other VCPUs. It isn't possible to set a PMU
>  if a PMU event filter is already present.

-- 
~Randy
