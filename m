Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9718EC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Dec 2021 09:37:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A0FB49E17;
	Tue, 28 Dec 2021 04:37:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bhPAuQQPy+Kd; Tue, 28 Dec 2021 04:37:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 319D449ED4;
	Tue, 28 Dec 2021 04:37:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E200A49E17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 04:37:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ue5CC6ffSnuZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Dec 2021 04:37:37 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B261F49B13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 04:37:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640684257;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=B5Dyr2hKJTOOO0TGPVRDDvVVpCPunRt9Jh2tsoosVQg=;
 b=QDDvZDrOKd3Y5zqjIbMuQxnvMwXjkKu8KPKco/0BGcSW82BTSVnSutTAmoEJ6tEacsTye7
 hCxNOuBSZ39l8ivDpqjLvqGRtntaKxFArV4a4ebkV7u5SuB17x7SRtLDsQLJeB/4j8A7uf
 8brADNHMfZNiMZWfoMOQJmho4REo9i8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-lUac6Kk2MiKfjeBhb7dYPw-1; Tue, 28 Dec 2021 04:37:35 -0500
X-MC-Unique: lUac6Kk2MiKfjeBhb7dYPw-1
Received: by mail-ed1-f72.google.com with SMTP id
 g2-20020a056402424200b003f8ee03207eso5929630edb.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 01:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=B5Dyr2hKJTOOO0TGPVRDDvVVpCPunRt9Jh2tsoosVQg=;
 b=4DDY2x6PNfxkTdKv65r2GBZ2AWk1WZN3bZywvtqY1Qr9yAD1DJ6QawYY+pPl9XSrgH
 iRjRFEdgd73H5JSsZ44GGY0hOuTguy7zZc26j6xTfIqSeqadiPmFHiJbwNdlWxGN/RXW
 WsrHg886mr68LaA8a9XKqCP8plkCuTcLAd7aTJOjHMOuNcuwAfgW9iC6yusBUM4P+rv4
 KVHrM+R1UPWnDAkwjbjcWE/JFiLcf/akT1KpFavWmZY17aktjsRRm3j9Tk4Y2yKRXK/L
 vGkpo2EJVY97M39O+rKZ6OWKqjY4J5m8rz533x2GpgHHwfCqN2S8hgkXXevVH4gN3rTR
 8r5A==
X-Gm-Message-State: AOAM533ESzj+7PQMYdAgaIVr7H15DW2acoaUcxMnEOL456ol5ZkIMbR+
 zXFUMJOdJJBdHXW9vhH2gE5c5J3Y0WHU4czz/vCs65aIdyNPBLokoVCfYLXMRsK/iIP1CmKrxbh
 q4AvZbCHob333+euqzsAcoSU0
X-Received: by 2002:a05:6402:1d4b:: with SMTP id
 dz11mr19396957edb.15.1640684254664; 
 Tue, 28 Dec 2021 01:37:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLPd90MR3jT/AajpUn5GE5pdmm4Y7/jXkOi2HCyvBFKr8b65HY2arIgvoCbXPXxkIz2d5uZA==
X-Received: by 2002:a05:6402:1d4b:: with SMTP id
 dz11mr19396938edb.15.1640684254499; 
 Tue, 28 Dec 2021 01:37:34 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id w10sm7148144edt.16.2021.12.28.01.37.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Dec 2021 01:37:34 -0800 (PST)
Date: Tue, 28 Dec 2021 10:37:32 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: selftests: arm64: Check for supported page
 sizes
Message-ID: <20211228093732.mxludqdyxihgwwzw@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-4-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211227124809.1335409-4-maz@kernel.org>
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

On Mon, Dec 27, 2021 at 12:48:06PM +0000, Marc Zyngier wrote:
> Just as arm64 implemenations don't necessary support all IPA
> ranges, they don't  all support the same page sizes either. Fun.
> 
> Create a dummy VM to snapshot the page sizes supported by the
> host, and filter the supported modes.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../selftests/kvm/include/aarch64/processor.h |  3 ++
>  .../selftests/kvm/lib/aarch64/processor.c     | 36 +++++++++++++++++++
>  tools/testing/selftests/kvm/lib/guest_modes.c | 17 +++++----
>  3 files changed, 50 insertions(+), 6 deletions(-)
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
