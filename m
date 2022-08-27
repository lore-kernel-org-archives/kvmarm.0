Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF95C0502C
	for <kvmarm@archiver.kernel.org>; Sat, 27 Aug 2022 08:27:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0C024DB33;
	Sat, 27 Aug 2022 04:27:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fn1jm5IuqNhI; Sat, 27 Aug 2022 04:27:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA3A04DB3B;
	Sat, 27 Aug 2022 04:27:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E8E4DB33
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Aug 2022 04:27:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q8CZTkoOscVr for <kvmarm@lists.cs.columbia.edu>;
 Sat, 27 Aug 2022 04:27:12 -0400 (EDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com
 [209.85.208.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80ED84DB32
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Aug 2022 04:27:12 -0400 (EDT)
Received: by mail-ed1-f42.google.com with SMTP id 2so4605256edx.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Aug 2022 01:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :sender:from:to:cc;
 bh=db6wHPl1NoBxSkqFEqmoNM4w13Oy0TZZkviyKHiod6c=;
 b=UEYLobTe2AZYd65vehbSh24XDhaWFDZNCGL1gdVQxc452u7u2Q4Y0f66RZocX0c5TR
 DdJwU7CRlQgFC6BGI+qrfrE8odV1ul43ApbvWCBwVJ+CO5ykyfdKL69XWCEz4AxBVoPc
 Fw9/BZpE/pwvSNqV+U8bI4UFaXmNWqGWUpCFIcgHDmb/R5YJHvw+l1Nl4PI62pOc0Mlu
 G6Xxx2tmIx2MgPkjxhb9Qr8ZtxLsw5z8IGCfxtj4gjhzdE7BqdYB4NS6TbXn8rmeHOgA
 wuLPmYOYHGXF2RHYZcgbY4nK+iZs8S8bbVCuzl21nt3v+hkpld1DBAXs+elsDk4x4Ohv
 QRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :sender:x-gm-message-state:from:to:cc;
 bh=db6wHPl1NoBxSkqFEqmoNM4w13Oy0TZZkviyKHiod6c=;
 b=BFyusewTenTYXA6ZCc9Fwz1SvbTDtMGR5+BKTHiu1Drksw4aE6546msxClOkyHrrbW
 I8eSQCf2gKU3vZMFyJ2ZaAbkkaPlppoWPgJRnPs/dKwJseNDOnr9oXNyJu4yBtU3rx0f
 YAAP5usIwiTyE2fNiDSbTb8uDoN3KUnDgEtUwpBj0/F1Na+XwsoSYwoqWc2oPxLHP70u
 vsEv2EIkffr+gaEQRLWxA+Z2EUaXEBTkynch4Bp8BgjEdc/NlB6oxqEwGL1B62TGlNuV
 BTYRB3/4RhZeXb08emkMr8NY4qQmd4waeDDNMUavzpDmGsUYXIKY3JvHIKq7k5E+8kqN
 ajkQ==
X-Gm-Message-State: ACgBeo1Yo/wMumlnimZiDEMUNx+/s9dSijwH4vnBnqVl5izjYlfhhbSB
 wr+CziBo51lnGiR2U0l6t5E=
X-Google-Smtp-Source: AA6agR7k4MkhXbRXPVNIpqB7niZw9Vuq4+jhvWLePL+17JoEYc9ENHX7DdgLIO1WI1Mrtg/N6ODRPw==
X-Received: by 2002:a05:6402:71a:b0:447:ebb2:18f2 with SMTP id
 w26-20020a056402071a00b00447ebb218f2mr4862760edx.408.1661588831315; 
 Sat, 27 Aug 2022 01:27:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.googlemail.com with ESMTPSA id
 m18-20020a056402511200b0043d5ead65a6sm2485422edd.84.2022.08.27.01.27.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 27 Aug 2022 01:27:10 -0700 (PDT)
Message-ID: <79cc1418-2448-6a80-e4b8-2041f94c419e@redhat.com>
Date: Sat, 27 Aug 2022 10:27:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com> <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org>
 <171d0159-4698-354b-8b2f-49d920d03b1b@redhat.com>
 <YwTc++Lz6lh3aR4F@xz-m1.local> <87bksawz0w.wl-maz@kernel.org>
 <YwVEoM1pj2MPCELp@xz-m1.local> <878rnewpaw.wl-maz@kernel.org>
 <9e7cb09c-82c5-9492-bccd-5511f5bede26@redhat.com>
 <8735djvwbu.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8735djvwbu.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, will@kernel.org,
 shan.gavin@gmail.com, zhenyzha@redhat.com, dmatlack@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

On 8/26/22 17:49, Marc Zyngier wrote:
>> Agreed, but that's a problem for userspace to solve.  If userspace
>> wants to reset the fields in different CPUs, it has to synchronize
>> with its own invoking of the ioctl.
> 
> userspace has no choice. It cannot order on its own the reads that the
> kernel will do to *other* rings.

Those reads will never see KVM_DIRTY_GFN_F_RESET in the flags however, 
if userspace has never interacted with the ring.  So there will be 
exactly one read on those rings, and there's nothing to reorder.

If that's too tricky and you want to add a load-acquire I have no 
objection though.  It also helps avoiding read-read reordering between 
one entry's flags to the next one's, so it's a good idea to have it anyway.

>> The main reason why I preferred a global KVM_RESET_DIRTY_RINGS ioctl
>> was because it takes kvm->slots_lock so the execution would be
>> serialized anyway.  Turning slots_lock into an rwsem would be even
>> worse because it also takes kvm->mmu_lock (since slots_lock is a
>> mutex, at least two concurrent invocations won't clash with each other
>> on the mmu_lock).
> 
> Whatever the reason, the behaviour should be identical on all
> architectures. As is is, it only really works on x86, and I contend
> this is a bug that needs fixing.
> 
> Thankfully, this can be done at zero cost for x86, and at that of a
> set of load-acquires on other architectures.

Yes, the global-ness of the API is orthogonal to the memory ordering 
issue.  I just wanted to explain why a per-vCPU API probably isn't going 
to work great.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
