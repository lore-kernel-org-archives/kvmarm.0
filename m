Received: from out-204.mta0.migadu.com (out-204.mta0.migadu.com [91.218.175.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E483CCF4
	for <kvmarm@lists.linux.dev>; Tue, 24 Oct 2023 18:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HmTAi3vX"
Date: Tue, 24 Oct 2023 18:37:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698172642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MhJ7hpYNLv+MdX49dQXGYnhsXLwtvTKjEUlM/EEP2AE=;
	b=HmTAi3vX6+c6qUUSeCE5bUS/PW6Yb7yhrXKc58eaEv/9GVTUSXOuF6uNnysiKo0GoNPB4+
	wllIwNj9PbBKFHyTluy6Qg5zJaD4norqGkRmo9F0H9VtpK+aClTT4P2Q9V6v2Z+mlImQVr
	JneDsDassGEe43ScK3hMSWUrpVNfKZE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 07/13] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
Message-ID: <ZTgO3SHzvd_mQTI9@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <20231020214053.2144305-8-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020214053.2144305-8-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 20, 2023 at 09:40:47PM +0000, Raghavendra Rao Ananta wrote:

[...]

> +	/*
> +	 * Make PMCR immutable once the VM has started running, but
> +	 * do not return an error to meet the existing expectations.
> +	 */
> +	if (kvm_vm_has_ran_once(vcpu->kvm)) {
> +		mutex_unlock(&kvm->arch.config_lock);
> +		return 0;
> +	}

Marc pointed out offline that PMCR_EL0 needs to be mutable at runtime as
well. I'll admit, the architecture isn't very helpful as it is both used
for identification _and_ configuration.

What I had in mind a few revisions ago when I gave the suggestion was to
ignore writes to _just_ the PMCR_EL0.N field after the VM has started.

-- 
Thanks,
Oliver
