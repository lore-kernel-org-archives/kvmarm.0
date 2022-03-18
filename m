Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4234CC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 09:36:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A903249E39;
	Fri, 18 Mar 2022 05:36:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xxZhEdPQdKFJ; Fri, 18 Mar 2022 05:36:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0B149ED4;
	Fri, 18 Mar 2022 05:36:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C5F349E39
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 05:36:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oeT7MUxPk9BC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 05:36:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06D1B49E0E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 05:36:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647596166;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=m4jF8/kC8zIHwAO3JdMD+H9wM977DPU+ZmNY1oF3jOo=;
 b=W0CJToXxsHVzafChRceYvf8ysJZz3XqEpa6DSQeIbHrGHGQ5HRq28UsOHYEAbiS8WEElnu
 JB5tj3C6Im0y8DUx/ItLQz8q7abmIu2FL09aWm95q7zNvPLeDHnonpGjcDO1eSGYJyjcQs
 kGFx4eXxV0x9+Iyzp71NcCJJ5kvZDeU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-OdBdwlzNMY-bAMPPr8mmRA-1; Fri, 18 Mar 2022 05:36:05 -0400
X-MC-Unique: OdBdwlzNMY-bAMPPr8mmRA-1
Received: by mail-ed1-f72.google.com with SMTP id
 w8-20020a50d788000000b00418e6810364so4544048edi.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 02:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=m4jF8/kC8zIHwAO3JdMD+H9wM977DPU+ZmNY1oF3jOo=;
 b=Db0GzPDqcl5rx0df5Nk8fkjoOubIcTjDKj5EGELAUgNfXIvcXnC2tbmr0Kvqeoe7pK
 eVj9M+Srb/mcamKeSdkIV6gQwvETOCXKM2PTTWhcngvFWp3tJaV+Sp3QVk2FoXZZ8jSO
 8cVrn+z8g58+0gW93a7bUreJsS6PTJLEmdruZvUCFnbWK9m8/OiXnc2R49YFPS+WxNfZ
 OOvgybhei4cZKpINOdJkrjnWJOcIBGOP9NlPC4HdIDaMNEaJi3rJ/hAyt3awE26KIAHp
 zsuBUmxqpTkk1ANCAeJGEGuIJOexvtDai+6SQ9KSntI9GsAfJADlasVdnQQDysJHrEsE
 eS+w==
X-Gm-Message-State: AOAM531Lr0gyUmZ3RMOQh5HnGAUcE+I/YCZeixASU/v0ZCbHrkvXoAV6
 opD4PvOSfakbfF+HciXFqUx4X0KGhaQYW1n+r+V+uNJTnsszwg7240CYI4Z7NmXcLJq6ibzVOme
 PYPYyW78cIl3ewLagLRIKjvFO
X-Received: by 2002:a17:906:4c83:b0:6b7:b321:5d54 with SMTP id
 q3-20020a1709064c8300b006b7b3215d54mr7986216eju.676.1647596164178; 
 Fri, 18 Mar 2022 02:36:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGfngiAJB91ib0NSDhnemNwcbBdY9hFIPe7Ws8dqmHZ+SkhiUDTGSr3KrMjxf9cL0cYbqRvw==
X-Received: by 2002:a17:906:4c83:b0:6b7:b321:5d54 with SMTP id
 q3-20020a1709064c8300b006b7b3215d54mr7986200eju.676.1647596163934; 
 Fri, 18 Mar 2022 02:36:03 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id
 sg9-20020a170907a40900b006df8c6df89fsm2355398ejc.93.2022.03.18.02.36.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 02:36:03 -0700 (PDT)
Date: Fri, 18 Mar 2022 10:36:01 +0100
From: Andrew Jones <drjones@redhat.com>
To: Bill Wendling <morbo@google.com>
Subject: Re: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of
 bitwise "or" with boolean operands
Message-ID: <20220318093601.zqhuzrp2ujgswsiw@gator>
References: <20220316060214.2200695-1-morbo@google.com>
MIME-Version: 1.0
In-Reply-To: <20220316060214.2200695-1-morbo@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: lvivier@redhat.com, linux-s390@vger.kernel.org, thuth@redhat.com,
 frankja@linux.ibm.com, kvm@vger.kernel.org, david@redhat.com,
 kvm-ppc@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
 pbonzini@redhat.com, imbrenda@linux.ibm.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 15, 2022 at 11:02:14PM -0700, Bill Wendling wrote:
> Clang warns about using a bitwise '|' with boolean operands. This seems
> to be due to a small typo.
> 
>   lib/libfdt/fdt_rw.c:438:6: warning: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>           if (can_assume(LIBFDT_ORDER) |
> 
> Using '||' removes this warnings.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/libfdt/fdt_rw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/libfdt/fdt_rw.c b/lib/libfdt/fdt_rw.c
> index 13854253ff86..3320e5559cac 100644
> --- a/lib/libfdt/fdt_rw.c
> +++ b/lib/libfdt/fdt_rw.c
> @@ -435,7 +435,7 @@ int fdt_open_into(const void *fdt, void *buf, int bufsize)
>  			return struct_size;
>  	}
>  
> -	if (can_assume(LIBFDT_ORDER) |
> +	if (can_assume(LIBFDT_ORDER) ||
>  	    !fdt_blocks_misordered_(fdt, mem_rsv_size, struct_size)) {
>  		/* no further work necessary */
>  		err = fdt_move(fdt, buf, bufsize);
> -- 
> 2.35.1.723.g4982287a31-goog
>

We're not getting as much interest in the submodule discussion as I hoped.
I see one vote against on this thread and one vote for on a different
thread[1]. For now I'll just commit a big rebase patch for libfdt. We can
revisit it again after we decide what to do for QCBOR.

Thanks,
drew

[1] https://lore.kernel.org/kvm/20220316105109.oi5g532ylijzldte@gator/T/#m48c47c761f3b3a4da636482b6385c59d4a990137 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
