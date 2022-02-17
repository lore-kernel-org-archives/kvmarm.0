Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34762C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 16:30:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C27E149E46;
	Thu, 17 Feb 2022 11:30:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T6dhLN196mCg; Thu, 17 Feb 2022 11:30:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD76749F33;
	Thu, 17 Feb 2022 11:30:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ADB649F2F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 11:30:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iNe1dLEelGIR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 11:30:12 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2509749E46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 11:30:12 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 495A361345;
 Thu, 17 Feb 2022 16:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE907C340E8;
 Thu, 17 Feb 2022 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645115410;
 bh=sKibz8OzQha4IEtN1WKsG3GJ7XK5Q1A3GcQLBBLeAak=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PpllzW2EpQnF667KIDoAmwzLnNggIf1+lxYcPcJvDmqc0aaxdzSS5zUzZvTnn/rxu
 m5CLZN/uotGOPyce3KKZE5Aw5RuNYh6R69LFtddIVuh/0fOuKPu6Shv2+LCuMHBF5e
 YA9pMhVSBqA/BvoFXHRgJzoBgwsSyl72kfjyDqVpRN8arvnXFQGwGVUKL76DKYjIF3
 hrp75T9mtuznx97/FxHhp9boWtJu87PnqxDClLjVcfPZk2783kU7FCoNNOcSEaUDh9
 75E/E6sJuSklSpRuuAw0JAfBkKsslQUHMluQ3L8yybJS/lhS4jG80vLRiNO2Xwzp7c
 6R4Y4rdPhbELQ==
Received: from static-176-185-135-154.ftth.abo.bbox.fr ([176.185.135.154]
 helo=localhost.localdomain)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nKjfU-008dH9-9v; Thu, 17 Feb 2022 16:30:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't miss pending interrupts for suspended
 vCPU
Date: Thu, 17 Feb 2022 16:30:01 +0000
Message-Id: <164511451219.2024117.15534854729772713949.b4-ty@kernel.org>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220217101242.3013716-1-oupton@google.com>
References: <20220217101242.3013716-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 176.185.135.154
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com,
 maz@kernel.org, ricarkol@google.com, alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, reijiw@google.com, pshier@google.com,
 pbonzini@redhat.com, seanjc@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
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

On Thu, 17 Feb 2022 10:12:42 +0000, Oliver Upton wrote:
> In order to properly emulate the WFI instruction, KVM reads back
> ICH_VMCR_EL2 and enables doorbells for GICv4. These preparations are
> necessary in order to recognize pending interrupts in
> kvm_arch_vcpu_runnable() and return to the guest. Until recently, this
> work was done by kvm_arch_vcpu_{blocking,unblocking}(). Since commit
> 6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out arch
> callback hook"), these callbacks were gutted and superseded by
> kvm_vcpu_wfi().
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Don't miss pending interrupts for suspended vCPU
      commit: a867e9d0cc15039a6ef72e17e2603303dcd1783f
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
