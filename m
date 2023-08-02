Received: from out-106.mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883C011188
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 20:17:22 +0000 (UTC)
Date: Wed, 2 Aug 2023 20:17:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1691007440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1T22WeV8+vYeVNiq20HOce62vnsYflUAaIDMYQ8Q6i4=;
	b=jdpl5FMvI9YSd8pRMe3NdvNqYEvqs3FKab3q5uuWVSgi0uBV8ZItn0xJHc7clVNGPQgLGu
	1vS+is+Tb5AMGSKVp8pJEdzP+zBvCCMyNpraOIzj8qogZiA7JmjJjonScKPJiLo56QD2Qy
	HXAvZbsqPx6i6zNWC4Eu86TfNQzUS0I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: Marc Zyngier <maz@kernel.org>, KVM <kvm@vger.kernel.org>,
	KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Test pointer authentication
 support in KVM guest
Message-ID: <ZMq5zDJ16xav7NPa@linux.dev>
References: <20230726044652.2169513-1-jingzhangos@google.com>
 <871qgvrwbi.wl-maz@kernel.org>
 <CAAdAUthi6oZ6oRQDFLeOFVwm2dtcTK2ERJm316x0bdn5TQObYw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdAUthi6oZ6oRQDFLeOFVwm2dtcTK2ERJm316x0bdn5TQObYw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

Hi Jing,

Nothing serious, but when you're replying on a thread can you add a
leading and trailing line of whitespace between the quotation and your
reply? Otherwise threads get really dense and hard to read.

On Wed, Aug 02, 2023 at 10:19:30AM -0700, Jing Zhang wrote:
> > > +                     case FAIL_KVM:
> > > +                             TEST_FAIL("KVM doesn't support guest PAuth!\n");
> >
> > Why is that a hard failure? The vast majority of the HW out there
> > doesn't support PAuth...
> Since previous TEST_REQUIRES have passed, KVM should be able to
> support guest PAuth. The test will be skipped on those HW without
> PAuth.

So then what is the purpose of this failure mode? The only case where
this would happen is if KVM is if KVM screwed up the emulation somehow,
took a trap on a PAC instruction or register and reflected that back
into the guest as an UNDEF.

That's a perfectly valid thing to test for, but the naming and failure
messages should indicate what actually happened.

> > As I mentioned above, another thing I'd like to see is a set of
> > reference results for a given set of keys and architected algorithm
> > (QARMA3, QARMA5) so that we can compare between implementations
> > (excluding the IMPDEF implementations, of course).
> Sure. Will do.

I was initially hesitant towards testing PAC like this since it is
entirely a hardware issue besides KVM context switching, but you could
spin this off as a way to test if vCPU save/restore works correctly by
priming the vCPU from userspace.

Marc, is there something else here you're interested in exercising I
may've missed?

-- 
Thanks,
Oliver
