Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A33C43464
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 13:38:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 290F020878
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 13:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="eg5/i5Bl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 290F020878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D8094B2DB;
	Fri, 18 Sep 2020 09:38:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ymb+kpGAo+a6; Fri, 18 Sep 2020 09:38:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 566154B29E;
	Fri, 18 Sep 2020 09:38:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DFBE4B29E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 09:38:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IUZDp1dn0OXm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 09:38:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 323654B1BC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 09:38:01 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1F6F320795;
 Fri, 18 Sep 2020 13:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600436280;
 bh=XngjAAUnERWNiIssoK32pkqFZKZzcZgEAB7yYNwM4jk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=eg5/i5BlgYsAk25OvAKp3QMoPQhjz+4/oACfeovvBXJmr7hm/jjLHjhQ/jtVYGnUj
 iT6XA+jIhbgJFwsFRXwZM7xE2nLb3TFqfVKwqPpvpzzfIaufFCpua0ayj/L+KH40h/
 60p5RvmwTysQlLSVpEaQJfxfjWM7ZO8GE+C5Ua5s=
Date: Fri, 18 Sep 2020 14:37:55 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Fix handling of S1PTW
Message-ID: <20200918133755.GD31232@willie-the-truck>
References: <20200915104218.1284701-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200915104218.1284701-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Sep 15, 2020 at 11:42:16AM +0100, Marc Zyngier wrote:
> I recently managed to trigger an interesting failure mode, where a
> guest would be stuck on an instruction abort due to a permission
> fault. Interestingly enough, this IABT had S1PTW set in the ESR,
> indicating that it was trying to *write* to the PT. We fix it by
> adding the execute permission (it's an IABT, after all...), and going
> nowhere fast.
> 
> Note that it can only happen on a system that can perform automatic
> updates of the page table flags.
> 
> This small series fixes the issue by revamping the S1PTW handling in
> the context of execution faults. The first patch fixes the bug, and is
> definitely a stable candidate. The second patch is merely a cleanup,
> which can wait.
> 
> Tested on an A55-based board.
> 
> * From v1:
>   - Rename kvm_vcpu_dabt_iss1tw() to kvm_vcpu_abt_iss1tw()
>   - Don't overload kvm_vcpu_trap_is_iabt()
>   - Introduce kvm_vcpu_trap_is_exec_fault()

For both patches:

Reviewed-by: Will Deacon <will@kernel.org>

Cheers,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
