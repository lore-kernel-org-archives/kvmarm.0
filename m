Return-Path: <SRS0=NVHA=GO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223CBC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 08:59:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D837227C3
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 08:59:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D837227C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADC7D4B295;
	Mon, 11 Jan 2021 03:59:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rwrza10uBfqb; Mon, 11 Jan 2021 03:59:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88B144B21D;
	Mon, 11 Jan 2021 03:59:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89A1F4B21D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 03:59:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K+CKx8JE9ntf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2021 03:59:35 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 841194B1D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 03:59:35 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 530C822581;
 Mon, 11 Jan 2021 08:59:34 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kyt2y-006cel-8W; Mon, 11 Jan 2021 08:59:32 +0000
MIME-Version: 1.0
Date: Mon, 11 Jan 2021 08:59:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: Haibo Xu <haibo.xu@linaro.org>
Subject: Re: [PATCH v3 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
In-Reply-To: <CAJc+Z1GFHp17+ROTyDnfS4QLs0kCEVBCD7+OBkHZA53q-zmiLQ@mail.gmail.com>
References: <20201210160002.1407373-1-maz@kernel.org>
 <CAJc+Z1GFHp17+ROTyDnfS4QLs0kCEVBCD7+OBkHZA53q-zmiLQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <47c1fd0431cb6dddcd9e81213b84c019@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: haibo.xu@linaro.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com,
 andre.przywara@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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

Hi Haibo,

On 2021-01-11 07:20, Haibo Xu wrote:
> On Fri, 11 Dec 2020 at 00:00, Marc Zyngier <maz@kernel.org> wrote:
>> 
>> This is a rework of the NV series that I posted 10 months ago[1], as a
>> lot of the KVM code has changed since, and the series apply anymore
>> (not that anybody really cares as the the HW is, as usual, made of
>> unobtainium...).
>> 
>> From the previous version:
>> 
>> - Integration with the new page-table code
>> - New exception injection code
>> - No more messing with the nVHE code
>> - No AArch32!!!!
>> - Rebased on v5.10-rc4 + kvmarm/next for 5.11
>> 
>> From a functionality perspective, you can expect a L2 guest to work,
>> but don't even think of L3, as we only partially emulate the
>> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,
>> as well as anything that would require a Stage-1 PTW. What we want to
>> achieve is that with NV disabled, there is no performance overhead and
>> no regression.
>> 
>> The series is roughly divided in 5 parts: exception handling, memory
>> virtualization, interrupts and timers for ARMv8.3, followed by the
>> ARMv8.4 support. There are of course some dependencies, but you'll
>> hopefully get the gist of it.
>> 
>> For the most courageous of you, I've put out a branch[2]. Of course,
>> you'll need some userspace. Andre maintains a hacked version of
>> kvmtool[3] that takes a --nested option, allowing the guest to be
>> started at EL2. You can run the whole stack in the Foundation
>> model. Don't be in a hurry ;-).
>> 
> 
> Hi Marc,
> 
> I got a kernel BUG message when booting the L2 guest kernel with the
> kvmtool on a FVP setup.
> Could you help have a look about the BUG message as well as my
> environment configuration?
> I think It probably caused by some local configurations of the FVP 
> setup.

No, this is likely a bug in your L1 guest, which was fixed in -rc3:

2a5f1b67ec57 ("KVM: arm64: Don't access PMCR_EL0 when no PMU is 
available")

and was found in the exact same circumstances. Alternatively, and if
you don't want to change your L1 guest, you can just pass the --pmu
option to kvmtool when starting the L1 guest.

Hope this helps,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
