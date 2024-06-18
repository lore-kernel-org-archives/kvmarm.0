Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3B91F176
	for <kvmarm@lists.linux.dev>; Tue, 18 Jun 2024 05:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718690140; cv=none; b=evuzkRayzDY+req65HVui+SLRTaWQ6qKHZHnxNkUrPsllVf1vi9ox942ZmDFa7CfkKRGpMgMwnYaZvg5bp7weR1WqPjcWOrH9W8rzj1Pji44gVNvwIg62ZBmUrWNVHl4717vHnnFkUnFvJmXNf1ciI3EcK8mmjVPU7VQJKK0SDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718690140; c=relaxed/simple;
	bh=7RiwnKT2I1MFdE03Yi9OQNr5nfwBkB7Vzra8koLRLqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ktBO/X2vweUW/Kz31J0f4H13Wm3bclf/4lvpHBrbNLnSoxcMTit2VCNuZFY8KpgSOuBZjfY+k5/tLlulezG4GeXeRwYmPz1HK19iFjBJLWQDOrib2yJ/vtK+nTNXqEQpkgTm9B6/W4KhV+GXEpphMAuw8XOQ3axu9k9AMPlU+xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DrzxiCPL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DrzxiCPL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718690138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hWu/voSZi4FQiwHW6WOBcFhupKmk2O/NDijOpbvubbo=;
	b=DrzxiCPLWRmGgQSAFDiNNQKaozwSgiAmJvuZvvT2fhHviuWwfDbfvjj3biWJWawJWEQQsg
	dKyZv4qXTWKEG+PetZ5S65+JLhGBFaFk0VR05TIxCaCF/qSYbpzdAq5H0sh1Ala7ikEZJ4
	XERuvl78HfPRf8dC35q++MAsASu6nCw=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-HmSUD_jmM4q7111P6PYamA-1; Tue, 18 Jun 2024 01:55:28 -0400
X-MC-Unique: HmSUD_jmM4q7111P6PYamA-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-2502a80477bso92099fac.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 22:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718690128; x=1719294928;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWu/voSZi4FQiwHW6WOBcFhupKmk2O/NDijOpbvubbo=;
        b=CdI1ruDEkrqV8SBJd7s2wjmmxA9LIqcDBnntx0tufEvu/h4ai0GjCFakd3+FVYsGDY
         aTqODMYl5urfq6N94iThjYtU4BePlA9vsyK3JLLUhlyUbwj1HYl1VvlnVxR8L41qKkfy
         3DOatXpNr3yXq6V4jSsE3cyPkqdE1v5h8C5Q7sgHMeVruo+VhXBIQt84jX4GeFAxSsri
         JHl+VJHHB1xWB2RduNheIUU9/HdW1GxTItONuXj1ka7G7LWmrG+tzo59gXacwUBAb5ca
         4yiU8aHE8tZ+hQFpBMOROvwKZZiNg+mJADpB+OjQZ5MrPjvjez9F1CjW/LTLU0AgJ89g
         EwsA==
X-Forwarded-Encrypted: i=1; AJvYcCWHAbXjBGSjKdR1ih+INGLfmGAsScEHJuThvyq8FrMcj++sc2xFn+Twa9ffzYuNlzoj4Gm4KT9pJCI8knTdItiZ+ZM7GtvA
X-Gm-Message-State: AOJu0YzMCJoaJZt72UU3c0rc8iudrgru5iXEqtl8oVxW6JjcBfTPXdSR
	3FJQywcPuc2vwkxqNYRcTvhtXE6Iehm+86N6zWOlj8FY64WP2EDIYg3oBqTypz/TKdcCfEmNtnL
	Q+KI5eofGqY8FRSYq9yDQkj8Hk3tvIiKLR707jtVkI96PvFXckSawWw==
X-Received: by 2002:a05:6358:8a6:b0:19f:4cd0:aad1 with SMTP id e5c5f4694b2df-19fb4eb049cmr1247884855d.2.1718690128087;
        Mon, 17 Jun 2024 22:55:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmf7CqoB5qG+f+SoSDNog9sHPlb0eZ/k8nda7B9rivFb2/iFdvUu6nxAvxJ5wxsEEdjtvYqg==
X-Received: by 2002:a05:6358:8a6:b0:19f:4cd0:aad1 with SMTP id e5c5f4694b2df-19fb4eb049cmr1247882755d.2.1718690127611;
        Mon, 17 Jun 2024 22:55:27 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fedf592f0csm7512541a12.54.2024.06.17.22.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 22:55:27 -0700 (PDT)
Message-ID: <8fd7e58d-1d87-430d-a974-47ee05bc72de@redhat.com>
Date: Tue, 18 Jun 2024 13:55:22 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] KVM: arm64: Making BT Field in ID_AA64PFR1_EL1
 writable
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, James Morse
 <james.morse@arm.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
References: <20240617075131.1006173-1-shahuang@redhat.com>
 <ZnB1FPw3Eg8-61mL@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <ZnB1FPw3Eg8-61mL@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 6/18/24 01:40, Oliver Upton wrote:
> On Mon, Jun 17, 2024 at 03:51:29AM -0400, Shaoqin Huang wrote:
>> In this patch series, we try to make more register fields writable like
>> ID_AA64PFR1_EL1.BT since this can benifit the migration between some of the
>> machines which have different BT values.
>>
>> Changelog:
>> ----------
>> RFCv1 -> v1:
>>    * Fix the compilation error.
>>    * Delete the machine specific information and make the description more
>>      generable.
> 
> Can you please address Marc's feedback?
> 
> If we only make things writable a field at a time it's going to take
> forever to catch up w/ the architecture.
> 
> https://lore.kernel.org/kvmarm/86zfrpjkt6.wl-maz@kernel.org/

Ok. I will update the patch series again with tackling the full register.

Thanks,
Shaoqin

> 

-- 
Shaoqin

