Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4410D5CB0
	for <kvmarm@lists.linux.dev>; Tue,  8 Nov 2022 05:43:56 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id l2so13204591pld.13
        for <kvmarm@lists.linux.dev>; Mon, 07 Nov 2022 21:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3UicMHRBXNKZ6klzBYtNlGfdpT3ipHtBcp9O7LuoFbE=;
        b=XNdeC13pb4LjOBaRWcKMBNqFRJ+RgsbfVoNw18z5L+vfkg1SZceZjUxbLhiIy1qySy
         Y4hI02da8j9ev8qt2sUsGeUiOSLlDAUgz5JUplPGm8kAk4jLtNdmDFZCCStM1EGIelNU
         pjjtL4FSGAVwgisQucoSj4vLVpkgLqzZdzX9wYytiy3sfYNB3aYKj8S/Nug5gaKAa8gA
         /5oDb+KCNmSa3bC/jNyCQmeij+quPN3cyVSSr1ovXCPVJxrqYAAydTsm3Q4bRt6yNhxm
         6FVSyKTuVZN23UWZkdV6Uc7djgZpboRwjQPImKvKrchYImM3eB6pVBMtJk1jJ8Nfk6ob
         kIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3UicMHRBXNKZ6klzBYtNlGfdpT3ipHtBcp9O7LuoFbE=;
        b=1G3fsbH1GhvXaz8hz+nfg/tLNJJaZ815+rp6TvhxvB/X1GJ+PERZPlTTMIVfW/lIqB
         iyv5ylmcGFRiSsO0El2+ZlAy7zW+hcfRdeEa4Inh5KOGkYubRMHAETYYfDZIXseuCqyI
         2QvxsNTf0H4NKBHc5T+uJVEcm/6B4V2RfwAVZPjZ8PhbrOty1C+Tl8pzxsYR36y1iqzC
         gmptWbuvUD6izYZlm928sujy+NBkzXTTm8HkYcEHTtN/BqAqAeRiiQ1EAcAT8YIyTWmS
         J0tn0QcIm8fCdO5aUbLNgyfo16ltTs+XllmRRiq+PHWwk7UFVk40SLtXb535KF0yKOMr
         svWQ==
X-Gm-Message-State: ACrzQf1P0OLvROBsPsuARzXo2bRS+B/s0gBI1lbfANMMjQaCEdvaIrMT
	T4FmYvbULMW4RYr6TxWvWWg=
X-Google-Smtp-Source: AMsMyM6Ssf7qu6Zt1cmqzeY+6ksfJF4jyx1t2euaZBhwzvq5JPVY+8zsaODdG48vWXQYQDWTdtSyvw==
X-Received: by 2002:a17:90b:4a04:b0:213:587b:204e with SMTP id kk4-20020a17090b4a0400b00213587b204emr55088612pjb.98.1667886235549;
        Mon, 07 Nov 2022 21:43:55 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id k21-20020a628415000000b0056bb06ce1cfsm5614872pfd.97.2022.11.07.21.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 21:43:55 -0800 (PST)
Date: Mon, 7 Nov 2022 21:43:54 -0800
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Christopherson,, Sean" <seanjc@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Yao, Yuan" <yuan.yao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"david@redhat.com" <david@redhat.com>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"farosas@linux.ibm.com" <farosas@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"anup@brainfault.org" <anup@brainfault.org>,
	"frankja@linux.ibm.com" <frankja@linux.ibm.com>,
	"farman@linux.ibm.com" <farman@linux.ibm.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"atishp@atishpatra.org" <atishp@atishpatra.org>,
	"imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
	"Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
Message-ID: <20221108054354.GA1708572@ls.amr.corp.intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221104071749.GC1063309@ls.amr.corp.intel.com>
 <Y2V1oslbw24/2Opd@google.com>
 <20221107214634.GE1063309@ls.amr.corp.intel.com>
 <bf29fe1ac84cae8ddb06e566b56c653600a1901c.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bf29fe1ac84cae8ddb06e566b56c653600a1901c.camel@intel.com>
Message-ID: <20221108054354.rrjjOuSezHxNS6jyt3LdkV0L1V_D2fYlNz2nE-vJhTw@z>

On Tue, Nov 08, 2022 at 01:09:27AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Mon, 2022-11-07 at 13:46 -0800, Isaku Yamahata wrote:
> > > On Fri, Nov 04, 2022, Isaku Yamahata wrote:
> > > > Thanks for the patch series. I the rebased TDX KVM patch series and it
> > > > worked.
> > > > Since cpu offline needs to be rejected in some cases(To keep at least one
> > > > cpu
> > > > on a package), arch hook for cpu offline is needed.
> > > 
> > > I hate to bring this up because I doubt there's a real use case for SUSPEND
> > > with
> > > TDX, but the CPU offline path isn't just for true offlining of CPUs.  When
> > > the
> > > system enters SUSPEND, only the initiating CPU goes through
> > > kvm_suspend()+kvm_resume(),
> > > all responding CPUs go through CPU offline+online.  I.e. disallowing all
> > > CPUs from
> > > going "offline" will prevent suspending the system.
> > 
> > The current TDX KVM implementation disallows CPU package from offline only
> > when
> > TDs are running.  If no TD is running, CPU offline is allowed.  So before
> > SUSPEND, TDs need to be killed via systemd or something.  After killing TDs,
> > the
> > system can enter into SUSPEND state.
> 
> This seems not correct.  You need one cpu for each to be online in order to
> create TD as well, as TDH.MNG.KEY.CONFIG needs to be called on all packages,
> correct?

That's correct. In such case, the creation of TD fails.  TD creation checks if
at least one cpu is online on all CPU packages.  If no, error.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
