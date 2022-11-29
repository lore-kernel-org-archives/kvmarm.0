Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD8AC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 29 Nov 2022 17:31:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05D2440E1A;
	Tue, 29 Nov 2022 12:31:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jVv6qCRkc7kB; Tue, 29 Nov 2022 12:31:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA1F743C58;
	Tue, 29 Nov 2022 12:31:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5D2D40E62
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 12:31:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BZ+8EHcmN-3w for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2022 12:31:51 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E3EF40E1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 12:31:51 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E67F16187E;
 Tue, 29 Nov 2022 17:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4E1C433C1;
 Tue, 29 Nov 2022 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1669743109;
 bh=UVinZvTim66u4bD8bc5xOZyCcQ1X8BETh6hP7fGDBAU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=jSGqNuRZSJi2DZAT5I2TcjbMZE/x9XmLA+z8A9P8IGRIuSYlKw9zJyOenjacAXnLz
 tNBq75DZ1OC1Zy+G0JU2WKeBmQszUHVCZ5N6LqVK+DnWhXcE2i0kZJdmxaOLClZJe3
 tYENqLz22d1Qx6iif/UjCs+BXDz6hvSDkETK3iARdvMHYpMC7/VHS4kU34eJgt+ooU
 XeIC+ksbjEbmiZu8yjRwjy5NjyIWF19/uxwx24oPX1+McinLXUJAkY82saEXxncT/i
 xNhEBocnLfBppcWb0dTPBa0fHKh7GuQcWYPDY5HDG0R3jKwLnWWUZRL4EeIYJ0Qebi
 YRSkSoXm6Lpcw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1p04SR-009PeW-37;
 Tue, 29 Nov 2022 17:31:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Enable access_tracking_perf_test
 for arm64
Date: Tue, 29 Nov 2022 17:31:44 +0000
Message-Id: <166974309671.1909695.14457318687237410207.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118211503.4049023-1-oliver.upton@linux.dev>
References: <20221118211503.4049023-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, james.morse@arm.com,
 oliver.upton@linux.dev, seanjc@google.com, gshan@redhat.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Fri, 18 Nov 2022 21:15:01 +0000, Oliver Upton wrote:
> Small series to add support for arm64 to access_tracking_perf_test and
> correct a couple bugs along the way.
> 
> Tested on Ampere Altra w/ all supported guest modes.
> 
> v1 -> v2:
>  - Have perf_test_util indicate when to stop vCPU threads (Sean)
>  - Collect Gavin's R-b on the second patch. I left off Gavin's R-b on
>    the first patch as it was retooled.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: selftests: Have perf_test_util signal when to stop vCPUs
      commit: 9ec1eb1bcceec735fb3c9255cdcdbcc2acf860a0
[2/2] KVM: selftests: Build access_tracking_perf_test for arm64
      commit: 4568180411e0fb5613e217da1c693466e39b9c27

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
