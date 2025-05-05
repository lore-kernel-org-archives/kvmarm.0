Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837A613D531
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746453692; cv=none; b=YjJblWXeEDKvHwYXGwI9vpmooZmc/x/BNmWebdabcK2WXxI4V/xG1qu8eBA2kiMycZWjoyFNcnnMQsQGUFrASsVSrhQuyddyYP+/8iLVKkkbHEd3/1+KSEQAwQyBTuQ5C0qQB2toQnxeeBBBvDlVYJFLAMf3i6/gjF/u4StBp8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746453692; c=relaxed/simple;
	bh=lggMFDTRC418IjzqTlRcBFR2dOSbcuiGBrWBhSWw0vc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=L/+2CtB1v9bM8GXSl7a5T5N4N9hkwSlFtT0sE9kZMvTnE0g9F7NeJlE6sPathO8nQKBsovidZUhzsbj6PP7H8ytUstfEjySRiwVyQBzRPT5CAKewQ2My0MlRfJRjWsyfJeJmlaomYBrpcC7TQyysBr2bFUPJme/O2nRgjg57h/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J2aCufCi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J2aCufCi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746453689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/w8rIxU/HB3/tNfk25aUgrHSFDYF6kYQyy+WRkU+kdE=;
	b=J2aCufCiHUntzuageZ6Fwj13XaBW6E79ldUqYrJTvG21Xw5a4bGpRvjwqeA0bCS25Z5i/A
	gAV5TFD2aTywtg0NRhlYR24zNT+7/2bFlBWsRx9y92QKLpFnDxtM/u7XlFfZLXgsdhyWJk
	iTfPoAA/r+QvBLsqnHx9aB637QL7dn4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-6tmJWVC3MsezjyneYsKgqQ-1; Mon, 05 May 2025 10:01:27 -0400
X-MC-Unique: 6tmJWVC3MsezjyneYsKgqQ-1
X-Mimecast-MFC-AGG-ID: 6tmJWVC3MsezjyneYsKgqQ_1746453687
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so23861365e9.1
        for <kvmarm@lists.linux.dev>; Mon, 05 May 2025 07:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746453686; x=1747058486;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/w8rIxU/HB3/tNfk25aUgrHSFDYF6kYQyy+WRkU+kdE=;
        b=C9DhQKuO8GOa+dbGUZYSOgL9m4McK78eSHT2HSogmb97Ee2VZz2VidUN75UnUZ2Im2
         P4LRy/Do8i7lKQzu6ebb3G4IE6w3ICkWu0RZl+Z+ewwEtleAquSiV4f8eT4fgQV8HycS
         AcySlCE9ilKvfccqukccxY08Rn/WApGrkzo3H9n9RXHY0msi7SJ6C3GgpDjhyJva3jC5
         XQGEzZQ80WhbMCsfxUsjORLRECBYFjnDZrBgc3fYNMwIndO/5nQ+PyE1oYjL5PO7uvyM
         VQbhbgsNcKloj25ykOu+TLdMiJ4KDG9uRP2KqZ7vAUPv4rORyUU2A3GfVn9gugor0QQp
         HyaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1VK02sd9TABQ4+CWbwflnFN/3ouRrlt3bYIRytPcMT1QbO1QSnnL14bFEOfzeb0rnJ9b4ETs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpRYJdxiMLcjbUD2ijTwcTFxJPdLnolkc+jQcXcmpSp/q0Jn4t
	xL+GH10NltO//RgKJEPNjLrv3QaozDOQygiFmUJ+zv1BhENovSIgQHt+GR2lrYePNnK04N6woCk
	dulJ/J5V2/Ulu5tK725dDrvsIT/XD4+CIS/LeYmaAl42QxvSN0GKlig==
X-Gm-Gg: ASbGncs8ReFQStYbMs8g6ol46d+IDstLN3+CJVkpONCx3EI1aGM1C5Z8pLA/I/3tewZ
	zqSc5RPtShn89wy1vESX8MqoYzLSClyIJYDDHZMmuaeloIXtkTQFktplWqLVqjfwwWNkeV2IgYS
	oPR5dNJaK47X43GOajD7QmduTYiq34yI6Y9MLAMlq4xZlsUYks0wGIRciJjteUuhE+vI1TWpcgF
	uCf9zm03yi8TH1D4Bw+fcpsReD7V1SDeGZPCiZ9TFYY3Y+0SXSeXMqryvomRg59HMvb8u+qHDDa
	9hEB/b5JpPJmaCGtkKoTbah+c7YrqW8IfJB0nTdLrht0Qwybm+9oSZ2yNoQL
X-Received: by 2002:a05:600c:5010:b0:441:bf4e:89c8 with SMTP id 5b1f17b1804b1-441c48b02e1mr70620085e9.3.1746453686430;
        Mon, 05 May 2025 07:01:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7iODw/o625/Nmx32pf7izs/rka/elNifkAdqbkKlAk31dsXlLHLsw9OXTkcQvtHWXeFwG8w==
X-Received: by 2002:a05:600c:5010:b0:441:bf4e:89c8 with SMTP id 5b1f17b1804b1-441c48b02e1mr70619465e9.3.1746453685956;
        Mon, 05 May 2025 07:01:25 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b89ee39esm133833415e9.21.2025.05.05.07.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 07:01:25 -0700 (PDT)
Date: Mon, 5 May 2025 16:01:24 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: Oliver Upton <oliver.upton@linux.dev>, Quentin Perret <qperret@google.com>, 
    Fuad Tabba <tabba@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
    Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>, 
    Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, 
    kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: LM regression: fce886a60207 KVM: arm64: Plumb the pKVM MMU in
 KVM
In-Reply-To: <86msbrguka.wl-maz@kernel.org>
Message-ID: <e1117e68-ef05-9de2-d018-685bb7d86bb5@redhat.com>
References: <3f5db4c7-ccce-fb95-595c-692fa7aad227@redhat.com> <86msbrguka.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LudY9QtgX6ESP1Csc6Ol96SjocPYgEPau2EGTDsbOrA_1746453687
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 5 May 2025, Marc Zyngier wrote:
> On Mon, 05 May 2025 11:52:00 +0100,
> Sebastian Ott <sebott@redhat.com> wrote:
>> Doing back and forth migrations currently fails on arm after a couple iterations.
>> During the failing migration KVM_RUN exits via guest_abort and returns -ENOMEM.
>> I can reliably reproduce this by migrating between 2 qemu instances on an ampere
>> altra machine. This fails after < 5 iterations. In this case qemu would spit out
>> smth like this (other than that - nothing in the logs):
>>
>> error: kvm run failed Cannot allocate memory
>>  PC=0000aaaae7d48590 X00=0000aaaae80a2e00 X01=0000aaaae7ea2fc0
>> X02=0000000001d3a5d0 X03=0000aaaae7eace8c X04=000000003b9aca00
>> X05=000000000000004a X06=000000000000004a X07=0000000028000000
>> X08=0000000000001d70 X09=0000000000000018 X10=000144b7d0000000
>> X11=00ffffffffffffff X12=000000008378f367 X13=0000aaab1a202d70
>> X14=0000000000000000 X15=0000000000000000 X16=0000ffffa2e2f7a8
>> X17=0000ffffa2541f20 X18=000000000000a000 X19=84bfda6288cf2dd6
>> X20=0000aaab1a1f1ce0 X21=000000007fffffff X22=0000ffffc5431788
>> X23=0000aaab1a17db60 X24=0000ffffc5431770 X25=0000000100000000
>> X26=0000004100000000 X27=0000000000000001 X28=0000aaab1a1f1c20
>> X29=0000ffffc54316d0 X30=0000aaaae7f8cd24  SP=0000ffffc5431650
>> PSTATE=20001000 --C- EL0t
>>
>> Guest and host are otherwise idle, kvm is in normal VHE mode.
>>
>> Git bisect points to (fce886a60207 "KVM: arm64: Plumb the pKVM MMU in KVM")
>> I also double checked that by reverting this commit on top of 6.14.
>
> Thanks for find the triggering commit. Can you further identify *what*
> causes the -ENOMEM? The only new -ENOMEM in that patch is the one
> added to topup_hyp_memcache(), which shouldn't be called.

The kvm_pgtable_stage2_map() call in user_mem_abort() returns -ENOMEM
because the memcache pointer was not initialized!

It looks like smth like this without other conditions could do the trick:

if (!is_protected_kvm_enabled())
 	memcache = &vcpu->arch.mmu_page_cache;
else
 	memcache = &vcpu->arch.pkvm_memcache;

(I'll try this now)

> Also, a failure to allocate would leave some nastygram in the kernel
> log, so it is unlikely to be an actual failure to allocate.
>
> Is it the first KVM_RUN that fails after migration?

Nope, it happens on the side that triggers the migration.

Sebastian

