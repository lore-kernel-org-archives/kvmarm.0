Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2010C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 11:08:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28C414B137;
	Wed, 24 Nov 2021 06:08:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WpMUjY8WLerT; Wed, 24 Nov 2021 06:08:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 702574B0EC;
	Wed, 24 Nov 2021 06:08:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16FF24B0DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 06:08:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q2LF4Kfeue-6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 06:08:31 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9015A4B0BD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 06:08:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637752111;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=waH4hRzlVOpWIl+cTH6RBonEIb6tUAeusmu8efKZ6yQ=;
 b=fK9gzZob94pa9zp0dOcTA57Ht5qMtrV03xCk5KsTa6WigTlijbwa2IaeOL0XPuHwndoXsm
 JdwRSuFV0lJjvygBGl31TIGG6LhN7FcM4dz4uC1aDMbRshU2iwYYP021qdA7n487nm+Etb
 2Dahg6uG2hsLgZ0Vz7QPK3Rx+0gdoqc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-bT7qF1VbOkWn05jaB43ihw-1; Wed, 24 Nov 2021 06:08:28 -0500
X-MC-Unique: bT7qF1VbOkWn05jaB43ihw-1
Received: by mail-ed1-f69.google.com with SMTP id
 r16-20020a056402019000b003e6cbb77ed2so1985780edv.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 03:08:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=waH4hRzlVOpWIl+cTH6RBonEIb6tUAeusmu8efKZ6yQ=;
 b=NtBl9Y/wP7ANjdlqSwUy6+Ne8JCubBh1TuLYKrhsRCBLzPrPi9owk1NGMXIUAALeM4
 uddZAlwky22/Vj1jd8+Yt6JUXIPlvhe7RZlkCeI+zW/Xl2C13tL/BlFBseXzWboL2DAz
 3clupEQtGSNGd8V67IFtbYMGhNSBa2YbdcnGMYYL1eZW+xFJwqeyQ4CHrXPyAcZs2qg9
 FjJSwJYSJxfsKMlNi9CSsm4qrZ5IM22cdjIxbIzFncovN4WZC8yFRBoaVIT4YloGPfng
 aJKotUx5Z2Y9MonImC8SuVZc+Kqw201DHEUUAaXWhiwKnjMRfrk+IhguOdcJZWHabNEs
 dnZw==
X-Gm-Message-State: AOAM531AkWtW3DHfJrloN/2eOzNwMDVu1vCT5lOPF/YLQStNPZlK38Fw
 DbXe9yrtu5AvNP4hqlQ+SlBPDbEaKah1c19AIx4hEoVjFT5rFfnfYbIHu+mkbSHCADSxWZt2mFV
 bsaTM4Iu41DDTEuwIVJXgEhle
X-Received: by 2002:a05:6402:50d4:: with SMTP id
 h20mr23601525edb.52.1637752107113; 
 Wed, 24 Nov 2021 03:08:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwglewokYpugqHWrBhNdWGpHvZXynVUenV12dW1Fb7vRdTvAfPH5JZMz6PqUW3GovixbQIRJA==
X-Received: by 2002:a05:6402:50d4:: with SMTP id
 h20mr23601480edb.52.1637752106917; 
 Wed, 24 Nov 2021 03:08:26 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id nd22sm6940051ejc.98.2021.11.24.03.08.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 24 Nov 2021 03:08:26 -0800 (PST)
Date: Wed, 24 Nov 2021 12:08:24 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v8 01/10] docs: mention checkpatch in the
 README
Message-ID: <20211124110824.yqrtjkbul3h3pv2i@gator.home>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-2-alex.bennee@linaro.org>
 <20211124110659.jhjuuzez6ij5v7g7@gator.home>
MIME-Version: 1.0
In-Reply-To: <20211124110659.jhjuuzez6ij5v7g7@gator.home>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
 pbonzini@redhat.com, idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Nov 24, 2021 at 12:07:02PM +0100, Andrew Jones wrote:
> On Thu, Nov 18, 2021 at 06:46:41PM +0000, Alex Benn=E9e wrote:
> > Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > ---
> >  README.md | 2 ++
> >  1 file changed, 2 insertions(+)
> > =

> > diff --git a/README.md b/README.md
> > index b498aaf..5db48e5 100644
> > --- a/README.md
> > +++ b/README.md
> > @@ -182,3 +182,5 @@ the code files.  We also start with common code and=
 finish with unit test
> >  code. git-diff's orderFile feature allows us to specify the order in a
> >  file.  The orderFile we use is `scripts/git.difforder`; adding the con=
fig
> >  with `git config diff.orderFile scripts/git.difforder` enables it.
> > +
> > +Please run the kernel's ./scripts/checkpatch.pl on new patches
> =

> This is a bit of a problem for kvm-unit-tests code which still has a mix
> of styles since it was originally written with a strange tab and space
> mixed style. If somebody is patching one of those files we've usually
> tried to maintain the original style rather than reformat the whole
> thing (in hindsight maybe we should have just reformatted). We're also
> more flexible with line length than Linux, although Linux now only warns
> for anything over 80 as long as it's under 100, which is probably good
> enough for us too. Anyway, let's see what Paolo and Thomas say. Personally
> I wouldn't mind adding this line to the documentation, so I'll ack it.
> Anyway, we can also ignore our own advise when it suits us :-)
> =

> Acked-by: Andrew Jones <drjones@redhat.com>
>

Forgot to CC Thomas and Paolo, am now.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
