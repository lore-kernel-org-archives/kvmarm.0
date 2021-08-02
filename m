Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E99CC4320E
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 13:40:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1320761029
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 13:40:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1320761029
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6FA4A2E5;
	Mon,  2 Aug 2021 09:40:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Lhb+HTB9t2x; Mon,  2 Aug 2021 09:39:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A02B04A19F;
	Mon,  2 Aug 2021 09:39:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 919CD4A19F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 09:39:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z0Sg+YFtkWS3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 09:39:57 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6C4B49F82
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 09:39:57 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CE75C60FC1;
 Mon,  2 Aug 2021 13:39:56 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mAYAc-002Sjn-RR; Mon, 02 Aug 2021 14:39:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 0/6] KVM: Remove kvm_is_transparent_hugepage() and
 friends
Date: Mon,  2 Aug 2021 14:39:51 +0100
Message-Id: <162791157466.3441503.3535158079584793741.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726153552.1535838-1-maz@kernel.org>
References: <20210726153552.1535838-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 suzuki.poulose@arm.com, kernel-team@android.com, pbonzini@redhat.com,
 qperret@google.com, alexandru.elisei@arm.com, james.morse@arm.com,
 will@kernel.org, seanjc@google.com, willy@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kernel-team@android.com
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

On Mon, 26 Jul 2021 16:35:46 +0100, Marc Zyngier wrote:
> A while ago, Willy and Sean pointed out[0] that arm64 is the last user
> of kvm_is_transparent_hugepage(), and that there would actually be
> some benefit in looking at the userspace mapping directly instead.
> 
> This small series does exactly that, although it doesn't try to
> support more than a PMD-sized mapping yet for THPs. We could probably
> look into unifying this with the huge PUD code, and there is still
> some potential use of the contiguous hint.
> 
> [...]

Applied to next, thanks!

[1/6] KVM: arm64: Introduce helper to retrieve a PTE and its level
      commit: 63db506e07622c344a3c748a1c06293d48780f83
[2/6] KVM: arm64: Walk userspace page tables to compute the THP mapping size
      commit: 6011cf68c88545e16cb32039c2cecfdae6a32315
[3/6] KVM: arm64: Avoid mapping size adjustment on permission fault
      commit: f2cc327303b13a70311e823bd52aa0bca8c7ddbc
[4/6] KVM: Remove kvm_is_transparent_hugepage() and PageTransCompoundMap()
      commit: 205d76ff0684a0b4fe3ff3a283d143a47439d191
[5/6] KVM: arm64: Use get_page() instead of kvm_get_pfn()
      commit: 0fe49630101b3ce23bd21a2788440ac719ec868a
[6/6] KVM: Get rid of kvm_get_pfn()
      commit: 36c3ce6c0d03a6c9992c3359f879cdc70fde836a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
