Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F5EBC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 19:32:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C104B21D1B
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 19:32:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C104B21D1B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C23F4B215;
	Mon,  4 Jan 2021 14:32:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dQ4TD9uJp-pS; Mon,  4 Jan 2021 14:32:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D72934B20C;
	Mon,  4 Jan 2021 14:32:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75AEC4B20C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 14:32:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ff8dZYRYVfTt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2021 14:32:44 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A4874B20B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 14:32:44 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3AB9720784;
 Mon,  4 Jan 2021 19:32:43 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kwVar-005IJG-4e; Mon, 04 Jan 2021 19:32:41 +0000
MIME-Version: 1.0
Date: Mon, 04 Jan 2021 19:32:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: Qian Cai <qcai@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Don't access PMCR_EL0 when no PMU is available
In-Reply-To: <22cd2b3e8b8b278f110a3540755583efee7189fd.camel@redhat.com>
References: <20201210083059.1277162-1-maz@kernel.org>
 <703e1b5f2db1631e8f9c55619909fe66eb069f25.camel@redhat.com>
 <579c839a0016107af66e704f147f9814@kernel.org>
 <f4300d00b9d2540bf90a6b1baadf030a2e4c92ed.camel@redhat.com>
 <bd725a533e4754b0d5634574bcab4b0d@kernel.org>
 <a0fcd5a4a595deddd990a6327568c82a1e94948a.camel@redhat.com>
 <f7b97771ed29c7630f678a8939a591dd@kernel.org>
 <22cd2b3e8b8b278f110a3540755583efee7189fd.camel@redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <81607700b5de4860a6f281c68ee17669@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qcai@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com, sfr@canb.auug.org.au,
 linux-next@vger.kernel.org, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>, kernel-team@android.com,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-04 18:42, Qian Cai wrote:
> On Mon, 2021-01-04 at 18:26 +0000, Marc Zyngier wrote:
>> What I'm suggesting is this [1], which is to get rid of KVM_ARM_PMU
>> completely. At least, the kernel configuration will be consistent.
>> 
> 
> Do you have a patch for CONFIG_KVM to select HW_PERF_EVENTS then? I 
> could cook
> one if not.

I don't think there should be such a patch. People do disable
HW_PERF_EVENTS in production in some cases, and we should
honor that. All I am trying to guarantee at the moment is
that the KVM configuration is consistent, as I believe that's
what broke in your particular case.

What needs doing is to hide the PMU registers from userspace
when no PMU is configured, or even available. I'll try and post
something to that effect tomorrow (hey, I'm still officially
on holiday...).

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
