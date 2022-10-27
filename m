Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8ACFA3740
	for <kvmarm@archiver.kernel.org>; Thu, 27 Oct 2022 18:53:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7798C40B8F;
	Thu, 27 Oct 2022 14:53:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FNC+iyAouhXf; Thu, 27 Oct 2022 14:53:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74A8240BA3;
	Thu, 27 Oct 2022 14:53:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46A8E40B75
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 14:53:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VnWrQtvBF22G for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 14:52:59 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4672040797
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 14:52:59 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0941F6245E;
 Thu, 27 Oct 2022 18:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66568C433D6;
 Thu, 27 Oct 2022 18:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666896777;
 bh=cE0DsxHVn8E3WSzZRpP4LLIDtwwk7/ADnshfq6mGRvk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=kBkhQYh+SUZhFRwlDyQceHZjgXEG22RW+xi2baopYZjGNtcrGWBmbA0OnwrUcxDxf
 1AbLkvJG5RzXjYSSSnntiRK7Bac2YMrk6Ci3v5ywlwwewQnwbxRWvLOUqK/NOQrHqD
 RA32Rb7rof30eixL/BzOco41FkMrlEzR5wDNtoH/nVmdknb36avKFisqC4s3Wx+1eg
 koJBef8N589Hrw4zo7igWctkRMn3n5ZSvUJT43RcVsWynwUORw6GUoPXFFKVbyCUYs
 ImSsbs9ynpqpN564sc/e9/vDRCAzE2NSplLCk60owpp6bvenCwx3hdfVgq55SAKGD2
 O+X7ry5BqKu9A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oo7zr-0024QE-1F;
 Thu, 27 Oct 2022 19:52:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v1] KVM: arm64: Fix bad dereference on MTE-enabled systems.
Date: Thu, 27 Oct 2022 19:52:49 +0100
Message-Id: <166689668290.1967996.11076695324695573284.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221027120945.29679-1-ryan.roberts@arm.com>
References: <20221027120945.29679-1-ryan.roberts@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ryan.roberts@arm.com, steven.price@arm.com,
 catalin.marinas@arm.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Thu, 27 Oct 2022 13:09:45 +0100, Ryan Roberts wrote:
> enter_exception64() performs an MTE check, which involves dereferencing
> vcpu->kvm. While vcpu has already been fixed up for hyp va, kvm is still
> a kern va pointer.
> 
> Fix this by first converting kvm to a hyp va pointer. If the system does
> not support MTE, the dereference is avoided in the first place.
> 
> [...]

Applied to fixes with minor commit message fixes, thanks!

[1/1] KVM: arm64: Fix bad dereference on MTE-enabled systems.
      commit: b6bcdc9f6b8321e4471ff45413b6410e16762a8d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
