Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DEEC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 28 Nov 2022 15:37:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A79410F3;
	Mon, 28 Nov 2022 10:37:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YGG9GF5IL7rq; Mon, 28 Nov 2022 10:37:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CD074B269;
	Mon, 28 Nov 2022 10:37:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DABC54B248
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 10:37:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hAZTL8Wkj7Mk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2022 10:37:42 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1E3C4A0D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 10:37:42 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7E9B06123E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 15:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30BFC433D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1669649860;
 bh=axC0bOfcmCXcacu/P2Pz0VCjCGhZUlb2iE5k15oCKYg=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=ucSbWoT0+0wduq4sl2bVdpv3u2Q9Pddm6ucmKKK7+ELAgmXlReOH/bMpzEmtxhbHs
 LdDMsxtzEDSxU9TFIdoeEfaBc9OrPslaYn4tLvdiR8yeKH+mGhw8d6ZPEGgFPYsgjj
 qzdrMezj/xH7d/hFfKqFBevU2I5BOw1SklGasLhO7DHeZFV8x72SMzkYSZaQaDjZeh
 bpyDvj80fLeqGTdjswxum0xOPZi5qas91sc/aAcQwTxgVMLfaPNgoDxhIKBdhTjKX3
 XvjA/GieW4tTrlq+WgHuBB200PFObXnJknm7oGYlBAm2eYxhpxFCuG1lK0RVenS5qg
 8rDNqw4GC2lkA==
Received: by mail-vk1-f177.google.com with SMTP id j19so5325854vke.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 07:37:40 -0800 (PST)
X-Gm-Message-State: ANoB5pmX5LotKP4O/bAYxBgciOY938jj4ePBziRU62jCm6ht/K4nRk+O
 Bz4q8bBK37c5eVRmVE0KmInY3gskjmvDMeGeTQ==
X-Google-Smtp-Source: AA0mqf47oOpOINKJ64oOFgIVKNUPHLJ4ZGkpiXyC+OMmMYBM1LnHgMTlIgOw0DD8Jyah1mivcWxiIo1aoqaQuKrmCjM=
X-Received: by 2002:a05:6122:b45:b0:3bc:811b:ddce with SMTP id
 5-20020a0561220b4500b003bc811bddcemr20313339vko.35.1669649859866; Mon, 28 Nov
 2022 07:37:39 -0800 (PST)
MIME-Version: 1.0
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <20220825-arm-spe-v8-7-v3-7-87682f78caac@kernel.org>
 <20221118164943.GA4872@willie-the-truck>
In-Reply-To: <20221118164943.GA4872@willie-the-truck>
From: Rob Herring <robh@kernel.org>
Date: Mon, 28 Nov 2022 09:37:28 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJMxEWhqZV=yqG15zvEHrBTwRVfHA6zptu2TswxRMSR0A@mail.gmail.com>
Message-ID: <CAL_JsqJMxEWhqZV=yqG15zvEHrBTwRVfHA6zptu2TswxRMSR0A@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] perf: Add perf_event_attr::config3
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 James Clark <james.clark@arm.com>, Jiri Olsa <jolsa@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Namhyung Kim <namhyung@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Nov 18, 2022 at 10:49 AM Will Deacon <will@kernel.org> wrote:
>
> On Fri, Nov 04, 2022 at 10:55:07AM -0500, Rob Herring wrote:
> > Arm SPEv1.2 adds another 64-bits of event filtering control. As the
> > existing perf_event_attr::configN fields are all used up for SPE PMU, an
> > additional field is needed. Add a new 'config3' field.
> >
> > Tested-by: James Clark <james.clark@arm.com>
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> > v3:
> >  - No change
> > v2:
> >  - Drop tools/ side update
> > ---
> >  include/uapi/linux/perf_event.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> > index 85be78e0e7f6..b2b1d7b54097 100644
> > --- a/include/uapi/linux/perf_event.h
> > +++ b/include/uapi/linux/perf_event.h
> > @@ -374,6 +374,7 @@ enum perf_event_read_format {
> >  #define PERF_ATTR_SIZE_VER5  112     /* add: aux_watermark */
> >  #define PERF_ATTR_SIZE_VER6  120     /* add: aux_sample_size */
> >  #define PERF_ATTR_SIZE_VER7  128     /* add: sig_data */
> > +#define PERF_ATTR_SIZE_VER8  136     /* add: config3 */
> >
> >  /*
> >   * Hardware event_id to monitor via a performance monitoring event:
> > @@ -515,6 +516,8 @@ struct perf_event_attr {
> >        * truncated accordingly on 32 bit architectures.
> >        */
> >       __u64   sig_data;
> > +
> > +     __u64   config3; /* extension of config2 */
>
> I need an ack from the perf core maintainers before I can take this.

Peter, Arnaldo, Ingo,

Can I get an ack on this please.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
