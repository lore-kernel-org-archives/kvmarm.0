Received: from out-59.mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7B9D304
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 23:40:41 +0000 (UTC)
Date: Thu, 30 Mar 2023 23:40:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680219639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ozqnvgu8saWyQ2rIbnUehRz7b/Vy2JwK5AYTCp0h8Q=;
	b=GVUFHCJJP0L+YOHtwnGWmONEzat8uo7DSusSdlE1D3qnPxYk0iMb8uQI9VLkRv/Uwiv9j1
	LWNOeAo0zDtIqihN5EKvigkpM6s9SEkE14H8s0DMZROBzjtgVGN1N4fSm0yuYorC3lS/53
	MM3puUJM1f7PclveS6LFzOtpdEnj38I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Saravana Kannan <saravanak@google.com>
Cc: David Dai <davidai@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>, kernel-team@android.com,
	linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
Message-ID: <ZCYd7kH2f/Ku8b0D@linux.dev>
References: <20230330224348.1006691-1-davidai@google.com>
 <ZCYZRIbPh+f3v26v@linux.dev>
 <CAGETcx_P27-=wkAkCETTR2Q0edA01M5jArS_t-zZFn61YM9Muw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGETcx_P27-=wkAkCETTR2Q0edA01M5jArS_t-zZFn61YM9Muw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 30, 2023 at 04:36:52PM -0700, Saravana Kannan wrote:
> On Thu, Mar 30, 2023 at 4:20 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
> >
> > [...]
> >
> > > David Dai (6):
> > >   sched/fair: Add util_guest for tasks
> > >   kvm: arm64: Add support for get_cur_cpufreq service
> > >   kvm: arm64: Add support for util_hint service
> > >   kvm: arm64: Add support for get_freqtbl service
> > >   dt-bindings: cpufreq: add bindings for virtual kvm cpufreq
> > >   cpufreq: add kvm-cpufreq driver
> >
> > I only received patches 2-4 in my inbox (same goes for the mailing lists
> > AFAICT). Mind sending the rest? :)
> 
> Oliver,
> 
> Sorry about that. Actually even I'm not cc'ed in the cover letter :)
> 
> Is it okay if we fix this when we send the next version? Mainly to
> avoid some people responding to this vs other responding to a new
> series (where the patches are the same).

Fine by me, as long as the full series arrived somewhere.

> We used a script for --to-cmd and --cc-cmd but looks like it needs
> some more fixes.
> 
> Here is the full series to anyone who's wondering where the rest of
> the patches are:
> https://lore.kernel.org/lkml/20230330224348.1006691-1-davidai@google.com/T/#t

Gah, a bit of noodling would've dug up the full series. Thanks for the
link.

-- 
Thanks,
Oliver
