Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991FBC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Mar 2022 13:57:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0189E49F02;
	Mon, 21 Mar 2022 09:57:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rMFhsmqgU0Nt; Mon, 21 Mar 2022 09:57:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D264E49F2C;
	Mon, 21 Mar 2022 09:57:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC40249F1D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 09:57:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id phdWvnTVZTxo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 09:57:12 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DB1A49F02
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 09:57:12 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 1B26BB81674;
 Mon, 21 Mar 2022 13:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F7DC340F2;
 Mon, 21 Mar 2022 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1647871029;
 bh=s3RG2lskzYIHCBj0QpKrfumQWmHB+RikR9MMTPHjm84=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=arZmPv1RKvDBxBtQO6qflcWzhZzHazoWt1I2sDMWzf9nGEgUjXIqXmkKNpDN1C44x
 FTvGihIaTZgquWdz8xHDIDMY/UVtEeNTr3/OhPBYLjq1oC1P4ZbeKqBxbSD/BfKEb3
 EMqa5Z9et4GjNepvi8VgS4hiDlGzFcXt++rOp9K/37qnFxycJwpLJnraNBXCXBvCX8
 StI0Zwfe2mknjdC91BMMiC1HTVPUwx78dThXcfgejQuenTHsFJN2uV0dOoHU55zdxn
 ytQF8v/WfgXCVrKYgsdi1QutqIQD/qRC6zGvpyF6gXVVeHaAJB6CXzaAAlcAERLPZn
 CmRldtuCN95LA==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH kvmtool v11 0/3] aarch64: Add stolen time support
Date: Mon, 21 Mar 2022 13:57:02 +0000
Message-Id: <164786978933.4050895.3560918928068714544.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220313161949.3565171-1-sebastianene@google.com>
References: <20220313161949.3565171-1-sebastianene@google.com>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, catalin.marinas@arm.com, maz@kernel.org,
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

On Sun, 13 Mar 2022 16:19:47 +0000, Sebastian Ene wrote:
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
> [...]

Applied to kvmtool (master), thanks!

[1/3] aarch64: Populate the vCPU struct before target->init()
      https://git.kernel.org/will/kvmtool/c/ff6958200c4b
[2/3] aarch64: Add stolen time support
      https://git.kernel.org/will/kvmtool/c/7d4671e5d372
[3/3] Add --no-pvtime command line argument
      https://git.kernel.org/will/kvmtool/c/1b76b6e1f84a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
