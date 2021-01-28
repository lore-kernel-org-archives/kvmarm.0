Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBB6C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 18:43:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB74B64DF4
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 18:43:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB74B64DF4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E61F94B19A;
	Thu, 28 Jan 2021 13:43:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k-kiVP+J6q3L; Thu, 28 Jan 2021 13:43:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB7DE4B199;
	Thu, 28 Jan 2021 13:43:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F8724B191
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 13:43:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y+7pa28LevmA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 13:43:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8074B198
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 13:43:14 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BAA8E13A1;
 Thu, 28 Jan 2021 10:43:13 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1B4D3F719;
 Thu, 28 Jan 2021 10:43:12 -0800 (PST)
Date: Thu, 28 Jan 2021 18:42:31 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: Turn kvm_arm_support_pmu_v3() into a
 static key
Message-ID: <20210128184231.711e0c54@slackpad.fritz.box>
In-Reply-To: <9bf9be4149cfd0671fe5178ce553159b@kernel.org>
References: <20210126151521.2958688-1-maz@kernel.org>
 <20210126151521.2958688-2-maz@kernel.org>
 <20210128151643.6e2c3668@slackpad.fritz.box>
 <9bf9be4149cfd0671fe5178ce553159b@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

On Thu, 28 Jan 2021 16:56:01 +0000
Marc Zyngier <maz@kernel.org> wrote:

> On 2021-01-28 15:16, Andre Przywara wrote:
> > On Tue, 26 Jan 2021 15:15:20 +0000
> > Marc Zyngier <maz@kernel.org> wrote:
> > 
> > Hi Marc,
> >   
> >> We currently find out about the presence of a HW PMU (or the handling
> >> of that PMU by perf, which amounts to the same thing) in a fairly
> >> roundabout way, by checking the number of counters available to perf.
> >> That's good enough for now, but we will soon need to find about about
> >> that on paths where perf is out of reach (in the world switch).
> >> 
> >> Instead, let's turn kvm_arm_support_pmu_v3() into a static key.  
> > 
> > I am sure the pesky build bot has told you about it already, but this
> > fails when ARM_PMU is not defined, as perf_num_counters() is not
> > defined. It's  bit nasty, since it's a generic function, so we
> > can't easily stub it in its original header.  
> 
> No sign from the bot yet, but that's indeed a problem. Well spotted.
> 
> > Shall we find a place somewhere in arch/arm64 and provide a stub
> > implementation there, #ifndef CONFIG_ARM_PMU? Sounds ugly, though.
> > 
> > Or something else entirely?  
> 
> How about:
> 
> diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
> index 198fa4266b2d..739164324afe 100644
> --- a/arch/arm64/kvm/perf.c
> +++ b/arch/arm64/kvm/perf.c
> @@ -55,7 +55,7 @@ int kvm_perf_init(void)
>   	 * hardware performance counters. This could ensure the presence of
>   	 * a physical PMU and CONFIG_PERF_EVENT is selected.
>   	 */
> -	if (perf_num_counters() > 0)
> +	if (IS_ENABLED(CONFIG_ARM_PMU) && perf_num_counters() > 0)

Neat!

That indeed compiles and works in both cases (w/ and w/o ARM_PMU),
fixing the original BUG I saw when using this as the L1 kernel.

Thanks!
Andre

>   		static_branch_enable(&kvm_arm_pmu_available);
> 
>   	return perf_register_guest_info_callbacks(&kvm_guest_cbs);
> 
> It certainly compiles here.
> 
>          M.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
