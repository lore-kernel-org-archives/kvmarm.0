Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60010C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 10:40:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA22361351
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 10:40:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CA22361351
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ED954B099;
	Wed, 22 Sep 2021 06:40:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5N-EjwVCVLOA; Wed, 22 Sep 2021 06:40:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18D2A4A3BF;
	Wed, 22 Sep 2021 06:40:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 909A64A173
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 06:39:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oGxu056c5JEC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 06:39:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4104A00B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 06:39:57 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BAF1311B3;
 Wed, 22 Sep 2021 03:39:56 -0700 (PDT)
Received: from [10.57.95.67] (unknown [10.57.95.67])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F9063F719;
 Wed, 22 Sep 2021 03:39:55 -0700 (PDT)
Subject: Re: [RFC PATCH v4 01/39] KVM: arm64: Make lock_all_vcpus() available
 to the rest of KVM
To: Alexandru Elisei <alexandru.elisei@arm.com>, maz@kernel.org,
 james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, will@kernel.org, linux-kernel@vger.kernel.org
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
 <20210825161815.266051-2-alexandru.elisei@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <ed657df4-7242-2c77-cfaf-b0dc1eb5c210@arm.com>
Date: Wed, 22 Sep 2021 11:39:54 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210825161815.266051-2-alexandru.elisei@arm.com>
Content-Language: en-GB
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

On 25/08/2021 17:17, Alexandru Elisei wrote:
> The VGIC code uses the lock_all_vcpus() function to make sure no VCPUs are
> run while it fiddles with the global VGIC state. Move the declaration of
> lock_all_vcpus() and the corresponding unlock function into asm/kvm_host.h
> where it can be reused by other parts of KVM/arm64 and rename the functions
> to kvm_{lock,unlock}_all_vcpus() to make them more generic.
> 
> Because the scope of the code potentially using the functions has
> increased, add a lockdep check that the kvm->lock is held by the caller.
> Holding the lock is necessary because otherwise userspace would be able to
> create new VCPUs and run them while the existing VCPUs are locked.
> 
> No functional change intended.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>


LGTM,

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
