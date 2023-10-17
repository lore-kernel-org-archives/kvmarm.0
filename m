Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138C9EBE
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 15:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMNTEeUZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697557964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RJCFeyH99wewsxYRk1lLnjPIdN1WhsmhUxQEUY5pO/k=;
	b=SMNTEeUZcePqdajsYwY4mcGEWZ1mORTDWk2BOBvtYMp41oWtHS/UsM+ZohzVyFvADHhO3q
	VtTjW8hU+5VMyqDu8IlU1ktntK6LrdIIWKSIKkgb/5CjdGUVQWO0VbCYrGqOXbOTpm0cLd
	eiEIWK6A9FOI2AOyPPRKhmRUiD8SJiM=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-zz9gAGmjMuKVY9I1Nzk8Yg-1; Tue, 17 Oct 2023 11:52:42 -0400
X-MC-Unique: zz9gAGmjMuKVY9I1Nzk8Yg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5a7cf717bacso91373577b3.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 08:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697557962; x=1698162762;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RJCFeyH99wewsxYRk1lLnjPIdN1WhsmhUxQEUY5pO/k=;
        b=kNbL6oDHI8sgvTeaDzzhF//9SegW0CSXJBSEa+USB9EDgnFnQdoSYQP4eNkEjDyafo
         +SnlOGM3ySC4U5lIyL8/hBvE8yuZNeB/twJOlnXXxPnE+4O/w3VKM3XJBnFn7CWQ086t
         xhWE2oCmpvvJUZJ3L245zl5g8DNfmTu0UED5tJ2Ul7KGVUhuEffiumWaL/Y6gM7SfdUg
         WL6mj+mt5UjE8ETFGKSaJbbUQRotIyeT34OgPWvCEhrOK7snjrOTGguZT7nHbsa0UNPY
         HUUCOX+Vz2CF8be76F9TE4Dr7k48uAaCsN1KcuPDXN/gxIJtjcuHQ1WTphF3paQUf4bR
         Jlpw==
X-Gm-Message-State: AOJu0YzDZNp4Jr+R+IqhK4Yq1fO38P5JW0Cff3XNc2jBCT5cVr0FL1ql
	rZIwahQEsSycMnTnyjcg91WIEbt6JiahojWNPBQ7rcdd/Xcdhgmi0DcbYL12hYaV1Daf4+scyqT
	OpIQMhhdQpmuxnM6D
X-Received: by 2002:a81:8586:0:b0:570:2568:15e with SMTP id v128-20020a818586000000b005702568015emr2742449ywf.43.1697557961990;
        Tue, 17 Oct 2023 08:52:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6HOkqm7LrAZb56MJgs6JiaTCoAldeZtr1QWk1SvAvnpO0F4NFw1Cui2NnZEFeX0hOVtxaLg==
X-Received: by 2002:a81:8586:0:b0:570:2568:15e with SMTP id v128-20020a818586000000b005702568015emr2742428ywf.43.1697557961784;
        Tue, 17 Oct 2023 08:52:41 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id b8-20020a05620a0cc800b00772662b7804sm759453qkj.100.2023.10.17.08.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 08:52:41 -0700 (PDT)
Date: Tue, 17 Oct 2023 17:52:37 +0200 (CEST)
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
Subject: Re: [PATCH v7 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
In-Reply-To: <20231009230858.3444834-9-rananta@google.com>
Message-ID: <5d35c9f3-455e-6aa9-fd6a-4433cf70803a@redhat.com>
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-9-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> +		    u64 val)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 new_n, mutable_mask;
> +
> +	mutex_lock(&kvm->arch.config_lock);
> +
> +	/*
> +	 * Make PMCR immutable once the VM has started running, but do
> +	 * not return an error (-EBUSY) to meet the existing expectations.
> +	 */

Why should we mention which error we're _not_ returning?


> +	if (kvm_vm_has_ran_once(vcpu->kvm)) {
> +		mutex_unlock(&kvm->arch.config_lock);
> +		return 0;
> +	}

