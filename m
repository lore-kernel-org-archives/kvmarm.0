Return-Path: <SRS0=6eMA=7N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314A5C433DF
	for <kvmarm@archiver.kernel.org>; Sun, 31 May 2020 13:37:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9980C206F1
	for <kvmarm@archiver.kernel.org>; Sun, 31 May 2020 13:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBsqsjL4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9980C206F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FFD24B26B;
	Sun, 31 May 2020 09:37:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8JcNflmfqT8b; Sun, 31 May 2020 09:37:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 374AA4B246;
	Sun, 31 May 2020 09:37:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 698884B1CA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 May 2020 09:37:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ISZQAqrzWbXa for <kvmarm@lists.cs.columbia.edu>;
 Sun, 31 May 2020 09:37:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F9244B1C9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 May 2020 09:37:53 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2C8C1206F1;
 Sun, 31 May 2020 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590932272;
 bh=PinbNsGvjOCu01z2yD/Rnhlz2gzf22QvJJ6yl34ziwA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=nBsqsjL403lfU1YOplK66SyWzj2gv9BgXlGslZn8oFCn4A/7YSjqasY1I0HxwEYwt
 BcbkIkc9sd0AaV0rrzeb+yZDegif9TiRJgc8JBO8nBAUp6wdiHcLdsrIyUHzXP/4OH
 x95FNBWTw7C2EUnRBoWpMi53enuTA2BYMReUX2yg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jfO9u-00Gh3V-Ph; Sun, 31 May 2020 14:37:50 +0100
MIME-Version: 1.0
Date: Sun, 31 May 2020 14:37:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm64: aarch32 ACTLR accesses
In-Reply-To: <20200526161834.29165-1-james.morse@arm.com>
References: <20200526161834.29165-1-james.morse@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <8bdb1f67fb142f3547ebcbbe4e6158c0@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi James,

On 2020-05-26 17:18, James Morse wrote:

[...]

> 1. How does this copro[] thing work with a big-endian host?
> The cp15_regs emulation look fine as nothing uses vcpu_cp15() to read 
> the
> register, but wouldn't prepare_fault32() read the wrong end of the 
> register
> when using vcpu_cp15()?

This seems pretty broken indeed. How about something like this:

diff --git a/arch/arm64/include/asm/kvm_host.h 
b/arch/arm64/include/asm/kvm_host.h
index 59029e90b557..e80c0e06f235 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -404,8 +404,14 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 
val, int reg);
   * CP14 and CP15 live in the same array, as they are backed by the
   * same system registers.
   */
-#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
-#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
+#ifdef CPU_BIG_ENDIAN
+#define CPx_OFFSET	1
+#else
+#define CPx_OFFSET	0
+#endif
+
+#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_OFFSET])
+#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_OFFSET])

  struct kvm_vm_stat {
  	ulong remote_tlb_flush;

Yes, it's ugly.

> 2. How does the 32bit fault injection code work with VHE?
> vcpu_cp15() modifies the in-memory copy, surely a vcpu_put() will 
> clobber
> everything it did, or fail to restore it when entering the guest.

Wow, you're really wadding into dangerous territory! ;-)

Again, you are absolutely right. I guess nobody really ever ran
32bit guests on VHE systems, as they are both rare and mostly
with 64-bit-only EL1. This code is also mostly never used
(we run well behaved guests at all times!).

Here's a hack that should do the right thing at all times:

diff --git a/arch/arm64/kvm/aarch32.c b/arch/arm64/kvm/aarch32.c
index 0a356aa91aa1..40a62a99fbf8 100644
--- a/arch/arm64/kvm/aarch32.c
+++ b/arch/arm64/kvm/aarch32.c
@@ -33,6 +33,26 @@ static const u8 return_offsets[8][2] = {
  	[7] = { 4, 4 },		/* FIQ, unused */
  };

+static bool pre_fault_synchronize(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+	if (vcpu->arch.sysregs_loaded_on_cpu) {
+		kvm_arch_vcpu_put(vcpu);
+		return true;
+	}
+
+	preempt_enable();
+	return false;
+}
+
+static void post_fault_synchronize(struct kvm_vcpu *vcpu, bool loaded)
+{
+	if (loaded) {
+		kvm_arch_vcpu_load(vcpu, smp_processor_id());
+		preempt_enable();
+	}
+}
+
  /*
   * When an exception is taken, most CPSR fields are left unchanged in 
the
   * handler. However, some are explicitly overridden (e.g. M[4:0]).
@@ -155,7 +175,10 @@ static void prepare_fault32(struct kvm_vcpu *vcpu, 
u32 mode, u32 vect_offset)

  void kvm_inject_undef32(struct kvm_vcpu *vcpu)
  {
+	bool loaded = pre_fault_synchronize(vcpu);
+
  	prepare_fault32(vcpu, PSR_AA32_MODE_UND, 4);
+	post_fault_synchronize(vcpu, loaded);
  }

  /*
@@ -168,6 +191,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool 
is_pabt,
  	u32 vect_offset;
  	u32 *far, *fsr;
  	bool is_lpae;
+	bool loaded;
+
+	loaded = pre_fault_synchronize(vcpu);

  	if (is_pabt) {
  		vect_offset = 12;
@@ -191,6 +217,8 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool 
is_pabt,
  		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
  		*fsr = DFSR_FSC_EXTABT_nLPAE;
  	}
+
+	post_fault_synchronize(vcpu, loaded);
  }

  void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr)

Of course, none of this is tested. We really should find ways to
trigger these corner cases... :-/

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
