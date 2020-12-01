Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EA0C64E7B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:58:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 816D52168B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:58:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="kNQC3DHq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 816D52168B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A52744C165;
	Tue,  1 Dec 2020 08:58:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P8xxF1NBV7Vo; Tue,  1 Dec 2020 08:58:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A996B4BEAD;
	Tue,  1 Dec 2020 08:58:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F054BEAD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:58:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id twWG70ML9KWL for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 08:58:42 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 802DC4BEAC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:58:42 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id 23so2756575wrc.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Dec 2020 05:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Zt2RBjQQsixvf0OIS3lOKNTVHIXpo1Ycgu9q/WItOOU=;
 b=kNQC3DHqR4eA7lOiYZdlSgTkBybeYpTQTxmLdgRX7PhlUu58f/ZAMVICVZQH2fZdtk
 ZWhvbE8UMd+kryPj/PhfbhrFc75A9Iz0yHHF3v2cQjnoQ8w4cecIbOCd9Tla8Ok9ZBXp
 79TjQOwFXJZ/A9pd5mKgjghHBTGlEW3epSl/NEjIZVVmZdRSDbSFcYbyU9qd67Q80VUC
 vFmK2jjHZZAQdzNscAej4hLKUyvhDTh8dPWiuuNHh35dPbNUqYre7W2syUO/MXLPdXnw
 eJm/2T5RDcL2vfaXuOI53We9gOmSndVPxz2Lq5JjcEPyqUaR3I3QM6IFmyUIWRto58vS
 hc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Zt2RBjQQsixvf0OIS3lOKNTVHIXpo1Ycgu9q/WItOOU=;
 b=Y7BKW2SJh1jdNZCaRehd+KEtBPl1ocm25YTAx4bJPKz+5QMR6w/7Z/lapzfJAUinQm
 /jdoBuw4mEbR+dYafFWWUWO+5AvXj8+ZZIkmGGN7SBHveTS+wIQEfV7WegPCP78jikk6
 RV6gSPb/5UXkmqJK6RY70eL62O/nanwpE/BBxV7kJQrjObs3kbBC/HncF+gbW2BqnwOA
 QR5Q1otyQfPAYmfWcqcKblAKrekzDT2IeafsbWH4wsUerzYYIQtR6uXXBf52awkZrO4F
 SjOaMji2onEcTR/+9vz87z50DJ5xgXJGh94/mQt84p3wTnAEWPU4/iKpK5yXBlFHvD66
 WnJA==
X-Gm-Message-State: AOAM532YlQOZArhiIDpMlWLvrStP8yJO6IS2I0D8FBTeyUfH9BHc3L+o
 njM1/AoEHx7dS6+BWOKueDY7Hw==
X-Google-Smtp-Source: ABdhPJyjTWVeFjDHUebqh352sK8hzDxuE5qee5pt97DkoN08upPYHvQfL+XqSsDLjMEAA2ajaICJuQ==
X-Received: by 2002:adf:fa05:: with SMTP id m5mr4047848wrr.26.1606831121268;
 Tue, 01 Dec 2020 05:58:41 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:7c5f:5ab5:ac1f:89ce])
 by smtp.gmail.com with ESMTPSA id v7sm3162739wma.26.2020.12.01.05.58.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Dec 2020 05:58:40 -0800 (PST)
Date: Tue, 1 Dec 2020 13:58:39 +0000
From: David Brazdil <dbrazdil@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 04/23] arm64: Move MAIR_EL1_SET to asm/memory.h
Message-ID: <20201201135839.jsvplmeodjzsa4he@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-5-dbrazdil@google.com>
 <20201126173534.GE38486@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201126173534.GE38486@C02TD0UTHF1T.local>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hey Mark,

> > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > index cd61239bae8c..54a22cb5b17b 100644
> > --- a/arch/arm64/include/asm/memory.h
> > +++ b/arch/arm64/include/asm/memory.h
> > @@ -152,6 +152,19 @@
> >  #define MT_S2_FWB_NORMAL	6
> >  #define MT_S2_FWB_DEVICE_nGnRE	1
> >  
> > +/*
> > + * Default MAIR_ELx. MT_NORMAL_TAGGED is initially mapped as Normal memory and
> > + * changed during __cpu_setup to Normal Tagged if the system supports MTE.
> > + */
> > +#define MAIR_ELx_SET							\
> > +	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
> 
> Patch 7 initializes MAIR_EL2 with this directly rather than copying it
> from MAIR_EL1, which means that MT_NORMAL_TAGGED will never be tagged
> within the nVHE hyp code.
> 
> Is that expected? I suspect it's worth a comment here (introduced in
> patch 7), just to make that clear.

Ouch, that didn't use to be there. In that case let's not build more implicit
assumptions into the code. I'll pass MAIR_EL1 in kvm_nvhe_init_params.

David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
