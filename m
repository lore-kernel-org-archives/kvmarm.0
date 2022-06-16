Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57332CCA47A
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 12:47:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C7B49EED;
	Thu, 16 Jun 2022 08:47:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VG9BdakeKpWw; Thu, 16 Jun 2022 08:47:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 948E349EB4;
	Thu, 16 Jun 2022 08:47:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5590649EB4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 08:47:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qag7YUfvX+DP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 08:47:13 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D8E640719
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 08:47:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655383633;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=eHLQpuAU4wLXl8S1FY+BvKbQEk+v7epLCejlC4CMvYY=;
 b=UL4x8FVY+cML8r2+1J/gGerQiy+LccYk48sPS6Zwikk19sN6VxX7EKquL9iaM485kHbZ9f
 C47R1Uww14pKsTCWk4xYhpWtgOTHWcyw/dUr+ehKmNbO2uF3xgdLfkzOGZTIlzBk845tFF
 6VIZJF/xmV2kPJWXDGA1KtHMoBAGgyc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-fcNLOPojPDSPvEjw29hYwA-1; Thu, 16 Jun 2022 08:47:09 -0400
X-MC-Unique: fcNLOPojPDSPvEjw29hYwA-1
Received: by mail-ed1-f69.google.com with SMTP id
 f9-20020a056402354900b0042ded146259so1168518edd.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 05:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eHLQpuAU4wLXl8S1FY+BvKbQEk+v7epLCejlC4CMvYY=;
 b=NYUEf6dp6n5ICVb/xz9CLhGgnffX+WpL1RGs11fZwJh8bkEB5eueWrk53I0DZ0vFWI
 eZ6oZTwpR6sp7fKl4e7RaY0jjyS0SV9+iTEI7LB6e7MB1yK/fOMBXPC9RXawizVeH0/A
 gSbWaM+jThG4ctMIEkuQcOoJu2AefWKf14zMT5tGBtufzSdEkA0scMC0OGYgbaRKKRx3
 AKUTmW5CApzEjKXtfzmz9VWFs15zz3yJyFO6/BfWUBputzPsyQqp5E5YD7btAfLtXjKo
 O7a+3cu6XevL9RMZASYwq07IfrWAxBFbbfMLPhniLnBxc2Mb2nY4LaqQy7YNVRttMHi/
 Kh2A==
X-Gm-Message-State: AJIora+udV13ae+3Aw37xtEH0T9fyqamouEamQf4f24oy9hT27OQDY33
 sBFVziapGta//5vbNkYQXLJbMd4d2go2sNx24pCIgffdoEniG4ND/mr9FmUfP2W1RE8WQSe7W/g
 gWFND4h7Bpeq7xsxzPaeCWiQK
X-Received: by 2002:a05:6402:23a3:b0:42e:251a:c963 with SMTP id
 j35-20020a05640223a300b0042e251ac963mr6296496eda.173.1655383628443; 
 Thu, 16 Jun 2022 05:47:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tpIYwJjkFopmtzI0GIlGcLZdwZ6PcGGP/8fD6qnBnNu7Xzc7i8G+/aM6OTa6GGy5Vz99TU8Q==
X-Received: by 2002:a05:6402:23a3:b0:42e:251a:c963 with SMTP id
 j35-20020a05640223a300b0042e251ac963mr6296486eda.173.1655383628301; 
 Thu, 16 Jun 2022 05:47:08 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 j4-20020a50ed04000000b004318ba244dcsm1714996eds.10.2022.06.16.05.47.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 05:47:07 -0700 (PDT)
Date: Thu, 16 Jun 2022 14:47:05 +0200
From: Andrew Jones <drjones@redhat.com>
To: Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH 1/4] KVM: selftests: enumerate GUEST_ASSERT arguments
Message-ID: <20220616124705.wsll33usok4gfhqc@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-2-coltonlewis@google.com>
MIME-Version: 1.0
In-Reply-To: <20220615193116.806312-2-coltonlewis@google.com>
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

On Wed, Jun 15, 2022 at 07:31:13PM +0000, Colton Lewis wrote:
> Enumerate GUEST_ASSERT arguments to avoid magic indices to ucall.args.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/include/ucall_common.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 98562f685151..dbe872870b83 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -32,6 +32,14 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>  				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
>  #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
>  #define GUEST_DONE()		ucall(UCALL_DONE, 0)
> +
> +enum guest_assert_builtin_args {
> +	GUEST_ERROR_STRING,
> +	GUEST_FILE,
> +	GUEST_LINE,
> +	GUEST_ASSERT_BUILTIN_NARGS
> +};
> +
>  #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
>  	if (!(_condition))                                              \
>  		ucall(UCALL_ABORT, 2 + _nargs,                          \
> -- 
> 2.36.1.476.g0c4daa206d-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
