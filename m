Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED389C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 07:49:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5709649E46;
	Wed,  4 May 2022 03:49:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KSat-bqHiLqI; Wed,  4 May 2022 03:49:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3121C4079D;
	Wed,  4 May 2022 03:49:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAC3349F01
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 03:49:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xtR3395faOUC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 03:49:33 -0400 (EDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com
 [209.85.219.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A888D49F5D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 03:49:33 -0400 (EDT)
Received: by mail-yb1-f174.google.com with SMTP id h10so1047503ybc.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 May 2022 00:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=nBQmirpc3Jzz2WCciK0xB/dSEqZbT1cDbk6dglZ1uBg=;
 b=UWuFLon1MvAHgjqPhEcsa2mVgIRhCdr07mEbCxel2hphWlSVQEC4vO/TE58K6YyZLv
 KdAt54vTokh9rWbOgXiqqIdgwmze4KE0kfH5RlEB9gP2IihVKQ4HB8zODadKn0SFW26k
 de6LUjlASatkBMKZ8rLkDafvM05dV7myRgJqYbH20gjCTAsEaA/V8ylwnVx0USGyar/0
 PxhPc8MFAi3qcTEqrfb7IOHCNpRM95mGhf2hl7dCGiAJt8XsSWKLGUUXIEZXTdL3MN9q
 +xvgTb4qfIC8nJvdcouu4KSlN9DDpFJQAgNdjoObloqDkKcAqkppEi6ypjnHRzlqDC5d
 Da/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=nBQmirpc3Jzz2WCciK0xB/dSEqZbT1cDbk6dglZ1uBg=;
 b=5M9jzY8kGtsYLz841YMcwB/8/vUEyZRsg5YehatK4fjNzHsdDS6MH25etr2OtU6CdM
 XyZObOR7WLeCoSncK3NuWJn3LIo88iMeakUXXt/zryK1V3PN8A3VCORugyRcSSM7g/oM
 GhUoGJWecPPbHqCnUWmCqWUFOhom+w8muUbABxCIrmu+x7R7WOJVTSzCeL/JOzwfJNpz
 tC7+ld2Yd5+JpVCyafuVeGkl6Wx7ElOvmlQqGi8n7Tl6LRi5G9m5iGHmymVw8f3SBhN7
 NSTMFMGwf+YspT6ng4gbg2ML7gB7QVskGVSG6gxVTAj7Zxr6BHfxDS5ENl+HxB5LSuf/
 yQTA==
X-Gm-Message-State: AOAM532j963uV0WU63wnzqaTpik51jlc/q3scSV0Q2hPVFDmFdWKf7B1
 j5RgaMBI45HHOf+e0iu56CK/In/V4ciw6PAyKr/U6w==
X-Google-Smtp-Source: ABdhPJyNB77zleiVNEcTCAgG3AS4key9sktPB70PVylNOO/cLnHmygWDMqHxwR+ZMCeE8XUmznCFoc3Cpri8uFEqgHI=
X-Received: by 2002:a25:8045:0:b0:648:a9b3:96d0 with SMTP id
 a5-20020a258045000000b00648a9b396d0mr15786060ybn.88.1651650573002; Wed, 04
 May 2022 00:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220419112247.711548-1-broonie@kernel.org>
 <YnGrbEt3oBBTly7u@qian> <YnHANG5cM0CS9ffm@sirena.org.uk>
In-Reply-To: <YnHANG5cM0CS9ffm@sirena.org.uk>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 4 May 2022 13:19:21 +0530
Message-ID: <CA+G9fYuqVq1G+zTamEqJDyaYqBSBQGkj5Qc6ZCZgBUj9qSP_Fg@mail.gmail.com>
Subject: Re: [PATCH v14 00/39] arm64/sme: Initial support for the Scalable
 Matrix Extension
To: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Marc Zyngier <maz@kernel.org>, Alan Hayward <alan.hayward@arm.com>,
 Qian Cai <quic_qiancai@quicinc.com>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
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

On Wed, 4 May 2022 at 05:22, Mark Brown <broonie@kernel.org> wrote:
>
> On Tue, May 03, 2022 at 06:23:40PM -0400, Qian Cai wrote:
> > On Tue, Apr 19, 2022 at 12:22:08PM +0100, Mark Brown wrote:
> > > This series provides initial support for the ARMv9 Scalable Matrix
> > > Extension (SME).  SME takes the approach used for vectors in SVE and
> > > extends this to provide architectural support for matrix operations.  A
> > > more detailed overview can be found in [1].
> >
> > Set CONFIG_ARM64_SME=n fixed a warning while running libhugetlbfs tests.

I agree with this.
The reported kernel warning gone with
 CONFIG_ARM64_SME=n

- Naresh
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
