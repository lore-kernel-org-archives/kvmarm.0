Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF1DAD58
	for <kvmarm@lists.linux.dev>; Fri, 24 Feb 2023 20:07:32 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id s1-20020a6bd301000000b0073e7646594aso67209iob.8
        for <kvmarm@lists.linux.dev>; Fri, 24 Feb 2023 12:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b9eEgAqxwwT4oBExX9UxWqccj7ZXr1sZAWCiBgAFhOg=;
        b=iqgI5WzFSxMSY27jQbX6h/A7/1NbpKWYqj67NeQey9WRvdfy8LcaF9g7Ztkco4ORBR
         f5DJCdkG2NVVQPUeBftttAXkjkT/5h39/fppVpX5BovT39UKAJi54mPw6sa9s8RCxfu3
         i4m6G3HBZh/9Fg8VrElnnk/q668v6koXeArvYu3PDRdW2FHIBjynX4W4bz7K7TVKvj1R
         RRIx9ccSLl5TknS4xxZrxMamMKcGI3wGDD9cOOANW8x7ExtWLgHirQVWHsX2if5S68pu
         V8qaBkcmfs3+pI/+RAQtAQ5a7tErrFuOfhodyg7L8E3Qs6UPQIgvV2euXEhkCEqBnAhh
         bBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b9eEgAqxwwT4oBExX9UxWqccj7ZXr1sZAWCiBgAFhOg=;
        b=LYu3+VW8nf8a3xSkhlsuK9sa5oOmYlMMa+Ff7RxSHutaE/yMg2hfgg6goJSJZPkMLM
         qsEyDQOwU+d+KnFdYLzR7+gwgdqwdUXxahzebOBikllLtzCZBGnwW2RlQjMTLJNwYduX
         M7yNT02KB3FZ+FGc/IYfFO9GI+0XorkZBpvJ1uA/ZB2xcHb0g/YBoOn9GifVjWxIz5xP
         i9emVCpA6oxPEob/0ExE5z3giz6O9NLMP135FOTyCM+2BZQ/8ZDHpqLucRDqJBndivRr
         FiyunXsqI/f/ENNuXqaA0tboLglpSIENddgZoWmpp4u83Dy58mDZaQ5Lr+Ecl3/hRecd
         5dTA==
X-Gm-Message-State: AO0yUKVXcVQ1kgzQ4k4TAkxGhlMdIvBAWsi4Q5iGkZaCYpqan8ip3JXH
	9CcKh5zmq2oiS23LSxwl41Kjp3BOSGels3aj4A==
X-Google-Smtp-Source: AK7set/EAaM8y0wwRhjkt0dNHV7aQnp40+jiSD+YRka4vFYDirCN0RN1NCz2qoO9U8PIUH0WXao1xULkaWnv7uKVkA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:a186:0:b0:3a7:e46f:7d30 with SMTP
 id n6-20020a02a186000000b003a7e46f7d30mr6586704jah.3.1677269251262; Fri, 24
 Feb 2023 12:07:31 -0800 (PST)
Date: Fri, 24 Feb 2023 20:07:30 +0000
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:07 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntlekm969p.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 00/16] KVM: arm64: Rework timer offsetting for fun and profit
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hello Marc,

This patch is of special interest to me as I was working on my own
ECV/CNTPOFF implementation, although mine was more narrow and doesn't
address any of your other goals. As far as I can tell at the moment,
your patch can cover the uses of mine, so I will dedicate
myself to reviewing and testing yours. Please include me on any future
rerolls of this patch.

Marc Zyngier <maz@kernel.org> writes:

> This series aims at satisfying multiple goals:

> - allow a VMM to atomically restore a timer offset for a whole VM
>    instead of updating the offset each time a vcpu get its counter
>    written

> - allow a VMM to save/restore the physical timer context, something
>    that we cannot do at the moment due to the lack of offsetting

> - provide a framework that is suitable for NV support, where we get
>    both global and per timer, per vcpu offsetting


If I am understanding your changes correctly, you introduce some VM-wide
timers with no hardware backing and a new API to access them from
userspace. This is useful both because it makes the code simpler (no
need to manually keep registers in sync), and so CNT{V,P}OFF can be
appropriately virtualized with NV. Is that a fair summary of the
important bits?

> This has been moderately tested with nVHE, VHE and NV. I do not have
> access to CNTPOFF-aware HW, so the jury is still out on that one. Note
> that the NV patches in this series are here to give a perspective on
> how this gets used.

> I've updated the arch_timer selftest to allow offsets to be provided
> from the command line, but the arch_test is pretty flimsy and tends to
> fail with an error==EINTR, even without this series. Something to
> investigate.

I can help you with testing because I have access to CNTPOFF-aware
hardware and emulators. Is there anything you are especially interested
to try out?
