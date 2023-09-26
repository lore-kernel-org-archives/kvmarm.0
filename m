Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2064C23D7
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 20:35:42 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d866d13c637so11268095276.3
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 13:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695760542; x=1696365342; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gBgGdeEWghtFptaMQEsHDDCQhw184YQ6Ycjl2VsrZq4=;
        b=xxW1irR09zIIpUyxuI4tTNKqPcsrDYXr9srDsZFNfLncGIQxXyVoM1SKuZc1CGko12
         CirJkuR3UBq7uYjv1o9VcE0n8iFgQcR2qkGVtxc4m/CeMD8pfkNlfrBIX6+ScFd7kbvH
         JDMP9NyeJ3hEPpD9km7KocUMB70UiIrWZw273AijwACKtC0o4AfAcTdbBnxCVYxbyV1i
         vIsJO5dGKMnHjtwUACMGnpAy+H/BJgQQnDJp4v9e99Cdldud71vfwhGzbzn0jWlBKzJ0
         9+FzTqFToJP5uHwaLJNxgcmt9ytWRiJ3tjvwtv7gC1DTjpdbGafs+bhvKU6Dc7WeAuH5
         rVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695760542; x=1696365342;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gBgGdeEWghtFptaMQEsHDDCQhw184YQ6Ycjl2VsrZq4=;
        b=Bw6uq7IMXPKQy19vZREW58CedsOVtRrJuCZzF/8OlYRK3CdPkIO29Ht0VJqT2gvf7b
         9sxeceIFH9i+8stet+mSxTRksQDj4Mszj1CYEaxna7uxBbn4IZcePVJunFdKxeEqAnM8
         hm23zesbqd/ZOp+dJA+42CdVSWo14cxtuPmooy9EgYKpbYgVPLYEN4cZkdp7MCKFG5QB
         sNk1oOkp29yfb7g4QPJlSq6CMJyK23SdJSg6j57E7BLoYbrdV9Aygl2mTKe7C3c4mSsd
         l61+evLNaIZoDTW+9Q5cbYssN+fxDoYEEqQJO9MVBqGS+f0FwTUzcBbVMr+/Vkzd0nh4
         oENA==
X-Gm-Message-State: AOJu0Yx1KwM1NQrtGZBDQTAkS44D8+rP8BoFkyMKngnYUt4FkZ9d0WXh
	Imiq4PBEVqatIIdGSmCmwdCq3S4MN50mt2dYkw==
X-Google-Smtp-Source: AGHT+IGjI2QiYKNg5G+Jh+AzDxStZmGOTFezLlj2LgEDS7lrar4VAi7pc9DGlMxlvU+hONN81Pn1xc/3gcuU7CDJuw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:4c8:b0:d85:ae1e:f696 with
 SMTP id v8-20020a05690204c800b00d85ae1ef696mr309ybs.0.1695760541740; Tue, 26
 Sep 2023 13:35:41 -0700 (PDT)
Date: Tue, 26 Sep 2023 20:35:40 +0000
In-Reply-To: <9bf8d239-2851-087b-9608-0c776b721ed7@huawei.com> (message from
 Zenghui Yu on Mon, 18 Sep 2023 19:16:21 +0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntwmwc3c6b.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	james.morse@arm.com, suzuki.poulose@arm.com, ricarkol@google.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Zenghui Yu <yuzenghui@huawei.com> writes:

> Hi Colton,

> On 2023/9/16 0:04, Colton Lewis wrote:
>> It's been a few months with no comment on this. Can someone please
>> review? There was no need to rebase from the original patch. It's all
>> new code so there are no conflicts.

>> I understand it's a bigger patch, but I believe it all falls under the
>> same functional umbrella.

> Thanks for your efforts. I'd like to give it a go but this patch fails
> to compile on the mainline kernel.

> In file included from include/aarch64/delay.h:9,
>                   from lib/aarch64/gic_v3.c:10:
> include/aarch64/arch_timer.h: In function 'timer_get_tval':
> include/aarch64/arch_timer.h:107:3: warning: implicit declaration of
> function 'GUEST_ASSERT_1'; did you mean 'GUEST_ASSERT_NE'?
> [-Wimplicit-function-declaration]
>    107 |   GUEST_ASSERT_1(0, timer);
>        |   ^~~~~~~~~~~~~~
>        |   GUEST_ASSERT_NE

> ... and something like that. It'd be good if you could have a look.

Sorry about that. I'll make those updates right away and rerun the
testing I did when I originally sent the patch.
