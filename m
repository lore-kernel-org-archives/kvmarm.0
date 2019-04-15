Return-Path: <SRS0=r5x+=SR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A201AC10F12
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 14:04:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E7F620880
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 14:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E7F620880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04B7A4A4DB;
	Mon, 15 Apr 2019 10:04:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GABFu7qvCGfJ; Mon, 15 Apr 2019 10:04:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 717984A4D3;
	Mon, 15 Apr 2019 10:04:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCF774A4C3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 10:04:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w0TWLQvfxuV0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 10:04:23 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FFE84A486
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 10:04:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1C19374;
 Mon, 15 Apr 2019 07:04:22 -0700 (PDT)
Received: from [10.1.196.69] (e112269-lin.cambridge.arm.com [10.1.196.69])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 690663F68F;
 Mon, 15 Apr 2019 07:04:21 -0700 (PDT)
Subject: Re: [PATCH v5 2/3] KVM: arm/arm64: Add save/restore support for
 firmware workaround state
To: Andre Przywara <andre.przywara@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>
References: <20190415111542.119788-1-andre.przywara@arm.com>
 <20190415111542.119788-3-andre.przywara@arm.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <82eb4d1f-004a-8621-7efc-0545fded88ac@arm.com>
Date: Mon, 15 Apr 2019 15:04:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415111542.119788-3-andre.przywara@arm.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
 kvmarm@lists.cs.columbia.edu, Dave Martin <dave.martin@arm.com>,
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
Message-ID: <20190415140420.PX9s5f4M0602Tsw-y0IgDffjPFGLYEgo2hrOaN1aYGw@z>

On 15/04/2019 12:15, Andre Przywara wrote:
> KVM implements the firmware interface for mitigating cache speculation
> vulnerabilities. Guests may use this interface to ensure mitigation is
> active.
> If we want to migrate such a guest to a host with a different support
> level for those workarounds, migration might need to fail, to ensure that
> critical guests don't loose their protection.
> 
> Introduce a way for userland to save and restore the workarounds state.
> On restoring we do checks that make sure we don't downgrade our
> mitigation level.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Steven Price <steven.price@arm.com>

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
