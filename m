Received: from out-207.mta0.migadu.com (out-207.mta0.migadu.com [91.218.175.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93F62FE0F
	for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 19:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oQgChljY"
Date: Thu, 19 Oct 2023 19:05:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697742363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RLHQdgbSkkxaLwkcFuueBvH7VycJBav8fBuH03XXBKY=;
	b=oQgChljYtL/bUrXu6LUkQIGrJjc8WiMnPJS8uSqF2+0i85LF0qAbU6vRorb3R0acf+NEdw
	gZcIJiAeOfohEj96llKypUMIb4sxUnfqGRyEqX7ybGc8+qgLJHdDMTQZKuEBMCAeSa9VIN
	TrPbM/1wjV8d1yKxluF426hrzLWEA+M=
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
Message-ID: <ZTF-FlDtvha-6Pw1@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com>
 <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
 <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com>
 <CAJHc60xc1dM_d4W+hOOnM5+DceF45htTfrbmdv=Q4vPf8T04Ow@mail.gmail.com>
 <CAJHc60yr5U+sxSAaZipei_4TNaU0_EAWKLG8cr+5v_Z1WYRMuw@mail.gmail.com>
 <CAJHc60yQSzsuTJLcyzs5vffgRzR5i0vKQwLnhavAon6hoSkb+A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60yQSzsuTJLcyzs5vffgRzR5i0vKQwLnhavAon6hoSkb+A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

Hi Raghu,

Can you please make sure you include leading and trailing whitespace for
your inline replies? The message gets extremely dense and is difficult
to read.

Also -- delete any unrelated context from your replies. If there's a
localized conversation about a particular detail there's no reason to
keep the entire thread in the body.

On Thu, Oct 19, 2023 at 11:46:22AM -0700, Raghavendra Rao Ananta wrote:
> On Wed, Oct 18, 2023 at 2:16 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> > I had a brief discussion about this with Oliver, and it looks like we
> > might need a couple of additional changes for these register accesses:
> > - For the userspace accesses, we have to implement explicit get_user
> > and set_user callbacks that to filter out the unimplemented counters
> > using kvm_pmu_valid_counter_mask().
> Re-thinking the first case: Since these registers go through a reset
> (reset_pmu_reg()) during initialization, where the valid counter mask
> is applied, and since we are sanitizing the registers with the mask
> before running the guest (below case), will implementing the
> {get,set}_user() add any value, apart from just keeping userspace in
> sync with every update of PMCR.N?

KVM's sysreg emulation (as seen from userspace) fails to uphold the RES0
bits of these registers. That's a bug.

-- 
Thanks,
Oliver
