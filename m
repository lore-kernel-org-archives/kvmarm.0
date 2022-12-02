Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252664C71
	for <kvmarm@lists.linux.dev>; Fri,  2 Dec 2022 16:08:09 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id 136so4746151pga.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Dec 2022 08:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LMdFvNSIKdTJxppFI5JflU3ZXHxkZjSJ4fG5U4tk7Tk=;
        b=kw0qyCOMp2u+ojev0wrASw/lF7r9rOnRJHqLy08FIIr+f+qpPtSFohe59bJmaOi/rJ
         xcGzBwmHctfDCuY/HsZstsw01nTTKqB9D0ItsIVCZBuDkF6U4LFd8/XxyiMZ9HQQBawu
         5Br6kbHRMEkmhVdkrdlpAnXBg7aXr8x1ngEkT987D0vDq9wJ1LYSA7pyGWl0PB6S36YX
         Ye0BXjX/JFQwCFB0idj1kNjBh1WOFf2yIueArh18nn+f3Kk6RhG95XRHvHGlIJTCnyAw
         T+Hf0HOA9lpO63L3167YfTmLHua9wbiTHz1XwCqkS0us3SdkuoK9a/bX1aNd1tZdIG9m
         GSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LMdFvNSIKdTJxppFI5JflU3ZXHxkZjSJ4fG5U4tk7Tk=;
        b=DRoJfAPgCidX51mthuM6QrbI8EU9gbqqoOsCTdOE6L+Wtm6dKMh0SZW05HJ1oApmV2
         JNvze/rKBFHMav25ZxZjYQ/J6T3GRgakPzn11HfdLZE1/FOE+KenIv1ZpSpymKMfsS8A
         iMP9CrDr8zVzFnh4oTH3jJ3O2upadGSWDipOxrACdp/Z8wcIt364XE/jYzIZcDg0dZIL
         WFTs2sx4ybyB1AzPKABQN5cNxE/3m/XUHTvzItQYVnCy+OpaE4gsx9uAZnE3sLDd+a+G
         z1FpUOlWsn8ItT73bWmZki4BdArejsqXavGBcTTQGPWF0YASqZFVC86QmmsAjuzsf0hd
         qYtQ==
X-Gm-Message-State: ANoB5pm2ok7FhfdCf9ad8qx4yhMHNGiS7sFn+jQnajN3OZ8ZwUn15mcF
	hQTF4Vj4RMGYmij2sle1Cj8PiQ==
X-Google-Smtp-Source: AA0mqf5a5KU+HXt1yCJ0zhlFtswkW2r0VasQIXpEBIwwE2hKQw/T3gXBywz5nj+1M/Ux52wSBF1P1g==
X-Received: by 2002:a63:495e:0:b0:470:75a1:c6d7 with SMTP id y30-20020a63495e000000b0047075a1c6d7mr47336241pgk.120.1669997286584;
        Fri, 02 Dec 2022 08:08:06 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w23-20020a1709026f1700b00189667acf19sm5714233plk.95.2022.12.02.08.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 08:08:06 -0800 (PST)
Date: Fri, 2 Dec 2022 16:08:02 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"frankja@linux.ibm.com" <frankja@linux.ibm.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"farman@linux.ibm.com" <farman@linux.ibm.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dwmw2@infradead.org" <dwmw2@infradead.org>,
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
	"imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
	"paul@xen.org" <paul@xen.org>,
	"mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"anup@brainfault.org" <anup@brainfault.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"cohuck@redhat.com" <cohuck@redhat.com>,
	"farosas@linux.ibm.com" <farosas@linux.ibm.com>,
	"david@redhat.com" <david@redhat.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"Yao, Yuan" <yuan.yao@intel.com>,
	"alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
	"philmd@linaro.org" <philmd@linaro.org>,
	"atishp@atishpatra.org" <atishp@atishpatra.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v2 41/50] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <Y4oi4oRk7jsCqYJO@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-42-seanjc@google.com>
 <c74c88ba6a17da2d36e2d340ce22af127bda8383.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c74c88ba6a17da2d36e2d340ce22af127bda8383.camel@intel.com>
Message-ID: <20221202160802.SL3eP-sBCB12zkcks9DmChdRbsDqMx43jFnjBbU1KY4@z>

On Fri, Dec 02, 2022, Huang, Kai wrote:
> On Wed, 2022-11-30 at 23:09 +0000, Sean Christopherson wrote:
> > From: Chao Gao <chao.gao@intel.com>
> > 
> ...
> 
> > 
> > Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Perhaps I am wrong, but I have memory that if someone has SoB but isn't the
> original author should also have a Co-developed-by?

This is the case where a patched is passed along as-is, e.g. same as when
maintainers apply a patch.  Isaku posted Chao's patch, and then I came along and
grabbed the patch that Isaku posted.  I could go back and grab Chao's patch
directly, but Yuan's review was provided for the version Isaku posted, so I
grabbed that version.

> > Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> > [sean: drop WARN that IRQs are disabled]
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
