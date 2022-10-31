Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843E2ECAAA1
	for <kvmarm@archiver.kernel.org>; Mon, 31 Oct 2022 17:24:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9CAE4BAAE;
	Mon, 31 Oct 2022 13:24:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id keiUjhZtvgFu; Mon, 31 Oct 2022 13:24:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCCAF4BACE;
	Mon, 31 Oct 2022 13:24:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20CF14BAAA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2022 13:24:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J1XV+MyGHxxu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Oct 2022 13:24:08 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C998F4BA87
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2022 13:24:08 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 90DD761345;
 Mon, 31 Oct 2022 17:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441E2C4314A;
 Mon, 31 Oct 2022 17:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1667237047;
 bh=BtJI2S7G3SFkXt/01dXN9vtpHl74EK9NiHMc7zybaFY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=WR0Ke/s2u39ppT7JEfxQDBwaNy/RENJrlWoqHuklDr0F9d7d3UHpgpWiuUwLPMwBi
 nn+GZUCCPWIhA/UFGwt0gOTwsCnHkAvr9Kzyqz2ZjCIbJ9KuOhgBPfoIWTD98KBzkk
 mkimq3mM+AoqsHYpxXok2IO8jXPw8WBSiS3RKth5EmsWN4I32/DpNyy3F48lCs3277
 ipNTibJUK59SuzcUBsimaTdOnshjTmUHGKr+XjZwpf1ts2yUeX38PzDV30Zud1xUjy
 g8wfbD8W+KKB41rdb3enXxR55QZq2G1XkmByK0nKh4spg9erdIgP0xgkjCOj43IL4b
 pQ39QpjLD0Krw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1opYW4-002naO-Nh;
 Mon, 31 Oct 2022 17:24:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>,
	kvmarm@lists.linux.dev
Subject: Re: (subset) [PATCH v7 0/9] KVM: arm64: Enable ring-based dirty
 memory tracking
Date: Mon, 31 Oct 2022 17:23:55 +0000
Message-Id: <166723701641.2037271.10248037129602101185.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221031003621.164306-1-gshan@redhat.com>
References: <20221031003621.164306-1-gshan@redhat.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: gshan@redhat.com, kvmarm@lists.linux.dev,
 ajones@ventanamicro.com, andrew.jones@linux.dev, suzuki.poulose@arm.com,
 will@kernel.org, james.morse@arm.com, kvm@vger.kernel.org,
 oliver.upton@linux.dev, kvmarm@lists.cs.columbia.edu, peterx@redhat.com,
 dmatlack@google.com, shuah@kernel.org, catalin.marinas@arm.com,
 alexandru.elisei@arm.com, pbonzini@redhat.com, seanjc@google.com,
 shan.gavin@gmail.com, bgardon@google.com, zhenyzha@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, shuah@kernel.org, andrew.jones@linux.dev,
 bgardon@google.com, shan.gavin@gmail.com, catalin.marinas@arm.com,
 dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Mon, 31 Oct 2022 08:36:12 +0800, Gavin Shan wrote:
> This series enables the ring-based dirty memory tracking for ARM64.
> The feature has been available and enabled on x86 for a while. It
> is beneficial when the number of dirty pages is small in a checkpointing
> system or live migration scenario. More details can be found from
> fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking").
> 
> v6: https://lore.kernel.org/kvmarm/20221011061447.131531-1-gshan@redhat.com/
> v5: https://lore.kernel.org/all/20221005004154.83502-1-gshan@redhat.com/
> v4: https://lore.kernel.org/kvmarm/20220927005439.21130-1-gshan@redhat.com/
> v3: https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
> v2: https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
> v1: https://lore.kernel.org/lkml/20220819005601.198436-1-gshan@redhat.com
> 
> [...]

Applied to fixes, thanks!

[3/9] KVM: Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL} prior to enabling them
      commit: 7a2726ec3290c52f52ce8d5f5af73ab8c7681bc1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
