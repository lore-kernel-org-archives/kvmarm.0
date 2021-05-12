Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4046EC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 19:26:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83B6461417
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 19:26:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83B6461417
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEE4E4B4DB;
	Wed, 12 May 2021 15:26:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H1FvPFTPVw72; Wed, 12 May 2021 15:26:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 057454B53D;
	Wed, 12 May 2021 15:26:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D94194B4DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 15:26:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TjZ2flecHVCc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 15:26:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD8BF4B2A4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 15:26:07 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 783D3613F7;
 Wed, 12 May 2021 19:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620847566;
 bh=cpcLCEh07MPFgU7nC0SnvS+k674aBQRE/mdbKfiBHi0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=fSItDh3kg9vohG+wOu8+YgwLSSy+onkW9xDYg4ZOVM68khqkeexpZkFjlEQN85aGc
 AwUbrfBgEZ11mqCUKlDXfkZ8k5OBiUPDIDcBAxj2EPFC/K2TggS7CsIel3fNdXJd6r
 w1O/TQqVQDmJ7nhyupTbcskn52vyJ6EaruHeXQeiVKVQubeFvtQjs9mtlaLHs6dV7W
 3EUYEf39mI8nrWRmbcN1RR1q1qKbxVeTLRXkYE54U2/PTwNBr7u6faP/G9qXWbfhRS
 KDT+MgyJF9p4i5nfbTMKNtsi6C2I8+2L/lHYF3LkxdleTEQX0a/Jf1VA2Qol1xcmD3
 R8oUwm/HoOB0Q==
Date: Wed, 12 May 2021 15:26:05 -0400
From: Sasha Levin <sashal@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
Message-ID: <YJwrzVNYg43MrA8V@sashalap>
References: <20210512144743.039977287@linuxfoundation.org>
 <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
 <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
 <87h7j7opg2.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87h7j7opg2.wl-maz@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Shuah Khan <shuah@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
 patches@kernelci.org, Linus Torvalds <torvalds@linux-foundation.org>,
 linux-stable <stable@vger.kernel.org>, Pavel Machek <pavel@denx.de>,
 Andrew Morton <akpm@linux-foundation.org>, Jon Hunter <jonathanh@nvidia.com>,
 kvmarm@lists.cs.columbia.edu, Guenter Roeck <linux@roeck-us.net>
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
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, May 12, 2021 at 06:02:37PM +0100, Marc Zyngier wrote:
>On Wed, 12 May 2021 18:00:16 +0100,
>Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> I made this change to get it to build:
>>
>> $ git diff
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_=
host.h
>> index dd03d5e01a94..32564b017ba0 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -335,6 +335,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu=
 *vcpu,
>> int cpu) {}
>> =A0static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) =
{}
>> =A0
>> =A0static inline void kvm_arm_init_debug(void) {}
>> +static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
>> =A0static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>> =A0static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>> =A0static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
>>
>> which matches the stub for kvm_arm_init_debug(). I can spin a patch
>> out of it and send it for 5.4 and 4.19. Marc, what do you think?
>
>Ideally, we'd drop the patch in its current form from 5.4 and 4.19,
>and send an updated patch with this hunk to fix the 32bit build.

Yes please. I've dropped it from 5.4 and 4.19 and we can queue up a
fixed backport for the next round of releases.

-- =

Thanks,
Sasha
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
