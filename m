Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7536373
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 01:18:20 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id v3so8970542pgh.4
        for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 17:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nnGMVzde5byvHYv17zn6FGm6u3wHPxyGxlsrl0lhE4k=;
        b=gS0UsTJncWvJRfQYP2inbr0w8Mu5L22CyzmfbiAUp4QGhqcYv8bfopuKXmpnPhn60D
         j7Dp9z24RyPgxOKgbgXGB+7ucB1mepqL6e6kBB3mG/4prdlzc55q5buz/8HMzcfC4JH/
         gbvvzqjuqYmQuezVRVJ61lOEwbGna5b+/05CTJuZ+gahL0an2W1MckQeEF0wZ2C1TrYu
         1/wf+9L9E1vXfLPWqlXVklOubKKHzRRNn6fSe81pA375Z1fkulDNSG2RDWalOdATwxNY
         nQj3gDyIuAteYyGe/zpDLMzrsSVDJYAXrxmeeKi5q5jf+hii7FkGWgIu3Wb9YE/L0amr
         /0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nnGMVzde5byvHYv17zn6FGm6u3wHPxyGxlsrl0lhE4k=;
        b=d4qENQjN/jiedKMREg4/3hy7WvyKQdJmxX98beYNFhwlv7UXN5CE7zjMu7StSuDn+F
         WvLjYBLb9w0F/zJ6+RRE46lV4rmEkf8Gg3LsvmJKQ+Tauj/K3JUF8lFWQQah9Rt91EPT
         bPPzQxjhxC1q7F5cPr0YDxthcxf9pyUhJ/p0iMZ9f6Z3g6OQeSdkoDb6YsSOvh5dPSMi
         1cnFPCrO3RFsWMBzFTfiBaysG85oMuj96fB6VLzKb93i1QrdHIG5jCXxSpyoCZ4egFuy
         cvhgnPOqbFJ+IStKCL0Vk2XLh0j4U8pxKJ2eGh+6CGjlSsRTDiC5KbgiVhElNIcZGIiA
         H4gw==
X-Gm-Message-State: AO0yUKWcNiuQpWgZzwaUeCKIVNCNMFeEuoChr+mqM+bJXvt7yDNHHt6e
	wcwFDgg/iPL/ABVpiBV+Nw66Ug==
X-Google-Smtp-Source: AK7set84RIWN7hVEPNjMKdYDJlU9OE3wecVWlKxUY5LLjtg26d7CD6T9yaGuw2Qq10wRBRGhv6rL6w==
X-Received: by 2002:aa7:858a:0:b0:576:9252:d06 with SMTP id w10-20020aa7858a000000b0057692520d06mr1040361pfn.0.1675127899947;
        Mon, 30 Jan 2023 17:18:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f18-20020a056a00229200b0058bca264253sm8040903pfe.126.2023.01.30.17.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 17:18:19 -0800 (PST)
Date: Tue, 31 Jan 2023 01:18:15 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ricardo Koller <ricarkol@google.com>, Marc Zyngier <maz@kernel.org>,
	pbonzini@redhat.com, yuzenghui@huawei.com, dmatlack@google.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
	catalin.marinas@arm.com, andrew.jones@linux.dev,
	alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is
 enabled
Message-ID: <Y9hsV02TpQeoB0oN@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi>
 <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org>
 <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <Y9g0KGmsZqAZiTSP@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9g0KGmsZqAZiTSP@google.com>

On Mon, Jan 30, 2023, Oliver Upton wrote:
> I think that Marc's suggestion of having userspace configure this is
> sound. After all, userspace _should_ know the granularity of the backing
> source it chose for guest memory.
> 
> We could also interpret a cache size of 0 to signal that userspace wants
> to disable eager page split for a VM altogether. It is entirely possible that
> the user will want a differing QoS between slice-of-hardware and
> overcommitted VMs.

Maybe.  It's also entirely possible that QoS is never factored in, e.g. if QoS
guarantees for all VMs on a system are better met by enabling eager splitting
across the board.

There are other reasons to use module/kernel params beyond what Marc listed, e.g.
to let the user opt out even when something is on by default.  x86's TDP MMU has
benefited greatly from downstream users being able to do A/B performance testing
this way.  I suspect x86's eager_page_split knob was added largely for this
reason, e.g. to easily see how a specific workload is affected by eager splitting.
That seems like a reasonable fit on the ARM side as well.

IMO, we should try to avoid new uAPI without a proven need, especially if we're
considering throwing something into memslots.  AFAIK, module params, at least on
the x86 side of things, aren't considered immutable ABI (or maybe it's just that
we haven't modified/removed one recently that folks care about).
