Return-Path: <SRS0=oQwk=VB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24214C06513
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 12:24:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A2F1C2064A
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 12:24:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2F1C2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB2244A4E6;
	Thu,  4 Jul 2019 08:24:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2L+Nuo3n+Pzv; Thu,  4 Jul 2019 08:24:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C20064A483;
	Thu,  4 Jul 2019 08:24:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 801824A483
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 08:24:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9qxDCAIzH0GN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jul 2019 08:24:45 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C35140217
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 08:24:45 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id n9so5580017wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Jul 2019 05:24:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=KPSqPEoe1r6Dxc7vF7+sN1C5dmgHnFsD6yHp+UiwzX4=;
 b=t5/HjrgohCt6uKfHJuAYengujXnR52xhZlrpbWdHfH6Zascj2PJfNluzkVheE6yvaC
 uSwVXfBWfGFo1RvNSmiDY3lqJE05ePJGS0zYsML7l2wXaUwrQSwGxzKy0tJgfQ4iV92l
 SM/7UAjoziuqOqPaiU+gAJpA0EF2HCaKfag9hvY8xu0NwSutLq2gOeQehV+pkvIoBda7
 K3IAYsO66HADEWnJIy/NQYiLqANb/s2dOZD6ZP0bFA+4/EZrJLESbkyPdKmv55c2JB37
 MBuyCtRNMQdcf8CvjtTScJIIiPIqmXRAxvxhjSE90K6/QVEBX50BJFpYmYHb5mEMm+d4
 v+QA==
X-Gm-Message-State: APjAAAU5EgepmwlstTlBLdnL1y7r6Csc6T/k7H/TYLSzUq+U9hKDxjry
 +QETDUoXs/1vcrFu35xXjquu2Q==
X-Google-Smtp-Source: APXvYqzQG/PaUQQ9qHqVztBsqXVCipBrlmnMaYGswHNZvR/NBHYz4F7WBJigYoQ5tyRLPoX0TXFIMA==
X-Received: by 2002:a1c:b782:: with SMTP id h124mr12390007wmf.20.1562243084421; 
 Thu, 04 Jul 2019 05:24:44 -0700 (PDT)
Received: from [10.201.49.68] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
 by smtp.gmail.com with ESMTPSA id g131sm3675169wmf.37.2019.07.04.05.24.43
 (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
 Thu, 04 Jul 2019 05:24:43 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64/sve: Fix vq_present() macro to yield a bool
To: Marc Zyngier <marc.zyngier@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1562175770-10952-1-git-send-email-Dave.Martin@arm.com>
 <86wogynrbt.wl-marc.zyngier@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1f39cc48-12d5-2e56-c218-b6b0dd05d8ce@redhat.com>
Date: Thu, 4 Jul 2019 14:24:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <86wogynrbt.wl-marc.zyngier@arm.com>
Content-Language: en-US
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>, kvm <kvm@vger.kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 Viresh Kumar <viresh.kumar@linaro.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 04/07/19 10:20, Marc Zyngier wrote:
> +KVM, Paolo and Radim,
> 
> Guys, do you mind picking this single patch and sending it to Linus?
> That's the only fix left for 5.2. Alternatively, I can send you a pull
> request, but it feels overkill.

Sure, will do.

Paolo

> Either way, please let me know.
> 
> Thanks,
> 
> 	M.
> 
> On Wed, 03 Jul 2019 18:42:50 +0100,
> Dave Martin <Dave.Martin@arm.com> wrote:
>>
>> From: Zhang Lei <zhang.lei@jp.fujitsu.com>
>>
>> The original implementation of vq_present() relied on aggressive
>> inlining in order for the compiler to know that the code is
>> correct, due to some const-casting issues.  This was causing sparse
>> and clang to complain, while GCC compiled cleanly.
>>
>> Commit 0c529ff789bc addressed this problem, but since vq_present()
>> is no longer a function, there is now no implicit casting of the
>> returned value to the return type (bool).
>>
>> In set_sve_vls(), this uncast bit value is compared against a bool,
>> and so may spuriously compare as unequal when both are nonzero.  As
>> a result, KVM may reject valid SVE vector length configurations as
>> invalid, and vice versa.
>>
>> Fix it by forcing the returned value to a bool.
>>
>> Signed-off-by: Zhang Lei <zhang.lei@jp.fujitsu.com>
>> Fixes: 0c529ff789bc ("KVM: arm64: Implement vq_present() as a macro")
>> Signed-off-by: Dave Martin <Dave.Martin@arm.com> [commit message rewrite]
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>>
>> ---
>>
>> Posting this under Zhang Lei's authorship, due to the need to turn this
>> fix around quickly.  The fix is as per the original suggestion [1].
>>
>> Originally observed with the QEMU KVM SVE support under review:
>> https://lists.gnu.org/archive/html/qemu-devel/2019-06/msg04945.html
>>
>> Bug reproduced and fix tested on the Arm Fast Model, with
>> http://linux-arm.org/git?p=kvmtool-dm.git;a=shortlog;h=refs/heads/sve/v3/head
>> (After rerunning util/update_headers.sh.)
>>
>> (the --sve-vls command line argument was removed in v4 of the
>> kvmtool patches).
>>
>> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2019-July/664633.html
>> ---
>>  arch/arm64/kvm/guest.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index c2afa79..dfd6264 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -208,7 +208,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>  
>>  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
>>  #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
>> -#define vq_present(vqs, vq) ((vqs)[vq_word(vq)] & vq_mask(vq))
>> +#define vq_present(vqs, vq) (!!((vqs)[vq_word(vq)] & vq_mask(vq)))
>>  
>>  static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>  {
>> -- 
>> 2.1.4
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
