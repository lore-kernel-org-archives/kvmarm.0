Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2B1328DA
	for <kvmarm@lists.linux.dev>; Tue,  7 Nov 2023 18:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YJa1Sri8"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-da1aa98ec19so7242783276.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Nov 2023 10:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699382729; x=1699987529; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qDCWSKP4vAXUfzgvit4LuMfPr8WJgpyfnDtKqeEtqPM=;
        b=YJa1Sri8hAukVqMDFfw65CiLRYAf82l8qB7I9+ysm/e6Z8pBvwIVhg/WnwVBLryt1c
         5szhUOmgNZNXklrx0R9clWSbbsQ1nJ6wAslz9co2sQaxWkU3o/4FSAvbt0x4gB415rKs
         F6BISSOjBZRRT3XXoYHjP9wPUEH6W2znlLK3QBjEt+F8r7Ximapk2sLVGyDzfkpgaYCP
         kmWp8odDwn0/rQWMJJL580TvBkpzs8dbNwtJbw4tfMsqEiIdE3G5OkSrXgR/3kL/l0x2
         2jxhFZLjJF52I4QUR0oxve3EweXaN+26pcIzmFZQtsRqQRO4RW247tXh6TPYsX9YyM5v
         e6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699382729; x=1699987529;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qDCWSKP4vAXUfzgvit4LuMfPr8WJgpyfnDtKqeEtqPM=;
        b=YuxZD+dGtbECA/eBTZD4yHHmu2toxAz99mDg4GOkX5pidWgO47Bx59bFQs4C9TOOcE
         3zixRTR3vFxwwfVEdtlk3Vb5VgVbtPKLZ3i0XgQPW/Ca2LP1Ld4z95DeG8lYTuEs3V5K
         24ECqTFRIqFRiOSJ/LvC5MBZRxxGVeCtznH3JJfLVghyh7bVtDiPEwLdhOcMaZB9NKIO
         RJ2vhukHKi/cLLC3SO2BFq+uYGDIVYUnadPxFNyc2lavy4lwKlDc1NS/ENljZjX08uFp
         G3m/Hr4SM9HpiokuBjuFLururhSDqJBsTYbba4LMrSIJ1NhBK2bAFoortIWdkY/2RmnB
         b71Q==
X-Gm-Message-State: AOJu0Yw2QZ5z+LI/Q0oWAyvecC0Nj7dHH3Y2KwMtx/9hC8lTL3bOHOMJ
	pdVHoBF9m94DLBefixFUiS5ma89FISTMpJouyg==
X-Google-Smtp-Source: AGHT+IG5qQtQqzPjeR5Y8G8AU6M7XDVXPeztR72N2C8qU92svUe1OJ6H7dpDFe3evTNNP4IMa8JRdAt/s/dkx9nskg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:c789:0:b0:d9a:c218:8177 with SMTP
 id w131-20020a25c789000000b00d9ac2188177mr566295ybe.8.1699382729191; Tue, 07
 Nov 2023 10:45:29 -0800 (PST)
Date: Tue, 07 Nov 2023 18:45:28 +0000
In-Reply-To: <ZUVxNs7q1yRyDq4a@linux.dev> (message from Oliver Upton on Fri, 3
 Nov 2023 22:16:22 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntsf5hv1vb.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 2/3] KVM: arm64: selftests: Guarantee interrupts are handled
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, ricarkol@google.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Colton,

> On Fri, Nov 03, 2023 at 07:29:14PM +0000, Colton Lewis wrote:
>> Break up the asm instructions poking daifclr and daifset to handle
>> interrupts. R_RBZYL specifies pending interrupts will be handle after
>> context synchronization events such as an ISB.

>> Introduce a function wrapper for the WFI instruction.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> What's missing from the changelog is that you've spotted an actual bug,
> and this is really a bugfix.

I will update the changelog mentioning this is a bugfix.

>> ---
>>   tools/testing/selftests/kvm/aarch64/vgic_irq.c    | 12 ++++++------
>>   tools/testing/selftests/kvm/include/aarch64/gic.h |  3 +++
>>   tools/testing/selftests/kvm/lib/aarch64/gic.c     |  5 +++++
>>   3 files changed, 14 insertions(+), 6 deletions(-)

>> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c  
>> b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
>> index d3bf584d2cc1..85f182704d79 100644
>> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
>> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
>> @@ -269,13 +269,13 @@ static void guest_inject(struct test_args *args,
>>   	KVM_INJECT_MULTI(cmd, first_intid, num);

>>   	while (irq_handled < num) {
>> -		asm volatile("wfi\n"
>> -			     "msr daifclr, #2\n"
>> -			     /* handle IRQ */
>> -			     "msr daifset, #2\n"
>> -			     : : : "memory");
>> +		gic_wfi();
>> +		local_irq_enable();
>> +		isb();
>> +		/* handle IRQ */

> nit: this comment should appear above the isb()

I put it there because the manual specifies pending interrupts are
handled before the first instruction *after* the context sync, but I can
see why to put it above.

>> +		local_irq_disable();
>>   	}
>> -	asm volatile("msr daifclr, #2" : : : "memory");
>> +	local_irq_enable();

>>   	GUEST_ASSERT_EQ(irq_handled, num);
>>   	for (i = first_intid; i < num + first_intid; i++)
>> diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h  
>> b/tools/testing/selftests/kvm/include/aarch64/gic.h
>> index 9043eaef1076..f474714e4cb2 100644
>> --- a/tools/testing/selftests/kvm/include/aarch64/gic.h
>> +++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
>> @@ -47,4 +47,7 @@ void gic_irq_clear_pending(unsigned int intid);
>>   bool gic_irq_get_pending(unsigned int intid);
>>   void gic_irq_set_config(unsigned int intid, bool is_edge);

>> +/* Execute a Wait For Interrupt instruction. */
>> +void gic_wfi(void);
>> +

> WFIs have nothing to do with the GIC, they're an instruction supported
> by the CPU. I'd just merge the definition and declaration into the
> header while you're at it.

> So, could you throw something like this in aarch64/processor.h?

> static inline void wfi(void)
> {
> 	asm volatile("wfi");
> }

Will do.
