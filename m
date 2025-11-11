Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FA222157B
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762883414; cv=none; b=D+GCAo+uONiZ0ICgGfoEvvJJyKVgtScxlB4ab7suDNN/NUqgCLXHP0TcjZqN/Z1bLlCg7/VrOyH5MtSd7KpF64bnK1LoTIWflUsFatox/YZrQxeoOGN+94+XGdbEu6wcvcGUDtqEQBYBEH/Qa4LRzrxyKlZVZFN7by/e+CPDlq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762883414; c=relaxed/simple;
	bh=WWMmwhWdWNyNjLHmzBhq4csR610NwWHiadSzqjR/lWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jcghXJDqR5z83IK4+53lWhxCGOB31gvn3/ciIcbDWTTh6JyKy3fe5e1WxvVR1rvN0SwXlOuAr3TZxP3xXBGr+ELYsS9209F7Mu2glmW0rpvINQ+n9dmqlF8TNjd6g9iHWWe8xjkyNofBpoe6I8pYsq2C1NQGW6R6wA9md7bHZmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hWeApdl6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hWeApdl6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762883411;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5YdgpSepIM+Vu72ZmZR6JDazpPsxkKp2SzwOXtK9HQ=;
	b=hWeApdl6Raz+/kUtfVgtWcAsjtm7PP6DMAsqtsZGYmfyGng/ngNIvOxKQhRtuRCux4mUUA
	n3aW/YEFjHTZ55gaaZMUO6YLT5QZV1fNOWInhz1FNUrf8BNCPtxvPUqVWL+lvAPuV0L153
	cf+TPIBwelLhE7tYSU21GzkwJtGbis4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-JH49fpmZNJOBIF-CKhWw3w-1; Tue, 11 Nov 2025 12:50:10 -0500
X-MC-Unique: JH49fpmZNJOBIF-CKhWw3w-1
X-Mimecast-MFC-AGG-ID: JH49fpmZNJOBIF-CKhWw3w_1762883410
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-88234e4a694so100620636d6.3
        for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 09:50:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762883410; x=1763488210;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5YdgpSepIM+Vu72ZmZR6JDazpPsxkKp2SzwOXtK9HQ=;
        b=b955ZiXYYoULBNjYOsrbTdinNfZaUXfD+9/Ux/oKMpfmgVJ9XLkuJ/88vymOHsk3u3
         01P50hbOoulDKc1H+cTehG1NGBAOcOC3XtJC7gLY3A918J/drZiBAgxSFnSxMRUpajD0
         bNlzxkyJ3uaSo9UduXiF2wk8LvU2M+T016/WFya5CxBo7EnYIjCmw6EHQsqtNFHS0USy
         DfdHUDdGk3RPbVxfbiqDp+nuCDZnVmUjxPthtalsG6JJhpPSJopv9w0ErJS0izXvmF9u
         u2sndpxStc9DqjEdT0LbD7zKZHC2ILnNwb4zjGVfmSd7UxUVey5oZkU2oa7XHd1WVQuB
         Ku9g==
X-Forwarded-Encrypted: i=1; AJvYcCXUrXs7GQhuXw3O8yHZmDI6/En+uBNS7ChhrSSTM4GNQRmzHcdF2seQnW0wYycVRxrJ+Jib8sg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSrl7xwEwQjTix0J96aIzkbMqEmt+euVQFjZr8paVevcFZRi0n
	Amzv9F4cSL2mYfaApmcjgtNreHyWl3yw+czWpX8i1OvxoA30HfTg9R3c+w3bQcfQE/lfuuCa/rr
	KXIwusoJYDm+x4GdNuthzVgn4OdE/WBP9Er8SD5wG4SyeS/e/BIHmAi9gEg==
X-Gm-Gg: ASbGnctO8DxPrKps7J9JvJoO/kyKJGXj/yJKQnACHj+SBm0bNtuP8l8jCBx5xpVD5tS
	nGWASxY/3tEjmWu9xtpQ6I46TtIuLAfp4M/jyX4z9ZXshgWvfCJS7OP9QT7qkJRRJP19xGtHJN/
	ZtNyg3i/gJreb+aUrTfoWzzhbHJ/7UDOy8TcpbSBkBDNqUS3Fq+PapjSE0rY74pm8tQFItJEJ6V
	zy3hebdaJOYNLQWy6CUd4Owg6px+sj2ehCUczKXa2VSeaU8FmtgZQamd4WOYO1Ch/6hop/GJn/y
	wPErxTu2D57y1CNn985fBwNDepXD7pTGTfxceQvfJ5lkxajBGHl/q28RT+FqQQ8Jxdw/DVfwPZN
	dfxSpojVlzmzjnx3RilMSIK9zzTWtRcwBlsQfm3MwuEUlZF45IbB/Rybu
X-Received: by 2002:a05:6214:1256:b0:882:3828:fa33 with SMTP id 6a1803df08f44-8827195f622mr3497546d6.26.1762883410116;
        Tue, 11 Nov 2025 09:50:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0Ci9tdkmBBhpaJb4rkRghX6NZbIVWm0/hZnIdsIzeoWFuTuvMXuGLGtwGnZRnSZ7XXAbryQ==
X-Received: by 2002:a05:6214:1256:b0:882:3828:fa33 with SMTP id 6a1803df08f44-8827195f622mr3497326d6.26.1762883409798;
        Tue, 11 Nov 2025 09:50:09 -0800 (PST)
Received: from [10.188.251.182] (cust-east-par-46-193-65-163.cust.wifirst.net. [46.193.65.163])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88238baa0aesm76833956d6.60.2025.11.11.09.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 09:50:09 -0800 (PST)
Message-ID: <ad87bec9-e36d-4c5d-adf8-ae92917451a2@redhat.com>
Date: Tue, 11 Nov 2025 18:50:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 1/2] target/arm/kvm: add constants for new PSCI
 versions
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251030165905.73295-1-sebott@redhat.com>
 <20251030165905.73295-2-sebott@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20251030165905.73295-2-sebott@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zaDmbtDsJAYwhnMzau-Fk_QaGiAssWgT8Uv4CqP252E_1762883410
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sebstian,

On 10/30/25 5:59 PM, Sebastian Ott wrote:
> Add constants for PSCI version 1_2 and 1_3.
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  target/arm/kvm-consts.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
> index 54ae5da7ce..9fba3e886d 100644
> --- a/target/arm/kvm-consts.h
> +++ b/target/arm/kvm-consts.h
> @@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
>  #define QEMU_PSCI_VERSION_0_2                     0x00002
>  #define QEMU_PSCI_VERSION_1_0                     0x10000
>  #define QEMU_PSCI_VERSION_1_1                     0x10001
> +#define QEMU_PSCI_VERSION_1_2                     0x10002
> +#define QEMU_PSCI_VERSION_1_3                     0x10003
>  
>  MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
>  /* We don't bother to check every possible version value */

