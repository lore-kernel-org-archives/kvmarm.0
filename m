Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B17C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 14:28:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B92023127
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 14:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B92023127
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DF214B56D;
	Mon, 25 Jan 2021 09:28:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o83LC6G03mbD; Mon, 25 Jan 2021 09:28:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D485D4B5DD;
	Mon, 25 Jan 2021 09:28:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0F074B5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 09:28:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rPlfPREXCnV7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 09:28:51 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D49054B56D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 09:28:50 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AC6BE23121;
 Mon, 25 Jan 2021 14:28:49 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l42rH-009tNN-FP; Mon, 25 Jan 2021 14:28:47 +0000
MIME-Version: 1.0
Date: Mon, 25 Jan 2021 14:28:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v5 18/21] arm64: Move "nokaslr" over to the early
 cpufeature infrastructure
In-Reply-To: <CAMj1kXGTu8AtMnm7NxB8M2xFuXHSKzAx2hjjeaAW2v-usvavVQ@mail.gmail.com>
References: <20210125105019.2946057-1-maz@kernel.org>
 <20210125105019.2946057-19-maz@kernel.org>
 <CAMj1kXFcc+0At5+9Keo1MF=TeGE9-eOHtSpK7yVy5jzwXt6KCA@mail.gmail.com>
 <3a98ff1db79c90c96038b924eb534643@kernel.org>
 <CAMj1kXGTu8AtMnm7NxB8M2xFuXHSKzAx2hjjeaAW2v-usvavVQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <32b49beb87b25303d71fd2f7053c7959@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ardb@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, jingzhangos@google.com,
 pajay@qti.qualcomm.com, psodagud@codeaurora.org, sramana@codeaurora.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Ajay Patil <pajay@qti.qualcomm.com>,
 Android Kernel Team <kernel-team@android.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On 2021-01-25 14:19, Ard Biesheuvel wrote:
> On Mon, 25 Jan 2021 at 14:54, Marc Zyngier <maz@kernel.org> wrote:
>> 
>> On 2021-01-25 12:54, Ard Biesheuvel wrote:

[...]

>> > This struct now takes up
>> > - ~100 bytes for the characters themselves (which btw are not emitted
>> > into __initdata or __initconst)
>> > - 6x8 bytes for the char pointers
>> > - 6x24 bytes for the RELA relocations that annotate these pointers as
>> > quantities that need to be relocated at boot (on a kernel built with
>> > KASLR)
>> >
>> > I know it's only a drop in the ocean, but in this case, where the
>> > struct is statically declared and defined only once, and in the same
>> > place, we could easily turn this into
>> >
>> > static const struct {
>> >    char alias[24];
>> >    char param[20];
>> > };
>> >
>> > and get rid of all the overhead. The only slightly annoying thing is
>> > that the array sizes need to be kept in sync with the largest instance
>> > appearing in the array, but this is easy when the struct type is
>> > declared in the same place where its only instance is defined.
>> 
>> Fair enough. I personally find the result butt-ugly, but I agree
>> that it certainly saves some memory. Does the following work for
>> you? I can even give symbolic names to the various constants (how
>> generous of me! ;-).
>> 
> 
> To be honest, I was anticipating more of a discussion, but this looks
> reasonable to me.

It looked like a reasonable ask: all the strings are completely useless
once the kernel has booted, and I'm the first to moan that I can't boot
an arm64 kernel with less than 60MB of RAM (OK, it's a pretty bloated
kernel...).

> Does 'char    feature[80];' really need 80 bytes though?

It really needs 75 bytes, because of this:

	{ "arm64.nopauth",
	  "id_aa64isar1.gpi=0 id_aa64isar1.gpa=0 "
	  "id_aa64isar1.api=0 id_aa64isar1.apa=0"	   },

80 is a round enough number.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
