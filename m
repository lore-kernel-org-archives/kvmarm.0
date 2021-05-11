Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C0EC433ED
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 17:07:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97D9E61361
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 17:07:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97D9E61361
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05DC14B4E5;
	Tue, 11 May 2021 13:07:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KvV9ToXTHNFQ; Tue, 11 May 2021 13:07:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D79A24B4BC;
	Tue, 11 May 2021 13:07:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 630E64B4BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 13:07:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aP38rDfW4E30 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 13:07:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 401C1402C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 13:07:50 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DAA5E61352;
 Tue, 11 May 2021 17:07:48 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lgVrG-000jYH-LZ; Tue, 11 May 2021 18:07:46 +0100
From: Marc Zyngier <maz@kernel.org>
To: kernel test robot <lkp@intel.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: arm64: fix boolreturn.cocci warnings
Date: Tue, 11 May 2021 18:07:38 +0100
Message-Id: <162075284668.2048815.12157825442810113360.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426223357.GA45871@cd4295a34ed8>
References: <202104270655.gBGhIPdZ-lkp@intel.com>
 <20210426223357.GA45871@cd4295a34ed8>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: lkp@intel.com, seanjc@google.com, danmei.wei@intel.com,
 will@kernel.org, suzuki.poulose@arm.com, farrah.chen@intel.com,
 catalin.marinas@arm.com, pbonzini@redhat.com, kbuild-all@lists.01.org,
 julien.thierry.kdev@gmail.com, robert.hu@intel.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kbuild-all@lists.01.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Farrah Chen <farrah.chen@intel.com>,
 linux-arm-kernel@lists.infradead.org, Robert Hu <robert.hu@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Danmei Wei <danmei.wei@intel.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Tue, 27 Apr 2021 06:33:57 +0800, kernel test robot wrote:
> arch/arm64/kvm/mmu.c:1114:9-10: WARNING: return of 0/1 in function 'kvm_age_gfn' with return type bool
> arch/arm64/kvm/mmu.c:1084:9-10: WARNING: return of 0/1 in function 'kvm_set_spte_gfn' with return type bool
> arch/arm64/kvm/mmu.c:1127:9-10: WARNING: return of 0/1 in function 'kvm_test_age_gfn' with return type bool
> arch/arm64/kvm/mmu.c:1070:9-10: WARNING: return of 0/1 in function 'kvm_unmap_gfn_range' with return type bool
> 
>  Return statements in functions returning bool should use
>  true/false instead of 1/0.
> Generated by: scripts/coccinelle/misc/boolreturn.cocci

Applied to fixes, thanks!

[1/1] KVM: arm64: fix boolreturn.cocci warnings
      commit: 9ff40461a0e9684d8cb60058938004ddc16fb536

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
