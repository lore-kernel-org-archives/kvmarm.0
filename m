Received: from out-194.mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8B937155
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 22:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ekUfSPU3"
Date: Wed, 18 Oct 2023 22:17:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697667429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ztNFzRAh3XJ3IwivXV0tZ5qyOZlUiSKoGVQq6wIcNls=;
	b=ekUfSPU3v18059DZdZrVpew7QpqnJJ1sYScvAhqqc/pvIZCmu+oApZt8bUO6OXug6NmjNy
	i8pjmvtCEc58wMOafrBz96SXMRUdrgbDW2XXYNfUDDgtbLusEzevbfeI1SUHT+3PKgXfFc
	kwVxhDtEeZCbrh9xSGm5Msv8LXMXUyA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Eric Auger <eauger@redhat.com>, Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v7 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
Message-ID: <ZTBZYNPMw4A7kr6n@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com>
 <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
 <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com>
 <CAJHc60xc1dM_d4W+hOOnM5+DceF45htTfrbmdv=Q4vPf8T04Ow@mail.gmail.com>
 <CAJHc60yr5U+sxSAaZipei_4TNaU0_EAWKLG8cr+5v_Z1WYRMuw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60yr5U+sxSAaZipei_4TNaU0_EAWKLG8cr+5v_Z1WYRMuw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 18, 2023 at 02:16:36PM -0700, Raghavendra Rao Ananta wrote:

[...]

> I had a brief discussion about this with Oliver, and it looks like we
> might need a couple of additional changes for these register accesses:
> - For the userspace accesses, we have to implement explicit get_user
> and set_user callbacks that to filter out the unimplemented counters
> using kvm_pmu_valid_counter_mask().
> - For the guest accesses to be correct, we might have to apply the
> same mask while serving KVM_REQ_RELOAD_PMU.

To be precise, the second issue is that we want to make sure KVM's PMU
emulation never uses an invalid value for the configuration, like
enabling a PMC at an index inaccessible to the guest.

-- 
Thanks,
Oliver
