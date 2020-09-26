Return-Path: <SRS0=w4Hd=DD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2650AC2D0A8
	for <kvmarm@archiver.kernel.org>; Sat, 26 Sep 2020 09:48:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77B9D238E2
	for <kvmarm@archiver.kernel.org>; Sat, 26 Sep 2020 09:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPN0+2bF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77B9D238E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE0F64B2C0;
	Sat, 26 Sep 2020 05:48:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8BW2-IVfR24E; Sat, 26 Sep 2020 05:48:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B9224B2C1;
	Sat, 26 Sep 2020 05:48:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7631E4B230
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Sep 2020 05:48:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 51NNCiKMpfVB for <kvmarm@lists.cs.columbia.edu>;
 Sat, 26 Sep 2020 05:48:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 735554B2BF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Sep 2020 05:48:21 -0400 (EDT)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1601113701;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=qPzyT1yxzWEFOlVOKw/hmxaO7K61FMxgOjcytwjQqGc=;
 b=FPN0+2bFBHZeDflcT6n+n+TvakTlDkUlciLPJUMqvqAu9CcxPNg++Dbfz2FDkv/ytnXvwt
 O9uZARLg8TRQnHXdT7hyrMXmnf7pv8lShUtsh5YVo3ofTzVU9KbYXyHiQPOzIdthgups8a
 yIcJFGZytgiPwU1OXuI9AWwEhAvzyis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-tf2a4MmxM5uxiwuk2HzxFA-1; Sat, 26 Sep 2020 05:48:16 -0400
X-MC-Unique: tf2a4MmxM5uxiwuk2HzxFA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40664107466A;
 Sat, 26 Sep 2020 09:48:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.27])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4802E5D9DC;
 Sat, 26 Sep 2020 09:48:11 +0000 (UTC)
Date: Sat, 26 Sep 2020 11:48:09 +0200
From: Andrew Jones <drjones@redhat.com>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: Hide unsupported MPAM from the guest
Message-ID: <20200926094809.f5boi5c3bnptsa7x@kamzik.brq.redhat.com>
References: <20200925160102.118858-1-james.morse@arm.com>
MIME-Version: 1.0
In-Reply-To: <20200925160102.118858-1-james.morse@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Sep 25, 2020 at 05:01:02PM +0100, James Morse wrote:
> Commit 011e5f5bf529 ("arm64/cpufeature: Add remaining feature bits in
> ID_AA64PFR0 register") proactively added published features to the
> cpufeature id registers.
> 
> If the platform supports these features, they are visible in the
> sanitised ID registers that are exposed to KVM guests. This is a
> problem as KVM doesn't support MPAM.
> 
> The hardware reset behaviour of MPAM is to be disabled at EL3. It
> is unlikely anyone would ship a platform without firmware support,
> the necessary initialisation has been upstream in the TF-A project
> for over a year.
> 
> Firmware configures the EL2 registers to trap EL1 and EL0 access
> to EL2. As KVM doesn't support MPAM, it doesn't change these
> registers. Booting an MPAM capable kernel as a guest of mainline
> causes KVM to take an unknown trap from an EL1 guest, and inject
> an undef in response:
> host:
> | kvm [126]: Unsupported guest sys_reg access at: ffff800010093f24 [00000005]
> |  { Op0( 3), Op1( 0), CRn(10), CRm( 5), Op2( 0), func_read },
> 
> guest:
> | ------------[ cut here ]------------
> | kernel BUG at arch/arm64/kernel/traps.c:409!
> | Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> | Modules linked in:
> | CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.6.0-rc1-00152-g570fa7e2d2ad #11605
> | Hardware name: linux,dummy-virt (DT)
> | pstate: 00000005 (nzcv daif -PAN -UAO)
> | pc : do_undefinstr+0x2ec/0x310
> | lr : do_undefinstr+0x2f8/0x310
> ...
> 
> This is a tad unfair on the guest as KVM said it supported the
> feature. Mask out the MPAM feature.
> 
> Fixes: 011e5f5bf529 ("arm64/cpufeature: Add remaining feature bits in
> ID_AA64PFR0 register")
> Cc: <stable@vger.kernel.org>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> 
> ---
> I'll be back at rc1 with the minimal KVM support to ensure the traps
> are enabled and handled islently.
> ---
>  arch/arm64/kvm/sys_regs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 077293b5115f..f736791f37ca 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1131,6 +1131,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		if (!vcpu_has_sve(vcpu))
>  			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
>  		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
> +		val &= ~(0xfUL << ID_AA64PFR0_MPAM_SHIFT);
>  	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
>  		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
>  			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> -- 
> 2.28.0
>

Hi James,

Thanks for this fix

Reviewed-by: Andrew Jones <drjones@redhat.com>

but, going forward, I think we need a more robust solution to CPU feature
additions in order to avoid these types of issues. Our current approach is
to patch KVM to hide features from the guest as we introduce support to
the [guest] kernel. IOW, we have to remember to maintain a guest CPU
feature reject-list. And, since that's error-prone, we should do regular
audits of the reject-list to ensure it's complete. It would be better to
have an accept-list (all features masked by default) and then only expose
features as we add the KVM support. Maybe we should introduce KVM masks
for each ID register? Also, regarding the current implementation, do you
know if a recent audit has been conducted to ensure (now with MPAM) that
the current feature hiding is complete?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
