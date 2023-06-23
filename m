Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209645247
	for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 14:24:43 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-666eb0346c4so340162b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 07:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687530283; x=1690122283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BXhTC2v6pUxG+hsvCgrpr6X6lmLWxVBU76yUJ1it6mc=;
        b=WwBmUsRkRn+d8K/CUFTITZPAiijq+mNGS23VxcXDWgRBaO3YeaAb9CGn5UYNvw8xuE
         is8581SmMpYLnoN3gopCiZicYEgrIlJsgqac5H1AF7ZnOWhdoT9h/BpiJUczHfcku7Eh
         8EV0af9YQFDIB/M88OhnjoEMPnIzFEVdVKYHik/izpp1ocZFmTaCdfRNWjI8/9HG/6TR
         vEFtwtAgAzYJW7bYhgj26Z3Zt7pDbKqs7galF5t81QJPtacywYWIVDzFtPR/Kohip92r
         /JwmOjZm8bzsO7Vd9sH6FhVTDK7VsTg/K6DrmiJ7/tYERHbJzNcO5hUnVHih1KxcJZ91
         9ObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687530283; x=1690122283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BXhTC2v6pUxG+hsvCgrpr6X6lmLWxVBU76yUJ1it6mc=;
        b=YpR+jQzN6HHiqPvFXVFrZYRCFuD+BIEmqxZinrwLJS+YLfC2tq1yF0KWg193cXQgTd
         /0HWYPILqrBxqmqdzTp3Tl4Gb5PQQ6K/uwL6ScylOq4nhONbKA4bws+Zu7/9tu7lt1yl
         l9xcdCSIDq1pWgVrk7J7iTp8h/khnuLqZLvzx91RkB35CQsW3Ni+y/BZCaSE0V9ikVfE
         k/ml2rR0M0k2PuECuAJ0z9Cd+6Pb0C56DuVnCVgSd4ppGEBmeLP73eVl9YHqex7Cnl13
         4kHv+ZUwVcvvFR80Tx+S8ZVD/yuymWg0AldXTqHiYE4bhv8oS9Ru+HNt1qi3HYftAZvo
         P9lQ==
X-Gm-Message-State: AC+VfDzWGBLyq5DVihJWvT8Go5wCYxlvwbQZGaswK9na8v3z7SZ3d/sL
	Xkf+bB5fSWhlHie3z1Cz1F0gWH5UURk=
X-Google-Smtp-Source: ACHHUZ6iBSV9DmoTyY1jspZcL24GA4euc/C+hM3clmSVzwcxNI+pnsjYRfjGYHdr6fPXdhC20bEdElnUsQU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:991:b0:659:ac9e:830 with SMTP id
 u17-20020a056a00099100b00659ac9e0830mr5944982pfg.2.1687530283463; Fri, 23 Jun
 2023 07:24:43 -0700 (PDT)
Date: Fri, 23 Jun 2023 07:24:42 -0700
In-Reply-To: <20230623125416.481755-3-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230623125416.481755-1-thuth@redhat.com> <20230623125416.481755-3-thuth@redhat.com>
Message-ID: <ZJWrKtnflTrskPkX@google.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] Link with "-z noexecstack" to avoid
 warning from newer versions of ld
From: Sean Christopherson <seanjc@google.com>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	"Nico =?iso-8859-1?Q?B=F6hr?=" <nrb@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Laurent Vivier <lvivier@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 23, 2023, Thomas Huth wrote:
> Newer versions of ld (from binutils 2.40) complain on s390x and x86:
> 
>  ld: warning: s390x/cpu.o: missing .note.GNU-stack section implies
>               executable stack
>  ld: NOTE: This behaviour is deprecated and will be removed in a
>            future version of the linker
> 
> We can silence these warnings by using "-z noexecstack" for linking
> (which should not have any real influence on the kvm-unit-tests since
> the information from the ELF header is not used here anyway, so it's
> just cosmetics).
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 0e5d85a1..20f7137c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -96,7 +96,7 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>  
>  autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
>  
> -LDFLAGS += -nostdlib
> +LDFLAGS += -nostdlib -z noexecstack

Drat, the pull request[1] I sent to Paolo yesterday only fixes x86[2].

Paolo, want me to redo the pull request to drop the x86-specific patch? 

[1] https://lore.kernel.org/all/20230622211440.2595272-1-seanjc@google.com
[2] https://lore.kernel.org/all/20230406220839.835163-1-seanjc@google.com
