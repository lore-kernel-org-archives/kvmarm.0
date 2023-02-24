Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33FCAD58
	for <kvmarm@lists.linux.dev>; Fri, 24 Feb 2023 20:08:17 +0000 (UTC)
Received: by mail-io1-f73.google.com with SMTP id a21-20020a5d9595000000b0074c9dc19e16so49546ioo.15
        for <kvmarm@lists.linux.dev>; Fri, 24 Feb 2023 12:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lq/fW+1gQO4fLzyopuslQ/5nt8lJLNNZbLNdvJWyg60=;
        b=ZRD06LxPDQh9ndgSUCZKyVPO+p4ZA36dw5+dprfLdTO1Ui40tseTDQjix2pt2YBxxE
         tbqXrbhQTasOXR40M+gIvXG6PO98fL+MTLjngEqkPe942ohJx1kTbRgLMJR6n7SuHVWZ
         sBVUuDZEAzsSY5FCBVtD9c1hXQwn+NRkzhy0uinLsxMyLDGF9DWgg8reJ97cOliMic3M
         Cvbq71846TzqLx9xDWyDRMaLZxaky03us3gIr7RSoHMOCh6Yo5Kteg8K7NUbeW+C+xfs
         cPAYuQNlPMngtJDDZf01j805hKirkQWR2EJyKyvFyTFpSgJTPo3t3ERtHGPPSW3IYmIx
         WCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lq/fW+1gQO4fLzyopuslQ/5nt8lJLNNZbLNdvJWyg60=;
        b=058LRrGGCxka+cPR66kq4ER16+GuvdnC04ByINofUzVv+i3FQCT+QvPdG6q+hfF1kW
         o2WITFGDO87a6Cq+DXzB8sfRAnJvBstlEpyZXuF6DYab3rxLC2NhxOWTOJVmBqp+DCwC
         NMhAerMUcfucZjwHlYHnbQvmkdUz2MQEHnBtDcBMAV4oYQfhyTXdSMg45kCIUTy/PauD
         Eo4RO8kHDUWMpZ2sS89I74FLfJuxgDUInNMVP4mGTDqAcx7mhlCitV1wJQBsmY4hisIg
         woYbrR5MWYpe6uhZwLhRA0g3P21iNvrIqRGMXDimdD30oLqIS0aPx56Eboo0UKeypzIe
         s8LQ==
X-Gm-Message-State: AO0yUKVmJX/96ALrFFHN8XyOKxS9Z36J90T/9X1oGsA3+pXBf1jePjUp
	AmcMynnFzEbOUM28rGWt3fOTWSw4NwxnsDrwsw==
X-Google-Smtp-Source: AK7set+6She2NcmRmPNnegMaKKLqU4exl69q8s3WqgCHl+QehD+6uDHs/Ir9zbRNO8GYwqkkC/9xJcwgXnvvvkKQEQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:a1c5:0:b0:3c4:d4b2:f72 with SMTP
 id o5-20020a02a1c5000000b003c4d4b20f72mr5755289jah.3.1677269296880; Fri, 24
 Feb 2023 12:08:16 -0800 (PST)
Date: Fri, 24 Feb 2023 20:08:15 +0000
In-Reply-To: <20230216142123.2638675-14-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:20 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntilfq968g.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 13/16] KVM: arm64: nv: timers: Support hyp timer emulation
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org, 
	christoffer.dall@arm.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

I hope someone else looks at this one because I don't understand NV.

Marc Zyngier <maz@kernel.org> writes:

> +	struct arch_timer_context *ctx;
> +
> +	ctx = (vcpu_has_nv(vcpu) && is_hyp_ctxt(vcpu)) ? vcpu_hvtimer(vcpu)
> +						       : vcpu_vtimer(vcpu);

I don't think that ternary is the easiest to read and would prefer an if
statement.
