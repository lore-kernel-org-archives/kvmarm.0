Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACA529A8
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 18:58:21 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id d10so2476254pfh.6
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 11:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OgBlWniGTXEnPcASGuNFCxIZuwOSNaqHJ+Eb2HtkZ3A=;
        b=crtTNSDLBpNcvDSxofCENmrvtDvGgpUzGCkxI3/S4zR915QtnPiMfGmQ1bfa1+IphI
         JYKHG76keqoKUqskuvBrM1m0JyELxmvNXlZ4KiPUOKMYgaWfFysvap9RGXI963+2hoeq
         HHT/GX+S1XBR2PYehjOUxetwVpL78GGV9aYozWyKXyCWQQP6iGe8zgNPOME2bv1qjA9e
         apMslXORbm1rWkX1K/6OQ1RCG98VSwtHOf2J04nfLy9jITyFIIcn6ieZ9TY4AUm1gsGc
         eyQU7zbjJP0kGKm2zN/8wgEWv2C3dUA3cPXDwDYFGn1wLuJmRxozNVKQFEnfavfSL6Lx
         ZqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OgBlWniGTXEnPcASGuNFCxIZuwOSNaqHJ+Eb2HtkZ3A=;
        b=L8KW0qEvh5iqF3jGTzM3CYm955pIWFjkeDZlS6EwV3dcWxagwQvbDojYM7NqJ0iZiu
         EcFFpX2kyYMZD+IHYZzx3ajI/eksIdFWytT5Y1KHv1S81uMi7gIsfuhV8gkcQtAbKv3B
         Wg/67ZWs7qgtDHP8ruSwBay9LBfbAhqqaLlz1Aqv/UST/1ND5e2ctA1nj1/edQz8o7JN
         hPH3dr4MTH6ckCz/zyKoGWR6ZJhKamzSHchxNLnq3Xx2LXSBcKbnMRK0Bt5JNM96JlFg
         TyU/WA+KGHhcVRpqnvxJ1RKYAYV5Rw5Sc4Uk0T0Yw6VVHnHRfSN91QVn7/nv4TgOsBhm
         lQAA==
X-Gm-Message-State: ACrzQf25pZp0ZFOmPTXMAhxp5+N1VZeaXMzsx/1GXCwIOWswwd3zEHGI
	sCGdqSdyNiTQTjpZxlRStcMdHQ==
X-Google-Smtp-Source: AMsMyM7lUXjnrFRO+e+xTY8enXMXmh/YC+M/IqwbxJRPxqwsuhxb3fUJPK1b1MpOBO3HsUEvz+aKuA==
X-Received: by 2002:aa7:81cf:0:b0:561:7d72:73ef with SMTP id c15-20020aa781cf000000b005617d7273efmr31655060pfn.16.1667501900762;
        Thu, 03 Nov 2022 11:58:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c20-20020a17090ad91400b00209a12b3879sm309308pjv.37.2022.11.03.11.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 11:58:20 -0700 (PDT)
Date: Thu, 3 Nov 2022 18:58:16 +0000
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
Subject: Re: [PATCH 33/44] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
Message-ID: <Y2QPSK1/6esl61wQ@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-34-seanjc@google.com>
 <bfa98587-3b36-3834-a4b9-585a0e0aa56a@redhat.com>
 <Y2QJ2TuyZImbFFvi@google.com>
 <c29e7d40-ddb9-def0-f944-a921a05a4bb2@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c29e7d40-ddb9-def0-f944-a921a05a4bb2@redhat.com>
Message-ID: <20221103185816.jyaXFqSuLMNK7XOiKEuLhQnnvMQHltKDqZMg9UHG7oU@z>

On Thu, Nov 03, 2022, Paolo Bonzini wrote:
> On 11/3/22 19:35, Sean Christopherson wrote:
> > It's technically required.  IA32_FEAT_CTL and thus KVM_INTEL depends on any of
> > CPU_SUP_{INTEL,CENATUR,ZHAOXIN}, but init_ia32_feat_ctl() is invoked if and only
> > if the actual CPU type matches one of the aforementioned CPU_SUP_*.
> > 
> > E.g. running a kernel built with
> > 
> >    CONFIG_CPU_SUP_INTEL=y
> >    CONFIG_CPU_SUP_AMD=y
> >    # CONFIG_CPU_SUP_HYGON is not set
> >    # CONFIG_CPU_SUP_CENTAUR is not set
> >    # CONFIG_CPU_SUP_ZHAOXIN is not set
> > 
> > on a Cenatur or Zhaoxin CPU will leave X86_FEATURE_VMX set but not set
> > X86_FEATURE_MSR_IA32_FEAT_CTL.  If VMX isn't enabled in MSR_IA32_FEAT_CTL, KVM
> > will get unexpected #UDs when trying to enable VMX.
> 
> Oh, I see.  Perhaps X86_FEATURE_VMX and X86_FEATURE_SGX should be moved to
> one of the software words instead of using cpuid.  Nothing that you should
> care about for this series though.

Or maybe something like this?

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3e508f239098..ebe617ab0b37 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -191,6 +191,8 @@ static void default_init(struct cpuinfo_x86 *c)
                        strcpy(c->x86_model_id, "386");
        }
 #endif
+
+       clear_cpu_cap(c, X86_FEATURE_MSR_IA32_FEAT_CTL);
 }
 
 static const struct cpu_dev default_cpu = {
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index c881bcafba7d..3a7ae67f5a5e 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -72,6 +72,8 @@ static const struct cpuid_dep cpuid_deps[] = {
        { X86_FEATURE_AVX512_FP16,              X86_FEATURE_AVX512BW  },
        { X86_FEATURE_ENQCMD,                   X86_FEATURE_XSAVES    },
        { X86_FEATURE_PER_THREAD_MBA,           X86_FEATURE_MBA       },
+       { X86_FEATURE_VMX,                      X86_FEATURE_MSR_IA32_FEAT_CTL         },
+       { X86_FEATURE_SGX,                      X86_FEATURE_MSR_IA32_FEAT_CTL         },
        { X86_FEATURE_SGX_LC,                   X86_FEATURE_SGX       },
        { X86_FEATURE_SGX1,                     X86_FEATURE_SGX       },
        { X86_FEATURE_SGX2,                     X86_FEATURE_SGX1      },

