Return-Path: <SRS0=pXP7=GJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0AEC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 09:03:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 784F92310A
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 09:03:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 784F92310A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D14EC4B345;
	Wed,  6 Jan 2021 04:03:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OLBGDurgsJ9T; Wed,  6 Jan 2021 04:03:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C3794B348;
	Wed,  6 Jan 2021 04:03:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99E8D4B33D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 04:03:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uzEzPMqwotZx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jan 2021 04:03:51 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A25D4B31E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 04:03:51 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 29FDA2310A;
 Wed,  6 Jan 2021 09:03:50 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kx4jM-005bCS-0P; Wed, 06 Jan 2021 09:03:48 +0000
MIME-Version: 1.0
Date: Wed, 06 Jan 2021 09:03:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 11/17] arm64: cpufeature: Add an early command-line
 cpufeature override facility
In-Reply-To: <CAAdAUtjNiBACFbxp-0x_ar9RcnFDkiSoGqOn0XKiwtJAd3qCHg@mail.gmail.com>
References: <20210104135011.2063104-1-maz@kernel.org>
 <20210104135011.2063104-12-maz@kernel.org>
 <CAAdAUtjNiBACFbxp-0x_ar9RcnFDkiSoGqOn0XKiwtJAd3qCHg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <90dccfccbfdfa8abb05716c2572af9ca@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jingzhangos@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com, catalin.marinas@arm.com,
 will@kernel.org, ardb@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-06 02:16, Jing Zhang wrote:
> On Mon, Jan 4, 2021 at 8:20 AM Marc Zyngier <maz@kernel.org> wrote:

[...]

>> +static __init void parse_cmdline(void)
>> +{
>> +       if (!IS_ENABLED(CONFIG_CMDLINE_FORCE)) {
>> +               const u8 *prop;
>> +               void *fdt;
>> +               int node;
>> +
>> +               fdt = get_early_fdt_ptr();
>> +               if (!fdt)
>> +                       goto out;
>> +
>> +               node = fdt_path_offset(fdt, "/chosen");
>> +               if (node < 0)
>> +                       goto out;
>> +
>> +               prop = fdt_getprop(fdt, node, "bootargs", NULL);
>> +               if (!prop)
>> +                       goto out;
>> +
>> +               match_options(prop);
>> +
>> +               if (!IS_ENABLED(CONFIG_CMDLINE_EXTEND))
>> +                       return;
>> +       }
>> +
>> +out:
>> +       match_options(CONFIG_CMDLINE);
>> +}
>> +
>> +void __init init_shadow_regs(void)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < ARRAY_SIZE(regs); i++) {
>> +               if (regs[i]->val)
>> +                       *regs[i]->val  = 0;
>> +               if (regs[i]->mask)
>> +                       *regs[i]->mask = 0;
>> +       }
>> +
>> +       parse_cmdline();
>> +
>> +       for (i = 0; i < ARRAY_SIZE(regs); i++) {
>> +               if (regs[i]->val)
>> +                       __flush_dcache_area(regs[i]->val, 
>> sizeof(*regs[i]->val));
>> +               if (regs[i]->mask)
>> +                       __flush_dcache_area(regs[i]->mask, 
>> sizeof(*regs[i]->mask));
>> +       }
> Could you shed some light on the usage of __flush_dcache_area here? 
> Thanks.

Some of this data gets used by secondary CPUs when they have their
MMU off. If we don't clean to the PoC, they will miss the updates
and things will randomly fail.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
