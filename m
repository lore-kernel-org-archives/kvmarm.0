Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53CAC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 13:53:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FB8223BAB
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 13:53:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FB8223BAB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4424F4B1CE;
	Thu, 10 Dec 2020 08:53:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cJYE6y-zDuH1; Thu, 10 Dec 2020 08:53:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EECC34B1CA;
	Thu, 10 Dec 2020 08:53:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84A714B1A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 08:53:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rmm8i4aLsUZl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 08:53:48 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 612B74B17E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 08:53:48 -0500 (EST)
Date: Thu, 10 Dec 2020 13:53:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1607608427;
 bh=NjrQ4FJF5266Z90UJ72u1Wg6hCMf64J2BYn3ruDlCmM=;
 h=From:To:Cc:Subject:References:In-Reply-To:From;
 b=OEPHAVOhWkIGpVAHib6eInZKs+4RcuFzg6tl2dG3haMd7QNgF9yOHoMF7ye0hqlQ9
 omcJKaLkBYMJASEvcgVM0BV6YOzfh7esaPQiE6sILqzQSK/g44y8XrjQHwpfCXYrmH
 EuEU34T3U6N4Ww+DQ4Se5XmyU+DcdKaLZT9ebxOdI+oc+YAX6h5NXLfeR12zrU+roq
 qdVBWzVj9hyBfCa4ChpHMVk/R6OnHepOX5D3r9iGoySk/z4RpRwRxAefIrJMMCT3fc
 /6EnxEqfvpMpArhXZg6MGSo/acLDk5cDdE6kMPyW9rhg5cN7lhMxV+XIQLS5ZjlqCo
 iOKArx0T+z5JQ==
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Expose CSV3 to guests on running on
 Meltdown-safe HW
Message-ID: <20201210135341.GA10255@willie-the-truck>
References: <20201204183709.784533-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201204183709.784533-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, David Brazdil <dbarzdil@google.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Dec 04, 2020 at 06:37:07PM +0000, Marc Zyngier wrote:
> Will recently pointed out that when running on big-little systems that
> are known not to be vulnerable to Metldown, guests are not presented
> with the CSV3 property if the physical HW include a core that doesn't
> have CSV3, despite being known to be safe (it is on the kpti_safe_list).
> 
> Since this is valuable information that can be cheaply given to the
> guest, let's just do that. The scheme is the same as what we do for
> CSV2, allowing userspace to change the default setting if this doesn't
> advertise a safer setting than what the kernel thinks it is.
> 
> * From v1:
>   - Fix the clearing of ID_AA64PFR0_EL1.CSV3 on update from userspace
>   - Actually store the userspace value
> 
> Marc Zyngier (2):
>   arm64: Make the Meltdown mitigation state available
>   KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV3=1 if the CPUs are
>     Meltdown-safe

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
