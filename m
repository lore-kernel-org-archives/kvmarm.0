Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BAD52FE4E;
	Tue, 22 Sep 2026 16:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790095762; cv=none; b=aM5tMTx0O0SfVoQBSEidYsAKNZTXhZm68iqyezhuXeXC24DpgFD6/7Gwg8LH4GCfTGap7ywPE7IZonVfBFEn4EsS6XpIJuqPgpMzvxQhc9Y9VEBzsrq5aizLzTfmwezDv7Ab10zZEIiVa+wDJ580jDsbd+yAxkiq40e1t2E2bzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790095762; c=relaxed/simple;
	bh=prIXwhQ54/LAQl2GDN5y6lppyuyJ4FjHuDqhUxnLRuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LjpgNG4MK2sXjI3pOIV/DmAcfCOWA+xNdVfYU8Q7tIEF/yVKqwX+vGpI4AZnkf0H1aLrLdS3EaifpN1GCXNh/BOBcTtZsTrwJLqKZOBRE79b4rB9d7JMY2mtR+SGHJU+YX776v7dmeLU6987Yuc6UoafDJDJ6OoJ9xPPg2KwVDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DI4wOHa1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DI4wOHa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A231F000FF;
	Tue, 22 Sep 2026 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790095760;
	bh=R4AexOQ3ACPOmP3EG8HHzPByHhgFEckUB6lzdNEoOVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DI4wOHa1jlK/tZ5Aohia2c4vC/sHBoYOV9lXGW5rdftXypESRR6UQTmXvokxO+0ST
	 jOKi/wnZW31ZepETxPHNJABRK2qKpaizlemVBP1OZFMUizMAXM0XK1KsWR5BL8D1g8
	 5m1jdNshgWjb94mV6ixKg2nVbUzZGQTXrYcA8T5hDQvy7RAa/amsAsjuB5F+I5m16Y
	 M2Q3xlmgjCkFSt2RwjYS7Dl3/nfeljdJpacgDE0pEUddYmHhL578RG/Iq2txVLYeAJ
	 nUtZFx/YPSggq+ZMlbJLVN/ujZIZyyrsSRCrxvZqAxTrsg+K1NT3pX5+jGFMUT5hK+
	 HIyhaHcp1jzAQ==
Date: Tue, 22 Sep 2026 09:49:18 -0700
From: Oliver Upton <oupton@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Jack Thomson <jackabt@amazon.com>,
	Jack Thomson <jackabt.amazon@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Leo Soares Passos <Leo.Bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 01/14] KVM: Allow architectures to disallow pre-fault
Message-ID: <arKxjsxuO1F5ExrY@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org>

Hi Lorenzo,

On Tue, Sep 22, 2026 at 03:17:55PM +0100, Lorenzo Stoakes (ARM) wrote:
> +bool __weak kvm_arch_vcpu_allow_pre_fault_memory(struct kvm_vcpu *vcpu)
> +{
> +	return true;
> +}
> +
>  void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  {
>  	int nr_vcpus, start, i, idx, yielded;
> @@ -4365,6 +4370,9 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	    range->gpa + range->size <= range->gpa)
>  		return -EINVAL;
>  
> +	if (!kvm_arch_vcpu_allow_pre_fault_memory(vcpu))
> +		return -ENOEXEC;
> +

nit: it'd be better to let the arch hook return an error of its choosing
but in reality this is only going to be used by arm64.

Not worth a respin on its own though.

Thanks,
Oliver
