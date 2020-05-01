Return-Path: <SRS0=60hl=6P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA61AC4724C
	for <kvmarm@archiver.kernel.org>; Fri,  1 May 2020 09:11:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53FB120731
	for <kvmarm@archiver.kernel.org>; Fri,  1 May 2020 09:11:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53FB120731
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0E0A4B5A0;
	Fri,  1 May 2020 05:11:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r7aaBPqrORsy; Fri,  1 May 2020 05:11:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B80924B4E8;
	Fri,  1 May 2020 05:11:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFE994B4E8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 May 2020 05:11:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kSgYpQaW90M9 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 May 2020 05:11:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A85E54B3C1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 May 2020 05:11:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AC5A1FB;
 Fri,  1 May 2020 02:11:55 -0700 (PDT)
Received: from [10.37.12.139] (unknown [10.37.12.139])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F1BE3F305;
 Fri,  1 May 2020 02:11:53 -0700 (PDT)
Subject: Re: [PATCH v4 1/4] KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
To: tabba@google.com, maz@kernel.org, catalin.marinas@arm.com,
 julien.thierry.kdev@gmail.com, kvmarm@lists.cs.columbia.edu
References: <20200421131734.141766-1-tabba@google.com>
 <20200421131734.141766-2-tabba@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <a9c69431-5d04-fd5c-9705-b609d326d468@arm.com>
Date: Fri, 1 May 2020 10:16:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200421131734.141766-2-tabba@google.com>
Content-Language: en-US
Cc: will@kernel.org
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

On 04/21/2020 02:17 PM, Fuad Tabba wrote:
> From: Will Deacon <will@kernel.org>
> 
> CONFIG_KVM_ARM_HOST is just a proxy for CONFIG_KVM, so remove it in favour
> of the latter.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>


Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
