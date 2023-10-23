Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDEF1BDDE
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 15:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NtAWkSba"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698074684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YrnXzVdFyG8cEywC86c0X/I901FAAiWZF1AhPDWq6c4=;
	b=NtAWkSbad+KHtd/fIKf8rL7pJZYrfNBGemH063DgcImvxzsHwzSEiEXJZb/UvJe6SS4/sQ
	BYSxmNInjpjevkHBdssfln1a18UEa5AaggDvTE+SM+NhIKrHiW9XWoz6Eg3Ri+2dm7MmIr
	/lJ30S6Ohv8irZl7pCJEcTSUlm4/SCY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-qcHB1mB7PW6ANTOQOEOMMg-1; Mon, 23 Oct 2023 11:24:42 -0400
X-MC-Unique: qcHB1mB7PW6ANTOQOEOMMg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7740829f2beso479470885a.2
        for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 08:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698074682; x=1698679482;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YrnXzVdFyG8cEywC86c0X/I901FAAiWZF1AhPDWq6c4=;
        b=u1A85Jg5Nzb+JVnN3uUC5CldC3q1hQLDtdUr02ii7oUdtO7w1RNGcDxJo8LAhUr7XS
         kKMnMbvnUhM84ean7itLdxzI0WtOdC3gm1P7NWYm+9Hi3gv0XfTOuf92r46oraqaUvl+
         1AUMm2Urwd0AE2ICEaWRxmdL55a+VzVdeggHKHjYRpwhEd7yIUv4Go3auKtznwkutog6
         2zoh66Gq28nkq/g8alFAOjxA1a0z7/JPFYif1+HyMj3dvCUUJwEE8dH37QdsTbxiHx0y
         C2scnXwU/rABFubyWu1ZI6TDj7CIwMsmssPRsoFQ2sBJYQITujY6wfOkJF4Q1UvspX5E
         ZvcQ==
X-Gm-Message-State: AOJu0YzCe06SygU2Dwqck6VLE/RLALhQZqF9svtZvxDFna0V9XyBgkJq
	3pXSPMLx1vZhl65O+VscUwB2ImVoDk0H4KQroK4Ki4U121iI6tHLj8Mjo2/xW66Wt7OKRRsSu7x
	ZYpFxPyWUjUDGbRgd
X-Received: by 2002:a05:620a:2909:b0:779:db14:53bd with SMTP id m9-20020a05620a290900b00779db1453bdmr3606675qkp.32.1698074682214;
        Mon, 23 Oct 2023 08:24:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0oXNOI2bZ0Q7EOH0xkSQPuJV1uT5Nv9oLcwOjU3v7FEChoNMD+vNwx5JP/j0OgNyb9geOCQ==
X-Received: by 2002:a05:620a:2909:b0:779:db14:53bd with SMTP id m9-20020a05620a290900b00779db1453bdmr3606648qkp.32.1698074682007;
        Mon, 23 Oct 2023 08:24:42 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id w20-20020a05620a149400b0076cbcf8ad3bsm2757613qkj.55.2023.10.23.08.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 08:24:41 -0700 (PDT)
Date: Mon, 23 Oct 2023 17:24:35 +0200 (CEST)
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
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
    Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v8 01/13] KVM: arm64: PMU: Introduce helpers to set the
 guest's PMU
In-Reply-To: <20231020214053.2144305-2-rananta@google.com>
Message-ID: <ed5c4213-d4ee-2c51-fff4-a3906876ee5a@redhat.com>
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-2-rananta@google.com>
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
> Introduce new helper functions to set the guest's PMU
> (kvm->arch.arm_pmu) either to a default probed instance or to a
> caller requested one, and use it when the guest's PMU needs to
> be set. These helpers will make it easier for the following
> patches to modify the relevant code.
>
> No functional change intended.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

