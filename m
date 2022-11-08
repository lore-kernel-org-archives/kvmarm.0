Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63BAC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Nov 2022 13:13:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A7124B878;
	Tue,  8 Nov 2022 08:13:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QaLhOEIVpXmD; Tue,  8 Nov 2022 08:13:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCB104B875;
	Tue,  8 Nov 2022 08:13:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FDC24B86D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 08:13:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zqy8w9n4yKx9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 08:13:07 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 529124B86B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 08:13:07 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id CBFACB81ACB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 13:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F046CC43147
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 13:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1667913184;
 bh=RjKzHDdvNdhhqfLtS6tIrlSlQE1p+3t6lJ0X9tYX6TA=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=G5qTTVfPjy9TPUXnDtlwJU0YWJuvTONeWw/y/aSJoSVpg8j0T1mMvPWFDASH/1TWh
 cvX1skWSgomoSxE9UJWPCqKqYqBP07Qxj2+B/PMut1qcZMcxYIsPL6WP5h7jdXk+dX
 lY56IRfDDJ09vyz3COv4/iohkQpgM5bNuy3KJ2M7n5u0otxamah19V1ssGjLTSO/61
 lBehPahySwDRBsQ5oySBPm2KjwCpE6DCghYGWqHarE4WmtgnCbnVyfVpa1DQfTEXxc
 Rx7K3WgncFgW6L32rJefMkjmggU+J9ICGjwQBeKjlv+Rj04haNiRQi1thAPPEet3YT
 ZJdsPRESvvkRw==
Received: by mail-lj1-f169.google.com with SMTP id s24so21018587ljs.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Nov 2022 05:13:03 -0800 (PST)
X-Gm-Message-State: ACrzQf0vy82v2eDO3hkeSIw+kgtoftoTXMDeYWaSofmhkoSnZDCNHsFq
 Si936k28YpeU0VaX800wQfYWu4tCnlno5GCYvQ==
X-Google-Smtp-Source: AMsMyM5O7pLGp8uyEtGPHwwVGHXeMrvhpQYBhNZudRznlwrlOHTsrSivsSasDCN6BrYubsxGr8Wt2bonOSkVnaLNpOY=
X-Received: by 2002:a05:651c:114a:b0:25d:5ae6:42a4 with SMTP id
 h10-20020a05651c114a00b0025d5ae642a4mr19131225ljo.255.1667913181963; Tue, 08
 Nov 2022 05:13:01 -0800 (PST)
MIME-Version: 1.0
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <20220825-arm-spe-v8-7-v3-8-87682f78caac@kernel.org>
 <CAM9d7ciYabTpo0q5Z8h229dZ+RXG7JP1zgOoR1fgdZZCH87vow@mail.gmail.com>
In-Reply-To: <CAM9d7ciYabTpo0q5Z8h229dZ+RXG7JP1zgOoR1fgdZZCH87vow@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 8 Nov 2022 07:12:53 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKS+xos95R0KUhm-xJ5ZhTaa7XYc-Ly45BCEWTXOh4j7w@mail.gmail.com>
Message-ID: <CAL_JsqKS+xos95R0KUhm-xJ5ZhTaa7XYc-Ly45BCEWTXOh4j7w@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] perf: arm_spe: Add support for SPEv1.2 inverted
 event filtering
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 linux-perf-users@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, James Clark <james.clark@arm.com>
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

On Mon, Nov 7, 2022 at 1:48 PM Namhyung Kim <namhyung@kernel.org> wrote:
>
> Hello,
>
> On Fri, Nov 4, 2022 at 8:55 AM Rob Herring <robh@kernel.org> wrote:
> >
> > Arm SPEv1.2 (Arm v8.7/v9.2) adds a new feature called Inverted Event
> > Filter which excludes samples matching the event filter. The feature
> > mirrors the existing event filter in PMSEVFR_EL1 adding a new register,
> > PMSNEVFR_EL1, which has the same event bit assignments.
>
> Just out of curiosity, is it possible to have the event filter and
> inverted filter at the same time?

Yes, that's why config3 is needed. Samples with all the events set in
PMSEVFR_EL1 and none of the events set in PMSNEVFR_EL1 are recorded.
For example if an event bit is 0 in PMSEVFR_EL1, then recorded samples
may or may not have that event. If the same event bit is then set in
PMSNEVFR_EL1, then record samples will not have that event.

> What if they have the same?

You'd get no samples.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
