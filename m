Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747EEC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 15:12:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F336861242
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 15:12:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F336861242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E3E44B099;
	Fri,  1 Oct 2021 11:12:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IiBeMBxmf2LO; Fri,  1 Oct 2021 11:12:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CE644B0A3;
	Fri,  1 Oct 2021 11:12:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0C874B099
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 11:12:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5StGxPNejc9T for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 11:12:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19C1640573
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 11:12:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633101144;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=LW6fp9rG/lvp5l8prGyc0xe8qMlUDZGZChEO4If5ox0=;
 b=cuh1A0UdTnY4C7/r5YpXA/HDZdcZRHAH0A4gSo61eS6Q6bvNilXlPMVfGSUCyuwmKis9UW
 d9Zjldz9t86jJba30rS0Y4gkuAlD+rwF25Vi+mJFOhOOQ36ncRL+sI2aA4IN494+ZZ04yL
 F8X4X6KLO+EiK9dnDq4ILEMbegAALHc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-ShlJEXMqPXqkrBVjuSQPdg-1; Fri, 01 Oct 2021 11:12:23 -0400
X-MC-Unique: ShlJEXMqPXqkrBVjuSQPdg-1
Received: by mail-ed1-f69.google.com with SMTP id
 w6-20020a50d786000000b003dabc563406so6319027edi.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Oct 2021 08:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=LW6fp9rG/lvp5l8prGyc0xe8qMlUDZGZChEO4If5ox0=;
 b=400u0qVPl+qKqupn5P4xM3/Lpu4BGxAApw7Nil0c2T5r8wQBB4Ksh3eANJGsp9gTS7
 OD/ihlbq9PVU7EXYZIYRn56p+mjUsoKfAq2OaUrYRUBhsW1S93ThhV0ucWS4RgbX/hqJ
 Yowffq/DShh9xt69G1S4Ab8jFZuZvTvafxg0bhr/IBvHchO05edx0D8Q1hxtxShwOK1j
 p0dEfv/O85LkJ1/MLfxmn8KlWiIVCZ5Xd3LFM2vDC+h1KaYMWjUDa2wHee8K4rD6InHi
 LjFqZowpgLHZsaRnod+B29MPHsCUeSmlS7uVAX9E65ySl+odVSvMiIwoNNUmAIYueHsO
 fZSA==
X-Gm-Message-State: AOAM531Vn4O1XnWnCmjFWpHaWzJpVpHXIlEBNclKSoxyVOgvLyXTJWRc
 hMLMxZOLTcgoepUUP/9AAFkrsfUndF4aqNEcAMm1R0J+QKPdVS9QtqaWGXHzp8+bIfi+ElWgPq0
 4ge5qiUW56D+esIChnWwCxELl
X-Received: by 2002:a17:907:3e03:: with SMTP id
 hp3mr6732923ejc.183.1633101142621; 
 Fri, 01 Oct 2021 08:12:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSleQpwCGZXW71w2qzpx6TzvbZz4Gx6iqhZH1Md89m/5OKOBFh+S0Y4ZfLrRfA1AXKxqbKQQ==
X-Received: by 2002:a17:907:3e03:: with SMTP id
 hp3mr6732898ejc.183.1633101142335; 
 Fri, 01 Oct 2021 08:12:22 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.162.200])
 by smtp.gmail.com with ESMTPSA id ee13sm1227751edb.14.2021.10.01.08.12.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 01 Oct 2021 08:12:21 -0700 (PDT)
Message-ID: <7901cb84-052d-92b6-1e6a-028396c2c691@redhat.com>
Date: Fri, 1 Oct 2021 17:12:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
To: Marcelo Tosatti <mtosatti@redhat.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
 <20210930191416.GA19068@fuller.cnet>
 <48151d08-ee29-2b98-b6e1-f3c8a1ff26bc@redhat.com>
 <20211001103200.GA39746@fuller.cnet>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211001103200.GA39746@fuller.cnet>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On 01/10/21 12:32, Marcelo Tosatti wrote:
>> +1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (t_0), +
>> kvmclock nanoseconds (k_0), and realtime nanoseconds (r_0). + [...]
>>  +4. Invoke the KVM_SET_CLOCK ioctl, providing the kvmclock
>> nanoseconds +   (k_0) and realtime nanoseconds (r_0) in their
>> respective fields. +   Ensure that the KVM_CLOCK_REALTIME flag is
>> set in the provided +   structure. KVM will advance the VM's
>> kvmclock to account for elapsed +   time since recording the clock
>> values.
> 
> You can't advance both kvmclock (kvmclock_offset variable) and the
> TSCs, which would be double counting.
> 
> So you have to either add the elapsed realtime (1) between
> KVM_GET_CLOCK to kvmclock (which this patch is doing), or to the
> TSCs. If you do both, there is double counting. Am i missing
> something?

Probably one of these two (but it's worth pointing out both of them):

1) the attribute that's introduced here *replaces*
KVM_SET_MSR(MSR_IA32_TSC), so the TSC is not added.

2) the adjustment formula later in the algorithm does not care about how
much time passed between step 1 and step 4.  It just takes two well
known (TSC, kvmclock) pairs, and uses them to ensure the guest TSC is
the same on the destination as if the guest was still running on the
source.  It is irrelevant that one of them is before migration and one
is after, all it matters is that one is on the source and one is on the
destination.

Perhaps we can add to step 6 something like:

> +6. Adjust the guest TSC offsets for every vCPU to account for (1)
> time +   elapsed since recording state and (2) difference in TSCs
> between the +   source and destination machine: + +   new_off_n = t_0
> + off_n + (k_1 - k_0) * freq - t_1 +

"off + t - k * freq" is the guest TSC value corresponding to a time of 0
in kvmclock.  The above formula ensures that it is the same on the
destination as it was on the source.

Also, the names are a bit hard to follow.  Perhaps

	t_0		tsc_src
	t_1		tsc_dest
	k_0		guest_src
	k_1		guest_dest
	r_0		host_src
	off_n		ofs_src[i]
	new_off_n	ofs_dest[i]

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
