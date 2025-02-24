Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 620B01369B6
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 14:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740405805; cv=none; b=e0kH0jmNXw1GXU3TeR29KT+SfTrQaB9DdZR6jDLofJ/niCvCcBmHafQUPBfqRnW6RfxlNBu1SGSdRsW/Zxh1IkJl95RIl2g6GDWUR8PP7zU1bdlcwZib30SK4Jr+mJTCu3g1qVWiRg/jZ+E25syOHF5BTXxqCScemBfxnT2XrU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740405805; c=relaxed/simple;
	bh=uRt4tqRoqDTY5+lgkCiQnEEqaFHzDQE2OPfebgftqD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYmYtXev+FlUnz5NCB8xgwYlsYgOqUVd/D08Tcv+oQZAmsRYFBW1ra0EMeI2+LF2gVLPwkGJM7xB1Yj+sXxJ08gJt6IPXck0puRkHKKPu4BiS0cuYykOTjH9WAF59g3HkVybZa0MDoVbWti/jNQshQDCVNE26lagbfvSXmc/iio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37BD71516;
	Mon, 24 Feb 2025 06:03:39 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 234F93F5A1;
	Mon, 24 Feb 2025 06:03:22 -0800 (PST)
Date: Mon, 24 Feb 2025 14:03:17 +0000
From: Leo Yan <leo.yan@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v20 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Message-ID: <20250224140317.GF8144@e132581.arm.com>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <20250218-arm-brbe-v19-v20-11-4e9922fc2e8e@kernel.org>
 <20250224122507.GE8144@e132581.arm.com>
 <CAL_Jsq+0fZ2uasgAam7qGTdCeDBQxXeyL-J1_suyxy6GE_ERTg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_Jsq+0fZ2uasgAam7qGTdCeDBQxXeyL-J1_suyxy6GE_ERTg@mail.gmail.com>

On Mon, Feb 24, 2025 at 06:46:35AM -0600, Rob Herring wrote:
> On Mon, Feb 24, 2025 at 6:25 AM Leo Yan <leo.yan@arm.com> wrote:
> > On Tue, Feb 18, 2025 at 02:40:06PM -0600, Rob Herring (Arm) wrote:
> > >
> > > From: Anshuman Khandual <anshuman.khandual@arm.com>
> >
> > [...]
> >
> > > BRBE records are invalidated whenever events are reconfigured, a new
> > > task is scheduled in, or after recording is paused (and the records
> > > have been recorded for the event). The architecture allows branch
> > > records to be invalidated by the PE under implementation defined
> > > conditions. It is expected that these conditions are rare.
> >
> > [...]
> >
> > > +static void armv8pmu_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
> > > +{
> > > +       struct arm_pmu *armpmu = *this_cpu_ptr(&cpu_armpmu);
> > > +       struct pmu_hw_events *hw_events = this_cpu_ptr(armpmu->hw_events);
> > > +
> > > +       if (!hw_events->branch_users)
> > > +               return;
> > > +
> > > +       if (sched_in)
> > > +               brbe_invalidate();
> > > +}
> >
> > Just a minor concern.  I don't see any handling for task migration.
> > E.g., for a task is migrated from one CPU to another CPU, I expect we
> > need to save and restore branch records based on BRBE injection.  So
> > far, the driver simply invalidates all records.
> >
> > I think this topic is very likely discussed before.  If this is the
> > case, please ignore my comment.  Except this, the code looks good
> > to me.
> 
> Not really discussed on the list, but that was present in v18 (though
> not functional because .sched_task() hook wasn't actually enabled) and
> Mark removed it. His work is here[1].The only comment was:
> 
> Note: saving/restoring at context-switch doesn't interact well with
> event rotation (e.g. if filters change)

In the brbe_enable() function, it "Merge the permitted branch filters
of all events".  Based on current implementation, all events share the
same branch filter.

When event rotation happens, if without context switch, in theory we
should can directly use the branch record (no invalidation, no injection)
for all events.

For a context-switch case, we need to save and re-inject branch record.
BRBE record sticks to a process context, no matter what events have been
enabled.

Thanks,
Leo
