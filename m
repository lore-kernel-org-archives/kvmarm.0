Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9592A37B97
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 15:18:33 +0000 (UTC)
Date: Tue, 6 Jun 2023 15:18:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686064711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a0OMKZo+jxk92OEJPdCQE4uvxPWt/l6mvkQM6RunaJQ=;
	b=h08XZrOM1ON+lg2vQSGmmcKMzlwr4jCaavS+zCxIxy5RmvPu/771Uy1hX2GJRTa9tA6ef+
	sWk4z+GrkFdOCEjtz7Kh+gD+XLDTGoP1t0uWQJpGLIEe3mrNE4w+mpeOFxfw3Ms6YxC2Fx
	sVME7JfpboYEQSTfd1NSweqEBBBGI+w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Sebastian Ott <sebott@redhat.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix smp_processor_id() call in preemptible
 context
Message-ID: <ZH9OQzKIfwxR3q54@linux.dev>
References: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com>
 <ZH8+ZG7DOX9TYcIY@linux.dev>
 <ZH9CvE54NSVXqjlO@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH9CvE54NSVXqjlO@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 06, 2023 at 07:29:16AM -0700, Sean Christopherson wrote:
> On Tue, Jun 06, 2023, Oliver Upton wrote:
> > The call from a preemptible context is intentional, so this really
> > should just be raw_smp_processor_id(). Do you mind if we fix it with the
> > following?
> 
> ...
> 
> > Nonetheless, there's no functional requirement for disabling preemption,
> > as the cpu # is only used to walk the arm_pmus list. Fix it by using
> > raw_smp_processor_id() instead.
> 
> As a partial outsider, that needs an explanation, and the code could really use a
> comment.  I assume KVM's ABI is that it's userspace's responsibility to ensure that
> the CPU(s) used for KVM_RUN is compatible with the CPU used for KVM_ARM_VCPU_PMU_V3_CTRL,
> but neither the original changelog nor the above state that, nor does anything
> explain what happens if userspace doesn't uphold its side of things.

See commit 40e54cad4540 ("KVM: arm64: Document default vPMU behavior on
heterogeneous systems"), which documents the subtlety of vCPU scheduling
with the 'old' ABI at the callsite of this function. I don't want to
bleed any details of this crap into user documentation, since the entire
scheme is irretrievably broken.

See Documentation/virt/kvm/api/devices/vcpu.rst 1.4 for the 'new' ABI
where userspace explicitly selects a vPMU instance.

> That stuff might be covered in documentation somewhere, but for someone
> just looking at git blame, this is all very magical.

Personally, I find any other fix that involves disabling preemption to be
quite a lot more 'magical', as there isn't any percpu data we're working
with in the loop.

-- 
Thanks,
Oliver
