Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3D7C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Apr 2022 13:21:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F07BC4B188;
	Wed,  6 Apr 2022 09:21:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xX8spjHU-cdr; Wed,  6 Apr 2022 09:21:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 774274B1A2;
	Wed,  6 Apr 2022 09:21:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C14344B188
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 09:21:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qpwN9PYco09J for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 09:21:46 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 76C2C4B176
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 09:21:46 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D9E3CB823BB;
 Wed,  6 Apr 2022 13:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891FBC385A3;
 Wed,  6 Apr 2022 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649251303;
 bh=9rQTc7L8tJ6xiJFNxneGRixTQCGHIv1jdjoD81C2PjI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Iz4AtakFBVCp2wk5WjxYcAYLOVYdFdadBlt82bPLsjO8d8fW1dPCigPmxTIgQQng9
 zsOlCy4db81JAJlprLuJVqZP6CjsxTekv9K3Js3jUGBf6cRX1DWFm5NXZ0SjidccOX
 0qdW35FVH9/JpfG8hsaKOnOpxaWO9RXI+2+OEOpu82L1rnCD478Ya3JvRVG8gA9z0x
 W8lKty2tqUDBc9VEcL9If31vrbJ3W2nYhM46/PFRDVLd9HgFkHybilRrIk0ntInAjx
 xqkQF5EC+cED7luy5reO2x/6N2SSEENlX5xBqHYhvNjzzEecLVtqbFV3Z8eMsbs30y
 ahMtGxF/iVJ1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nc5bQ-002Ae1-Gm; Wed, 06 Apr 2022 14:21:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: Reiji Watanabe <reijiw@google.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v6 0/2] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
Date: Wed,  6 Apr 2022 14:21:33 +0100
Message-Id: <164925121901.3715988.2577538688364822137.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329031924.619453-1-reijiw@google.com>
References: <20220329031924.619453-1-reijiw@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: reijiw@google.com, kvmarm@lists.cs.columbia.edu,
 drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 alexandru.elisei@arm.com, ricarkol@google.com, pshier@google.com,
 rananta@google.com, jingzhangos@google.com, suzuki.poulose@arm.com,
 will@kernel.org, oupton@google.com, james.morse@arm.com, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Mon, 28 Mar 2022 20:19:22 -0700, Reiji Watanabe wrote:
> KVM allows userspace to configure either all EL1 32bit or 64bit vCPUs
> for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
> if the vcpu's register width is consistent with all other vCPUs'.
> Since the checking is done even against vCPUs that are not initialized
> (KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
> are erroneously treated as 64bit vCPU, which causes the function to
> incorrectly detect a mixed-width VM.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: mixed-width check should be skipped for uninitialized vCPUs
      commit: 26bf74bd9f6ff0f1545b4f0c92a37c232d076014
[2/2] KVM: arm64: selftests: Introduce vcpu_width_config
      commit: 2f5d27e6cf14efe652748bad89ee529ed5a5d577

Note that I have somewhat tweaked the first patch to my own liking.

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
