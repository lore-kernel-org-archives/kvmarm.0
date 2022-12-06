Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E19C352A1
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 16:28:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8457140397;
	Tue,  6 Dec 2022 11:28:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GQiuZSavW-8b; Tue,  6 Dec 2022 11:28:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EA3740E25;
	Tue,  6 Dec 2022 11:28:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEDEC40397
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 11:28:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ST3FYM3u9Ks for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 11:28:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3036E401AF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 11:28:47 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34C3723A;
 Tue,  6 Dec 2022 08:28:53 -0800 (PST)
Received: from FVFF77S0Q05N.cambridge.arm.com (FVFF77S0Q05N.cambridge.arm.com
 [10.1.39.172])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C787A3F73B;
 Tue,  6 Dec 2022 08:28:43 -0800 (PST)
Date: Tue, 6 Dec 2022 16:28:38 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robh@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 7/8] perf: Add perf_event_attr::config3
Message-ID: <Y49ttrv6W5k3ZNYw@FVFF77S0Q05N.cambridge.arm.com>
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <20220825-arm-spe-v8-7-v3-7-87682f78caac@kernel.org>
 <20221118164943.GA4872@willie-the-truck>
 <CAL_JsqJMxEWhqZV=yqG15zvEHrBTwRVfHA6zptu2TswxRMSR0A@mail.gmail.com>
 <877czfujdj.fsf@ubik.fi.intel.com>
 <CAL_JsqKJYrEUzkzNMKMOGvzJN_EqacHZvBR6eVt35bRhhtRo=g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL_JsqKJYrEUzkzNMKMOGvzJN_EqacHZvBR6eVt35bRhhtRo=g@mail.gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
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

Peter, it looks like this series is blocked on the below now; what would you
prefer out of:

(a) Take this as is, and look add adding additional validation on top.

(b) Add some flag to indicate a PMU driver supports config3, and have the core
    code check that, but leave the existing fields as-is for now (and hopefully
    follow up with further validation later for the existing fields).

(c) Go audit all the existing drivers, add flags to indicate support for
    existing fields, and have the core code check that. Atop that, add support
    for config3 with the same sort of flag check.

    I suspect that'd end up needing to go check more than config1/config2 given
    all the filter controls and so on that drivers aren't great at checking,
    and that might being fairly invasive.

(d) Something else?

I think we want to get to a point where drivers indicate what they actually
support and the core code rejects stuff drivers don't support or recognise, but
I think it'd be a little unreasonable to delay this series on cleaning up all
the existing issues.

I'm tempted to say (b) as that shouldn't introduce any regressions, should be a
relatively simple change to this series, and doesn't precluse making the rest
stricter as a follow-up. I'm happy to take a look at that (and IIUC Rob is
too).

What's your preference?

Thanks,
Mark.

On Mon, Nov 28, 2022 at 11:15:21AM -0600, Rob Herring wrote:
> On Mon, Nov 28, 2022 at 10:36 AM Alexander Shishkin
> <alexander.shishkin@linux.intel.com> wrote:
> >
> > Rob Herring <robh@kernel.org> writes:
> >
> > > On Fri, Nov 18, 2022 at 10:49 AM Will Deacon <will@kernel.org> wrote:
> > >>
> > >> On Fri, Nov 04, 2022 at 10:55:07AM -0500, Rob Herring wrote:
> > >> > @@ -515,6 +516,8 @@ struct perf_event_attr {
> > >> >        * truncated accordingly on 32 bit architectures.
> > >> >        */
> > >> >       __u64   sig_data;
> > >> > +
> > >> > +     __u64   config3; /* extension of config2 */
> > >>
> > >> I need an ack from the perf core maintainers before I can take this.
> > >
> > > Peter, Arnaldo, Ingo,
> > >
> > > Can I get an ack on this please.
> >
> > It appears that PMUs that don't use config{1,2} and now config3 allow
> > them to be whatever without any validation, whereas in reality we should
> > probably -EINVAL in those cases. Should something be done about that?
> 
> Always the 3rd occurrence that gets to clean-up things. ;)
> 
> I think we'd have to add some capability flags for PMU drivers to set
> to enable configN usage and then use those to validate configN is 0.
> Wouldn't be too hard to do for config3 as we know there's exactly 1
> user, but for 1,2 there's about 80 PMU drivers to check.
> 
> Rob
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
