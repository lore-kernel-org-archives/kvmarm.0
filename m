Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FABC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:18:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C3AC64F53
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:18:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C3AC64F53
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 031184B1DA;
	Thu,  4 Feb 2021 09:18:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vSifH4l5yeGc; Thu,  4 Feb 2021 09:18:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F31BE4B1E2;
	Thu,  4 Feb 2021 09:18:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 012504B1E2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:18:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3XD0bmPJJphO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 09:18:46 -0500 (EST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCE164B1DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:18:45 -0500 (EST)
Received: by mail-wr1-f50.google.com with SMTP id d16so3644152wro.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 06:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=1A5jaGMH8v+8RmdU0UTE1kbhV4vjjan/ogFcu70QFBM=;
 b=kRbGsvSTuji0iv5YtpH4MYYQqNnFddgufEy4QsAH7R2fLfOK7onqaAUtIbALHOKYnc
 NAEQ9am67BI4JNDLRDj0tSJ5nfUszcCN6tSuhpwWcque/KXCX4cfDO0U8JK43+dsj+vx
 1Y2kxvNZSdfgt2n4gKlVaxpCgAK0iZg3HekpS3oJRCfDdxiInXL1wH/eS5ZTRCsd5C47
 zoHUZ9lKr0b9hqj1r4cvMY40hRG5umkYAWcWVgdL1nqFt4TxFku5KNI0DDFSqHDOJQ29
 ENRRELa3ERiq5FgRUFXRNakDuEhpvvsXdHWHvn6eCuVv5LdB57u6hIYKryT8KZJ0fgD4
 sj1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1A5jaGMH8v+8RmdU0UTE1kbhV4vjjan/ogFcu70QFBM=;
 b=kXlyj5QhkWsCV1PByFrOJDZY1YTI62sZZYMxquv6kjWGpEQHZKrosOYMEuP1K4mn6u
 n/mttCmOoZuUjqqbSY7XNy9/XUfn1JUqXdWkUES/m9vXvI0n/6tkmQwbEKRoqBhijutT
 LGnssWxi5PT+/7Bw+A4y8aTD54N4CYycE2YNntxpm/mhZuZpOVJO4gE15vDwYTo1cRFt
 AAfZ7RA7wbpQbfoxIOYVyS00d7MaPzuAVtkoBFQX/FT+ruIesfhErzS4QqM/TyzMYCVn
 rTo+tjw4F0Icc20qjagjjLFEL7Ctx5oGZKLu0KooMyYlUiOtMUxLHT+GYrc82+2eJj1A
 Nofw==
X-Gm-Message-State: AOAM531HW2yeloX4C02xNzlgCfBOS+uujPATVVlplE1Z4u6BOqmPzmdW
 a40VIPxMJywI52khudHdQae/Lg==
X-Google-Smtp-Source: ABdhPJwmxlEADo2pamrd4+uG+uA5gIHQiPMR8XnPrPRMCr82leKGAKYaVIlc3piIwQdzJpEdnxUfkQ==
X-Received: by 2002:adf:9148:: with SMTP id j66mr10034560wrj.28.1612448324809; 
 Thu, 04 Feb 2021 06:18:44 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id 35sm9159761wrn.42.2021.02.04.06.18.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 06:18:43 -0800 (PST)
Date: Thu, 4 Feb 2021 14:18:41 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 23/26] KVM: arm64: Refactor __populate_fault_info()
Message-ID: <YBwCQVi2JUxKUy9Y@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-24-qperret@google.com>
 <20210203155831.GG18974@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210203155831.GG18974@willie-the-truck>
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Wednesday 03 Feb 2021 at 15:58:32 (+0000), Will Deacon wrote:
> On Fri, Jan 08, 2021 at 12:15:21PM +0000, Quentin Perret wrote:
> > Refactor __populate_fault_info() to introduce __get_fault_info() which
> > will be used once the host is wrapped in a stage 2.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 36 +++++++++++++++----------
> >  1 file changed, 22 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 84473574c2e7..e9005255d639 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -157,19 +157,9 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
> >  	return true;
> >  }
> >  
> > -static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
> > +static inline bool __get_fault_info(u64 esr, u64 *far, u64 *hpfar)
> 
> Could this take a pointer to a struct kvm_vcpu_fault_info instead?

The disr_el1 field will be unused in this case, but yes, that should
work.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
