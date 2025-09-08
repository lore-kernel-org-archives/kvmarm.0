Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1F631E0FB
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 18:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357686; cv=none; b=GM0F/ECAVd4WToSPpyz1NpjZjW6Pfk7zVltlvMDD/qP04OXmAvPjmQrwB14IUPnlQe462tHW2DPLuuBH4okCy/H5MIPV78FInNSg7qSPCSntXJxFgnDcyDG2UWlWDDOqJdVgXVsQefIx+HIsAP/pWzo9ct5SGfaRdCDzZdU7jSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357686; c=relaxed/simple;
	bh=jyy2Ypc6417a0peHyHM40rbdu6Qv+lOp4irKZ2BPWsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sp0XJCPorpyUmQa9VlLD7wu2yqQKx253LsOd96bkGHDBgwEOvjYk2oDfMVKXo8sNNe8M7k0YnPMbFVy5PTK0EqFFMry/SVlmDUuuphiBskbZe+RNR4f9xvmPVemJBYFu9RfL50ClNh7SF47GT+mYyaZ4ETJJ4aL8OZI+P+bKysc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L6Uwo4bO; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L6Uwo4bO"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b5d6ce4ed7so955611cf.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Sep 2025 11:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757357684; x=1757962484; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nc/vcmy+EaSL+RZZSsVeBJ6JjsLMgp1Qvyb0IgIZr+8=;
        b=L6Uwo4bOkeY1H8mqDYraSem5ZT4O7AL0bfP0nP7zD/OSzcCZzmYclNOe/8zc19csdN
         VS5kySRXfNSVcil7obfSf7XIlGI1BzUnCnSuu1ccSmTm4j3Xv3+19q9egHlAdhVqwpOW
         ZYRETT8Vu3IM3hlNgAlyvdVcrGdlsjVNNysIRZbmwqNIWkoRc10Es2yxmUQ6AqtBjFDi
         Y0xjTdpqDoxd4+7RjOxX0/KDkbxhPDDpdUqQJzKUPPaU7i4cAmAIK6bmvOAFP6XSHSmF
         YXFHwkm5NjO16CBsz9DhJAhdrTK1B1SbOboEZgi09xq6rgO7fDlVR4F5MN2LF7HiuWAJ
         Kxmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757357684; x=1757962484;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nc/vcmy+EaSL+RZZSsVeBJ6JjsLMgp1Qvyb0IgIZr+8=;
        b=GGKtRnuh13KbF5gaIwlK+D5/77X03gVcmnZrP4BvWLwrxLRMUvtyfjxqKdnfGzoOnV
         RF+Nctd/2PyAvKTP8VvJI9CPpnEsMQ+yO5USusuTdFzjIlsskNqZN5/cPeoFo9DWqxvI
         HN7/ZizzQsgFZidk6zOgGSRyge59joTtE6KeYqpoOy5VGlc+JWdvzzNUW/+lAxTs2dyN
         uw8DVt+uB8KNafWQovSfFa8oa/jy1qY5+/2n7nySA0fajKFlMGaAHai043UsmA2PtF58
         kErWemLGU1cOmHlEwofFYSR0w4NTY2BBpazszCRaOlIYPRWD7Sm87uCcQKrrI0Gv1ypT
         am0g==
X-Gm-Message-State: AOJu0YwKvZl9COv4KM2WfqWACST3fPT0KVSG07wOAckEXULH+LleD5yf
	RerUjrXOq0aDrvzH/KGanlRtRhxBrViZ4dFDdY6chbeUwn5dacSAkXMQoPY6AIMmI0hjPFPJbh4
	10xBAHDjclkVmnRU1HkRkt2bEEq5qSKowgI1WOiOS
X-Gm-Gg: ASbGnctL6HPqDIldDPBrXTYY1xZasz2KEmnsvLS0YSgF7CRR3YIMtWCOYP5I3eAhFg6
	QbU7u9lIdXZvaTKIYY+ogTRBsKajS+Uwk6HAV0Nc4xXQ3vmWh5i2j8sNWF0F0D2megvkLWVKMAN
	JuPdBHWgg8Ky34EGN2ezZ3MEdGF5csbiR9VivleU6ll0kiiCPOtilYkS9vAsN2YshiQK7//G/TB
	f9ix11tXQaa7Z+RCq1JxbCjolm0SBjMQp6p
X-Google-Smtp-Source: AGHT+IHxJBSO7w5Xmh8kn2r/iMDjRfetjUilgPPiP9j+i2xhVrg37GnxGDxWNGuAz/flz/3JXZQ6OFIXSnc5YcieRWI=
X-Received: by 2002:ac8:59c9:0:b0:4b3:8ee:521b with SMTP id
 d75a77b69052e-4b5f6d1d109mr12322211cf.0.1757357683401; Mon, 08 Sep 2025
 11:54:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250827101949.4089456-1-tabba@google.com> <20250827101949.4089456-10-tabba@google.com>
 <1a248f14-60f2-4f8f-8b4d-3c63e602fd54@sirena.org.uk> <22a563c0-886a-4ccd-84e5-3093986b164b@sirena.org.uk>
In-Reply-To: <22a563c0-886a-4ccd-84e5-3093986b164b@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 8 Sep 2025 19:54:06 +0100
X-Gm-Features: AS18NWDbGDcURy5P5Xe8dqaGtypth_Kq4WFhaOlejGW8eCU1PI2j12fC_WRCJiQ
Message-ID: <CA+EHjTwR-PFQLkH5ECPc0Ak6RpnqJjV-j8Phjf9XrRqWo1+=vw@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, mark.rutland@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Mark,

On Mon, 8 Sept 2025 at 19:52, Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Sep 08, 2025 at 05:05:56PM +0100, Mark Brown wrote:
>
> > I'm seeing the KVM selftests failing in -next on multiple nVHE
> > platforms (pretty sure it's all of them) which bisect down to this
> > commit, when booted in standard nVHE mode the selftests are all failing
> > to initialise with:
>
> I'm seeing a different failure on the same commit with qemu in VHE mode,
> we fault during pkvm_init_host():

I can reproduce this too. It's the same issue. Fix coming soon.

Cheers,
/fuad

> <12>[  112.802609] kselftest: Running tests in kvm
> TAP version 13
> 1..34
> # timeout set to 120
> # selftests: kvm: demand_paging_test
> <2>[  113.800187] Unhandled 64-bit el1h sync exception on CPU0, ESR 0x000000005a000000 -- HVC (AArch64)
> ...
> <4>[  113.812056] Call trace:
> <4>[  113.812571]  show_stack+0x18/0x24 (C)
> <4>[  113.813078]  dump_stack_lvl+0x60/0x80
> <4>[  113.813448]  dump_stack+0x18/0x24
> <4>[  113.813711]  vpanic+0x124/0x2ec
> <4>[  113.813965]  abort+0x0/0x4
> <4>[  113.814198]  arm64_exit_nmi.isra.0+0x0/0x94
> <4>[  113.814517]  el1h_64_sync_handler+0x2c/0xac
> <4>[  113.814812]  el1h_64_sync+0x6c/0x70
> <4>[  113.815266]  pkvm_init_host_vm+0x20/0x48 (P)
> <4>[  113.815629]  kvm_dev_ioctl+0x264/0x80c
> <4>[  113.815960]  __arm64_sys_ioctl+0xac/0x104
>
> Full log:
>
>    https://lava.sirena.org.uk/scheduler/job/1794785#L2258
