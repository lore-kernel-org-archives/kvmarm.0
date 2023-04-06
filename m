Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0232ECA
	for <kvmarm@lists.linux.dev>; Thu,  6 Apr 2023 07:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PSTnZvKPii8CuqOLasDZa85RvXeN5qcfEeMj/qPN4AI=; b=NS+Rj5XNebo6MF4JhS2WqHg+pY
	ILIdptlQ1bk40yfARr2w/c3p1krt6L0pMWX612ksBo1yCxk9YxCWaqf2t7UWlPP1tCrwpnQzKCNd3
	cBi2ZFmaJ7k+LwPVX3gYnTYJSIF3tMDHiTVxOXbMEKAhDpOq3v6ZOpOU9kD7sFxxavM5TdWx5S3fd
	gOJSgcgQM086pSBofRNXZVbJkznDSLzclz5TcbU0TrQy0hMUae0+OQhMcsOIPqKSLyv67cepA8V7m
	9Tiogm4Fuxu1w4JrHqEV6JFitpcmTral7U/bnGHxrFZX4jTpKUycTLFmHBUJJZD1SM7/dBCTXlEOZ
	0K21+nJQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1pkKCn-00ASbW-0T;
	Thu, 06 Apr 2023 07:38:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 74E9D3000DC;
	Thu,  6 Apr 2023 09:38:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5BAFA24C025F1; Thu,  6 Apr 2023 09:38:48 +0200 (CEST)
Date: Thu, 6 Apr 2023 09:38:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Saravana Kannan <saravanak@google.com>
Cc: David Dai <davidai@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>, Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <20230406073848.GC386572@hirez.programming.kicks-ass.net>
References: <20230330224348.1006691-1-davidai@google.com>
 <20230405080548.GW4253@hirez.programming.kicks-ass.net>
 <CAGETcx-qgKeUQ60VhvW+hYUY-sMh-wX1G8zSwJUFpJ-u7aU6aA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-qgKeUQ60VhvW+hYUY-sMh-wX1G8zSwJUFpJ-u7aU6aA@mail.gmail.com>

On Wed, Apr 05, 2023 at 02:08:43PM -0700, Saravana Kannan wrote:

> The only 2 pieces of information shared between host/guest are:
> 
> 1. Host CPU frequency -- this isn't really scheduler internals and
> will map nicely to a virtual cpufreq driver.
> 
> 2. A vCPU util value between 0 - 1024 where 1024 corresponds to the
> highest performance point across all CPUs (taking freq, arch, etc into
> consideration). Yes, this currently matches how the run queue util is
> tracked, but we can document the interface as "percentage of max
> performance capability", but representing it as 0 - 1024 instead of
> 0-100. That way, even if the scheduler changes how it tracks util in
> the future, we can still keep this interface between guest/host and
> map it appropriately on the host end.
> 
> In either case, we could even have a Windows guest where they might
> track vCPU utilization differently and still have this work with the
> Linux host with this interface.
> 
> Does that sound reasonable to you?

Yeah, I suppose that's managable.

Something that wasn't initially clear to me; all this hard assumes a 1:1
vCPU:CPU relation, right? Which isn't typical in virt land.
