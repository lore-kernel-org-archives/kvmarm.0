Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F641339362;
	Sun,  6 Sep 2026 19:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788724433; cv=none; b=FnMVUmh1bfQXIbx3KMGv+ru3np6MRplIP77r7w1hYkrjUB67SiNJkY6IZo5spTuldek0ZbWdiljGOEDibr54QFQ6ZuELNFdJFSAYMUHcgDZt7PGgZXA80z+M/nyiOahEfufUsFl5O3T3PLsO6YMgSWl8khBltQxocaMFyz0ILe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788724433; c=relaxed/simple;
	bh=8keelnl4CzscbpgILS1t3dYcg1V0XmCwseCKnZ1DLBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CNpKtbm7pCNtMLsXt1UvUnoKgYP0cgM4zEFRdbH3DqscEAymaCV85TEgvct3LCPH78rvXYmbLXnYMgqlKI00gdhPA6Z5kLP6Pz7hbkDaZGjZ46YQbIoVPQzJKuuE5vGBUuQgfrJ5HkNW9yQ8KajqYF0Tq8AiRW57bM8T+t0FTVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SvntvIWE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SvntvIWE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=wGZySnTODouTVoi6FvegzmrXkqgJBwxRhbPrYzFeY5Y=; b=SvntvIWEubIDpDW/HalUZjUHC8
	ge/RWPE4Ne4N4Q1lnrswkEWypoRuz4Z6dqL0E/c/5+B8ZuHxHSF1Fgc+RQ6BVGYKE1DviV9qoK6eT
	IEgdep8Cz7Tm08PycF9BrVIW9mMQMwIJkE/TIjUHoxB1EJxo9CHGbiM3imZwIR1sd+k3lTdHW8enq
	PAtEoFGxj6Y1YF+VWDlnsrPmOqpu/wDAHJtsIIVkjfliN4jobzjDmgvPqHAERKGL6ZCivkBQE9DKg
	KVYG1U6f78Q5jH9iB+5fxAbnQVWAMxCdMilKreVzTH7SLxzcdapCO/OaNO0HRqYwjW2hfo9KGPqvw
	TkowRyRw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3Iw2-00000005Wuk-1PPa;
	Sun, 06 Sep 2026 19:53:50 +0000
Message-ID: <e84f235f-5510-4b71-9232-744467aea8d2@infradead.org>
Date: Sun, 6 Sep 2026 12:53:49 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: KVM: Fix the struct kvm_arm_device_addr
 name
To: Karl Mehltretter <kmehltretter@gmail.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20260905090655.40683-1-kmehltretter@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260905090655.40683-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/5/26 2:06 AM, Karl Mehltretter wrote:
> KVM_ARM_SET_DEVICE_ADDR takes struct kvm_arm_device_addr; the document
> names it struct kvm_arm_device_address, which does not exist.
> 
> Use the real name.
> 
> Fixes: 3401d54696f9 ("KVM: ARM: Introduce KVM_ARM_SET_DEVICE_ADDR ioctl")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index e0430cc750c9..7a2de8640226 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3676,7 +3676,7 @@ type KVM_X86_REG_TYPE_MSR, but are NOT enumerated via KVM_GET_REG_LIST.
>  :Capability: KVM_CAP_ARM_SET_DEVICE_ADDR
>  :Architectures: arm64
>  :Type: vm ioctl
> -:Parameters: struct kvm_arm_device_address (in)
> +:Parameters: struct kvm_arm_device_addr (in)
>  :Returns: 0 on success, -1 on error
>  
>  Errors:

-- 
~Randy
