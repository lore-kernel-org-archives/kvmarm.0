Received: from out-31.mta0.migadu.com (out-31.mta0.migadu.com [91.218.175.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69285D304
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 23:20:51 +0000 (UTC)
Date: Thu, 30 Mar 2023 23:20:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680218448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0aj5bOgQ4mEsCChUHVS6+sTeRnmXhckONq90XH8Us5w=;
	b=d1osQ0kLcawGNYbaohfARe7ASFRKQHSP51ARKk0AVqcCSDiOPc1MQpc8tmuI7W2u4ksGKc
	Gw5lLO2WUcOoAZzRGxLZ2jFzb5zUNozwy5maghEesziNF0eEzW709Lxz+IbJ0N8GPPWeL/
	1bBEBNAyUtFIedeU/SEKA0KStaQ1cS0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Dai <davidai@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
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
Message-ID: <ZCYZRIbPh+f3v26v@linux.dev>
References: <20230330224348.1006691-1-davidai@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330224348.1006691-1-davidai@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:

[...]

> David Dai (6):
>   sched/fair: Add util_guest for tasks
>   kvm: arm64: Add support for get_cur_cpufreq service
>   kvm: arm64: Add support for util_hint service
>   kvm: arm64: Add support for get_freqtbl service
>   dt-bindings: cpufreq: add bindings for virtual kvm cpufreq
>   cpufreq: add kvm-cpufreq driver

I only received patches 2-4 in my inbox (same goes for the mailing lists
AFAICT). Mind sending the rest? :)

-- 
Thanks,
Oliver
