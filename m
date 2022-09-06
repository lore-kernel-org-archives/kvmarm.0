Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BDCC6FA83
	for <kvmarm@archiver.kernel.org>; Tue,  6 Sep 2022 04:54:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CCA54BE4B;
	Tue,  6 Sep 2022 00:54:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RUp2QHkjrki3; Tue,  6 Sep 2022 00:54:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FCC24BE59;
	Tue,  6 Sep 2022 00:54:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75AE14BE1B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 00:54:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c-l9-XerPbyw for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2022 00:54:45 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 533754BE26
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 00:54:45 -0400 (EDT)
Date: Tue, 6 Sep 2022 05:54:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1662440083;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=hEQ8207Wqe20jUMzx18IBRP3OCnR8vMZaKCXgkLkmoI=;
 b=cpKKgUdkl1pr2b5NAK+po55wTT4lLZFVj2qXXrk+tQJtYXNItl2oTLRu2W5BbAdhXBxw2d
 zVPdqLj35UVIKoqWdjwC+LOeaHmkB4MQkY09RikH1UtRHMJYcb+LiGFTEEvAfDSNba37CD
 z91nYZEs/rqeI0hbE1URG2e9enSD2Vs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [PATCH v2 7/7] KVM: selftests: Add test for RAZ/WI AArch32 ID
 registers
Message-ID: <YxbSkCMxZdwKGqQM@google.com>
References: <20220902154804.1939819-1-oliver.upton@linux.dev>
 <20220902154804.1939819-8-oliver.upton@linux.dev>
 <20220905073140.lrsrbyu2zhkiki5a@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220905073140.lrsrbyu2zhkiki5a@kamzik>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
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

Hi Drew,

On Mon, Sep 05, 2022 at 09:31:40AM +0200, Andrew Jones wrote:

[...]

> > +static uint64_t reg_ids[] = {
> > +	KVM_ARM64_SYS_REG(SYS_ID_PFR0_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_PFR1_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_DFR0_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_MMFR0_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_MMFR1_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_MMFR2_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_MMFR3_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_ISAR0_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_ISAR1_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_ISAR2_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_ISAR3_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_ISAR4_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_ISAR5_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_MMFR4_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_ISAR6_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_MVFR0_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_MVFR1_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_MVFR2_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_PFR2_EL1),
> > +	KVM_ARM64_SYS_REG(SYS_ID_MMFR5_EL1),
> 
> Hi Oliver,
> 
> I see all the hidden and unallocated registers have been filtered out of
> the test lists. They should also behave as RAZ, right? Maybe we should
> keep them in the lists here for consistency and to test them as well.

Sure, can do. The reason I only tested these registers is because they
have RAZ/WI behavior with this series, whereas the rest are RAZ +
invariant. Should be easy enough to cover the whole range, though.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
