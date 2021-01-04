Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD721C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 16:27:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 517BF224D2
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 16:27:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 517BF224D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F74C4B2F3;
	Mon,  4 Jan 2021 11:27:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BKvz6Ae1CS8Q; Mon,  4 Jan 2021 11:27:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D3E44B2E9;
	Mon,  4 Jan 2021 11:27:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B7954B294
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 10:47:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WAPwfjIaL8Aq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2021 10:47:38 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 647AD4B291
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 10:47:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1609775258;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GdVjsGRGqcz2Bp3755zL9bg1/osM9yZ5XLo7yMYYsTA=;
 b=VFa2F8oGwTpi8o41U91j1ii2nmEiqUL2TmK7+YG6r5Jg+pEgnBKWhkD8VWpR82yYrK0qOa
 k081qh6jOHgbHpUXEZTFSMvc4B6cq96eacHG1xLUZ6++1+gPxuOF3pKqWJn+sLtZd1eyfP
 LfDUcaaRzQ6Ip1N8oMwTATw6SOVWPx8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-k2tGDxxXOsuqoOETBhFf3w-1; Mon, 04 Jan 2021 10:47:33 -0500
X-MC-Unique: k2tGDxxXOsuqoOETBhFf3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D3E2801AA9;
 Mon,  4 Jan 2021 15:47:31 +0000 (UTC)
Received: from ovpn-66-203.rdu2.redhat.com (unknown [10.10.67.203])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 872551007613;
 Mon,  4 Jan 2021 15:47:30 +0000 (UTC)
Message-ID: <703e1b5f2db1631e8f9c55619909fe66eb069f25.camel@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Don't access PMCR_EL0 when no PMU is available
From: Qian Cai <qcai@redhat.com>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu
Date: Mon, 04 Jan 2021 10:47:30 -0500
In-Reply-To: <20201210083059.1277162-1-maz@kernel.org>
References: <20201210083059.1277162-1-maz@kernel.org>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mailman-Approved-At: Mon, 04 Jan 2021 11:27:56 -0500
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>, kernel-team@android.com
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

On Thu, 2020-12-10 at 08:30 +0000, Marc Zyngier wrote:
> We reset the guest's view of PMCR_EL0 unconditionally, based on
> the host's view of this register. It is however legal for an
> imnplementation not to provide any PMU, resulting in an UNDEF.
> 
> The obvious fix is to skip the reset of this shadow register
> when no PMU is available, sidestepping the issue entirely.
> If no PMU is available, the guest is not able to request
> a virtual PMU anyway, so not doing nothing is the right thing
> to do!
> 
> It is unlikely that this bug can hit any HW implementation
> though, as they all provide a PMU. It has been found using nested
> virt with the host KVM not implementing the PMU itself.
> 
> Fixes: ab9468340d2bc ("arm64: KVM: Add access handler for PMCR register")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reverting this commit on the top of today's linux-next fixed a qemu-kvm coredump
issue on TX2 while starting a guest.

- host kernel .config:
https://cailca.coding.net/public/linux/mm/git/files/master/arm64.config

# /usr/libexec/qemu-kvm -name ubuntu-20.04-server-cloudimg -cpu host -smp 2 -m 2g
-drive if=none,format=qcow2,file=./ubuntu-20.04-server-cloudimg.qcow2,id=hd 
-device virtio-scsi -device scsi-hd,drive=hd -cdrom ./ubuntu-20.04-server-cloudimg.iso
-bios /usr/share/AAVMF/AAVMF_CODE.fd -M gic-version=host -nographic 
-nic user,model=virtio,hostfwd=tcp::2222-:22

qemu-kvm: /builddir/build/BUILD/qemu-4.2.0/target/arm/helper.c:1812:
pmevcntr_rawwrite: Assertion `counter < pmu_num_counters(env)' failed.

> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index bc15246775d0..6c64d010102b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -923,6 +923,10 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const
> struct sys_reg_desc *r)
>  {
>  	u64 pmcr, val;
>  
> +	/* No PMU available, PMCR_EL0 may UNDEF... */
> +	if (!kvm_arm_support_pmu_v3())
> +		return;
> +
>  	pmcr = read_sysreg(pmcr_el0);
>  	/*
>  	 * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
