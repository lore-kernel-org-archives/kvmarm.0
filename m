Return-Path: <SRS0=a1NQ=P2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFB3C433EF
	for <kvmarm@archiver.kernel.org>; Sun,  7 Nov 2021 13:26:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1BA761215
	for <kvmarm@archiver.kernel.org>; Sun,  7 Nov 2021 13:26:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E1BA761215
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amsat.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D9274B1B0;
	Sun,  7 Nov 2021 08:26:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V2YtOA8rP9CW; Sun,  7 Nov 2021 08:26:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B625E4B195;
	Sun,  7 Nov 2021 08:26:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE65F4B156
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Nov 2021 11:56:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pSlnPXQzKpG4 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 Nov 2021 11:56:34 -0400 (EDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
 [209.85.210.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8473B4B136
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Nov 2021 11:56:34 -0400 (EDT)
Received: by mail-ot1-f51.google.com with SMTP id
 z2-20020a9d71c2000000b0055c6a7d08b8so5736315otj.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 06 Nov 2021 08:56:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=eBDSUIjOttiaXGIBqHqfJQJUcKgBFvtaHFb5EhflaV4=;
 b=jwu1jYdLMd+soBglUZdDw+LFWGg8j95W5+z9C42+a4nn9jwqVlGUw0hFSM1pITTcGT
 lsGpFaNsdJAk0XsgX4YXWuaSqBG6tR+X1Asxd+XTyTuUHldyEP6pJe3TLMM7AbeTcSVP
 1MyiRmH46yppdVl0l+iOGT1Ngzc4JJwQZ6G/5CmKHp6gpPeU/C4T2dEY8XnQXZRGtT3P
 yupUP+jowcw/SUwi6NPV4xRYrmD00VneE62YvxNuYHRKnVYfkw/TNdDdDQrcDuMIGw9x
 8/k5pB6tiOWjPKseoY3MLTdzx1DWg/vGO/eV+k6KZ2De8gdIRza+sUgEtY3atAU5Mbq8
 GhfQ==
X-Gm-Message-State: AOAM533aOB5znaiJqxZy7lzZTAbHU9lSFd9ILpQkZyTYgRxPdTQvxdHJ
 zSdZrWu0vs51KGJM33XLYUVqhJHtravUCz82IIs=
X-Google-Smtp-Source: ABdhPJxwhCJyC+uhck/vVYoIRwMhWus9uJyoYA8q1C4DG6hFBkzj6XG5LHI4onqLHXxXLvHpBvFJjhBzstBp2T8d+3A=
X-Received: by 2002:a9d:4e97:: with SMTP id v23mr20053935otk.190.1636214193915; 
 Sat, 06 Nov 2021 08:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-3-maz@kernel.org>
In-Reply-To: <20211105192101.3862492-3-maz@kernel.org>
From: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date: Sat, 6 Nov 2021 16:56:22 +0100
Message-ID: <CAAdtpL4UKw2s7ekxKjKy8XxPR5acq0u1qLR5ontL3T9MWJ5VPQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: mips: Use kvm_get_vcpu() instead of open-coded
 access
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Sun, 07 Nov 2021 08:26:42 -0500
Cc: kvm <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Atish Patra <atish.patra@wdc.com>, Paul Mackerras <paulus@samba.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kernel-team@android.com,
 Nicholas Piggin <npiggin@gmail.com>, Juergen Gross <jgross@suse.com>,
 Anup Patel <anup.patel@wdc.com>,
 "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, linuxppc-dev@lists.ozlabs.org
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gRnJpLCBOb3YgNSwgMjAyMSBhdCA5OjE0IFBNIE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5v
cmc+IHdyb3RlOgo+Cj4gQXMgd2UgYXJlIGFib3V0IHRvIGNoYW5nZSB0aGUgd2F5IHZjcHVzIGFy
ZSBhbGxvY2F0ZWQsIG1hbmRhdGUKPiB0aGUgdXNlIG9mIGt2bV9nZXRfdmNwdSgpIGluc3RlYWQg
b2Ygb3Blbi1jb2RpbmcgdGhlIGFjY2Vzcy4KPgo+IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2ll
ciA8bWF6QGtlcm5lbC5vcmc+Cj4gLS0tCj4gIGFyY2gvbWlwcy9rdm0vbG9vbmdzb25faXBpLmMg
fCA0ICsrLS0KPiAgYXJjaC9taXBzL2t2bS9taXBzLmMgICAgICAgICB8IDIgKy0KPiAgMiBmaWxl
cyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpSZXZpZXdlZC1ieTog
UGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPGY0YnVnQGFtc2F0Lm9yZz4KX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
