Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82443C4321E
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 17:45:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F05044B133;
	Thu,  3 Nov 2022 13:45:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bFXhafjYdVb8; Thu,  3 Nov 2022 13:44:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1AE04B274;
	Thu,  3 Nov 2022 13:44:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 929BA4B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 13:44:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qasc0ehMxVvK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 13:44:57 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 728C149F49
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 13:44:57 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 v4-20020a17090a088400b00212cb0ed97eso2485484pjc.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 10:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=8AGL/PsJDqmkBbWJctJQ5bgh7/DFqzRw/vHpBouVq+OayKYyWsnx2x/E4gWYGvu5NM
 VuleSbHhj+fv3XwNnuDq8nbjPxCNQGn4AoOXij3M9O4mZEsGWuQ8iSybKM7yZapSIXeA
 76Fu0VY3ns/qHr2UjTxcsBnCZm2BmR+A5/gm5eE06RLsObXReQYOudL2pNJ9unT28TCh
 iRyI7UkHVCrqItIgrmsEWwUJqB3QiEv+87a0whoMjnEU3sk7+apmlBQhwuO91scVozkM
 01qHrmXxs8qsmujn5ahzULySkZlu6fToBasMR/WH927YF5K7fwFfGT6YrARhD1eqkcY3
 +t/g==
X-Gm-Message-State: ACrzQf3WoAi7z+rYzwBaP5b2uE1TQgwH1mKAv9tlQvZj+StlZV9ZjMU4
 4WdgRCibC2gcUVL4TuzIJ04MGQ==
X-Google-Smtp-Source: AMsMyM7Vi7ErqJmqrzHt1bwsO7Jfw+kVc4w4lCdxf/cK5b8KZHYV39XlOvASF4Eye8GSeC7ZJ2rbFQ==
X-Received: by 2002:a17:90a:d24d:b0:213:d3e4:677a with SMTP id
 o13-20020a17090ad24d00b00213d3e4677amr24629292pjw.101.1667497496277; 
 Thu, 03 Nov 2022 10:44:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 i7-20020a17090332c700b00178aaf6247bsm1004862plr.21.2022.11.03.10.44.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 10:44:55 -0700 (PDT)
Date: Thu, 3 Nov 2022 17:44:51 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <Y2P+E+631c0TNcK7@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <23bfd709-f99a-5a74-e4b9-1381b88453f1@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <23bfd709-f99a-5a74-e4b9-1381b88453f1@redhat.com>
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
