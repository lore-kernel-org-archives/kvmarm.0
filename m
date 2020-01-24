Return-Path: <SRS0=41R7=3N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F29C32771
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jan 2020 12:21:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 519612075D
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jan 2020 12:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="cMFyr4Xh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 519612075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D0F54AF36;
	Fri, 24 Jan 2020 07:21:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H3R4bSjFAvND; Fri, 24 Jan 2020 07:21:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B9664AF11;
	Fri, 24 Jan 2020 07:21:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30EEA4AF0A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 07:21:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pR6mVik6RSLi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jan 2020 07:20:59 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 089A94AEF4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 07:20:59 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id y17so1738038wrh.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 04:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=Q5/QGs5gkh2XO+BQ2zRh4RVM54DuioXv50QpwNO/LOs=;
 b=cMFyr4Xh6yV515G1Qq+7238gv8y/HlkKi/4rDB6GTsgTNRmR41qvT7PZ2twHVSP9qh
 D0smuhi515A4wWVRtwHtSu2wHrxMvbX7auVyndUubiJrmU7agt48NX0/V74cmH9LQs1C
 RkanOyFY4U4cvEHWtLbatOG1cyxqEyAqm0Um96aKuPDMfonfVjFkDYJrdkk3sTnWdC1y
 QiK17UFDkrb+5NS4E1JnK5cXikgYvzO0gKkH0idqWjeUnf1qDy1Dskr30XUYsiC9mrrX
 /dAs9Kj8wLaDI7RvsWsLChvwOE9D0HUIvys2vSFyUMFzGYYetTx+/MKDP6UiVbqDJ04K
 bbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=Q5/QGs5gkh2XO+BQ2zRh4RVM54DuioXv50QpwNO/LOs=;
 b=beNs6UDzlBmoyPHAT6mTMBIRb+hyo8pBGlr77qrnOBLgChujZaJjy8vQMjNARPRXfb
 j4Uw7ogs+1J5BThegHxbUKlbrNS9GbLLeHvWrNIml3SOgRMnG/X9gRaTEvObGeBL/pmW
 rXtYMr6xNoA+lw4WedPhUCCohf/Rcr1MaaIQxjJFcS58QjK+NyMY3RAsEUEey1rYbo6x
 FNrtkNphjrzBaOxt7unZ1P70G6CsGKyBkPsF3ocNPJ/E1YsmnWMSDTYtujGlOltnuVj/
 ny67sIvq9CUSzhWfGdOIkqDn7HNyPP7bl8w/jSVoMVkQeISXuaRRU95DM55+5V5+xwYR
 xe2A==
X-Gm-Message-State: APjAAAUw8UbwROsP+neJEt6ojVaCrngJvu6R0ejXoH8is2mWACLUcG5J
 lYV4+vo5nmgk5moPcMPGzVilVw==
X-Google-Smtp-Source: APXvYqwc1Foj2c7KnaKvacpILFbKY0n7Gl1OeFMdCaXfhHe+gYzfLhnQoBCMml+AofYQ5iRp2XnYpw==
X-Received: by 2002:a5d:68c5:: with SMTP id p5mr3938040wrw.193.1579868457525; 
 Fri, 24 Jan 2020 04:20:57 -0800 (PST)
Received: from google.com ([2a00:79e0:d:110:d6cc:2030:37c1:9964])
 by smtp.gmail.com with ESMTPSA id u7sm6587819wmj.3.2020.01.24.04.20.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Jan 2020 04:20:56 -0800 (PST)
Date: Fri, 24 Jan 2020 12:20:53 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 0/1] arm/arm64: add support for folded p4d page tables
Message-ID: <20200124122053.GA150292@google.com>
References: <20200113111323.10463-1-rppt@kernel.org>
 <20200122185017.GA17321@willie-the-truck>
 <cb6357040bd5d9fa061a8d3bd96fb571@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cb6357040bd5d9fa061a8d3bd96fb571@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, Mike Rapoport <rppt@linux.ibm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Mike Rapoport <rppt@kernel.org>
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

Hi Marc,

On Wednesday 22 Jan 2020 at 18:56:38 (+0000), Marc Zyngier wrote:
> But maybe this is the reason we've all been waiting for, for which we
> sacrifice 32bit KVM host on the altar of progress, and finally move along.
> 
> Will and I are the only known users, and that'd be a good incentive to
> experience some if this 64bit goodness... ;-)

Jumping in this discussion a bit randomly, but I just wanted to share
some thoughts that hopefully are relevant to this discussion and can be
of interest to the community.

Context: we have a use-case where guests would need some degree of memory
protection from the host for confidentiality reasons. We're currently
looking at extending KVM to support this feature by enabling the stage
2 translation for the host (in the NVHE case) so we can prevent it from
accessing private guest memory, in addition to many other changes
required to make this work properly. We're currently at the prototyping
stage, but hopefully we'll be able to share patches soon.

I'm bringing this up now because this particular use-case doesn't seem
relevant in the arm32 world -- all our potential users are on arm64.
However, because of the current structure of the arm/arm64 KVM host
code, making significant arm64-specific changes turns out to be really
hard.

We're currently left with three options:

  1. move code from virt/kvm/arm and duplicate it in the arch/arm and
     arch/arm64 folders so the arm64 version can diverge. I can imagine
     this duplication isn't exactly an appealing solution from a
     maintainer's perspective ...

  2. do changes in the virt/kvm/arm folder directly, but these must be
     met with matching changes in the respective arch/ folders. The
     code added to arch/arm, however, would be practically dead code,
     largely un-used and un-tested as there will be no real arm32 users
     of this feature.

  3. have lots of kvm_arm_* callbacks stubbed for arm32, but this tends
     to be really hard to apply to this use-case as some of the changes
     are really quite intrusive.

Obviously, details matter for all of this, and lots of discussions will
be needed once the patches are on the list.

But the point I'm trying to make here is the following: regardless of
the option we end up choosing (most likely a mix of all three), the sole
fact that we have to deal with this is clearly slowing down development
of the feature.

This would a be perfectly reasonable and acceptable overhead if this had
to be done to keep 32bit KVM host support for a real user community, but
since it doesn't seem to exist (?), fighting with the above options
feels like a lot of wasted efforts. (Note: I am not implying that Will
and you are not real persons, but well, you see what I mean ;-)).

So, this is the end of my daily rant. But hopefully this other example
of a real-world feature that's being held back by the 32bit KVM host
code will be useful background when/if we go ahead and finally decide
stop supporting it.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
