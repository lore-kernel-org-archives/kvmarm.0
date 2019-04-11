Return-Path: <SRS0=Fx/F=SN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BCCC10F14
	for <kvmarm@archiver.kernel.org>; Thu, 11 Apr 2019 17:19:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A82E020693
	for <kvmarm@archiver.kernel.org>; Thu, 11 Apr 2019 17:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A82E020693
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E49444A485;
	Thu, 11 Apr 2019 13:18:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vWr091dvj4OV; Thu, 11 Apr 2019 13:18:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E204A48C;
	Thu, 11 Apr 2019 13:18:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F904A484
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Apr 2019 13:18:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Kn7Wmzv8+qT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Apr 2019 13:18:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 774064A46F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Apr 2019 13:18:53 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BAE6F374;
 Thu, 11 Apr 2019 10:18:52 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A4843F59C;
 Thu, 11 Apr 2019 10:18:50 -0700 (PDT)
Date: Thu, 11 Apr 2019 18:18:48 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v13 8/8] arm64: docs: document perf event attributes
Message-ID: <20190411171848.GG29081@fuggles.cambridge.arm.com>
References: <20190409192217.23459-1-andrew.murray@arm.com>
 <20190409192217.23459-9-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190409192217.23459-9-andrew.murray@arm.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190411171848.wWNYNdmQCHfiBY4Y-ILu5Sqg4uUuZl8ip2o-rrPF1xE@z>

On Tue, Apr 09, 2019 at 08:22:17PM +0100, Andrew Murray wrote:
> The interaction between the exclude_{host,guest} flags,
> exclude_{user,kernel,hv} flags and presence of VHE can result in
> different exception levels being filtered by the ARMv8 PMU. As this
> can be confusing let's document how they work on arm64.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  Documentation/arm64/perf.txt | 85 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
>  create mode 100644 Documentation/arm64/perf.txt

Thanks! Hopefully I no longer have to try (and fail) to figure out these
semantics from the code anymore...

Acked-by: Will Deacon <will.deacon@arm.com>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
