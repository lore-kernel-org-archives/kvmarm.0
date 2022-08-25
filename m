Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D885ECAA25
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 17:29:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B549F4D8A4;
	Thu, 25 Aug 2022 13:29:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xxL7A8pFoYCm; Thu, 25 Aug 2022 13:29:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D72D4D92B;
	Thu, 25 Aug 2022 13:29:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 082AB4D8A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 13:29:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JmAi9kSylxkg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 13:29:31 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0325D4D83B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 13:29:30 -0400 (EDT)
Date: Thu, 25 Aug 2022 10:29:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661448570;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zdth8V+Yi5dhI0ba6Qeqn/SaZeHitUYg7hY4PMB4tjs=;
 b=JcVnmGrUDy+xU5oOhDVH5E7TR0ogrnEsL5NSG20fGR19XFIeXqFamJ8yN6v9E8Ba1/W2S0
 d4WodRFs9xgi7bnqqt7NWF8y/VyfKtA6tjciw1Edpu8L68Z8655kUY1itd+T5TtOp6Gf63
 VzcEvmvYg08INaBs/P7H5ocMm/ghoSU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 5/9] KVM: arm64: selftests: Have debug_version() use
 cpuid_get_ufield() helper
Message-ID: <YwexdqgGpN43qYyy@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-6-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-6-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Aug 24, 2022 at 10:08:42PM -0700, Reiji Watanabe wrote:
> Change debug_version() to use cpuid_get_ufield() to extract DebugVer
> field from the AA64DFR0_EL1 register value.

Either squash this into the patch that adds the field accessors or
reorder it to immediately follow said patch.

aarch64_get_supported_page_sizes() is also due for a cleanup, as it
accesses the TGRANx fields of ID_AA64MMFR0_EL1.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
