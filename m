Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16954C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 08:05:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F32749EDF;
	Tue, 26 Apr 2022 04:05:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZRpZ6clsypg0; Tue, 26 Apr 2022 04:05:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41DB649E08;
	Tue, 26 Apr 2022 04:05:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB85F49E08
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 04:05:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cTf87WDG2WvD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 04:05:16 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 931D849B0A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 04:05:16 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id m13so4941905iob.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 01:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=dsc/EWty8tGghPFclfiZRTuruyVjweazfqxw2YozJTU=;
 b=cY7o2Bz3fPazxWEl3MzQo1DN0C4kZ8MkaYo0axcBKqaiOtH2aaBNp9Zntppd6LAAy4
 3oY0yRlyzth9nxuBhFVh+aelqcDHONKEW0RCnXxLJILWopacqGBxBTzkWwGe5Hc6iOoJ
 zbmpodB4JjNXnBkxINpm+ZdDWo+lYbu4qLRkMWmcTh/lBrFh+FdCpqM656mDhOBgXzBJ
 +K0l90QwvKAliU0yYYP9E5eluJhylCEv5TOB2BUy3uBUfjJmWVFzuGPpWwY47M2hR9B/
 1L3QtvoGhYUxvN8AlaJQhN0kcVO5Ahwm0bGlEeHMHYl83OwCD/OlAPsuT1ftE0beNVdj
 A/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dsc/EWty8tGghPFclfiZRTuruyVjweazfqxw2YozJTU=;
 b=ylw3xAYsWrM5xs+BMaP4H4qSuMtu/LdqMkU9oMQQUxnOG8xLEy808JqCdoEVpo/P9B
 mXeiHuUZcCMflKOwXX4WJgw/fAVcigzCa1rbaPxEhtakInvJaMR/BCKvHOEmyBFI9HP+
 dNjKaCXxJxW33evsBYO242odU7N7Ay909l1D8eNGb2CzPedzX9XX1YnuOA2w7Q+6i/81
 k9NmJSM2S7bdY0fF5QfpJQHoQZVhp6t3j0dq0XxVlkHQNDqggp7qqOR0jcInJ7P2NdJO
 I3VnhlujKRUfGlGikfREgjZqbTo8MOKQTJCJfRLWnWU/AeQWR/9O1DMFpXot9UEeaWtr
 Jipg==
X-Gm-Message-State: AOAM530lwfwvcq3ZQukJ/HvnvRVIGITcdo9u0jbkQjaF1/hdc4xisk8s
 i8f9nEWyga891wj4/jYFYGP9Sw==
X-Google-Smtp-Source: ABdhPJxIgkZSgfxjTHNm1FDJb1xY5sS57J17GplF1uJS9JygJiChFq2OLb+22nZbhAh5d6hsWJssXA==
X-Received: by 2002:a05:6638:3397:b0:32a:8ab7:3f0 with SMTP id
 h23-20020a056638339700b0032a8ab703f0mr8944972jav.260.1650960315744; 
 Tue, 26 Apr 2022 01:05:15 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 d14-20020a5d964e000000b00657430ee98bsm9041176ios.4.2022.04.26.01.05.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Apr 2022 01:05:14 -0700 (PDT)
Date: Tue, 26 Apr 2022 08:05:11 +0000
From: Oliver Upton <oupton@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM/arm64: Don't emulate a PMU for 32-bit guests if
 feature not set
Message-ID: <Yment8uGahyB+wgK@google.com>
References: <20220425145530.723858-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220425145530.723858-1-alexandru.elisei@arm.com>
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Alex,

On Mon, Apr 25, 2022 at 03:55:30PM +0100, Alexandru Elisei wrote:

[...]

> The root cause remains the same: kvm->arch.pmuver was never set to
> something sensible because the VCPU feature itself was never set.
> 
> The odroid-c4 is somewhat of a special case, because Linux doesn't probe
> the PMU. But the above errors can easily be reproduced on any hardware,
> with or without a PMU driver, as long as userspace doesn't set the PMU
> feature.

This note has me wondering if we could do more negative testing with
kvm-unit-tests just by selectively turning on/off features, with the
expectation that tests either skip or pass.

> Work around the fact that KVM advertises a PMU even when the VCPU feature
> is not set by gating all PMU emulation on the feature. The guest can still
> access the registers without KVM injecting an undefined exception.

We're going to need something similar even after KVM conditionally
advertises the PMU.

WDYT about wiring up sys_reg_desc::visibility for the AArch32 PMU
registers? For now just treat them as REG_RAZ (probably extend this to
imply WI too) then promote to REG_HIDDEN in a later patch.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
