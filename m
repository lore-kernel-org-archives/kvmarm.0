Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2624C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jul 2022 14:25:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97C5A4B5BC;
	Fri,  1 Jul 2022 10:25:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 50cpb21mgs+P; Fri,  1 Jul 2022 10:25:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C74124B5D3;
	Fri,  1 Jul 2022 10:25:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E79E4B53F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 08:30:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eYjxHtKn4++q for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jul 2022 08:30:51 -0400 (EDT)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC9464B53B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 08:30:51 -0400 (EDT)
Received: by mail-pj1-f45.google.com with SMTP id
 i8-20020a17090aee8800b001ecc929d14dso5245423pjz.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Jul 2022 05:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version;
 bh=yVSDhYrK8Y7ydTrXkxqp6foDlogTshep1dzSeIK3bck=;
 b=Ock5oAG9Efpw4etgLVjnFZV11LyFwgPvpKTQ4ZUP1pTdSGoQ8WaiPAxfpYGWq90h9m
 SUVHcVVvNb7Va/VLakQLFak7sQxXMVzfgg+NjAsL/lGLVjoSKmEWL6poTH5XuxU7c8Lz
 /7PRP/5DzpiPw5tR5mamU95Ows+oMWRP6Je0dT/Y2Ux3bmPfqZjjnGmPo5k0ASNSS/e1
 fWS+ZlHOHc8fhTHQXEw+Ab8BV/EjCUHPxZL+h0xHUpwrLOYO/2bkfTV+/ROTkQTA1/qW
 gSSuoKarWvxc/9mRAsNX+9D4Jppfu0YqEv5yVvix/VhLZLWSpdyZlfRRPG6/jWWdDKfk
 IFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version;
 bh=yVSDhYrK8Y7ydTrXkxqp6foDlogTshep1dzSeIK3bck=;
 b=WaI8RSLVaK1sBEdbQ3CustdMQDdmwWg7HlroanZdXXtl2zoHOHU3wlWRqVWwQ27IsE
 nikUfneQDGdya33AJrjpZMHYVMT+piB30DFp6VfnBbdko8LqiA9i+cYcG+ws3+XRmMji
 QmDmh6z3WU497AY5EErxRDYkPCfktOfKvF1VidFl7/i0qibY8M7IMRWzA22EBE+4p/Du
 ddtC97Uj6DxxchXPoVtSGSOXGKgzjZvI9UFhjLj/uzcWXmD9NTbXEWXbvhFjrgxkZ1Ld
 j6Z25VtxHvckxrkniS+C95rRtI7Z2mCCxP2c19BFB0N6Bgm3D26lnGcMLVvF3e68M69j
 epyA==
X-Gm-Message-State: AJIora/kvOObyZ/4cX+KPsASPJ5UOpQdUQXa3oK+AI/izGP5Cd1YZseP
 a+Bh2t4tINdM/fMw4y8xRhQ=
X-Google-Smtp-Source: AGRyM1vmkowsRZ77Rl9LxuQLsD4sTyOWaT8kaC4WNZGN6pzJBlYFKf5xB9txI4u8LtbbeJvoiyOjiA==
X-Received: by 2002:a17:90b:2391:b0:1ec:a241:5e79 with SMTP id
 mr17-20020a17090b239100b001eca2415e79mr18080199pjb.24.1656678650559; 
 Fri, 01 Jul 2022 05:30:50 -0700 (PDT)
Received: from MBP ([39.170.101.209]) by smtp.gmail.com with ESMTPSA id
 n18-20020a63f812000000b0040c33cb0ccasm15342175pgh.42.2022.07.01.05.30.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Jul 2022 05:30:50 -0700 (PDT)
References: <20220630161220.53449-1-schspa@gmail.com>
 <87mtdu15ok.wl-maz@kernel.org> <m2bkua148a.fsf@gmail.com>
 <a5ca4db3db9ef101258cab94d6b7e045@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From: Schspa Shi <schspa@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix 64 bit mmio handle
Date: Fri, 01 Jul 2022 20:22:21 +0800
In-reply-to: <a5ca4db3db9ef101258cab94d6b7e045@kernel.org>
Message-ID: <m2sfnlvwup.fsf@gmail.com>
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

> On 2022-06-30 17:50, Schspa Shi wrote:
>> Marc Zyngier <maz@kernel.org> writes:
>> 
>>> On Thu, 30 Jun 2022 17:12:20 +0100,
>>> Schspa Shi <schspa@gmail.com> wrote:
>>>> If the len is 8 bytes, we can't get the correct sign extend 
>>>> for
>>>> be system.
>>> I'm afraid you'll have to give me a bit more details.
>>> 
>>>> Fix the mask type len and the comparison of length.
>>>> Signed-off-by: Schspa Shi <schspa@gmail.com>
>>>> ---
>>>>  arch/arm64/kvm/mmio.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
>>>> index 3dd38a151d2a6..0692f8b18f35c 100644
>>>> --- a/arch/arm64/kvm/mmio.c
>>>> +++ b/arch/arm64/kvm/mmio.c
>>>> @@ -81,8 +81,8 @@ unsigned long kvm_mmio_read_buf(const void 
>>>> *buf, unsigned
>>>> int len)
>>>>  int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>>>>  {
>>>>  	unsigned long data;
>>>> +	unsigned long mask;
>>>>  	unsigned int len;
>>>> -	int mask;
>>>>   	/* Detect an already handled MMIO return */
>>>>  	if (unlikely(!vcpu->mmio_needed))
>>>> @@ -97,7 +97,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu 
>>>> *vcpu)
>>>>  		data = kvm_mmio_read_buf(run->mmio.data, len);
>>>>   		if (kvm_vcpu_dabt_issext(vcpu) &&
>>>> -		    len < sizeof(unsigned long)) {
>>>> +		    len <= sizeof(unsigned long)) {
>>> If you're reading an 8 byte quantity, what is there to 
>>> sign-extend?
>>> Sign extension only makes sense if what you're reading is 
>>> *smaller*
>>> than the size of the register you are targeting.
>>> 
>> Yes, you are correct, sorry for my bad patch.
>> Please ignore this patch.
>> 
>>> I must be missing something. And how is that related to 
>>> running BE? BE
>>> in the host? The guest?
>> I mean BE is for guest running with BE mode.
>
> So what problem did you see? If you have noticed something going
> wrong, I'd like to get it fixed.
>

I have running some static code analysis software upon Kernel 
code.
Seeing there is possible overflow.

maks << 1U << ((len * 8) -1);

The AI don't know, len is only the value of 1, 2, 4, and make this
a warnings

I tring to analysis this, but didn't realize the real scenario of
sign extension, and finally sent this problematic patch.

I do see some uninitialized memory reads (the values are not used
in the end, just as temporary space for API execution),
do we need to fix these?

> Thanks,
>
>          M.


-- 
Schspa Shi
BRs
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
