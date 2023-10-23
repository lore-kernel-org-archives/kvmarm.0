Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FBE1BDC9
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QuXPYhcx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698074749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5pB8P5MZI5SVEZkvNE+Ru1LBtul6eHQwWOFc8lfM1dc=;
	b=QuXPYhcxhsJKkldavnukZrBmXptR0h2lSmvnD/tlvQcrVV0DP2yLH8l7+RJBhC8oqnCSBO
	JD8KqzdyYWLyCtXORWXSJ3809F81b0vEJaqbxLvDioVYSiKrCIdxlHig5EVtqFFGzefgQT
	DJ1RMHWNrFpwT65OS8zGL72P7OaxarU=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-uzB-ATAEMe2NgqtT8cujLA-1; Mon, 23 Oct 2023 11:25:46 -0400
X-MC-Unique: uzB-ATAEMe2NgqtT8cujLA-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6cf619df364so1077609a34.3
        for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 08:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698074745; x=1698679545;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5pB8P5MZI5SVEZkvNE+Ru1LBtul6eHQwWOFc8lfM1dc=;
        b=qiiRzFm7P/5CmBAsBkY9wPP8XLP6K8Hkya7ZWQOc5M+uV8Ius25GC6Oo+NtaECg6xw
         sXejLbPrMrH9oqRaPpxiEVkSNsApwhTJjz/G8aTUxAGO5mf9ThLAh3Fyf5Dy2Hdp4kBI
         c6R++9h5N33YQHbwVQFXcnBM9T1lkogElOrufslEkNJ3wB/II3c0P5Q6mJlMUqIhdfNt
         ev7VcqEJkujvNFk/PLgVVO3k/rO5Qvzen6wC5AdRqYIvwYDbNy9qkmy+RJIE6H7Ogg3r
         cA9RLeBcytG3FzWw7N3eT++FEUuVp6oqrue+buAMUNbgTue31KflKUvzmuH3AZ+/Bd3g
         IRFQ==
X-Gm-Message-State: AOJu0YyfcMtWiJ5IQylLNsUvzFFUFBTG3dix5eIUpETPNj4POGLr3cB6
	1diIxdL3NMbsLEfRTIAnrtYKkWiNn+g/WxbMlwvGZ833a5V8PeqSTGqQmU141hwYtbqxb36yh7o
	+HnJ2Y3cK3Pi46H9B
X-Received: by 2002:a05:6830:13cc:b0:6bd:b29:85d3 with SMTP id e12-20020a05683013cc00b006bd0b2985d3mr9887437otq.24.1698074745357;
        Mon, 23 Oct 2023 08:25:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoK2+qovEnJ0kBN6PCXBIHQFLPHRIJV2jQ3joRidNulJY5AG6LRxvvWXSsxUzhRkBeB3zQyQ==
X-Received: by 2002:a05:6830:13cc:b0:6bd:b29:85d3 with SMTP id e12-20020a05683013cc00b006bd0b2985d3mr9887424otq.24.1698074745090;
        Mon, 23 Oct 2023 08:25:45 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id fb8-20020ad44f08000000b0066d32666a20sm2951492qvb.71.2023.10.23.08.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 08:25:44 -0700 (PDT)
Date: Mon, 23 Oct 2023 17:25:38 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
    Alexandru Elisei <alexandru.elisei@arm.com>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
    Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
    Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 02/13] KVM: arm64: PMU: Set the default PMU for the
 guest before vCPU reset
In-Reply-To: <20231020214053.2144305-3-rananta@google.com>
Message-ID: <6dcbfe5b-2502-0f04-81dc-a4b19e231f06@redhat.com>
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-3-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 20 Oct 2023, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
>
> The following patches will use the number of counters information
> from the arm_pmu and use this to set the PMCR.N for the guest
> during vCPU reset. However, since the guest is not associated
> with any arm_pmu until userspace configures the vPMU device
> attributes, and a reset can happen before this event, assign a
> default PMU to the guest just before doing the reset.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

