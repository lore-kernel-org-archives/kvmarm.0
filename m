Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F58A2620DF
	for <kvmarm@lists.linux.dev>; Tue, 11 Mar 2025 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714838; cv=none; b=A774JogDnnjTPFLPdfvNDps+u05jHQie8mLdVbcko+dxn/Gm7M6gdDBtLHUhhdPo4vh6rjJaOpqZtPeuBinxv+orAUqeOl0oDMrIPfTfPWeh6DyCYXNxUCP5rlzqW/+C1kB3fhGZDwWspeQpZybD/1aEKsCh21Mm0+0LPI/1UkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714838; c=relaxed/simple;
	bh=fJoSgtJei61Vv1IRCa8Xzx03ffV9RuFjSgTUQ60+Pf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQW7F+t1A98fQyzu7PKFTv0WvfBXKmnnEwatCzDZJMXnfwb0ytzGWZiAK0n3QIh/ORFo4/J6WeD6yhkWKq8UiavbNg5qinDs4+1wTERp1ZUAb07LJzROvTtGZSn4uu55EKSqLVGA2WPd3uoUgAPpuyb9166U+8WUsDU3OHk8Ehg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x2TA1Z5r; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x2TA1Z5r"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22580c9ee0aso36846865ad.2
        for <kvmarm@lists.linux.dev>; Tue, 11 Mar 2025 10:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741714836; x=1742319636; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fJoSgtJei61Vv1IRCa8Xzx03ffV9RuFjSgTUQ60+Pf4=;
        b=x2TA1Z5rTHHn45AWYNtdEfzMEcdGG55Q7fgepxjRsk2C3A3PFQs+Iy09a84oXqYipx
         22hLLbVLUrNn4xwEAu+/N1g4Nsdm5R3XP4EbAj8+Yt5J8eVMNEouQRA+KQB9E45i9QVP
         p9N9EvTzcZojASf0OFd+XTwi3CLc3DfmM80Yn6EELfCkBxAbldFVaZTe8ns0hTETlDh/
         32Fkedft6rVzy/dGW3vC1Iuz7ezXHbR76nqLF5vB+WNZ80FMa++Q2+vsNtgi2jSx69qP
         sD54rOx4n1sIbO0SM4EfGVWAJn+d3T7IsiHNprYaJm/Fs1eN8dINyXqeQgSGgXSmt9ng
         QHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741714836; x=1742319636;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJoSgtJei61Vv1IRCa8Xzx03ffV9RuFjSgTUQ60+Pf4=;
        b=IyNOKvWjO8hif4GC53gla/O5Kuj8DDSzXNSgo+XXeTnTIDw/POzJgvIacyYAhPoDLA
         Xs+3esBeJ2ee8e6T0Cq0inTCZSP81AId129VKip05nnT738yPrAGfVgezadIsJuWBq89
         y2Ja4HsEDKSXr0Trx/R//e4sADLBGyzWjeLr2hUu93GfrOZF4sbIYfzLGwhhKhc9qy3v
         eJA7VJR3bsrDiu/V2ut/PiPJWOK6ssM6HlvGa/Qu3UtF1e1Oo9K5mnvlvS5dAoRofqog
         P7jYp+Jjx4RSiHUhV1MnVtP+Cv7Y+lGIr03BIOfGhGJvYLH54vpfgagz9rq17zyaynfN
         GSfw==
X-Forwarded-Encrypted: i=1; AJvYcCVFEmFptvHfHCeCF2EF/zV0RC5xBAC0dhQMG8z4gJV1WHMelJWqN8CeIq/l0Qd6heKYHfVYemo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyz8oR1m062JRZ6OuLkGPil+vD4Mi572ePs4ajLnF1cFECPEiLW
	iDKEDb5dj0B34XKyK/G4rUD2sdRZnsbjuxbIdg9p0JoCbkvpLLkTX31BofP+vSQ=
X-Gm-Gg: ASbGncuXJt00R2+5US6aIi4bR8rKtHOCXc1XuliIorKD+62A3Dguw2SODAd6ngiaZdX
	/pGq00j/1J8XhdKxU6NaKjzfgTeueky99dL14IwNHYdQYfE6vKJt827IpZX0lX2Qe4Im+rc6J/f
	61iUW663JmWGbKFtWHWiZny2L0Z12gp0cvPuAc4QhzB3FCUsSyz9Ve0uSjAT0JrH7m43/Wxq+Mo
	e/00KSQdQncRcNtMNs4uw41kV3L01Z4/XuwEBv8Bpvtv2bo9wCrm92lb8ubhZnEJJ2ObtR+DoHo
	qhU1wsBq3PolJAOz2HHFOzeotavIbHrxvYpB67hQg7hQI/tXam0FoWHG/rQRAvMDrOmRyCpYXY2
	0Y/jz5jNv
X-Google-Smtp-Source: AGHT+IGlaR9HwjrPVHTQyRxHtXjUtcHCgPfmVSkbp3ZKMt8nZvn1Cdbu6c7wfGboStIgwisDcZkQ2w==
X-Received: by 2002:a05:6a21:164a:b0:1f5:60fb:8d9 with SMTP id adf61e73a8af0-1f560fb098fmr18554773637.33.1741714836477;
        Tue, 11 Mar 2025 10:40:36 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af52f391035sm3669478a12.77.2025.03.11.10.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 10:40:36 -0700 (PDT)
Message-ID: <37fd4871-f3c5-43bc-9dd5-1c0f72dcd392@linaro.org>
Date: Tue, 11 Mar 2025 10:40:34 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/14] arm/kvm: add accessors for storing host features
 into idregs
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org, alex.bennee@linaro.org,
 maz@kernel.org, oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250311162824.199721-1-cohuck@redhat.com>
 <20250311162824.199721-3-cohuck@redhat.com>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250311162824.199721-3-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/25 09:28, Cornelia Huck wrote:
> +/* read a sysreg value and store it in the idregs */
> +static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf, ARMIDRegisterIdx index)

This still isn't used, and so must Werror.


r~
