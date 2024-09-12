Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACA21AD265
	for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 14:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726149832; cv=none; b=FEwwmBCNbbEbA4lbUWDPVzI2eCPjoU8rGahV8ad/GMHRxKErg4oCvEbcQod/O8AXfY4ZrL26cYndWKh6vaWiiFfk9Yz0Wr7i7U76i4jD7racfkTGD9Dpl1Z1dY/V4Q3figi6SUBC5/LbUj2X9DrRgvfxsVsv9a56lvLWqRsi7Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726149832; c=relaxed/simple;
	bh=f4ub2ioH2rAq4LrWkvf3tWt0xuhXdG4XmLanIfAoLdo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tMHwK4yC21ujXhEyRcQbPZ49znjDXCU2rAN2KcEJY1Mi5TFjZEtigIumyXTT4yORFk5R0ngm9FcxkJK65hFI7R60cY+B6/kX/6UDXTejTjDJlzpH/fBNq1MiHD4DY8gf2FnSnIWMfyBv+3rccRBYOlaYsngjkwoK/IqKAxtHPw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xGBBnXjP; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xGBBnXjP"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b8d96aa5ebso24012497b3.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 07:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726149830; x=1726754630; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WJF8OdeeEbgD1lB1UBEPz4l4GIXf0/aw8YXbCeOR8js=;
        b=xGBBnXjPmc8EQou3b1JXIHXDVVwC5DDIPTTLsPzCb2iNPobwzgL9wzEWJlbiZW91Qm
         DeUVf+He0/ZSnHaog0wP/8iEJGXM0bTp88Xx3jtMZwVGkfyhAIWO7rVUXFCA+KM0Sfb2
         udJHKBzPWHNaxksE7WlNd7o7CKAjHYOMNCq/N3dUP1g3qblPSW6JTDi6sJM2W5TEtD0m
         9Sb/TSRpYbywOydk27Ym1SnnZhYaVUDai/wh1QaXdtSbbGmkd4eRiBQ73+MDiFNqgFzB
         EyJDcY4wCpycFvHeTjFJZk1ZACuhzQVYAOFgzc18q806jEpz/mVw1XEwPZNzMsZBCK/7
         eSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726149830; x=1726754630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WJF8OdeeEbgD1lB1UBEPz4l4GIXf0/aw8YXbCeOR8js=;
        b=BahIQkD216gc8hlXEmHvVKw/0ps+WvnLCRTfdmGzxlM2zit+yRtTJi7E3Qm0M1tDdw
         voaI2qzdQ0sgjC503VEvZStqXM56ARzSWhctICtQALUPgDB8RMWrIktRd+BK95b97Y4k
         +FLXD2AFZzZHNIW2kIc5Js05adV+Stj0XdQGaprYeMoURJCVyQ91FmswCj9k6vVb7FId
         4gM/7VWq7cItlEwr9rybsp1RXFo4R/AV9xuJ2Ln0wqFY8iSjpUan5zFIlhTsmf0/Fesr
         kTfHp2ImXOnjftHrF5MSD1FTulZChPSdUMN4wnGb3B2hFtsyn5Cd//5+VbVYlBJZHWGC
         +5jA==
X-Forwarded-Encrypted: i=1; AJvYcCWGtFq9DACrkOjdihP/DKG0IOmPXZLqHYIu3oxgNidrjgBz4uneL1JR48t2+HrGMTpS8lljhR8=@lists.linux.dev
X-Gm-Message-State: AOJu0YylK/KbdBMLwpLkOSEzVL+8glmIN2iCrNJ/AdekWgP1eLec+BLx
	EuFpSOYiyMDmpnIQwBdcraw7XdntSmVL7JXgqbX8L3T/CJfjGigEy0fNz1TMwR7vtCHeL+xsg+8
	upg==
X-Google-Smtp-Source: AGHT+IG9MDMwcr2ud0GqvqLu65vyfg3SEL0UKjpaqJLZjzXIU9brTD+du2LqNfe439QMw4Yu0UCoNCtm5zw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:209d:b0:64a:d1b0:4f24 with SMTP id
 00721157ae682-6dbb6bb7dc7mr477817b3.7.1726149830238; Thu, 12 Sep 2024
 07:03:50 -0700 (PDT)
Date: Thu, 12 Sep 2024 07:03:48 -0700
In-Reply-To: <20240912-757a952b867ea1136cb260cf@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com> <20240912-757a952b867ea1136cb260cf@orel>
Message-ID: <ZuL0xEIB1ol5epEE@google.com>
Subject: Re: [PATCH v2 00/13] KVM: selftests: Morph max_guest_mem to mmu_stress
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 12, 2024, Andrew Jones wrote:
> I gave this test a try on riscv, but it appears to hang in
> rendezvous_with_vcpus(). My platform is QEMU, so maybe I was just too
> impatient.

Try running with " -m 1 -s 1", which tells the test to use only 1GiB of memory.
That should run quite quickly, even in an emulator.

> Anyway, I haven't read the test yet, so I don't even know what it's doing.
> It's possibly it's trying to do something not yet supported on riscv. I'll
> add investigating that to my TODO, but I'm not sure when I'll get to it.
> 
> As for this series, another patch (or a sneaky change to one
> of the patches...) should add 
> 
>  #include "ucall_common.h"
> 
> to mmu_stress_test.c since it's not there yet despite using get_ucall().
> Building riscv faild because of that.

Roger that.

Thanks!
