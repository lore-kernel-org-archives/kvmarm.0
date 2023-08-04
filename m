Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B1FC2CA
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 17:57:59 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5847479b559so26718647b3.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 10:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691171878; x=1691776678;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2rR0xmb+YpEUj3rb8g7lk+IJj++fv45EBtjmO2AP5zk=;
        b=bumgosh2Fglx/mRvU+e7OVXgC7GL8e1cUh6pLrPTjFCr9UtxKS8jKIgjXdbGU7nyIB
         oO617f8ho1qd8wT+xD4VFYTeaPZi2dl+K0fiOnV/oFPm98E/jQofZA3C46eOZpkfeTzt
         953FClrdMN0nv5fZLFsdS92yXZz+Afi5KT8m7tdXL7zd4opZR3yx0deF4nNrYv+FXPn7
         bKZ5BWu9uX07QDRB0lf3xnOAJG0MxOoOr0rZsvjSJ6u1u9iK9LaJlMjvHMRLWtt+vRqp
         gb7S1Mnrtcnfui9PfIh95nI/IYX7GEfDoTk12muH3wg97/2y9dAu3HKdoHHJldszxmPv
         G/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691171878; x=1691776678;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2rR0xmb+YpEUj3rb8g7lk+IJj++fv45EBtjmO2AP5zk=;
        b=SxbSr1vL/EAL7YIdxlpyV/mNY/Se2Usy34XBkdaGclXUNsKYzhwoRIymp56qMVZd/I
         JPTSKCjrnZW24dE98O8pCIr9bQOeasikCuLCVyBghu8fw+cz6IOpwaEUe6+NhUQNEokT
         mPvH1EOFAXrKKQ293XF4YtsYn6mbt0/TeDaJlZ0idi//LHyTUlscAAFTH4Qv/N0XyI0X
         dVWUQT47RB0CSvscM3HkenXUUxpsTZeG1Aida4dU5RQCj/3TCq4lxKesvpedLLNPEn9K
         JmdiF074p/cqJzPpDTcCT9d57zBS+MsaasgRlPtPBahFMbz44Pj9zZuLuTXnDIu10bz8
         rfhw==
X-Gm-Message-State: AOJu0YwHALxFKtT+ffpNuXHYCDPqIzC7gChQG4/KeXgDQHpHFatuXTsc
	/uatAGlzNt/ejlHiYHsaVTc1FJjpOGve32EH7g==
X-Google-Smtp-Source: AGHT+IHaWtzA8FG7BfGEEKC7lPm6rGVwe5YfMHXK5sMAhQq0e/Y5Uh7AwMHjvY2Enp4SAYdR7RxsP/uFCP9yIiKaLw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:aa4e:0:b0:d45:1b81:1154 with SMTP
 id s72-20020a25aa4e000000b00d451b811154mr9675ybi.2.1691171878397; Fri, 04 Aug
 2023 10:57:58 -0700 (PDT)
Date: Fri, 04 Aug 2023 17:57:57 +0000
In-Reply-To: <ZM0rXgKvb912k5BE@linux.dev> (message from Oliver Upton on Fri, 4
 Aug 2023 16:46:22 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnto7jm8zbu.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Add helper macros for ioctl()s that
 return file descriptors
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: seanjc@google.com, maz@kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, mhal@rbox.co
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Sean,

> On Thu, Aug 03, 2023 at 05:42:24PM -0700, Sean Christopherson wrote:
>> Add KVM, VM, and vCPU scoped helpers for ioctl()s that return file
>> descriptors, i.e. deduplicate code for asserting success on ioctls() for
>> which a positive return value, not just zero, is considered success.

>> Signed-off-by: Sean Christopherson <seanjc@google.com>

> I appreciate the desire to eliminate duplicate code, but I think the
> naming just muddies the waters. TBH, when I first read the diff w/o the
> changelog, I thought you were describing the input fd (i.e. 'kvm_fd',
> 'vm_fd', 'vcpu_fd'). I don't think explicitly spelling out the condition
> each time (i.e. ret >= 0) is all that difficult.

Couldn't ret >= 0 be the assert condition for everything? Don't see why
there needs to be different helpers to check == 0 and >= 0.

Unless I'm missing something, error returns are only ever negative.
