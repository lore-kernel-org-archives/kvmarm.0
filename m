Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1399C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 11:07:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A2644B0EC;
	Wed, 24 Nov 2021 06:07:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BJCHBgkPhIHc; Wed, 24 Nov 2021 06:07:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 257594B132;
	Wed, 24 Nov 2021 06:07:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A5F74B0C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 06:07:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TlkGjnBNAHsj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 06:07:12 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C3224B0BD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 06:07:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637752031;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=aMB2sNUsa/0UAP4HkeCP25BsocK+xXuD+P0zzpx3vjI=;
 b=AqLqQpJRJqvk/Y6uehYF8uDPd/xxM0sUG2BJnnssyJ3lzfyvlRZtVlPI5RmM9divAXSqsj
 0+qofRjDEsco8asio8HLh1yZs8/R6S1Rdf9CLUpwckwkI5PHQeAxaKKWFOKASkaTngWPz5
 0ErN/PTuPbPvEviv1Wjp9HHJFZFKKU8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-O1uJSScNN5SpXRNbtaOZ3Q-1; Wed, 24 Nov 2021 06:07:10 -0500
X-MC-Unique: O1uJSScNN5SpXRNbtaOZ3Q-1
Received: by mail-ed1-f71.google.com with SMTP id
 c1-20020aa7c741000000b003e7bf1da4bcso1944788eds.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 03:07:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=aMB2sNUsa/0UAP4HkeCP25BsocK+xXuD+P0zzpx3vjI=;
 b=eDeRF8Mg31yHZJJs0zCB42xitGBMCfbNwVdbkEM75SEj0fbkSiKMRhqJroonbhmAuX
 blaVKNnCoUns9rA85eoyYpq89bKnBwbi3AwJXz+NoIgcJG1rr+OB4MyJZ+pcKWA/9v0O
 dFroe0q6ytT67rgyhXcvzlJzDiO6L0KdBMu/Oq72d9m45F8M9sixixYPWrff1T0vuaL9
 KN02dBixqnxM2CVCFiDkr5K8V7RExfcv/rxY7fIHW2gmJ/pnschLpY65KeV/T1y4Ahlt
 PWFIX9srEsnD6rHi6w6dXWiezHLKkJ2Zjzx77q+NCTZ7C+lOaWlq7IDPIKU/cZBJHJqv
 ow3g==
X-Gm-Message-State: AOAM531CXcQbfdUDfgxa+fhdw6OkQ95+3LjmZpVQKE0zODXite3XNDu9
 yf766/lXF9y6FpotqJW50XAQv5vJAKhPjdmgRCW8qq1fbZYcgnX3Fba+qnDH0mPF27XyRLlVu3M
 dmYXaVuRYr2PjEgv74eeZ04Ip
X-Received: by 2002:a17:906:398:: with SMTP id
 b24mr18897421eja.49.1637752022454; 
 Wed, 24 Nov 2021 03:07:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/3AI7n2ydPSF4DuJUj9I55cNiYIR3/zfiBhnY+uMe5uwnnmEx4YLSqiw9/N8tZAOXWIQ/gA==
X-Received: by 2002:a17:906:398:: with SMTP id
 b24mr18897369eja.49.1637752022167; 
 Wed, 24 Nov 2021 03:07:02 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id gt18sm6730329ejc.88.2021.11.24.03.07.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 24 Nov 2021 03:07:01 -0800 (PST)
Date: Wed, 24 Nov 2021 12:06:59 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v8 01/10] docs: mention checkpatch in the
 README
Message-ID: <20211124110659.jhjuuzez6ij5v7g7@gator.home>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-2-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20211118184650.661575-2-alex.bennee@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
 idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Nov 18, 2021 at 06:46:41PM +0000, Alex Benn=E9e wrote:
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  README.md | 2 ++
>  1 file changed, 2 insertions(+)
> =

> diff --git a/README.md b/README.md
> index b498aaf..5db48e5 100644
> --- a/README.md
> +++ b/README.md
> @@ -182,3 +182,5 @@ the code files.  We also start with common code and f=
inish with unit test
>  code. git-diff's orderFile feature allows us to specify the order in a
>  file.  The orderFile we use is `scripts/git.difforder`; adding the config
>  with `git config diff.orderFile scripts/git.difforder` enables it.
> +
> +Please run the kernel's ./scripts/checkpatch.pl on new patches

This is a bit of a problem for kvm-unit-tests code which still has a mix
of styles since it was originally written with a strange tab and space
mixed style. If somebody is patching one of those files we've usually
tried to maintain the original style rather than reformat the whole
thing (in hindsight maybe we should have just reformatted). We're also
more flexible with line length than Linux, although Linux now only warns
for anything over 80 as long as it's under 100, which is probably good
enough for us too. Anyway, let's see what Paolo and Thomas say. Personally
I wouldn't mind adding this line to the documentation, so I'll ack it.
Anyway, we can also ignore our own advise when it suits us :-)

Acked-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
