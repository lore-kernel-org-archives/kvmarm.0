Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40B4C2BB55
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:43:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7ADD4207FF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:43:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mOOFt0Uf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7ADD4207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F4584B1CB;
	Fri, 10 Apr 2020 03:43:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G-q1oRy5V1CD; Fri, 10 Apr 2020 03:43:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4F004B190;
	Fri, 10 Apr 2020 03:43:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 364244B14A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 23:53:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8jVIgNfViaAI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2020 23:53:01 -0400 (EDT)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
 [209.85.210.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 121304B147
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 23:53:01 -0400 (EDT)
Received: by mail-pf1-f195.google.com with SMTP id l1so526545pff.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Apr 2020 20:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:subject:from:in-reply-to:date:cc
 :content-transfer-encoding:message-id:references:to;
 bh=vSIPEPOc5ZIkDepQBj4MVQxNI/hKIwhnPMzWb3j2cdg=;
 b=mOOFt0UftnQV7EQlLU/Z0Ws7IhdatJylqfsoCmwhaBgUZWrsNA6/RJ0YUzROT0KiVL
 vdG9y4QVZ1Rl8giDRDcZMulEKGaFFQsydDGGKc4ARLVcPxDxStAiHkBvtD2+jeK01+uT
 1GVs7W/T71S8PY9ewZMfiIaI4lFRnegc1qhwagu3hj+uG0QydUzrlPLTmTjCeFwjO9YQ
 KcVlUlV6lbKQXZ0Oz5GU1/tLDDkRhQHClHOTGOJnN8kafIHAfeF1TsUuElWWsKz76dop
 mky8pwdExPPlHT4HvPnKJLaQDljxBlF+uOgxWfUsmpuYyFZ/NXPT6CO9xlbAGRfKCgpS
 b/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
 :content-transfer-encoding:message-id:references:to;
 bh=vSIPEPOc5ZIkDepQBj4MVQxNI/hKIwhnPMzWb3j2cdg=;
 b=Q/StvkRbi3wIq1TPlx+BOzPvUANVWYR+IfSzO27oazyJ1vNc6Tpt7y3mjVm0oRfyvW
 rP2u1pcfcyCURawdv47O0VMFnZCRyrmUzZgrE+/LnrvVZlHoOAhweAYsZjkADoJMXxQo
 2M4gX9apwjaXNt5epz1huUFsm0lscmgJFMmMr3jqTJY5cFyxJ64D5F048LLSVu+OLnzp
 xs8A9zkJS8tlKbEXgH5BmQb1UT3aX9U6tC4nYHvc8GpvXVseO0hr8uS61zIcXyScrMAm
 fUmCSVDeeqWfHcWVlb2PnhrEmtB552Y339GbN6bmuZOg6BIkS5vCZ8IFyvruhzJTZhIg
 SqeA==
X-Gm-Message-State: AGi0PuYvuXhwPx0+HXPj6mft0ioXG5Dbff+j6afmdpaQEeLoqjzxsvqz
 a9t5/V89RCsHRWh1i21+wmM=
X-Google-Smtp-Source: APiQypJgEoPdhrJZvgMTrP0qIAy3rcKbJUAcjDjl3RwOCMwNaIkRgzs/3XW0Ty2wP8MV6mYBuLqHfw==
X-Received: by 2002:a63:cf50:: with SMTP id b16mr2600005pgj.189.1586490779975; 
 Thu, 09 Apr 2020 20:52:59 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:d8e9:9b3c:bb20:8b56?
 ([2601:647:4700:9b2:d8e9:9b3c:bb20:8b56])
 by smtp.gmail.com with ESMTPSA id w2sm521868pff.195.2020.04.09.20.52.58
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Thu, 09 Apr 2020 20:52:58 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: Contribution to KVM.
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
Date: Thu, 9 Apr 2020 20:52:57 -0700
Message-Id: <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
To: Javier Romero <xavinux@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Mailman-Approved-At: Fri, 10 Apr 2020 03:43:52 -0400
Cc: like.xu@intel.com, Liran Alon <liran.alon@oracle.com>,
 kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
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

> On Apr 9, 2020, at 8:34 PM, Xu, Like <like.xu@intel.com> wrote:
> 
> On 2020/4/10 5:29, Javier Romero wrote:
>> Hello,
>> 
>>  My name is Javier, live in Argentina and work as a cloud engineer.
>> 
>> Have been working with Linux servers for the last 10 years in an
>> Internet Service Provider and I'm interested in contributing to KVM
> Welcome, I'm a newbie as well.
>> maybe with testing as a start point.
> You may try the http://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> and tools/testing/selftests/kvm in the kernel tree.
>> If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at disposal.
> If you test KVM on Intel platforms, you will definitely get support from me :D.

If you are looking for something specific, here are two issues with
relatively limited scope, which AFAIK were not resolved:

1. Shadow VMCS bug, which is also a test bug [1]. You can start by fixing
   the test and then fix KVM.

2. Try to run the tests with more than 4GB of memory. The last time I tried
   (actually by running the test on bare metal), the INIT test that Liran
   wrote failed.

Regards,
Nadav

[1] https://lore.kernel.org/kvm/3235DBB0-0DC0-418C-BC45-A4B78612E273@gmail.com/T/#u
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
