Return-Path: <SRS0=xA+Y=WP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B56DC3A59F
	for <kvmarm@archiver.kernel.org>; Mon, 19 Aug 2019 07:42:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A111C204EC
	for <kvmarm@archiver.kernel.org>; Mon, 19 Aug 2019 07:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hh2QkeT6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A111C204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 477424A5C9;
	Mon, 19 Aug 2019 03:42:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0HeBkA5p28We; Mon, 19 Aug 2019 03:41:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FFB64A59A;
	Mon, 19 Aug 2019 03:41:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F6FC4A59A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Aug 2019 03:41:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id efUJHwOSBEmb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Aug 2019 03:41:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DCEC4A595
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Aug 2019 03:41:56 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BBBD4204EC;
 Mon, 19 Aug 2019 07:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1566200515;
 bh=Bj5VwIQaJmiMtcxgccis/IQVQu1dOXG6ktRvVZc/tNQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Hh2QkeT6BWiakhxFyxX9eSPmMkYOaiZFJPreOEHHkevteQ4TsbD9fioIq6IEE6Kfp
 fviD/EiJU+ZfDV/9mNNGA5506rtM8Djweu+6R4NaTOHrtySt0ioPWxKXyDCAvPmZnh
 Dr+0/2szM3Ji0q9d4xn65pL7CbnjsX3M8gGmrsME=
Date: Mon, 19 Aug 2019 08:41:50 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Allow more than 256 vcpus for
 KVM_IRQ_LINE
Message-ID: <20190819074150.jv3dyyxqazoawgds@willie-the-truck>
References: <20190818140710.23920-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190818140710.23920-1-maz@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Sun, Aug 18, 2019 at 03:07:10PM +0100, Marc Zyngier wrote:
> While parts of the VGIC support a large number of vcpus (we
> bravely allow up to 512), other parts are more limited.
> 
> One of these limits is visible in the KVM_IRQ_LINE ioctl, which
> only allows 256 vcpus to be signalled when using the CPU or PPI
> types. Unfortunately, we've cornered ourselves badly by allocating
> all the bits in the irq field.
> 
> Since the irq_type subfield (8 bit wide) is currently only taking
> the values 0, 1 and 2 (and we have been careful not to allow anything
> else), let's reduce this field to only 4 bits, and allocate the
> remaining 4 bits to a vcpu2_index, which acts as a multiplier:
> 
>   vcpu_id = 256 * vcpu2_index + vcpu_index
> 
> With that, and a new capability (KVM_CAP_ARM_IRQ_LINE_LAYOUT_2)
> allowing this to be discovered, it becomes possible to inject
> PPIs to up to 4096 vcpus. But please just don't.

Do you actually need a new capability for this? Older kernels reject
non-zero upper bits in the 'irq_type', so isn't that enough to probe
for this directly?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
