Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548A5C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 13:55:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF8E922C9E
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 13:55:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF8E922C9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E623A4B60B;
	Mon, 25 Jan 2021 08:55:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XTrV3O8LAD47; Mon, 25 Jan 2021 08:55:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8451D4B5C5;
	Mon, 25 Jan 2021 08:55:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FFCB4B4A8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 08:54:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1lfYdbO7z2Pu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 08:54:58 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F4444B3A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 08:54:58 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2788822B3B;
 Mon, 25 Jan 2021 13:54:57 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l42KU-009t4p-SC; Mon, 25 Jan 2021 13:54:55 +0000
MIME-Version: 1.0
Date: Mon, 25 Jan 2021 13:54:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v5 18/21] arm64: Move "nokaslr" over to the early
 cpufeature infrastructure
In-Reply-To: <CAMj1kXFcc+0At5+9Keo1MF=TeGE9-eOHtSpK7yVy5jzwXt6KCA@mail.gmail.com>
References: <20210125105019.2946057-1-maz@kernel.org>
 <20210125105019.2946057-19-maz@kernel.org>
 <CAMj1kXFcc+0At5+9Keo1MF=TeGE9-eOHtSpK7yVy5jzwXt6KCA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <3a98ff1db79c90c96038b924eb534643@kernel.org>
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

On 2021-01-25 12:54, Ard Biesheuvel wrote:
> On Mon, 25 Jan 2021 at 11:53, Marc Zyngier <maz@kernel.org> wrote:
>> 
>> Given that the early cpufeature infrastructure has borrowed quite
>> a lot of code from the kaslr implementation, let's reimplement
>> the matching of the "nokaslr" option with it.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> Acked-by: David Brazdil <dbrazdil@google.com>
>> ---
>>  arch/arm64/kernel/idreg-override.c | 15 +++++++++++++
>>  arch/arm64/kernel/kaslr.c          | 36 
>> ++----------------------------
>>  2 files changed, 17 insertions(+), 34 deletions(-)
>> 
>> diff --git a/arch/arm64/kernel/idreg-override.c 
>> b/arch/arm64/kernel/idreg-override.c
>> index cbb8eaa48742..3ccf51b84ba4 100644
>> --- a/arch/arm64/kernel/idreg-override.c
>> +++ b/arch/arm64/kernel/idreg-override.c
>> @@ -31,8 +31,22 @@ static const struct ftr_set_desc mmfr1 __initdata = 
>> {
>>         },
>>  };
>> 
>> +extern struct arm64_ftr_override kaslr_feature_override;
>> +
>> +static const struct ftr_set_desc kaslr __initdata = {
> 
> This should be __initconst not __initdata (below too)
> 
>> +       .name           = "kaslr",
>> +#ifdef CONFIG_RANDOMIZE_BASE
>> +       .override       = &kaslr_feature_override,
>> +#endif
>> +       .fields         = {
>> +               { "disabled", 0 },
>> +               {}
>> +       },
>> +};
>> +
>>  static const struct ftr_set_desc * const regs[] __initdata = {
>>         &mmfr1,
>> +       &kaslr,
>>  };
>> 
>>  static const struct {
>> @@ -41,6 +55,7 @@ static const struct {
>>  } aliases[] __initdata = {
>>         { "kvm-arm.mode=nvhe",          "id_aa64mmfr1.vh=0" },
>>         { "kvm-arm.mode=protected",     "id_aa64mmfr1.vh=0" },
>> +       { "nokaslr",                    "kaslr.disabled=1" },
>>  };
>> 
> 
> This struct now takes up
> - ~100 bytes for the characters themselves (which btw are not emitted
> into __initdata or __initconst)
> - 6x8 bytes for the char pointers
> - 6x24 bytes for the RELA relocations that annotate these pointers as
> quantities that need to be relocated at boot (on a kernel built with
> KASLR)
> 
> I know it's only a drop in the ocean, but in this case, where the
> struct is statically declared and defined only once, and in the same
> place, we could easily turn this into
> 
> static const struct {
>    char alias[24];
>    char param[20];
> };
> 
> and get rid of all the overhead. The only slightly annoying thing is
> that the array sizes need to be kept in sync with the largest instance
> appearing in the array, but this is easy when the struct type is
> declared in the same place where its only instance is defined.

Fair enough. I personally find the result butt-ugly, but I agree
that it certainly saves some memory. Does the following work for
you? I can even give symbolic names to the various constants (how
generous of me! ;-).

Thanks,

         M.

diff --git a/arch/arm64/kernel/idreg-override.c 
b/arch/arm64/kernel/idreg-override.c
index d1310438d95c..9e7043bdc808 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -14,15 +14,15 @@
  #include <asm/setup.h>

  struct ftr_set_desc {
-	const char 			*name;
+	char 				name[20];
  	struct arm64_ftr_override	*override;
  	struct {
-		const char 		*name;
+		char			name[20];
  		u8			shift;
  	} 				fields[];
  };

-static const struct ftr_set_desc mmfr1 __initdata = {
+static const struct ftr_set_desc mmfr1 __initconst = {
  	.name		= "id_aa64mmfr1",
  	.override	= &id_aa64mmfr1_override,
  	.fields		= {
@@ -31,7 +31,7 @@ static const struct ftr_set_desc mmfr1 __initdata = {
  	},
  };

-static const struct ftr_set_desc pfr1 __initdata = {
+static const struct ftr_set_desc pfr1 __initconst = {
  	.name		= "id_aa64pfr1",
  	.override	= &id_aa64pfr1_override,
  	.fields		= {
@@ -40,7 +40,7 @@ static const struct ftr_set_desc pfr1 __initdata = {
  	},
  };

-static const struct ftr_set_desc isar1 __initdata = {
+static const struct ftr_set_desc isar1 __initconst = {
  	.name		= "id_aa64isar1",
  	.override	= &id_aa64isar1_override,
  	.fields		= {
@@ -54,7 +54,7 @@ static const struct ftr_set_desc isar1 __initdata = {

  extern struct arm64_ftr_override kaslr_feature_override;

-static const struct ftr_set_desc kaslr __initdata = {
+static const struct ftr_set_desc kaslr __initconst = {
  	.name		= "kaslr",
  #ifdef CONFIG_RANDOMIZE_BASE
  	.override	= &kaslr_feature_override,
@@ -65,7 +65,7 @@ static const struct ftr_set_desc kaslr __initdata = {
  	},
  };

-static const struct ftr_set_desc * const regs[] __initdata = {
+static const struct ftr_set_desc * const regs[] __initconst = {
  	&mmfr1,
  	&pfr1,
  	&isar1,
@@ -73,9 +73,9 @@ static const struct ftr_set_desc * const regs[] 
__initdata = {
  };

  static const struct {
-	const char	*alias;
-	const char	*feature;
-} aliases[] __initdata = {
+	char	alias[30];
+	char	feature[80];
+} aliases[] __initconst = {
  	{ "kvm-arm.mode=nvhe",		"id_aa64mmfr1.vh=0" },
  	{ "kvm-arm.mode=protected",	"id_aa64mmfr1.vh=0" },
  	{ "arm64.nobti",		"id_aa64pfr1.bt=0" },

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
