Return-Path: <SRS0=lGdW=ZR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA0DC432C0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 10:40:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 183FD20836
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 10:40:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcksZTKC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 183FD20836
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CB7C4A4E8;
	Mon, 25 Nov 2019 05:40:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bEBglHuOpb4x; Mon, 25 Nov 2019 05:40:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DE6B4ACB8;
	Mon, 25 Nov 2019 05:40:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C0704A610
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 05:40:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1GbVzUxZX4sB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Nov 2019 05:40:27 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 416604A4E8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 05:40:27 -0500 (EST)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 57BA020740;
 Mon, 25 Nov 2019 10:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1574678426;
 bh=DaD7HrU1GEmWXei6V5oHBY0lPBCv4J4j7Ett9UjykLI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=YcksZTKCVcS7G348eKxQDvLgtbZCrhEdDS1jUyVkTbbH3TYa7XEVodW+t9oi40lW1
 Uut5cd20ztADFCw1oYUOUvgo8aEqWGLatBdvaJKwHRYTm46KtVW/FvwfEZl+UhaIGb
 XKI+yC0EKPOwvc8dKfT20y3/n4pMlvUt7aoFNWNQ=
Date: Mon, 25 Nov 2019 10:40:21 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] target/arm: Honor HCR_EL2.TID3 trapping requirements
Message-ID: <20191125104021.GA2583@willie-the-truck>
References: <20191123115618.29230-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191123115618.29230-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu
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

On Sat, Nov 23, 2019 at 11:56:18AM +0000, Marc Zyngier wrote:
> HCR_EL2.TID3 mandates that access from EL1 to a long list of id
> registers traps to EL2, and QEMU has so far ignored this requirement.
> 
> This breaks (among other things) KVM guests that have PtrAuth enabled,
> while the hypervisor doesn't want to expose the feature to its guest.
> To achieve this, KVM traps the ID registers (ID_AA64ISAR1_EL1 in this
> case), and masks out the unsupported feature.
> 
> QEMU not honoring the trap request means that the guest observes
> that the feature is present in the HW, starts using it, and dies
> a horrible death when KVM injects an UNDEF, because the feature
> *really* isn't supported.
> 
> Do the right thing by trapping to EL2 if HCR_EL2.TID3 is set.
> 
> Reported-by: Will Deacon <will@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> There is a number of other trap bits missing (TID[0-2], for example),
> but this at least gets a mainline Linux going with cpu=max.
> 
>  target/arm/helper.c | 75 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)

I took your fixes/el2_traps branch for a spin and I no longer get an
unexpected undefined instruction trap on first access to the ptrauth key
registers during context-switch:

Tested-by: Will Deacon <will@kernel.org>

Thanks,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
