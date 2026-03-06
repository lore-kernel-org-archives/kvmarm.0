Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDAFF26AA93
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 12:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772799558; cv=none; b=e0KwdaAQuc3OgaPgLLtiZxdr1d+S941PtZUpXZpcoBnbR9tktFO/gU6LYyXdl4x0DrjV6n5At0tU65dUh6DueNXNrGj+/c6u3II26zHgZ5netzjMx/7VZ2fDNtvNtPqlYx616P23HtoPQxk1VNX8gU0fdT685vAJIwWNlLI4WMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772799558; c=relaxed/simple;
	bh=WMOQpX/JNu7sTnxiMLx78jM9HbBwOUxwwWNo4ilILIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tb7J62VdudY0kPfrQ6NWPNZPpDvxP5uf9ziZcl2B+CuimDha1tQhDnEZcpZgKsf9gNtqZxo8vXOQ8kdOykZAu1vB7tUTmgJFo3LMOazuVy+zWngKYhgw3pRtqreHKbEN88qxPEIhHJYd33TjnhENiFwi0OhgtmblStscy4dPiqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0577F497;
	Fri,  6 Mar 2026 04:19:10 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADEFC3F694;
	Fri,  6 Mar 2026 04:19:14 -0800 (PST)
Date: Fri, 6 Mar 2026 12:19:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/4] arm64: errata: Work around early CME DVMSync
 acknowledgement
Message-ID: <aarGQNNi1HfrcGyy@arm.com>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-4-catalin.marinas@arm.com>
 <aamT6-Mvr9nI1unq@willie-the-truck>
 <aarB3iv8963UDn5E@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aarB3iv8963UDn5E@arm.com>

On Fri, Mar 06, 2026 at 12:00:30PM +0000, Catalin Marinas wrote:
> On Thu, Mar 05, 2026 at 02:32:11PM +0000, Will Deacon wrote:
> > On Mon, Mar 02, 2026 at 04:57:56PM +0000, Catalin Marinas wrote:
> > > +void sme_do_dvmsync(void)
> > > +{
> > > +	/*
> > > +	 * This is called from the TLB maintenance functions after the DSB ISH
> > > +	 * to send hardware DVMSync message. If this CPU sees the mask as
> > > +	 * empty, the remote CPU executing sme_set_active() would have seen
> > > +	 * the DVMSync and no IPI required.
> > > +	 */
> > > +	if (cpumask_empty(sme_active_cpus))
> > > +		return;
> > > +
> > > +	preempt_disable();
> > > +	smp_call_function_many(sme_active_cpus, sme_dvmsync_ipi, NULL, true);
> > > +	preempt_enable();
> > > +}
> > 
> > Why do we care about all CPUs using SME, rather than limiting it to the
> > set of CPUs using SME with the mm we've invalidated? This looks like it
> > will result in unnecessary cross-calls when multiple tasks are using SME
> > (especially as the mm flag is only cleared on fork).
> 
> Yes, it's a possibility but I traded it for simplicity. We also have the
> TTU case where we don't have an mm and we don't want to broadcast to all
> CPUs either, hence an sme_active_cpus mask. As I just replied on patch
> 2, for the TLB batching we wouldn't be able to use a cpumask in the
> batching structure since, per the ordering above, we need the DVMSync
> before checking if/where to send the IPI to.
> 
> For the typical TLBI (not TTU), we can track a per-mm mask passed down
> to this function (I have patches doing this but it didn't make a
> significant difference in benchmarks).

Reusing the current mm_cpumask(), something like below. We could also
scrap the MMCF_SME_DVMSYNC flag, though we end up always call
sme_do_dvmsync() and checking the mask, probably more expensive than a
flag check.

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index e3ea0246a4f4..2c77ca41cb14 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -81,7 +81,7 @@ static inline unsigned long get_trans_granule(void)
 }
 
 #ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
-void sme_do_dvmsync(void);
+void sme_do_dvmsync(struct mm_struct *mm);
 
 static inline void sme_dvmsync(struct mm_struct *mm)
 {
@@ -90,7 +90,7 @@ static inline void sme_dvmsync(struct mm_struct *mm)
 	if (mm && !test_bit(ilog2(MMCF_SME_DVMSYNC), &mm->context.flags))
 		return;
 
-	sme_do_dvmsync();
+	sme_do_dvmsync(mm);
 }
 #else
 static inline void sme_dvmsync(struct mm_struct *mm) { }
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 90015fc29722..37e215cd0f39 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1378,6 +1378,7 @@ void sme_set_active(unsigned int cpu)
 	if (!test_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags))
 		set_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags);
 
+	cpumask_set_cpu(cpu, mm_cpumask(current->mm));
 	cpumask_set_cpu(cpu, sme_active_cpus);
 
 	/*
@@ -1398,6 +1399,7 @@ void sme_clear_active(unsigned int cpu)
 	 * With SCTLR_EL1.IESB enabled, the SME memory transactions are
 	 * completed on entering EL1.
 	 */
+	cpumask_clear_cpu(cpu, mm_cpumask(current->mm));
 	cpumask_clear_cpu(cpu, sme_active_cpus);
 }
 
@@ -1410,19 +1412,25 @@ static void sme_dvmsync_ipi(void *unused)
 	 */
 }
 
-void sme_do_dvmsync(void)
+void sme_do_dvmsync(struct mm_struct *mm)
 {
 	/*
 	 * This is called from the TLB maintenance functions after the DSB ISH
 	 * to send hardware DVMSync message. If this CPU sees the mask as
 	 * empty, the remote CPU executing sme_set_active() would have seen
 	 * the DVMSync and no IPI required.
+	 *
+	 * When an mm is provided, limit the IPI to CPUs that are actively
+	 * running SME code for that mm (recorded in mm_cpumask()), otherwise
+	 * fall back to the global sme_active_cpus mask.
 	 */
-	if (cpumask_empty(sme_active_cpus))
+	const struct cpumask *mask = mm ? mm_cpumask(mm) : sme_active_cpus;
+
+	if (cpumask_empty(mask))
 		return;
 
 	preempt_disable();
-	smp_call_function_many(sme_active_cpus, sme_dvmsync_ipi, NULL, true);
+	smp_call_function_many(mask, sme_dvmsync_ipi, NULL, true);
 	preempt_enable();
 }
 
