Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B9513ADF
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 15:23:56 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d07cb52a768so2403521276.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 08:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691162635; x=1691767435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFxOXnJrCnLwyosaEoJ5XKTdBgr+iJ5sfCPaX0Y1m90=;
        b=MqIxKVHf1VXgzNTFjVSItHPlUtA6jlDZ6cMA5loyVnm34+XGPfPfHi7i4Usm4AU7ac
         W0Mjx6U/igEf4P0ZYjtcGxo5foByhdtowNPxbDsL5QxNZpFdCplK5J4FG0yIuvCkXLS4
         a95QuhnNLAnW9bcMzcWNHzyxuBF+wGZZJ0d8TQTo8T4W2a9FWZUJU7HA7KupGKxbn1tI
         TXlz0Eyq/7GTDtCZ7PQmDvEX3+sJslw8Le4sjx5G9NNo4nB0y3Wd39Afmq319x33Xfyp
         hRct9w6s7Sl6w6sbkVIYwI3iqZVNtwB5GBxsHDPKWFaosSyjgDGsQ4el6xElhc4kvD9r
         626Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691162635; x=1691767435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFxOXnJrCnLwyosaEoJ5XKTdBgr+iJ5sfCPaX0Y1m90=;
        b=T+m9EItp3Sh51WfH6POpzshbfRYGQNO1e/RXJZaPWn85DubyP4xwz/NLncqWBvZQfw
         6GIQPb+TcZ2vwK3qY5oJcX39v7hHUrywKvWxjJiaSRnV3E6YHjGeXXWiukDk9yee/F8H
         6SqxL7wCcDtK7C3RmWUT2OxafpWPiT7s++SDPwGOzvnPlhJoe0QPG1PVGQJPPZsdB/kF
         ZYcTBmg2JvYmXqniA0hJgc9AoNWINFa6E5YTtO6aSrEeO5fDSBDdXoZa4Q9aSNH9zAda
         oImpnQGupcSEmuVuTAjASQ7Oxq0MklWoC21jR4TqXhZiP6WLyNYvdSKcVE046bHlV3Bq
         iisg==
X-Gm-Message-State: AOJu0YydcR5y8rZwbKRadU7JPw3Sva6pIdrYKctRSzaK2vpBIP59B0qf
	J043N3OmIgNUQsbxABk61FbMnboorvs=
X-Google-Smtp-Source: AGHT+IGE/OCLG15icz/3cvmPraYl9lMENeybPBclQw1v/gSBLG6RHMQjrkxyHk1GNtrEatT/w5sEvyR2tcs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b316:0:b0:d0f:bcfe:bc74 with SMTP id
 l22-20020a25b316000000b00d0fbcfebc74mr11768ybj.9.1691162635611; Fri, 04 Aug
 2023 08:23:55 -0700 (PDT)
Date: Fri, 4 Aug 2023 08:23:54 -0700
In-Reply-To: <ae42db25-9c8c-3f27-9ccb-41644b135a8b@rbox.co>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230804004226.1984505-1-seanjc@google.com> <20230804004226.1984505-4-seanjc@google.com>
 <ae42db25-9c8c-3f27-9ccb-41644b135a8b@rbox.co>
Message-ID: <ZM0YCjDLGzEBWF/M@google.com>
Subject: Re: [PATCH 3/4] KVM: selftests: Use asserting kvm_ioctl() macros when
 getting ARM page sizes
From: Sean Christopherson <seanjc@google.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 04, 2023, Michal Luczaj wrote:
> On 8/4/23 02:42, Sean Christopherson wrote:
> > Use kvm_ioctl() instead of open coding equivalent ioctl()+TEST_ASSERT()
> > calls when getting the support page sizes on ARM.  The macro usage is a
> > little funky since the "kvm_fd" parameter implies an actual /dev/kvm fd,
> > but on the other hand the code is invoking KVM ioctl()s.
> > 
> > Alternatively, the core utilities could expose a vm_open()+vm_close()
> > pair so that the ARM code could create a dummy, on-stack VM+vCPU pair and
> > use {vm,vcpu}_ioctl() as appropriate.  But the odds of something breaking
> > due to oddball, partial usage of kvm_vm and kvm_vcpu structures is much
> > higher than realizing meaningful benefit from using {vm,vcpu}_ioctl().
> 
> Since you're doing the cleanup, does mmio_warning_test qualify for the
> same (funky usage ahead)?

Hmm, I'm heavily leaning towards deleting that test entirely.  It's almost
literally a copy+paste of the most basic syzkaller test, e.g. spawn a vCPU with
no backing memory and watch it die a horrible death.  Unless I'm missing something,
the test is complete overkill too, e.g. I highly doubt the original KVM bug required
userspace to fork() and whatnot, but syzkaller spawns threads for everything and
so that got copied into the selftest.

And this stuff is just silly:

	TEST_REQUIRE(host_cpu_is_intel);

	TEST_REQUIRE(!vm_is_unrestricted_guest(NULL));

because crashing the VM doesn't require Intel, nor does it require !URG, those
just happened to be the conditions for the bug.

As much as I like having explicit testcases, adding a new selftest for every bug
that syzkaller finds is neither realistic nor productive.  In other words, I think
we should treat syzkaller as being part of KVM's test infrastructure.

I'll send a patch to nuke the test.
 
> -       kvm = open("/dev/kvm", O_RDWR);
> -       TEST_ASSERT(kvm != -1, "failed to open /dev/kvm");
> -       kvmvm = __kvm_ioctl(kvm, KVM_CREATE_VM, NULL);
> -       TEST_ASSERT(kvmvm > 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, kvmvm));
> -       kvmcpu = ioctl(kvmvm, KVM_CREATE_VCPU, 0);
> -       TEST_ASSERT(kvmcpu != -1, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, kvmcpu));
> +       kvm = open_path_or_exit(KVM_DEV_PATH, O_RDWR);
> +       kvmvm = kvm_fd_ioctl(kvm, KVM_CREATE_VM, NULL);
> +       kvmcpu = kvm_fd_ioctl(kvmvm, KVM_CREATE_VCPU, NULL);
> 
> Side note, just in case this wasn't your intention: no kvm@ in cc.

Wasn't intentional, I was moving too fast at the end of the day and missed that
KVM wasn't Cc'd.  Grr.
