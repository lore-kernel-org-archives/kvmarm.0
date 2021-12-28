Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1CAC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Dec 2021 09:38:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A333649EEE;
	Tue, 28 Dec 2021 04:38:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fC7pAxLBffP4; Tue, 28 Dec 2021 04:38:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99EE049EAE;
	Tue, 28 Dec 2021 04:38:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57DF349E17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 04:38:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MKzWWZt35Yjw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Dec 2021 04:38:12 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58D4949B13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 04:38:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640684292;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=GBj1Lmo862bZ5iBBD9Gif3sLiVjk0Wo9dVxJgXi9alI=;
 b=RURLtzv6EQzVZPGLNqbUQpmJYjZCrdF6l8SGw2Fhp0Ksq77S8ZkOTsESwbvkfQUKxVA87l
 Mxw0tmTTsW7pV0i8Ow/HfakQLrkNGv6E0Kwdjk9X0CBquehIY/XnQ0cY57lRTCx5anFU4m
 mmszta0P+ZmUIyrDXSxOGvAgW5q0xM8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-Qx8yQ7k7NaSpMBaBbFmi4Q-1; Tue, 28 Dec 2021 04:38:10 -0500
X-MC-Unique: Qx8yQ7k7NaSpMBaBbFmi4Q-1
Received: by mail-ed1-f69.google.com with SMTP id
 ch27-20020a0564021bdb00b003f8389236f8so12655469edb.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 01:38:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GBj1Lmo862bZ5iBBD9Gif3sLiVjk0Wo9dVxJgXi9alI=;
 b=NXJ8qcnONq5/OyYHRgkafNHjdgKqajK7Ynoq7yTGZc4POKF2DdKwr10AKeQnhAMX/+
 xDYWsTFHmGT2Rri7Zv+EsxKrn4iOtozTZfKG/T4xtlKXRQlhJUh5oGOyq0R4XoRLnG/J
 atTL2JhL4OgTvsNEq0RiFSRpUqeD3yvkRk1TRnm58KUhazZxks4yYIVExlj4BHDJWKu3
 5g6Adi3JxfDIufsHPPqtsvvF/XIwFI8eTSwgg5XWjbA3viZpREEQwizlnsJOSVtod5p0
 KaFlkkTzXUHAL05Gcy7MuzwPhqsY3RfFmfqajORagmO6Mpx5urVs2R5S4MIqZBSW2QuN
 uNHA==
X-Gm-Message-State: AOAM530w+UnQbbTangnEh0DnEwiW8D4rXVi+Vf6MxcsnmoDQf/6A2L35
 b6ORat+yXcWcMU6Xqlpyap0f8pD5POvM8rDS8h2YztqQ+J477PFL/5T0SOdIThaxuhzWfZ9bHRV
 we2GdWfCMmJZXGoZWXvzjQ5ka
X-Received: by 2002:a17:906:4703:: with SMTP id
 y3mr16876617ejq.346.1640684289473; 
 Tue, 28 Dec 2021 01:38:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxSJyRS8TjbSLG0wyvRnwXos8K6OpwsqZkJ/RTwvEz16Ua9DcGNhPNRUQd8GoC6Nld1r5RMzw==
X-Received: by 2002:a17:906:4703:: with SMTP id
 y3mr16876603ejq.346.1640684289289; 
 Tue, 28 Dec 2021 01:38:09 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id gs14sm5894820ejc.183.2021.12.28.01.38.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Dec 2021 01:38:09 -0800 (PST)
Date: Tue, 28 Dec 2021 10:38:07 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 6/6] KVM: selftests: arm64: Add support for various
 modes with 16kB page size
Message-ID: <20211228093807.4s46hte4ilbjmxz7@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-7-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211227124809.1335409-7-maz@kernel.org>
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

On Mon, Dec 27, 2021 at 12:48:09PM +0000, Marc Zyngier wrote:
> The 16kB page size is not a popular choice, due to only a few CPUs
> actually implementing support for it. However, it can lead to some
> interesting performance improvements given the right uarch choices.
> 
> Add support for this page size for various PA/VA combinations.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h   |  4 ++++
>  .../selftests/kvm/lib/aarch64/processor.c        | 10 ++++++++++
>  tools/testing/selftests/kvm/lib/guest_modes.c    |  4 ++++
>  tools/testing/selftests/kvm/lib/kvm_util.c       | 16 ++++++++++++++++
>  4 files changed, 34 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
