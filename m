Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0037FC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Mar 2022 14:00:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C73449F56;
	Mon, 21 Mar 2022 10:00:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id duszWS7PcsQv; Mon, 21 Mar 2022 10:00:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E4549F2C;
	Mon, 21 Mar 2022 10:00:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F4F249EFB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 10:00:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N4-wLlCa6MHN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 10:00:47 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E98E649ECF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 10:00:46 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 623776126A;
 Mon, 21 Mar 2022 14:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F303C340F2;
 Mon, 21 Mar 2022 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1647871244;
 bh=z+fIyMiBBd9j4jMIRyKXadB39SI8/RcOLqnYSNbAIGc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=T3q5wPbp1TfmqF7yEQSWdjhu2naNVrifB/ledyvPrgszgZWORR1+s/z2BNdiP3V/c
 zL6TTcaywFbKxM4xwld5fwGAM4KvbcXTOzjjIWTuv/spEiHo1web87LIwKtqX+tBmZ
 AAIeIHGK0X1B8rQW8UXgw/u4q7imvYZrEE88zi/xOLJfguo7zNQC7jIa5DHXmB6sRJ
 WFcz2XwoB2FzOIzlmstmr1AG2odE8z4Jv/r191ulrAsi5dwEaZnCuHasx0CXCcUMX4
 sGjP+64noaNkDBHyLHNjuHH+yJTOy3jlyeHNXX8I8TmUVzAjKNL6MO1r+//amR2IUG
 1h1KpNiSmn+NQ==
Date: Mon, 21 Mar 2022 14:00:39 +0000
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH kvmtool v11 0/3] aarch64: Add stolen time support
Message-ID: <20220321140039.GA11036@willie-the-truck>
References: <20220313161949.3565171-1-sebastianene@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220313161949.3565171-1-sebastianene@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Sebastian,

On Sun, Mar 13, 2022 at 04:19:47PM +0000, Sebastian Ene wrote:
> This series adds support for stolen time functionality.
> 
> Patch #1 moves the vCPU structure initialisation before the target->init()
> call to allow early access to the kvm structure from the vCPU
> during target->init().
> 
> Patch #2 modifies the memory layout in arm-common/kvm-arch.h and adds a
> new MMIO device PVTIME after the RTC region. A new flag is added in
> kvm-config.h that will be used to control [enable/disable] the pvtime
> functionality. Stolen time is enabled by default when the host
> supports KVM_CAP_STEAL_TIME.
> 
> Patch #3 adds a new command line argument to disable the stolen time
> functionality(by default is enabled).
> 
> Changelog since v10:
>  - set the return value to -errno on failed exit path from
>    'kvm_cpu__setup_pvtime' 

Thanks. I've applied this, but I think it would be worth a patch on top
to make the new '--no-pvtime' option part of the 'arch-specific' options
rather than a generic option given that this is only implemented for
arm64 at the moment.

Please could you send an extra patch to move the option? You can look at
how we deal with the other arm64-specific options in
arm/aarch64/include/kvm/kvm-config-arch.h for inspiration.

Cheers,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
