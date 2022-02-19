Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079C8C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 19 Feb 2022 09:42:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72E464A014;
	Sat, 19 Feb 2022 04:42:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BA9dmhlGbLEI; Sat, 19 Feb 2022 04:42:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2194B4A105;
	Sat, 19 Feb 2022 04:42:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B59449F23
 for <kvmarm@lists.cs.columbia.edu>; Sat, 19 Feb 2022 04:42:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SdEQbSV3zXrc for <kvmarm@lists.cs.columbia.edu>;
 Sat, 19 Feb 2022 04:42:23 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4E8149F1D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 19 Feb 2022 04:42:23 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8F5D860FBE;
 Sat, 19 Feb 2022 09:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E747CC004E1;
 Sat, 19 Feb 2022 09:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645263742;
 bh=JHGMB5wyXhuUeu/pJD4Q++IqqHBbSh5JNv1xBjTAPEA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=CSFEtGbLDSfNNskaealbTBWwp5XwQV4VUJ6arAPCR4vH1cHFzWXl3FW/exhom/Tc3
 AAsAhGeSLlPWBb0j4cX8KN2yKftFgH8nLbv5fprXL0I7sQAPJtdo6XOcuhDEV6lIwE
 IhICjv5j+WER0/YYudn+WmplDvUF2u414sqrX8dy538qwrrV1Gjw40PzusVIld4dhl
 dSC03amXgOTf6aBwicxF+zyhxTEQPo+UoXU7A7ALYXHPqF1jd3dlTGThhCAlhFxS/y
 ptnRQgnG8PpTTI7YX2a+7q7tIYziIMAI5FAuJk6Rf08W1fTQImOrAhAJZ1Siwox6c+
 s/YKMlwyu9JNA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nLMFv-008xGO-Ul; Sat, 19 Feb 2022 09:42:20 +0000
MIME-Version: 1.0
Date: Sat, 19 Feb 2022 09:42:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Introduce get_set_regs_perf
 test
In-Reply-To: <CAAeT=FxbbBq0sxUZAOSJW_wM+6M=xQe-p+=aeqpg=-y9VbpnnA@mail.gmail.com>
References: <20220217034947.180935-1-reijiw@google.com>
 <20220217034947.180935-2-reijiw@google.com> <Yg3Uer/K6n/h6oBz@google.com>
 <874k4x502u.wl-maz@kernel.org>
 <CAAeT=FxbbBq0sxUZAOSJW_wM+6M=xQe-p+=aeqpg=-y9VbpnnA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <3878ff49741733d6dd76aae57b594cb2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reijiw@google.com, oupton@google.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, drjones@redhat.com,
 pbonzini@redhat.com, will@kernel.org, pshier@google.com, ricarkol@google.com,
 jingzhangos@google.com, rananta@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Reiji,

On 2022-02-19 04:50, Reiji Watanabe wrote:
> Hi Marc,
> 
> On Thu, Feb 17, 2022 at 1:12 AM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> On Thu, 17 Feb 2022 04:52:10 +0000,
>> Oliver Upton <oupton@google.com> wrote:
>> 
>> > Would it make sense to test some opt-in capabilities that expose
>> > additional registers (PMU, SVE, etc.)?
>> 
>> I think this is important. System registers are usually saved/restored
> 
> Yes, I will fix the test to include registers for opt-in features
> when supported.
> 
>> in groups, and due to the way we walk the sysreg array, timings are
>> unlikely to be uniform. Getting a grip on that could help restructure
>> the walking if required (either per-group arrays, or maybe a tree
>> structure).
> 
> The biggest system register table that I know is sys_reg_descs[],
> and KVM_SET_ONE_REG/KVM_GET_ONE_REG/emulation code already uses
> binary search to find the target entry.  So, the search itself
> isn't that bad.  The difference between the min and the max
> latency of KVM_GET_ONE_REG for the registers is always around
> 200nsec on Ampere Altra machine as far as I checked.

Even if it is OK so far, it is bound to get worse over time, as
the architecture keeps adding all sort of things that we'll
eventually have to save/restore.

I see this test as a way to monitor this trend and work out when
we need to invest in something better.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
