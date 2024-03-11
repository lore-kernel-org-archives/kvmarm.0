Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6343851C58
	for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710179320; cv=none; b=nAdDzQnp7/x1arLPKuU5xmqb/2aga9ouAJ3ca+2joqJ6T8eih05ErM5vJQb2R901tD4gWiAmAIkkTpjtO2ZYIpU+fGOVl0FFsc6MUwf785jgfv0+YVKXVYP35ZjENqHhA0thb3HjAhzoscaKn1J+LLh0WDjv+mEDFTNEQAhoT/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710179320; c=relaxed/simple;
	bh=L1n1/YHrPlqMMkbS0uthBiig9NG84l+9uiSYaBNVKOc=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=LxQQn6bHMAyNRp003NktYzeUwKEE2EON39SB+xAOrWNsxKP/Z9ZoSmjw8ZPcNMk+uFs4TFEG8Lrgzlpc5ZkU6ibSLg1lyaBme78jGH/Slku9nOexwQwdDm7lmY4NMw6GibUytCsR/QVwQM+3sImkhFgqAFyUKwKHC/Ro/k14PAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZfDTsBKp; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZfDTsBKp"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a2386e932so35250647b3.1
        for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 10:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710179318; x=1710784118; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BiOP5uhojwXrQMEQN8gcT/txErWrlOzb94LiHfJQtiY=;
        b=ZfDTsBKp2rtxB7VPA0VT91V0pGjRQtVe10Q8JC78eBUWV27sHFNV3pXROzR83FmfNh
         jcR0esz2K+cLNDnD7UnxluMC2n8kqADgfT8eRmGNT2fqc+B8bV+xyV9qo37LdIMAk0OX
         NmdyHTJ/AW0WaqSO8xcWvQnIPG2GhXEj60PhccsXbLUc7YYRnClm1BYZiQzVOUL2PLCn
         tAhxN9P33n9gheApJOxEAjuZKnlSWaJVLrGWmwFECZ4rjfULHZJolLRjWt3v/g0ETix2
         ZFH9nAlbQFlrecGFlWYpe5JKe1mXboEB78bKlNbXUQp/XUXZjizHuHA4Mfq06lhAKTlA
         C6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710179318; x=1710784118;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BiOP5uhojwXrQMEQN8gcT/txErWrlOzb94LiHfJQtiY=;
        b=ECkqV7qZg3MwuZ098RWp6uLanOu5DgtBlah6B67HS1IYLrummHa3yn2y7CT9V8hKqh
         tY2uMZyibXcpO80krGqIhT7L35Kg8bMlcCbn9lI+JU8onJK9/sXBZ6NXBe0U5w2zj4q8
         DKYOAzvuUa5lE/USr3l2DoDmSL7xvCnW8Gzkezv/r6jiW3H7dXn+LRdvt3vtwpZ5FPBD
         MHlYu9jG4ipfaG+aE6tcEo/7bDAnAszSgSmSv74yDI+n2unC7JIIlNXz9K+MMD+K65Po
         WSt7Eqj8c+/DbiEupgyypwEmbmOPdDDsNXxgRQO2udVoCzr9N2b26DEy1tUkBr1aklo6
         bi3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWF8BWD3xpEAm0QgNWVlDy7j6tgaICX7VU1tZp8nFaif+x9yjT+vNN3MtptcQCoEYSqQWpEUTTPYrnrtcKYgftqSHY85PcX
X-Gm-Message-State: AOJu0YzVnnDtUY0q5dhdTx1k6PfGf4J9sZibhkHXBaBuNnYWZWGWHssC
	V7FB84QmN38+Ougytulf4LatFR4ELEDv4tDZxJfl/Ma6skQ41/92FEcKphqU6XytdFudkFPYqcz
	RDXm3AesLEJJGSZqu/gtw8Q==
X-Google-Smtp-Source: AGHT+IGFlAS1WdzxYj387xVx8jJoAYV0MEk2zSj5ce9EnqPrBq6hYHzb4A6q6s61+sDLDrkY8tMPGxgQ8QXCcYndpA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:f8e:b0:609:25d1:ea9a with
 SMTP id df14-20020a05690c0f8e00b0060925d1ea9amr2008993ywb.9.1710179318418;
 Mon, 11 Mar 2024 10:48:38 -0700 (PDT)
Date: Mon, 11 Mar 2024 17:48:37 +0000
In-Reply-To: <Ze6PMRMfIK8z0q4F@thinky-boi> (message from Oliver Upton on Sun,
 10 Mar 2024 21:57:21 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntzfv4slqi.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v4 2/3] KVM: arm64: selftests: Guarantee interrupts are handled
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, ricarkol@google.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

>> -		asm volatile("wfi\n"
>> -			     "msr daifclr, #2\n"
>> -			     /* handle IRQ */
>> -			     "msr daifset, #2\n"
>> -			     : : : "memory");
>> +		gic_wfi();
>> +		local_irq_enable();
>> +		isb();
>> +		/* handle IRQ */
>> +		local_irq_disable();

> Sorry, this *still* annoys me. Please move the comment above the ISB,
> you're documenting a behavior that is implied by the instruction, not
> anything else.

Fixing this too. I changed this in the third patch but forgot there
was also an instance in the second.
