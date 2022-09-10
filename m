Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56368C6FA82
	for <kvmarm@archiver.kernel.org>; Sat, 10 Sep 2022 13:43:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9BE74BFDB;
	Sat, 10 Sep 2022 09:43:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pm4zGG3+E7mq; Sat, 10 Sep 2022 09:43:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 924414BFC8;
	Sat, 10 Sep 2022 09:43:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A5954BFC4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2022 09:43:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id crH-dGlzWdMm for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Sep 2022 09:43:51 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77B6D4BFC2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2022 09:43:51 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D253660C58;
 Sat, 10 Sep 2022 13:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822F9C433D7;
 Sat, 10 Sep 2022 13:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1662817430;
 bh=tBeZ680+HlTQzJfvNJw3jMyeEy9SyGRGumiy8ZxNN/k=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=LiS4kh2PSCn9bIjpLqYgxZ94APB3ehxWTQ63zQS3IZFPr7hFNjksC7CxzjlTc+OKz
 EJhW8dXiUBv8DWw3dw/VdRI1nH80OT4ng8rQs6frXNYd1UEU9MkLXyy39w7FyOra5R
 is4e2U92PG0p2Z09ZMnFZfMRwxidkThmPfZmBZXa/8ajG72ffFj68ZLAOJ7/8ZOqO8
 GxLuXrw4Tqrxx11p2aCxJ4TLH8KV0EvasS9V15p6SYj9dfrGzEXY1wihuiZeVOkH02
 6BTk+jID4KzMrZYQTP1ciOS3tXt3leBEH+YgUSg5PFr9xf4Ga4c5wqiuAWXOyQERXn
 018CB8DfdL6Mg==
Date: Sat, 10 Sep 2022 14:43:44 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Only set KVM_MODE_PROTECTED if
 is_hyp_mode_available()
Message-ID: <20220910134342.GA959@willie-the-truck>
References: <20220909144552.3000716-1-quic_eberman@quicinc.com>
 <Yxt3wmXYYbWraXrd@arm.com>
 <05057e2a-1a85-69ba-ffcd-584d4090467a@quicinc.com>
 <878rmrr3xw.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <878rmrr3xw.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Elliot Berman <quic_eberman@quicinc.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
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

On Sat, Sep 10, 2022 at 10:09:31AM +0100, Marc Zyngier wrote:
> On Fri, 09 Sep 2022 18:55:18 +0100,
> Elliot Berman <quic_eberman@quicinc.com> wrote:
> > 
> > 
> > 
> > On 9/9/2022 10:28 AM, Catalin Marinas wrote:
> > > On Fri, Sep 09, 2022 at 07:45:52AM -0700, Elliot Berman wrote:
> > >> Do not switch kvm_mode to KVM_MODE_PROTECTED if hypervisor mode is not
> > >> available. This prevents "Protected KVM" cpu capability being reported
> > >> when Linux is booting in EL1 and would not have KVM enabled.
> > >> 
> > >> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> > >> ---
> > >>   arch/arm64/kvm/arm.c | 4 +++-
> > >>   1 file changed, 3 insertions(+), 1 deletion(-)
> > >> 
> > >> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > >> index 8fe73ee5fa84..861f4b388879 100644
> > >> --- a/arch/arm64/kvm/arm.c
> > >> +++ b/arch/arm64/kvm/arm.c
> > >> @@ -2272,7 +2272,9 @@ static int __init early_kvm_mode_cfg(char *arg)
> > >>   		return -EINVAL;
> > >>     	if (strcmp(arg, "protected") == 0) {
> > >> -		if (!is_kernel_in_hyp_mode())
> > >> +		if (!is_hyp_mode_available())
> > >> +			kvm_mode = KVM_MODE_DEFAULT;
> > > 
> > > I think kvm_mode is already KVM_MODE_DEFAULT at this point. You may want
> > > to print a warning instead.
> > > 
> > 
> > Does it make sense to print warning for kvm-arm.mode=nvhe as well?
> 
> In general, specifying a kvm-arm.mode when no hypervisor mode is
> available should be reported as a warning.

As long as this is pr_warn() rather than WARN() then I agree. Otherwise,
kernels with a kvm-arm.mode hardcoded in CONFIG_CMDLINE (e.g. Android's
GKI) will make for noisy guests.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
