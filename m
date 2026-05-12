Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015693A59B7
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 14:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778595068; cv=none; b=Be2TfPRjCxn44Z+CnNtoO4/hXw/6F2yMxweTFVc1Lo7INO9gQSJLA3L+Tk3pCyYXhwaYqo2GZ16BoQwZqNMRs1Ylboi4yiIPh8EarEP6QmV6rrZxK7LhtMbB6Y0n9/q5BiBgwh9LCL4mHA8D5Jixk/ohYKPkFmUWY8mKF17q/Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778595068; c=relaxed/simple;
	bh=ahHkeHnr+EgK+NoawFqvqDeCQyGptnpBFYdSKYbnhFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YbIkqyPkU9qWaUPdLFhKi0swhDJN1fq4r98YEyFJ+q37hPmtbxiBvWRI7n+FYow1Nd0d9cTdVGZq5d0sRU7MRWSc2FJVfb4KdBLGLhTdeyT6RYxkmaADa8/JKTaVN08wbm7lf+Rs3UfaSXQnbXzc3U+7O+hQgRQguQMz0ohpOtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FNwbG783; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNwbG783"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778595066;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uUE9BrfvgANCe3PYuItXPVWdLqAc8hiA/X97MqevMTg=;
	b=FNwbG783JeqzXkFusH34m6206S/d1eJtm1Gh8CPZm886UP7IJXDo+wqlDZ9r6BJqtbZPEY
	/o4xAzXzX8GDCYq0BgWsoFk7hatSB45DTCnCSQd+Wu/51MSFq9FvUk0UyQB41cUVMBo7+J
	e8/OXWbSrqzDCzJcBCrOTKBX9n7XBUo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-aGCFb7sfPoCjkEe2eyLmuw-1; Tue, 12 May 2026 10:11:04 -0400
X-MC-Unique: aGCFb7sfPoCjkEe2eyLmuw-1
X-Mimecast-MFC-AGG-ID: aGCFb7sfPoCjkEe2eyLmuw_1778595063
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48e51dc35a3so43931115e9.1
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 07:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778595063; x=1779199863;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uUE9BrfvgANCe3PYuItXPVWdLqAc8hiA/X97MqevMTg=;
        b=jaEEbeoiuc/V96k0W9RoK6qkFrQwQX/EuTVbMgq42bvTVHhVp5QjiKHe1TstlTFWHe
         HPOSNO62Dk0r54Z4pfEQoC2z6kIIWx6e+99YJbm+rYhMHqNRtVbKSYdmYRiN5APxul4W
         vGkPksC348kOGjEsIE+tTv8poMhr2RKRPy7drYribPxtU93rHg+xXFtYkCyuztFXokVD
         gFbvD6V9BtTpzP7TBW0u3Iz0YzHuPc7603lnY9ZUYmCiOcO2CZbHsbS4dsJAImIuhxTD
         4SNd4r/awihKL3/kVrKXQRJEWIH95qCJHarrs916+eRCJzxcgt1kayjsLK3srr0XS1Zr
         +7yw==
X-Forwarded-Encrypted: i=1; AFNElJ/Zh//424gX1SUs8LH0WJ7yAjambSl9+gr4GNwm5Cvp4zoeVkEvO52NHSdJhWR9hefoNw8j8u0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWg1BHgkP3LuwY0PStMtmfVUsZRIjOiMD00+C77ahoJatCiJSH
	xP02s0/UwnLRh38YF+jOZTgnvfe+l6mOBvwfQ+kgCaq+3aM6uCqOW7/E1vi/skpE+OV1Qo7nL37
	6pEijHWeQ6oWEgOg3ElqtN4XuSEVGv41e662kIxDDbbEb1BMvx+smsGvGMA==
X-Gm-Gg: Acq92OHop8ioVKSJ1Db+dJT57+nd/lc+vy84ov2QBSPTewqxK/nYTB52DUHaWDa10DC
	NEv5l6edxO5ke1apmXAIENs5IaSQ1e4UVBlHhfWaCoi5QomYpJrLMZ1mkntonqVY8V8dH62eBWN
	rnPZlgywmupJxy3LTaBvIBVL+Fha/eCNh8N9rYxCjq/mQWQzldcT1ydzrSP7tpWQ/WoCry0koXV
	cvMRoTxISKG88h1hHcIEUg3lTEEbXarpxKzC5NjxfKleTxqc4OKPd84DRKavSUz9YRVxkroRcxH
	RH9HrgM27bAsPzB8eispzoQ1EChfYUnx69Vku8fkokhTK2YbSkZk7p3fa+s9O65GGLciD5mYOl1
	MYzSRtz5O1SuOlj+f2RJUSx8vklRL09wMXbKNX0I6WtThnDUOSAF7mvApDSCxV599ZBkvmw==
X-Received: by 2002:a05:600c:5250:b0:48f:99a9:bbed with SMTP id 5b1f17b1804b1-48f99a9be7cmr9306165e9.22.1778595063441;
        Tue, 12 May 2026 07:11:03 -0700 (PDT)
X-Received: by 2002:a05:600c:5250:b0:48f:99a9:bbed with SMTP id 5b1f17b1804b1-48f99a9be7cmr9305505e9.22.1778595062933;
        Tue, 12 May 2026 07:11:02 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f3e7829sm29426115e9.4.2026.05.12.07.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 07:11:02 -0700 (PDT)
Message-ID: <5101bb04-8acf-4d3b-8db6-701d7c41d5c2@redhat.com>
Date: Tue, 12 May 2026 16:11:00 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 03/17] target/arm/cpu-sysregs.h.inc: Update with
 automatic generation
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-4-eric.auger@redhat.com>
 <CH3PR12MB7548C2AB4989FEF96C247D47AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
 <c7bfd8f7-3e3f-49fe-a8f4-ac0212a1762b@redhat.com>
 <CH3PR12MB7548FB661824C44F18C72A01AB392@CH3PR12MB7548.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CH3PR12MB7548FB661824C44F18C72A01AB392@CH3PR12MB7548.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kmAgAIMv6SXEMTZCbbI_Yx4z1pLltipy5ozvgyOPuG0_1778595063
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shameer,

On 5/12/26 11:41 AM, Shameer Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 12 May 2026 07:39
>> To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>;
>> eric.auger.pro@gmail.com; qemu-devel@nongnu.org; qemu-
>> arm@nongnu.org; kvmarm@lists.linux.dev; peter.maydell@linaro.org;
>> richard.henderson@linaro.org; cohuck@redhat.com; sebott@redhat.com;
>> philmd@linaro.org
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: Re: [PATCH v4 03/17] target/arm/cpu-sysregs.h.inc: Update with
>> automatic generation
>>
> [...]
>
>>>> +DEF(MPIDR_EL1, 3, 0, 0, 0, 5)
>>> Do we need MPIDR_EL1 as well? Is this considered as a feature ID
>>> register and is writable? I don't think so.
>> MPIDR_EL1 is part of the ID regs range defined in the kernel doc
>>
>> op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]
>>
>> That's why the python script extracts it. Effectively it is not writable yet.
>>
>> I can exclude it from the automatic generation but do we really need to? Any
>> specific reason?
> No specific reason. The only thing is it's not really a feature ID register but
> a topology register and is not writable now.  I leave that to you.

noted. I leave it as is for now and we will decide upon further reviews.

Thanks

Eric
>
> Thanks,
> Shameer
>

