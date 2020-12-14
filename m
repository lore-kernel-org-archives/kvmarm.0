Return-Path: <SRS0=YLka=FS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71999C4361B
	for <kvmarm@archiver.kernel.org>; Mon, 14 Dec 2020 17:56:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C943F21D7F
	for <kvmarm@archiver.kernel.org>; Mon, 14 Dec 2020 17:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C943F21D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B1194B69F;
	Mon, 14 Dec 2020 12:56:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UhYasF3zsmEY; Mon, 14 Dec 2020 12:56:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BE2A4B4D4;
	Mon, 14 Dec 2020 12:56:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 413AC4B2F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 12:56:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2rpzhRTJGsVX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Dec 2020 12:56:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DA8D4B145
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 12:56:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607968608;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=79cm79IVkiUIbLvmmmEIZwiax7dBoLljm3f9FmIzx+g=;
 b=KhFye9cDX5q8mDnfI4TbO4Y+O0X7UqerUElX53Lv2u055oRNldvij9TclIkV/jvT0oJcxj
 7iyCoq6dIqXt41CNmuuBepP1RNoLbjeHzMtZx27uo87Yi4CQuXEt0K6LT1/G29Bll1rdSH
 r9GBaiklQlfp33AocVsKVqvVtJ7/Oeo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-vRLPlRR4Npeq7n-_gqgWcw-1; Mon, 14 Dec 2020 12:56:46 -0500
X-MC-Unique: vRLPlRR4Npeq7n-_gqgWcw-1
Received: by mail-ed1-f69.google.com with SMTP id cm4so8647401edb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 09:56:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=79cm79IVkiUIbLvmmmEIZwiax7dBoLljm3f9FmIzx+g=;
 b=O7bSbRxdtBCUvFgP2DzWAhpCTDFMjYyR3+PelNZMvTUCN6u6CggsJL7vGfQi6fkO2e
 Zi14+i5ppToOogPu2b+B9AST1/mdohqqkGy7Fs14qECLRleDhWv8bB1eXT1YK9qS8zg8
 ZVcR8pr0C2WvZrxuvt6I1DRhPcCmR8A208bb0p8USlynO/HS6aIzaKyf3BaTxiM8qlNw
 dNfXYbSGcYdt+jtVen8AS5fs3GiVrFwKwaVxhXfEQe9LCkE3do0r4pvcUPFVjhLtcE8u
 kK5Me3vvisevUB/edQnzkhsF4816ugT3lRDkQ+cv7doTwPrtrGEkNkSIG+jlomfiVj/z
 F7Xw==
X-Gm-Message-State: AOAM531j2QhUoYYgiplUqzfkzYMl+vxc+aLzsK0Mnt+inR2cUUtzwQaE
 xRWhjQRCPYCNnyQfQJtjx/1K1O7VKVBLDGVxXxgDboRcfXpcFQDIAdNjVfh4+zwMPpnW/yJbdou
 UjUsD4AHB1QicNysSXTyQ/CHBlgDSL6UYe1WLqE0nq6IeIvTHtu9VlryWRyRkpu4NY//u41Tboz
 r0
X-Received: by 2002:a17:907:101c:: with SMTP id
 ox28mr22119741ejb.201.1607968604918; 
 Mon, 14 Dec 2020 09:56:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDh7obIu90aOomr8vENCNh64r6dOqJ66dyirZU/BAXGxgxblE1fizw2ZRdkIUwFSn8NMbp1w==
X-Received: by 2002:a17:907:101c:: with SMTP id
 ox28mr22119703ejb.201.1607968604600; 
 Mon, 14 Dec 2020 09:56:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id o13sm15733009edr.94.2020.12.14.09.56.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Dec 2020 09:56:43 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.11
To: Marc Zyngier <maz@kernel.org>
References: <20201214174848.1501502-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f94b87f5-fcc5-273d-f774-48b816eafa2b@redhat.com>
Date: Mon, 14 Dec 2020 18:56:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201214174848.1501502-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Steven Price <steven.price@arm.com>,
 Shenming Lu <lushenming@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

On 14/12/20 18:48, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the initial set of KVM/arm64 updates for 5.11. The most notable
> change is the "PSCI relay" at EL2, which is the first "user visible"
> feature required by the Protected KVM effort. The rest is a mixed bag
> of architecture compliance (PMU accesses when no PMU is present, cache
> hierarchy discovery), cleanups (EL2 vector allocation, AArch32 sysreg
> handling), internal rework (exception injection, EL2 function
> pointers), and general improvements (advertising CSV3, reduced GICv4
> entry latency).
> 
> Note that this pull request comes with some additional bonuses in the
> shape of a shared branch with the arm64 tree (arm64/for-next/uaccess),
> as it was conflicting*very*  badly with the new PSCI relay code.
> 
> I already have a bunch of fixes earmarked for after the merge window,
> but that is probably something for another year!

Ok, cool!  Expect my PR to Linus around the Thu-Fri.  Better set 
expectations right after the mess from 5.10.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
