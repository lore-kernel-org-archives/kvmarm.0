Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0543D0C1D
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 16:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778863291; cv=none; b=rcUXzgg+SZBlVb0idGYrziZau80HSSVvx2cGYKSIxcsylFeNSMglSGwHkfy3e3pSLRcfe7BahBzWi5RsnC7qMQ3HW/FCgWGCvBojMWlfO8xEqkfmoL2J4nrsxV3T1MXP23Vkf8bmojrjJGnLaiFmgDaJiGmwlPRUdoamitYsmWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778863291; c=relaxed/simple;
	bh=krJbL0Sdi/hkL6W5Ea1NnbxGpV0CvhepfqMLFkhgVrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oy0lVEZw0pQB4FxsvDGluWxHJddHlJai5od0/RmSUTtJn3fth/6jS4U05K47QTlj3CwQ7ktUsuxNmzC1T3qwubCvRCjafyp9KCrIalvW8YWFPBu4786bVJvpG6gA8FRLoXFJxv7KPW6b/uLl6UoeE8ItDo+WFsABgiuH651dhHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VEqgwTLn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VEqgwTLn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778863287;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjBZPMHg7/xD5odH5O5oe5BuoaLaAXni0yjS+VAtUvM=;
	b=VEqgwTLnpfO2m6dVD5OsJdKVB+u/y4iEob85U39H98N45dW/HNmbHneM+oKJVfO0lLURhT
	oqoiW0Ay9ead3MtC5su/lFKomdqpYeqxRzlQPq28Z8K8haN5UHGG2ViVITIPOCPJXYXGxG
	e/0k8ZcEpoeDnK5SXXvWgKtBtuEYPrU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-Zjwt5VKIN7eJ-Dh8sa_Naw-1; Fri, 15 May 2026 12:41:26 -0400
X-MC-Unique: Zjwt5VKIN7eJ-Dh8sa_Naw-1
X-Mimecast-MFC-AGG-ID: Zjwt5VKIN7eJ-Dh8sa_Naw_1778863285
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d7730e9e3so5905420f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 09:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778863285; x=1779468085;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bjBZPMHg7/xD5odH5O5oe5BuoaLaAXni0yjS+VAtUvM=;
        b=VCQZLvumJrbJ/WXzKWOYPfnjTkmPVhZZ4mq9B4zPlWSy6v4iJrmmXGLQA7pUYlWZSd
         lJb/S/IZ6QR0vLmQO5qXxx5EKm6v0f1c1GjJAj8bACZ2p9srcsUuen4oJfVZgRdimAhU
         rfh5SWLwrTqWILroth9fVhZF/jHe/vsyaXcUTEZBTarHQzOpZfuUn03cS0ozMOUoMLJd
         uTN9+tzHXrgyydh179FV3EMeKPrSJuewVOwC4berk0564Hyd5L72HoKk+xnt+0vHBL6I
         bPHzp8TDeZEbNQDrWFglh+R17z2fgLT3erYLpUHHnlk72knoozbvUatvGmGBkYEYftq4
         JfGw==
X-Forwarded-Encrypted: i=1; AFNElJ/yTHsvww/IKs0927qld13zXnreHygMFE2wFyWROM6fOSS+h1E1wDP2KQds+Iow31zQCk1mPxI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0mNFfO3orSKyi10LINSTM/r3rQDpxJ5zVUrb+jTuD1CQ8vdSu
	xjzo2vFFz+oFH7wZHa7v3m0g3PKmMJyNANY7QuHpdtiXwG07UzkDc7ftM8T2hcvjYlvbGy6TLvA
	HqzHI5i+/+cQD59/Er7HFq924bBq0AW9LZhZ6h7i0nl8Jr6iAnePN59nqGg==
X-Gm-Gg: Acq92OGMFu+NLePKo6CHYGYNE5EcGe95dAVyh0+gOTYFr0d4ZRla/mGm5sRYFOzOgIQ
	fEj7DN6auSYbyLKG7vWuS7LzOJBw6HrX6ujR8s+2pbemxfRWGm4U+WQLKtrlmR+XJRg2p3LZL8M
	Lutt3EFpwETpMCtjV6aIf32OgRjGcawiDzBeebzpGBzJZLE7Oj79Lo7mbxrdZl8SuC5AjXTToVm
	jAI/hqBUveVsTG2730dq0PExqfB9hDj5TKLGHXET9hSwcDGRBYGIoy01BzAxnHq4XFHRkyI0a7S
	TM7+mrm1uWw0+y6cnlml0q0eMIRG6edw6vDTq4Pa9NCG83lLc62XTyOTcYKpEDc8zsg7JkQI9ml
	r53bYZ6vjDz7/YKuo0ZfvKVp4XF6TeH8OB6clfjdqdo5CIEDtXjyMlHHlEFybKnHvIFDmhg==
X-Received: by 2002:a5d:5f42:0:b0:44a:fa76:5193 with SMTP id ffacd0b85a97d-45e5c5af4f8mr7076727f8f.12.1778863284352;
        Fri, 15 May 2026 09:41:24 -0700 (PDT)
X-Received: by 2002:a5d:5f42:0:b0:44a:fa76:5193 with SMTP id ffacd0b85a97d-45e5c5af4f8mr7076636f8f.12.1778863283546;
        Fri, 15 May 2026 09:41:23 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a19c2dsm15815025f8f.21.2026.05.15.09.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 09:41:22 -0700 (PDT)
Message-ID: <ee91fb33-1a9f-46f7-985d-b84ba15ad0cc@redhat.com>
Date: Fri, 15 May 2026 18:41:20 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 00/17] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Marc Zyngier <maz@kernel.org>, Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, richard.henderson@linaro.org, cohuck@redhat.com,
 sebott@redhat.com, skolothumtho@nvidia.com, philmd@linaro.org,
 oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <CAFEAcA-TE-8cj6fGOYJaChRVB5GE7E8ys87cxPP4Yw1kgjh9Dg@mail.gmail.com>
 <87pl2x9h7g.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <87pl2x9h7g.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tkF4QiqqGI-RqMJAG6SR9NeP3dVYFZjJxnX1o9jm8Io_1778863285
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Peter, Marc,

On 5/15/26 11:04 AM, Marc Zyngier wrote:
> On Fri, 15 May 2026 09:31:19 +0100,
> Peter Maydell <peter.maydell@linaro.org> wrote:
>> So if the user asks to set ID registers to an architecturally
>> invalid combination (e.g. one that reports FEAT_X but not
>> FEAT_Y even though FEAT_X is supposed to imply FEAT_Y, or
>> one where one ID register says we have FEAT_X but a different
>> ID register says we don't have FEAT_X), what happens ?
>> Do we catch and reject that? Does the kernel reject that?
>> Or do we just report to the guest what the user asked for,
>> and if they asked for something broken they can keep both
>> pieces ?
> I fully expect the latter. Neither the kernel nor QEMU can enforce
> this short of encoding all the various dependencies, which have the
> horrible habit of changing over time. The only thing we can
> realistically reason about is a single idreg at a time.

Effectively at the moment the series does not implement any consistency
check at qemu level (neither on the individual value nor any cross check
with other ID reg field values). For individual setting we fully rely on
KVM check.  

Thanks

Eric
>
> Thanks,
>
> 	M.
>

