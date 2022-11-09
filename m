Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98699C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 00:05:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 098A74B887;
	Tue,  8 Nov 2022 19:05:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RujKamw9OFep; Tue,  8 Nov 2022 19:05:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAC954B88B;
	Tue,  8 Nov 2022 19:05:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6AA04B886
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 19:05:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KNJoyCQzRZ2K for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 19:05:05 -0500 (EST)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9BC24B82C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 19:05:05 -0500 (EST)
Received: by mail-pg1-f173.google.com with SMTP id 136so10908426pga.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Nov 2022 16:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=8mN4lJ0ugApMl1P1+zNxhl9RCm2csyd+rIUafb5kLio=;
 b=Ved11eCrNxyvfhZoDnk9yg1nEoH5NfSvLqbQQWkLH5gv7U3BpGORKcXovnYiMK0v0b
 ZSJmkaQmxqFPifBVIoDVlY5gYp0CiXA4BrrRrrUe0/A7qvgSmFISzkMljW0ZOz1lINow
 sH0rWbGMCHylbTsCaXEcKNRQZN17+MtUMq2LCR0l8Z5v86NGJNPMYetqm1q76nYCcJiw
 ambwzPDpVv9v72wkGNUN/OcDvzd57cKfSPqAX4jbiQb//z/0+hCgw1HkxeKdhpcQsicK
 UElHeJ0aV5lNcCgUUdKuY/qkz8GUWu9RwG2MJDk/dLFm5fUL4/t1o7Oh5BuyAkQEkunI
 IF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=8mN4lJ0ugApMl1P1+zNxhl9RCm2csyd+rIUafb5kLio=;
 b=a5DVffHBRQpB2HTM81MAjlpGdRvQMya1fPlIi6d67RL6RB9q2IJ8GO8n1Eb6DH8o3p
 uh2EgEbbEpAEseWE8yrjwXhaM2gondCA2GB1rXyYM04K7o4jhR5LA2PG7Q20CMVVfgeF
 c2dFI9PJC3qmWzLd5NXqylrWYS2spRl+4U71t2TbS7zMIRQJIXRCegnNqmPctPUebrO9
 MuU1WiH05UFPX68O3AB6Vn+7vZZpdfBmYP4KmrRo8jCUxHCIFENWy6NZmdP9aZvWJABb
 TpoZy4Vf92Acz2tXqY/fsiAYrnzXok2qPApHYTR1zunFU6hGq365R/kVRWGGmbDMJ9Ui
 M7AA==
X-Gm-Message-State: ACrzQf3zwR3kE8IFTziNwARBWk9cPlD/mXUkhJA6aXERE1eZAx2eyJzU
 /BmbRPiUYs3OS6HcfMkKpkYY4w==
X-Google-Smtp-Source: AMsMyM6lqHfLRza4xpTYFG5OCmO3t7QpGSB8EMMMXUfcY2HCMAhGNyyP1NkF3U+FKGNN9RZhDBNBYQ==
X-Received: by 2002:a63:e153:0:b0:439:2fa3:74d1 with SMTP id
 h19-20020a63e153000000b004392fa374d1mr49274307pgk.85.1667952304721; 
 Tue, 08 Nov 2022 16:05:04 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 k21-20020a628415000000b0056bb06ce1cfsm7128531pfd.97.2022.11.08.16.05.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Nov 2022 16:05:04 -0800 (PST)
Date: Wed, 9 Nov 2022 00:05:00 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2rurDmCrXZaxY8F@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com>
 <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Wed, Nov 09, 2022, Gavin Shan wrote:
> Hi Sean,
> 
> On 11/9/22 12:25 AM, Sean Christopherson wrote:
> > I have no objection to disallowing userspace from disabling the combo, but I
> > think it's worth requiring cap->args[0] to be '0' just in case we change our minds
> > in the future.
> > 
> 
> I assume you're suggesting to have non-zero value in cap->args[0] to enable the
> capability.
> 
>     if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>         !kvm->dirty_ring_size || !cap->args[0])
>         return r;

I was actually thinking of taking the lazy route and requiring userspace to zero
the arg, i.e. treat it as a flags extensions.  Oh, wait, that's silly.  I always
forget that `cap->flags` exists.

Just this?

	if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
	    !kvm->dirty_ring_size || cap->flags) 
		return r;

It'll be kinda awkward if KVM ever does add a flag to disable the bitmap, but
that's seems quite unlikely and not the end of the world if it does happen.  And
on the other hand, requiring '0' is less weird and less annoying for userspace
_now_.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
