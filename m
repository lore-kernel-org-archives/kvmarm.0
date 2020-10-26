Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB35C388F9
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 08:40:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54ED8223B0
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 08:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="be0fL6kl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54ED8223B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B9C24B4A3;
	Mon, 26 Oct 2020 04:40:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1221Q4fdsGmf; Mon, 26 Oct 2020 04:40:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BADB4B47E;
	Mon, 26 Oct 2020 04:40:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCAC44B47E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 04:40:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n7Jc6LN6XrqG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 04:40:48 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4D894B465
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 04:40:48 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 936BF223B0;
 Mon, 26 Oct 2020 08:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603701647;
 bh=YlW8Xfo2Ltbkr7uYAZDLILOKVIUBJu0dIhiivmcrF5g=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=be0fL6klQ1i17YKh1rgUP8AO06fLg+wyrobdNWQFnYBzf1MJhuHWIxISVF0jXHp+H
 NBj6ex6BF+/2ERzeyDvxH7N4DB4bODRJNn2yGlS/BMnCWRK8rvX6aVcdY1q1NXX4q8
 /LPJpQgHD9EKyvuAp+fVcwh60r+yk88e0GjRFrjQ=
Date: Mon, 26 Oct 2020 08:40:43 +0000
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Check if 52-bits PA is enabled
Message-ID: <20201026084042.GC23739@willie-the-truck>
References: <20201025002739.5804-1-gshan@redhat.com>
 <20201025002739.5804-2-gshan@redhat.com>
 <871rhmpr92.wl-maz@kernel.org>
 <333451bd-4730-4ebb-f76c-28fa5d0e1f7d@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <333451bd-4730-4ebb-f76c-28fa5d0e1f7d@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
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

On Mon, Oct 26, 2020 at 09:23:31AM +1100, Gavin Shan wrote:
> On 10/25/20 8:52 PM, Marc Zyngier wrote:
> > On Sun, 25 Oct 2020 01:27:37 +0100,
> > Gavin Shan <gshan@redhat.com> wrote:
> > > 
> > > The 52-bits physical address is disabled until CONFIG_ARM64_PA_BITS_52
> > > is chosen. This uses option for that check, to avoid the unconditional
> > > check on PAGE_SHIFT in the hot path and thus save some CPU cycles.
> > 
> > PAGE_SHIFT is known at compile time, and this code is dropped by the
> > compiler if the selected page size is not 64K. This patch really only
> > makes the code slightly less readable and the "CPU cycles" argument
> > doesn't hold at all.
> > 
> > So what are you trying to solve exactly?
> > 
> 
> There are two points covered by the patch: (1) The 52-bits physical address
> is visible only when CONFIG_ARM64_PA_BITS_52 is enabled in arch/arm64 code.
> The code looks consistent with this option used here. (2) I had the assumption
> that gcc doesn't optimize the code and PAGE_SHIFT is always checked in order
> to get higher 4 physical address bits, but you said gcc should optimize the
> code accordingly. However, it would be still nice to make the code explicit.

I don't know: adding #ifdef CONFIG_ lines just reduces the coverage we
get from CI, so unless the code is actually causing a problem then I'd be
inclined to leave it as-is.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
