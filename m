Received: from out-52.mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63585CA1
	for <kvmarm@lists.linux.dev>; Sat,  1 Jul 2023 12:18:16 +0000 (UTC)
Date: Sat, 1 Jul 2023 14:18:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1688213893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LsRteDgJP/2zCvkpBVoOVyDzfBBR9KshRxmyWDFTyTw=;
	b=BpWq+zB+l+P9/UjT1g6lIbqzNMbWRO69Dr7K1vTVoz05j/I2mU8AyKmsZQrPb/k018tNOC
	NolDz3dhqXyoR+u/XuLO7jxpljB0iMr8synV6QZyJgIFKHwnMDTBqTExw/UXo9/dmElkNV
	f6qSOQBaPJxNMMzpe5jx83F8BlNs1FU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Message-ID: <20230701-f8dc5f619eeb2849f8861bd5@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 30, 2023 at 05:08:52PM +0100, Nikos Nikoleris wrote:
> Hello,
> 
> This series adds initial support for building arm64 tests as EFI
> apps and running them under QEMU. Much like x86_64, we import external
> dependencies from gnu-efi and adapt them to work with types and other
> assumptions from kvm-unit-tests. In addition, this series adds support
> for enumerating parts of the system using ACPI.
> 
> The first set of patches, moves the existing ACPI code to the common
> lib path. Then, it extends definitions and functions to allow for more
> robust discovery of ACPI tables. We add support for setting up the PSCI
> conduit, discovering the UART, timers, GIC and cpus via ACPI. The code
> retains existing behavior and gives priority to discovery through DT
> when one has been provided.
> 
> In the second set of patches, we add support for getting the command
> line from the EFI shell. This is a requirement for many of the
> existing arm64 tests.
> 
> In the third set of patches, we import code from gnu-efi, make minor
> changes and add an alternative setup sequence from arm64 systems that
> boot through EFI. Finally, we add support in the build system and a
> run script which is used to run an EFI app.
> 
> After this set of patches one can build arm64 EFI tests:
> 
> $> ./configure --enable-efi
> $> make
> 
> And use the run script to run an EFI tests:
> 
> $> ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"
> 
> Or all tests:
> 
> $> ./run_tests.sh
>

Hey Nikos,

I've just merged this. Thanks for all your hard work and patience. Now we
need to get it to work on bare-metal, starting with early zeroing of BSS
and anything else we deferred from this review.

Yay!
drew
