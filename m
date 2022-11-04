Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C365C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 14:47:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC52D40B80;
	Fri,  4 Nov 2022 10:47:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J9VRqbwNB6Ba; Fri,  4 Nov 2022 10:47:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0DF340BA3;
	Fri,  4 Nov 2022 10:47:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39C8540AF2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 10:47:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CadGzIOh9R+z for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 10:47:27 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00FF740298
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 10:47:26 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 60F8362242
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 14:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF72AC433B5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 14:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1667573244;
 bh=wPPnLNZ+4T3Fuos8Ly78Qj2v7R8MfGXYzebSE4GJ56s=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=d/7GPpvjH1jr3aFEkcWCRke/i2dOsHwqocnWKSK5H2rrqObWkDPivRKZkiVinqC4w
 bvWGdrmA0VYgrnLo+/GwxKgpCGCsFhFVdt5ucL0svuahYo1cCgJaeRt72YcLbRUMsd
 DIpZtLpgik8mbY4FbRSuaQ1g7+h7ypYO2lARwHmOworsjMxsa/IEmKxdayPgqGx5fG
 jFj9fw/UCASzCMJu6J5BUxwzpJnE74f5nu9/iyNSSXgEydIeyy6J7SQNehKy9rBwzl
 JMiH8gPJD1hPCE5DFBlxiMyCte/KDagvwV3b4yVqbTj7Rqmrohl6ofddDWvI45URLt
 sVZuLstD5UZAw==
Received: by mail-lj1-f178.google.com with SMTP id d20so6647321ljc.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 07:47:24 -0700 (PDT)
X-Gm-Message-State: ACrzQf0Lt215G2vkBkJGku0NQA+Y4GO4d++wrSyMBI+m3InxswOHJipH
 jvVEkJReTIP3jmXF9lDkW1MIAHXQAyJpLDacTQ==
X-Google-Smtp-Source: AMsMyM62Xs6fCvQyp5qZFL0MJl4QpNNhlm01k6mmAVVcbjT5g/d41ex992OtIiF0ZA7d3S+KRipg5DVCEr5R0NJZekA=
X-Received: by 2002:a05:651c:114a:b0:25d:5ae6:42a4 with SMTP id
 h10-20020a05651c114a00b0025d5ae642a4mr13404029ljo.255.1667573242688; Fri, 04
 Nov 2022 07:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
 <5c410969-2176-49cf-640f-8023c421682e@arm.com>
In-Reply-To: <5c410969-2176-49cf-640f-8023c421682e@arm.com>
From: Rob Herring <robh@kernel.org>
Date: Fri, 4 Nov 2022 09:47:13 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJ6hdCxTOFk=r6RE_3XGtBhF1HRCMKdjrW-D2FuYazZrQ@mail.gmail.com>
Message-ID: <CAL_JsqJ6hdCxTOFk=r6RE_3XGtBhF1HRCMKdjrW-D2FuYazZrQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] perf: Arm SPEv1.2 support
To: James Clark <james.clark@arm.com>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Arnaldo Carvalho de Melo <acme@kernel.org>, linux-perf-users@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Brown <broonie@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, Nov 4, 2022 at 6:30 AM James Clark <james.clark@arm.com> wrote:
>
>
>
> On 19/10/2022 20:11, Rob Herring wrote:
> > This series adds support for Arm SPEv1.2 which is part of the
> > Armv8.7/Armv9.2 architecture. There's 2 new features that affect the
> > kernel: a new event filter bit, branch 'not taken', and an inverted
> > event filter register.
> >
> > Since this support adds new registers and fields, first the SPE register
> > defines are converted to automatic generation.
> >
> > Note that the 'config3' addition in sysfs format files causes SPE to
> > break. A stable fix e552b7be12ed ("perf: Skip and warn on unknown format
> > 'configN' attrs") landed in v6.1-rc1.
> >
> > The perf tool side changes are available here[1].
> >
> > Tested on FVP.
> >
> > [1] https://lore.kernel.org/all/20220914-arm-perf-tool-spe1-2-v2-v4-0-83c098e6212e@kernel.org/
> >
>
> LGTM. Tested with [1] applied and on N1SDP (where it isn't supported),
> and on the FVP. Enabling all the inverted filters results in no trace
> and other combinations work as expected.

Thanks, I'll take that as a 'Tested-by' tag if that's okay.

In the future, please be explicit with tags. Tools such as b4 and
patchwork will recognize them and add them automatically.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
