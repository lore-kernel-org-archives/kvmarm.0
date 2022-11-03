Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1011163A0
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 17:44:56 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id gw22so2354458pjb.3
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 10:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cK19xZ8r/JxZ6zrZk59CGRO4XALiFfw/k+DEo690ifc=;
        b=AMXkMgBJe864E9ylH4eLhcV4DnnmpnUZQciwStcW/fWfVy8vl8xbyLHXqWoh/4n8QF
         bRAhsfNtOcglKLMhK6Nb/v5AF7HvdYNYuPv80cwXOHPX5E9n4f4rIwmSH2XAdpFIqhuj
         sSsx/7sAKHM3fmeDS7xyNpoxOPMcbkwOVVWM5XBPQcjHKuBxYoH5JxFh6oDyEgClSLr4
         VePL27iqi0rk5/s+JivkXFUi7OtMXJLNacJQMnJ3M4obYSjfplMj8jxI5D4RNhWTNCit
         VmDRgbq4Pt+ph415Zp0hH77zR2JN9eVpsj1xI6CTZrVgir1QKlQnpGg6QTPI6wKdJ0ls
         3hyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cK19xZ8r/JxZ6zrZk59CGRO4XALiFfw/k+DEo690ifc=;
        b=5co6LCXtkPVpW38nrOfE9R7FEK5MwUEfsHvYp6QXvFdicBsv2UieH/HEWZCA1sKq9l
         VET9WTMNS5eeil8HuXGUY2qtMl6hdTNOtkmpT2Tbr1Ltk7GLOpZfl4vX5ZzHTHX9X2cu
         YCkx5S7dVSK07vs4oBdTpmyJk5eVf6yb2bQV80EEV96YWx9mPgrA2FB0n0ETSfYN6GAi
         ms5RfRbUlSd/Q4jHPdJAR+jT3n8E40Mtq3y6LBd/mT8PFIWq7IG2a8VNibbHXIo5rt/l
         EDjn+0AW2XZZ/aq42hy6lT6HTtxjucKGfT/+1bFhwRq01ELRJ2D+rv57+FecmxVKQwTE
         wH6w==
X-Gm-Message-State: ACrzQf1JwEsYbv8ctY1FHpBPnXK2yyUUPnSSJhyYf4S3/SNzG3RZtYrt
	nNGa1BWik3RZdqUAgE09O90u8g==
X-Google-Smtp-Source: AMsMyM7Vi7ErqJmqrzHt1bwsO7Jfw+kVc4w4lCdxf/cK5b8KZHYV39XlOvASF4Eye8GSeC7ZJ2rbFQ==
X-Received: by 2002:a17:90a:d24d:b0:213:d3e4:677a with SMTP id o13-20020a17090ad24d00b00213d3e4677amr24629292pjw.101.1667497496277;
        Thu, 03 Nov 2022 10:44:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090332c700b00178aaf6247bsm1004862plr.21.2022.11.03.10.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 10:44:55 -0700 (PDT)
Date: Thu, 3 Nov 2022 17:44:51 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
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
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <Y2P+E+631c0TNcK7@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <23bfd709-f99a-5a74-e4b9-1381b88453f1@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23bfd709-f99a-5a74-e4b9-1381b88453f1@redhat.com>
Message-ID: <20221103174451.u4ThMi2c3sxKft3XqN4SrD-WqjRnQl68hvu4aXOyWxU@z>

On Thu, Nov 03, 2022, Paolo Bonzini wrote:
> On 11/3/22 00:19, Sean Christopherson wrote:
> > From: Chao Gao<chao.gao@intel.com>
> > 
> > Do compatibility checks when enabling hardware to effectively add
> > compatibility checks when onlining a CPU.  Abort enabling, i.e. the
> > online process, if the (hotplugged) CPU is incompatible with the known
> > good setup.
> 
> This paragraph is not true with this patch being before "KVM: Rename and
> move CPUHP_AP_KVM_STARTING to ONLINE section".

Argh, good eyes.  Getting the ordering correct in this series has been quite the
struggle.  Assuming there are no subtle dependencies between x86 and common KVM,
the ordering should be something like this:

  KVM: Opt out of generic hardware enabling on s390 and PPC
  KVM: Register syscore (suspend/resume) ops early in kvm_init()
  KVM: x86: Do compatibility checks when onlining CPU
  KVM: SVM: Check for SVM support in CPU compatibility checks
  KVM: VMX: Shuffle support checks and hardware enabling code around
  KVM: x86: Do VMX/SVM support checks directly in vendor code
  KVM: x86: Unify pr_fmt to use module name for all KVM modules
  KVM: x86: Use KBUILD_MODNAME to specify vendor module name
  KVM: Make hardware_enable_failed a local variable in the "enable all" path
  KVM: Use a per-CPU variable to track which CPUs have enabled virtualization
  KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
  KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock
  KVM: Disable CPU hotplug during hardware enabling
  KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
  KVM: Drop kvm_arch_check_processor_compat() hook
