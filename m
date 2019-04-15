Return-Path: <SRS0=r5x+=SR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC42C10F0E
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 15:18:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E53B20818
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 15:18:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E53B20818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 684F34A48F;
	Mon, 15 Apr 2019 11:18:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0cMg3UOugtjr; Mon, 15 Apr 2019 11:17:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C29564A4AA;
	Mon, 15 Apr 2019 11:17:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24CD14A4AA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 11:17:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XYUMUaPoSwQb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 11:17:57 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05CF44A48F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 11:17:57 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id AACD6307B963;
 Mon, 15 Apr 2019 15:17:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A63560C97;
 Mon, 15 Apr 2019 15:17:41 +0000 (UTC)
Date: Mon, 15 Apr 2019 17:17:39 +0200
From: Andrew Jones <drjones@redhat.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 05/14] KVM: arm64/sve: Clean up UAPI register ID
 definitions
Message-ID: <20190415151739.svfcwoybfr5js3wc@kamzik.brq.redhat.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <1555086498-26691-6-git-send-email-Dave.Martin@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1555086498-26691-6-git-send-email-Dave.Martin@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.47]); Mon, 15 Apr 2019 15:17:55 +0000 (UTC)
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190415151739.qWv6fVjhMAe3ePD5s4Yc37fSIgCb4R0NWWWLyvSyZ1Y@z>

On Fri, Apr 12, 2019 at 05:28:09PM +0100, Dave Martin wrote:
> Currently, the SVE register ID macros are not all defined in the
> same way, and advertise the fact that FFR maps onto the nonexistent
> predicate register P16.  This is really just for kernel
> convenience, and may lead userspace into bad habits.
> 
> Instead, this patch masks the ID macro arguments so that
> architecturally invalid register numbers will not be passed through
> any more, and uses a literal KVM_REG_ARM64_SVE_FFR_BASE macro to
> define KVM_REG_ARM64_SVE_FFR(), similarly to the way the _ZREG()
> and _PREG() macros are defined.
> 
> Rather than plugging in magic numbers for the number of Z- and P-
> registers and the maximum possible number of register slices, this
> patch provides definitions for those too.  Userspace is going to
> need them in any case, and it makes sense for them to come from
> <uapi/asm/kvm.h>.
> 
> sve_reg_to_region() uses convenience constants that are defined in
> a different way, and also makes use of the fact that the FFR IDs
> are really contiguous with the P15 IDs, so this patch retains the
> existing convenience constants in guest.c, supplemented with a
> couple of sanity checks to check for consistency with with the UAPI

s/with with/with/

> header.
> 
> Fixes: e1c9c98345b3 ("KVM: arm64/sve: Add SVE support to register access ioctl interface")
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/include/uapi/asm/kvm.h | 32 +++++++++++++++++++++++---------
>  arch/arm64/kvm/guest.c            |  9 +++++++++
>  2 files changed, 32 insertions(+), 9 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
