Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12D4C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  1 Mar 2022 09:07:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A0F349E43;
	Tue,  1 Mar 2022 04:07:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oBlcJqSto5QR; Tue,  1 Mar 2022 04:07:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C743749E2C;
	Tue,  1 Mar 2022 04:07:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3A8249DE3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2022 04:07:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DKATOzc+5j06 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2022 04:07:01 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78DFD49E33
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2022 04:07:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1646125621;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=yvepydnYzGU3SWQG48ulR9nFOyOjuERIrVXsBMjjm5E=;
 b=DwVynh+z6EHGZrpaVoDD638Z9Zd2uVV0VgA11znY1iIxbje2x+RP5k05jHrEfG0pnWjqEb
 Gg9DVpynZ+7SoMSIpYhOvAS4QB8f+2oxJAwo+T0xZBnKK1zntiZe8zXVRAJcFkQuzdwSyT
 s/75hGuftMFfuC46WGjl/cUczU9XO2s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-EIjUUYMPMcK2cHudc2Eb0w-1; Tue, 01 Mar 2022 04:06:57 -0500
X-MC-Unique: EIjUUYMPMcK2cHudc2Eb0w-1
Received: by mail-wr1-f71.google.com with SMTP id
 z16-20020adff1d0000000b001ef7dc78b23so2039478wro.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Mar 2022 01:06:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=yvepydnYzGU3SWQG48ulR9nFOyOjuERIrVXsBMjjm5E=;
 b=ZQxo2537skUccT49GCli/ChFFPDvRWKF+A3a33jiwTGSdHm0q5Axo4BSe3UIVGdAKp
 WXJOjZozo0aNgKaYfOwGbHzQ82U2jSdFoGHIzoaxMKLYKoD6dPL1R3s7iFi2u2oWG5HW
 QtVVAkYnJCTrP5pt00VspYYQpNRSsKzvu4DZZnAzNPiWIIyQbcWwgOVRYS00hKInF3M9
 26Ywr5uXHzQQ8Wh0Vbw5ZzmhE3Dz/8Hd9ULDSMdVUdLzm/myjUrOGjDsBPcnUhLVlsdJ
 xEqxxS0T/CjFGauaciSy7SGwstjIWG4zuEgX+OsfvVO1jXrQilD4ApYHqLx80zNIEV9D
 Rcxg==
X-Gm-Message-State: AOAM533l3UQz9e+FEtkKDeDTsfG3GrpmLF2I7qiiC8IvAkojSYxHIWmR
 Vs36dQiNzLyB3g/3VLJP1rqBxf35dX8dyEW9ctdUy0lCYyGTx4fR3l+98C6dtYtcVm4Kbh7kPbJ
 dq5D26PojcGn++uinYxuTpXJo
X-Received: by 2002:a5d:49c9:0:b0:1f0:16b2:584f with SMTP id
 t9-20020a5d49c9000000b001f016b2584fmr1282971wrs.710.1646125616333; 
 Tue, 01 Mar 2022 01:06:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysPuQNRZM4I3CerlyPgO2J4N/MPFQV33vrrQB+RZ+Mucd9f7im/hH9m1ZdNgj7gMA+tTZeqA==
X-Received: by 2002:a5d:49c9:0:b0:1f0:16b2:584f with SMTP id
 t9-20020a5d49c9000000b001f016b2584fmr1282958wrs.710.1646125616134; 
 Tue, 01 Mar 2022 01:06:56 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id
 m10-20020adfe94a000000b001ef57f562ccsm13171245wrn.51.2022.03.01.01.06.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Mar 2022 01:06:55 -0800 (PST)
Date: Tue, 1 Mar 2022 10:06:53 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: Timer delays in VM
Message-ID: <20220301090653.yzsd5eichip4li7r@gator>
References: <BYAPR12MB31927AEB9D0A4068ED12826DD9019@BYAPR12MB3192.namprd12.prod.outlook.com>
 <667c9f084b2d38725369de60daef6d58@misterjones.org>
MIME-Version: 1.0
In-Reply-To: <667c9f084b2d38725369de60daef6d58@misterjones.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvmarm@lists.cs.columbia.edu, Eugene Huang <eugeneh@nvidia.com>
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

On Mon, Feb 28, 2022 at 09:02:47PM +0000, Marc Zyngier wrote:
> 
> You also don't mention what host kernel version you are running.
> In general, please try and reproduce the issue using the latest
> kernel version (5.16 at the moment). Please also indicate what
> HW you are using.
>

Yes, please reply with the kernel version these delays are seen on
and also try to reproduce with a latest upstream kernel version. If
the delays are not present with the upstream kernel version, then
we can open a CentOS bug.

(You may want to experiment with host and guest kernel configs as
well.)

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
