Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F8EC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 07:56:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6894B354;
	Fri, 27 May 2022 03:56:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IlEgVSsMe9wm; Fri, 27 May 2022 03:56:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08DC849EDF;
	Fri, 27 May 2022 03:56:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF88C49EDF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 03:56:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2vbhjUag+glY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 03:56:19 -0400 (EDT)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com
 [209.85.167.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85E6A49E0E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 03:56:19 -0400 (EDT)
Received: by mail-oi1-f173.google.com with SMTP id k187so674807oif.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 00:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=AKxjalUcljvKnzN5lBKCl4Vp/gLsPH6RAr8Yk+aW0r4=;
 b=ETR+NaVaVl4FmjEFVhzm6fOzYXY7BWGuylgp6IlAxdm/zvWnX/Yne5X3enLi8kt8dV
 ICtcKvY+kvySit5lehcMDaDqVU2cC7qvv5AXqJicDL/X/4mWbryQ60Pz/951MjJs4c20
 0uhtngIbFrBMJIVc6r4xq6lGT/SIS72gjK1huBqB5tDUNG+Me5+lp2XvvkLsnhdSsWtt
 ENco9sM3c6AoatcgFC9Tu6OiecE1n35Y9pGWZvv2B7dDZldRGcWU9plUT1Wq77JfdSt4
 tLinQG9r7DR1kHuOiwX71hSAOMO18i7KwE2pzfP2XETBUtmLvqUQlerNWuGQ6+Mb9Zmg
 PTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=AKxjalUcljvKnzN5lBKCl4Vp/gLsPH6RAr8Yk+aW0r4=;
 b=jUO92XSl926TEz0YFYI48VFxtk+1pPuiBmC7EbHZjdC3VX+sknh7EwXbI9zWc7oJYr
 e1S0X9uCI6NPRQrfQJY+Ck71RvcK/+xufmjrsOzQoUIMMPG89f6FXJyonl6QigWB7yED
 HLI0GsqdHKYzq7eXSbU/Pkdec+Ck8hkUcmvPSm876NZ0AsCjyl+B2rsXDkVIt8iFrGtA
 QJGxc5uA1XJLLfaXJX4VQ3vNBszgBm0FfqtUF3KGOzF8WuacKJIxhv4a0iCWAZj81QAv
 HsWvcCe63tJ7mEdy4pp+BNUPlaQyNe0KQJCEMhEQ9Hs0OxvoKAZOCScwJA0TNQBQlPtM
 0vdw==
X-Gm-Message-State: AOAM533Ng4evZkjsIVk8W/1sp6mgVFWB1VfgMyp0mv+rnTgmRVsjIMhr
 ONizu8cln9ldO/Qe0jh/nOMl9qpBDaL/ielKZ6GaFw==
X-Google-Smtp-Source: ABdhPJxaU/ES1nDnDkYzxdzdnAGBT0PhiqjnwkFprfzv9nwJvg+PhTb6hoy2zVozvUV/SSLEyWDtS1I+obPS5iAC5Yk=
X-Received: by 2002:a05:6808:19a7:b0:32b:3cef:631 with SMTP id
 bj39-20020a05680819a700b0032b3cef0631mr3338903oib.294.1653638178580; Fri, 27
 May 2022 00:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-60-will@kernel.org>
 <CAMn1gO4_d75_88fg5hcnBqx+tdu-9pG7atzt-qUD1nhUNs5TyQ@mail.gmail.com>
In-Reply-To: <CAMn1gO4_d75_88fg5hcnBqx+tdu-9pG7atzt-qUD1nhUNs5TyQ@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 27 May 2022 08:55:42 +0100
Message-ID: <CA+EHjTx328na4FDfKU-cdLX+SV4MmKfMKKrTHo5H0=iB2GTQ+A@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To: Peter Collingbourne <pcc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Peter,

On Thu, May 26, 2022 at 9:08 PM Peter Collingbourne <pcc@google.com> wrote:
>
> On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
> >
> > From: Fuad Tabba <tabba@google.com>
> >
> > Return an error (-EINVAL) if trying to enable MTE on a protected
> > vm.
>
> I think this commit message needs more explanation as to why MTE is
> not currently supported in protected VMs.

Yes, we need to explain this more. Basically this is an extension of
restricting features for protected VMs done earlier [*].

Various VM feature configurations are allowed in KVM/arm64, each requiring
specific handling logic to deal with traps, context-switching and potentially
emulation. Achieving feature parity in pKVM therefore requires either elevating
this logic to EL2 (and substantially increasing the TCB) or continuing to trust
the host handlers at EL1. Since neither of these options are especially
appealing, pKVM instead limits the CPU features exposed to a guest to a fixed
configuration based on the underlying hardware and which can mostly be provided
straightforwardly by EL2.

This of course can change in the future and we can support more
features for protected VMs as needed. We'll expand on this commit
message when we respin.

Also note that this only applies to protected VMs. Non-protected VMs
in protected mode support MTE.

Cheers,
/fuad

[*] https://lore.kernel.org/kvmarm/20210827101609.2808181-1-tabba@google.com/
>
> Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
