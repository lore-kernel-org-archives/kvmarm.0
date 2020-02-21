Return-Path: <SRS0=c+b0=4J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE33C35657
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 16:38:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B01D524650
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 16:38:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jac+jXV/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B01D524650
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F5784AECE;
	Fri, 21 Feb 2020 11:38:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id piEqkdUX0Cfy; Fri, 21 Feb 2020 11:38:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 427E04AED2;
	Fri, 21 Feb 2020 11:38:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C72294AECE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 11:38:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id le5QQPVwvk5r for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Feb 2020 11:38:14 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B810C4AEBF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 11:38:14 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8122D24650;
 Fri, 21 Feb 2020 16:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582303093;
 bh=vx7DYqshiSvtTa72/koYpApCGou0XWnWIMWdMy/RIAc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Jac+jXV/ZV53KVQTPBYVTDEppW4Mq4MV7IEX4C2znk1vl5Xji4vgwggxYqp8VBniq
 MszcHuSTDRzYJ5QykS2QZRKduROKCZ4yS0L5dl6E7HBeXLGDWSZuz0BSlkF1swZOXs
 roIpTwV/NgIxjC58XDtWI6M5pza1jIkDUPLArW6o=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j5BJb-007593-PI; Fri, 21 Feb 2020 16:38:11 +0000
MIME-Version: 1.0
Date: Fri, 21 Feb 2020 16:38:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Ask the compiler to __always_inline
 functions used by KVM at HYP
In-Reply-To: <228ef9d9-1ded-05ee-22e5-0158a0e47d82@arm.com>
References: <20200220165839.256881-1-james.morse@arm.com>
 <cb56f509ea0a4a9e1809af76f319daa2@kernel.org>
 <228ef9d9-1ded-05ee-22e5-0158a0e47d82@arm.com>
Message-ID: <6479dd67fbe12c6517551dbd79dc7461@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, ard.biesheuvel@linaro.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, samitolvanen@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi James,

On 2020-02-21 14:57, James Morse wrote:
> Hi Marc,
> 
> On 21/02/2020 12:55, Marc Zyngier wrote:
>> On 2020-02-20 16:58, James Morse wrote:
>>> It turns out KVM relies on the inline hint being honoured by the 
>>> compiler
>>> in quite a few more places than expected. Something about the Shadow 
>>> Call
>>> Stack support[0] causes the compiler to avoid inline-ing and to place
>>> these functions outside the __hyp_text. This ruins KVM's day.
>>> 
>>> Add the simon-says __always_inline annotation to all the static
>>> inlines that KVM calls from HYP code.
>>> 
>>> This series based on v5.6-rc2.
>> 
>> Many thanks for going through all this.
>> 
>> I'm happy to take it if Catalin or Will ack the arm64 patches.
>> It case we decide to go the other way around:
>> 
>> Acked-by: Marc Zyngier <maz@kernel.org>
>> 
>> One thing I'd like to look into though is a compile-time check that
>> nothing in the hyp_text section has a reference to a non-hyp_text
>> symbol.
> 
> Heh, that hypothetical tool would choke on things like 
> arch/arm64/kvm/hyp/tlb.c:
> | static void __hyp_text __tlb_switch_to_guest_vhe(...)
> | {
> 
> [...]
> 
> |	local_irq_save(cxt->flags);
> 
> which calls trace_hardirqs_off() ... which is absolutely fine because
> this only happens on VHE.

Duh, indeed.

> To do it purely with the section information, you'd need to separate
> all the VHE code... (maybe as a debug option that only runs when VHE
> is turned off?)

We may have to to that anyway at some point. If the "KVM compartment"
thing becomes real, we may have to end-up compiling both separately
(and jettison the one we don't need at runtime).

>> We already have checks around non-init symbols pointing to init 
>> symbols,
>> and I was wondering if we could reuse this for fun and profit...
> 
> I think objtool is the tool-of-the-future that can do this. You need
> something that believes everything behind has_vhe() is unreachable...

I need to educate myself about objtool. Seems to be the miracle cure
for a lot of ailments! ;-)

Anyway, I've now queued the series for 5.6.

          M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
