Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A21F9E6
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 08:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733126616; cv=none; b=QTLod2xKo9hAMD6pqCMwZ0Y7Uq6NadX65dQAo0dWh2YuDm6FS6mqCEdH/RJwKPTSPFthC7ZyyqEXBxmzsJwcrhJuGJUWPrNawe+AiGcmx+lMYQdbsLpC5Gp/qxsPnYaTfjGAw9y4jGVSnaBAYgh8UP3E+yyW/QapKGqSf/vLnHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733126616; c=relaxed/simple;
	bh=ATXqHFDTRwj3ZH4k079DN/kvfKCGcHHa9jl0aMvATIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ar6RFcpLsZZeIVfqXtMmdVAY3wv6Ia6HoDWnLnv4CqxCkW2uqRQPldIDg6cXjiQFedh1TXwtgPyvlfUSQEM3g2PTLCA/awyiUng/6Be/nbrgoI/9DW1dAaz1dH395uCJiuGix/Lyzd3R75hTfu6SY0/uhVVdu3s+9RUMjUCTx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jLtMkg8b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jLtMkg8b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733126613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aN+6aXxjhPFYN+ILtJ8oROYNyiXPAUR4XJGNYkKrR8w=;
	b=jLtMkg8bSapCM2+Xalq6ceecV5RFUfXxCoKIiBMnXJMNCXf6ysUogycRGqcKZrdbXvWtpm
	gTW8v8nDDUGeHFLEts7MEa93Q0A5QtM1KAHOM4GGHW7Q0It6Ja9AwTTc3XJ+PD1Rq2vMhR
	/YQYMwDBjTi20K2mU3rY5Jep9ei8Hto=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-VO63GzwVMbCRkEpmgnqOuw-1; Mon, 02 Dec 2024 03:03:30 -0500
X-MC-Unique: VO63GzwVMbCRkEpmgnqOuw-1
X-Mimecast-MFC-AGG-ID: VO63GzwVMbCRkEpmgnqOuw
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4349e08ae91so29520335e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 00:03:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733126609; x=1733731409;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aN+6aXxjhPFYN+ILtJ8oROYNyiXPAUR4XJGNYkKrR8w=;
        b=huvByJk5+njyJ6de3bI5ZQM6myH2TN3vLjjkLJ6iTqpL0gEM/qBZx9jrg/l/ZiBEwV
         YGX9GeV4vQnOuaGfpErYYXS0cCcZzKF8Wo8xMYLP1RpR09lzXN4wwGvkuvcTjWSJBUI3
         gfYhsDhWDxfI2votGrhTniLkM2iy5J108UB2ELhhYKWeP2QYUbO8C5cB2oQio/xtpfLS
         FK9+0DAxh3nzO0EUfDGYJKW5aNX/vluXmK7wXUeAwWFzTe0gFaiq3xFtsD15VDnynbU+
         zLzCCnQ+BkWlCQtH/D3Wqias5+XLQ2u/ukA9BhXYEPRDdzy5wWC9rjSW4b+u2+RSZlMB
         YClw==
X-Forwarded-Encrypted: i=1; AJvYcCUMzgbHy3GoAItYggzXsyhe1/Dp9ph0FKfUrQzOS/90LaNO8HzZR+b/5zW13BbRWY/8Gw+44FQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0WGLsqZO8I+j43TnpEEZfq2z8VNMZdmYOq9HVfPVVvhpJmoxK
	mOhHhgVZc72oTC1jiuUYpE//obfQ0o43xf0HWOMhk3HDKtbZKhY9hk2Zv66FG3AzAZo1B+e2gr2
	VLomli+jzMtaGzySTnIpKQAz3R7q8bs9QLcJIo05/FAEahkaz3PvrQw==
X-Gm-Gg: ASbGnctWLVlW3jArsuluwObnbDma/Pivzse5um0lx/7IY5S4eZy90Kaaou1Bd3Y9b5l
	7xoGRDsBqoiJwUhQzQsVpz6R9heEBRh67UfQUnjl7G/Ow8++DWTLNCU4EWobHKU4MGkAUTbCzvN
	HLR49LuF03Y60ctWrP7pvfH0vjSBDlqASWlX2xykvIrSM7VJJtwrNelEWLCbsX53RmOYRAO4D7C
	/HxlfLIGPv5ynfkVqvEacKPEW2ftbbMA8oWOETcxck6JzpX0+yEfARMOUqN71DmPYkj/YspdOZn
	iCvgnymGH4kBWKZE
X-Received: by 2002:a05:600c:588c:b0:434:a7e3:db50 with SMTP id 5b1f17b1804b1-434a9df26cbmr158068075e9.21.1733126609339;
        Mon, 02 Dec 2024 00:03:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOoKcy4ZLxYfJuHVBmETBdh3cXi5dFZ/+hCy9umKs5/0947WIDG+W1ZeqLNq9Ru+txGZNWXg==
X-Received: by 2002:a05:600c:588c:b0:434:a7e3:db50 with SMTP id 5b1f17b1804b1-434a9df26cbmr158067725e9.21.1733126608984;
        Mon, 02 Dec 2024 00:03:28 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0f32837sm145415305e9.33.2024.12.02.00.03.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2024 00:03:28 -0800 (PST)
Message-ID: <e35612b4-e25b-4846-8fd2-56c2473c140d@redhat.com>
Date: Mon, 2 Dec 2024 09:03:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1
 writable from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: Sebastian Ott <sebott@redhat.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "will@kernel.org" <will@kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 yuzenghui <yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>,
 Linuxarm <linuxarm@huawei.com>, "reijiw@google.com" <reijiw@google.com>
References: <20240813142835.77180-1-shameerali.kolothum.thodi@huawei.com>
 <86v804z3lk.wl-maz@kernel.org> <b2dad37ac5464384abe4edf76cb6b546@huawei.com>
 <4d3a7dde-e085-fa70-8859-ba153c93b615@redhat.com>
 <87zfllssji.wl-maz@kernel.org>
 <c879fda9-db5a-4743-805d-03c0acba8060@redhat.com>
 <865xo3vbjq.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <865xo3vbjq.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Za7aX67OuopvI1RKdg19QYGbMXStU-kDBl7RNhYSM2w_1733126609
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 12/1/24 13:21, Marc Zyngier wrote:
> Hey Eric,
> 
> On Thu, 28 Nov 2024 09:31:08 +0000,
> Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 11/26/24 20:29, Marc Zyngier wrote:
>>> Finally, who is going to ensure this keeps working in the foreseeable
>>> future? Because while this is nice, that's not what gets deployed in
>>> production, as it leads to unpredictable performances. My take is that
>>> this thing will eventually bitrot and die.
>> In the context of our works to define qemu vcpu models for ARM
>> (https://lore.kernel.org/all/20241025101959.601048-1-eric.auger@redhat.com/)
>> , our current approach is to try migrating between modern HW we have
>> access to. The case above is migration between AmpereOne and Grace which
>> both should be prevalent systems. Do you think this does not make sense
>> at all to try migrating between those, alhough this may be challenging?
> 
> I don't mind the challenge. But I'm worried this is something that
> looks like a reasonable idea that doesn't get any traction in
> practice.
> 
> And the example you mention is pretty striking: who in their right
> mind would migrate between these two systems? If you deploy a Grace
> system, that's because you are making use of the GPU, and your VM is
> likely to require it. Conversely, if you run on an Ampere system, you
> don't want to use a valuable (read: bloody expensive) slot on a Grace
> machine.

Yes I acknowledge it is a total valid point from a use case and cost
point of view. I was expecting maybe some interest migrating between
AmpereOne and Grace-Grace for farm enhancement but most probably it is
marginal.

Definition of [qemu] named vcpu models looks pretty uneasy then because
we don't have much relevant and accessible HW to test with, taking into
account such non technical considerations. Besides migration within a
CPU family I don't see much.
> 
>> Other cases we have looked at are migration within Ampere Altra Max
>> system family (which should be hopefully fine now with have CTR_EL0
>> works from Sebastian upstream), mig between Graviton hosts. Wrt Ampere
>> Altra Max to AmpereOne, Oliver pointed out the cntfrq issue which is
>> blocking.
>>
>> Do you think we should restrict our studies to systems which are
>> "closer" to each other in terms of ARM spec rev. We throught that
>> migration bewteen AmpereOne And Grace would be an interesting POC and
>> not totally irrelevant in terms of industry.
> 
> These two implementations may be close in terms of CPU features. But
> as systems, they are massively different, and I very much doubt they
> have the same deployment story. If they have one at all.
OK thank you for sharing your point of view.
> 
> The Graviton story may have more traction, but these folks have their
> own way of doing things, and in my experience do not give upstream
> much consideration.
OK thanks
> 
> To sum it up, I'm not opposed to this work. But if we are going to
> carry this sort of complex emulation, I want someone to step up and
> promise that they will test it for the next 10 years, at the very
> least. Because I'm very unlikely to ever have access to any of these
> machines, let alone both, and I don't see people using it in practice.
understood!

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

