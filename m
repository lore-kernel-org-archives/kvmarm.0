Received: from out-52.mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB21C97D
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 16:29:16 +0000 (UTC)
Date: Tue, 21 Mar 2023 16:29:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679416153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kq9+N9QHigTIZJPGoarTcMFC8BV6VmA0s4hGrCXu9A8=;
	b=E7YkmmJOGc64rALiUiWchdtqPfUA3dJ3hk3qRbaFwceDz0W4NnR9uATOTkwJZXYHhwMS2Z
	ZffbweNa7z03FDpCGQ0PZROLG1HeIg5RTWOz6jGajiVWDMzgVEKlpeUQ+IsFKwrLJVSl19
	TmDqR9QjzfKs9ML7WndnqkKpbNBGdKg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH 02/11] KVM: arm64: Add a helper to check if a VM has ran
 once
Message-ID: <ZBnbVchNxHRchlE0@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-3-oliver.upton@linux.dev>
 <60fbd578-0391-98b1-d8d1-200a716e1500@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60fbd578-0391-98b1-d8d1-200a716e1500@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Suzuki,

On Tue, Mar 21, 2023 at 09:42:25AM +0000, Suzuki K Poulose wrote:
> Hi Oliver,
> 
> On 20/03/2023 22:09, Oliver Upton wrote:
> > The test_bit(...) pattern is quite a lot of keystrokes. Replace
> > existing callsites with a helper.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >   arch/arm64/include/asm/kvm_host.h | 3 +++
> >   arch/arm64/kvm/pmu-emul.c         | 4 ++--
> 
> There is one more instance in arch/arm64/kvm/hypercalls.c at
> kvm_arm_set_fw_reg_bmap(). Is there a reason why that can't be replaced ?

Oops! Missed that one. I'll address it in v2.

-- 
Thanks,
Oliver
