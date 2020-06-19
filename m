Return-Path: <SRS0=kKHV=AA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62983C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Jun 2020 09:51:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3C8120773
	for <kvmarm@archiver.kernel.org>; Fri, 19 Jun 2020 09:51:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="FJ9xI3Wc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3C8120773
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46CEE4B194;
	Fri, 19 Jun 2020 05:51:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qqTISqMWSQRP; Fri, 19 Jun 2020 05:51:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4827E4B11A;
	Fri, 19 Jun 2020 05:51:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 826614B116
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 05:51:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id myRYYu4eOXbW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2020 05:51:23 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 799B84B0C8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 05:51:23 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id c3so9007751wru.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2020 02:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=LnPwgU2Ku49ZJqPfwVOOBQKnYQ6yhIFp57++bexGok8=;
 b=FJ9xI3Wc7r4gcCFA8b8VjMefoKs5sNRH3+a0+UgRIipP3eDy53lralSiPmJ2KKUFPg
 c8JE5injQrqn5LsaHztBYGk8O4wl0wTfZQ6+qhNUY9qhfFCkv8b1pnDv5iH18Xdm0WMi
 eKKFHQDAzU8UZiB0zYkRR1sUz5Gv/fxVnDv6KD3O75/BkpcJa/5+cnKfmquBjd4ldZ8H
 LJ8RPvIoEisWbDMTOmgvM92LnIDCMnfxSjjZWuGO3e2YkGQhBsChs0Lk1ivwcgtZLQDx
 bXA4SH/dgcKnh9hM7Rtsy7wMH4IVdnpAo8z8gw8PFBje6DFMogBezcJDiPBM088rzVZl
 vegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=LnPwgU2Ku49ZJqPfwVOOBQKnYQ6yhIFp57++bexGok8=;
 b=lcYEPM+TjzaufFOOtrTYPYWUX3hjr+VcSqy+wePpoJzCwjW5HPTygNmdUSnivPM602
 nRCDJJ6hsJyP/rnn/THoL21DYMNnmyFjuGQxkGg7+tIVUk9Eno0pKZ8bbrTqu9jeYplI
 M5PD0LL7Yb5d2tiXpE8D7IOk1J99HpBOIFOwz7nnBUR2IvNnP6diKTBcv5Mz8FkDJZDV
 8hNk/WRZw39AY3Qkw36qtWaX+aa1GV0dtzGCd8cbYNdvzb6bKL2PpIlRHb+KnS6zEmSy
 7mPeR9tOCb3/FDFyGxILucdk07ePr1msENIk5B94SoNzzNeqf7EAkNJi0Lu0D8pP0gpi
 eBhQ==
X-Gm-Message-State: AOAM5306eI61QJ24xCvCt7hyvMVNgaeLMa9w4M54+17Vx8DvZnBcFmWq
 oTI2V9VXMCYk7BA8hvgAAKB6yA==
X-Google-Smtp-Source: ABdhPJy/P5GyQ6zftQjFqjZk4Eo0bUBjfqGjrRHEc55ESeQvI7/VsuC7NR2YjKFzBIldf4CGa6pbQw==
X-Received: by 2002:a5d:67c8:: with SMTP id n8mr3139455wrw.343.1592560282184; 
 Fri, 19 Jun 2020 02:51:22 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:d994:d48b:4a9:7c2b])
 by smtp.gmail.com with ESMTPSA id n7sm6628302wrx.82.2020.06.19.02.51.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Jun 2020 02:51:21 -0700 (PDT)
Date: Fri, 19 Jun 2020 10:51:20 +0100
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 02/15] arm64: kvm: Move __smccc_workaround_1_smc to
 .rodata
Message-ID: <20200619095120.wenkbs5bl3wbyiyh@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
 <20200618122537.9625-3-dbrazdil@google.com>
 <02322fdac903aa1786c334d0ddd7f38a@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <02322fdac903aa1786c334d0ddd7f38a@kernel.org>
Cc: kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Hey Marc,

> > -	.popsection
> 
> I'd be tempted to leave the .popsection in place, if only for symmetry  with
> the initial .pushsection.

I removed it because other .S files don't pop either. It must have been added
here purely for the smccc workaround code. Happy to add it back if you prefer,
but the pushsection is removed later in the series, so this would disappear
as well.

> > +	.pushsection	.rodata
> > +	.global		__smccc_workaround_1_smc
> > +__smccc_workaround_1_smc:
> 
> You probably want to replace this with SYM_DATA_START (and SYM_DATA_END at
> the end).

Done

Thanks for reviewing,
David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
