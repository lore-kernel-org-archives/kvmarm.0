Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8209B1E98F3
	for <kvmarm@lists.linux.dev>; Fri, 27 Jun 2025 20:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751057155; cv=none; b=LaEgXHMZVEwewhJTcGB/tqe/eHfk+Vlj6hkrIJ58eynUX6nl2U/hfY3Xu2vCzrMdrzuOIcPFMAdp7l53BX1x1uZN4jRsBWmWbEZX/KKNcWDG2TF55NBBmHOCYCMcUQ8QDq6OXjAy6egyL9WzNP+AF6O4MFRhE3C6ifTpC3LJvRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751057155; c=relaxed/simple;
	bh=31Dp+CMBRMQ8uN0vaou9SdCDYjiC6hdV62l5ML46Uno=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=tgcI3xgJbs1oXL0ioq1UxXgSZjnVy4x0YdNgaZAcMZAT3dvsJdJAQXrqe0IeyBmDDstWFAUWTVdbVKnlXsVeEWJiC+qbk3fdzyOppYqmefMUw+5dfiVwFuX3ixsLMOKpvGYcuVmvmWjYzV+l55ldGhEuhdVoFq1Cb521Crf5wRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mz51N3NY; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mz51N3NY"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3de3b5b7703so1872075ab.1
        for <kvmarm@lists.linux.dev>; Fri, 27 Jun 2025 13:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751057153; x=1751661953; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UQtNA0hS1YdwM8TLVBpaF+KBYsznLZdF9AooNXo/LEo=;
        b=mz51N3NYREtLIDPTw711X4U8SaZPTiKjY5V0/svRPVc0vwInpFuyIp0o2Qg41tl7h2
         tKssnpWV7ZNIimhYCBRHO4PwjKbfMkU5fWDTQKMLRqEOtHGBnmxzRhWhCuGK5K4IvEzq
         LtLFlHUVrKDPmzHsdOReqJe4DOFYgjAmxVaAoMr1duinxj88RMJu+YNKxKgx3Q0Sub98
         o4YcSnJDKxfqLd2j4FFbDjHQgPsmjghBBW3gjlWTDcp7ptlN0rd6JdZX7O+ANXSvqUVb
         uWrAYtRS63aIbyYttMQRdym9Hdw+IAak7oEToDL4WYOy4ogaHBDVXT7wl5AO4+NT/NZA
         Xg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751057153; x=1751661953;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQtNA0hS1YdwM8TLVBpaF+KBYsznLZdF9AooNXo/LEo=;
        b=h5ycqGcUuMxrvQqmi6bOWPogRJLKPDeKoSsDFMrjgACgnkGJc+HtwW7U5s2rJfAYeo
         Oy5yl8Yb6T9NrYIyY3za05C6avmtQNn4T6aF/yoZo0/GSgWqqD3Ivh1PNznIgMW9PnQR
         8cUwe3n4lwGQba+hGbAlek50mOSz6dZDzOIGjenv6SFiYLZ6ee0J+VUIOvi7sNM/a2K2
         8xz86jv4iHQaIRUYRcmZ3c96O8l7p9JQeELqj45g7HJ5Bz6sK9IuaSiZQ3svBPRBbf4J
         pjbouwvLOGwXKrnlNXo16ogQF6bhyJ0Z9jMoSdsme/dE6lka440ScEhvma4NN+l6mmrr
         RVFw==
X-Forwarded-Encrypted: i=1; AJvYcCV+2/9Nxk6me3WQKiySThpNykI0Ohx0F5UETN+dmskU1/XFoz11zHAM6jcyFPyLyFwWmD+h8ic=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDsTE1VhDp7HToujOBra+ksKkKl3/FQ2TRBEfJz4aWpmPw9sfX
	t5H0BNO1zO8p60SgAf0gvA3ueYyYcQ0NabJSRd9ZRPUg7MIttcawpm28gnDrDIosgxTqb0yftng
	XbqDZpLC/hME1lHZVjXwXNPZHlw==
X-Google-Smtp-Source: AGHT+IG8ubvH3kPztAj1ao94LgGUW1XY/gBYCn7CffcpcGKKkMXZJW+TsDn1nh7iOVmLnOgs9jfVsOn7IAe78nE95w==
X-Received: from ilbec16.prod.google.com ([2002:a05:6e02:4710:b0:3dd:77db:e2f7])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:12e8:b0:3df:154d:aa60 with SMTP id e9e14a558f8ab-3df4acf7b61mr59890785ab.22.1751057152711;
 Fri, 27 Jun 2025 13:45:52 -0700 (PDT)
Date: Fri, 27 Jun 2025 20:45:51 +0000
In-Reply-To: <86sejlb9ba.wl-maz@kernel.org> (message from Marc Zyngier on Fri,
 27 Jun 2025 14:31:05 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntcyao9am8.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 03/22] KVM: arm64: Define PMI{CNTR,FILTR}_EL0 as undef_access
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	oliver.upton@linux.dev, mizhang@google.com, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	shuah@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Marc. Thanks for the review.

Marc Zyngier <maz@kernel.org> writes:

> On Thu, 26 Jun 2025 21:04:39 +0100,
> Colton Lewis <coltonlewis@google.com> wrote:

>> Because KVM isn't fully prepared to support these yet even though the
>> host PMUv3 driver does, define them as undef_access for now.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/arm64/kvm/sys_regs.c | 3 +++
>>   1 file changed, 3 insertions(+)

>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 76c2f0da821f..99fdbe174202 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -3092,6 +3092,9 @@ static const struct sys_reg_desc sys_reg_descs[] =  
>> {
>>   	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility =  
>> sme_visibility  },
>>   	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility =  
>> fp8_visibility },

>> +	{ SYS_DESC(SYS_PMICNTR_EL0), undef_access },

> $ jq -r --arg FEAT "FEAT_PMUv3_ICNTR" -f ./dumpfeat.jq Features.json
> (FEAT_PMUv3_ICNTR --> v8Ap8)
> (FEAT_PMUv3_ICNTR --> FEAT_PMUv3p9)
> ((FEAT_PMUv3_ICNTR && FEAT_AA64EL2) --> FEAT_FGT2)

> If you have FEAT_PMUv3_ICNTR, then you have FEAT_FGT2. If you have
> FEAT_FGT2, then we already trap and UNDEF PMICNTR_EL0 without any
> further handling since 4bc0fe0898406 ("KVM: arm64: Add sanitisation
> for FEAT_FGT2 registers").

>> +	{ SYS_DESC(SYS_PMICFILTR_EL0), undef_access },

> Same thing.
>> +
>>   	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
>>   	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
>>   	{ PMU_SYS_REG(PMCNTENSET_EL0),

> So none of this is actually required.

Thanks for the context. I'll take this patch out.
