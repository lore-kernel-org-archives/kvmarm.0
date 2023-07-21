Received: from out-17.mta0.migadu.com (out-17.mta0.migadu.com [91.218.175.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA894DDD4
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 21:10:12 +0000 (UTC)
Date: Fri, 21 Jul 2023 21:10:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689973810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qX7D7IfSV6pjjnY7PqLth1+9ew15naXT3J3p5h8PUhE=;
	b=OpHiX5u6iaM3e6PagcHSpi7Wh9Zs4H409/6i1SdDX9zv7DCg6Anj17LFaPPjrStp/HmcNy
	ODSAytlH+GK2yPfEVeE+ulvUSOwFX0ytQ+Os4rLmmxhHh6sNWIvKA3GjbHyToGbrt/CVFE
	/Rb6NxQ6OvcV0kznkEhN6npa8YhSJ7A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Cornelia Huck <cohuck@redhat.com>,
	KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
Message-ID: <ZLr0LcQENZmIGMAt@linux.dev>
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com>
 <87o7k77yn5.fsf@redhat.com>
 <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
 <87sf9h8xs0.fsf@redhat.com>
 <86r0p1txun.wl-maz@kernel.org>
 <CAAdAUtjNW6Q+phGbc6jXWTERRhYo7E3H4Ws0iDSngc17Sac0uA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAdAUtjNW6Q+phGbc6jXWTERRhYo7E3H4Ws0iDSngc17Sac0uA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 21, 2023 at 11:22:35AM -0700, Jing Zhang wrote:
> On Fri, Jul 21, 2023 at 2:31 AM Marc Zyngier <maz@kernel.org> wrote:
> > My preference would be a single ioctl that returns the full list of
> > writeable masks in the ID reg range. It is big, but not crazy big
> > (1536 bytes, if I haven't messed up), and includes the non ID_*_EL1
> > sysreg such as MPIDR_EL1, CTR_EL1, SMIDR_EL1.
> Just want to double confirm that would the ioclt return the list of
> only writable masks, not the list of {idreg_name, mask} pair? So, the
> VMM will need to index idreg's writable mask by op1, CRm, op2?

I generally agree with the approach Marc is proposing, but I wonder if
it makes sense to have userspace ask the kernel for this information on
a per-register basis.

What I had in mind was something similar to the KVM_GET_ONE_REG ioctl,
but instead of returning the register value it'd return the mask of the
register. This would keep the kernel implementation dead simple (I'm
lazy) and more easily allow for future expansion in case we want to
start describing more registers this way. Userspace would iterate the ID
register space and ask the kernel for the mask of registers it wants to
change.

Thoughts?

-- 
Thanks,
Oliver
