Return-Path: <SRS0=LYeO=HB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FF4C433E0
	for <kvmarm@archiver.kernel.org>; Sat, 30 Jan 2021 12:16:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3370864E0E
	for <kvmarm@archiver.kernel.org>; Sat, 30 Jan 2021 12:16:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3370864E0E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 826B84B315;
	Sat, 30 Jan 2021 07:16:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O0SvhwASKsIO; Sat, 30 Jan 2021 07:16:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65E574B320;
	Sat, 30 Jan 2021 07:16:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3D94B315
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Jan 2021 07:16:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kgH9DBbeMd4g for <kvmarm@lists.cs.columbia.edu>;
 Sat, 30 Jan 2021 07:16:44 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 243694B312
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Jan 2021 07:16:44 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CE8A564E06;
 Sat, 30 Jan 2021 12:16:42 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l5pBA-00Ayge-MI; Sat, 30 Jan 2021 12:16:40 +0000
MIME-Version: 1.0
Date: Sat, 30 Jan 2021 12:16:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 4/8] KVM: arm64: Generate hyp relocation data
In-Reply-To: <20210129214325.GA195322@roeck-us.net>
References: <20210105180541.65031-1-dbrazdil@google.com>
 <20210105180541.65031-5-dbrazdil@google.com>
 <20210129214325.GA195322@roeck-us.net>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <a2c65d97fb924bd78aae3cf5659c9adc@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linux@roeck-us.net, dbrazdil@google.com,
 kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org, james.morse@arm.com,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, ardb@kernel.org,
 julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
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

Hi Guenter,

Thanks a lot for the heads up.

On 2021-01-29 21:43, Guenter Roeck wrote:
> Hi,
> 
> On Tue, Jan 05, 2021 at 06:05:37PM +0000, David Brazdil wrote:
>> Add a post-processing step to compilation of KVM nVHE hyp code which
>> calls a custom host tool (gen-hyprel) on the partially linked object
>> file (hyp sections' names prefixed).
>> 
>> The tool lists all R_AARCH64_ABS64 data relocations targeting hyp
>> sections and generates an assembly file that will form a new section
>> .hyp.reloc in the kernel binary. The new section contains an array of
>> 32-bit offsets to the positions targeted by these relocations.
>> 
>> Since these addresses of those positions will not be determined until
>> linking of `vmlinux`, each 32-bit entry carries a R_AARCH64_PREL32
>> relocation with addend <section_base_sym> + <r_offset>. The linker of
>> `vmlinux` will therefore fill the slot accordingly.
>> 
>> This relocation data will be used at runtime to convert the kernel VAs
>> at those positions to hyp VAs.
>> 
>> Signed-off-by: David Brazdil <dbrazdil@google.com>
> 
> This patch results in the following error for me.
> 
> error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: assertion
> elf.ehdr->e_ident[5] == 1 failed (lhs=2, rhs=1, line=250)
> 
> The problem is seen when trying to build aarch64 images in big endian
> mode.

Ah, big-endian. of course, the ELF header is in native endianness,
and the sanity checks explode (still much better than generating crap).

I'll have a look shortly. It shouldn't too hard to fix, just a
bit invasive...

Thanks again,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
