Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D30C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 17:37:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE6864B12C;
	Tue,  8 Feb 2022 12:37:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TmTShJSAD8XN; Tue,  8 Feb 2022 12:37:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14E544B152;
	Tue,  8 Feb 2022 12:37:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 831C74A0FC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rxEaH+lIuFcq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 12:37:31 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 042654B0F4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:31 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 0CAB9B81CB5;
 Tue,  8 Feb 2022 17:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C3EC340ED;
 Tue,  8 Feb 2022 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644341848;
 bh=DPma+LTOaMoHH6eY4ZXpFN0Oa9UnswEIPw8is5imAJ0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ihoRU5F2a5DZAb4LPAzOI1XryX1XGVFbgeKREFgKQTtGgPMdc7qSNvzNjqiqoHH3n
 lUd7N6K1rzHpLnfdyo+fsChx11MV9Cpmfaj+NcAPzq+EgSt9qT7Trr3noIstxpV/aZ
 gXsvCHhRDeoCyosjWtPIhV4MN5jPRtOePXAYZkXkWsYj32pjxxPzKOFJ35SuC6bVl4
 FDafU4bu8dQNPZc1olVToKXusejnBZxm/PlSHHN1MSYczC/dkHoaNhyCGMj/w1WGDj
 m5YofxIqyxzetiBGyUZLBa0EiVn0YwOhLlEO5GFdZyTgMV/Y/kxFpyCZHF06Ok6QJz
 tjkiz3W1CzY7g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nHUQh-006Kse-1y; Tue, 08 Feb 2022 17:37:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, drjones@redhat.com, kvm@vger.kernel.org,
 Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 0/5] kvm: selftests: aarch64: some fixes for vgic_irq
Date: Tue,  8 Feb 2022 17:37:26 +0000
Message-Id: <164434147328.3931943.5336012810624636920.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
References: <20220127030858.3269036-1-ricarkol@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 kvm@vger.kernel.org, ricarkol@google.com, pbonzini@redhat.com,
 oupton@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Paolo Bonzini <pbonzini@redhat.com>
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

On Wed, 26 Jan 2022 19:08:53 -0800, Ricardo Koller wrote:
> Reiji discovered multiple issues with the vgic_irq series [0]:
> 1. there's an assert that needs fixing.
> 2. some guest arguments are not set correctly.
> 3. the failure test in kvm_set_gsi_routing_irqchip_check is wrong.
> 4. there are lots of comments that use the wrong formatting.
> 5. vgic_poke_irq() could use a tighter assert check.
> 
> [...]

Applied to next, thanks!

[1/5] kvm: selftests: aarch64: fix assert in gicv3_access_reg
      commit: cc94d47ce16d4147d546e47c8248e8bd12ba5fe5
[2/5] kvm: selftests: aarch64: pass vgic_irq guest args as a pointer
      commit: 11024a7a0ac26dd31ddfa0f6590e158bdf9ab858
[3/5] kvm: selftests: aarch64: fix the failure check in kvm_set_gsi_routing_irqchip_check
      commit: 5b7898648f02083012900e48d063e51ccbdad165
[4/5] kvm: selftests: aarch64: fix some vgic related comments
      commit: a5cd38fd9c47b23abc6df08d6ee6a71b39038185
[5/5] kvm: selftests: aarch64: use a tighter assert in vgic_poke_irq()
      commit: b53de63a89244c196d8a2ea76b6754e3fdb4b626

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
