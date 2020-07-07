Return-Path: <SRS0=EuCB=AS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169A3C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 12:56:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E52520708
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 12:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E52520708
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF1B4B114;
	Tue,  7 Jul 2020 08:56:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yPFS9RiuwAOW; Tue,  7 Jul 2020 08:56:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC1514B11E;
	Tue,  7 Jul 2020 08:56:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4294B115
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 08:56:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xwi6ipx1WBUA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2020 08:56:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D17A4B114
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 08:56:50 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17A1FC0A;
 Tue,  7 Jul 2020 05:56:49 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E67833F71E;
 Tue,  7 Jul 2020 05:56:46 -0700 (PDT)
Subject: Re: [PATCH v3 07/17] KVM: arm64: hyp: Use ctxt_sys_reg/__vcpu_sys_reg
 instead of raw sys_regs access
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20200706125425.1671020-1-maz@kernel.org>
 <20200706125425.1671020-8-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1f97200e-7a0a-aae6-637b-db84481abfb9@arm.com>
Date: Tue, 7 Jul 2020 13:57:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706125425.1671020-8-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>, Will Deacon <will@kernel.org>
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

Hi,

On 7/6/20 1:54 PM, Marc Zyngier wrote:
> Switch the hypervisor code to using ctxt_sys_reg/__vcpu_sys_reg instead
> of raw sys_regs accesses. No intended functionnal change.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h          |   2 +-
>  arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |   4 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h    |   7 +-
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 110 ++++++++++-----------
>  arch/arm64/kvm/hyp/nvhe/switch.c           |   4 +-
>  5 files changed, 62 insertions(+), 65 deletions(-)

Looks fine to me, checked that the correct function is used (either
__vcpu_sys_reg, or ctxt_sys_reg), and that the registers names match. Also did a
compile test to make extra sure I didn't miss anything:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
