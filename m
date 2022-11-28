Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B04C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 29 Nov 2022 09:17:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8652F4B3DF;
	Tue, 29 Nov 2022 04:17:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GeX2GrenFFmf; Tue, 29 Nov 2022 04:17:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01F4B4B349;
	Tue, 29 Nov 2022 04:17:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F21314B256
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 11:36:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SBGAtNMOKqO6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2022 11:36:00 -0500 (EST)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47BAE4B248
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 11:36:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1669653360; x=1701189360;
 h=from:to:cc:subject:in-reply-to:references:date:
 message-id:mime-version;
 bh=bpv9EcCzKKYgtgd8XPPXyhjlOvzzWCv3x/6Nbovu2o0=;
 b=mPn0i0uypiu2MjQQ1ChKxnc6BCpZWe5s5UvMY1wddosaXDR8d92LC3S/
 ULU0QzjgWf5NHm6lM/Vnc1jwmCy+nlz79TdffL6JV16jS3bltxuiinRcR
 KGVt1mI0f6Ezbum/7/9l7YEzLY4Y8QXsHs9jQDEPu/LlM03yg1FtcvjMU
 z4rEKEjRDW6vTFcmYEy/p/sFrRRjNFcJwBoq33ReYnOhiRCJLoxxQmwTL
 5nia4jIgtJQod8ZfAwubIqIB3y2GOr9RJeUwXLGahoKEw0HBkxfyE4U5C
 uxPYduw4AuaHYUUsrq4/vdG5bJsAZS71ifjGUuYoKgT45/IOffK7fDugp g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="341794097"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; d="scan'208";a="341794097"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 28 Nov 2022 08:35:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="674280975"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; d="scan'208";a="674280975"
Received: from ubik.fi.intel.com (HELO localhost) ([10.237.72.184])
 by orsmga008.jf.intel.com with ESMTP; 28 Nov 2022 08:35:53 -0800
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Rob Herring <robh@kernel.org>, Will Deacon <will@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 7/8] perf: Add perf_event_attr::config3
In-Reply-To: <CAL_JsqJMxEWhqZV=yqG15zvEHrBTwRVfHA6zptu2TswxRMSR0A@mail.gmail.com>
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <20220825-arm-spe-v8-7-v3-7-87682f78caac@kernel.org>
 <20221118164943.GA4872@willie-the-truck>
 <CAL_JsqJMxEWhqZV=yqG15zvEHrBTwRVfHA6zptu2TswxRMSR0A@mail.gmail.com>
Date: Mon, 28 Nov 2022 18:35:52 +0200
Message-ID: <877czfujdj.fsf@ubik.fi.intel.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 29 Nov 2022 04:17:05 -0500
Cc: alexander.shishkin@linux.intel.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, James Clark <james.clark@arm.com>,
 Jiri Olsa <jolsa@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
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

Rob Herring <robh@kernel.org> writes:

> On Fri, Nov 18, 2022 at 10:49 AM Will Deacon <will@kernel.org> wrote:
>>
>> On Fri, Nov 04, 2022 at 10:55:07AM -0500, Rob Herring wrote:
>> > @@ -515,6 +516,8 @@ struct perf_event_attr {
>> >        * truncated accordingly on 32 bit architectures.
>> >        */
>> >       __u64   sig_data;
>> > +
>> > +     __u64   config3; /* extension of config2 */
>>
>> I need an ack from the perf core maintainers before I can take this.
>
> Peter, Arnaldo, Ingo,
>
> Can I get an ack on this please.

It appears that PMUs that don't use config{1,2} and now config3 allow
them to be whatever without any validation, whereas in reality we should
probably -EINVAL in those cases. Should something be done about that?

Regards,
--
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
