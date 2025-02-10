Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C951C07E5
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 12:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739192184; cv=none; b=jvHcDASjv5c0WRG7WO8YPEBglWBZuLYFyttZnN14/OBPKkBN1jpIEHntZhC1qubZ0NiDyzxNbRpYtLWVLLXUK7fQwWs3qyRpuxsP0U/uJLArARqI3J5bF3EFISaJPc0V96Te/bEA94Ri9r0l1zN3vNbpQ1yE34y25OTauPiKCMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739192184; c=relaxed/simple;
	bh=AM8r7Al44OxoWA3Zm77MOmrR6rDzDg47XwlgXoaDk2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L1Ep36l7Zd8GyPsbtUIpBrpAdPxCtZejm20Txq9YexTD95J/M/8JCsu8HMuv35XQGczuo2YtiWOBUCe4l2O/7sQiqFxa3cukwFFEufDKMmKqT2lGNfxzj1/Un+rh0USjl9qscK9fMoH7BaX6fZlnRzbJDHMRSVatLpP5ouWIIDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NujU0rMW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NujU0rMW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739192181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QMJ6zzLiiyEY3Ydp/SdDJEADRTX0+mn49qrPTc9KqfM=;
	b=NujU0rMWF6Nd+kRBoM+eX53OfSXLXijmQUqo8PRa/gH4agcAyStMVGQBn30a4yz9XHkM1f
	yzQzu0h/mK5foYJMApHGMf4ckwOjEQzP0LJhLoivzfnmw1HM2ELIhQXKwNh3mEde8faFmv
	sX+Rs1jKiqqNlfaJy0kwB9F/nqrS2CY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-JecGNqCxMWWnTqSmrhFl3g-1; Mon, 10 Feb 2025 07:56:20 -0500
X-MC-Unique: JecGNqCxMWWnTqSmrhFl3g-1
X-Mimecast-MFC-AGG-ID: JecGNqCxMWWnTqSmrhFl3g
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ab78bcb4b09so328164066b.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 04:56:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739192179; x=1739796979;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QMJ6zzLiiyEY3Ydp/SdDJEADRTX0+mn49qrPTc9KqfM=;
        b=gfSomf8QlyanC8tG1YXfLE1KtDAeZk3RHERQjU/Osb0pQDN6RiAuG5nPkELJLJ5c6r
         ZrENvikXaM85m1N5uvEE9/xOCe1z2UX+8S4M3jSlYxcZ2zLyGy64GJ4OcX62fQtY960k
         TIcbj9Knvra6puG3NKtREHBaum1X1MQp+4aooLFIAXuwsju4ImJ2o/PGY010LDF95wdT
         Ufv2YY/wfw9+wusVCEp3ZvYW3p/0PEQcYPQ3HN0lTYuQkUCqXtPXDbebmcP7qLwXmkur
         eqmBQUDHHw0is+j3vNwT+FIgjrlZ2r5yd2U5X/fFctVttgwdKcCtw5qU4PN208FNSgoW
         8p/A==
X-Forwarded-Encrypted: i=1; AJvYcCXezNsdtcMowiRvyWTCxpC6xLBGd0aBCHH/RP9NctqRZHmw/6AOUyaIu77qA8AhbWCrQmqSsRo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBjgDvrSj+5pg5OT+t7Aw8bACFznze3dv8O18eSvdS5jHmWVBK
	bPtnjuyuETBKq/MAZSvU//lb+5lETEV37wPRXmw09RImNnYYfeuxYPSuxzi/CD4mma+T0XJ7F33
	NLeHYspydUK6P03a6XwfQjdlmp9nPenVwARtmPwXLfb7Yjnt32Yj+69M+cJNhw5gy
X-Gm-Gg: ASbGncuThVrf5zIGM65Vx//AfVlnDr14/Si5dejvj6plsM2y2O32VbUcdUKZ02cmSoj
	4Y2go2dRrGkRx/aHZGtipRLLXash54jv1UHQpDj16RTJbs3D3ut8vnYYCqE/FGrlzmvRiAOf1nU
	Y4RiSYrsLwpgqf46LaVz+Re64MWgP/S5kwjYFy0zs7B35sYPnwVOBgZGoUEayIaSj8Z5VdK0CPI
	7YQvcFiwGDxboxfqmZ2kYmHCL/da84LcGoZ7tTr6ov6rtAKBrFY8WRExmHG8+WVD1KLydsycFqt
	4J0q3A==
X-Received: by 2002:a17:907:d204:b0:ab7:b589:4f9e with SMTP id a640c23a62f3a-ab7b5894fe3mr542372366b.39.1739192179254;
        Mon, 10 Feb 2025 04:56:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFabAXqHVT9MWeUjhH+ne18nwueJNMJ5fXQ0srpHuFth5385zolS0vCYf7bI/JgNYRpmneBA==
X-Received: by 2002:a17:907:d204:b0:ab7:b589:4f9e with SMTP id a640c23a62f3a-ab7b5894fe3mr542371166b.39.1739192178864;
        Mon, 10 Feb 2025 04:56:18 -0800 (PST)
Received: from [192.168.10.3] ([151.62.97.55])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ab7c70f4064sm158609966b.170.2025.02.10.04.56.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 04:56:18 -0800 (PST)
Message-ID: <ddab0f10-7218-416f-af9a-47c1425a2f52@redhat.com>
Date: Mon, 10 Feb 2025 13:56:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Question about lock_all_vcpus
To: Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, "anup@brainfault.org" <anup@brainfault.org>
References: <dd333b6d05e2757daf0dffa17ae9af5eb3498e05.camel@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <dd333b6d05e2757daf0dffa17ae9af5eb3498e05.camel@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gAn6BCePRLRSSV059HeKdaelE2WX1INybpv6ylbdG4k_1739192180
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/25 21:08, Maxim Levitsky wrote:
> Do you think that it's possible? or know if there were any efforts 
> to get rid of lock_all_vcpus to avoid this problem? If not possible, 
> maybe we can exclude the lock_all_vcpus from the lockdep validator?
> 
> AFAIK, on x86 most of the similar cases where lock_all_vcpus could 
> be used are handled by assuming and enforcing that userspace will 
> call these functions prior to first vCPU is created an/or run, thus 
> the need for such locking doesn't exist.

The way x86 handles something like lock_all_vcpus() is in function
sev_lock_vcpus_for_migration(), where all vCPUs from the same VM are
collapsed into a single lock key.

This works because you know that multiple vCPU mutexes are only nested
while kvm->lock is held as well.  Since that's the case also for ARM's
lock_all_vcpus(), perhaps sev_lock_vcpus_for_migration() and 
sev_unlock_vcpus_for_migration() could be moved to virt/kvm/kvm_main.c 
(and renamed to kvm_{lock,unlock}_all_vcpus_nested(); with another 
function that lacks the _nested suffix and hardcodes that argument to 0).

RISC-V also has a copy of lock_all_vcpus() and it also has the kvm->lock 
around it thanks to kvm_ioctl_create_device(); so it can use the same 
generic function, too.

Paolo

> Recently x86 got a lot of cleanups to enforce this, like for example 
> enforce that userspace won't change CPUID after a vCPU has run.
> 
> Best regards, Maxim Levitsky
> 
> 

