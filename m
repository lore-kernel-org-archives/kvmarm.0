Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1B3C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 16:08:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1BC34613ED
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 16:08:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BC34613ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 864F24B43E;
	Thu, 22 Apr 2021 12:08:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kG8ZPkfag2Ba; Thu, 22 Apr 2021 12:08:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6990B4B4DD;
	Thu, 22 Apr 2021 12:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F39764B4D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 12:08:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 28CkJzv2Ae+s for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 12:08:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D79CF4B43E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 12:08:54 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E18061264;
 Thu, 22 Apr 2021 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619107733;
 bh=zCpRP7eiDwk7J8veDKd9XKtUDSNQOgGDnmNG35QL+Fk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=HqN9argi4yFTb1QYEVp71kycCBk55wJ1iYpZTt73yRuzobDNGFlik9GxTjTjG7/Xb
 Zvd3Y65A8V+nZV8ZccvGA90pIUuKjs9yYe/NjA5os5L6bC4B65CylaDUHgQEK3NsSH
 h9b160ntxo+E3k33+Q65MstpCh519ZEhYG7kp31ky2mZPpg7rpBrf9Y2+giUMmbPxY
 jm2RqxlYbzw0pZK77FvGzVkA+NBJnT2FGflH+qWDmEdN/xUpHzCWAVs+Jv1diTMN8u
 UUDSJpdtLU0KkcT4IOHrS542kOBRk2ItZxiwlePPhluX321woy/s91AQck9qftDHkk
 NQbfEoRgsHrUQ==
Date: Thu, 22 Apr 2021 17:08:48 +0100
From: Will Deacon <will@kernel.org>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 00/16] kvm/arm: Align the VMID allocation with the
 arm64 ASID one
Message-ID: <20210422160846.GB2214@willie-the-truck>
References: <20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: jean-philippe@linaro.org, julien@xen.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, linuxarm@huawei.com, catalin.marinas@arm.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Apr 14, 2021 at 12:22:56PM +0100, Shameer Kolothum wrote:
> Hi,
> 
> This is an attempt to revive this series originally posted by
> Julien Grall[1]. The main motive to work on this now is because
> of the requirement to have Pinned KVM VMIDs and the RFC discussion
> for the same basically suggested[2] to have a common/better vmid
> allocator for KVM which this series provides.
>  
> Major Changes from v3:
> 
> -Changes related to Pinned ASID support.
> -Changes to take care KPTI related bits reservation.
> -Dropped support for 32 bit KVM.
> -Rebase to 5.12-rc7
> 
> Individual patches have change history for any major changes
> from v3.
> 
> Tests were performed on a HiSilicon D06 platform and so far not observed
> any regressions.
> 
> For ASID allocation,
> 
> Avg of 10 runs(hackbench -s 512 -l 200 -g 300 -f 25 -P),
> 5.12-rc7: Time:18.8119
> 5.12-rc7+v4: Time: 18.459
> 
> ~1.8% improvement.
> 
> For KVM VMID,
> 
> The measurement was made with maxcpus set to 8 and with the
> number of VMID limited to 4-bit. The test involves running
> concurrently 40 guests with 2 vCPUs. Each guest will then
> execute hackbench 5 times before exiting.
> 
> The performance difference between the current algo and the
> new one are(ag. of 10 runs):
>     - 1.9% less exit from the guest
>     - 0.7% faster
> 
> For complete series, please see,
>  https://github.com/hisilicon/kernel-dev/tree/private-v5.12-rc7-asid-v4
> 
> Please take a look and let me know your feedback.

Although I think aligning the two algorithms makes sense, I'm not completely
sold on the need to abstract all this into a library and whether the
additional indirection is justified.

It would be great to compare this approach with one where portions of the
code are duplicated into a separate VMID allocator. Have you tried that to
see what it looks like? Doesn't need to be a proper patch set, but comparing
the end result might help to evaluate the proposal here.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
