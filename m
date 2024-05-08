Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3B41A2C05
	for <kvmarm@lists.linux.dev>; Wed,  8 May 2024 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715181452; cv=none; b=nt04vQA0l0ai5a8uh1m1NdmuvqFhXx75L2BqupKUeOIiu73bbD3+EZFxebrb6i5F6T0lWMi3Hg3mI3yfs8CxVHljBVYnlAA7VWFLBm5CXCjm2Gz9SbU1WsRCIrtQe4eCeHy9Vjhaxg2KLxGKi5+gJBWZ+yz75GTxTWwRhJq8sDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715181452; c=relaxed/simple;
	bh=gRdB9n65LyXMjkfsB0lKXNxvTGZOBUlH+iocBIKF/t8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pU4w7JTEhHJ3fBnJDlmi1UDibjcHvzgqtQjcNR6Vzl284kRyIzbSXDpiZzOG/knXSAo59DOn1nzuhDwebv/cRcu1ysqsWfF+BDptVbdQseVdwkNPSppjDzVTIWmigmP7lDUBVuETfv6Uj+2j90xmwY8Jhk3X2sfPWNfByX+PlRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L0uJXlfx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L0uJXlfx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715181449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VIad/R/g2y7/8Prfc6dEDdL10xOaoHh1ag7PtNI4GYE=;
	b=L0uJXlfxg/d5JuwMBdB9WoXP15sabCWxEpeWATCih4PFOd4NItiCzZGVU+FgiA1CM9oiG7
	YYJ8b6BsBAXMH9+4YJIMpsWB6IHL2krQVEdNRaZNUDdxqtR+T8DUqYBF7GDu6TigWo5ucc
	ce78ERu4tzH5oLGVenPZyHwP2KzudsY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-ie0pofjMMmSTMamQY6erhw-1; Wed, 08 May 2024 11:17:28 -0400
X-MC-Unique: ie0pofjMMmSTMamQY6erhw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41ab62f535aso17061945e9.0
        for <kvmarm@lists.linux.dev>; Wed, 08 May 2024 08:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715181447; x=1715786247;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VIad/R/g2y7/8Prfc6dEDdL10xOaoHh1ag7PtNI4GYE=;
        b=U5l5uUGiU4GM7JdD+UaR0m8Ip+wxWBZPEqLpeEDJUiOVH/SbFDjvfII1l1/BfTd8rb
         4O9ZtZlb7WverTvbtAIXH4itttDZyhbOb6Jz0Tak9+YU7hYwZU7WDR7+4MBvn0PB486I
         7RnsCDkdaSeKcyPxBAxUBdM28KVig/MUWqyIj4ARhxErlSshIbQbTVe9/YCFX9pFkyNq
         bfD7EQG4+QjPw4KKZS/PS5DAdyGiiTVgFv72e+2S/wI0LEUo5AQ05jDU+lC303Av5gQ8
         kMsaTp/dGXOTqrZxKg6jRY8ii/jq+14XNqh96TNGO/DqtncUveH4pbUO44aPaTRd9VhT
         GLRA==
X-Forwarded-Encrypted: i=1; AJvYcCVjUIDRsLqAKm/u60OIXNeMp9i5k2dpOEsNCYk1K8LRwInX9id/v5ZcME0/Y/DiyReTRIbAZs3tk5cUPEqht/KAXQRN3WdS
X-Gm-Message-State: AOJu0YyQrgl5LF5QSXpn376hXXKOpE8P5R7Im2qIFTkjlAap7u9HlmY2
	7fKKO5+swbGWI93+RNQ5ATTBrFjJBGLWY3+YWmmbEZht4YEto/GeX2UJJr0VipoHvSo6II+e2Qc
	my9dTsqiHBNEazG1OFk1PWQUolG2vc/yA2jLzvUDjCP5QoqA/I/CFRw==
X-Received: by 2002:a05:600c:19d4:b0:418:ee2:5911 with SMTP id 5b1f17b1804b1-41f719d5e37mr22162105e9.28.1715181447047;
        Wed, 08 May 2024 08:17:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5Ud+DNGoE9CqTLGhS8uyH+zdil3VjI9FsxdYScCIgSCwwJsBYlhxzIamR62bh7Oj4RwndnA==
X-Received: by 2002:a05:600c:19d4:b0:418:ee2:5911 with SMTP id 5b1f17b1804b1-41f719d5e37mr22161935e9.28.1715181446699;
        Wed, 08 May 2024 08:17:26 -0700 (PDT)
Received: from rh (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id v6-20020a5d6106000000b0034d743eb8dfsm15550428wrt.29.2024.05.08.08.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 08:17:26 -0700 (PDT)
Date: Wed, 8 May 2024 17:17:25 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 4/6] KVM: arm64: add emulation for CTR_EL0 register
In-Reply-To: <ZjH6DcedmJsAb6vw@linux.dev>
Message-ID: <29e7b97b-7a61-9b64-2c57-5a5d0e5f190e@redhat.com>
References: <20240426104950.7382-1-sebott@redhat.com> <20240426104950.7382-5-sebott@redhat.com> <ZjH6DcedmJsAb6vw@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hej Oliver,

On Wed, 1 May 2024, Oliver Upton wrote:
>> +static u64 reset_ctr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
>> +{
>> +	vcpu->kvm->arch.ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
>> +	return vcpu->kvm->arch.ctr_el0;
>> +}
>> +
>
> We definitely do not want this value to change across a vCPU reset, it
> should be handled like the other ID registers where they only get reset
> once for the VM lifetime.

Hm, maybe I'm misreading the code here but I don't think this is true
for existing regs e.g. CLIDR_EL1 or the stuff defined via ID_WRITABLE().

Sebastian

