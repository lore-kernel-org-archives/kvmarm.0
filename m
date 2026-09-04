Received: from mta0.migadu.com (out-56.mta0.migadu.com [91.218.175.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFE03E1686
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 08:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788509725; cv=none; b=VHMmLZ/++M9KZ2eL3Ddg+/D2Y+tn5yyvxsV0oLnFs863+bzvna2l12JWYBDOxaBM7ezINJIA4rL7yIrHc33BhomPTSFJWJv3ETEs/YLixLK/8ojLCWA0aiYQkOw8d6PxMn8SC1LnAQFq/4owcsUVzwizzwS1QVjjo0JfwcgsWBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788509725; c=relaxed/simple;
	bh=PvS/b2Z/rWbhXmaZRpQZt7dAKEvw4kUH2lDXouIPU/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kaoINvcsF53JB9159ckvgy5EV8s88qpMfuIj0OGz+hNxoghk5SjFN/0WuIVJwQIsLdJaxxzwVZVlqafUFdWM799y8ga5U9qJ83vnaHcI8SYyGycpSwBqSb0bJ81CBVAJIZFANf49ODmAg+Xa6RGXiX4/NbBR8lHyUjI1A82/9j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tK7fuDs/; arc=none smtp.client-ip=91.218.175.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tK7fuDs/"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=PvS/b2Z/rWbhXmaZRpQZt7dAKEvw4kUH2lDXouIPU/Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788509719; v=1; x=1789114519;
 b=tK7fuDs/LKiQDnZg+jday5NS+rCi6phLKcz2VHSMul3M2BUPuiu2w+D2g23jx2CBHDFLmtB2
 nO2gbz57G1WFmvxTwSB5EZNo6OiBtTAUZewe3ggvEVXh5I/QzPbHrFUDIwj5s4Jnd5qORMFc+0f
 ArMHskl8t1u+0WYgW3FZd1YM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 51cf3c11fa8ccdd0;
	Fri, 04 Sep 2026 08:15:18 +0000
X-Mizu-Trace-ID: 51cf3c11fa8ccdd0
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so3449e87.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 01:15:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzuxhjb/t9nTHKIjqilc41b2+cwC18nORsyP2oAHu7c1TjQOGN8LaGUNInVGH/oeguytJYe9Ws=@lists.linux.dev
X-Gm-Message-State: AFuF++kt6OpjYtQkTuqL34la3Se8gd3mmL/EKxmwGuVemg4bQKPpimOG
	Azi3SS7MRZfs3OxrEf65zWNqcvZGDnEFyqg1sWFVeOCJOHPhvwz9Nr0i20QQHKHHFjRMD5gpaWT
	cZh8zOo0Gfr5cZKNlnBCS6A+meeiNAJHob6fr5Kz4
X-Received: by 2002:a05:6512:1112:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5b616f28401mr90649e87.0.1788509712868; Fri, 04 Sep 2026
 01:15:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>
In-Reply-To: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 4 Sep 2026 09:14:36 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwPmwPTMcgQB6zt47Kz6NPMr+FkGfq2Qq+Uxu+G427OEg@mail.gmail.com>
X-Gm-Features: AcwNN1WvopgDxoDNDPRaykUroX4fh4XjNCnUWBoPOLttdFGRxQfbeOfusjQcANY
Message-ID: <CA+EHjTwPmwPTMcgQB6zt47Kz6NPMr+FkGfq2Qq+Uxu+G427OEg@mail.gmail.com>
Subject: Re: [PATCH 0/2] 52-bit VA guest mode ID support
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Takayuki Okamoto <tokamoto@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Hi Itaru,


On Tue, 25 Aug 2026 at 22:18, Itaru Kitayama <itaru.kitayama@fujitsu.com> wrote:
>
> This patch series extends the arm64 KVM selftest framework
> to support 52-bit guest virtual address (VA) modes in addition to
> the existing 52-bit physical address (PA) configurations.
> The motivation is to enable validation of LPA2 guest memory-management
> behaviour in configurations that use a 52-bit VA space.
> While the selftest framework already supports testing 52-bit PA
> configurations, it lacks the ability to exercise guests running with
> 52-bit virtual addresses, leaving part of the LPA2 functionality untested.

The series adds three 52-bit VA guest modes, but nothing in tree maps
a guest VA high enough to use them. The mode-iterating tests map at a
fixed low GVA, so pgd_index() returns 0 and only the first entry of
the top level is ever used.

What do you expect the modes to catch as they stand? The allocators
already take a minimum GVA, so mapping high in one of those tests
looks like a small change.

> To address this, the series introduces new guest modes for 52-bit VA
> operation, adds five-level page table support where required, and
> performs runtime detection of host 52-bit VA capability so that
> LPA2-enabled guest VA tests are executed only on supported systems.
>
> Testing:
>
> Built and tested on arm64.
> Verified on QEMU with a V52-capable guest configuration.
> Confirmed correct operation of high virtual address mappings by
> exercising guest memory accesses in the 52-bit VA range.

I could not reproduce "exercising guest memory accesses in the 52-bit
VA range" with anything in tree either. Could you say which test you
ran, which guest modes, and on what?

Thanks,
/fuad

> Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Reviewed-by: Takayuki Okamoto <tokamoto@fujitsu.com>
> ---
> Itaru Kitayama (2):
>       KVM: selftest: arm64: Support 5-level paging in stage 1 translation table
>       KVM: selftests: arm64: Add 52-bit VA guest modes
>
>  .../selftests/kvm/include/arm64/processor.h        |  2 +
>  tools/testing/selftests/kvm/include/kvm_util.h     |  3 +
>  tools/testing/selftests/kvm/lib/arm64/processor.c  | 87 ++++++++++++++++++++--
>  tools/testing/selftests/kvm/lib/guest_modes.c      |  5 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c         | 11 +++
>  5 files changed, 103 insertions(+), 5 deletions(-)
> ---
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> change-id: 20260825-arm64-52bit-va-32f1f4cd050d
>
> Best regards,
> --
> Itaru Kitayama <itaru.kitayama@fujitsu.com>
>
