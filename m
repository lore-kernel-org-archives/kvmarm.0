Return-Path: <SRS0=1n5P=4H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B997C34022
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 07:52:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B25CF222D9
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 07:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="puwrlXZU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B25CF222D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ED7D4AF51;
	Wed, 19 Feb 2020 02:52:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dGxHiXtEqyd5; Wed, 19 Feb 2020 02:52:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 205B04AF37;
	Wed, 19 Feb 2020 02:52:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E64D4AF2D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 02:52:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pvqdR2v5lVyy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Feb 2020 02:52:07 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 802D94A54B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 02:52:07 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3803C21D56;
 Wed, 19 Feb 2020 07:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582098726;
 bh=DXyXsIYD/jYMp5sCM+tq/z3Z1WPUdlaBaxmFssTcyyk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=puwrlXZUSL5xRYpx2wIoU8h9QkrBUiVtzWPTGdxijB1ZcG7ShYLc1DOiSySfjK+GW
 iB3x43EXqv5h/6X5wzz9ixQpc0i8haradG6gGPu6McnsLLpgCy1vVtxOrh8qgcKxUA
 2//XNmC5oXIrYiWGmSYvuSPoToXrOrCwIrzErJug=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j4K9M-006RyY-FM; Wed, 19 Feb 2020 07:52:04 +0000
Date: Wed, 19 Feb 2020 07:52:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 1/9] KVM: Pass kvm_init()'s opaque param to
 additional arch funcs
Message-ID: <20200219075202.1a6ed865@why>
In-Reply-To: <20200218235437.20533-2-sean.j.christopherson@intel.com>
References: <20200218235437.20533-1-sean.j.christopherson@intel.com>
 <20200218235437.20533-2-sean.j.christopherson@intel.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, pbonzini@redhat.com,
 paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, cohuck@redhat.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-mips@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Tue, 18 Feb 2020 15:54:29 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Pass @opaque to kvm_arch_hardware_setup() and
> kvm_arch_check_processor_compat() to allow architecture specific code to
> reference @opaque without having to stash it away in a temporary global
> variable.  This will enable x86 to separate its vendor specific callback
> ops, which are passed via @opaque, into "init" and "runtime" ops without
> having to stash away the "init" ops.
> 
> No functional change intended.
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Tested-by: Cornelia Huck <cohuck@redhat.com> #s390
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Acked-by: Marc Zyngier <maz@kernel.org>

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
