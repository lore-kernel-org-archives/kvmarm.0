Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B341D63F0
	for <kvmarm@lists.linux.dev>; Sun,  2 Mar 2025 23:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740959052; cv=none; b=ClRfP7p0WyTAj3lQSBncx58u/rqX/Qn/7eo8kGI3JTA5n1zIoqoI//5ExglO4c+2E7oGaxXQrCLvVisrjXg6+3lzYt0NVSKo/sHmElae0VItXjq0YbksII8FE4fNFI3XWSez5JhA6A7nd4NIbycDnygCt4encBkW4jQHv3g5jM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740959052; c=relaxed/simple;
	bh=sTCLWPm34augivVf+k+p8TpTc7zDld5RdFOwiFSrPQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h9YTLfAlwcn+LiExx8Yc5la6ZSffYqhOkQkJiiymV55Dny9FkOtC6PVKLLd7Ybs8dwYQxrPQnAdEBZNz/csBIu76YwEJ8PMpcP4TT+WVoJwdiYvYfG9zny2EqgcZk8Vy6vqVlNDYd18s9B33lwWtOj8mAwGOnnM7d/Vw8CWM6Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Df6jXvrj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Df6jXvrj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740959048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=apls3JT829ifJDsJne75u3rNFMkdEv5XlW99N9rTPso=;
	b=Df6jXvrjNDQhgqOT9ofv/P/pA9aHYE+poC2u4WOBDkFTXGelav5mzV6/GJOVHk+3n9HAwE
	aAaDy9nnWWgCbgYku62i1aesZeNifyAkbP2R0K3HYNRSk8JN1a6TD7hOok+JrtLKTd1Xs8
	eBtuC+9ggwfLj5Lid9ftX71CUCEo3Hs=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-7qyd0PCuOKO7uwBWzYQCLg-1; Sun, 02 Mar 2025 18:44:02 -0500
X-MC-Unique: 7qyd0PCuOKO7uwBWzYQCLg-1
X-Mimecast-MFC-AGG-ID: 7qyd0PCuOKO7uwBWzYQCLg_1740959042
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-223551ee0a3so89572395ad.1
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 15:44:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740959041; x=1741563841;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=apls3JT829ifJDsJne75u3rNFMkdEv5XlW99N9rTPso=;
        b=Dc7qwaISIFgLvWH9ytph+BW0OmR1vwuuEbvDuoM52eh8WcJLZf1gbtMGnWG3ttE+zR
         Uu+wkZ4wSnWj6qZYOpYUlNrKEIJ7qZa3HH9beBCdFXNFV1VFJ/GZjbnHAUl+TlGhz5we
         HKxJD1fEd9aej322ekO9QLa/FndPgUSbTpBbBjAbASSzAV97I2jtrpR4NxAsGPOuDn77
         BMB4LCOtlfVXE3uVkT+5R1U/TE+VMmHhGuvUycbICbJWget0dZnj2pe2k0M/B0bgM+dR
         jE4iX7Hh0xg61XrKytcAMRoDE7oshnUh9oSl9w4IrXiMis4mHBdDyQCFs77vjK5A1I5N
         vX3g==
X-Forwarded-Encrypted: i=1; AJvYcCWXbblwvYOyw59oMRHtKTBH17BniDW4dKGEZDG436CB/pU9cY/1iPLcYZ90zRm7PESHWvxeoi8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyW32CJeT0DCqqGY/vxVtcrQPoDMfqslciiETu5bKjlB8+UI8ag
	QwwNxnEhZUiFawm2c1J8OuyjIufYxiPSW8+Jh/9o5GQoh+QvruuegNaNWN0bV+Du6kqfbSCw+h4
	BDop9ShPXXHlARBjnGxWTszg2jsauzTvy10quDkredoZ3yTpA5UTaXg==
X-Gm-Gg: ASbGncsmJWQayDqemzhwjo6BgOXig3xPd0X8uI2sHmOCbk+ENQMaxfhHAKQY50Gi94X
	AEIFpw63wKoq7MADUboLoTUeJPShcE9A/aPdgolRyOrhGnyZmibCviGQi9KUpE75UehzStnJaIt
	fsUPKhfHyUNBAzN3IrRTEHxm3JSzcQZTvCBcrCZIaSB1amsDr7FUDo5guzUp7wEiaAk9X/icUiO
	R1GS2r662OgBEvcSw9kGJD4SXj5zh13uEGtjDwKK3T8vxTZIoc0c+4MiL9IHCsnmrJjInpvBIer
	01bbWA/JaCHRGQnrkQ==
X-Received: by 2002:a17:903:1252:b0:223:26da:4b6f with SMTP id d9443c01a7336-22368f74891mr183107385ad.14.1740959041707;
        Sun, 02 Mar 2025 15:44:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFYssys7UGoPXMBxe9bSswsi7jbUP9yKeJMmGxQGuBfHCIW8f2mxFgGu/EUcQbiuyd2gk6SQ==
X-Received: by 2002:a17:903:1252:b0:223:26da:4b6f with SMTP id d9443c01a7336-22368f74891mr183107165ad.14.1740959041447;
        Sun, 02 Mar 2025 15:44:01 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501fd28dsm65811695ad.94.2025.03.02.15.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 15:44:00 -0800 (PST)
Message-ID: <9dbebd7b-b441-405d-8c45-0dfa4d3df9e3@redhat.com>
Date: Mon, 3 Mar 2025 09:43:52 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/45] arm64: RME: Handle Granule Protection Faults
 (GPFs)
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-4-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-4-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HorzmspG-Vb0f447qvNcmysOVc_QaKGhT_IYO3wThGU_1740959042
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> If the host attempts to access granules that have been delegated for use
> in a realm these accesses will be caught and will trigger a Granule
> Protection Fault (GPF).
> 
> A fault during a page walk signals a bug in the kernel and is handled by
> oopsing the kernel. A non-page walk fault could be caused by user space
> having access to a page which has been delegated to the kernel and will
> trigger a SIGBUS to allow debugging why user space is trying to access a
> delegated page.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>   * Include missing "Granule Protection Fault at level -1"
> ---
>   arch/arm64/mm/fault.c | 31 +++++++++++++++++++++++++------
>   1 file changed, 25 insertions(+), 6 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

