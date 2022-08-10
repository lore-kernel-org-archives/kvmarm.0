Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793F6C25B07
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 18:46:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B084D9C9;
	Wed, 10 Aug 2022 14:46:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U9hoKCzAlrns; Wed, 10 Aug 2022 14:46:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6A1A4D9CD;
	Wed, 10 Aug 2022 14:46:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0C04D9C9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 14:46:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fHybYNKziOKK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 14:46:29 -0400 (EDT)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89E364D9C7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 14:46:29 -0400 (EDT)
Received: by mail-pl1-f173.google.com with SMTP id d16so14981388pll.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 11:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=w7tKdaFpkXOHqmzRmN3TS17bbMv5aY9ZVRa8viTMmRA=;
 b=mryMQKfp8NuK+lcMB/v4C/eZQvysrNsacXRGGU+ns1YlKLYZ4an1sak74CP/9uOQwj
 vmTcazpGmj0QSeEzqJhEMQVGuQEY4cRda9cnUkwjM2oTVfhDrEZ1zauUSDY729M/zK3M
 8V441nXBXcjEh3O3pgwmUOIaj7407tX8vatsx0kc1be4BjvdwVliuYvLxN8cVFLxzS09
 uwj4XXDR3c3DAaI1nZYnE2FeAV8KXK0Dc5w5a+wmkq0lH2/bDu8gx8nwPTQghoSTx5qj
 lDx10dGGr6P0NGcyC3JXUEoEB7QTime/O3F3q+NKlIu4W/FiWEkKW3cmFhhiYiuvGX4q
 TW6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=w7tKdaFpkXOHqmzRmN3TS17bbMv5aY9ZVRa8viTMmRA=;
 b=WfD7koefeGoeQeXjm1Yez6ZRGbBtITjAa0C2t3Sw318RWvCXy3M9uEDDrXQXXu3e2V
 g2MHiU4nCwpM/7PotKEXVbsCXo6sTCFeg5V/C6VOke8/CH10KOcaAUCK9nG20DtIWHAt
 Tryi9goFxhIwa+XQONJIMKtVYx84LWUYHe4JhD5US4clpJoQBxNB/8y/1EHrUgUfaKZ8
 dM4tXkzgeUMLeujJ1g5KHndNoqh2A/6A/uG8xftAkUwmDdLtuJ0DRc8hZTJYffvqfcbK
 eA1VV3OniqSlzg6m5YP4diM8FjRS7RhfrgBio0hWsq3sSlX4AaJRqWRrE/VH8WeRtLCM
 4PBA==
X-Gm-Message-State: ACgBeo2787Y66RMCwXzbVUIyqRS3ar25ciCxBJg8o1Q8vRHH9BIl5dZE
 bn1oq6l4V9RcVB4AeH/TyZE36Q==
X-Google-Smtp-Source: AA6agR5YxgHA27P0ktUotSKJbRJ8qV0IwK9/mACrXmCnkz/YNaR7XQoDc+CBbP8mCvVE8aYBRlYVHA==
X-Received: by 2002:a17:903:1cd:b0:171:3543:6b13 with SMTP id
 e13-20020a17090301cd00b0017135436b13mr4703078plh.96.1660157188397; 
 Wed, 10 Aug 2022 11:46:28 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 w18-20020a1709027b9200b0016dbb878f8asm13157232pll.82.2022.08.10.11.46.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 10 Aug 2022 11:46:27 -0700 (PDT)
Date: Wed, 10 Aug 2022 11:46:22 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/9] KVM: arm64: PMU: Fixing chained events, and PMUv3p5
 support
Message-ID: <YvP8/m9uDI2PcyoP@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-1-maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Aug 05, 2022 at 02:58:04PM +0100, Marc Zyngier wrote:
> Ricardo recently reported[1] that our PMU emulation was busted when it
> comes to chained events, as we cannot expose the overflow on a 32bit
> boundary (which the architecture requires).
> 
> This series aims at fixing this (by deleting a lot of code), and as a
> bonus adds support for PMUv3p5, as this requires us to fix a few more
> things.
> 
> Tested on A53 (PMUv3) and FVP (PMUv3p5).
> 
> [1] https://lore.kernel.org/r/20220805004139.990531-1-ricarkol@google.com
> 
> Marc Zyngier (9):
>   KVM: arm64: PMU: Align chained counter implementation with
>     architecture pseudocode
>   KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow
>   KVM: arm64: PMU: Only narrow counters that are not 64bit wide
>   KVM: arm64: PMU: Add counter_index_to_*reg() helpers
>   KVM: arm64: PMU: Simplify setting a counter to a specific value
>   KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation
>   KVM: arm64: PMU: Aleven ID_AA64DFR0_EL1.PMUver to be set from userspace
>   KVM: arm64: PMU: Implement PMUv3p5 long counter support
>   KVM: arm64: PMU: Aleven PMUv3p5 to be exposed to the guest
> 
>  arch/arm64/include/asm/kvm_host.h |   1 +
>  arch/arm64/kvm/arm.c              |   6 +
>  arch/arm64/kvm/pmu-emul.c         | 372 ++++++++++--------------------
>  arch/arm64/kvm/sys_regs.c         |  65 +++++-
>  include/kvm/arm_pmu.h             |  16 +-
>  5 files changed, 208 insertions(+), 252 deletions(-)
> 
> -- 
> 2.34.1
> 

Hi Marc,

There is one extra potential issue with exposing PMUv3p5. I see this
weird behavior when doing passthrough ("bare metal") on the fast-model
configured to emulate PMUv3p5: the [63:32] half of the counters
overflowing at 32-bits is still incremented.

  Fast model - ARMv8.5:
   
	Assuming the initial state is even=0xFFFFFFFF and odd=0x0,
	incrementing the even counter leads to:

	0x00000001_00000000	0x00000000_00000001		0x1
	even counter		odd counter			PMOVSET

	Assuming the initial state is even=0xFFFFFFFF and odd=0xFFFFFFFF,
	incrementing the even counter leads to:

	0x00000001_00000000	0x00000001_00000000		0x3
	even counter		odd counter			PMOVSET

More specifically, the pmu-chained-sw-incr kvm-unit-test fails when
doing passthrough of PMUv3p5 (fast model - ARMv8.5):

  INFO: PMU version: 0x5
  INFO: PMU implementer/ID code: 0x41("A")/0
  INFO: Implements 8 event counters
  PASS: pmu: pmu-chained-sw-incr: overflow and chain counter incremented after 100 SW_INCR/CHAIN
  INFO: pmu: pmu-chained-sw-incr: overflow=0x1, #0=4294967380 #1=1
                                                ^^^^^^^^^^^^^
                                                #0=0x00000001_00000054
                                                #1=0x00000000_00000001
  FAIL: pmu: pmu-chained-sw-incr: expected overflows and values after 100 SW_INCR/CHAIN
  INFO: pmu: pmu-chained-sw-incr: overflow=0x3, #0=4294967380 #1=4294967296
                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                                  #0=0x00000001_00000054
                                                  #1=0x00000001_00000000

There's really no good use for this behavior, and not sure if it's worth
emulating it. Can't find any reference in the ARM ARM.

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
