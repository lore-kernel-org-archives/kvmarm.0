Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9466C2BB86
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:43:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8913A2084D
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:43:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8913A2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 336014B1AB;
	Fri, 10 Apr 2020 03:43:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mp2BLOFFPfZ1; Fri, 10 Apr 2020 03:43:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC28B4B1A7;
	Fri, 10 Apr 2020 03:43:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6972F4B0EA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 23:34:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tb4PgsHAuA-S for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2020 23:34:55 -0400 (EDT)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB3BD4B0E2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 23:34:54 -0400 (EDT)
IronPort-SDR: OyzC3ZDYmRLinwdlT9BR2NbjXxGlkT2+txJvSeEPl/U/MH3GgQ+ZerFKU6drZdArelumBVtHXw
 mC7DOgmUScIQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 09 Apr 2020 20:34:53 -0700
IronPort-SDR: ME4wJefU9c08y8O4N8n30+KSe8YidS+RNWxf5yHPKnSdkR3tDUbFF9uTgBtYzKB3AFaPi9pdH7
 Uw/jZvWUlbGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,364,1580803200"; d="scan'208";a="270288714"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.236])
 ([10.238.4.236])
 by orsmga002.jf.intel.com with ESMTP; 09 Apr 2020 20:34:52 -0700
Subject: Re: Contribution to KVM.
To: Javier Romero <xavinux@gmail.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
From: "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
Date: Fri, 10 Apr 2020 11:34:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
Content-Language: en-US
X-Mailman-Approved-At: Fri, 10 Apr 2020 03:43:52 -0400
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: like.xu@intel.com
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

On 2020/4/10 5:29, Javier Romero wrote:
> Hello,
>
>   My name is Javier, live in Argentina and work as a cloud engineer.
>
> Have been working with Linux servers for the last 10 years in an
> Internet Service Provider and I'm interested in contributing to KVM
Welcome, I'm a newbie as well.
> maybe with testing as a start point.
You may try the http://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
and tools/testing/selftests/kvm in the kernel tree.
>
> If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at disposal.
If you test KVM on Intel platforms, you will definitely get support from me :D.

Thanks,
Like Xu
>
> Thanks for your kind attention.
>
> Best Regards,
>
>
>
> Javier Romero

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
