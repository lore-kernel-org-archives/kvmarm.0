Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18E0C4360C
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 08:33:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F1652075D
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 08:33:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F1652075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF4A94A720;
	Fri, 27 Sep 2019 04:33:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 16IvWDlakFJH; Fri, 27 Sep 2019 04:33:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E04344A726;
	Fri, 27 Sep 2019 04:33:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B07064A720
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 04:33:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VeEj602DxhXk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 04:33:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A87ED4A71A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 04:33:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5F97337;
 Fri, 27 Sep 2019 01:33:51 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C66FD3F739;
 Fri, 27 Sep 2019 01:33:50 -0700 (PDT)
Subject: Re: [PATCH 1/5] arm64: Add ARM64_WORKAROUND_1319367 for all A57 and
 A72 versions
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20190925111941.88103-1-maz@kernel.org>
 <20190925111941.88103-2-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <403cb5f2-b55a-0e5e-f228-954b3b746334@arm.com>
Date: Fri, 27 Sep 2019 09:33:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190925111941.88103-2-maz@kernel.org>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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



On 25/09/2019 12:19, Marc Zyngier wrote:
> Rework the EL2 vector hardening that is only selected for A57 and A72
> so that the table can also be used for ARM64_WORKAROUND_1319367.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
