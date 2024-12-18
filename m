Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11411E9B1C
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734535842; cv=none; b=ix8AI4GLw+oa/enfiPcPjEzb4tTFXgnfdbasVEQPa6LnC3/N3aqNmoN9cj6riVHzvrq7zeE+teXWOBp80FlyCPLhdqWbVO37dELT9StYeY5950LX1wpzeRbhPwVUsyvjrvWEeAYbI/8gy7t2EWnjw19JKfu8ojpTor14UGYW6gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734535842; c=relaxed/simple;
	bh=J3xoFWjW1+N7ItEmMKjrgWixC2VGiRoOpV6ULJJZOCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sVZwgnUG1YxSNbOi4yOYJBhsKGyAsi/qz6ZkQHPKttPWNgSxJr9drNvXqQ2CUFXA4NyO+0sWlo0Sk6lukCWbsK2KsR/sUV2blBAo/cLiGoo90gY66MgJplcoujjz0J6IPbhp3NcHvmjTlnjyUgdyU7b3llz0wvRZ/8APme9ojKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKkBeqBL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKkBeqBL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734535839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IOTwT8HE0XwDG2FAJOX9RxAWuGIePlcHl5MDSdJ05RA=;
	b=VKkBeqBLvSjjkhwsOFZyrhh4XZGnSRkycuoHwcERetd/Qudkv/xU/xiDUTxSre2UqNCB4Y
	3EV+ty+OQjmOcgjFQBHcEGduBMBhIV3pjf0iy07/SY7Pu3Ei1ig/plwOFNdFoFMoUwSwQP
	rddkMwbkxfdqY+wayc8uSOj3+lRkuTo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-axwQ63lfMVqCqY5hTjL79w-1; Wed, 18 Dec 2024 10:30:36 -0500
X-MC-Unique: axwQ63lfMVqCqY5hTjL79w-1
X-Mimecast-MFC-AGG-ID: axwQ63lfMVqCqY5hTjL79w
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4362b9c15d8so30766325e9.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:30:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734535835; x=1735140635;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IOTwT8HE0XwDG2FAJOX9RxAWuGIePlcHl5MDSdJ05RA=;
        b=SLq7p2XNW/EqBFlDjt0oG4ivz8Zr1/Cf2S8Yi7FNr+M5VYkXzzkDtUogVXMRVMjgjg
         kZcWJzAb58VIKnJS5WJE4CzXPV6wYKz1pfZzSZyFUvs0/Q+c7fK9+lfG1P3T6V5MyoCo
         NdmcbzZgyZOwwzEOowzJO4fHTqBzY+geOhim40qivAxANQNkzIQGpp0ktnseghHpmTt6
         a30XPQ0DYrh8768rQ84fdrNfOOtmyYKEyM8FNaOeoaNT5onw+UZ/XW5iiplEXUuJ8+fS
         SEPhu5j1GLVMTA7ymVqI8peVyGu5x10N28fIEF7kx4E1CmifQWkGz9bU6bzezQxL1TGt
         DuEw==
X-Forwarded-Encrypted: i=1; AJvYcCXJ0tBFv98e1Ya7w4QuYrNW7t1ilDox1+CGXixsRSubOSPCkimT5lTxBesqn2vPGoeBH7ufTn8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMvZbxQzZz+3uZSJjzJhKrDdbfOLg4E9HNSoR0ACI5TlV5MfTW
	dWEjarJfZsJ7rHEnJf7N0Xh7djLX05gjy3bmVyQJx+JrqPU+8/Kj5taInlhzpEr2CGCoy9lVEU9
	BKMJONp9MRbeZa4oLm5uSFO3xc40wqzCZLzglgNlV22pwDFfQclWvTw==
X-Gm-Gg: ASbGncs8rw4ZEtNoUWi5kApoKku7cHVqACOcV0JeqS1FFAWEFG3DGwNcHKK3RK90nVO
	/k2I75qNidyQgCYwI9f4hTvOAvPYSLA39YXOlgESEcPpk3Ho1p2Qd1B0gyMbezriguAyVWBt+Gb
	vO425FiWt6vdA3PL4LQRCaOjoKpRud8zjD3wnbQbiXbvrZu9QNPShc4j7tXbpn/41nDQOlsmOrp
	S4WlMZcbPWV/3IW0fqr5yttNA4a12waeMdIcM8PSTxI5vNoAPCEDaQ4ignifEP3x0UMHsrLFI9R
	e7Q/P4OVdgv7MU1yKq8GKGA=
X-Received: by 2002:a05:600c:468a:b0:434:9499:9e87 with SMTP id 5b1f17b1804b1-436553fe17dmr24703965e9.25.1734535834981;
        Wed, 18 Dec 2024 07:30:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXy7/92tN4aqDKjWg7kMg8QCEdGz/+/l71Ezw0sjA8QjrEyldBB1pQsA/f3MKEus/gdEi2RA==
X-Received: by 2002:a05:600c:468a:b0:434:9499:9e87 with SMTP id 5b1f17b1804b1-436553fe17dmr24703635e9.25.1734535834464;
        Wed, 18 Dec 2024 07:30:34 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656af6c5bsm23443205e9.2.2024.12.18.07.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:30:33 -0800 (PST)
Message-ID: <ac2744ad-728b-487f-af9f-1eee1ae0bab5@redhat.com>
Date: Wed, 18 Dec 2024 16:30:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 12/46] arm64/sysreg: Add register fields for
 TRBMPAM_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-13-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-13-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LJGSop1gKEA4p5ylPVtb6X6S8lCDeZc70rFTpw_v1pA_1734535835
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for TRBMPAM_EL1 as per the definitions based
> on DDI0601 2024-09.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/tools/sysreg | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a5e31e4c4474..78564b24b187 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3413,6 +3413,19 @@ EndEnum
>  Field	7:0	Attr
>  EndSysreg
>  
> +Sysreg	TRBMPAM_EL1	3	0	9	11	5
> +Res0	63:27
> +Field 	26	EN
> +UnsignedEnum	25:24	MPAM_SP
> +	0b00	SECURE_PARTID
> +	0b01	NON_SECURE_PARTID
> +	0b10	ROOT_PARTID
> +	0b11	REALM_PARTID
> +EndEnum
> +Field	23:16	PMG
> +Field	15:0	PARTID
> +EndSysreg
> +
>  Sysreg	TRBTRG_EL1	3	0	9	11	6
>  Res0	63:32
>  Field	31:0	TRG

