Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0739E8F6C
	for <kvmarm@lists.linux.dev>; Mon, 28 Nov 2022 17:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB91CC433D7
	for <kvmarm@lists.linux.dev>; Mon, 28 Nov 2022 17:15:34 +0000 (UTC)
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
Received: by mail-vk1-f175.google.com with SMTP id t185so2917107vkb.7
        for <kvmarm@lists.linux.dev>; Mon, 28 Nov 2022 09:15:34 -0800 (PST)
X-Gm-Message-State: ANoB5pl2PG2ZB0CYp3Vc+3cmjOrnZc7yS5gAcGg/EWz1bjAzDv1DwRu3
	3Q42QRcq4bW/xCDNdtZXmmgdvX1Z2Wd6ugga2w==
X-Google-Smtp-Source: AA0mqf5DGWfEzpziiy8nNC806yxTFRTyR6VEXoTa46759eX6T6/rQB46oLpPxYdhiPJ/cDZe0y9EkUNMrHCu5nCup6Y=
X-Received: by 2002:a1f:b2c9:0:b0:3b7:8f9b:4eff with SMTP id
 b192-20020a1fb2c9000000b003b78f9b4effmr19775933vkf.19.1669655733655; Mon, 28
 Nov 2022 09:15:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <20220825-arm-spe-v8-7-v3-7-87682f78caac@kernel.org> <20221118164943.GA4872@willie-the-truck>
 <CAL_JsqJMxEWhqZV=yqG15zvEHrBTwRVfHA6zptu2TswxRMSR0A@mail.gmail.com> <877czfujdj.fsf@ubik.fi.intel.com>
In-Reply-To: <877czfujdj.fsf@ubik.fi.intel.com>
From: Rob Herring <robh@kernel.org>
Date: Mon, 28 Nov 2022 11:15:21 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKJYrEUzkzNMKMOGvzJN_EqacHZvBR6eVt35bRhhtRo=g@mail.gmail.com>
Message-ID: <CAL_JsqKJYrEUzkzNMKMOGvzJN_EqacHZvBR6eVt35bRhhtRo=g@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] perf: Add perf_event_attr::config3
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>, 
	Jiri Olsa <jolsa@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	James Clark <james.clark@arm.com>, Mark Brown <broonie@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221128171521.Qtt14N7dyh4OpX1Mo81lawTIhsrw8dwNbKO4zstqImg@z>

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
