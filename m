Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA7F1BDD1
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 09:53:28 +0000 (UTC)
Received: from [192.168.2.59] (109-252-153-31.dynamic.spd-mgts.ru [109.252.153.31])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dmitry.osipenko)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id 470E56607181;
	Mon, 18 Sep 2023 10:53:26 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1695030806;
	bh=IjFrlopWOaN1CduUHxVI+ag5G4pEjLhQeTjWB3O0R+Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jd6mXEc/m6VOamTwaErf2CNnWTdDkHbgh1N2AHv89y+qjyb/x8XmMoeyFbf9hR8gO
	 bl2GR3JS59b2dhm1TT/sI7yTI6RGLqnqcrK69ikcNkKYcRHav5KgQvweNeY3/rre5I
	 Y5pJq8k8ESL/ZK5JO5gixAvjgrc2N3p8CPEJS088u5437NV0NL1EcrM+FPyS/RTsdk
	 Ai2IRrwSGjxj+lIfawI7pNQxGWI6/Mue3oBwz++V+HTVgE9jGXlf6axG7Y0xFpy5Yi
	 Yf3HetdCA/Y5VYXBjaqG6Qnds6dH0yWTq8V1LyG2N319sKjbN/KpKrx5p1E2LzCpY1
	 PohXVy9y98YpA==
Message-ID: <d272613e-aed9-4cbc-26dd-78bc8fca2650@collabora.com>
Date: Mon, 18 Sep 2023 12:53:22 +0300
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
Content-Language: en-US
To: David Stevens <stevensd@chromium.org>,
 Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230911021637.1941096-1-stevensd@google.com>
 <20230911021637.1941096-7-stevensd@google.com>
From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <20230911021637.1941096-7-stevensd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/23 05:16, David Stevens wrote:
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -848,7 +848,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  
>  out_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(fault->pfn);
> +	if (fault->is_refcounted_page)
> +		kvm_set_page_accessed(pfn_to_page(fault->pfn));

The other similar occurrences in the code that replaced
kvm_release_pfn_clean() with kvm_set_page_accessed() did it under the
held mmu_lock.

Does kvm_set_page_accessed() needs to be invoked under the lock?

-- 
Best regards,
Dmitry

