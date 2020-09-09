Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8753BC433E2
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 15:28:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7714218AC
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 15:28:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7714218AC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 236534B5FE;
	Wed,  9 Sep 2020 11:28:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nK-Xwdel1s3y; Wed,  9 Sep 2020 11:28:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DBB94B2F3;
	Wed,  9 Sep 2020 11:28:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 549C34B5EC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 11:28:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kvoyrvbyihXe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 11:28:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 152AD4B2F3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 11:28:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A68B7101E;
 Wed,  9 Sep 2020 08:28:23 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6757A3F66E;
 Wed,  9 Sep 2020 08:28:22 -0700 (PDT)
Subject: Re: [PATCH v4 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-3-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4ef01cff-71ac-7f3c-2404-af184f5a5cb4@arm.com>
Date: Wed, 9 Sep 2020 16:29:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200907152344.12978-3-will@kernel.org>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

Hi Will,

On 9/7/20 4:23 PM, Will Deacon wrote:
> [..]
> +
> +int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +		     struct kvm_pgtable_walker *walker)
> +{
> +	struct kvm_pgtable_walk_data walk_data = {
> +		.pgt	= pgt,
> +		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
> +		.end	= PAGE_ALIGN(walk_data.addr + size),
> +		.walker	= walker,
> +	};

If the caller wants to walk [0x500, 0x1500), for PAGE_SIZE = 0x1000 (4K), the
function walks the range [0x0, 0x1000). Is that intentional?

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
