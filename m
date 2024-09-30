Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9029D186E52
	for <kvmarm@lists.linux.dev>; Mon, 30 Sep 2024 21:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727733413; cv=none; b=WRSYbfPu/5LlV3/C59pI4DyrONBP+4bCFIbGJ98gmzozvfEFbvpNU1EKvXgH1gOSsVBG65aCr0fn99DLeQILdvdqpGdevFGsDW2u0ZN8vnmnSBDT9pisrcpO1/DEfAcqTbJWf/MkXX4NYKcJH5rti484L5vlLsU7EJWodLq105Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727733413; c=relaxed/simple;
	bh=EI35CoEM1AcSciWaRt5Y7P85pwkoV/1G1OSkpZxfbPg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=YMYMQgxg3flmyzZ+ZGmnOTjTFiCxe1R2fEothVfz28wTkLUl4JSeu7YrYdbz6Qe74Mbu6qs7cmVYknSmNh8TDuKnzDkDtvr4psh8pJr582qHfr/WXXYbiGu1ToZCAGhz1+Z0lIj57MW7HHeyZ3yq/xwH4bnwrbdg/YOAbcTmFX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NeEwifml; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NeEwifml"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e08735ed9dso6684678a91.3
        for <kvmarm@lists.linux.dev>; Mon, 30 Sep 2024 14:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727733412; x=1728338212; darn=lists.linux.dev;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PntPBodbq4krAqAL/kXN8N5SHx+RiWW9dX81Z4mrKcI=;
        b=NeEwifmlixz/oYOvuJ9ak2/A6/t4qE7sO1eroHce1bdFVQFHwEaG+UdrVWDO7waZRr
         9XmrqqTn/vWXKB05c6uGXeQIYmrQ/FA2mObcFSgyf/aicDhXfdTLr2f3lhNM4PX99jyz
         nihH+/lEzI3gYyu4ol54/+CFD8SFbDjs/aVnHpkI+VDRWgYM08ZgHdsuKf7pbxTpkT+7
         WzAvSMr1bU7RKaRCU0YhfZlPl5BI6ZBfsd2AyRmtKcMzTcX/lDxYareDJxsUmoqheOLr
         agOPpyApo0bicDYy5BqL4FfVH/VeAYlzX4f4k8Ls8cdA0n7e9RwyxTqttHUZHG9lDXn5
         PuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727733412; x=1728338212;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PntPBodbq4krAqAL/kXN8N5SHx+RiWW9dX81Z4mrKcI=;
        b=Y5wbecWxkS6W6od5u5pHBNlu4xelqX4KPfNRgmjfVZa5gyq0hpe7YuF23/AnOHzARW
         BEXlrMUjszAvMDCg2gVAK0/pf7xSBa1zN1pJNFIFfd7lX0K0Vrzzipr7+iwHQ83+hAF7
         i6pZb6wf95/+lORKV8EE9wxqH4yd0OTJ2z10V8QgeO3y2CBZv4KHP2QZxSnQOfaEAtFA
         DTTPKwM5268tobZ13qczIaatnDjfmfM0KIicJiys13buCONv2mCVwFCXp3oRv27wq3Oe
         T/aI/NRRgqPHcuoRiLBDxVtJ+KNshreZDix4dlDmGzuPvyO9uGfuK+3f0aiufCzBAW6i
         ovRw==
X-Forwarded-Encrypted: i=1; AJvYcCWd1/eFIp4xULFL8amJiVbJ3eI4c/OTIZ8CZ9CB9Z6vrTJBqT+HuktlZXPfmSom8XF97693P3c=@lists.linux.dev
X-Gm-Message-State: AOJu0YyheQYpY4q9XcZrfR6FE3Y8m4yCERqwxvduqvjAgPtNJM9W7Z7G
	fC4YQQkP9Zyb4Iw3K/hNTiDRak5F8SBG+d244wQR5SrubFVd040mqlSXTcgmuMwzlFsFYISlwKX
	CYw==
X-Google-Smtp-Source: AGHT+IFa/3NUudFCuE72HcCwi+hM+UVm+5oAl6XGWfqHgohNP2i/0xjhJQmHwp45qjEiLZEOk9HWi9na7w8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f691:b0:20b:aed1:bf77 with SMTP id
 d9443c01a7336-20baed1c097mr62225ad.7.1727733411419; Mon, 30 Sep 2024 14:56:51
 -0700 (PDT)
Date: Mon, 30 Sep 2024 14:56:49 -0700
In-Reply-To: <20240911204158.2034295-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com> <20240911204158.2034295-4-seanjc@google.com>
Message-ID: <ZvseoZLzmaS4MEbc@google.com>
Subject: Re: [PATCH v2 03/13] KVM: selftests: Fudge around an apparent gcc bug
 in arm64's PMU test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 11, 2024, Sean Christopherson wrote:
> Use u64_replace_bits() instead of u64p_replace_bits() to set PMCR.N in
> arm64's vPMU counter access test to fudge around what appears to be a gcc
> bug.  With the recent change to have vcpu_get_reg() return a value in lieu
> of an out-param, some versions of gcc completely ignore the operation
> performed by set_pmcr_n(), i.e. ignore the output param.

Filed a gcc bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=116912

I'll report back if anything interesting comes out of that bug.
