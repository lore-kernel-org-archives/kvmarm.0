Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1A7187561
	for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 10:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721039295; cv=none; b=FZ9Ltq2eyXDpe7KGscldZK0XFj1EmBXmQNvrTXFwXTryYDoEpuoYrradGJpIunNjq4cP5OlQ41+vLwN43TXOwV1ZvjRFkRe/aVnDwhBSXTrmFh0yiy6D49cBIQkVY2nknu7zShTL6OGpR6nWcz266phLLvgrx0yEzCVsccPo0yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721039295; c=relaxed/simple;
	bh=+xTWXNB9goKErdd7zsLIfBIKWebwItFQTsWRxe+U2d8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pepvLC8XpB3RPM3LUyXGqVX6oWXVnjqWYkt2nx3sizjf3rjCkbfGdDAiYMqO64++hTIVzcCAjV5dT1EvJM8Utf6cYOhttRuw30Y9Sdoj8bzYxo+KU5t1YfzBVdssV/biRfCWyZVUe9SGnVmRLn3JkGKlL7YFTUbNXCJ7S8v7Iv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=USJBvWUb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USJBvWUb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721039293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GH/UMjm9Bv3Ls7RPi1qyRi7O73kNYwzhssTIeV97gbM=;
	b=USJBvWUbmPBmlD0x9PVdZWEUQ/F2fW1Jn+HNr42iCB5AZdQLMGyT8SWtwK01HoEHtYK1nQ
	RwwugpyXDnmQIB5xM79f1vbJsXSUWPwSOS39DR3zjTKcE0G7G6MV9NN0LUDDsDSgj2Bzvj
	+Cvssj+5f717BkFaxrw4VV80xo43qJw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-hzc83PAzObmQUaAUSsdcKA-1; Mon, 15 Jul 2024 06:28:11 -0400
X-MC-Unique: hzc83PAzObmQUaAUSsdcKA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6b5e96477ebso58292476d6.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 03:28:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721039290; x=1721644090;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GH/UMjm9Bv3Ls7RPi1qyRi7O73kNYwzhssTIeV97gbM=;
        b=fuP56MuEldhgtoqv+Ai4R4aIrCgH5Hh0MBZPr6apeG/vFqEnS2SvVqTJCV/4XIXfPB
         hwtRWXGg7wyfCEd+dnir3oiEvEBBpVtqIYgsACL65d7Pc6+pXIKzuVgOV/CbJf2A+X0g
         JW+4lyDmlOu/DjzJWWTaPGKukHjnwoxx5uYilpYPFLIo3w/qwRVX6FXgMe/oTaTcmgB4
         oOsI702K40J9F98tNEGXCNpfM4fNiKVUAh0DzzLiWFw6KLhqg4sSMdpUY88XMpQDUS9U
         g9d3dvjPN6BsEFJaPrA26UGBUbNWE3/xvMPOn2+iXozP1TYEFnlqy+oMfC33OVTf3OES
         cP0w==
X-Forwarded-Encrypted: i=1; AJvYcCXjGV0eQKi8QrcLeoo9j0Hqk2tkO2xVnNYvdaacikzqDl7VV4qwqQxObDFhgrvFMe4YNj6anDavXj67WMoRdn/EgDTfwNzn
X-Gm-Message-State: AOJu0YyqVLSeCNa5bsliZZFjWuVhTphiFGrcKYLjVZwr8MyMF4OrGt9y
	DjCHPpRVzG2jQcxAIe2YskTuIftRlt02vPsTEfguiteFzi5YjNApxA+IuqrweYuizJz/DVLHgw+
	cNtjE3SmIG0hil6KY2+fLRyu7z7QJGWGVOUEdxyzt3mdPLIr2Sn12I2Dh4rcsYg==
X-Received: by 2002:ad4:5aa5:0:b0:6b0:86ab:fe89 with SMTP id 6a1803df08f44-6b61bf24454mr253416196d6.33.1721039290700;
        Mon, 15 Jul 2024 03:28:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtZ5aPh6SJPX0vALIcQbxvBsBt7/FyT5/BtnGUEqoH9PUJwi4W3cEfWV3d6Sx5qRQ1lvAo8A==
X-Received: by 2002:ad4:5aa5:0:b0:6b0:86ab:fe89 with SMTP id 6a1803df08f44-6b61bf24454mr253416076d6.33.1721039290402;
        Mon, 15 Jul 2024 03:28:10 -0700 (PDT)
Received: from rh (p200300c93f45e50062e5f8c654844c9a.dip0.t-ipconnect.de. [2003:c9:3f45:e500:62e5:f8c6:5484:4c9a])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b761a10d8fsm20015876d6.99.2024.07.15.03.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 03:28:10 -0700 (PDT)
Date: Mon, 15 Jul 2024 12:28:06 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/3] KVM: arm64: fix override-init warnings in W=1
 builds
In-Reply-To: <8734oep96j.wl-maz@kernel.org>
Message-ID: <3b882ac0-fd2c-35df-38d7-b89cf073bcc3@redhat.com>
References: <20240712110332.10970-1-sebott@redhat.com> <20240712110332.10970-2-sebott@redhat.com> <8734oep96j.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 12 Jul 2024, Marc Zyngier wrote:
> On Fri, 12 Jul 2024 12:03:30 +0100,
> Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Remove double initializations in cases where that's easily possible
>> - like extra NULL initialization in static global structures. In the
>> other cases just silence -Woverride-init.
>>
>> To fix warnings like the following:
>> arch/arm64/kvm/hyp/vhe/switch.c:271:43: warning: initialized field overwritten [-Woverride-init]
>>   271 |         [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15_32,
>>       |                                           ^~~~~~~~~~~~~~~~~~~~~~
>>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> ---
>>  arch/arm64/kvm/handle_exit.c     | 5 +++++
>>  arch/arm64/kvm/hyp/nvhe/switch.c | 6 ++----
>>  arch/arm64/kvm/hyp/vhe/switch.c  | 3 +--
>>  arch/arm64/kvm/sys_regs.c        | 5 +++++
>>  4 files changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index d7c2990e7c9e..2c049746657c 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -291,6 +291,9 @@ static int handle_svc(struct kvm_vcpu *vcpu)
>>  	return 1;
>>  }
>>
>> +__diag_push();
>> +__diag_ignore_all("-Woverride-init", "Allow field overrides in exit_handlers");
>
> The wording you are looking for is "Silence stupid warning". I really
> mean it. There is really nothing wrong with this code, and if the
> compiler doesn't understand the purpose of a default initialiser, then
> *maybe* it should be fixed rather than polluting the kernel with this
> stuff.
>
[...]
>> -static const exit_handler_fn hyp_exit_handlers[] = {
>> -	[0 ... ESR_ELx_EC_MAX]		= NULL,
>> +static const exit_handler_fn hyp_exit_handlers[ESR_ELx_EC_MAX + 1] = {
>
> Is this really any better? I don't think so. It makes the intent
> disappear instead of making it explicit. Intent matters *a lot*.

I'm not claiming that it's an improvement to the code. But yea, I see your
point. How about disabling that flag in the makefile?

Thanks,
Sebastian

