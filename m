Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00CFC433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 13:39:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3099F64F42
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 13:39:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3099F64F42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6F3D4B622;
	Thu,  4 Mar 2021 08:39:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bppQ7jp9pcQa; Thu,  4 Mar 2021 08:39:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB1E84B523;
	Thu,  4 Mar 2021 08:39:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78C354B43F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 08:39:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iyC3Qc+zPS0Z for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 08:39:09 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A2DE4B3CC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 08:39:09 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FF4C64F2C;
 Thu,  4 Mar 2021 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614865147;
 bh=if92YC9vio4Wnb8KGrOYHJJSJjqsc9o370GPKUYZUkU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Hmsy7aJYf1pooezRgKSoYG7UiOpJ4DvBb6h3ohC4bVI3IEpgJT1OKDGPBKsu/v5EF
 nYNyd79i7vP6zNnD/A5Bq9F4TMnZWMBajt8XGtq0y5xk7q1xZrbJxQpQX1SUL/O3E2
 0ZyITH9ie9AkxQvTvDw2E8z+eigm7fjJkEV5OyTs0jL5LQMLWZfHCJ42YyHTpFINmf
 C0Y6g98QkSFpFISLc8sbik2kbTKbuwMDxY+4X8x2n8lCYEJMInevvWAFwmMgaJDhI0
 kN1KpXtEtWJKVJBwCtSil93ZkrFeNH/HDJ0cjlcpaeOtiRH6bSCbjD7UNSa4ZMWueU
 GO2ECp/5S3Hng==
Date: Thu, 4 Mar 2021 13:39:01 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 04/32] KVM: arm64: Initialize kvm_nvhe_init_params early
Message-ID: <20210304133900.GB21229@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-5-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-5-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 02, 2021 at 02:59:34PM +0000, Quentin Perret wrote:
> Move the initialization of kvm_nvhe_init_params in a dedicated function
> that is run early, and only once during KVM init, rather than every time
> the KVM vectors are set and reset.
> 
> This also opens the opportunity for the hypervisor to change the init
> structs during boot, hence simplifying the replacement of host-provided
> page-table by the one the hypervisor will create for itself.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/arm.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
