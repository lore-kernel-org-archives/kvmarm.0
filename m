Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BBAC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 28 Nov 2022 17:15:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C63F4B286;
	Mon, 28 Nov 2022 12:15:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y02dK3pSGBgt; Mon, 28 Nov 2022 12:15:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D205E4B28D;
	Mon, 28 Nov 2022 12:15:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92BA34B286
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 12:15:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eInIuLavElUf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2022 12:15:39 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FE3D40ECC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 12:15:39 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 0D519B80E76
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 17:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC098C433C1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1669655734;
 bh=TjkRRocGp4/KkfkTxpUuw69NnWIMsmRgISNVf22kTRY=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=gb+2JqY1awK0mINOxq4IOVP2bvEr5zFbvNeybTUSIRF1uf8NT78hZ8tldu0x7v9jb
 /M6OzFHfSkmR934ZE4HVU1nt+ukWfEjX4dFHOnAeDYX1BqnzlhBeoxZzJp84Mx1651
 80i5gyLFnOryM3LVTlvuX+n8iulgTzlUt6q2/vl4gZ1p24sE/yYUc4UrSvt49wen/H
 L2NK92XAC46Jfb9pXeCnsIowsypLXlwDqKe/HMZs2Pa4mVan2YvqJTyhWSDPIelXql
 +T8pYunZNHrKgrtcWdoZnv+WwQlHlCvdQAhWXTEccl6wbrN+zMIimXNZd20l1W3UKS
 9D65CUkh8rVsg==
Received: by mail-vk1-f174.google.com with SMTP id f68so5581155vkc.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 09:15:34 -0800 (PST)
X-Gm-Message-State: ANoB5plvBKyVr+GQaB5mevT73HwHCEk4srqODkSUr+YBpKi9DKK6cQ+v
 ztclnx9uAafaJpDExBmF8DV1OhiCTYYctkD52g==
X-Google-Smtp-Source: AA0mqf5DGWfEzpziiy8nNC806yxTFRTyR6VEXoTa46759eX6T6/rQB46oLpPxYdhiPJ/cDZe0y9EkUNMrHCu5nCup6Y=
X-Received: by 2002:a1f:b2c9:0:b0:3b7:8f9b:4eff with SMTP id
 b192-20020a1fb2c9000000b003b78f9b4effmr19775933vkf.19.1669655733655; Mon, 28
 Nov 2022 09:15:33 -0800 (PST)
MIME-Version: 1.0
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <20220825-arm-spe-v8-7-v3-7-87682f78caac@kernel.org>
 <20221118164943.GA4872@willie-the-truck>
 <CAL_JsqJMxEWhqZV=yqG15zvEHrBTwRVfHA6zptu2TswxRMSR0A@mail.gmail.com>
 <877czfujdj.fsf@ubik.fi.intel.com>
In-Reply-To: <877czfujdj.fsf@ubik.fi.intel.com>
From: Rob Herring <robh@kernel.org>
Date: Mon, 28 Nov 2022 11:15:21 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKJYrEUzkzNMKMOGvzJN_EqacHZvBR6eVt35bRhhtRo=g@mail.gmail.com>
Message-ID: <CAL_JsqKJYrEUzkzNMKMOGvzJN_EqacHZvBR6eVt35bRhhtRo=g@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] perf: Add perf_event_attr::config3
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 linux-perf-users@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 Jiri Olsa <jolsa@kernel.org>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
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

On Mon, Nov 28, 2022 at 10:36 AM Alexander Shishkin
<alexander.shishkin@linux.intel.com> wrote:
>
> Rob Herring <robh@kernel.org> writes:
>
> > On Fri, Nov 18, 2022 at 10:49 AM Will Deacon <will@kernel.org> wrote:
> >>
> >> On Fri, Nov 04, 2022 at 10:55:07AM -0500, Rob Herring wrote:
> >> > @@ -515,6 +516,8 @@ struct perf_event_attr {
> >> >        * truncated accordingly on 32 bit architectures.
> >> >        */
> >> >       __u64   sig_data;
> >> > +
> >> > +     __u64   config3; /* extension of config2 */
> >>
> >> I need an ack from the perf core maintainers before I can take this.
> >
> > Peter, Arnaldo, Ingo,
> >
> > Can I get an ack on this please.
>
> It appears that PMUs that don't use config{1,2} and now config3 allow
> them to be whatever without any validation, whereas in reality we should
> probably -EINVAL in those cases. Should something be done about that?

Always the 3rd occurrence that gets to clean-up things. ;)

I think we'd have to add some capability flags for PMU drivers to set
to enable configN usage and then use those to validate configN is 0.
Wouldn't be too hard to do for config3 as we know there's exactly 1
user, but for 1,2 there's about 80 PMU drivers to check.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
