Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32B12F0C53
	for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 09:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755164938; cv=none; b=cAY5hhHa5okp5q4TCUU2HTq+2cc0lYNilVZ7msfYmoqNRW1D0kfo2UCBVThbzv3fN9bBKzYGhUTuOBV6Fusax1VhJoMg4/Ek6FYcV9wRwA1Z8gtHPyObIRsyfIuFICQk25fN3q4NkNPhE4CSqLrYZnuXVTVvaYebnm/uLhTWwhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755164938; c=relaxed/simple;
	bh=6ViulPyNxpGyEla0Ly7QVqs2yGv2gIdTjYax+36+3Ko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZpyWCSKz+M9Rj4af600YNwvQu6I7e2gmfbw6swnlD30sE3fj41ItRQBPg43FeHuG1DNJuGvrOmBsCJGRmS+54RF/Wif8DKKYRDnxsD0UkekkYwqUOzF6YBK/Mg4w9qAU6YwHY1gcuOZo0NGY/50cqUAbd3J1BKMF8iJI7/aDq1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uHMsiRqb; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uHMsiRqb"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-76e2e88c6a6so721168b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 02:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755164936; x=1755769736; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UhXQ8ClAZyC6ZwPBAtm9gjqUVvPh4kKwbXv0Fn9fBm8=;
        b=uHMsiRqbKYCpc6nD90AwEJdK4z1dwf65wEJVhC2+RWeVr5oZbswLZcpLiV3HAHO5yN
         DEv7dPxAtubPsuhZFwVJXTc5Uj1nc2w1RuoEF5b3M3jSo8PDf2AetKSZYExoUPb3uJ6A
         KqMzLcG8yKrPYTaS2VtKRL0lXG7miMy+weSZzwrnv+/2ZgNxB4eP7nVKh17f4LqMLqF1
         qdpieDClSuKSlAot4uiMtFZN4BU+HsUVKqIpVkj0BcKosoEppgIyHtitwtGYuw9KQPax
         977MpVWUFGvJMM98Ak1raq4x1ABJlqAJgLh6VG+s/acVmj/ZLXv1/CZpBvLpbq4pKaNS
         EtLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755164936; x=1755769736;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UhXQ8ClAZyC6ZwPBAtm9gjqUVvPh4kKwbXv0Fn9fBm8=;
        b=OtdURPBeAUKuGh5batU8AJbc+zJLFE0GBRm5C9Ea1jDOdKEexJDnC0yLJG2iOSDyAy
         9HH0F3fMZmQGa4osqExfcyHECPvILIqS650gl104NXEVC3UJPcM5KEyDX3+5vog9Fagg
         II9YkIxt4J1JfvKoaT/H1vx97uDBKSmvSLXCcx/UyMhq6tQLQqZyuDB8Je9CCzeMuRF+
         2bsi9RlHSYndUGo/oA580Eqf5g0qhsYDRaqI9qTYkAe8qveZpKG+RJtG8T4j45VPR9Yo
         tvHo1ElJfavb+CZNU4pg6rVCZvRNXPHRRrAj1Upyjwz6JRt8DFVWl9KPgXBa/+FQELJn
         imAw==
X-Gm-Message-State: AOJu0YxhbCjMMt1QVSRuWqvqpqwsvHgZN8+0A1+ziOQZVaWecyN1uhlL
	xa7qs7MyKEHPDLFh1mxmLeAp+SCQEOGglBeXkrSRDLmkntfsWpuGD/zwbadTMd2PChM=
X-Gm-Gg: ASbGncv66OHeu4vgVz5LnfRRRHak/eMTulYmE3glMwYGk79Nc4U71fM7iENFXMSzOOs
	2qpMY0FPrcVUcS6HTUCdm0q13LtUsYlfZAs+H73I+gSHM/5XvAelj9eOWR7ZduXDEKm4TKjZJcA
	nivjqprkNXB9iVeZA+X32+fXnN3VLWj+h4fePmlK/8GHNh6+G54gWUXTBGMK5pGRrtW5UHn4qHZ
	WjwXnl0r7mzunNCKgSWduKl8KxCbnCSpw4niEHFS/JDbhXGB39TVNRu7qavuPE1hpsoyvmDHZuQ
	m8B74f+Wq7o4mFnqsSP+h8vF4YXoQ+PAcyE9NxxUV2Wstyex9GOTDdp2Lc0TmR8yjlt2++8BMsa
	y5tb7KNXEB9IKLiTCM4FLb9B4MRwepl94aMny1LkK9DQaUXDm+FEDxgYjHNfNELPwFwKfItyWaS
	+dY7j3wYZWbb8pq+MFqJOEkO32lWE9oKIeTIu6YCAWXTrOSAyfxhffvoOGizhRhDPn
X-Google-Smtp-Source: AGHT+IHj3MwSb3JWcBhyoOovn8dGlEB/uRNYUIfQ0xd1gbq/JeWWUz0xFadXXnz/eyXHwR6A1K6geg==
X-Received: by 2002:a05:6a21:6da6:b0:240:20d:47ca with SMTP id adf61e73a8af0-240bd019e6cmr3470292637.10.1755164936214;
        Thu, 14 Aug 2025 02:48:56 -0700 (PDT)
Received: from ?IPV6:2401:d006:5c08:e100:bc49:5c3a:83c2:8ce7? (19r3hzjy9klp0jf5b7z5.ipv6.originbroadband.com.au. [2401:d006:5c08:e100:bc49:5c3a:83c2:8ce7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b470fd547d0sm2562644a12.4.2025.08.14.02.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 02:48:55 -0700 (PDT)
Message-ID: <80d7478a-bed3-4e6f-9241-2c4b54c62929@linaro.org>
Date: Thu, 14 Aug 2025 19:48:49 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KVM sysreg ids for FEAT_SYSREG128
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, qemu-devel <qemu-devel@nongnu.org>,
 Peter Maydell <peter.maydell@linaro.org>,
 Oliver Upton <oliver.upton@linux.dev>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>
References: <1c6b4f19-6cb2-4da0-9acc-d63307880de1@linaro.org>
 <86cy8y8grv.wl-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <86cy8y8grv.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 18:11, Marc Zyngier wrote:
> Hi Richard,
> 
> Thanks for bringing this up. FEAT_D128 is not on anyone's radar on the
> KVM side (I really don't fancy having to write another set of page
> table walkers), but it doesn't hurt to be prepared.
> 
> On Thu, 14 Aug 2025 00:27:25 +0100,
> Richard Henderson <richard.henderson@linaro.org> wrote:
>>
>> Hiya,
>>
>> QEMU (ab)uses the kvm encoding of system register ids in the migration
>> stream.  As we implement support for FEAT_D128, it would be good to
>> agree on an encoding for the 128-bit registers so that we can avoid
>> complications with migration later.
>>
>> I don't think this is terribly complicated.  Simply adjust the value
>> in the KVM_REG_SIZE_MASK field from U64 to U128.  E.g.
>>
>> PAR_EL1 (64-bit)	(__ARM64_SYS_REG(3, 0, 7, 4, 0) | KVM_REG_SIZE_U64)
>> PAR_EL1 (128-bit)	(__ARM64_SYS_REG(3, 0, 7, 4, 0) | KVM_REG_SIZE_U128)
>>
>> This will currently be cleanly rejected by index_to_params, resulting
>> in ENOENT for the ioctl.  When KVM grows support for D128 guests,
>> kvm_sys_reg_{get,set}_user can select the read/write code path based
>> on reg->id & KVM_REG_SIZE_MASK.
>>
>> Comments?
> 
> The encoding of the register, as described above, is absolutely fine.
> 
> But since you brought the subject, I'd like to align on a bit more
> than the encoding.
> 
> The way I see imagine it after two cups of coffee (which clearly isn't
> enough) is to have a feature bit provided at VM creation time,
> enabling D128 support, HW support allowing.
> 
> At that point, querying the list of supported sysregs would report the
> 128bit versions of TTBR{0,1}_EL{1,2}, VTTBR_EL2, and PAR_EL1 (ignoring
> things we are unlikely to ever support, such as FEAT_THE). The 64bit
> versions of these registers would not be reported.
> 
> Does that align with what QEMU would do internally?

Yes.

After selecting the feature set for the cpu, we register the system registers that 
correspond to each feature.  During registration, we select the size of each register 
(more specifically, the canonical definition is maximal, and 128-bit registers are 
squashed back down to a 64-bit registers when FEAT_SYSREG128 is not enabled).

We always require the same cpu model during migration, and the choice of register size is 
tied to the cpu model, so there shouldn't be any migration issues.  With -cpu max, we 
explicitly don't support migration between qemu versions.


r~
