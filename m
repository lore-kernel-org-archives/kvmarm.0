Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557F4525A94
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792073154; cv=none; b=cmbNF5M+4q2uvFKTF3AlY2ltPv+9N1vxqmOcZepjRUCDy3Ib+SvyGSkKww1ValFL/WA/fC6kTP11C/mskXW9KGnJda8N7B7AzuJuiL7+hHYSVophXsEy9RIWvhbmnM8/rt0H4rKFY0iJEQ1r4NNrsXl+vXCWNSYZYHShcM0e8is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792073154; c=relaxed/simple;
	bh=iRB8iNw/SDzXnV4puovDYxc4Klg6ae2JqBfiV4+yGyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z67BwrdA2YssXTC/ykuECgV/mhoXDbK9EK4I38bCIbqzOZOs78EIOe1u5z8NNE/4o5WYWbKLdkboN4tP3KbfCdL7Jbt2xjHfrheAR8/0W2QEHo0+IpCqOwvywGPdn3qA5+kRR1JM8jrlBw0U4mmyb2lgGE9nQaG+ti+Cz6JaajI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c0A7q4Iw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c0A7q4Iw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792073152;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ro4VReCJbMXDDulID/D345/NuyZnyk0gEdYTf6PdAuE=;
	b=c0A7q4Iwnd5g8WK4cXCehaUphka/QnRnsdawUGG1gXcBmLG9PkOb8w/v2qNsVIbpQCFL9G
	qiK2iP7cc/HxpJSdj12yb8U8p/C+G7cLrsbnjil8RS5GlRra80Ku2e3We4iBWP2XUaPfZ6
	cm+dK6cjis1QFgMbMyI1Dm7RD5JGHSk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-CC_MBDVDN2mgZb9z98Zchg-1; Thu, 15 Oct 2026 14:05:51 +0000
X-MC-Unique: CC_MBDVDN2mgZb9z98Zchg-1
X-Mimecast-MFC-AGG-ID: CC_MBDVDN2mgZb9z98Zchg_1792073150
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49cdc4080ddso41483075e9.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 07:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792073150; x=1792677950;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ro4VReCJbMXDDulID/D345/NuyZnyk0gEdYTf6PdAuE=;
        b=A3M3FDk1OZeFnD5eHy7w4cOLXLCc0Vc9gUNlpZ/qhEHfZlYzjLDwg53oiy08FNEKOk
         kiEjGDlbilOl0Bdu0P4rPmTKynVMyy1UElNGI4RzTJBwwtsJnHFpRWxv1naziqmG3QmH
         pnQ5w6ryPSy8avEKdVbsedITMSjH5jkIebDVK9DztI2VxCyDyUd2z/WZ8vwkW5CCKkyv
         iLV3NSAR4dCjn4DtYoC9jS7jRinLhfc/jYhZDgYRR9pGupnVCkW2mdSwuOShHyWce2Yg
         U6TqGhp153dybadHrPPn6M5WUVOC8jzSqFCOBSY3es6/uoFYXtfoyGxcSNEVPvA7Mion
         H/9Q==
X-Forwarded-Encrypted: i=1; AKwUvBwGKqJ/NEqKw4k94w9B0dfJ36i+QC/ycsaSI5QduFOHgSEzrRV8cjWacov0y3A70xYdraeeTNQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYKKZGRTBYBq7OY7sWBRQcPiQFKrEvLGA/0GMWIo6+ciKJbWenzZ
	nvsgs/EyEhMq8PtjMkzmjGB8dE8KPecx7fWv1ktmsKhgKH9PDnP18Li6UVCpCJUzRhSm3LNPWfv
	ydIdvRcuLy9ejHhfCFb6UZv+wML/RcllhB/MADiDkZLrG1ilwZxvmoQ0Ulw==
X-Gm-Gg: AYBFou132e9kURLYve+pfRuL/Hnsu4OOjYz8bySNMNA+rbeMKEAsYiw2i8zyTELuim/
	fuLfXzmsLiShax2b1QKeNf7rF4GukeIjuL1NHzDRq4glBr7VKLRGDWIhdg9W3F1jwJtrhr+vJIa
	sUt54uJg/G7djHKsMYZworheb/oAjFlF0mg1FGQ+lxwuqQAL4eSlZ5yUXASlahJ58UQgOVUYOFZ
	tZ4oGCpt4X3WhktOkMsyiHyWKMDnmSck03sTLcbDRBdnjo01vMeSeNPKz727OBeRNT2Vqi0cr/h
	85+oOjenLFgHTEz/nUuDc905K4j8Q1hvLibZ8X0+c4xxV4b4F/pgNUaIA/qKxwlrUD4B15uQsgN
	s3Mj+qO0Ruyxj84OfzEIhZV/H79SfiH1aTyjqw2U1k7Yidros
X-Received: by 2002:a05:600c:2154:b0:4a1:ac66:604b with SMTP id 5b1f17b1804b1-4a1c6635d20mr2234375e9.1.1792073148398;
        Thu, 15 Oct 2026 07:05:48 -0700 (PDT)
X-Received: by 2002:a05:600c:2154:b0:4a1:ac66:604b with SMTP id 5b1f17b1804b1-4a1c6635d20mr2233835e9.1.1792073147927;
        Thu, 15 Oct 2026 07:05:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd6428b3sm67859615e9.1.2026.10.15.07.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 07:05:47 -0700 (PDT)
Message-ID: <a1245318-1843-45c8-9822-bea483a3e660@redhat.com>
Date: Thu, 15 Oct 2026 16:05:45 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 14/25] target/arm: add neoverse-v2-v2 named CPU
 model
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, cohuck@redhat.com,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 ping@khushitshah.com, sandesh.patel@nutanix.com
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-15-khushit.shah@nutanix.com>
 <395b66c9-4173-401b-b469-8972b710aae2@redhat.com>
 <CAFEAcA8DcLLYJeE_NUKrFTKfYvHp+6YYAmCdZnBfz2AjRNDnzw@mail.gmail.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CAFEAcA8DcLLYJeE_NUKrFTKfYvHp+6YYAmCdZnBfz2AjRNDnzw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aRi29qkPb-kpeDNg0LyartsFwtsBx72wqezxTtljTcI_1792073150
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/15/26 2:22 PM, Peter Maydell wrote:
> On Thu, 15 Oct 2026 at 13:13, Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Khushit,
>>
>> On 9/21/26 2:32 PM, Khushit Shah wrote:
>>> Add a KVM-only named CPU model for Neoverse V2 r0p1 (TRM 102375),
>>> inheriting from neoverse-v2-v1 (r0p0).
>>>
>>> r0p1 only changes MIDR_EL1.Revision and adds FEAT_ECBHB
>>> (ID_AA64MMFR1_EL1.ECBHB).
>>>  static const ArmNamedCpuModel arm_cpu_models[] = {
>>>      {"arm-v9.0-a-v1", NULL, arm_v9_0_a_v1_props},
>>>      {"neoverse-v2-v1", "arm-v9.0-a-v1", neoverse_v2_v1_props},
>>> +    {"neoverse-v2-v2", "neoverse-v2-v1", neoverse_v2_v2_props},
>> nit I would call it directly neoverse-v2-r0p1 and leave the -v<n> suffix
>> for potential fixes. Same for r0p0 obviously.
> I'm not very enthusiastic about accumulating different CPU models
> for all the different rXpY variations that appear. We used to have
> a ton of basically identical pxa720 variants and I was glad to be
> able to drop those when we deprecated-and-dropped the pxa support.
>
> Is any user actually going to care about the difference between
> r0p0 and r0p1 ? In particular pX changes are just hardware
> bugfixes that QEMU was unlikely to be modelling in the first place.
I do agree. In terms of ID reg, there is very little difference between
both. Modeling a single one may be sufficient

Thanks

Eric
>
> thanks
> -- PMM
>

