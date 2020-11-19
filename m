Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F38CC63697
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:58:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDF8E24655
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:58:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDF8E24655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52D2B4B564;
	Thu, 19 Nov 2020 11:58:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gkc89xT+ddtL; Thu, 19 Nov 2020 11:58:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 368664B4FD;
	Thu, 19 Nov 2020 11:58:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 730D14B488
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:58:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fhzz9nN0cV7w for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 11:58:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 317874B4B3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:58:25 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5D0A1595;
 Thu, 19 Nov 2020 08:58:24 -0800 (PST)
Received: from [192.168.2.21] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AFC743F718;
 Thu, 19 Nov 2020 08:58:23 -0800 (PST)
From: James Morse <james.morse@arm.com>
Subject: Re: [RFC PATCH v3 04/16] arm64: Introduce CPU SPE feature
To: Alexandru Elisei <alexandru.elisei@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
 <20201027172705.15181-5-alexandru.elisei@arm.com>
Message-ID: <418e3bf6-159c-6d1f-2b84-2fdb10c3cddd@arm.com>
Date: Thu, 19 Nov 2020 16:58:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201027172705.15181-5-alexandru.elisei@arm.com>
Content-Language: en-GB
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org,
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

Hi Alex,

On 27/10/2020 17:26, Alexandru Elisei wrote:
> Detect Statistical Profiling Extension (SPE) support using the cpufeatures
> framework. The presence of SPE is reported via the ARM64_SPE capability.
> 
> The feature will be necessary for emulating SPE in KVM, because KVM needs
> that all CPUs have SPE hardware to avoid scheduling a VCPU on a CPU without
> support. For this reason, the feature type ARM64_CPUCAP_SYSTEM_FEATURE has
> been selected to disallow hotplugging a CPU which doesn't support SPE.

Can you mention the existing driver in the commit message? Surprisingly it doesn't use
cpufeature at all. It looks like arm_spe_pmu_dev_init() goes out of its way to support
mismatched systems. (otherwise the significance of the new behaviour isn't clear!)

I read it as: the host is fine with mismatched systems, and the existing drivers supports
this. But KVM is not. After this patch you can't make the system mismatched 'late'.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
