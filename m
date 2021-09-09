Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32130C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 05:22:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9805A61139
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 05:22:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9805A61139
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD7C4B0BA;
	Thu,  9 Sep 2021 01:22:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GvF7mxcjx2NA; Thu,  9 Sep 2021 01:22:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 153BE4B0EF;
	Thu,  9 Sep 2021 01:22:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22FB94B0F2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 01:22:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Td7d4U6okAEx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 01:22:22 -0400 (EDT)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com
 [209.85.166.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5081E4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 01:22:22 -0400 (EDT)
Received: by mail-io1-f44.google.com with SMTP id z1so770432ioh.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 22:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=7Ja+MA4OCzFYM/Hx8ySIku22LElZavZCzLsENm+S9Mc=;
 b=sSrKzdgbodHekgxN4FeKFtpd8Y4Csq7gzvDRQimT+tWyjS2LXY7/BuapliIukRhqkG
 Io+6kUubaiVrscaC82Af6p1nUdBkfSX4eUr2v4loWlgQDqFuH6d0WF3s+mSjHOFgKkll
 JnavnAYo7F0qxztVd/Pzz09WfH16Zrc+8IKrvs8libeSHlhU2XeB3Lje4p3qSeX2Rfce
 W1VW0vcIdi9Bw1ZuM4oJI+DPDjWoMOOG7xQ16u49oNtnrcc0HV2eINlwGZGBlLOohXK/
 Qo9en2g0liePMOSs+oEZeOm1FMQayg0KLs4qpa7kwSuOIXjJuDBgMRl0W1CUQ+d7Psp6
 A1Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7Ja+MA4OCzFYM/Hx8ySIku22LElZavZCzLsENm+S9Mc=;
 b=GMiuOH23k013d3pdNAJCTTV984GcEvRUbqZ014xuS+KlQlN1N8Xn6nhjmd/9W48N1U
 +DV6KeWeHXpkNklaTA0ryCUIdQf+G5RJgTcGwNfXVjuoYPVKpJMcgmsYXvjerWZCFk3c
 Vs9aC1T3lj11f9TtWvESBO+GicSFj9X8di0Cc4Agfg77tFpww1oY8hDhBOsrWV2vHFNZ
 znqwEdq12fo2dDv+R2pMN0rWA4SgBxkrTJgRK5kb1SBta0vy5lxv0PeXuYJKIuIBRRaV
 Wl/vtrpsNJTqDdvXig3U1D7uFuTX4duZ1StTSxyJX+kww74lJv5CKBog4DKGN3aXjZaV
 Xy1w==
X-Gm-Message-State: AOAM531D2JKulvSrm+WaYJ9X3yyLGXbtgV3mgh4AimWka2mnIKKX5aGg
 LNwVk6fyJkJDU3I0e/UxTP9J2g==
X-Google-Smtp-Source: ABdhPJy8iklDSbE81P3I3H1zXA7m4JYm6w3j44cDkU5aPYiQLRdS7kUUAS26jVunWdjTARITmatx0Q==
X-Received: by 2002:a02:cc30:: with SMTP id o16mr1211625jap.101.1631164941450; 
 Wed, 08 Sep 2021 22:22:21 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id t10sm408390iol.34.2021.09.08.22.22.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 22:22:20 -0700 (PDT)
Date: Thu, 9 Sep 2021 05:22:17 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 12/18] KVM: selftests: Keep track of the number of
 vCPUs for a VM
Message-ID: <YTmaCWPkJ2TOeTsT@google.com>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-13-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-13-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 09, 2021 at 01:38:12AM +0000, Raghavendra Rao Ananta wrote:
> The host may want to know the number of vCPUs that were
> created for a particular VM (used in upcoming patches).
> Hence, include nr_vcpus as a part of 'struct kvm_vm' to
> keep track of vCPUs as and when they are added or
> deleted, and return to the caller via vm_get_nr_vcpus().
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h      | 1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 7 +++++++
>  tools/testing/selftests/kvm/lib/kvm_util_internal.h | 1 +
>  3 files changed, 9 insertions(+)

Shouldn't a test keep track/know how many vCPUs it has created?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
