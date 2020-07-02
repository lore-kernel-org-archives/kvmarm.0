Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24880C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:03:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A4FCB20890
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:03:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bb02j41H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4FCB20890
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E6374B5F0;
	Thu,  2 Jul 2020 09:03:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5wqsNlYbAxZP; Thu,  2 Jul 2020 09:03:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 444D94B5F5;
	Thu,  2 Jul 2020 09:03:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFEAB4B5F0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:03:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MzFJNKXSj9yG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 09:03:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1D0C4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:03:18 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D492220772;
 Thu,  2 Jul 2020 13:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593694998;
 bh=DU/qEXJhyo5s+7zwwietRnCmtfRVZjPerieDNN6bTyM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=bb02j41HDWRtcMeJGS5a/HmXQ23YjPopSGVn5Fy7ifGkuKU7hIY3kMM/XusJII12W
 Qqptkx7RxdiW6bkN5AuaLpY2SK+5RBPUXi1KWdbe5MQ588jxSdV3Xp/0xtqtYgy4u9
 zLTqhAs1lybS/8Simh/QLfLI7YZkb7+9nkhv0tls=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jqys0-008PHk-Es; Thu, 02 Jul 2020 14:03:16 +0100
MIME-Version: 1.0
Date: Thu, 02 Jul 2020 14:03:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
In-Reply-To: <dabc2406-4a7f-61cf-cdbd-b0b79d97bf2c@redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <fe9699e3ee2131fe800911aea1425af4@kernel.org>
 <dabc2406-4a7f-61cf-cdbd-b0b79d97bf2c@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <688823451d3d4a0cb4d346bb7f7b99aa@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, wangjingyi11@huawei.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Eric,

On 2020-07-02 13:36, Auger Eric wrote:
> Hi Marc,
> 
> On 7/2/20 10:22 AM, Marc Zyngier wrote:
>> On 2020-07-02 04:01, Jingyi Wang wrote:
>>> If gicv4.1(sgi hardware injection) supported, we test ipi injection
>>> via hw/sw way separately.
>> 
>> nit: active-less SGIs are not strictly a feature of GICv4.1 (you could
>> imagine a GIC emulation offering the same thing). Furthermore, GICv4.1
>> isn't as such visible to the guest itself (it only sees a GICv3).
> 
> By the way, I have just downloaded the latest GIC spec from the ARM
> portal and I still do not find the GICD_CTLR_ENABLE_G1A,
> GICD_CTLR_nASSGIreq and GICD_TYPER2_nASSGIcap. Do I miss something?

The latest spec still is the old one. There is a *confidential* erratum
to the spec that adds the missing bits, but nothing public.

You unfortunately will have to take my word for it.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
