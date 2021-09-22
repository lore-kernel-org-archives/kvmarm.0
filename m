Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34B6C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 09:34:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 486476126A
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 09:34:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 486476126A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9182D49E93;
	Wed, 22 Sep 2021 05:34:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RRmQMMi0jWVH; Wed, 22 Sep 2021 05:34:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78DFF40762;
	Wed, 22 Sep 2021 05:34:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EB6640642
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:34:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FgFRa-aj7Xrs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 05:34:48 -0400 (EDT)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com
 [209.85.167.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5652940413
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:34:48 -0400 (EDT)
Received: by mail-oi1-f169.google.com with SMTP id 24so3654374oix.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/C5mpNbBmoPckO9Tuag0+wSlj6t5R7giav+EX45XDOs=;
 b=eHUe3bWDDn4qkPUZo4L4Z0fcAsB9+J9fwawyvO20NlVVljHF5Dtyq9mp40XzuCfugU
 NHEckbfbiVwqEWpnfEPq8bTt1o37LWXNGtrqfr0sFfYNgS8h8tWThWGcTQci4jAos33h
 n6Rkq9dFWSiwcS4K93c93eBqCfSRWtyHNFtUdbY9NhzsAtomPXkjDbXP75bohHWU5UKH
 kmPOTplel3Q/Av0SQdbKvDCGPHWq72z8LXny4D7Yp4kmDD+CCc+jkvB8PvBI5ZFiBmOC
 DnG/42K+/Kdmy0ACKkEn36FZY/SgTJaP857A2cCbQt5wvhCIh0HENe/1hFreclaSwL32
 rF1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/C5mpNbBmoPckO9Tuag0+wSlj6t5R7giav+EX45XDOs=;
 b=hczl6GnlKckq3u7JjIeuxVCPwp+U73sErNfH5Nt5N9KW+j1m1rCc6cTOlaVUGJkqIV
 L77A+jYzEteqPeKOFcQO/eQRq5rhFoNBT2dZNsllXSx9/J/Lf8uknzoOaA9bSkOfBp6Y
 rlqluoAjmpkU0RuwdWDa6RUz1eu4CvB+bCnqdfFOO6U8e4eV1Lt6WQgOEWh1qXhw/z+2
 53Qvor6FNKgkUFEc5lw8mmd+Wcl8Qo/hZZV72h3VdCwnZ9l0ya1AyyMMtfdeykns7yAg
 cEM60jCI0R56fFieUkMFyr9hs7+2FclfByZgZRlBAu4qnenb8sIUt6WHv2r0qJKTw7Y1
 rgrA==
X-Gm-Message-State: AOAM532sYrvs25H88hqKtaANDl+csUanPy7PhT667aJ3Oih/wbx7GkPE
 w9M9JxnDa6pYV7RFONimGewtEVp5ApFzADOA7nWlyA==
X-Google-Smtp-Source: ABdhPJw2dFdgLvXM1SuivMLDkuM1fFDGcYbJFC1w6JcFr8gg6Ni02AGH23NLtCL/i+T7xPsvIBHzYOWc2NbQAOc7svQ=
X-Received: by 2002:aca:604:: with SMTP id 4mr265229oig.8.1632303287537; Wed,
 22 Sep 2021 02:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
 <20210827101609.2808181-3-tabba@google.com>
 <20210908123837.exyhsn6t2c7nmbox@gator>
In-Reply-To: <20210908123837.exyhsn6t2c7nmbox@gator>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 22 Sep 2021 10:34:11 +0100
Message-ID: <CA+EHjTx+Rfd4UXvNPnL8siGfM=7PuWxCtKuWOGDRyMqEQKgxPw@mail.gmail.com>
Subject: Re: [PATCH v5 2/8] KVM: arm64: Add missing field descriptor for
 MDCR_EL2
To: Andrew Jones <drjones@redhat.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Andrew,

On Wed, Sep 8, 2021 at 1:38 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 27, 2021 at 11:16:03AM +0100, Fuad Tabba wrote:
> > It's not currently used. Added for completeness.
> >
> > No functional change intended.
> >
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 327120c0089f..a39fcf318c77 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -295,6 +295,7 @@
> >  #define MDCR_EL2_HPMFZO              (UL(1) << 29)
> >  #define MDCR_EL2_MTPME               (UL(1) << 28)
> >  #define MDCR_EL2_TDCC                (UL(1) << 27)
> > +#define MDCR_EL2_HLP         (UL(1) << 26)
> >  #define MDCR_EL2_HCCD                (UL(1) << 23)
> >  #define MDCR_EL2_TTRF                (UL(1) << 19)
> >  #define MDCR_EL2_HPMD                (UL(1) << 17)
> > --
> > 2.33.0.259.gc128427fd7-goog
> >
>
> If we're proactively adding bits per the most recent spec, then I guess we
> could also add HPMFZS (bit 36). Otherwise,

Seems someone has beaten me to it. HPMFZS is in 5.15-rc2 at least
(which I'm going to be rebasing on/respinning).

Thanks,
/fuad

>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
