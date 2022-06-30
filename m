Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F93C43334
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jul 2022 14:25:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 291644B5BB;
	Fri,  1 Jul 2022 10:25:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id joO7k5B0TlT3; Fri,  1 Jul 2022 10:25:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9614B4B5C6;
	Fri,  1 Jul 2022 10:25:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C8784B456
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 12:54:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RzdlywcLQ6Ai for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 12:54:56 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F100B4B381
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 12:54:55 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id k15so19700401iok.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version;
 bh=3yzQoY2ucWrQqXREQTyNPjG4X86W8VdDP00R8nZTgn0=;
 b=gKHIqcp0AXkJmHeV5RhLZd4icY5aYh4HmgWSU7ggoO73jfesxxLYVvV03O8gLsc2g5
 +cOwbiWrWLrnxa5Ivba04k23sLZ/VzDqvVJGxIuNRO5EFyAaZT8XPV48zebXLz7r3zPE
 nRM+1xIjvy9uFrtZkqNlL92HXCv2ysiQc2OBuTiijyC60csdeQWNQUric+SODQoFdcNO
 +f5AT3XUhy8XYk6g7mLvG0i5OjWUMLHCs5JRBTmY/dYg2Bx0dAaSfEcVomqUN6GSSFmM
 bFdS0Oweb2Xt6h1Wo2E36OtoM61U2v81mUipbJ64BoAnv3q3w5ZV7NEw6i9ETiEp66jF
 dXsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version;
 bh=3yzQoY2ucWrQqXREQTyNPjG4X86W8VdDP00R8nZTgn0=;
 b=fJeqcon2+U/kzPij2HWQzevGZRICl0uWFOpKsGCDWvidFQCOUqb85OENWOhUn2eF/u
 SNxBc56OFLqePX/Qcx7YYy5e4hveDfIFD4bQNmR+2SmWVXjM4UgbkyQSEo//PKZkob4H
 QO6ecjODsga2XWCorNhsYpC1y8F+Y8eYwl0qaHV1ccpfheuz7SYFTgUhN3B8xfo4HZiU
 sLCIO0ULpsETSaSa4h/RAuuWtqMyeyvLTU5Ykqqv/3k9qxIUzLzZWDu5RO9S/06Bq91u
 jTkjjP11Zszl+tEAdgSmMGO031UayPJD5trcupyj+1qpocwEoz0giad3+dUYpt3/uBR+
 mzXg==
X-Gm-Message-State: AJIora8o0EDmPJ2IIBvP5hmB3MKIZgLlen17tH3xsgDO+ogI4M0/ZjzG
 2ogZ9iykmYBCeQH77fQHsB4=
X-Google-Smtp-Source: AGRyM1t1lqGrk46YUgq5ZmtKS2YxO4+SXDt+L/ChvS1zfaHjZTfXt/gVL3fenni78YqCtJp7hGr+WQ==
X-Received: by 2002:a05:6638:1a8d:b0:33c:9a98:ff2d with SMTP id
 ce13-20020a0566381a8d00b0033c9a98ff2dmr6243491jab.31.1656608095139; 
 Thu, 30 Jun 2022 09:54:55 -0700 (PDT)
Received: from ArchLinux ([240e:390:a20:ece0:3ad5:47ff:feb5:73b2])
 by smtp.gmail.com with ESMTPSA id
 p7-20020a02b007000000b00339dd3976absm8723936jah.110.2022.06.30.09.54.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Jun 2022 09:54:54 -0700 (PDT)
References: <20220630161220.53449-1-schspa@gmail.com>
 <87mtdu15ok.wl-maz@kernel.org>
User-agent: mu4e 1.7.5; emacs 28.1
From: Schspa Shi <schspa@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix 64 bit mmio handle
Date: Fri, 01 Jul 2022 00:50:59 +0800
In-reply-to: <87mtdu15ok.wl-maz@kernel.org>
Message-ID: <m2bkua148a.fsf@gmail.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 01 Jul 2022 10:25:03 -0400
Cc: will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


Marc Zyngier <maz@kernel.org> writes:

> On Thu, 30 Jun 2022 17:12:20 +0100,
> Schspa Shi <schspa@gmail.com> wrote:
>> 
>> If the len is 8 bytes, we can't get the correct sign extend for
>> be system.
>
> I'm afraid you'll have to give me a bit more details.
>
>> 
>> Fix the mask type len and the comparison of length.
>> 
>> Signed-off-by: Schspa Shi <schspa@gmail.com>
>> ---
>>  arch/arm64/kvm/mmio.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
>> index 3dd38a151d2a6..0692f8b18f35c 100644
>> --- a/arch/arm64/kvm/mmio.c
>> +++ b/arch/arm64/kvm/mmio.c
>> @@ -81,8 +81,8 @@ unsigned long kvm_mmio_read_buf(const void 
>> *buf, unsigned int len)
>>  int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>>  {
>>  	unsigned long data;
>> +	unsigned long mask;
>>  	unsigned int len;
>> -	int mask;
>>  
>>  	/* Detect an already handled MMIO return */
>>  	if (unlikely(!vcpu->mmio_needed))
>> @@ -97,7 +97,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu 
>> *vcpu)
>>  		data = kvm_mmio_read_buf(run->mmio.data, len);
>>  
>>  		if (kvm_vcpu_dabt_issext(vcpu) &&
>> -		    len < sizeof(unsigned long)) {
>> +		    len <= sizeof(unsigned long)) {
>
> If you're reading an 8 byte quantity, what is there to 
> sign-extend?
> Sign extension only makes sense if what you're reading is 
> *smaller*
> than the size of the register you are targeting.
>

Yes, you are correct, sorry for my bad patch.
Please ignore this patch.

> I must be missing something. And how is that related to running 
> BE? BE
> in the host? The guest?

I mean BE is for guest running with BE mode.

>
> Please convince me.
>
> 	M.

-- 
BRs
Schspa Shi
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
