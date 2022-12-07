Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F1CC63709
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 19:57:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A540A4B7E7;
	Wed,  7 Dec 2022 14:57:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DTcaXniyjAt3; Wed,  7 Dec 2022 14:57:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A1F94B7A7;
	Wed,  7 Dec 2022 14:57:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 105CC4B7A7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 14:57:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qsQoUe2lO43i for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 14:57:08 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D08344B785
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 14:57:07 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id EFD0FB82055
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 19:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B88C43470
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 19:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1670443024;
 bh=AvmeQtrnl7xMXtEnD6viJTvtLqEQcfiUyyyKZl/KgUI=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=ObplL2g8TxTO5JJOjfNmVoA6K7NHMQs2vaoeQ8u0mEZIQu8gLeqCx6d8mgaTga/BN
 bc376wJENHG5Zx2mALAkvG9AD8eEcU2D2t+zU/g2gWfdHcB+YvjaUhf1eAM4ah9E6g
 HxlHuQI1pnrpq56qd7fAIykbUO5dDDDDSSM2TpXQ+cHruqik5wqddbEmqONurSgYoO
 iIs1QIs5quM6sNqIBbuV5a9PcQuIdKGKk2qlEiYFZqBY7GCJgFBA+/Q67aNSN+fjOe
 TkuSnoXCog3/5QBkPYZiRnsqQ73zm7umoQBu2qcR0AedfrMHeLNUMMMLfwy05q6xsL
 0hLaOMGk22yRw==
Received: by mail-vk1-f177.google.com with SMTP id g137so8773426vke.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Dec 2022 11:57:04 -0800 (PST)
X-Gm-Message-State: ANoB5pk+LGbB7gNO/P9eKraew4kEdw38sx0LGUCusdi4AurGCPnWqw7I
 is/FvePI6zyyq+JLi+Xi/iuzFQdiQP4CAtVxHg==
X-Google-Smtp-Source: AA0mqf79ttTFnrHyDKt4VUK0QUXtDvssZUfj1nXbNUgEZmKUPkzsNanut9A30xKpK3IOHRfaB9JBKoN+r9dpoMCKPpw=
X-Received: by 2002:a1f:41ca:0:b0:3bd:ce89:f4e6 with SMTP id
 o193-20020a1f41ca000000b003bdce89f4e6mr4493288vka.26.1670443023467; Wed, 07
 Dec 2022 11:57:03 -0800 (PST)
MIME-Version: 1.0
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <20220825-arm-spe-v8-7-v3-7-87682f78caac@kernel.org>
 <20221118164943.GA4872@willie-the-truck>
 <CAL_JsqJMxEWhqZV=yqG15zvEHrBTwRVfHA6zptu2TswxRMSR0A@mail.gmail.com>
 <877czfujdj.fsf@ubik.fi.intel.com>
 <CAL_JsqKJYrEUzkzNMKMOGvzJN_EqacHZvBR6eVt35bRhhtRo=g@mail.gmail.com>
 <Y49ttrv6W5k3ZNYw@FVFF77S0Q05N.cambridge.arm.com>
In-Reply-To: <Y49ttrv6W5k3ZNYw@FVFF77S0Q05N.cambridge.arm.com>
From: Rob Herring <robh@kernel.org>
Date: Wed, 7 Dec 2022 13:56:52 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLfZVrwFgYDwA9mz3FPp3jf0r5OOajTJ=7QvwE8P8UKyw@mail.gmail.com>
Message-ID: <CAL_JsqLfZVrwFgYDwA9mz3FPp3jf0r5OOajTJ=7QvwE8P8UKyw@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] perf: Add perf_event_attr::config3
To: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 linux-perf-users@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Namhyung Kim <namhyung@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 James Clark <james.clark@arm.com>
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

On Tue, Dec 6, 2022 at 10:28 AM Mark Rutland <mark.rutland@arm.com> wrote:
>
> Peter, it looks like this series is blocked on the below now; what would you
> prefer out of:
>
> (a) Take this as is, and look add adding additional validation on top.
>
> (b) Add some flag to indicate a PMU driver supports config3, and have the core
>     code check that, but leave the existing fields as-is for now (and hopefully
>     follow up with further validation later for the existing fields).

That looks something like this:

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 853f64b6c8c2..845162b152ea 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -286,6 +286,7 @@ struct perf_event;
 #define PERF_PMU_CAP_NO_EXCLUDE                        0x0080
 #define PERF_PMU_CAP_AUX_OUTPUT                        0x0100
 #define PERF_PMU_CAP_EXTENDED_HW_TYPE          0x0200
+#define PERF_PMU_CAP_CONFIG3                   0x0400

 struct perf_output_handle;

diff --git a/kernel/events/core.c b/kernel/events/core.c
index aefc1e08e015..4414ae64432a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11314,6 +11314,9 @@ static int perf_try_init_event(struct pmu
*pmu, struct perf_event *event)
                    event_has_any_exclude_flag(event))
                        ret = -EINVAL;

+               if (!(pmu->capabilities & PERF_PMU_CAP_CONFIG3) &&
event->attr.config3)
+                       ret = -EINVAL;
+
                if (ret && event->destroy)
                        event->destroy(event);
        }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
