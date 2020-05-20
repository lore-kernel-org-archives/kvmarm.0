Return-Path: <SRS0=/uKA=7C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33A7C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 20 May 2020 17:54:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F9AF207F9
	for <kvmarm@archiver.kernel.org>; Wed, 20 May 2020 17:54:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFq5+gFi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F9AF207F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17C8E4B182;
	Wed, 20 May 2020 13:54:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XRvsabU11Zj7; Wed, 20 May 2020 13:54:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 094354B15F;
	Wed, 20 May 2020 13:54:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AF684B158
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 May 2020 13:54:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lpp57HORcUGc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 May 2020 13:54:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A253A4B15E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 May 2020 13:54:46 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AD330207D3;
 Wed, 20 May 2020 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1589997286;
 bh=LwxTBNwVwq8v+Z3EBK8Zb+aYAe0AVV8dq4zcV/fvDC8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=OFq5+gFik+r6kGeqmyDWMKqEgZalTs7c4tPsNNhQaX/MPA8BMIV672M3qkbbA9ZDQ
 27uhRAS9YPmjakvM6KuqrfY2I4LD9GHc/miBeCKwQtsFFp7gOUwchYkOUzmuSE6foo
 tpr7SsjsgdfdXkm0DB9u1TBpd5zg/WWX5pPxmrwI=
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3] arm64/cpufeature: Validate hypervisor capabilities
 during CPU hotplug
Date: Wed, 20 May 2020 18:54:37 +0100
Message-Id: <158998676494.231372.15074477766045633803.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1589248647-22925-1-git-send-email-anshuman.khandual@arm.com>
References: <1589248647-22925-1-git-send-email-anshuman.khandual@arm.com>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
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

On Tue, 12 May 2020 07:27:27 +0530, Anshuman Khandual wrote:
> This validates hypervisor capabilities like VMID width, IPA range for any
> hot plug CPU against system finalized values. KVM's view of the IPA space
> is used while allowing a given CPU to come up. While here, it factors out
> get_vmid_bits() for general use.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-kernel@vger.kernel.org

Applied to arm64 (for-next/cpufeature), thanks!

[1/1] arm64/cpufeature: Validate hypervisor capabilities during CPU hotplug
      https://git.kernel.org/arm64/c/c73433fc630c

But please note that I made some changes to verify_hyp_capabilities() so
that it's (a) static and (b) uses IS_ENABLED to avoid the dummy function
definition. I also extended the IS_ENABLED_check so that it doesn't
conflict with the KVM kconfig changes from Fuad. Please shout if you think
I'm still missing something.

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
