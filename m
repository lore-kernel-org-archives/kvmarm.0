Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D39DC43219
	for <kvmarm@archiver.kernel.org>; Tue,  8 Nov 2022 17:46:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96AB74B87B;
	Tue,  8 Nov 2022 12:46:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WRhdSOYFZF-y; Tue,  8 Nov 2022 12:46:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 493EF4B885;
	Tue,  8 Nov 2022 12:46:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 145714B875
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 12:46:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j9rSCOlnVo0u for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 12:46:37 -0500 (EST)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC1524B82F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 12:46:37 -0500 (EST)
Received: by mail-pl1-f174.google.com with SMTP id u6so14802698plq.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Nov 2022 09:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=cjSjC5m99kmUUHYC704oOlI8KJi6LTudhKVnFW3q+Mo=;
 b=ftWxPl3+8IfelsK/irLrvblaLrX6dvTk43ZU1RGb7E7QhEuhpuFGQnZUs1B/6eqA8Y
 9uQybJjBJrLcnswih9ZuqdP/IGzw5N1LHsBYZwMjKm4pxbrW1ieLuxCyIbeQvnPHGIX9
 KlKI+02Y2PtkvzGrkUCj7EVO4k0DJZDFtOtuUtFMvCioPX+FiFS160StdFwaRhG4AwZY
 /X/0r60JYMQEe4UtsauftLe+islfrGWTT7n2RWyEhP6x94J5Vb4QTPr7DjEYHP04yepW
 KF97tjKStfZxjB8uLonmnyGRloE774fNFuZ/STi6vuLRLYYB1EDXjhtfDOqD4TBoTzbU
 ZVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=cjSjC5m99kmUUHYC704oOlI8KJi6LTudhKVnFW3q+Mo=;
 b=ijc8kQCz0wyraEhIMd0X40Lv/Uf6gQFXsCY9pOag42rZF+hmvazQhce+TLSWBGwmIQ
 WbT2u/Il6KIUcrOCT2mEK1qg5x0c//7Tx7dTTBgwublHnAexWVxY6L0qkjitbz4PbVb8
 93O310icQmp6l/tThsW4oGd5iji5TcDkYsY2DdYmT//c9jkMvfV2Kff3vKQEym5ZoFNc
 Gd3N5rlJx8jZLFB0A8ojH2VwxNPYLj5SKXLbXUobLCxco2pADL2p6esDudWthshKc4Tb
 5pDJx0pqeZ+zOEqOnmeqU7co4xXGyOYR7YtV6AoOViJcwvvH5IMQApRPI3anjYSSJMQo
 QeVQ==
X-Gm-Message-State: ACrzQf2kqg6OUlSGEknp/aqIkNWAqFPL3O9hXT8uoJTyFR7zE8Z8/Wkb
 +VyZkAoUxwQyotfCYqGXAJfkwQ==
X-Google-Smtp-Source: AMsMyM6IejjlUU0y+myBNmX6xdBJY00CqsdAF2QTJKOsZh5WixYj1ODA6TQRcmab3f8JPfGm8K7ciQ==
X-Received: by 2002:a17:902:ea04:b0:187:4923:56f4 with SMTP id
 s4-20020a170902ea0400b00187492356f4mr35142106plg.97.1667929596484; 
 Tue, 08 Nov 2022 09:46:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 b9-20020a170902d50900b00185402cfedesm7283578plg.246.2022.11.08.09.46.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Nov 2022 09:46:35 -0800 (PST)
Date: Tue, 8 Nov 2022 17:46:32 +0000
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
Message-ID: <Y2qV+IGKyKQItMj2@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221104071749.GC1063309@ls.amr.corp.intel.com>
 <Y2V1oslbw24/2Opd@google.com>
 <20221107214634.GE1063309@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221107214634.GE1063309@ls.amr.corp.intel.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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

On Mon, Nov 07, 2022, Isaku Yamahata wrote:
> On Fri, Nov 04, 2022 at 08:27:14PM +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Fri, Nov 04, 2022, Isaku Yamahata wrote:
> > > Thanks for the patch series. I the rebased TDX KVM patch series and it worked.
> > > Since cpu offline needs to be rejected in some cases(To keep at least one cpu
> > > on a package), arch hook for cpu offline is needed.
> > 
> > I hate to bring this up because I doubt there's a real use case for SUSPEND with
> > TDX, but the CPU offline path isn't just for true offlining of CPUs.  When the
> > system enters SUSPEND, only the initiating CPU goes through kvm_suspend()+kvm_resume(),
> > all responding CPUs go through CPU offline+online.  I.e. disallowing all CPUs from
> > going "offline" will prevent suspending the system.
> 
> The current TDX KVM implementation disallows CPU package from offline only when
> TDs are running.  If no TD is running, CPU offline is allowed.  So before
> SUSPEND, TDs need to be killed via systemd or something.  After killing TDs, the
> system can enter into SUSPEND state.

Ah, I assumed offlining was disallowed if TDX was enabled.

> > I don't see anything in the TDX series or the specs that suggests suspend+resume
> > is disallowed when TDX is enabled, so blocking that seems just as wrong as
> > preventing software from soft-offlining CPUs.
> 
> When it comes to SUSPEND, it means suspend-to-idle, ACPI S1, S3, or S4.
> suspend-to-idle doesn't require CPU offline.
> 
> Although CPU related spec doesn't mention about S3, the ACPI spec says
> 
>   7.4.2.2 System _S1 State (Sleeping with Processor Context Maintained)
>   The processor-complex context is maintained.
> 
>   7.4.2.4 System _S3 State or 7.4.2.5 System _S4 State
>   The processor-complex context is not maintained.
> 
> It's safe to say the processor context related to TDX is complex, I think.
> Let me summarize the situation. What do you think?
> 
> - While no TD running:
>   No additional limitation on CPU offline.
> 
> - On TD creation:
>   If any of whole cpu package is software offlined, TD creation fails.
>   Alternative: forcibly online necessary CPUs, create TD, and offline CPUs

The alternative isn't really viable because there's no way the kernel can guarantee
a CPU can be onlined, i.e. the kernel would need to fallback of disallowing TD
creation anyways.

> - TD running:
>   Although it's not required to keep all CPU packages online, keep CPU package
>   from offlining for TD destruction.
> 
> - TD destruction:
>   If any of whole cpu package is software offlined, TD destruction fails.
>   The current implementation prevents any cpu package from offlinining during
>   TD running.
>   Alternative:
>   - forcibly online necessary CPUs, destruct TD, and offline CPUs again and
>     allow CPU package to offline
>   - Stash TDX resources somewhere. When cpu packages are onlined, free those
>     release.
> 
> - On SUSPEND:
>   TODO: Allow CPU offline if S1 is requested.

Is this actually a TODO?  I assume the kernel doesn't actually try to offline
CPUs in this case, i.e. it Just Works.

>   - suspend-to-idle: nothing to do because cpu offline isn't required
>   - ACPI S1: Need to allow offline CPUs.  This can be implemented by referencing
>     suspend_state_t pm_suspend_target_state is PM_SUSPEND_TO_STANBY.
>   - ACPI S3/S4: refuse cpu offline.  The system needs to kill all TDs before
>     starting SUSPEND process. This is what is implemented.

Looks good, disallowing SUSPEND with active TDs is a reasonable tradeoff.  As
above, I highly doubt anyone actually cares.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
