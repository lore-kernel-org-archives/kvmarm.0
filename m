Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE5A25B668
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 18:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212017; cv=none; b=V51zAN9FAeZkJs2TvlFu9eX2EUMzIrZ/Mhli5vPXxeZsL4trKAwdxw/OBbG5gpcexPJv0ic/9Hddpxbz1fPlIQy7Xc9UGAy+h7IJPoS5lLNqll5ux7MOPdqtej8DXU7lJ/mhasI+b3i9dxb7rlAAOSX+SXjwHJt5ILIJMUPnLCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212017; c=relaxed/simple;
	bh=ZiUyHi8wpWmhV6mgwoY+8th0sFIVE7wkfNkxP+TA/oE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lbSg98Ht1Yod9/CwEy+k+FLg1bAUC9qCkmZdlqdKdr+sMptrlwR5xxRIT8IlzXqMQ/PkISw06yKGh6B3nfc5ET5uYm5wReMEXn75VpJhqLB8Dyoz5EGqBKbdfYFfspKjijIaZW4gm64SS60gKR82pRE1ediGGCcB8HxZ6pjdZ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Soi4BvTD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Soi4BvTD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739212014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HA223N7bzpD0iurwVL/uuRnSBdx4Qsn+l1XE/28dqsc=;
	b=Soi4BvTD82qUyR+7Z/FGrwHIwMXgzPvXLcKXKsQh5kJ6+9DvDHFUtNxfZOzAnVwoe6xgGy
	CTso+Nb9EMP/jTudN1G+WEOsHsfgxHm9aUJ/YJmQYY0Z6IU5/IzuqykqOh9YC3UPVHNJsj
	tyX222ugvK4epdHhG+N3AvqVoVjNLDo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-E8z-JX7mPGK9nzzFwo7N7w-1; Mon, 10 Feb 2025 13:26:53 -0500
X-MC-Unique: E8z-JX7mPGK9nzzFwo7N7w-1
X-Mimecast-MFC-AGG-ID: E8z-JX7mPGK9nzzFwo7N7w
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-438e4e9a53fso35071985e9.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 10:26:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739212012; x=1739816812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HA223N7bzpD0iurwVL/uuRnSBdx4Qsn+l1XE/28dqsc=;
        b=TLxkjWGCakRQjE+aBk5JpJRcQVZZtrSPaV7eKIip9xK5pBaYRdcio+ORijVSDi7fGD
         japVCDJtNiBuPweVhwSapn4I8NipkfISfJgmcsX182DDNrxvNDaL90RDzqGAZmljfxLV
         ed+68iKD8zFiSBey3PbVjfgMc8FNaPb/jyqFSRX2DiV2kZ661zKXbpSZDqPdik2z4kzJ
         G9UL+eIPs6FWZnJ3Yk3HuM922b5Wk20buBzRctQThkV3TxL+w2g+dgmrSyY2cr1jxDqi
         Mu5BFVNYGWAuDdCO+PMAollPsk26AA3wQzEhTnPa0jdB+SiW7jhB4tKE2UBfuy2buP28
         /THA==
X-Forwarded-Encrypted: i=1; AJvYcCV+m1rtV6wUV0ayTZJLoErqlSah6usyMeo+KH4afnS16c62VDdlP/Edeehda7p5iyy7+HKMEY4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxl5SZI12xg5UmnywqALZjm1JyIA74kH5SlWhuvPm5MO1OX1Z3a
	Q4p/dMlmNUWLJR7d7/axqKgZGMdqwgTedRMF7qWGjae8TqqL0R0fI10YdjNYX/VndjwtP2+rexn
	6u7+vcnKDBNfYvWi6gvSSw98P/Tko1ioJruprbuco4PpL2SMqxHS3/3/UFJyY6A==
X-Gm-Gg: ASbGncv8xX8QXOFxnuksXQnR57NUosST8nzw96AuhgnpguvXv/J5qPb5fhBfumv3MSr
	964zEi8hYLwktRwv2q/bUbJRX7H7huFbgxDNB+vOkL0KDfv9FadeaUvjyqn2wRHa31n3RzT6msB
	xLy+WgIGv4KHvSqjrm3cowkNH3jK02NEk72jqFJle2Mb68b7j0KZJVZA2b+ri7WPEMU81erwJBy
	UAro0QXyJHpyzjoMFNn3NfJDbsvh/xG0dF5lrhvGzkM05Qgtju3ZNZOrhaOfzYIG4ln66ww1teg
	1HASnEepTsgiWDSH5VU1k4LmPMWabzENDUblGIRnSu/CS9g=
X-Received: by 2002:a05:600c:5026:b0:434:e9ee:c2d with SMTP id 5b1f17b1804b1-439249c6eeamr102512905e9.26.1739212012022;
        Mon, 10 Feb 2025 10:26:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFdXSicXWsQFBmaEUffk1qaLUEnTABUYO99W2RiA4VYZWZefOzltKbNAoDI4virz7wvcWBw1g==
X-Received: by 2002:a05:600c:5026:b0:434:e9ee:c2d with SMTP id 5b1f17b1804b1-439249c6eeamr102512675e9.26.1739212011660;
        Mon, 10 Feb 2025 10:26:51 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dd1093bb2sm8205458f8f.40.2025.02.10.10.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 10:26:50 -0800 (PST)
Message-ID: <8da22249-eedb-477b-98d8-f50dee56f1f7@redhat.com>
Date: Mon, 10 Feb 2025 19:26:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If timer
 expired
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 kvmarm <kvmarm@lists.linux.dev>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, christoffer.dall@arm.com,
 suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com,
 coltonlewis@google.com, joey.gouly@arm.com, yuzenghui@huawei.com,
 darren@os.amperecomputing.com, vishnu@os.amperecomputing.com
References: <bcb4289b-507c-4ea1-afc7-6febd34d88db@redhat.com>
 <86y10osr19.wl-maz@kernel.org>
 <4d443db1-85b1-4071-acd5-3187deb9cb17@redhat.com>
 <2f6b2cb1-3d32-480a-9801-9b993ae74e2d@os.amperecomputing.com>
 <152d262e-641d-4bb1-9656-a13e049d62c4@redhat.com>
 <86h661wje4.wl-maz@kernel.org>
 <4a9fbdd9-ad23-44bc-8ba5-399f08068db4@redhat.com>
 <86cygpwfy0.wl-maz@kernel.org>
 <b22d5916-8b55-43bc-a256-2136d66ad25f@redhat.com>
 <86frkptzr6.wl-maz@kernel.org> <Z6ZMdv8jJUvYwQzT@linux.dev>
 <86bjvdtxb5.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <86bjvdtxb5.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LHtdQ0IKNsNI3jEnNnc0uEqljMkPfmcUFmJKUNL6TNM_1739212013
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 2/7/25 7:38 PM, Marc Zyngier wrote:
> On Fri, 07 Feb 2025 18:09:58 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
>>
>> Hey,
>>
>> On Fri, Feb 07, 2025 at 05:45:33PM +0000, Marc Zyngier wrote:
>>> I found at least one issue that could fail the migration. Before the
>>> VM starts running, we limit the feature set to the subset we actually
>>> support with NV.
>>>
>>> By doing this, we also change the value of IDreg fields that are not
>>> writable, because they describe features that we don't support.
>>> Obviously, that fails on restore.
>>>
>>> I need to have a think...
>>
>> We spoke about this a while ago (and I forgot til now), but I was
>> wondering if we could use vCPU feature flags to describe NV, including
>> the selection between FEAT_E2H0 and FEAT_VHE.
>>
>> I think this might match userspace expectations a bit more closely where
>> the state of the ID registers after init gives the actual feature set
>> supported by the VM.
> 
> I'm not sure that's enough. Let me give you an example:
> 
> My host has FEAT_XNX, described in ID_AA64MMFR1_EL1.XNX. For whatever
> reason, we don't allow this field to be written to, even out of NV
> context. This is odd, because for an EL1 VM, this field means nothing
> at all.
So the curprit fields for me look like

- ID_AA64MMFR1_EL1.XNX
- ID_AA64DFR0_EL1.DoubleLock
- ID_AA64PFR0_EL1.RAS

This is still based on your nv-next branch from Jan 9
https://github.com/eauger/linux/tree/nv_next_jan9_2025

Eric
> 
> However, we don't yet support FEAT_XNX with NV (it requires some extra
> surgery in the S2 walker, in the S2 shadowing code and in AT).
> 
> How would you manage this field if you had a vcpu flag saying E2H0 or
> not? I don't think it helps, at least not in that particular case. It
> may help for some things, but not all.
> 
> It feels that we need to define the field limit (and what is writable
> or not) based on the NV/!NV support, and maybe E2H0/VHE as well.
> 
> This is getting complicated...
> 
> 	M.
> 

