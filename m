Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09441C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 16:56:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 214DC64E07
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 16:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 214DC64E07
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AC074B1B2;
	Thu, 28 Jan 2021 11:56:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qh2-VINyYLuw; Thu, 28 Jan 2021 11:56:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BCBB4B184;
	Thu, 28 Jan 2021 11:56:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF0104B17E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 11:56:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WPvail-+Iev5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 11:56:05 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EED5F4B0DE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 11:56:04 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9501D64E07;
 Thu, 28 Jan 2021 16:56:03 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l5AaP-00AedB-9V; Thu, 28 Jan 2021 16:56:01 +0000
MIME-Version: 1.0
Date: Thu, 28 Jan 2021 16:56:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Turn kvm_arm_support_pmu_v3() into a
 static key
In-Reply-To: <20210128151643.6e2c3668@slackpad.fritz.box>
References: <20210126151521.2958688-1-maz@kernel.org>
 <20210126151521.2958688-2-maz@kernel.org>
 <20210128151643.6e2c3668@slackpad.fritz.box>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <9bf9be4149cfd0671fe5178ce553159b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-28 15:16, Andre Przywara wrote:
> On Tue, 26 Jan 2021 15:15:20 +0000
> Marc Zyngier <maz@kernel.org> wrote:
> 
> Hi Marc,
> 
>> We currently find out about the presence of a HW PMU (or the handling
>> of that PMU by perf, which amounts to the same thing) in a fairly
>> roundabout way, by checking the number of counters available to perf.
>> That's good enough for now, but we will soon need to find about about
>> that on paths where perf is out of reach (in the world switch).
>> 
>> Instead, let's turn kvm_arm_support_pmu_v3() into a static key.
> 
> I am sure the pesky build bot has told you about it already, but this
> fails when ARM_PMU is not defined, as perf_num_counters() is not
> defined. It's  bit nasty, since it's a generic function, so we
> can't easily stub it in its original header.

No sign from the bot yet, but that's indeed a problem. Well spotted.

> Shall we find a place somewhere in arch/arm64 and provide a stub
> implementation there, #ifndef CONFIG_ARM_PMU? Sounds ugly, though.
> 
> Or something else entirely?

How about:

diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index 198fa4266b2d..739164324afe 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -55,7 +55,7 @@ int kvm_perf_init(void)
  	 * hardware performance counters. This could ensure the presence of
  	 * a physical PMU and CONFIG_PERF_EVENT is selected.
  	 */
-	if (perf_num_counters() > 0)
+	if (IS_ENABLED(CONFIG_ARM_PMU) && perf_num_counters() > 0)
  		static_branch_enable(&kvm_arm_pmu_available);

  	return perf_register_guest_info_callbacks(&kvm_guest_cbs);

It certainly compiles here.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
