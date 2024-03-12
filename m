Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B818143731
	for <kvmarm@lists.linux.dev>; Tue, 12 Mar 2024 21:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710278925; cv=none; b=Vg1qSYS0GEbs/eqj8t6mQ9GJLeJeHsduRkZzuQV0Wgu5mc4PDBXMtL+X70T8pSuvBEcne4rtiJ02oS+eqCqtpuiUCyzour0JCX65nckTZXtMM87zMn4liXQ6/bAPCm84yO5E/vh3geBNzexSh00gO3ORCKbpNj/0nSPVEaVNOrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710278925; c=relaxed/simple;
	bh=TlN/KcWgKTqrLf9K7Wxdb6jjRGDSlbdWWWnaAZ4pxKc=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=F0MpTKjr6CDv6YOGAnr7TV0vBVoBXnyHPZFmVq1EpKYnT9ZTQc5UNu+QnEFFA3I9Muc+nXpalge361VDvUmsH3bY/DkknviVhahabkftxyXJiYaeMXmvwTj9jlR1zuwUP/x5s6wGr22gu4XxZYstmedi8EUkLN6TZ1TfgsqHDfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0l5rpd9/; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0l5rpd9/"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3665991055fso32065575ab.1
        for <kvmarm@lists.linux.dev>; Tue, 12 Mar 2024 14:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710278923; x=1710883723; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TlN/KcWgKTqrLf9K7Wxdb6jjRGDSlbdWWWnaAZ4pxKc=;
        b=0l5rpd9/yxZoaF+cPe9w6AQnAdlHPz7Jcbl3b1wIhvkp+4Ub68Wt7SiQZbAnOgcbOd
         aV0IMJsFnZNmNiccW5zAmG629oF9RvADwCQVGAXCbeOgh8k+ltjRGNfq6C6GELsOjSIE
         VWgUt+xzO9aIE9N1pvbEd8U18ygMjqYLa/HnLMRYMl4/s+beEEYEYz7hMG4YN1jMVdUh
         m8siezQqgAPJDTXG5Ax3Axdvo0TcDaC2N5Jk2wLg8HNb9VGmbHtaKQpMSR181azLLVG+
         R3+NLCFHKHjm/TEcVpnZ6dXJlIxFMgfGFqL7bUCdQPYfmx/GAQlc9vinmVrcLnInt87V
         3mmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710278923; x=1710883723;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TlN/KcWgKTqrLf9K7Wxdb6jjRGDSlbdWWWnaAZ4pxKc=;
        b=Np575D5ykcikSlK1Dh4wX5NA1JIN68edOs/8pK4+j3/wkePj+FZZ+T/KtzO6aW0ITE
         owaHSbn0Kaedr7rCYXCbIwQahrQM5rOj4AFp0ua+dsUsX0G7u3lhtT+bH4gwJrtsNqfQ
         5HG1B81NTnPeM5oBcvr4S8M0U/XXpK8vImU1/zgCJR0/44uX+aSVsErI01Dcl/e62I74
         WuB1gXYTbN15Xh+aKgEuDUqDBPchR8YGHXY1XxUpOeXyutqA29fgJQJ3ROIJrPwsJPf2
         eKe+HBCsu4IzK9HnPnTlL+/L6MswWtuHTBHnHlkoRwY8aajI1BZHnGbSPZofAvhboTHu
         V7bQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnzJPEtfykfPbBYiHRloIyKt/Uu7XYM/YR42D4bTQpSlMBOQW58CbI72jKJcrz5ccfckShSPWFCjuu0dtQHGn9CVYSia1r
X-Gm-Message-State: AOJu0Yy27JqSXP1z1naGO2fNxJVKPKFMVLdCaCd0ei06yJccypncNe1U
	sHkNJeHzIcgk7OoBfVVvZfVPn51eImT45lGkVPSrUQON8dZdy8X5k47rg0VfNH03Lxwga0LzdS8
	7MUXzaM6IWXPRAk6yXMoVlA==
X-Google-Smtp-Source: AGHT+IEoVsGuGGGld+ryeqksDKkbTQO1fBRWYgfgCt3ANgMLC+suKNaZec5VszPIVCIIPKCZ9y/dRjlt4XfPMVM4Tg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a92:cd84:0:b0:366:1f71:1f6d with SMTP
 id r4-20020a92cd84000000b003661f711f6dmr438743ilb.2.1710278923231; Tue, 12
 Mar 2024 14:28:43 -0700 (PDT)
Date: Tue, 12 Mar 2024 21:28:42 +0000
In-Reply-To: <Zbgx8hZgWCmtzMjH@linux.dev> (message from Oliver Upton on Mon,
 29 Jan 2024 23:17:06 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntv85rrvg5.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH] KVM: arm64: Add capability for unconditional WFx passthrough
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Colton,

> On Mon, Jan 29, 2024 at 09:39:17PM +0000, Colton Lewis wrote:
>> Add KVM_CAP_ARM_WFX_PASSTHROUGH capability to always allow WFE/WFI
>> instructions to run without trapping. Current behavior is to only
>> allow this if the vcpu is the only task running. This commit keeps the
>> old behavior when the capability is not set.

>> This allows userspace to set deterministic behavior and increase
>> efficiency for platforms with direct interrupt injection support.

> Marc and I actually had an offlist conversation (shame on us!) about
> this very topic since there are users asking for the _opposite_ of this
> patch (unconditionally trap) [*].

> I had originally wanted something like this, but Marc made the very good
> point that (1) the behavior of WFx traps is in no way user-visible and
> (2) it is entirely an IMP DEF behavior. The architecture only requires
> the traps be effective if the instruction does not complete in finite
> time.

> We need to think of an interface that doesn't depend on
> implementation-specific behavior, such as a control based on runqueue
> depth.

Here's the first thing I came up with after returning to this problem:

We have an ioctl to get/set a threshold value,
wfx_traps_runqueue_depth. If the depth is less than or equal to the
threshold, disable WFx traps. If greater than, enable WFx traps.

Current behavior occurs with a setting of 1. Always trap occurs with a
setting of 0. Never trap occurs with any large enough number.

Of course, having an integer may be more flexible than needed. I can't
imagine a practical use for a number between 1 and UINT_MAX, in which
case it would be better as an enum for different behaviors than a
integer threshold.

What do you think?

Also, do you mean runqueue depth for the current CPU or globally?
