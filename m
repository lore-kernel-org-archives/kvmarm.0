Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B084632
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 22:34:14 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id g24so3288371plq.3
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 15:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ldFAJy69ux+7z8nNCEANq8kYxugZwXEN2GoxlipQK+E=;
        b=mkCIQ7bnuqf5rnZcP6hp5JREtMJ78/S1f1OWtkJaTeRse5OVZRNDMID1AYpz+jBJzg
         eTpW9c3Fpt1GJSjywJBWRecDimPLsqOLfN7Nt46XLz4VoW6wiMtnGP3QRSBmWb2Jy2Ue
         XIrU3j6Zv6WjRE+wBsl7MInjLBoh0ETGKk290BPhyym2xqAHPTTSp2piVfBSnA5Xqpa6
         3LkVfTkbpSA7y+3xQukW44oEvhoV3ll0HshYQg8WmMixLpenp+usLAkNlELtK9JmVVTO
         f4CyPp1jxX+2aW0ZdvzjRbMLb0KbcueA1rrAX1kSu3aGK0UrE4ad6SuEvUCcApyckgBR
         ztmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ldFAJy69ux+7z8nNCEANq8kYxugZwXEN2GoxlipQK+E=;
        b=Fdo6vza1BXuEJO4qb15pcwEWRvSsYmpuFmR5TECHraEQfZdAt2TjFbGswrQEtUrF27
         a1DOHByc6AlYX0S5eNyXMKZItPLt+kZOuJVGA+/sQcPTqTm0KqtmJ+sqBxq7efmbtSln
         6IliKIYC6F/jNjUKWiNTHdH0KREOpocngjTWOekXp3v1xV0Qf2GY25GCosV/sxaltcqm
         268NTrdWFzvcBmj4xvckhBO7gHhiFI9EDA+3veH9XfF02eC30C01aRp3xEnD9Zickimm
         bWv6Ubk4+2OH6H/BJoKs+MUvkf9c3n4op6RwtlS+UMen5vZsOpImMXdeAOs8XZdpYrRo
         7+4Q==
X-Gm-Message-State: ACrzQf2E0CC9wO8v5jd2gS9G78Tgsuc228hqtMixDjc77Hri8kmQ8+tY
	d3yV4tQVMx+DQa2X2mhxF1z/Lg==
X-Google-Smtp-Source: AMsMyM4x/1h/4H3vdmKr9CnvGb6Osipgsi8YDrhqpMcYmjYNzerzqYc2UHi5AhKhfTxXN1DVaborYg==
X-Received: by 2002:a17:90a:6045:b0:212:fe9a:5792 with SMTP id h5-20020a17090a604500b00212fe9a5792mr49415367pjm.178.1667514854306;
        Thu, 03 Nov 2022 15:34:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902e80a00b00186ad73e2d5sm1151929plg.208.2022.11.03.15.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 15:34:13 -0700 (PDT)
Date: Thu, 3 Nov 2022 22:34:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <Y2RB4qT02EkhMjPL@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <20221103210402.GB1063309@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103210402.GB1063309@ls.amr.corp.intel.com>
Message-ID: <20221103223410.iLlu7MZn7FQY54uVCitSUMSKAm69nmgN9csIL4SfqXE@z>

On Thu, Nov 03, 2022, Isaku Yamahata wrote:
> On Wed, Nov 02, 2022 at 11:19:03PM +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f223c845ed6e..c99222b71fcc 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1666,7 +1666,7 @@ struct kvm_x86_nested_ops {
> >  };
> >  
> >  struct kvm_x86_init_ops {
> > -	int (*check_processor_compatibility)(void);
> > +	int (*check_processor_compatibility)(int cpu);
> 
> Is this cpu argument used only for error message to include cpu number
> with avoiding repeating raw_smp_processor_id() in pr_err()?

Yep.

> The actual check is done on the current executing cpu.
> 
> If cpu != raw_smp_processor_id(), cpu is wrong. Although the function is called
> in non-preemptive context, it's a bit confusing. So voting to remove it and
> to use.

What if I rename the param is this_cpu?  I 100% agree the argument is confusing
as-is, but forcing all the helpers to manually grab the cpu is quite annoying.
