Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2FEC47247
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 17:16:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 691B1206E6
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 17:16:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="UdfGkBCa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 691B1206E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C592F4B361;
	Tue,  5 May 2020 13:16:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9HSdMURgnInA; Tue,  5 May 2020 13:16:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B58F64B37A;
	Tue,  5 May 2020 13:16:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96F664B36F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 13:16:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DE9zo-X-rAJS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 13:16:37 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E84C4B361
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 13:16:37 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id e26so3132230wmk.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 May 2020 10:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=j/K4PATbLRvXzOHJ5kuvFj7wv+7GxYy2AO2wgULDc48=;
 b=UdfGkBCaEekX1+Ogl521QElFibeK4JEuXmv+9Qyn1i1eO1zr1X48fFX03epvhY+IY6
 ndvidFnMb1LphudrcVRhoWifpNWD22iZNraDpuomYuRhOEn76EjZ3b9SSDCBtT8Y4GQ7
 jt6vabzBm6D8UD+o4kzd9GJibXajbtWD8IdhX9Lmgfrh0w0ORRwY8fXa2Ya6/ryu3evu
 SBcPxJ45+56nOeQDG0Egjl56sijaUTDF0SJfEaOmqBuxiSyv38xKB49H6095OwlH+Mad
 6s4qyd1ojEeGZwrkhd05xwnwU2rFCDNGqF17NcmacWdRCjdzQak93yG3czezNQwM0bZg
 /ISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=j/K4PATbLRvXzOHJ5kuvFj7wv+7GxYy2AO2wgULDc48=;
 b=SL0HjbvZVzaCGsmfrcd2RRjkfAHd7xS1ZPZGWXLvW1NMTs6L04Kz8tiiFhUdpkWy9g
 3RO/x8uaSHdgTip5BmRnVVYS4NOZpHRJ6XLXfEXv2858wA9BayRdpox/tAXrYK1Tm8BT
 9DORB8og13gERBOcQut9IlrcbygOB1aeR156NoVNL9Tj2Qcflrwz/fLAe0XrlmXL6mo3
 GRr1NDwUNeHJikF7SKhwa5ff0lOftGKRn7N52vHUp6jxK0Hnr4h8LVapM11BkDY0oUX0
 Pl1MHbD963v8W3mXIq1QiKBVSdS7SbdrO/ZRkLlxK9+PDCM4sHeEf+B3mr53yr+v5eUv
 rJgQ==
X-Gm-Message-State: AGi0Pubiz0bKJEMLvpF/XG/0VvXTH8oEIZXWav7JOGqK/1BkxnVtJm2K
 haw8ms4wDY+39feiBgIaQ+CoWA==
X-Google-Smtp-Source: APiQypLAF/GA9/GggAGCjJYWWbPUt/ZLtlJkLB0SJTpOIVPoR1ng5wPO0c9UIGGAGmCzyMuR7y9mNA==
X-Received: by 2002:a1c:3c87:: with SMTP id j129mr4234274wma.157.1588698996194; 
 Tue, 05 May 2020 10:16:36 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id z22sm4692812wma.20.2020.05.05.10.16.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 May 2020 10:16:35 -0700 (PDT)
Date: Tue, 5 May 2020 18:16:31 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 06/26] arm64: Add level-hinted TLB invalidation helper
Message-ID: <20200505171631.GC237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-7-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-7-maz@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

> +#define __tlbi_level(op, addr, level)					\
> +	do {								\
> +		u64 arg = addr;						\
> +									\
> +		if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&	\
> +		    level) {						\
> +			u64 ttl = level;				\
> +									\
> +			switch (PAGE_SIZE) {				\
> +			case SZ_4K:					\
> +				ttl |= 1 << 2;				\
> +				break;					\
> +			case SZ_16K:					\
> +				ttl |= 2 << 2;				\
> +				break;					\
> +			case SZ_64K:					\
> +				ttl |= 3 << 2;				\
> +				break;					\
> +			}						\
> +									\
> +			arg &= ~TLBI_TTL_MASK;				\
> +			arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);		\

Despite the spec saying both tables apply to TLB maintenance
instructions that do not apply to a range of addresses I think it only
means the 4-bit version (bug report to Arm, or I'm on the wrong spec).

This is consistent with Table D5-53 and the macro takes a single address
argument to make misuse with range based tlbi less likely.

It relies on the caller to get the level right and getting it wrong
could be pretty bad as the spec says all bets are off in that case. Is
it worth adding a check of the level against the address (seems a bit
involved), or that it is just 2 bits or adding a short doc comment to
explain it?

(Looks like we get some constants for the levels in a later patch that
could be referenced with some form of time travel)

> +		}							\
> +									\
> +		__tlbi(op,  arg);					\

cosmetic nit: double space in here
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
