Return-Path: <SRS0=vP85=YS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45A2CA9EA0
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 15:50:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7AECA206DD
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 15:50:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AECA206DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5A84A54B;
	Fri, 25 Oct 2019 11:50:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ECefGHp4B5pI; Fri, 25 Oct 2019 11:50:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACE9F4A598;
	Fri, 25 Oct 2019 11:50:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F20AC4A541
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 11:50:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wZde0mzp+le1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Oct 2019 11:50:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFED04A53F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 11:50:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 605AC328;
 Fri, 25 Oct 2019 08:50:41 -0700 (PDT)
Received: from C02TF0J2HF1T.local (C02TF0J2HF1T.cambridge.arm.com
 [10.1.26.186])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 04E5F3F71A;
 Fri, 25 Oct 2019 08:50:38 -0700 (PDT)
Date: Fri, 25 Oct 2019 16:50:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v7 09/10] arm/arm64: Make use of the SMCCC 1.1 wrapper
Message-ID: <20191025155036.GA999@C02TF0J2HF1T.local>
References: <20191021152823.14882-1-steven.price@arm.com>
 <20191021152823.14882-10-steven.price@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191021152823.14882-10-steven.price@arm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Oct 21, 2019 at 04:28:22PM +0100, Steven Price wrote:
> Rather than directly choosing which function to use based on
> psci_ops.conduit, use the new arm_smccc_1_1 wrapper instead.
> 
> In some cases we still need to do some operations based on the
> conduit, but the code duplication is removed.
> 
> No functional change.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
