Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEFD15AD
	for <kvmarm@lists.linux.dev>; Mon,  7 Nov 2022 21:46:37 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso15994418pjg.5
        for <kvmarm@lists.linux.dev>; Mon, 07 Nov 2022 13:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9On9UDwN9+FMOJXKCMZYipbKJoIjLKP2XZ3U7kBuoB0=;
        b=GL+2Bxv6ry2q2tVdZRODeD97j7WTZ0CqlPqVG3cOZfSQ2lPpNfGbSsDDWxIi7pHIp0
         4gPpC/0UyTeXngfMw/90jVGCYvfydu4VVDIBdRhsclgKtmxCEiA9BP4R87XQG30smBdC
         1/LRsqd/o2s4hFf8dQGeyUXxQVNajfdobkSuQnz0LYFbUg3nN2WjiofwzLBJS7P0QSlq
         3E2aD8E0qfRqk/z6hwmiW9lLNW6MmCIaXMhDFh5+LVoso6k/SENsDAmWDZa1hpQYz//Q
         JF3KaJnULb3SlFFzyr0MclyB75dQs6HtyFHyOI25a5zATM3F+OUwHUTUTEkKDNPpwCyo
         BpOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9On9UDwN9+FMOJXKCMZYipbKJoIjLKP2XZ3U7kBuoB0=;
        b=t1/7owZNGNw32mQKOavroAUNSZ0Djt1cqrIbdEQxtwHqV8krX0CA6OgDqJcKuhwHq1
         ul7jcu/fejX28e5cI5urWlDNSXxUPUeyxiniyNx9atYnTJcmf7NrjaLEDAAyZmvQZfQf
         LacsZqhy3fRO35DUwoKOjILYZPpFAhZRMOI5oOFxvPNNLQwvzJGXKyXBsesG4LEPIUth
         SnyqOe9dr2eB8WAlp2BO0amFdJGoezv2jElbwEQ8GkvRlpddjShcrntl3RUL4JaoJEny
         wG7Bn40dY5TV3AjzaISNF7b3LVwzApPNKz9sUV74lVqQ+Ofa1VAzOtA303ReGuNedznr
         JqvA==
X-Gm-Message-State: ACrzQf2J5N5/y0EXLIgIfP4hVeWbxTBRBBNF1OcqUkcZILJdf0gABWl/
	kRWQZP9Q1+V3MeroVab4CvE=
X-Google-Smtp-Source: AMsMyM5nI4bmuY9lD4XinO2gz+Xc6KHSLBRiOXpXoSFa21NNV37M1qdfO6ImmoOBa63VChvhPC/Cjg==
X-Received: by 2002:a17:90b:1d12:b0:20c:8edd:59a3 with SMTP id on18-20020a17090b1d1200b0020c8edd59a3mr52739175pjb.222.1667857596321;
        Mon, 07 Nov 2022 13:46:36 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id i126-20020a626d84000000b0056c0b98617esm4981650pfc.0.2022.11.07.13.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 13:46:35 -0800 (PST)
Date: Mon, 7 Nov 2022 13:46:34 -0800
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Atish Patra <atishp@atishpatra.org>,
	David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
Message-ID: <20221107214634.GE1063309@ls.amr.corp.intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221104071749.GC1063309@ls.amr.corp.intel.com>
 <Y2V1oslbw24/2Opd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2V1oslbw24/2Opd@google.com>
Message-ID: <20221107214634.CijkAcaS-gAlvYvcPc9eT82R8j_MxP8LZce390rlkps@z>

On Fri, Nov 04, 2022 at 08:27:14PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Nov 04, 2022, Isaku Yamahata wrote:
> > Thanks for the patch series. I the rebased TDX KVM patch series and it worked.
> > Since cpu offline needs to be rejected in some cases(To keep at least one cpu
> > on a package), arch hook for cpu offline is needed.
> 
> I hate to bring this up because I doubt there's a real use case for SUSPEND with
> TDX, but the CPU offline path isn't just for true offlining of CPUs.  When the
> system enters SUSPEND, only the initiating CPU goes through kvm_suspend()+kvm_resume(),
> all responding CPUs go through CPU offline+online.  I.e. disallowing all CPUs from
> going "offline" will prevent suspending the system.

The current TDX KVM implementation disallows CPU package from offline only when
TDs are running.  If no TD is running, CPU offline is allowed.  So before
SUSPEND, TDs need to be killed via systemd or something.  After killing TDs, the
system can enter into SUSPEND state.


> I don't see anything in the TDX series or the specs that suggests suspend+resume
> is disallowed when TDX is enabled, so blocking that seems just as wrong as
> preventing software from soft-offlining CPUs.

When it comes to SUSPEND, it means suspend-to-idle, ACPI S1, S3, or S4.
suspend-to-idle doesn't require CPU offline.

Although CPU related spec doesn't mention about S3, the ACPI spec says

  7.4.2.2 System _S1 State (Sleeping with Processor Context Maintained)
  The processor-complex context is maintained.

  7.4.2.4 System _S3 State or 7.4.2.5 System _S4 State
  The processor-complex context is not maintained.

It's safe to say the processor context related to TDX is complex, I think.
Let me summarize the situation. What do you think?

- While no TD running:
  No additional limitation on CPU offline.

- On TD creation:
  If any of whole cpu package is software offlined, TD creation fails.
  Alternative: forcibly online necessary CPUs, create TD, and offline CPUs

- TD running:
  Although it's not required to keep all CPU packages online, keep CPU package
  from offlining for TD destruction.

- TD destruction:
  If any of whole cpu package is software offlined, TD destruction fails.
  The current implementation prevents any cpu package from offlinining during
  TD running.
  Alternative:
  - forcibly online necessary CPUs, destruct TD, and offline CPUs again and
    allow CPU package to offline
  - Stash TDX resources somewhere. When cpu packages are onlined, free those
    release.

- On SUSPEND:
  TODO: Allow CPU offline if S1 is requested.
  - suspend-to-idle: nothing to do because cpu offline isn't required
  - ACPI S1: Need to allow offline CPUs.  This can be implemented by referencing
    suspend_state_t pm_suspend_target_state is PM_SUSPEND_TO_STANBY.
  - ACPI S3/S4: refuse cpu offline.  The system needs to kill all TDs before
    starting SUSPEND process. This is what is implemented.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
