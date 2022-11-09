Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B63220E8
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 00:05:05 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id i3so15187880pfc.11
        for <kvmarm@lists.linux.dev>; Tue, 08 Nov 2022 16:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=rL8QTJpu5zklsZgumexMeRRh3beVPWJoINsPyeaaalAn8FxtKEaOsAkCg+47qr/Thl
         3M81WOB8diqWhuOGExDN/NUQ7PIk9MuDulSNsKWygSJpEUG/weMLekI3F2iFqnjDllaN
         VSTmGNjerPPJNQgss4hpUSsBmfPJJmIxrKb0fcIWgzYQYSmnyZ+GQOOjCeEI9j+OXCNR
         k1S+brftCxCm8KIjAd9wyzzIQFGbzNjAenIisQwjBUZi221w2bYQFNBfaNlS+0XEmKiM
         kidQ16k3wcTCzDiwtrSd7UWpg6YgKWqSdG/2jRbnU9ZektBdhx5Y1jwQk5I5hOeIJwWy
         vgXg==
X-Gm-Message-State: ACrzQf2Rp/IxAephnH3m1oxNQ70GpLuwOVI5Si/+3OKr/jIDp/ZWBeVK
	Tsj0vpmdHnYULlZ+8uh9pXFrDQ==
X-Google-Smtp-Source: AMsMyM6lqHfLRza4xpTYFG5OCmO3t7QpGSB8EMMMXUfcY2HCMAhGNyyP1NkF3U+FKGNN9RZhDBNBYQ==
X-Received: by 2002:a63:e153:0:b0:439:2fa3:74d1 with SMTP id h19-20020a63e153000000b004392fa374d1mr49274307pgk.85.1667952304721;
        Tue, 08 Nov 2022 16:05:04 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k21-20020a628415000000b0056bb06ce1cfsm7128531pfd.97.2022.11.08.16.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:05:04 -0800 (PST)
Date: Wed, 9 Nov 2022 00:05:00 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
	andrew.jones@linux.dev, ajones@ventanamicro.com, bgardon@google.com,
	dmatlack@google.com, will@kernel.org, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, pbonzini@redhat.com, maz@kernel.org,
	peterx@redhat.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2rurDmCrXZaxY8F@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com>
 <Y2qDCqFeL1vwqq3f@google.com>
 <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
Message-ID: <20221109000500.AYIAq7c76q4Li0l372TkwNqTk-1tUkw-Yhs3uGDYMI4@z>

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
