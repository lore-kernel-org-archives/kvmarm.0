Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1004E3FDD
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 15:16:19 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso2258212pjc.2
        for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 07:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Geqy1MGLbG4CNNhTg6ig5gMw4IRIu2ApDkqg8kUu6fE=;
        b=im3ECY8irru0d2J3PmRkK1oS6XMYGDmkKrSKiLpQr6kggh65U519LacoANhp99/wDs
         yHeOZt/b6IK2ihlol7f0Ba2me3bs0cr3TxYhTcQThAifpYqs8dB3p/8NK2dEXBDay90O
         bW6pXrP7B14I1MNWa+NfggtZKbyTz1rnHhMsVYBCQiIPWqcakktYyuja6CoTLxQtkpfs
         JsqTKBMeEN72FgBWe/ihbCXP9h1x9TEb9ulziUgPn3ZIyNK23YQtGzg65j8/As9Xyk7K
         3+HVs34s1miAiKC8ZfgoVMv73WwF3DJWJcQDYskZpYkejUuTFt6cPMAw/xSDBCQyvpM1
         B6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Geqy1MGLbG4CNNhTg6ig5gMw4IRIu2ApDkqg8kUu6fE=;
        b=OGOOGd6OXEJ+9gy11vKfxedlcO3CRhqXCg/4/8+TGLH4A1CFb5n2xT0T/Y0CSQ7G+c
         p0TXlgqGY+XlkLM4kPwsRxN8Y0N7zr473kBOyUEr8h2k4fliRpJnty4C8keVIkkFE3hA
         sVgXdvE0KkNGfPGp8GtmOc/ZYT58ZT30VwGKFLN2WAvwH2UYbDOWgwxgaef/OwvNQ5Up
         VeWsWg5w6XdwLU9AMF6DaMq2Ooo83u2+ec+XqgGQcID1NdQ8Kr3bhOafSGEURCZWSUvL
         ZHJc7dv1MKq2TXxRbzA8/topj1Z2Tor5b9svaj/xIlFD6IgHieg3hIq9nGlfna4/8/Sl
         JCSA==
X-Gm-Message-State: ANoB5pn3fWnab9Y5ESj4Lhk5sLAeiFff0IhVlTNIYsE+D1vQo4F4/Uzx
	edzk0lx31+1w6LHFTLmv4xeiEg==
X-Google-Smtp-Source: AA0mqf5Drbj5GGUy8zNXmPljMG8UuEFTPTHf+YuwVXyWlSocFeljs1OjIQ+Ab7mWXZMNXetmsxdGbQ==
X-Received: by 2002:a17:90a:6b84:b0:20a:cbb0:3c9b with SMTP id w4-20020a17090a6b8400b0020acbb03c9bmr3280802pjj.81.1668698179289;
        Thu, 17 Nov 2022 07:16:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r12-20020a63e50c000000b00476dc914262sm1135777pgh.1.2022.11.17.07.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:16:18 -0800 (PST)
Date: Thu, 17 Nov 2022 15:16:15 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"Yao, Yuan" <yuan.yao@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
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
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"anup@brainfault.org" <anup@brainfault.org>,
	"frankja@linux.ibm.com" <frankja@linux.ibm.com>,
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
	"farman@linux.ibm.com" <farman@linux.ibm.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"atishp@atishpatra.org" <atishp@atishpatra.org>,
	"imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
	"Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH 38/44] KVM: Disable CPU hotplug during hardware enabling
Message-ID: <Y3ZQP3C1f8pk199t@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-39-seanjc@google.com>
 <88e920944de70e7d69a98f74005b49c59b5aaa3b.camel@intel.com>
 <b198fe971cecd301f0c7c66028cfd71dd7ba7e62.camel@intel.com>
 <Y3PzhANShVlTXVg1@google.com>
 <95ca433349eca601bdd2b16d70f59ba8e56d8e3f.camel@intel.com>
 <Y3UZtoIidMyE8qVz@google.com>
 <7fb66c497b6c41049167b05c63267cbc301b1c20.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fb66c497b6c41049167b05c63267cbc301b1c20.camel@intel.com>
Message-ID: <20221117151615.2GZxnpuI21lb-1WbWdzYVvalE6dObjvnfWBz0dwrNGw@z>

On Thu, Nov 17, 2022, Huang, Kai wrote:
> On Wed, 2022-11-16 at 17:11 +0000, Sean Christopherson wrote:
> > static int kvm_x86_check_processor_compatibility(void)
> > {
> >         int cpu = smp_processor_id();
> >         struct cpuinfo_x86 *c = &cpu_data(cpu);
> > 
> >         /*
> >          * Compatibility checks are done when loading KVM and when enabling
> >          * hardware, e.g. during CPU hotplug, to ensure all online CPUs are
> >          * compatible, i.e. KVM should never perform a compatibility check on
> >          * an offline CPU.
> >          */
> >         WARN_ON(!cpu_online(cpu));
> 
> Looks good to me.  Perhaps this also can be removed, though.

Hmm, it's a bit superfluous, but I think it could fire if KVM messed up CPU
hotplug again, e.g. if the for_each_online_cpu() => IPI raced with CPU unplug.

> And IMHO the removing of WARN_ON(!irq_disabled()) should be folded to the patch
> "[PATCH 37/44] KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section". 
> Because moving from STARTING section to ONLINE section changes the IRQ status
> when the compatibility check is called.

Yep, that's what I have coded up, just smushed it all together here.
