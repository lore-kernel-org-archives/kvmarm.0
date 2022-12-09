Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15D263C5
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 17:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670605644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hojLz9t3au/qqPytj+gNDvtXE0hfeHRqSZoktJ8ZVLI=;
	b=I2CVxnfSP53Ws99ZJzpUPlpAoJgI03WeRbk6LhZAypv+wa2d+DJ29NnofIK5ubQ8yjpKy1
	VAtS9ZDQ+RcV3QD3pd7QxxS6k1uCVSRUkyUKw2tGCs5KQ0jXqwbD7Ojup7aNgA1xPGA0e6
	w8QrytUp78iupr9pr0qgrhfm+wsgVQE=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-445-gRWErxPEOBiliBofuuOgyA-1; Fri, 09 Dec 2022 12:07:23 -0500
X-MC-Unique: gRWErxPEOBiliBofuuOgyA-1
Received: by mail-vk1-f200.google.com with SMTP id f190-20020a1f1fc7000000b003b88bc02472so1873732vkf.13
        for <kvmarm@lists.linux.dev>; Fri, 09 Dec 2022 09:07:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hojLz9t3au/qqPytj+gNDvtXE0hfeHRqSZoktJ8ZVLI=;
        b=EH9CnJ36ri1SWuuA3npZFtdZoSm/wrErwe3e08nUWLmdKV25p4ixQZAKb1eHAe5Jqo
         kBfhsZjsIyes/kID3shs5o+amb4oExuHtiIHCFTHE9zORlCLb8tsY2kAukiWN3nHXmH6
         cDg2fjngnKGpTCqX100M/27o6KENM9SqDanlrB2FMsGgIVsxrt1wWQH+yFFE0fOuQLty
         FM1VcMIadQGEfgTulM3IjH0KWCSW+nI5ynbi+xOHTYv3rQTgUHAA7tNiKgqavWCq6jiM
         LYi5/RB0qUhUzEc/8I14Pd8GtIsaYSwofN4PjAt3C8TcwkgJRwFMa/nkz+wEtQgH4UeN
         rb0Q==
X-Gm-Message-State: ANoB5pnE479O/Uy9LHeASZ9wXH+1O/GalnWD/33z6uAG+OALrTWOzoe3
	jlIoQ23fLOn82vRKn1FxqOu+41qyJI5mtgmpguzhXe7Ex9kQumPnQQDClJ/5DlQfEfVHzHwePo5
	pfE405qLGnpsL9bvOpwfpFB3QP6I5UKMg
X-Received: by 2002:a67:ee95:0:b0:3aa:2354:b5d2 with SMTP id n21-20020a67ee95000000b003aa2354b5d2mr45546856vsp.16.1670605643013;
        Fri, 09 Dec 2022 09:07:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5zz6uhq0KfiH7V7TqkPbJSPeXdssw5wlXfqjy07mP6JlwmbeZfTCfhWp5bmBRLBRYOfMVw/rtjU5EJ/PG8pbE=
X-Received: by 2002:a67:ee95:0:b0:3aa:2354:b5d2 with SMTP id
 n21-20020a67ee95000000b003aa2354b5d2mr45546820vsp.16.1670605642739; Fri, 09
 Dec 2022 09:07:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221205155845.233018-1-maz@kernel.org> <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y5EK5dDBhutOQTf6@google.com> <5e51cf73-5d51-835f-8748-7554a65d9111@redhat.com>
 <Y5Nq0a2JxUP+JuP+@google.com>
In-Reply-To: <Y5Nq0a2JxUP+JuP+@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 9 Dec 2022 18:07:06 +0100
Message-ID: <CABgObfbAwaseKFYUSAwowGzP7Hh4bw6QDZrj+76HJ9pzHP3Jtw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Andrew Jones <andrew.jones@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>, Ben Gardon <bgardon@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>, 
	Fuad Tabba <tabba@google.com>, Gavin Shan <gshan@redhat.com>, Jakub Kicinski <kuba@kernel.org>, 
	James Morse <james.morse@arm.com>, "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Mark Brown <broonie@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Collingbourne <pcc@google.com>, Peter Xu <peterx@redhat.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Quentin Perret <qperret@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Steven Price <steven.price@arm.com>, 
	Usama Arif <usama.arif@bytedance.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Will Deacon <will@kernel.org>, Zhiyuan Dai <daizhiyuan@phytium.com.cn>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221209170706.q6s7_JZpmxeJoVxQHQfLIm5CntmG20fAQzWRcAwV8KA@z>

On Fri, Dec 9, 2022 at 6:05 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> Mind dumping what I had in v1 and applying this instead?
>
> https://lore.kernel.org/kvm/20221209015307.1781352-1-oliver.upton@linux.dev/

Ouch, five minutes too late... I can take care of the difference but
it'll have to wait for Monday.

Paolo

