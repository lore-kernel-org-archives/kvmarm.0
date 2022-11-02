Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FFF8C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 01:27:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 135DC4BA97;
	Tue,  1 Nov 2022 21:27:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lH8jyskwAGz3; Tue,  1 Nov 2022 21:27:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4DA24BA85;
	Tue,  1 Nov 2022 21:27:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EAE64BA67
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 21:27:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KslpuPvLWNHi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2022 21:27:02 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 503AD4BA22
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 21:27:02 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 163696179F;
 Wed,  2 Nov 2022 01:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D102C433D6;
 Wed,  2 Nov 2022 01:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1667352420;
 bh=k4P0hoQfhSxNC7Iu4COmXWBjx1cpoaAFcD65LMcpkR8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=T2M2TndJir1D5natjoAn4VcJHKb3P9ZFYPWMeYUb5+Ccl4H74Pkb0dalFlAjak90/
 oDZeguPtOpVNFbszteq6vkIgWIOUAbkLMo2yCepk+PCDc+QnURYzfkVrZn7LWne/BS
 Bkxr+C50csTwGqESMLb9FD/IKD0uOt2998m0aFJc=
Date: Wed, 2 Nov 2022 02:27:52 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 5.10 0/2] arm64: backport two patches to 5.10-stable
Message-ID: <Y2HHmEUEHShi4PMX@kroah.com>
References: <20221031112246.1588-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221031112246.1588-1-yuzenghui@huawei.com>
Cc: sashal@kernel.org, linux-efi@vger.kernel.org, anders.roxell@linaro.org,
 anshuman.khandual@arm.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, Oct 31, 2022 at 07:22:44PM +0800, Zenghui Yu wrote:
> Patch #1 (merged in 5.12-rc3) is required to address the issue
> Anders Roxell reported on the list [1].  Patch #2 (in 5.15-rc1) is
> a follow up.
> 
> [1] https://lore.kernel.org/lkml/20220826120020.GB520@mutt
> 
> Anshuman Khandual (1):
>   arm64/kexec: Test page size support with new TGRAN range values
> 
> James Morse (1):
>   arm64/mm: Fix __enable_mmu() for new TGRAN range values

Both now queued up, thanks.

greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
