Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320A91F60A
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 02:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729132665; cv=none; b=GrpgzAfPgAK96MPRsStctVVnFoeSBPN5i3Jjyc7Q7qlmSgWM/8kBJle74imBqaAJsYTZ6GgPa+2a9TZmitH74b0evSs++YKEut8bWet4zeRRlX6edrf3HuaWrJB4TS1YjGK06FY9/o9MO9ckbPJUYKo4H16uC9KxiSgaySo5Ksc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729132665; c=relaxed/simple;
	bh=pA7tSpPZ2QboNIR13aev6/zX7LrGVM1dGZ+WlIRbJhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQS7BmOn2bKJBFREUDAzMZxJji6W1qpU0vde6tq+xaaqk6o/B5HbI7HMCzgRm/d/m0Oa/wDoaJBr5Ack0eqQV3QonBOmmYaEKgDFE2dCwqPkSuTjCuZys8ONu7i7bQkE8nTwyHpaKxQJfa2PokacF81K5NNNbMQS/3kcGizQ+oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OxHsnbf4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OxHsnbf4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729132661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qWniMANedXJ1EWKFF+mqezcITEv5frCFKYK2msKJk74=;
	b=OxHsnbf4Zvp7jnrBIrhx/us6mPznD8HSdHIj8IgoOebZZ4PQur+TTasrN6blPfdW8TcGZC
	IIv2PutkfXktMb25F6SzC2M4MUTtvMPxVxybm8SgdC5Nvqp+ghzQEE/+E6234OakrxPXPo
	tVhnHtUD+H3c2ee+WAY0Ern9BLNetN8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-rmSygzE1N02H0KDwiCNKzg-1; Wed, 16 Oct 2024 22:37:40 -0400
X-MC-Unique: rmSygzE1N02H0KDwiCNKzg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-20b61ec80a2so4348355ad.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 19:37:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729132658; x=1729737458;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qWniMANedXJ1EWKFF+mqezcITEv5frCFKYK2msKJk74=;
        b=j2+BxsOTI9IRxLXL0QCGM7qIeKVFg+64ahdKXPZeyUi1NqYLkCoMTQRMy+Ln7nDQAQ
         c8O5u7djmOifA5OxyssnBTLtrjmiEt7eTjQ7U4qYcvNfbujvCJg0fWpX/iq5+nwJRWSG
         ySOaubCouvWM2MEyTzv+QfhSwYQ6FlEJhjzPpmsEagaXBEAlE9R6cD4XqPOfZ/vS5MHZ
         TbTCEDVyPCSJrg0Cg1wasF6stdBHkTzVgtQmlojRqTO4Z8jlwYfzF2piNL/aLF4Fxb4Q
         dppM+P+FRp3aIeONfRb4E3iU98YRqgF8fh/EKBqb2CWWqo8FA2CdS1I5YOoSqed1io5X
         h1Yw==
X-Forwarded-Encrypted: i=1; AJvYcCUfv4CjSqeU0qKHxPK9aopQZP9Pd+SW3WkNt7xtVeFIm+nSsARj96DF5K9KL9/+rNybwPdIiEE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5cjYN4KriJMwWzVzLAagHW1IdkK0krMMUep/IIQZY5kt64JbG
	iWHxWfq54Jf/4TP3BM5uEWpyAXi7OBgdOcVq1jSBNOoreXhywFh7x3sOc8iugcNvLS/pQ1rYWdb
	MnKViyxE9DRok9rGvsF+P2SAHdZB81Cr/Fhu609YyXfNiPykHSzOSlNNODD3hZw==
X-Received: by 2002:a17:902:d2cf:b0:20b:8325:5a1e with SMTP id d9443c01a7336-20ca169062fmr231082405ad.36.1729132658489;
        Wed, 16 Oct 2024 19:37:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDgWYUaDJ3y6UYpIVyOAjerecoeFm1ZwrbvfoesHxxq9z1oRlfJ1erDbJW1r8GnXMwhr5pGQ==
X-Received: by 2002:a17:902:d2cf:b0:20b:8325:5a1e with SMTP id d9443c01a7336-20ca169062fmr231082205ad.36.1729132658139;
        Wed, 16 Oct 2024 19:37:38 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d17f9df81sm35027955ad.70.2024.10.16.19.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 19:37:37 -0700 (PDT)
Message-ID: <2a2cc0a8-8f44-41d1-ba01-9f274254789a@redhat.com>
Date: Thu, 17 Oct 2024 12:37:31 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/7] KVM: arm64: Add a macro for creating filtered
 sys_reg_descs entries
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-6-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241015133923.3910916-6-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 11:39 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> The sys_reg_descs array holds function pointers and reset value for
> managing the user-space and guest view of system registers. These
> are mostly created by a set of macro's as only some combinations
> of behaviour are needed.
> 
> If a register needs special treatment, its sys_reg_descs entry is
> open-coded. This is true of some id registers where the value provided
> by user-space is validated by some helpers.
> 
> Before adding another one of these, add a helper that covers the
> existing special cases. 'ID_FILTERED' expects helpers to set the
> user-space value, and retrieve the modified reset value.
> 
> Like ID_WRITABLE() this uses id_visibility(), which should have no functional
> change for the registers converted to use ID_FILTERED().
> 
> read_sanitised_id_aa64dfr0_el1() and read_sanitised_id_aa64pfr0_el1() have been
> refactored to be called kvm_read_sanitised_id_reg(), to try be consistent with
> ID_WRITABLE().
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   arch/arm64/kvm/sys_regs.c | 62 +++++++++++++++++++++++----------------
>   1 file changed, 36 insertions(+), 26 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

