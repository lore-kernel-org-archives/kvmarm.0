Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E04C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Dec 2021 09:37:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ECEA49EF9;
	Tue, 28 Dec 2021 04:37:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i8++3-MrDak3; Tue, 28 Dec 2021 04:37:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67A2649EC0;
	Tue, 28 Dec 2021 04:37:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 212D749E17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 04:37:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UsXNg70SQD1D for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Dec 2021 04:37:53 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BAEF49B13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 04:37:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640684272;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=8UNaWMcu6LyEF1PGvetsyJ0a6lkdnxNspgKA2bFoUeA=;
 b=J0wXCLeBIebNTmjttL0b9Jv5sjqAhmuxswumv6gwuClJVF1+Uxz0q8NEcXvx10NZLB184V
 7geP1yKykmvG7SVH3E1IkG0tJpBBGQ6bk7YPhifdnnwG1VHE1dJP8MLncHSL+x5uR0lV3Y
 BGVu61307N7VYlEeTPNShMBFhvuH9KQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-KGKp0gWFO6azipG5SnrgOA-1; Tue, 28 Dec 2021 04:37:51 -0500
X-MC-Unique: KGKp0gWFO6azipG5SnrgOA-1
Received: by mail-ed1-f71.google.com with SMTP id
 g2-20020a056402424200b003f8ee03207eso5929980edb.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 01:37:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8UNaWMcu6LyEF1PGvetsyJ0a6lkdnxNspgKA2bFoUeA=;
 b=2lsREWWANjsvhzMletlWNJG1dLigOAjVbBHdyKs0FGOwO/IVM8q3jycKPduBX5N1u+
 cOc21Du0f4Px7c0km0VUrlHa2vPABG2eJLFnsv9IEZg3YeqLkNsDLBUtUIfwQm+d2Y6J
 hfumJAk1/0Ynpe2E3tdq1A4v/b0Z/jdwI0DuLTgTbn6TXRt3672V8KHJuQsE6Z0ivUC6
 rkhiDLXgyyTe/dAIEFnDNbpqfj5GWHIuzPP77vQ4t/k0MudrQ5eiwvk5enpjYgrqeQnG
 nOfmbSx4TufrygkPoTnIyVrqSDg9L+2bTmdG5wW/8zh3rY4dYGv6sIrCIiT7kkVeK5Cw
 xLmA==
X-Gm-Message-State: AOAM532N5SALjo4BONxF4IZ6mfZiymmnZQ3bvSePPIBMOqg36Ys0ACbz
 jcNWiy86baCzvwtQtoxAa9nmrleRMiNDk775ix2hLyo+NbBFS/Phm306/Ke65AstOWCWsHqXRnD
 bBj4ETQOtDJiohGvLPDBBkYXL
X-Received: by 2002:a17:907:16a8:: with SMTP id
 hc40mr16049343ejc.210.1640684270168; 
 Tue, 28 Dec 2021 01:37:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwk10qerga4au0PlRksDEq0pg2NINxNnJMdwWVAoVSQTerQ17y4x4lhluHN98cBV3jmZIMeqw==
X-Received: by 2002:a17:907:16a8:: with SMTP id
 hc40mr16049327ejc.210.1640684269989; 
 Tue, 28 Dec 2021 01:37:49 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id hb31sm176544ejc.2.2021.12.28.01.37.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Dec 2021 01:37:49 -0800 (PST)
Date: Tue, 28 Dec 2021 10:37:48 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/6] KVM: selftests: arm64: Rework TCR_EL1 configuration
Message-ID: <20211228093748.ed7ohpnrq3cmljee@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-5-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211227124809.1335409-5-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Dec 27, 2021 at 12:48:07PM +0000, Marc Zyngier wrote:
> The current way we initialise TCR_EL1 is a bit cumbersome, as
> we mix setting TG0 and IPS in the same swtch statement.
> 
> Split it into two statements (one for the base granule size, and
> another for the IPA size), allowing new modes to be added in a
> more elegant way.
> 
> No functional change intended.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../selftests/kvm/lib/aarch64/processor.c     | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
