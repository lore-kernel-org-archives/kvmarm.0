Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35624C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 11:51:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE3FB2065F
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 11:51:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XVK6UNYd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE3FB2065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3353A4B182;
	Mon, 18 May 2020 07:51:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lkdeJ6nElJJ5; Mon, 18 May 2020 07:51:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CE804B185;
	Mon, 18 May 2020 07:51:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521464B174
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 07:51:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sS5irqCuF1mG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 07:51:15 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 631CC4B172
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 07:51:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1589802675;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=K7n8PqWCHeJpc4TOjEire+J+qqMuJFazIRRj2XcxpTw=;
 b=XVK6UNYdU4VywjmAFzz4rSomFZo8w69sYLirdlHx1eh00yqZdbohfw1W0EJ98pGELrKuON
 TqPwRXBuBNaOe6PH2k++ArrdnXzSkn32fPLAIta4YPLBJaoHLoKHIvcDY7r8/VzXdL2s5M
 MB88Df8pucHBWL2smivtNcJ7Ik42sUk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-oNoVNWvGPrKQVLTuOSDJtA-1; Mon, 18 May 2020 07:51:11 -0400
X-MC-Unique: oNoVNWvGPrKQVLTuOSDJtA-1
Received: by mail-wr1-f69.google.com with SMTP id 90so5527237wrg.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 04:51:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=K7n8PqWCHeJpc4TOjEire+J+qqMuJFazIRRj2XcxpTw=;
 b=QdguoofCNv1p704YLi06lh9h99Dz+dp2FbWFihwu3+7JjOr3+MPR/PIzZazFtwrT2Z
 VqAjGKn17XXWl6TaxQtA2qKCJHttbJ3lZiLLRlQmPxy68Tka09+Jkl1K49dmNq9PS5ml
 Zw5FLN0qVnkLJooAciCaZRYh3H7yqiiLW9CC+o8Gpgns9fv8A+9EHlOzS8pwqikee8C+
 v6fzfYQxiecZnSYtym8hA8SV3qyPrbS3nCffGE92TSMHGaEaukiqpSgyktq8V4gFmE/R
 vovv9CD9y1lQDoHbgqu0xpyqIyELD0D6VrzbHXZQ01t85bPAtzGPVkB3fBk4C7bIz1DR
 g22Q==
X-Gm-Message-State: AOAM5310K3VE8ORwuVYuBpVUAqJyMrW48uSuwqljmw3F3UhqSMZdeBmm
 3JkYhekR8wd1OOUXR0iopwcb2Dqpf3x+47NuerC6AaS0es+CwwC7Siv9I6wyPCctOEys+u9NQtJ
 HdbN4n7twSKrGbyWnFkpP5wu3
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr13480501wmj.118.1589802670504; 
 Mon, 18 May 2020 04:51:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzz/MHpQNa5OfqyAyUmSWspHe0TEjiHHxK4p4e3uIbEs+RNZalGxhgvtsm502hRAzN6gU/urQ==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr13480458wmj.118.1589802670294; 
 Mon, 18 May 2020 04:51:10 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.90.67])
 by smtp.gmail.com with ESMTPSA id m65sm16590858wmm.17.2020.05.18.04.51.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 18 May 2020 04:51:09 -0700 (PDT)
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
To: Maxim Levitsky <mlevitsk@redhat.com>,
 Anastassios Nanos <ananos@nubificus.co.uk>, Marc Zyngier <maz@kernel.org>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
 <c1124c27293769f8e4836fb8fdbd5adf@kernel.org>
 <CALRTab90UyMq2hMxCdCmC3GwPWFn2tK_uKMYQP2YBRcHwzkEUQ@mail.gmail.com>
 <760e0927-d3a7-a8c6-b769-55f43a65e095@redhat.com>
 <680e86ca19dd9270b95917da1d65e4b4d2bb18a9.camel@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f077234c-ea74-faaf-422a-fd5d2c1c6923@redhat.com>
Date: Mon, 18 May 2020 13:51:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <680e86ca19dd9270b95917da1d65e4b4d2bb18a9.camel@redhat.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 18/05/20 13:34, Maxim Levitsky wrote:
>> In high-performance configurations, most of the time virtio devices are
>> processed in another thread that polls on the virtio rings.  In this
>> setup, the rings are configured to not cause a vmexit at all; this has
>> much smaller latency than even a lightweight (kernel-only) vmexit,
>> basically corresponding to writing an L1 cache line back to L2.
>
> This can be used to run kernel drivers inside a very thin VM IMHO to break up the stigma,
> that kernel driver is always a bad thing to and should be by all means replaced by a userspace driver,
> something I see a lot lately, and what was the ground for rejection of my nvme-mdev proposal.

It's a tought design decision between speeding up a kernel driver with
something like eBPF or wanting to move everything to userspace.

Networking has moved more towards the first because there are many more
opportunities for NIC-based acceleration, while storage has moved
towards the latter with things such as io_uring.  That said, I don't see
why in-kernel NVMeoF drivers would be acceptable for anything but Fibre
Channel (and that's only because FC HBAs try hard to hide most of the
SAN layers).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
