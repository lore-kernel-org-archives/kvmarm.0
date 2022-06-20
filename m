Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F8CC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 13:21:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94BCB4B4E1;
	Mon, 20 Jun 2022 09:21:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 66-SYG37gMII; Mon, 20 Jun 2022 09:21:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AD4A40417;
	Mon, 20 Jun 2022 09:21:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F06264B26C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 09:21:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2ao2YIolXpUZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 09:21:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D348B401AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 09:21:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655731271;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=CUQCJRI06y3J+/812aZ86ATOZgRVRfW4HLzZbrLgbQ8=;
 b=EuF+u8a8r1EuVW6Ze7DC5gjsk1HDjZDfP/MZCKk6U3IPtuwdogbhG9j+QJ5sj4AQ6YyZIU
 vuXJ2P5Z3TVOZGMXUq1oCq2r/LgdlibaXyyDzLGes51EJKZerNluEfWi/VoE7owY/aBGo5
 Za0OX1TO2rbbU0ZJFTDgJ6iMxQrwZTc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-VAO4H9PKOOSyf5XqXAywig-1; Mon, 20 Jun 2022 09:21:10 -0400
X-MC-Unique: VAO4H9PKOOSyf5XqXAywig-1
Received: by mail-wm1-f70.google.com with SMTP id
 m23-20020a05600c3b1700b0039c6e3c169aso5022453wms.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 06:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=CUQCJRI06y3J+/812aZ86ATOZgRVRfW4HLzZbrLgbQ8=;
 b=LU/W3yTCHGP5uSrpgLEY33isyclgXtKiokc6YCoYoFSDYyfOkJv/Fmm1IN8UmunbrZ
 4/FV5EkYyqehcY3/lb036jiZOK7eDvQzZovatX1Jxa352WzsArDYe/H71cqx29+Hj9tt
 +u7mdZG/7dsoksbFR36jNtg1dNTCPL4Z355WT0YX7EsplLFGMTEJ5G1j1/qoqakifjSQ
 fHPM0YX8uxrDSLdOvkO+Y265+/F56nU7rMzyoW97bm2z2NkosM0TtQ/eXtbrSMk74uKo
 aQjXxPguQ9N93D6woYdqxT5kSuZyiboeylgeX8ws+t8/X+mK0T9XWK9b3ZVuJKSbWE/y
 f1gQ==
X-Gm-Message-State: AJIora8XvZ4FYu3FI8n1kSGWmj3gxsVUvwAQiCRhiy4LDVr4EzukeUxm
 zvw6Z7lvNfmz290+sNA2bvs+L31rijy38M+u6LFxkMGJOMC+v+UH7zo4ezIRyz6cRnrlXYP7UaC
 N6qnqDYJDlwMZOQdKOj3S7ySl
X-Received: by 2002:a05:600c:4f4e:b0:39c:1bbb:734f with SMTP id
 m14-20020a05600c4f4e00b0039c1bbb734fmr24392319wmq.116.1655731269042; 
 Mon, 20 Jun 2022 06:21:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tUV9rvX4nJ/95jAvg8un3XPRTCFNataKSiPHHwW6CNr66NL+ZHJp2SoaoRMQsUv9XfU1sg3w==
X-Received: by 2002:a05:600c:4f4e:b0:39c:1bbb:734f with SMTP id
 m14-20020a05600c4f4e00b0039c1bbb734fmr24392306wmq.116.1655731268871; 
 Mon, 20 Jun 2022 06:21:08 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 c5-20020a5d63c5000000b0020c5253d8c2sm12654052wrw.14.2022.06.20.06.21.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jun 2022 06:21:08 -0700 (PDT)
Date: Mon, 20 Jun 2022 15:21:06 +0200
From: Andrew Jones <drjones@redhat.com>
To: Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <20220620132106.5vknwvcs3ja224tw@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
MIME-Version: 1.0
In-Reply-To: <20220615193116.806312-3-coltonlewis@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Jun 15, 2022 at 07:31:14PM +0000, Colton Lewis wrote:
> Increase UCALL_MAX_ARGS to 7 to allow GUEST_ASSERT_4 to pass 3 builtin
> ucall arguments specified in guest_assert_builtin_args plus 4
> user-specified arguments.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/include/ucall_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index dbe872870b83..568c562f14cd 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -16,7 +16,7 @@ enum {
>  	UCALL_UNHANDLED,
>  };
>  
> -#define UCALL_MAX_ARGS 6
> +#define UCALL_MAX_ARGS 7
>  
>  struct ucall {
>  	uint64_t cmd;
> -- 
> 2.36.1.476.g0c4daa206d-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
