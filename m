Return-Path: <SRS0=SHHE=UG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3A9C28CC3
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 06:00:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED24020825
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 06:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I+DO+bXX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED24020825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B4454A380;
	Fri,  7 Jun 2019 02:00:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wzWH9QNWTMqB; Fri,  7 Jun 2019 02:00:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 225404A4DF;
	Fri,  7 Jun 2019 02:00:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D88F44A4DF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 02:00:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UByEq5qOKXuG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jun 2019 02:00:42 -0400 (EDT)
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com
 [209.85.214.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AFA874A380
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jun 2019 02:00:42 -0400 (EDT)
Received: by mail-pl1-f195.google.com with SMTP id s24so393530plr.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Jun 2019 23:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=sNeYqqj7A5jsZjI23KJv1FicJVOUSHOJooPoBup8FeM=;
 b=I+DO+bXX3/U0c5/tJe9YZdOfd9awmUKsKrvLQ6RM5e7ZPbpVdNQ6p467NhbVoMoarQ
 ZTrXnuYi/GBo+EETAJBGN7Pbc4eyxedjJgINnFW2Ljv5sN9z7vOHs6OG+Gfjx+nUFata
 r/SNJ3fb38yconRfVgfs5zO505iUUyDV4G/jHwXknqC1Y7Z1U8rC0v+rvDJyZqa/2SDY
 dFJFBnKgq948wzi26ZcXJ+LY/RNrc3C7DV8bcYap3C5SQTdSlGOwcqCDiElfo5zU+Fni
 UXim+fepv1U8X+0j4guVpm6nZtJBCDBnu6scNE5hLkz6jskKt97gH5ftrO8QkfNEvFqD
 KgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=sNeYqqj7A5jsZjI23KJv1FicJVOUSHOJooPoBup8FeM=;
 b=ArK6EcQk65+wuJTyyZ3GFCmoY159yJA7aH9S6ZAeu3OiKJ521bnAk5HJwY3D58YXWO
 U7AGXoJE18thyKAkDL2HH1JrVpDKhkVcAYGnHX/TJdHE8EldzDkXZNIfKNG2wzSm3B1E
 wOQBy9BGMz5L5rnT0i5HNib3DARB9fJMNf83ZHft5W3aGR8JRcvVcuPE5H8Win3bKjj+
 0XmAfXux79ZOhGd36zKmnUdx/QXoNVf6lBm3TerEMSPUxqUn6mkgv8PMACzW9lTYkpst
 CH3ScZPFRELVlWzlYyB5lyxPHgD9ViM3ldsYuxbe+UkJE0WHpYdOuGzhvhWHlrn6BFMp
 ItXg==
X-Gm-Message-State: APjAAAWC/MzykSMXh9h3bnYDNm47p4yf76rTbzQiso1BbxFJM1f9rekj
 KbOG8ftcBeLVHNaJlTBlmzSU3A==
X-Google-Smtp-Source: APXvYqxOAWcArkn2cVZZlioTLt/qQbVmliWaDP7qBUla76loZRkDUMwoTY7MzTYQenlQtRiEFq12yQ==
X-Received: by 2002:a17:902:6a4:: with SMTP id
 33mr53039518plh.338.1559887241528; 
 Thu, 06 Jun 2019 23:00:41 -0700 (PDT)
Received: from localhost ([122.172.66.84])
 by smtp.gmail.com with ESMTPSA id s42sm1593160pjc.5.2019.06.06.23.00.39
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Thu, 06 Jun 2019 23:00:40 -0700 (PDT)
Date: Fri, 7 Jun 2019 11:30:37 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] KVM: arm64: Drop 'const' from argument of vq_present()
Message-ID: <20190607060037.eaof3hllyombxlhc@vireshk-i7>
References: <699121e5c938c6f4b7b14a7e2648fa15af590a4a.1559623368.git.viresh.kumar@linaro.org>
 <20190604095915.GW28398@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190604095915.GW28398@e103592.cambridge.arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

On 04-06-19, 10:59, Dave Martin wrote:
> On Tue, Jun 04, 2019 at 10:13:19AM +0530, Viresh Kumar wrote:
> > We currently get following compilation warning:
> > 
> > arch/arm64/kvm/guest.c: In function 'set_sve_vls':
> > arch/arm64/kvm/guest.c:262:18: warning: passing argument 1 of 'vq_present' from incompatible pointer type
> > arch/arm64/kvm/guest.c:212:13: note: expected 'const u64 (* const)[8]' but argument is of type 'u64 (*)[8]'
> > 
> > The argument can't be const, as it is copied at runtime using
> > copy_from_user(). Drop const from the prototype of vq_present().
> > 
> > Fixes: 9033bba4b535 ("KVM: arm64/sve: Add pseudo-register for the guest's vector lengths")
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  arch/arm64/kvm/guest.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 3ae2f82fca46..78f5a4f45e0a 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -209,7 +209,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
> >  
> >  static bool vq_present(
> > -	const u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
> > +	u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
> >  	unsigned int vq)
> >  {
> >  	return (*vqs)[vq_word(vq)] & vq_mask(vq);
> 
> Ack, but maybe this should just be converted to a macro?

I will send a patch with that if that's what you want.

Thanks.

-- 
viresh
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
