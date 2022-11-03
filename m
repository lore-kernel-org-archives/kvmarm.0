Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DA2C4321E
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 15:47:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B08C1410DE;
	Thu,  3 Nov 2022 11:47:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G5eWqFv8H5LW; Thu,  3 Nov 2022 11:47:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F7F4B256;
	Thu,  3 Nov 2022 11:47:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAC0A4B256
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:47:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iKEwfCCFc9yy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 11:47:24 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CC7A4B0F4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:47:24 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 274AFB82685;
 Thu,  3 Nov 2022 15:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB34C433C1;
 Thu,  3 Nov 2022 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1667490441;
 bh=YyjFEMcRcjqRDNSfbQWiVKeLBUUkpDMT5jdKO6cAdqQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=TDr9qyKe/+dTR8gWFGKeBUhaC6zf/8HOy2icfeIp2fkVHh6HFeOyvTa2yirYgH9Uv
 g4p6zC9ZdppboGONR9r7YwziMTpiF2HbXUtg0n8i+Kbk9k6mvoNu4xv3ZaKijU7d6d
 haM3m5tT7hYMlfh7UBfNTT13941UTyCsMsHT3eEQrZuKkF3vhVU7/yKO7UR6K+b6f7
 PgKJmetND26xArGRpkC53q/67oQ63maKXTe7hybvMkyeKQPiqAiOM9KosvFZYi+Lc8
 tWWbtpIOX7OWLWvK1l729EYpyaHJi41yIut+oPFcdNnuQbQk6jHeaLmxoBM4KJY8nk
 wkgc4wFHl4lbA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oqcR5-003Xxs-PC;
 Thu, 03 Nov 2022 15:47:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: yezengruan@huawei.com, steven.price@arm.com, catalin.marinas@arm.com,
 mark.rutland@arm.com, linux@armlinux.org.uk,
 Usama Arif <usama.arif@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
 will@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, bagasdotme@gmail.com
Subject: Re: [PATCH] kvm/arm: Fix pvtime documentation
Date: Thu,  3 Nov 2022 15:47:16 +0000
Message-Id: <166749042515.2400683.5463582608696818455.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221103131210.3603385-1-usama.arif@bytedance.com>
References: <20221103131210.3603385-1-usama.arif@bytedance.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: yezengruan@huawei.com, steven.price@arm.com,
 catalin.marinas@arm.com, mark.rutland@arm.com, linux@armlinux.org.uk,
 usama.arif@bytedance.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, will@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, bagasdotme@gmail.com,
 fam.zheng@bytedance.com, liangma@liangbit.com, punit.agrawal@bytedance.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: punit.agrawal@bytedance.com, fam.zheng@bytedance.com, liangma@liangbit.com
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

On Thu, 3 Nov 2022 13:12:10 +0000, Usama Arif wrote:
> This includes table format and using reST labels for
> cross-referencing to vcpu.rst.

Applied to kvm-arm64/misc-6.2, thanks!

[1/1] kvm/arm: Fix pvtime documentation
      commit: e7442ac1da07910f4731cb812c05484e4be2d4de

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
