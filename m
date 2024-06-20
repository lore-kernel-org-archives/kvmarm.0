Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4231B010F
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718897948; cv=none; b=QKD3fK8L7sqcQXdAf/M6LpXOT0ueZSECEK7CZWCzMr1wLxUWfBrCqmd2r7FJ5axF+zfSCp0qiFC5zv+HwS6hKnYGwFXmJY0dhxx+sBe3L+Z2CDbtmoF0m/pDhoqD71QaMFLqmYVHWbpqmHJyChgdu6Svt8Y7u5LWINE7Ig/5S5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718897948; c=relaxed/simple;
	bh=7MB1I1UVOTEXCsm5pjN83xKIVZzA23rlgdy0g9R1YFw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=YlOcZpKzG8ej5JRxWKhfsvG5Uo0ezcWrqPRXHMmJt3y+bcsYhABgtHnlWoWMDuXCRVftCyone1lwRfd0v2rjgAWN3SJqCnwIjEujJCiH8Mm5+HPH2lwjXU72X1wodlpDTw31wvzY7RS5muKJ79dtBgucpMrCdzVZLsuyqZzAS0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dLqbJstC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dLqbJstC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718897945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7MB1I1UVOTEXCsm5pjN83xKIVZzA23rlgdy0g9R1YFw=;
	b=dLqbJstCm7J07jGo6Ud/YwN8AKbkB0A+w0Qzvln926csWXOHttkNazw8jZrMouw5AG6SK3
	jrFVVWNSHd1pMg661RJihxmzNx5E7azig3W1ozjT/5TB2wJSgoJg/aReOVtkYPefH8EWG4
	g0KYF3nWKCnvVCzESwwE7TSmbD3NzCg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-tur7tHEfMVy5uT7ma-kOtQ-1; Thu, 20 Jun 2024 11:39:02 -0400
X-MC-Unique: tur7tHEfMVy5uT7ma-kOtQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-797d167a402so116511085a.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 08:39:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718897941; x=1719502741;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7MB1I1UVOTEXCsm5pjN83xKIVZzA23rlgdy0g9R1YFw=;
        b=TO/9ljeyS294T5FG6E+tO0NWZoZg/d7pToKIze8mnro+Ya7KdT5hkmI4mG6sUPI6Ua
         scJj0xH5HaGs6F/74yv8N0wzMqZHtgQE+aoBlRUslhSBdNvGrPQvzz/mh4iCxlGrEIhV
         qX2VfA3lgwZ0iU0SDzK5qT8iDn6vQI6gxER3ZbZVdj4ADjvqiLVY+L3gZ6uGDyvtjxyz
         o3hJcl5olYhNfkRRwrFfcbgVNNPfwgHAKVo21tU0pEBznpO8uWiXmKhvL68WlmbmAXbu
         PRCXjJbUXBOGasYfoE0XHmAI3GMup/2eI2VTF+aoXNyeE22p12pwGZJY+7v9ZUbTUQS8
         iTPQ==
X-Gm-Message-State: AOJu0Yx+LPWNx7TyFcK+YCOauikDKDrjjXAnrYqPlDDcHxyxxJjLFsR0
	KYMDTJ/KM8Xu+xuho8JewzCnOrbUEKKp2ecxkpc4xn0NhCQ8qIrPH6cweWYbfkTrX8lY3HpRI6l
	ywHSL5sj5eIH3Y3WMelJ4lom/iRIqV6Z2NCSOdbH3qG7dV5GTDcdIcw==
X-Received: by 2002:a05:620a:4109:b0:796:842c:77ef with SMTP id af79cd13be357-79bb3e1178fmr615652185a.10.1718897941548;
        Thu, 20 Jun 2024 08:39:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvwSPJpjWm/tOIuX081oVCD2HT9fyPjYjPX7yKJ9jzORjE/DVs3ALW+IJEPIHcnQvKKzPyyg==
X-Received: by 2002:a05:620a:4109:b0:796:842c:77ef with SMTP id af79cd13be357-79bb3e1178fmr615649785a.10.1718897941256;
        Thu, 20 Jun 2024 08:39:01 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-798aacc5267sm705627685a.18.2024.06.20.08.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:39:00 -0700 (PDT)
Date: Thu, 20 Jun 2024 17:38:55 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v5 01/10] KVM: arm64: Get sys_reg encoding from descriptor
 in idregs_debug_show()
In-Reply-To: <20240619174036.483943-2-oliver.upton@linux.dev>
Message-ID: <4474548f-f30c-5369-d058-6871caf04d67@redhat.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev> <20240619174036.483943-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 19 Jun 2024, Oliver Upton wrote:
> KVM is about to add support for more VM-scoped feature ID regs that
> live outside of the id_regs[] array, which means the index of the
> debugfs iterator may not actually be an index into the array.
>
> Prepare by getting the sys_reg encoding from the descriptor itself.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

