Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EED7C43219
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 21:46:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C95894B877;
	Mon,  7 Nov 2022 16:46:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BOqYLg+zDEK7; Mon,  7 Nov 2022 16:46:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 880424B878;
	Mon,  7 Nov 2022 16:46:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE1434B875
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 16:46:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jvJaQtzca5ne for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 16:46:37 -0500 (EST)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FA884B868
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 16:46:37 -0500 (EST)
Received: by mail-pj1-f51.google.com with SMTP id
 c15-20020a17090a1d0f00b0021365864446so11554360pjd.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 13:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
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
 b=PqQW1EEXJgvrCjdfodk/pHCLw8BbFPtmDX0XZOooH+mgwzYFP1qaSzBjw7rM+4VU0P
 as+2b1eZeDmDr/mE3CAK3JJBMTat4uOdjobJ8etSEyOUaDA3YGk4la0Z4FPab1TcXLyU
 I/b5gF3gLsQO1RVlN4SDOqigUq/EyONH8hBZmoj7MUFWk1VOAl++bJXhPhsI48o4nCEk
 1ihBlLVtkxnYbLxdXZMkWi4oVyE0FIUoQHi3hDzOKTAq9aZuDNJMBV4e+dgjBmTvk1+G
 GQ/KWpm0fCBA/EDt3upZZ7YwunywYEhMypU3/vQXsO66C3lUNP76Vt3ATnFol8GmZjVR
 aEJg==
X-Gm-Message-State: ACrzQf0NZ7LqAz7sTthDtyrjH8ZjuZK7Rt5t22VQC+jpotujOHJTx/F4
 csszhO70AAfq07Wd0HxhypA=
X-Google-Smtp-Source: AMsMyM5nI4bmuY9lD4XinO2gz+Xc6KHSLBRiOXpXoSFa21NNV37M1qdfO6ImmoOBa63VChvhPC/Cjg==
X-Received: by 2002:a17:90b:1d12:b0:20c:8edd:59a3 with SMTP id
 on18-20020a17090b1d1200b0020c8edd59a3mr52739175pjb.222.1667857596321; 
 Mon, 07 Nov 2022 13:46:36 -0800 (PST)
Received: from localhost ([192.55.54.55]) by smtp.gmail.com with ESMTPSA id
 i126-20020a626d84000000b0056c0b98617esm4981650pfc.0.2022.11.07.13.46.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 13:46:35 -0800 (PST)
Date: Mon, 7 Nov 2022 13:46:34 -0800
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
Message-ID: <20221107214634.GE1063309@ls.amr.corp.intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221104071749.GC1063309@ls.amr.corp.intel.com>
 <Y2V1oslbw24/2Opd@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y2V1oslbw24/2Opd@google.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Yuan Yao <yuan.yao@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Isaku Yamahata <isaku.yamahata@gmail.com>,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Chao Gao <chao.gao@intel.com>,
 Eric Farman <farman@linux.ibm.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
