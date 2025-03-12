Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3885A156C62
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 17:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741800796; cv=none; b=UMzMAeIi+UIcGoJoYAl4BpHB7bfRwYsKd1VhALS94pqYxvWAY+lG7Zz+cFlq5EKA2IGv4tsHsPl5R+XBIJe5Qv616wwjPSW5b+yeS6Cwo9yp4m0Zw/UaabNZ8nPUOM480UvsPF/iOBBAhiVedjCWGGtKDigLqxWEyT1Cp85WMAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741800796; c=relaxed/simple;
	bh=dvyJrdPXem/t9rhGc0og2q57i3iOEHExNGrbOAeLIoQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=PBSO6eAZfz/YqripWJc+MUIzvc2baXcrFrT/0x9QtStZIg6Dk3WeYGLyYzooTKWtSv/EaFxSNX6xqvO1xwg4bhJVE0EBFXhrU4ZXTmpcF8/+LuzcwfnV4SpIRfIcAAe1pa1VmAH3Z5M/p+uuIZlZk+RlXGHvSjC7/xJ9s11QlMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GtIyhi0V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GtIyhi0V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741800794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dvyJrdPXem/t9rhGc0og2q57i3iOEHExNGrbOAeLIoQ=;
	b=GtIyhi0VVeMCSNwOxLSXImqvhY2DDP2xOGcudci47exK8eYEANsNH5V0e31Zh2XA+8oYXN
	wKcR9I+2MhD3/V5C3MN2kVLE1apylmYZMzX3JTrpFTcXkixCCJKaGCs8TOX6JPHa2z6TZ0
	7kYgfJ9pH87/hTpKKrODF1HX/A7zjEI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-m3RbBi0YPbKhkrK9jmr3lg-1; Wed, 12 Mar 2025 13:33:12 -0400
X-MC-Unique: m3RbBi0YPbKhkrK9jmr3lg-1
X-Mimecast-MFC-AGG-ID: m3RbBi0YPbKhkrK9jmr3lg_1741800792
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43bd8fd03a2so206285e9.3
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 10:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741800792; x=1742405592;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dvyJrdPXem/t9rhGc0og2q57i3iOEHExNGrbOAeLIoQ=;
        b=dLxoNuEKNndvP3WYit2L7+J7sJw1gMuGwBbnGVoVs1HXr3Do/dPZ5ItRnDjN94/axf
         +q3xR/S0nt1B4fYDp/9ySSFWGJVMaN2tlChuFQ0nKTDfQiDMfgh5QSh8m6gFA0ycwvnC
         woiHYhg+uCkM2d01fUTVKYd1pr1Hmw6A/7GrbAHQLqJGnGv46hZ3q7YsUWgNySibCjEz
         NH16T08Kf6F+8zbVUEbuVNq8HCtisxk3NE8448KpfrbUoCzRf44FldV5/hY6USOI3t8j
         J9YBpOhM9FI7d7QtfHpqJSW8esjrqwHJtj+OFwuKQN5xD6R8fonVJ9t3uAUWKqvo4h2g
         bj4A==
X-Forwarded-Encrypted: i=1; AJvYcCVxgGh9/rrdvqhYmRKlW7k49jDrdxDMs9e7gjcYRLnbwXXMG9YO10iR90K05Xcj4MFrSCD06z4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzmfq/xqU5kF/mg4sRjXqnOPGTAnOMJ0ANp85dH1lXzOqRwPyMg
	nMeNCtcMFs2XJcPAGFTOjqFbSbh9b/DxAy/5Pfl/xrvkb6s+QvXZGkfxR5ySBjZTVHsIAl1QAcr
	GFlvmHg1+fuxFlEXNF/UiVJd4FgG+ocDeAkWTJkuiVOmaWpBiXlXlRg==
X-Gm-Gg: ASbGncvqBRqY+5ZxcfjmesOF0V5guzsttJOwecNaTqZJb0qIAXGcrcMsTQyS3mVTTS3
	LIqxTkjgHpX2QU91aTxroLeJ9l/0lDCbUBpWLiVMggIpnUuKg0IZM3Frg6L3NkTFG0IsgjIjoCk
	QXTVvN7nkKW11tMNvKfRasV9jiQGwVDg/AMGgMoPb/VX8nSCgW3DHb6ZkfqT3WqFKekyxfqUamq
	8+u4og9/woDI53El+jjZ61efYOpiPZnK6HrnnyAIPA0Rq9hPQp00qazDC1TiQDyEnj6/AbAbjO1
	hvB3Ot066C/9vhuI5vzF4omhPtFzdHbnG2v9EETsCTz9Ee2/4s+AAIbeaKAFemyq
X-Received: by 2002:a05:600c:190c:b0:43c:ea40:ae4a with SMTP id 5b1f17b1804b1-43cea40af7amr151794735e9.31.1741800791742;
        Wed, 12 Mar 2025 10:33:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkDaxroZKHcALMxZZ+BxRIhiOexx6MlAPp0LIXP7yGXSlrtMMJvV8WhA2IxMPpSEUR5gjapA==
X-Received: by 2002:a05:600c:190c:b0:43c:ea40:ae4a with SMTP id 5b1f17b1804b1-43cea40af7amr151794565e9.31.1741800791436;
        Wed, 12 Mar 2025 10:33:11 -0700 (PDT)
Received: from rh (p200300f6af11ec00f9928575aec32536.dip0.t-ipconnect.de. [2003:f6:af11:ec00:f992:8575:aec3:2536])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d0a74b699sm27660235e9.10.2025.03.12.10.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 10:33:10 -0700 (PDT)
Date: Wed, 12 Mar 2025 18:33:09 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Writable TGRAN*_2
In-Reply-To: <Z9HCQ40LxShzL4nj@linux.dev>
Message-ID: <eb045be7-69ca-fe71-0333-086b71bb624f@redhat.com>
References: <20250306184013.30008-1-sebott@redhat.com> <Z9HCQ40LxShzL4nj@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cK_Nj5dKxIXYtYT_gIk08jP1XlIybfgnlIDNnjDD6rs_1741800792
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Oliver,

On Wed, 12 Mar 2025, Oliver Upton wrote:
> Hi Sebastian,
>
> On Thu, Mar 06, 2025 at 07:40:13PM +0100, Sebastian Ott wrote:
>> Allow userspace to write the safe (NI) value for ID_AA64MMFR0_EL1.TGRAN*_2.
>> Disallow to change these fields for NV since kvm provides a sanitized view
>> for them based on the PAGE_SIZE.
>> Also add these bits to the set_id_regs selftest.
>>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>
> I can't tell what you've based this patch on, it certainly doesn't apply
> on a 6.14 rc. Consider telling git to include the base commit next time
> you generate a patch.

Ok, I'll keep it in mind for next time.
(It was kvm-arm64/next + 2 pkvm series from the list that I applied
manually.)

> Please do selftests changes in a separate patch.
>
> Don't worry about respinning, I'll fix this up and queue it in a moment.

Thanks!
Sebastian

